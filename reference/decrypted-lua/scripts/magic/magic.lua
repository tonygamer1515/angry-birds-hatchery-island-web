--------------
-- AB MAgic --
--------------

topbarURL 		= "http://rovio-magic.appspot.com/menu/notification.html"
localURL 		= "data_iphone/notifications/notification.html"
topbar = nil			-- Webview

topbarReady = false
loggingEnabled = true

----------------------
-- Public functions --
----------------------

function initializeNotification()
	if _G.WebView ~= nil then
		createTopbar()
		log("notification initialized")
	else
		log("WebView is not available on this platform.")
	end
end

function topbarReady()
	return topbarReady
end

function showTopbar()
	log("Showing topbar.")
	-- log(_G.debug.traceback())
	
	if topbar ~= nil then
		topbar:show()
	end
end

function hideTopbar()
	log("Hiding topbar.")
	
	if topbar ~= nil then
		topbar:hide()
	end
end

function notifyTopbar(text, action, icon)
	
	action = action or actions.SHOW_MENU
	icon = icon or ""
	-- log("notifyTopbar action: " .. action .. ", icon: " .. icon)

	if gamelua.g_notificationsEnabled then

		-- notification has to be allowed in the screen
		if (gamelua.subsystemsapi.isMagicNotificationAllowed()) then
			if topbar ~= nil then
				local method = "showMessage('".. text .. "','" .. action .. "','" .. icon .. "')"
				local result = topbar:executeJavaScript(method)
				showTopbar()
			end
		end
	else
		log("notifications disabled, cannot show notification: "..text)
	end
end

-----------------------
-- Private functions --
-----------------------

function createTopbar()
	if topbar == nil then
		log("Creating a topbar.")
		
		local width = (7/12)*gamelua.screenWidth
		local height = (3/16)*gamelua.screenHeight
		
		local x = gamelua.screenWidth - width
		local y = 0
		
		topbar = _G.WebView.new(x, y, height, width)
		
		topbar:setOnPageLoadedCallback(onTopbarPageLoaded)
		-- topbar:loadPage(topbarURL)
		topbar:loadLocalPage(localURL)

		-- hidden by default
		hideTopbar();
	end
end

function onTopbarPageLoaded(view, success, pageTitle)
	if success and pageTitle == "magic-notification" then
		log("Top bar content loaded.")
		
		view:allowCallsFromJavaScript("_G.magicNamespace")
		topbarReady = true

		-- hide by default
		hideTopbar();
	end
end

-------------------------------------------------------------------------
-- magic namespace functions which can be invoked from javascript code --
-------------------------------------------------------------------------

_G.magicNamespace = {}

_G.magicNamespace.showTopbar = function()
	if topbar ~= nil then
		topbar:show()
		log("showTopbar called from JavaScript")
	end
end

_G.magicNamespace.hideTopbar = function()
	if topbar ~= nil then
		topbar:hide()
		log("hideTopbar called from JavaScript")
	end
end

_G.magicNamespace.performMagicAction = function(action)
	action = action or ""
	if action ~= "" then
		--gamelua.gamePaused()
		gamelua.eventManager:notify({id = gamelua.events.EID_PAUSE_CLICKED})
		if gamelua.rovioNews then
			gamelua.rovioNews:executeJavaScript(action.."()")
		end
	end
	log("performMagicAction called from javascript. Action: " .. action)
end

-- UTILS -----------------------------------------------------------------

function log(message)
	if loggingEnabled then
		gamelua.print("[Magic] " .. _G.tostring(message) .. "\n")
	end
end

filename="magic.lua"
