-- UNDER CONSTRUCTION START --

ABSync = {}

ABSync.bootstrapURL = "https://rovio-sdk.appspot.com/public/bootstrap.html"
ABSync.clientID = "angrybirds"
ABSync.scope = "statestorage"
ABSync.context1 = "[my]/[client]/settings"
ABSync.context2 = "[my]/[client]/highscores"

ABSync.isReady = false
ABSync.webView = nil
ABSync.refreshToken = ""	-- must never be nil; if empty means the token is invalid
ABSync.loggingEnabled = true

state1Waiting = nil
state2Waiting = nil

----------------------
-- Public functions --
----------------------

function ABSync.bootstrap(token)
	if ABSync.webView == nil then
		log("Bootstrapping Cloud Services.")
		
		-- TODO: Use saveRefershToken()?
		if token ~= nil then
			ABSync.refreshToken = token
		else
			ABSync.refreshToken = ""
		end
		
		createWebView()		
		loadJavaScriptSDK()
	end
end

function ABSync.login()	-- TODO: Rename
	if ABSync.isReady then
		log("About to show the Register/Profile page.")
		
		ABSync.webView:setOnPageLoadedCallback(onRegisterProfilePageLoaded)
		ABSync.webView:setOnLinkClickedCallback(onRegisterProfilePageLinkClicked)
		
		local command = "Rovio.Profile.show('" .. ABSync.clientID .. "', '" .. ABSync.scope .. "', '" .. ABSync.getRefreshToken() .. "');"
		ABSync.webView:asyncExecuteJavaScript(command)
	else
		log("Attempting to show Register/Profile page while Cloud Services are not ready.")
	end
end

function ABSync.syncStates()
	if ABSync.isReady and ABSync.refreshTokenExists() then
		-- Settings that are synched = state1
		local state1 = gamelua.exportLuaTableAsJSON("settings")
		local hash1 = gamelua.getJSONHash(state1)
		
		-- Settings that have changed since last sync
		local deltaState1 = gamelua.GetJSONDiff("ABIDSettingsServerState", "settings")
		
		-- Highscores = state2
		local state2 = gamelua.exportLuaTableAsJSON("highscores")
		local hash2 = gamelua.getJSONHash(state2)
		
		-- Highscores that have changed since last sync
		local deltaState2 = gamelua.GetJSONDiff("ABIDHighscoresServerState", "highscores")
			
		-- DEBUG START
		log("Saving states:")
		log("(1) Settings diff: " .. deltaState1)
		log("(2) Highscores diff: " .. deltaState2)
		-- DEBUG END

		local command = "csResult = Rovio.Sync.sendState([[\'" .. ABSync.context1 .. "\',\'" .. deltaState1 .. "\'],[\'" .. ABSync.context2 .. "\',\'" .. deltaState2 .. "\']]);"
		command = command .. "csResult = eval('(' + csResult + ')');"
		command = command .. "parameters = '" .. hash1 .. ", " .. hash2 .. ", '" .. " + csResult[0].hash + ', ' + csResult[1].hash;"
		command = command .. "callLuaFunction('processHashes(' + parameters + ')');"
		
		--log(command)
		
		if deltaState1 ~= "{}" then
			state1Waiting = state1
		end
		
		if deltaState2 ~= "{}" then
			state2Waiting = state2
		end
	
		ABSync.webView:asyncExecuteJavaScript(command)
	end
end

function ABSync.getRefreshToken()
	return ABSync.refreshToken
end

function ABSync.refreshTokenExists()
	return ABSync.refreshToken ~= nil and ABSync.refreshToken ~= ""
end

-----------------------
-- Private functions --
-----------------------

function processHashes(hash1, hash2, oldHash1, oldHash2)
	if state1Waiting ~= nil then
		gamelua.ABIDSettingsServerState = {}
		gamelua.importJSONToLuaTable(state1Waiting, "ABIDSettingsServerState")
		state1Waiting = nil
		gamelua.saveLuaFileWrapper("ABIDSettingsServerState.lua", "ABIDSettingsServerState", true)
		
		log("Updating ABIDSettingsServerState")
	end
	
	if state2Waiting ~= nil then
		gamelua.ABIDHighscoresServerState = {}
		gamelua.importJSONToLuaTable(state2Waiting, "ABIDHighscoresServerState")
		state2Waiting = nil
		gamelua.saveLuaFileWrapper("ABIDHighscoresServerState.lua", "ABIDHighscoresServerState", true)
		
		log("Updating ABIDHighscoresServerState")
	end

	if hash1 ~= "" and hash2 ~= "" then
		if oldHash1 == hash1 and oldHash2 == hash2 then
			log("Hashes match, no need to retrieve states.")
		else
			log("Hashes differ (1: " .. oldHash1 .. "/" .. hash1 .. ", 2: " .. oldHash2 .. "/" .. hash2 .. ").")
			
			retrieveStatesFromServer(oldHash1 ~= hash1, oldHash2 ~= hash2)
		end
	else
		log("Error retrieving hashes.")
	end
end

function saveRefreshToken(token)
	if token ~= nil then
		ABSync.refreshToken = token
	else
		ABSync.refreshToken = ""
	end
	
	gamelua.localSettings.ABIDrefreshToken = ABSync.refreshToken
	gamelua.saveLuaFileWrapper("localSettings.lua", "localSettings", true)
end

------------------------------------------------------
-- Functions for creating the Web View              --
-- and handling link clicked and page loaded events --
------------------------------------------------------

function createWebView()
	if ABSync.webView == nil and _G.WebView ~= nil then
		local height = gamelua.screenHeight
		local width = gamelua.screenWidth
		
		ABSync.webView = _G.WebView.new(0, 0, height, width)
	end
end

function loadJavaScriptSDK()
	if ABSync.webView ~= nil then
		ABSync.webView:setOnPageLoadedCallback(javaScriptSDKOnPageLoaded)
		ABSync.webView:loadPage(ABSync.bootstrapURL)
	end
end

function javaScriptSDKOnPageLoaded(view, success, pageTitle)
	if success and pageTitle == "Javascript SDK" then
		log("Cloud Services ready")
		
		view:allowCallsFromJavaScript("_G.namespace")
		
		ABSync.isReady = true	-- TODO: Move this to the completion routine?
		
		-- Show the ABID button (move this code someplace else)
		--local ABIDButton = gamelua.getItemByName(gamelua.mainMenu.items, "ABIDButton")
		--local ABIDButtonText = gamelua.getItemByName(gamelua.mainMenu.items, "ABIDtext")
		--local ABIDButtonSpinner = gamelua.getItemByName(gamelua.mainMenu.items, "ABIDspinner")
		--ABIDButton.visible = true
		--ABIDButtonText.visible = true
		--ABIDButtonSpinner.show = false
		
		-- Validate the refresh token
		local command = "csTemp = Rovio.Identity.refreshAccessToken('".. ABSync.getRefreshToken() .. "');"
		command = command .. "callLuaFunction('setRefreshToken(' + csTemp + ')');"
		command = command .. "csTemp = nil;"
		
		view:asyncExecuteJavaScript(command)
	else
		if pageTitle ~= "Profile" then -- TODO: Fix this
			log("Cloud Services bootstrap failed")
		end
	end	
end

function onRegisterProfilePageLoaded(view, success, pageTitle)
	if success then
		if pageTitle == "Profile" or pageTitle == "Register" then
			log("Showing the " .. pageTitle .. " page.")
			
			--gamelua.getItemByName(gamelua.mainMenu.items, "ABIDspinner").show = false
			
			view:show()
			
			-- Rovio.Identity.getRefreshToken() executes fast so it can be called synchronously
			local newRefreshToken = view:executeJavaScript("Rovio.Identity.getRefreshToken();")

			if newRefreshToken ~= nil and newRefreshToken ~= "" then
				saveRefreshToken(newRefreshToken)
			end
		else
			-- TEMP, dont hide because of FaceBook
			-- view:hide()
			log("Unknown page '" .. pageTitle .. "' loaded.")
		end
	else
		-- TEMP, dont hide because of FaceBook
		-- view:hide()
		log("Failed to load page.")
	end
end

function onRegisterProfilePageLinkClicked(view, url)	
	if url == "http://www.ab.game/close" then
		log("Closing the Register/Profile page.")
				
		view:hide()
		
		-- sync the next time that gamelogic.update() is called
		gamelua.ABIDSubSystem.attemptToSync = true
		
		return _G.WebView.DONT_LOAD_PAGE
	end

	if url == "http://www.ab.game/logout" then
		log("Logging out.")
		
		view:hide()
		
		saveRefreshToken("")
	
		gamelua.ABIDSettingsServerState = {}
		gamelua.saveLuaFileWrapper("ABIDSettingsServerState.lua", "ABIDSettingsServerState", true)
		
		gamelua.ABIDHighscoresServerState = {}
		gamelua.saveLuaFileWrapper("ABIDHighscoresServerState.lua", "ABIDHighscoresServerState", true)
		
		loadJavaScriptSDK()
	end

	return _G.WebView.LOAD_PAGE_INTO_WEBVIEW
end

--------------------------------------------------
-- Functions for getting states from the server --
--------------------------------------------------

function composeRetrieveStatesCommand(getState1, getState2) 
	local command = ""
	
	if getState1 or getState2 then
		-- Get the states from the server
		command = "csResult = eval('(' + Rovio.Sync.getState([[\'"
	
		if getState1 then
			command = command .. ABSync.context1 .. "\']"
			if getState2 then
				command = command .. ",[\'"
			end
		end
	
		if getState2 then
			command = command .. ABSync.context2 .. "\']"
		end
	
		command = command .. "]) + ')');"
		
		-- Pass the result back to Lua (encoded as base 64)
		command = command .. "if (csResult == null) { callLuaFunction(\"mergeStates('', '')\"); }"	-- TODO: need base64 encoding?
		command = command .. "else {"
		
		if getState1 and getState2 then
			command = command .. "parameters = window.btoa(JSON.stringify(csResult[0].state)) + ',' + window.btoa(JSON.stringify(csResult[1].state));"
		elseif getState1 then
			command = command .. "parameters = window.btoa(JSON.stringify(csResult[0].state)) + ',' + window.btoa('{}');"
		else
			command = command .. "parameters = window.btoa('{}') + ',' + window.btoa(JSON.stringify(csResult[0].state));"
		end
		
		command = command .. "callLuaFunction('mergeStates(' + parameters + ')');";
		command = command .. "}"
	end
	
	return command
end

function retrieveStatesFromServer(getState1, getState2)	
	if ABSync.isReady and ABSync.refreshTokenExists() and (getState1 or getState2) then
		--log("About to launch async execution")
	
		local command = composeRetrieveStatesCommand(getState1, getState2)
		ABSync.webView:asyncExecuteJavaScript(command)
		
		--log("Async execution launched");
	end
end

function mergeStates(state1, state2)
	-- TODO: handle error when both states are empty strings
	log("Merging server states to local states:")

	if state1 ~= "" and state1 ~="{}" then
		log("(1) Settings: " .. state1)
		
		gamelua.importJSONToLuaTable(state1, "settings")
		gamelua.importJSONToLuaTable(state1, "ABIDSettingsServerState")
		
		gamelua.saveLuaFileWrapper("settings.lua", "settings", true)
		gamelua.saveLuaFileWrapper("ABIDSettingsServerState.lua", "ABIDSettingsServerState", true)
	end

	if state2 ~= ""  and state2 ~="{}" then
		log("(2) Highscores: " .. state2)
		
		gamelua.importJSONToLuaTable(state2, "highscores")
		gamelua.importJSONToLuaTable(state2, "ABIDHighscoresServerState")

		gamelua.saveLuaFileWrapper("highscores.lua", "highscores", true)
		gamelua.saveLuaFileWrapper("ABIDHighscoresServerState.lua", "ABIDHighscoresServerState", true)
	end
	
	log("Merging done")
end

-- TODO: Change function name/namespace
_G.namespace = {}

_G.namespace.mergeStates = function(state1, state2)
	log("mergeStates called from JavaScript")
	
	local decodedState1 = gamelua.decodeBase64(state1)
	local decodedState2 = gamelua.decodeBase64(state2)

	mergeStates(decodedState1, decodedState2)
end

_G.namespace.processHashes = function(hash1, hash2, oldHash1, oldHash2)
	log("processHashes called from JavaScript")
	
	processHashes(hash1, hash2, oldHash1, oldHash2)
end

_G.namespace.setRefreshToken = function(newRefreshToken)
	log("setRefreshToken called from JavaScript.")
	
	if newRefreshToken == "" or newRefreshToken == nil then
		log("Old refresh token not valid, new token is null.")
		
		saveRefreshToken("")
	else
		if ABSync.getRefreshToken() ~= newRefreshToken then
			log("Refresh Token updated.")
			
			saveRefreshToken(newRefreshToken)
		else
			log("Old Refresh Token is still valid")
		end
					
		-- sync the next time that gamelogic.update() is called
		gamelua.ABIDSubSystem.attemptToSync = true
	end
end

function log(message)
	if ABSync.loggingEnabled then
		gamelua.print("[AB Sync] " .. message .. "\n")
	end
end
-- UNDER CONSTRUCTION END --
filename="ABSync.lua"
