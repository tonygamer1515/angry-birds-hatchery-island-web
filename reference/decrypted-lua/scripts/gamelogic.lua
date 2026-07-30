function loadFiles()
	-- load global options from separate file
	loadLuaFileToObject(scriptPath .. "/options.lua", this, "options")
	loadLuaFileToObject(scriptPath .. "/events.lua", this, "events")

	if showEditor then
	--	_G.assert(false, "editor is borked in trunk/1.7, use generic_1.6.3 branch until it's fixed")
	end
	
	-- loadLuaFileToObject(scriptPath .. "/menus/generic.lua", this, "ui")
	-- WARNING: I change the loadLuaFileToObject on cpp so that if the table name is empty it won't dump the contents of the file into an extra table, just like the loadLuaFile method
	-- that way, we can for example group all UI elements into the same UI table

	loadLuaFileToObject(scriptPath .. "/ui_components/Frame.lua", this, "ui")
	loadLuaFileToObject(scriptPath .. "/ui_components/Text.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/TextButton.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/Image.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/BGBox.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/ImageButton.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/ScallableButton.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/StaticButton.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/ProgressBar.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/ToggleButton.lua", this.ui, "")	
	loadLuaFileToObject(scriptPath .. "/ui_components/GridFrame.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/SliderFrame.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/ui_components/scrollframe.lua", this.ui, "")

	if g_hatcheryEnabled then
		loadLuaFileToObject(scriptPath .. "/ui_components/InvisibleButton.lua", this.ui, "")	
	end

	loadLuaFileToObject(scriptPath .. "/ui_components/MenuManager.lua", this, "MenuManager")

	loadLuaFileToObject(scriptPath .. "/menus/MightyEagleButton.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/menus/Prompt.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/menus/ConfirmPrompt.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/menus/GameHud.lua", this.ui, "")
	loadLuaFileToObject(scriptPath .. "/menus/PausePage.lua", this.ui, "")

	loadLuaFileToObject(scriptPath .. "/menus/shop.lua", this, "shop")
	loadLuaFileToObject(scriptPath .. "/episodes.lua", this, "_")
	loadLuaFile(scriptPath .. "/achievements.lua", "")
	
	loadLuaFileToObject(scriptPath .. "/subsystems/subsystems.lua", this, "subsystems")
	loadLuaFileToObject(scriptPath .. "/EventManager.lua", this.subsystems, "")
	
	loadLuaFileToObject(scriptPath .. "/subsystems/flurry.lua", this.subsystems, "")
	loadLuaFileToObject(scriptPath .. "/subsystems/loader.lua", this.subsystems, "")
	loadLuaFileToObject(scriptPath .. "/subsystems/RovioNews.lua", this.subsystems, "")
	
	loadLuaFile(scriptPath .. "/soundboards.lua", "")
	loadLuaFile(scriptPath .. "/editor.lua", "")
	loadLuaFileToObject(scriptPath .. "/menus/infoFrame.lua", this, "info")
	loadLuaFile(scriptPath .. "/menus/ChallengePage.lua", "")
	loadLuaFile(scriptPath .. "/menus/MEPage.lua", "")
	loadLuaFile(scriptPath .. "/menus/ProcessManager.lua", "")
	loadLuaFile(scriptPath .. "/menus/cutscene.lua", "")
	loadLuaFile(scriptPath .. "/settingsWrapper.lua", "")	
	loadLuaFile(scriptPath .. "/challenges.lua", "")
	loadLuaFile(scriptPath .. "/subsystems/adsSubsystem.lua", "")

	loadLuaFileToObject(scriptPath .. "/magic/magic.lua", this, "magic")
	loadLuaFileToObject(scriptPath .. "/magic/magicactions.lua", this.magic, "actions")

	loadLuaFileToObject(scriptPath .. "/subsystemsapi.lua",this, "subsystemsapi")

	loadLuaFile(scriptPath .. "/cutscenes.lua", "cutscenes")	
	
	if ABIDEnabled then
		loadLuaFileToObject(scriptPath .. "/ABSync.lua", this, "utils")
		loadLuaFileToObject(scriptPath .. "/ABIDUtils.lua", this, "ABIDUtils")	
		loadLuaFileToObject(scriptPath .. "/subsystems/ABIDSubSystem.lua", this.subsystems, "")	
	end
	
	settings.currentMainMenuTheme = "theme1"
end

loadFiles()


-- 
--  

if g_hatcheryEnabled == true then
	g_hatcheryServerTimeSync = {}
	g_hatcheryServerTimeSync["timeToRequest"] = 300
	g_hatcheryServerTimeSync["totalRequestWaitTime"] = 300
	
	
end


g_usingMouse = false

postHighscores = true
subSystemsList = {}
processManager = ProcessManager:new()

useShop = false

--set to true if all sounds are MP3 instead of wavs, affects the filenames,
--using .mp3 instead of .wav as there isn't a proper load list for audio
--g_useMp3Sound = deviceModel == "ipad"
g_useMp3Sound = true

--set to true to stream all sounds
--set to false if all sounds (except music and sounds specifically
--marked as streaming) should be loaded into RAM instead of streamed.
--Always enable when using MP3 sounds; or crap devices (everything that's
--not a PC) won't be able to play audio without lag!
--g_streamSounds = deviceModel ~= "ipad"
g_streamSounds = false

if customerString == "hannspree" or customerString == "nook" or deviceModel == "bada" then
	isSeasonsAvailable = false
end

lockLevelsButtonVisible = false
-- Used when taking screenshots from levels, should be false usually --
hideHud = false
--showEditor = true

releaseSplashes = true
-- Use this to visualize the camera system
showCameraDebugData = false

eagleLockedTime = 3600
iapInitTimeOut = 20

NFCUnlockTime = 3600

-- global flag, that keeps information where eagle was last clicked from
-- used to set eagle bait to slinghot if purhchased from menu, or
-- while logging flurry events. 
g_eagleClickedFrom = nil

g_enableNewMenus = false

g_hatcheryEnableBirdSelector = true

if cheatsEnabled  then
	NFCUnlockTime = 60
end

LP5_PAGE2_LOCKED = false
LP5_PAGE3_LOCKED = false

LP6_PAGE2_LOCKED = false
LP6_PAGE3_LOCKED = false


feedMessages = {}

adRemovalItemId = "com.rovio.angrybirds.removeads"
mightyEagleItemId = "com.clickgamer.angrybirds.mightyeagle2"
if deviceModel == "ipad" then
	mightyEagleItemId = "com.chillingo.angrybirdsipad.mightyeagle"
end

if deviceModel == "iphone" or deviceModel == "ipad" or deviceModel == "iphone4" or deviceModel == "android" then
	webViewIsSupported = true
end

-- All iOS devices here
iOS = false
if deviceModel == "iphone" or deviceModel == "ipad" or deviceModel == "iphone4" then
	iOS = true
end

g_crystalEnabled = iOS
g_allowLowQualityGraphics = deviceModel == "android" and not isHDVersion


if isPremium then
	settingsWrapper:setPremium(true)
end

if releaseBuild then
	showEditor = false
	postHighscores = true
	_G.assert = function() end
end

tapRadius = 15 * screenWidth/480

--display gamecenter stuff on screen even when it's not enabled
--toggle in runtime by pressing G and C at the same time
--also requires releasebuild set to false
debugShowGameCenter = false


-- Different subsystems of game
eventManager = nil
achievementProcessor = nil
--[[
	episode = self.episode,
	page = i,
	level = j,
	levelName = levelName,
	data = data,
]]

notificationsFrame = ui.Frame:new()

function notificationsFrame:eventTriggered(event)
	if event.id == events.EID_SHOW_LOADING_PAGE then
		self:getChild("loading").visible = true
	elseif event.id == events.EID_HIDE_LOADING_PAGE then
		self:getChild("loading").visible = false
	elseif event.id == events.EID_LEVEL_LOADING_INIT then
		self:getChild("loading").visible = true	
	elseif event.id == events.EID_LEVEL_LOADING_DONE then
		self:getChild("loading").visible = false	
	end
	
	if event.id == events.EID_PROCESS_FINISHED then
		local allChildren = {}
		
		-- remove item of finished process from notifications frame.
		if event.target ~= nil then		
			self:removeChild(event.target.item)
		end		
	end	
end

--remove facebook levels
if applyChinaRestictions then
	g_episodes[5].pages[4] = nil
end

g_currentChallenge = nil


function isChallengeMode()
	return g_currentChallenge ~= nil
end

-------
------- Starts next gameplay - type challenge
-------	
function startNextGameplayChallenge(challenge, progress)
	
	progress.levelIndex = progress.levelIndex + 1
	

	setEditing(false)
	setPhysicsEnabled(false)
	local previous_level_count = 0
	
	
	levelName = challenge.levels[progress.levelIndex].name
	local levelData,episode,page,levelNumber = getLevelById(levelName)
	
	for i = 1, page - 1 do
		previous_level_count = previous_level_count + #g_episodes[episode].pages[page].levels
	end
	
	currentLevelNumber = previous_level_count + levelNumber
	currentLevelNumberInTheme = getLevelNumber(challenge.levelName)
	currentThemeNumber = episode
	currentWorldNumber = g_episodes[episode].pages[page].world_number
	currentPageNumber = page
	
	levelFolder = "levels/" .. g_episodes[episode].pages[page].folder_name .. "/"	
	
	numberOfAttemptsInLevel = 1
	
	-- TODO: Some flurry events?
	eventManager:notify({id = events.EID_LEVEL_LOADING_INIT})
	
end


function prepareChallengeQueue(challenge)	
	print("Starting Challenge : id = "..challenge.id.." type = "..challenge.type.." name = "..challenge.name.." reward = "..challenge.reward.."\n")
	
	if challenge.type == "BIRD_FLOCK" then
		g_currentChallenge = challenge
		
		g_currentChallengeProgress = {}
		g_currentChallengeProgress.levelIndex = 0
		g_currentChallengeProgress.shotsQueue = {}

		-- Create shots queue to progress
		-- The contents of shots queue in currentChallengeProgress is something like:
		----------------------------------------------------------------------------
		-- g_currentChallengeProgress = 
		--	{
		--   shotsQueue = {
		--       RED,
		--       RED,
		--       RED,
		--		 BLUE,	
		--		 BLUE,	
		--       RED,
		--
		--		}
		--	}
		-----------------------------------------------------------------------------
		
		
		for i,v in _G.ipairs(g_currentChallenge.shotsQueue) do			
			for k,l in _G.pairs(g_currentChallenge.shotsQueue[i]) do				
				for amount = 1, l do
					_G.table.insert(g_currentChallengeProgress.shotsQueue,k)
				end
			end
		end		
		eventManager:notify({id = events.EID_START_NEXT_CHALLENGE_LEVEL, challenge = g_currentChallenge, progress = g_currentChallengeProgress})
	end	
end 

function getLevelNumber(levelName)
	for i = 1, #g_episodes do
		for j = 1, #g_episodes[i].pages do
			for k = 1, #g_episodes[i].pages[j].levels do
				if g_episodes[i].pages[j].levels[k].name == levelName then return k end
			end						
		end
	end
	return 0
end

function getLevelIndexInEpisode(level)
	for i = 1, #g_episodeIds do
		local index = 1
		for j = 1, #g_episodes[g_episodeIds[i]].pages do
			for k = 1, #g_episodes[g_episodeIds[i]].pages[j].levels do
				if g_episodes[g_episodeIds[i]].pages[j].levels[k].name == level then
					return index
				end
				index = index + 1
			end
		end
	end
end

function getLevelById(level)

	for k, v in _G.pairs(g_episodes) do
		for i = 1, #v.pages do
			for j = 1, #v.pages[i].levels do
				if v.pages[i].levels[j].name == level then
					return v.pages[i].levels[j], k, i, j
				end
			end
		end
	end
	
	return nil
end

function getNextLevel(level)
	local next = false
	for k, _ in allLevels() do
		if k == level then
			next = true
		elseif next then
			return k
		end
	end
	return nil
end

function allLevels()
	local iterator = function(_, i)
		if i == nil then
			local level = g_episodes[g_episodeIds[1]].pages[1].levels[1]
			return level.name, level
		end
		
		local _, episode, page, index = getLevelById(i)
		for j = 1, #g_episodeIds do
			if g_episodeIds[j] == episode then
				episode = j
				break
			end
		end
		
		index = index + 1
		if index > #g_episodes[g_episodeIds[episode]].pages[page].levels then
			page = page + 1
			index = 1
			if page > #g_episodes[g_episodeIds[episode]].pages then
				episode = episode + 1
				page = 1
				if episode > #g_episodeIds then
					return nil
				end
			end
		end
		
		local level = g_episodes[g_episodeIds[episode]].pages[page].levels[index]
		return level.name, level
	end
	return iterator, nil, nil
end

function getHatcheryStarMaximum(level)
	return 9
end

function isNextLevelButtonDisabled(level_id)

	local level, episode, page, _ = getLevelById(level_id)

	local disable_next_button = false
	if g_episodes[episode].disable_next_level_button then
		disable_next_button = true
	end
	if g_episodes[episode].pages[page].disable_next_level_button then
		disable_next_button = true
	elseif g_episodes[episode].pages[page].disable_next_level_button == false then
		disable_next_button = false
	end
	if level.disable_next_level_button then
		disable_next_button = true
	elseif level.disable_next_level_button == false then
		disable_next_button = false
	end
	
	return disable_next_button
end

function isEagleDisabled(level_id)

	local level, episode, page, _ = getLevelById(level_id)
	
	if level == nil then
		return true
	end

	local mighty_eagle_disabled = false
	if g_episodes[episode].mighty_eagle_disabled then
		mighty_eagle_disabled = true
	end
	if g_episodes[episode].pages[page].mighty_eagle_disabled then
		mighty_eagle_disabled = true
	elseif g_episodes[episode].pages[page].mighty_eagle_disabled == false then
		mighty_eagle_disabled = false
	end
	if level.mighty_eagle_disabled then
		mighty_eagle_disabled = true
	elseif level.mighty_eagle_disabled == false then
		mighty_eagle_disabled = false
	end
	
	return mighty_eagle_disabled
end

function prepareLevel(meta)
	setEditing(false)
	setPhysicsEnabled(false)
	local previous_level_count = 0
	-- TODO: use wrapper functions to get level data from levelname of event. 
	
	for i = 1, meta.page - 1 do
		previous_level_count = previous_level_count + #g_episodes[meta.episode].pages[meta.page].levels
	end

	currentLevelNumber = previous_level_count + meta.level
	currentLevelNumberInTheme = getLevelNumber(meta.levelName)
	currentThemeNumber = meta.episode
	currentWorldNumber = g_episodes[meta.episode].pages[meta.page].world_number
	currentPageNumber = meta.page
	
	
	levelFolder = "levels/" .. g_episodes[meta.episode].pages[meta.page].folder_name .. "/"	
	levelName = meta.levelName
	
	numberOfAttemptsInLevel = 1
	currentEpisode = meta.episode
	
	if g_episodes[meta.episode].extra then
		settingsWrapper:setGoldenEggPlayed(levelName)
		
		eventManager:notify({id = events.EID_GE_LEVEL_STARTED,  levelName = levelName})
	else
		eventManager:notify({id = events.EID_LEVEL_STARTED,  currentWorldNumber = currentWorldNumber, currentLevelNumberInTheme = currentLevelNumberInTheme, from = _G.tostring(levelRestartedFrom)})
	end
	
	if g_episodes[meta.episode].per_page_level_numbering then
		g_currentLevelString = g_episodes[meta.episode].pages[meta.page].display_number .. "-" .. getLevelNumber(meta.levelName)
	else
		g_currentLevelString = g_episodes[meta.episode].pages[meta.page].display_number .. "-" .. getLevelIndexInEpisode(meta.levelName)
	end
	
	--local loading = LevelLoadingPage:new(nil, levelFolder .. levelName)
	--eventManager:notify({id = events.EID_PUSH_FRAME, target = loading})
	eventManager:notify({id = events.EID_LEVEL_LOADING_INIT})
	
end	
--[[
	if event.id == gamelua.events.EID_FULLSCREEN_AD_SHOWING then
		self.delegateBackClicks = false
	end

	if event.id == gamelua.events.EID_FULLSCREEN_AD_DISMISSED then
		self.delegateBackClicks = true
	end
]]

loadFrameCount = 0
gameluaMenuListener = {
	
	eventTriggered = function(o,event)			
		
		if event.id == events.EID_FULLSCREEN_AD_SHOWING then
			if settingsWrapper:isAudioEnabled() then
				changeAudio()			
				menuManager.delegateBackClicks = false
				-- get back old state after ad was dismissed
				changeAudioBackAfterAd = true
			end
		end
		
		if event.id == events.EID_FULLSCREEN_AD_DISMISSED then
			if changeAudioBackAfterAd then
				if not settingsWrapper:isAudioEnabled() then
					changeAudio()		
					changeAudioBackAfterAd = false
					menuManager.delegateBackClicks = true					
				end				
			end			
		end
		
		if event.id == events.EID_EXIT_FROM_MAIN_REQUESTED then
			requestExit()
		end
		
		if event.id == events.EID_LEVEL_RESTART_CLICKED then
			restartLevelIngame()
		end
		
		-----------------------------------
		if event.id == events.EID_PAUSE_CLICKED then
			setPhysicsEnabled(false)
			setGameMode(function() end)
		end	
	
		-----------------------------------
		if event.id == events.EID_BACK_TO_GAME_CLICKED then
			setPhysicsEnabled(true)
			hidePauseMenu()	
			--[[	
			if deviceModel == "iphone4" then
				wantedResolution = "FULL"
				changeResolution = true			
			end
			]]--
			setGameMode(updateGame)
		end	
	
		-----------------------------------	
		if event.id == events.EID_GOTO_MAIN_MENU then
			menuManager:deactivate()
			clearParticles()
			-- <HACK> --------  Without these game will be visible for one frame after returning from level selection to game, if game has been visited before.---------------------
			currentMenuPage = mainMenu
			currentGameMode = updateMenu
			------------------------------</HACK>
			
			prepareMenuPage(mainMenu)
			updateMenu(g_dt, g_time)
			
			setActiveMenuPage(mainMenu, true, false)
			setGameMode(updateMenu)				
		end
		
		-----------------------------------	
		if event.id == events.EID_MIGHTY_EAGLE_PURCHASE_CLOSE_CLICKED then		
			if event.from == "LEVEL_FAILED" then
				local frame = menuManager:popFrame()
				eventManager:notify({ id = events.EID_PUSH_FRAME, target = frame.return_screen })
				-- this will set level failed visible again.
				--menuManager:getRoot():layout()
				
				-- menuManager:setRootVisible(true)
				-- eventManager:notify({ id = events.EID_LEVEL_ENDED, level = levelName, score = score, levelComplete = false })			
			elseif event.from == "INGAME" then
				menuManager:changeRoot(ui.GameHud:new())
				setGameMode(updateGame)
				setPhysicsEnabled(true)
				
				--[[
				if deviceModel == "iphone4" then
					changeResolution = true
					wantedResolution = "FULL"
				end
				]]--
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_GOTO_FACEBOOK_CONNECT then
			gotoABFBConnect()						
		end
			
		-----------------------------------	
		if event.id == events.EID_MIGHTY_EAGLE_BUTTON_CLICKED then
		
			if startedFromEditor then
				launchEagleBaitInGame()
			else
		
				if isEagleEnabled() == true then				
					if isEagleUnavailableForShot() == true then 
					   -- eagle sleeping
					   eagleInfoTimer = 3.0
					else
						launchEagleBaitInGame()
						if event.from == "LEVEL_FAILED" then
							menuManager:changeRoot(ui.GameHud:new())
						end
					end
				else
					if event.from == "LEVEL_FAILED" then
						g_eagleClickedFrom = "LEVEL_FAILED"
						eventManager:notify({id = events.EID_PUSH_FRAME, target = MEPage:new({ return_screen = menuManager:popFrame() })})
					elseif event.from == "MAIN_MENU" then
						g_eagleClickedFrom = "MAIN_MENU"
						menuManager:changeRoot(MainMenuEaglePage:new())
					elseif event.from == "INGAME" then
						g_eagleClickedFrom = "INGAME"
						--menuManager:deactivate()
						--print(nil)
						goToMightyEagleDemoPageFromGame()	
						--setGameMode(function () drawGame() end)
						--goToMightyEagleDemoPageFromGame()			
					end
				end
			end
			skipInput = true						
		end
		
		-----------------------------------	
		if event.id == events.EID_MIGHTY_EAGLE_PURCHASE_CLICKED then
			goToMightyEaglePaymentPage()
			setGameMode(updateGame)
			menuManager:deactivate()
		end
		
		if event.id == events.EID_LEVEL_LOADING_INIT then
			-- check start of function update(dt,time) to see how this works.
			loadFrameCount = 1
		end
		
		-----------------------------------	
		if event.id == events.EID_SHOW_LOADING_PAGE then
			menuManager:setAllowInput(false)							
		end
		
		-----------------------------------	
		if event.id == events.EID_HIDE_LOADING_PAGE then
			menuManager:setAllowInput(true)		
		end
		
		-----------------------------------	
		if event.id == events.EID_GOLDEN_EGG_FROM_MENU then
			revealGoldenEgg(event.levelName)
		end
		
		if event.id == events.EID_BOOMERANG_BIRD_POPUP then
			showRewardPopup("BOOMERANG_BIRD")
		end
		
		if event.id == events.EID_STAR_POPUP then
			showRewardPopup("STAR", { first_time = event.first_time })
		end
		
		if event.id == events.EID_REWARD_POPUP then
			showRewardPopup("GENERIC_REWARD", { sprite = event.sprite, sound = event.sound, })
		end
		
		-----------------------------------	
		if event.id == events.EID_START_NEXT_CHALLENGE_LEVEL then
			startNextGameplayChallenge(event.challenge, event.progress)		
		end
		
				
		-----------------------------------	
		if event.id == events.EID_CHANGE_SCENE then
			--{id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_"..currentThemeNumber}			
			clearParticles()
			
			if event.from == "INGAME" then
				setGameMode(function() end)
				stopIngameSounds()				
				showHatcheryIngameMenu(false)				
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_LEVEL_COMPLETED then
			loginfo(" EID_LEVEL_COMPLETED. levelName = "..event.levelName)
			
			--remove eagle cooldown from this level if necessary
			if event.eagleBaitLaunched ~= true and settingsWrapper:removeEagleUsedInLevel(event.levelName) then
				loginfo("removing eagle used in from "..event.levelName)	
				settingsWrapper:setEagleUsedTime(nil)
				removeNotification("mightyEagleAvailable")
			end
			
			local level, episode, page, index = getLevelById(event.levelName)
			if settingsWrapper:getLastOpenLevel(episode) <= getLevelIndexInEpisode(event.levelName) then
				settingsWrapper:incrementLastOpenLevel(episode)
				saveLuaFileWrapper("settings.lua", "settings", true)
			end
		end
		-----------------------------------	
		if event.id == events.EID_CHALLENGE_STARTED then
			
			if not highscores[event.challenge.id] then
				print("<warning> highscores[" .. _G.tostring(event.challenge.id) .. "] was not initialised\n")
				highscores[event.challenge.id] = {}
			end
			
			if not highscores[event.challenge.id].played then
				highscores[event.challenge.id].played = true
				eventManager:notify({ id = events.EID_CHALLENGE_STARTED_FIRSTTIME, challenge = event.challenge })
			end
		
			prepareChallengeQueue(event.challenge)					
		end
		
		-----------------------------------	
		if event.id == events.EID_CHANGE_LEVEL then
			
			g_currentChallenge = nil
			g_currentChallengeProgress = nil
			local meta = event.data
		
			if meta.levelName == "SOUNDBOARD1" or
			   meta.levelName == "RADIO" or
			   meta.levelName == "KEYBOARD" or
			   meta.levelName == "SEQUENCER" or
			   meta.levelName == "ACCORDION" then
			   settingsWrapper:setGoldenEggPlayed(meta.levelName)
				
			   eventManager:notify({id = events.EID_GE_LEVEL_STARTED,  levelName = meta.levelName})
				
			   currentSoundboard = meta.levelName
			   initSoundboard()
			   currentGameMode = updateSoundboard
			   
			   menuManager:deactivate()
			   
			else
				prepareLevel(meta)
			end								
		end
		
		-----------------------------------	
		if event.id == events.EID_GAMELUA_POPUP then
			dummyPopupPage.rootContainer = event.root
			setActivePopupPage(dummyPopupPage)
		end	
		
		--------- case with android or other platrorms with back button ----
		if event.id == events.EID_EXIT_CONFIRMED then
			requestExit()
		end
		-----------------------------------	
		if event.id == events.EID_EXIT_GAME then
			if deviceModel ~= "android" then
				requestExit()				
			else
				eventManager:notify({id = events.EID_PUSH_FRAME, target = ui.ConfirmPrompt:new({title = "TEXT_EXIT_CONFIRM", returnValue = events.EID_EXIT_CONFIRMED, confirmOnLeft = true})})
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_GOTO_GAME then
		
			if wantedResolution ~= "FULL" then
				changeResolution = true
				wantedResolution = "FULL"
			end
			
			local old_reso_x, old_reso_y = screenWidth, screenHeight
			if deviceModel == "iphone4" then
				screenWidth = 960
				screenHeight = 640
			end
			initCameras()
			if deviceModel == "iphone4" then
				screenWidth = old_reso_x
				screenHeight = old_reso_y
			end
			menuManager:deactivate()
			setGameMode(updateGame)
			g_drawHud = true
			
			drawGame()
			--TODO: drawGame, + draw the level background colour as a rect once?
			menuManager:changeRoot(ui.GameHud:new())
			
		end
		
		-----------------------------------	
		if event.id == events.EID_LOAD_INTRO_CUTSCENE then
			local play_cutscene = { id = events.EID_PLAY_INTRO_CUTSCENE, cutscene = event.cutscene, data = event.data }
			eventManager:notify({ id = events.EID_DO_LOADING, items = { loadCutScenes }, completion_event = play_cutscene })
		end
		
		-----------------------------------	
		if event.id == events.EID_PLAY_INTRO_CUTSCENE then
			menuManager:changeRoot(CutScene:new(event.cutscene, { id = events.EID_CHANGE_LEVEL, data = event.data }))
		end
		
		-----------------------------------	
		if event.id == events.EID_LOAD_END_CUTSCENE then
			local play_cutscene = { id = events.EID_PLAY_END_CUTSCENE, cutscene = event.cutscene, episode = event.episode, page = event.page, level_index = event.level_index }
			eventManager:notify({ id = events.EID_DO_LOADING, items = { loadCutscenes }, completion_event = play_cutscene })
		end
		
		-----------------------------------	
		if event.id == events.EID_PLAY_END_CUTSCENE then
			menuManager:changeRoot(CutScene:new(event.cutscene, { id = events.EID_END_CUTSCENE_FINISHED, episode = event.episode, page = event.page, level_index = event.level_index }))
		end
		
		-----------------------------------	
		if event.id == events.EID_END_CUTSCENE_FINISHED then
			if not g_episodes[event.episode].pages[event.page].levels[event.level_index].episode_end and not g_episodes[event.episode].pages[event.page].levels[event.level_index].temporary_end then
				eventManager:notify({ id = events.EID_SCROLL_TO_NEXT_WORLD, episode = event.episode })
				eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_" .. event.episode })
			elseif g_episodes[event.episode].pages[event.page].levels[event.level_index].temporary_end then
				eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_" .. event.episode })
			else
				eventManager:notify({ id = events.EID_GOTO_CREDITS })
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_GOTO_CREDITS then
			eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "CREDITS", })
		end
		
		-----------------------------------	
		if event.id == events.EID_HATCHERY_CLICKED then
			Hatchery.enter()
		end
		
		-----------------------------------	
		if event.id == events.EID_LEVEL_PLAYED_WITH_EAGLE then
			--check if eagle has already been used in this level
			local eagle_already_used = false
			
			for k, v in _G.pairs(settingsWrapper:getEagleUsedIn()) do
				if v.level == event.level then
					eagle_already_used = true
				end
			end
			
			
			-- check if this level was already completed normally
			if event.level ~= nil and highscores[event.level] ~= nil and highscores[event.level].score > 0 then
				eagle_already_used = true
				loginfo("eagle was already used in level (score found)")
			end
			
			--if not, then mark it as used and put it on the 1 hour cooldown
			if not eagle_already_used then
				settingsWrapper:setEagleUsedInLevel(event.level)
				settingsWrapper:setEagleUsedTime(currentTime())

				local eagleNotificationText = _G.res.getString("TEXTS_BASIC", "TEXT_MIGHTY_EAGLE_RETURNS")
				addNotificationAfter("mightyEagleAvailable", eagleLockedTime, eagleNotificationText)
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_THREE_STARS_GAINED then
			local _, episode, _, _ = getLevelById(event.level)
			local stars, total_stars = calculateEpisodeStars(episode)
			
			if stars == total_stars and not settingsWrapper:isEpisodeThreeStarred(episode) and not g_episodes[episode].disable_episode_completion_screens then
				eventManager:notify({ id = events.EID_EPISODE_THREE_STARRED, episode = episode })
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_EPISODE_THREE_STARRED then
			settingsWrapper:setEpisodeThreeStarred(event.episode)
			if g_episodes[event.episode].three_stars_goldenegg then
				goldenEggAchieved(g_episodes[event.episode].three_stars_goldenegg)
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_STARS_GAINED then
			settingsWrapper:setCumulativeStars(settingsWrapper:getCumulativeStars() + event.stars)
			if g_hatcheryCurrencyEnabled then
			
				if not highscores[event.level].hatcheryStars then
					highscores[event.level].hatcheryStars = 0
				end
				
				local hatcheryMaximum = getHatcheryStarMaximum(event.level)
				if highscores[event.level].hatcheryStars < hatcheryMaximum then
					if highscores[event.level].hatcheryStars == 0 or highscores[event.level].hatcheryTime == nil then
						highscores[event.level].hatcheryTime = _G.os.time()
					end
					highscores[event.level].hatcheryStars = highscores[event.level].hatcheryStars + event.stars
					-- HATCHERY : could be listening to this event instead
					if g_hatcheryEnabled then
						Hatchery.addStars(event.stars)
					end
					settingsWrapper:addHatcheryStars(event.stars)
					saveLuaFileWrapper("highscores.lua", "highscores", true)
					saveLuaFileWrapper("settings.lua", "settings", true)
					print("<hatchery> gained " .. event.stars .. " stars from level " .. event.level .. "\n")
				end
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_WORLD_COMPLETED then
			settingsWrapper:setThemeCompleted(event.worldNumber)
		end
		
		-----------------------------------	
		if event.id == events.EID_CHALLENGE_LEVEL_ENDED then
			g_drawHud = false
			if startedFromEditor then return end
			setGameOn(false)
			setPhysicsEnabled(false)
			currentGameMode = function() end
			stopIngameSounds()
			menuManager:changeRoot(LevelEndRoot:new())
			
			
			if event.levelComplete == true then
				-- Success
				if g_currentChallengeProgress.levelIndex + 1 > #g_currentChallenge.levels then
					local reward = 0
					local old_hatchery_stars = settingsWrapper:getHatcheryStars()
					
					eventManager:notify({ id = events.EID_CHALLENGE_COMPLETE, challenge = g_currentChallenge })
					
					if not highscores[event.challenge.id] or not highscores[event.challenge.id].completed then
						highscores[event.challenge.id] =
						{
							completed = true,
						}
						
						reward = event.challenge.reward
						settingsWrapper:addHatcheryStars(reward)
						saveLuaFileWrapper("highscores.lua", "highscores", true)
						
						eventManager:notify({ id = events.EID_CHALLENGE_COMPLETE_FIRST_TIME, challenge = g_currentChallenge })
					end
					
					eventManager:notify({id = events.EID_PUSH_FRAME, target = ChallengeComplete:new(event.challenge, g_currentChallengeProgress, old_hatchery_stars, reward)})
				else
					eventManager:notify({id = events.EID_PUSH_FRAME, target = ChallengeLevelComplete:new(event.challenge, g_currentChallengeProgress)})
				end
			else
				eventManager:notify({ id = events.EID_CHALLENGE_FAILED, challenge = g_currentChallenge, progress = g_currentChallengeProgress })
				-- Failed
				eventManager:notify({id = events.EID_PUSH_FRAME, target = ChallengeFailed:new(event.challenge,  g_currentChallengeProgress)})
			end
		end
		
		-----------------------------------	
		if event.id == events.EID_LEVEL_ENDED  then			
			if startedFromEditor then return end
			
			if deviceModel == "iphone4" then
				changeResolution = true
				wantedResolution = "HALF"
				screenWidth = 480
				screenHeight = 320
				resetCameras()
				print("resetting cameras\n")
				screenWidth = 960
				screenHeight = 640
			end
			
			showHatcheryIngameMenu(false)
			
			setGameOn(false)
			setPhysicsEnabled(false)
			currentGameMode = function() end
			
			stopIngameSounds()
			
			local level, episode, page, index = getLevelById(event.level)
			
			--was this the first time this level was completed/has it been cleared previously?
			local first_time = true
			if highscores[event.level] and highscores[event.level].completed then
				first_time = false
			end
			
			if highscores[event.level] == nil then
				highscores[event.level] = { score = 0 }
				save_scores = true
			end
			
			if highscores[event.level].score == nil then
				highscores[event.level].score = 0
				save_scores = true
			end
			
			if not highscores[event.level].completed and event.levelComplete then
				eventManager:notify(
				{
					id = events.EID_LEVEL_COMPLETE_FIRST_TIME,
					level = event.level,
				})
			
				highscores[event.level].completed = true
			end
			
			local stars = 0
			
			--display appropriate level end page
			
			if event.levelComplete and g_episodes[episode].extra then
			
				--store old highscore for the levelend screen
				local old_highscore = highscores[event.level].score or 0
				
				if event.score > highscores[event.level].score then
					eventManager:notify(
					{
						id = events.EID_NEW_HIGHSCORE,
						level = event.level,
						oldHighscore = highscores[event.level].score,
						newHighscore = event.score,
					})
					
					highscores[event.level].score = score
					highscores[event.level].birds = birdsShot
					
					if gameCenterEnabled and gameCenter and gameCenter.leaderboards then
						setPostedStatus(event.level)
					end
				end
				
				if highscores[event.level].lowScore == nil or event.score < highscores[event.level].lowScore then
					highscores[event.level].lowScore = event.score
				end
			
				if event.score >= starTable[event.level].goldScore then
					eventManager:notify({ id = events.EID_GOLDEN_EGG_STAR_GAINED, data = { starsGained = calculateStarsFromGoldenEggLevels() } })
				end
				
				--set rootpage to level end base page
				menuManager:changeRoot(LevelEndRoot:new())
				
				--show the level end scorescreen as a popup over the level end root
				local end_page = GoldenEggComplete:new(event.level, event.score, old_highscore)
				
				--display the level end page as popup atop the root
				eventManager:notify({ id = events.EID_PUSH_FRAME, target = end_page })
			
			elseif event.levelComplete and not eagleBaitLaunched then
			
				--number of stars
				stars = getStarCount(event.level, event.score)
				
				--store old highscore for the levelend screen
				local old_highscore = highscores[event.level].score or 0
				
				local old_ep_stars, total_stars = calculateEpisodeStars(episode)
				
				if event.score > highscores[event.level].score then
					eventManager:notify(
					{
						id = events.EID_NEW_HIGHSCORE,
						level = event.level,
						oldHighscore = highscores[event.level].score,
						newHighscore = event.score,
					})
					
					highscores[event.level].score = score
					highscores[event.level].birds = birdsShot
					
					if gameCenterEnabled and gameCenter and gameCenter.leaderboards then
						setPostedStatus(event.level)
					end
				end
				
				local new_ep_stars = calculateEpisodeStars(episode)
				
				if highscores[event.level].lowScore == nil or event.score < highscores[event.level].lowScore then
					highscores[event.level].lowScore = event.score
				end
				
				local old_hatchery_balance = settingsWrapper:getHatcheryStars()
				local old_level_stars = highscores[event.level].hatcheryStars or 0
				
				if event.score >= starTable[event.level].goldScore then
					eventManager:notify({ id = events.EID_THREE_STARS_GAINED, level = event.level })
				end
					
				eventManager:notify({ id = events.EID_STARS_GAINED, level = event.level, stars = stars })
				
				local new_hatchery_balance = settingsWrapper:getHatcheryStars()
				
				--TODO: should this use some flag for checking if crystal/gc is enabled?
				if deviceModel == "iphone" or deviceModel == "ipad" or deviceModel == "iphone4" then
					postTotalHighScores()
					if not isLiteVersion then
						postLevelHighScore(levelName, highscores[levelName].score, true)
					end
				end
				
				--set rootpage to level end base page
				menuManager:changeRoot(LevelEndRoot:new())
				
				--show the level end scorescreen as a popup over the level end root
				local end_page = LevelComplete:new(nil, event.level, first_time, stars, event.score, old_highscore, old_hatchery_balance, new_hatchery_balance, old_level_stars, isEagleUnavailableForShot())
				
				--check for world and episode completion
				local world = g_episodes[episode].pages[page].world_number
				if world > 0 and index == #g_episodes[episode].pages[page].levels and not settingsWrapper:isThemeCompleted(world) then
					settingsWrapper:setThemeCompleted(world)
				end
				
				if level.episode_end and first_time and not g_episodes[episode].disable_episode_completion_screens then
					--add episode completion screen on first time episode clear
					end_page = EpisodeComplete:new(nil, end_page, episode)
				end
				
				--check for episode three starring
				if stars == 3 and new_ep_stars >= total_stars and old_ep_stars < new_ep_stars and not g_episodes[episode].disable_episode_completion_screens then
					end_page = EpisodeThreeStars:new(nil, end_page, episode)
				end
				
				--display the level end page as popup atop the root
				eventManager:notify({ id = events.EID_PUSH_FRAME, target = end_page })
				
			elseif eagleBaitLaunched then
			
				print("<Mighty Eagle> score for " .. _G.tostring(event.level) .. ": " .. _G.tostring(event.score) .. "\n")
			
				local eagle_score = _G.math.min(_G.math.floor((event.score / starTable[event.level].eagleScore) * 100), 100)
				local old_eagle_score = highscores[event.level].eagleScore or 0
				
				if eagle_score > old_eagle_score then
				
					eventManager:notify(
					{
						id = events.EID_NEW_EAGLE_HIGHSCORE,
						level = event.level,
						oldHighscore = old_eagle_score,
						newHighscore = eagle_score,
					})
				
					storeEagleScore(event.level, eagle_score)
										
					--got the feather for first time
					if eagle_score >= 100 then
						eventManager:notify({ id = events.EID_EAGLE_FEATHER_GAINED, level = event.level })
					end
				end
				
				--eagle score max (in raw score)
				if highscores[event.level].eagleScoreMax == nil or event.score > highscores[event.level].eagleScoreMax then
					highscores[event.level].eagleScoreMax = event.score
				end
				
				--eagle score min (in raw score)
				if highscores[event.level].eagleScoreMin == nil or event.score > highscores[event.level].eagleScoreMin then
					highscores[event.level].eagleScoreMin = event.score
				end
				
				print("level played using mighty eagle\n")
				eventManager:notify({ id = events.EID_LEVEL_PLAYED_WITH_EAGLE, level = event.level, skipped = first_time })
				
				menuManager:changeRoot(LevelEndRoot:new())
				eventManager:notify({ id = events.EID_PUSH_FRAME, target = EagleScore:new(nil, event.level, first_time, eagle_score, old_eagle_score) })
			else
				--level failed
				menuManager:changeRoot(LevelEndRoot:new())
				eventManager:notify({ id = events.EID_PUSH_FRAME, target = LevelFailed:new( event.level, not isEagleUnavailableForShot(),not first_time)})
				--eventManager:notify({ id = events.EID_PUSH_FRAME, target = ChallengeComplete:new(challenges[1], { levelIndex = 4 }, 333, 222 ) }) --temp testing!!
			end
			
			saveLuaFileWrapper("highscores.lua", "highscores", true)
			saveLuaFileWrapper("settings.lua", "settings", true)
			
			if event.levelComplete then
				local level,e,w,levelNumber = getLevelById(event.level)
				-- TODO: episode completed first time
				if levelNumber == #g_episodes[episode].pages[page].levels then
					eventManager:notify({id = events.EID_EPISODE_COMPLETED, episodeNumber = e})
				end
				
				if not g_episodes[episode].extra then
					if index == #g_episodes[episode].pages[page].levels then
						local first_time_completed = not settingsWrapper:isThemeCompleted(g_episodes[episode].pages[page].world_number)
						eventManager:notify(
						{
							id = events.EID_WORLD_COMPLETED,
							worldNumber = g_episodes[episode].pages[page].world_number,
							firstTime = first_time_completed,
							clearAchievement = g_episodes[episode].pages[page].clear_achievement
						})
					end
				end
			
				if not g_episodes[episode].extra then
					local episode_stars, episode_total_stars = calculateEpisodeStars(episode)
					eventManager:notify(
					{
						id = events.EID_LEVEL_COMPLETED,
						levelName = event.level,
						hatcheryStars = highscores[event.level].hatcheryStars,
						totalScore = calculateEpisodeScore(episode),
						gainedStars = stars,
						themeNumber = episode,
						stars = episode_stars,
						totalStars = episode_total_stars,
						cumulativeStars = settingsWrapper:getCumulativeStars(),
						extraWorld = g_episodes[episode].extra,
						feathers = calculateAllFeathers(),
						scoreAchievementLimit = g_episodes[episode].score_achievement_limit,
						eagleBaitLaunched = eagleBaitLaunched,
					})
				else
					eventManager:notify({ id = events.EID_GOLDEN_EGG_COMPLETED, level = event.level })
				end
			else
			
				if not g_episodes[episode].extra then
					eventManager:notify({ id = events.EID_LEVEL_FAILED, level = event.level })
				else
					eventManager:notify({ id = events.EID_GOLDEN_EGG_FAILED, level = event.level })
				end
				
			end
			--turn off retina graphics
			--[[
			if deviceModel == "iphone4" then
				changeResolution = true
				wantedResolution = "HALF"
			end
			]]--
		end
		
		if event.id == events.EID_SHOW_TUTORIALS then
			--show all tutorials that have been unlocked
			
			birdTutorialPopups = {}

			if settingsWrapper:getTutorialsForItem("BIRD_RED") then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_RED").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_BLUE") then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_BLUE").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_YELLOW") then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_YELLOW").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_GREY") then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_GREY").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_GREEN") then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_GREEN").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_BOOMERANG") ~= nil then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_BOOMERANG").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_BIG_BROTHER") ~= nil then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_BIG_BROTHER").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BIRD_PUFFER_1") then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_PUFFER_1").sprite)
			end
			if settingsWrapper:getTutorialsForItem("BAIT_SARDINE") ~= nil then
				_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BAIT_SARDINE").sprite)
			end
			
			if #birdTutorialPopups > 1 then
				eventManager:notify({ id = events.EID_SHOW_TUTORIAL, tutorial = birdTutorialPopups[1], from = "PAUSE_MENU", })
			end
		end
		
		if event.id == events.EID_SHOW_TUTORIAL then
			_G.table.remove(birdTutorialPopups, 1)
			if g_tutorialActive then
				eventManager:notify({ id = events.EID_POP_FRAME })
			end
			g_tutorialActive = { tutorial = event.tutorial, from = event.from }
			eventManager:notify({ id = events.EID_PUSH_FRAME, target = Tutorial:new(event.tutorial), })
			if event.from == "INGAME" then
				setPhysicsEnabled(false)
				setGameMode(function() end)
			end
		end
		
		if event.id == events.EID_CLOSE_TUTORIAL then
			local tutorial = g_tutorialActive
			
			if #birdTutorialPopups == 0 then
			
				if tutorial.from == "INGAME" then
					--[[
					if deviceModel == "iphone4" then
						changeResolution = true
						wantedResolution = "FULL"
					end
					]]--
					setPhysicsEnabled(true)
					setGameMode(updateGame)
				end
			
				g_tutorialActive = nil
				eventManager:notify({ id = events.EID_POP_FRAME })
			else
				g_tutorialActive.ready_for_next_tutorial = true
			end
		end
		
		if event.id == events.EID_LEAVE_GAME then
			if event.reason == "PAUSE_MENU_BUTTON" and deviceModel == "iphone4" then
				changeResolution = true
				wantedResolution = "HALF"
			end
		end
	end
}

function initSubsystems()
	eventManager = subsystems.EventManager:new()
	achievementProcessor = subsystems.AchievementProcessor:new()
	achievementProcessor:checkForAchievements()
	menuManager = MenuManager.MenuManager:new()
	adSystem = AdsSubSystem:new()
	
	linkListener = subsystems.LinkListener:new()
	editorListener = Editor:new()
	flurry = subsystems.Flurry:new()
	loaderSystem = subsystems.Loader:new()
	rovioNewsSubSystem = subsystems.RovioNews:new()
	----------- ABID stuffzies
	if ABIDEnabled then
		ABIDSubSystem = subsystems.ABIDSubSystem:new()
		eventManager:addEventListener(events.EID_GAME_INITIALIZED, ABIDSubSystem)
		eventManager:addEventListener(events.EID_ABID_CLICKED, ABIDSubSystem)
		eventManager:addEventListener(events.EID_GAME_PAUSED, ABIDSubSystem)
		eventManager:addEventListener(events.EID_GAME_RESUMED, ABIDSubSystem)
	end
	
	--------- Notifications frame
	eventManager:addEventListener(events.EID_SHOW_LOADING_PAGE, notificationsFrame)
	eventManager:addEventListener(events.EID_HIDE_LOADING_PAGE, notificationsFrame)
	eventManager:addEventListener(events.EID_LEVEL_LOADING_DONE, notificationsFrame)
	eventManager:addEventListener(events.EID_LEVEL_LOADING_INIT, notificationsFrame)
	eventManager:addEventListener(events.EID_PROCESS_FINISHED, notificationsFrame)
	
	--------- Achievement Processor
	eventManager:addEventListener(events.EID_GOLDEN_EGG_GAINED, achievementProcessor)
	eventManager:addEventListener(events.EID_GOLDEN_EGG_STAR_GAINED, achievementProcessor)
	eventManager:addEventListener(events.EID_TUTORIAL_WATCHED, achievementProcessor)
	eventManager:addEventListener(events.EID_WORLD_COMPLETED, achievementProcessor)
	eventManager:addEventListener(events.EID_LEVEL_COMPLETED, achievementProcessor)
	eventManager:addEventListener(events.EID_BLOCKS_DESTROYED, achievementProcessor)
	eventManager:addEventListener(events.EID_BOOMERANG_BIRD_POPUP_SHOWN, achievementProcessor)
	eventManager:addEventListener(events.EID_BIRD_SHOT, achievementProcessor)
	eventManager:addEventListener(events.EID_BIRDS_COLLIDED_ON_FLY, achievementProcessor)
	eventManager:addEventListener(events.EID_ACHIEVEMENT_BULLSEYE, achievementProcessor)
	eventManager:addEventListener(events.EID_CAKE_COLLECTED, achievementProcessor)

	--------- Menu Manager -------	
	eventManager:addEventListener(events.EID_CHANGE_SCENE, menuManager)
	eventManager:addEventListener(events.EID_POP_FRAME, menuManager)
	eventManager:addEventListener(events.EID_PUSH_FRAME, menuManager)
	
	--------- GameLua Listener -----------
	eventManager:addEventListener(events.EID_CHANGE_LEVEL, gameluaMenuListener)
	eventManager:addEventListener(events.EID_GOTO_MAIN_MENU, gameluaMenuListener)
	eventManager:addEventListener(events.EID_GAMELUA_POPUP, gameluaMenuListener)
	eventManager:addEventListener(events.EID_EXIT_GAME, gameluaMenuListener)
	eventManager:addEventListener(events.EID_GOTO_GAME, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LEVEL_COMPLETED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_CHANGE_SCENE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_HATCHERY_CLICKED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_GOLDEN_EGG_FROM_MENU, gameluaMenuListener)
	eventManager:addEventListener(events.EID_BOOMERANG_BIRD_POPUP, gameluaMenuListener)
	eventManager:addEventListener(events.EID_STAR_POPUP, gameluaMenuListener)
	eventManager:addEventListener(events.EID_REWARD_POPUP, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LEVEL_PLAYED_WITH_EAGLE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_THREE_STARS_GAINED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_EPISODE_THREE_STARRED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_STARS_GAINED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_WORLD_COMPLETED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_CHALLENGE_LEVEL_ENDED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LEVEL_ENDED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_CHALLENGE_STARTED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_START_NEXT_CHALLENGE_LEVEL, gameluaMenuListener)
	eventManager:addEventListener(events.EID_GOTO_FACEBOOK_CONNECT, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LEAVE_GAME, gameluaMenuListener)

	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_PURCHASE_CLOSE_CLICKED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_PURCHASE_CLICKED, gameluaMenuListener)

	eventManager:addEventListener(events.EID_LEVEL_LOADING_INIT, gameluaMenuListener)
	eventManager:addEventListener(events.EID_SHOW_LOADING_PAGE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_HIDE_LOADING_PAGE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LEVEL_LOADING_DONE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LOAD_INTRO_CUTSCENE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LOAD_END_CUTSCENE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_PLAY_INTRO_CUTSCENE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_PLAY_END_CUTSCENE, gameluaMenuListener)
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_BUTTON_CLICKED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_END_CUTSCENE_FINISHED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_GOTO_CREDITS, gameluaMenuListener)
	eventManager:addEventListener(events.EID_PAUSE_CLICKED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_BACK_TO_GAME_CLICKED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_LEVEL_RESTART_CLICKED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_EXIT_CONFIRMED, gameluaMenuListener)
	eventManager:addEventListener(events.EID_FULLSCREEN_AD_SHOWING, gameluaMenuListener)
	eventManager:addEventListener(events.EID_FULLSCREEN_AD_DISMISSED, gameluaMenuListener)
	--tutorials
	eventManager:addEventListener(events.EID_SHOW_TUTORIAL, gameluaMenuListener)
	eventManager:addEventListener(events.EID_CLOSE_TUTORIAL, gameluaMenuListener)
	eventManager:addEventListener(events.EID_SHOW_TUTORIALS, gameluaMenuListener)
	
	--------- Editor -----------
	eventManager:addEventListener(events.EID_LEVEL_ENDED, editorListener)

	--------- Link Listener ---------------	
	eventManager:addEventListener(events.EID_GIFT_PURCHASE_CLICKED, linkListener)
	eventManager:addEventListener(events.EID_AB_SHOP_CLICKED, linkListener)
	eventManager:addEventListener(events.EID_LENOVO_ADFREE_CLICKED, linkListener)
	eventManager:addEventListener(events.EID_NEWSLETTER_CLICKED, linkListener)
	eventManager:addEventListener(events.EID_SEASONS_CLICKED, linkListener)
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_TRAILER_CLICKED, linkListener)
	
	--Flurry
	eventManager:addEventListener(events.EID_LEVEL_PLAYED_WITH_EAGLE, flurry)
	eventManager:addEventListener(events.EID_EAGLE_FEATHER_GAINED, flurry)
	eventManager:addEventListener(events.EID_NEW_HIGHSCORE, flurry)
	eventManager:addEventListener(events.EID_LEVEL_COMPLETE_FIRST_TIME, flurry)
	eventManager:addEventListener(events.EID_GOLDEN_EGG_COMPLETED, flurry)
	eventManager:addEventListener(events.EID_LEVEL_COMPLETED, flurry)
	eventManager:addEventListener(events.EID_LEVEL_FAILED, flurry)
	eventManager:addEventListener(events.EID_GOLDEN_EGG_FAILED, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_STARTED, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_STARTED_FIRSTTIME, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_RESTARTED, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_FAILED, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_COMPLETE, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_COMPLETE_FIRST_TIME, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_MENU_ENTERED, flurry)
	eventManager:addEventListener(events.EID_CHALLENGE_UNLOCKED, flurry)
	eventManager:addEventListener(events.EID_ME_PURCHASE_FAILED_OTHER, flurry)
	eventManager:addEventListener(events.EID_MIGHTYEAGLE_RESTORED, flurry)
	eventManager:addEventListener(events.EID_ME_PURCHASE_CANCELLED_BY_USER, flurry)
	eventManager:addEventListener(events.EID_MIGHTYEAGLE_PURCHASED, flurry)
	eventManager:addEventListener(events.EID_CRYSTAL_STARTED, flurry)
	eventManager:addEventListener(events.EID_FACEBOOK_LIKE_CLICKED, flurry)
	eventManager:addEventListener(events.EID_CHANGE_LEVEL, flurry)
	eventManager:addEventListener(events.EID_MAIN_MENU_ENTERED, flurry)
	eventManager:addEventListener(events.EID_MENUMANAGER_ROOT_CHANGED, flurry)
	eventManager:addEventListener(events.EID_CHANGE_SCENE, flurry)
	eventManager:addEventListener(events.EID_ABOUT_MENU_OPENED, flurry)
	eventManager:addEventListener(events.EID_GOTO_FACEBOOK_CONNECT, flurry)
	eventManager:addEventListener(events.EID_ABSHOP_LINK_CLICKED, flurry)
	eventManager:addEventListener(events.EID_GIFT_PURCHASE_CLICKED, flurry)
	eventManager:addEventListener(events.EID_FACEBOOK_LINK_CLICKED, flurry)
	eventManager:addEventListener(events.EID_TWITTER_LINK_CLICKED, flurry)
	eventManager:addEventListener(events.EID_CINEMATIC_TRAILER_CLICKED, flurry)
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_TRAILER_CLICKED, flurry)
	eventManager:addEventListener(events.EID_SEASONS_LINK_CLICKED, flurry)
	eventManager:addEventListener(events.EID_NEWSLETTER_CLICKED, flurry)
	eventManager:addEventListener(events.EID_LEVEL_RESTARTED, flurry)
	eventManager:addEventListener(events.EID_FLURRY_EVENT_STARTED_BEFORE_COMPLETION, flurry)
	eventManager:addEventListener(events.EID_LEVEL_STARTED, flurry)
	eventManager:addEventListener(events.EID_GE_LEVEL_STARTED, flurry)
	eventManager:addEventListener(events.EID_GOLDEN_EGG_STAR_GAINED, flurry)
	eventManager:addEventListener(events.EID_GE_LEVEL_RESTARTED, flurry)	
	
	--- loader ---
	eventManager:addEventListener(events.EID_DO_LOADING, loaderSystem)

	-- ads subsystem --
	eventManager:addEventListener(events.EID_MENUMANAGER_ROOT_CHANGED, adSystem)
	eventManager:addEventListener(events.EID_GAME_INITIALIZED, adSystem)
	eventManager:addEventListener(events.EID_LEVEL_LOADING_DONE	, adSystem)
	eventManager:addEventListener(events.EID_GOTO_GAME, adSystem)
	-------- add to systems update loop if necessary ----------	
	_G.table.insert(subSystemsList, achievementSystem)
	_G.table.insert(subSystemsList, loaderSystem)
	_G.table.insert(subSystemsList, rovioNewsSubSystem)
end

-- format redirect link URL with all the query string parameters
function generateRedirectURL(variant, target)
	return "http://cloud.rovio.com/link/redirect/?d=".. deviceModel .."&p=abc&a=".. variant .."&v=".. gameVersionNumber .."&t=".. target .."&r=game&c=".. customerString
end

-- Filled from C++
--imagePath = "images"
--fontPath = "fonts"
--audioPath = "audio"
--localizationPath = "localization"
--levelPath = "levels"
function createStartUpAssets()

	if deviceModel == "iphone" then
		g_cameraProfileList = { deviceModel, "osx", "ipad", "iphone" }
	elseif deviceModel == "ipad" then
		g_cameraProfileList = { deviceModel, "iphone" }
	elseif deviceModel == "android" and isHDVersion then
		g_cameraProfileList = { deviceModel, "ipad", "iphone" }
	else
		g_cameraProfileList = { deviceModel, "iphone" }
	end
	
	-- Create urls
	local variant = "full"
	if isLiteVersion then
		variant = "lite"
	end
	
	if isHDVersion then
		variant = "HD"
	end
	
	local appStoreFullType = "originalfull"
	local appStoreSeasonsFullType = "halloweenfull"
	
	if customerString ~= "rovio" then
		appStoreFullType = appStoreFullType .."_" .. customerString
		appStoreSeasonsFullType = appStoreSeasonsFullType .."_" .. customerString
	end
	
--	APP_STORE_SEASONS_URL = generateRedirectURL(variant, "halloween")
	APP_STORE_FULL_VERSION_URL = generateRedirectURL(variant, appStoreFullType)
	APP_STORE_HALLOWEEN_URL = generateRedirectURL(variant, appStoreSeasonsFullType)
	NEWSLETTER_URL = generateRedirectURL(variant, "newsletter")
	ANDROID_MARKET_FULL_VERSION_URL = generateRedirectURL("litebeta2", "originalfull")
	REPORT_BUG_URL = generateRedirectURL("litebeta2", "reportbug")
	ANGRY_BIRDS_TRAILER_URL = generateRedirectURL(variant, "trailer")
	OVI_STORE_URL = generateRedirectURL(variant, "full")
	
	--OVI_STORE_URL_S60 = "http://lr.ovi.mobi/store/10042237_AngryBirds" -- Redirect not allowed by Nokia
	OVI_STORE_URL_S60 = generateRedirectURL("lite", "originalfull")
	OVI_STORE_MORE_GAMES_URL_S60 = generateRedirectURL(variant, "moregames")
	ROVIO_IN_OVI_STORE_URL = "http://store.ovi.com/publisher/RovioMobile/"
	LP1_IN_OVI_STORE_URL = generateRedirectURL(variant, "lp1")
	LP2_IN_OVI_STORE_URL = generateRedirectURL(variant, "lp2")
	FACEBOOK_URL = generateRedirectURL(variant, "facebook")
	TWITTER_URL = generateRedirectURL(variant, "twitterfollow")
	MIGHTY_EAGLE_TRAILER = generateRedirectURL(variant, "trailer2")
	
	ROVIO_UPDATE_URL_S60 = generateRedirectURL(variant, "checklatestfull")
	
	if applyChinaRestictions then
		ROVIO_UPDATE_URL_S60 = generateRedirectURL("full_china", "checklatestfull")
	end
	
	ABSHOP_URL = generateRedirectURL(variant, "shop")
	APPLE_GIFT_PURCHASE_URL = generateRedirectURL(variant, "purchasegift")
	LENOVO_NO_ADS_URL = generateRedirectURL(variant, "lenovonoads")
	RIO_CONTEST_URL = generateRedirectURL(variant, "riocontest")
	PRIVACY_POLICY_URL = generateRedirectURL(variant, "privacypolicy")
	EULA_URL = generateRedirectURL(variant, "eula")
	AB_FBCONNECT_URL = generateRedirectURL(variant, "facebooklike")
	ABLIKE_URL = generateRedirectURL(variant, "ablike")
	
	uniqueDeviceId = uniqueDeviceId or "none"
	--print("gamelogic.lua:createStartUpAssets(): uniqueDeviceId: ".. uniqueDeviceId)
	
	if not releaseBuild then
		ROVIO_NEWS_URL = "http://dev.angrybirds.com/card/news-dyn.php?device=" .. deviceModel .."&product=angrybirds&variant=".. variant .."&version=".. gameVersionNumber .."&screenWidth=".. screenWidth .."&screenHeight=".. screenHeight .."&id=".. uniqueDeviceId .."&customer="..customerString
	else
		ROVIO_NEWS_URL = "https://cloud.rovio.com/content/embed/pauseMenu/?device=" .. deviceModel .."&product=angrybirds&variant=".. variant .."&version=".. gameVersionNumber .."&screenWidth=".. screenWidth .."&screenHeight=".. screenHeight .."&id=".. uniqueDeviceId .."&customer="..customerString
	end
	
	_G.res.createTextGroupSet(localizationPath .. "/TEXTS_BASIC.dat")
	loadImages( { "SPLASHES" } )
	
	-- if we want to play audio during the startup scene
	_G.res.createAudioOutput(1, 16, 16000)
end

function selectAssetProfile(group)
	-- Default profile is iPhone because it's probably the most up to date
	local profileName = "480x320"
	
	if deviceModel == "iphone" then
		profileName = "480x320"
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
		
	elseif deviceModel == "iphone4" then
		--profileName = "960x640"
		profileName = "480x320"
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
		
	elseif deviceModel == "ipad" then
		profileName = "1024x768"
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
		
	elseif deviceModel == "n900" then
		profileName = "864x480"
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
	elseif deviceModel == "meego" then
		profileName = "864x480"
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
		
	elseif deviceModel == "bada" then
		profileName = "864x480_bada"
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
		
	elseif deviceModel == "s60" then
		if isKorea then
			if group == "SPLASHES" then
				profileName = "640x360_korea"
			else
				profileName = "640x360"
			end
		elseif applyChinaRestictions then
			if group == "CHINA" then
				profileName = "640x360_china"
			else
				profileName = "640x360"
			end
		else
			profileName = "640x360"
		end
		
		if isLiteVersion then
			profileName = profileName .. "_lite"
		end
		
	elseif deviceModel == "windows" then
		profileName = ""
	elseif deviceModel == "palm" then
		-- Palm HD
		if screenWidth >= 1024 then
			profileName = "1024x768_palmhd"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
	
		-- Palm mobile phones
		elseif (group == "MENU" or group == "TUTORIALS_COMPOSPRITES") and screenWidth < 800 then
			profileName = "400x320_palm_partial"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		else profileName = "864x480"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		end	
		
	--[[
	elseif deviceModel == "palm" then
		-- Palm Tablet
		if screenWidth > 480 then
			profileName = "1024x768"
		-- Palm Pre
		elseif screenWidth == 480 then
			profileName = "480x320"
			if isLiteVersion then
				profileName = profileName .. "_lite_palm"
			end
			
		-- Palm Pixi
		else
			profileName = "400x320"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		end]]
		
	elseif deviceModel == "android" then
		if isHDVersion then
			profileName = "1280x800"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		elseif (group == "MENU" or group == "TUTORIALS_COMPOSPRITES") and screenHeight < 320 then
			profileName = "320x240_android_partial"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		elseif (group == "MENU" or group == "TUTORIALS_COMPOSPRITES") and screenHeight < 480 then
			profileName = "480x320_android_partial"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		else
			profileName = "864x480"

			
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
			if isBetaVersion then
				profileName = profileName .. "_beta"
			end
			
		end
	end
	
	
	return profileName
end

function selectFontProfile()
	-- Default profile is iPhone because it's probably the most up to date
	local profileName = "480x320"
	
	if deviceModel == "iphone" or deviceModel == "iphone4" then
		profileName = "480x320"
	
	elseif deviceModel == "palm" then
		if screenWidth > 480 then
			profileName = "1024x768"
		elseif screenWidth == 480 then
			profileName = "480x320"
			if isLiteVersion then
				profileName = profileName .. "_lite_palm"
			end
			
		-- Palm Pixi
		else
			profileName = "400x320"
			if isLiteVersion then
				profileName = profileName .. "_lite"
			end
		end
	elseif deviceModel == "meego" then
		profileName = "864x480"
	elseif deviceModel == "ipad" then
		profileName = "1024x768"
		
	elseif deviceModel == "n900" then
		profileName = "864x480"
		
	elseif deviceModel == "bada" then
		profileName = "864x480_bada"
		
	elseif deviceModel == "s60" then
		profileName = "640x360"
		
	elseif deviceModel == "windows" then
		profileName = ""
		
	elseif deviceModel == "android" then
		if screenHeight < 320 then
			profileName = "320x240"
		elseif screenHeight < 480 then
			profileName = "480x320"
		else
			profileName = "864x480"
		end
	end
	
	return profileName
end

function loadImages(groups)

	for g = 1, #groups do
		local profileName = selectAssetProfile( groups[g] )
		if assetLoadList[profileName] ~= nil then
			local files = assetLoadList[profileName][groups[g]]
			if files ~= nil then
				for i=1, #files do
					_G.res.createSpriteSheet(imagePath .. "/" .. profileName .. "/" .. files[i])
				end
			end
		end
	end
end

function loadCompoSprites(groups)
	for g = 1, #groups do
		local profileName = selectAssetProfile( groups[g] )
		if assetLoadList[profileName] ~= nil then
			local files = assetLoadList[profileName][groups[g]]
			if files ~= nil then
				for i=1, #files do
					_G.res.createCompoSpriteSet(imagePath .. "/" .. profileName .. "/" .. files[i])
				end
			end
		end
	end
end

function releaseImages(groups)


	for g = 1, #groups do
		local profileName = selectAssetProfile( groups[g] )
		if assetLoadList[profileName] ~= nil then
			local files = assetLoadList[profileName][groups[g]]
			if files ~= nil then
				for i=1, #files do
					_G.res.releaseSpriteSheet(imagePath .. "/" .. profileName .. "/" .. files[i])
				end
			end
		end
	end
end

function releaseCompoSprites(groups)
	for g = 1, #groups do
		local profileName = selectAssetProfile( groups[g] )
		if assetLoadList[profileName] ~= nil then
			local files = assetLoadList[profileName][groups[g]]
			if files ~= nil then
				for i=1, #files do
					_G.res.releaseCompoSpriteSet(imagePath .. "/" .. profileName .. "/" .. files[i])
				end
			end
		end
	end
end

function loadFonts()
	local profileName = selectFontProfile()
	
	fontBasic = _G.res.getString("TEXTS_BASIC", "FONT_BASIC")

	fontMenu = _G.res.getString("TEXTS_BASIC", "FONT_MENU")
	
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/" .. fontBasic .. ".dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/" .. fontMenu .. ".dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_SCORE.dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_BIG_NUMBERS.dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_LS_SMALL.dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_CHALLENGE_SCORE.dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_BIRDS_LEFT.dat")
	_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_CURRENT_HIGHSCORE.dat")
	
	if gameCenterSupported then
		_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_GAMECENTER_BASIC.dat")
		_G.res.createBitmapFont(fontPath .. "/" .. profileName .. "/FONT_GAMECENTER_NUMBERS.dat")
	end
		
end

--called when getting out from hatchery
function loadMenuAssets()	
	
	loadImages( { "INGAME", "OTHER", "ACHIEVEMENTS", "MENU" } )
	loadBackgrounds()

	if applyChinaRestictions then
		loadImages({"CHINA"})
	end

	loadCompoSprites( { "TUTORIALS_COMPOSPRITES", "INGAME_COMPOSPRITES", "ROVIO_NEWS_COMPOSPRITES", "COMPO", "MENU_COMPOSPRITES"} )

	loadAllThemeGraphics()

end

--called when loading hatchery
function releaseMenuAssets()
	
	releaseImages( { "INGAME", "OTHER", "ACHIEVEMENTS", "MENU" } )
	releaseBackgrounds()

	if applyChinaRestictions then
		releaseImages({"CHINA"})
	end

	releaseCompoSprites( { "TUTORIALS_COMPOSPRITES", "INGAME_COMPOSPRITES", "ROVIO_NEWS_COMPOSPRITES", "COMPO", "MENU_COMPOSPRITES"} )

	releaseAllThemeGraphics()
end

function releaseAllThemeGraphics()
	for k,v in _G.pairs(blockTable.themes) do
		if(k ~= "settings") then
			releaseImages({v.graphicSetName})
			releaseCompoSprites({v.graphicSetName.."_COMPOSPRITES"})					
		end
	end
end


function changeLocale(locale)
	 print("LOCAL CHANGED TO "..locale.."\n")
	_G.res.loadLocale("TEXTS_BASIC", locale)
	_G.res.useLocale(locale)	
end

function loadAllThemeGraphics()
	for k,v in _G.pairs(blockTable.themes) do
		if(k ~= "settings") then
			loadImages({v.graphicSetName})
			loadCompoSprites({v.graphicSetName.."_COMPOSPRITES"})		
		end
	end
end

--oldGFXSet = nil
currentGFXSet = nil

function loadThemeGraphics(name)

	print (" ::  LoadThemeGraphics() \n")
	local themeName = blockTable.themes[name].graphicSetName
	
	if(themeName == currentGFXSet) then
		print(" - - GFX set is the same, not loading or releasing graphics\n")
		return
	end
	
	if(currentGFXSet ~= nil) then
		print("- - Releasing previous graphics set : "..currentGFXSet.."\n")
		releaseImages({currentGFXSet})
		releaseCompoSprites({currentGFXSet.."_COMPOSPRITES"})							
	end
	
	-- update current set value
	currentGFXSet = themeName
	
	print(" -- THEME GRAPHICS SET NAME = "..themeName.."\n")
	
	loadImages({currentGFXSet})
	loadCompoSprites({currentGFXSet.."_COMPOSPRITES"})
end

function createAssets()

	if settingsWrapper:getSettingsVersion().id ~= 1 then
		settingsWrapper:convertSettings()
	end
	
	-- uncomment for different language
	-- _G.res.loadLocale("TEXTS_BASIC", "es_ES")
	-- _G.res.useLocale("es_ES")
		
	loadImages( { "INGAME", "OTHER", "ACHIEVEMENTS", "MENU" } )
	loadBackgrounds()
	
	if applyChinaRestictions then
		loadImages({"CHINA"})
	end
	
	loadCompoSprites( { "TUTORIALS_COMPOSPRITES", "INGAME_COMPOSPRITES", "ROVIO_NEWS_COMPOSPRITES", "COMPO", "MENU_COMPOSPRITES"} )
	loadFonts()
	
	defaultMenuFont = fontBasic
	setFont(defaultMenuFont)
	
	local createAudio = function(params)
		local stream = g_streamSounds
		if params.alwaysStream then
			stream = true
		end
		
		local extension = params.extension or "wav"
		if g_useMp3Sound and params.extension == nil then
			extension = "mp3"
		end
		
		local fileName = params.fileName .. "." .. extension
		--print("-- loading audio clip [" .. fileName .. "] as [" .. params.clipName .. "], streaming = " .. _G.tostring(stream) .. "\n")
		_G.res.createAudio(fileName, params.clipName, stream)
	end
	
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a1", clipName = "bird 01 collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a2", clipName = "bird 01 collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a3", clipName = "bird 01 collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a4", clipName = "bird 01 collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a1_low", clipName = "bird 01 collision a1_low" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a2_low", clipName = "bird 01 collision a2_low" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a3_low", clipName = "bird 01 collision a3_low" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 collision a4_low", clipName = "bird 01 collision a4_low" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 flying", clipName = "bird_01_flying" }
	createAudio{ fileName = audioPath .. "/sfx/bigbrother_fly", clipName = "big_brother_flying" }
	createAudio{ fileName = audioPath .. "/sfx/bigbrother_awakens", clipName = "big_brother_awakens" }
	createAudio{ fileName = audioPath .. "/sfx/bird 01 select", clipName = "bird_01_select" }
	createAudio{ fileName = audioPath .. "/sfx/bigbrother_select", clipName = "big_brother_select" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 collision a1", clipName = "bird 02 collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 collision a2", clipName = "bird 02 collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 collision a3", clipName = "bird 02 collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 collision a4", clipName = "bird 02 collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 collision a5", clipName = "bird 02 collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 flying", clipName = "bird_02_flying" }
	createAudio{ fileName = audioPath .. "/sfx/bird 02 select", clipName = "bird_02_select" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 collision a1", clipName = "bird 03 collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 collision a2", clipName = "bird 03 collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 collision a3", clipName = "bird 03 collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 collision a4", clipName = "bird 03 collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 collision a5", clipName = "bird 03 collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 flying", clipName = "bird_03_flying" }
	createAudio{ fileName = audioPath .. "/sfx/bird 03 select", clipName = "bird_03_select" }
	createAudio{ fileName = audioPath .. "/sfx/bird 04 flying", clipName = "bird_04_flying" }
	createAudio{ fileName = audioPath .. "/sfx/bird 04 select", clipName = "bird_04_select" }
	createAudio{ fileName = audioPath .. "/sfx/bird 04 collision a1", clipName = "bird 04 collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird 04 collision a2", clipName = "bird 04 collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird 04 collision a3", clipName = "bird 04 collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird 04 collision a4", clipName = "bird 04 collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 collision a1", clipName = "bird 05 collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 collision a2", clipName = "bird 05 collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 collision a3", clipName = "bird 05 collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 collision a4", clipName = "bird 05 collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 collision a5", clipName = "bird 05 collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 flying", clipName = "bird_05_flying" }
	createAudio{ fileName = audioPath .. "/sfx/bird 05 select", clipName = "bird_05_select" }
	createAudio{ fileName = audioPath .. "/sfx/bird_06_flying", clipName = "bird_06_flying" }
	createAudio{ fileName = audioPath .. "/sfx/boomerang_select", clipName = "boomerang_select" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a1", clipName = "bird_misc_a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a2", clipName = "bird_misc_a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a3", clipName = "bird_misc_a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a4", clipName = "bird_misc_a4" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a5", clipName = "bird_misc_a5" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a6", clipName = "bird_misc_a6" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a7", clipName = "bird_misc_a7" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a8", clipName = "bird_misc_a8" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a9", clipName = "bird_misc_a9" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a10", clipName = "bird_misc_a10" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a11", clipName = "bird_misc_a11" }
	createAudio{ fileName = audioPath .. "/sfx/bird misc a12", clipName = "bird_misc_a12" }
	createAudio{ fileName = audioPath .. "/sfx/bird destroyed", clipName = "bird_destroyed" }
	createAudio{ fileName = audioPath .. "/sfx/bird next military a1", clipName = "bird next military a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird next military a2", clipName = "bird next military a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird next military a3", clipName = "bird next military a3" }
	createAudio{ fileName = audioPath .. "/sfx/bird shot-a1", clipName = "bird shot a1" }
	createAudio{ fileName = audioPath .. "/sfx/bird shot-a2", clipName = "bird shot a2" }
	createAudio{ fileName = audioPath .. "/sfx/bird shot-a3", clipName = "bird shot a3" }
	createAudio{ fileName = audioPath .. "/sfx/level clear military a1", extension = "mp3", alwaysStream = true, clipName = "level clear military a1" }
	createAudio{ fileName = audioPath .. "/sfx/level clear military a2", extension = "mp3", alwaysStream = true, clipName = "level clear military a2" }
	createAudio{ fileName = audioPath .. "/sfx/level failed piglets a1", extension = "mp3", alwaysStream = true, clipName = "level failed piglets a1" }
	createAudio{ fileName = audioPath .. "/sfx/level failed piglets a2", extension = "mp3", alwaysStream = true, clipName = "level failed piglets a2" }
	createAudio{ fileName = audioPath .. "/sfx/level start military a1", extension = "mp3", alwaysStream = true, clipName = "level start military a1" }
	createAudio{ fileName = audioPath .. "/sfx/level start military a2", extension = "mp3", alwaysStream = true, clipName = "level start military a2" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a1", clipName = "light collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a2", clipName = "light collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a3", clipName = "light collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a4", clipName = "light collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a5", clipName = "light collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a6", clipName = "light collision a6" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a7", clipName = "light collision a7" }
	createAudio{ fileName = audioPath .. "/sfx/ice light collision a8", clipName = "light collision a8" }
	createAudio{ fileName = audioPath .. "/sfx/light damage a1", clipName = "light damage a1" }
	createAudio{ fileName = audioPath .. "/sfx/light damage a2", clipName = "light damage a2" }
	createAudio{ fileName = audioPath .. "/sfx/light damage a3", clipName = "light damage a3" }
	createAudio{ fileName = audioPath .. "/sfx/light destroyed a1", clipName = "light destroyed a1" }
	createAudio{ fileName = audioPath .. "/sfx/light destroyed a2", clipName = "light destroyed a2" }
	createAudio{ fileName = audioPath .. "/sfx/light destroyed a3", clipName = "light destroyed a3" }
	createAudio{ fileName = audioPath .. "/sfx/light rolling", clipName = "light_rolling" }
	createAudio{ fileName = audioPath .. "/sfx/menu back", clipName = "menu_back" }
	createAudio{ fileName = audioPath .. "/sfx/menu confirm", clipName = "menu_confirm" }
	createAudio{ fileName = audioPath .. "/sfx/menu select", clipName = "menu_select" } -- is this used anywhere?
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a1", clipName = "piglette collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a2", clipName = "piglette collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a3", clipName = "piglette collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a4", clipName = "piglette collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a5", clipName = "piglette collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a6", clipName = "piglette collision a6" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a7", clipName = "piglette collision a7" }
	createAudio{ fileName = audioPath .. "/sfx/piglette collision a8", clipName = "piglette collision a8" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a1", clipName = "piglette damage a1" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a2", clipName = "piglette damage a2" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a3", clipName = "piglette damage a3" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a4", clipName = "piglette damage a4" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a5", clipName = "piglette damage a5" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a6", clipName = "piglette damage a6" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a7", clipName = "piglette damage a7" }
	createAudio{ fileName = audioPath .. "/sfx/piglette damage a8", clipName = "piglette damage a8" }
	createAudio{ fileName = audioPath .. "/sfx/piglette destroyed", clipName = "piglette_destroyed" }
	createAudio{ fileName = audioPath .. "/sfx/rock collision a1", clipName = "rock collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/rock collision a2", clipName = "rock collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/rock collision a3", clipName = "rock collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/rock collision a4", clipName = "rock collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/rock collision a5", clipName = "rock collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/rock damage a1", clipName = "rock damage a1" }
	createAudio{ fileName = audioPath .. "/sfx/rock damage a2", clipName = "rock damage a2" }
	createAudio{ fileName = audioPath .. "/sfx/rock damage a3", clipName = "rock damage a3" }
	createAudio{ fileName = audioPath .. "/sfx/rock destroyed a1", clipName = "rock destroyed a1" }
	createAudio{ fileName = audioPath .. "/sfx/rock destroyed a2", clipName = "rock destroyed a2" }
	createAudio{ fileName = audioPath .. "/sfx/rock destroyed a3", clipName = "rock destroyed a3" }
	createAudio{ fileName = audioPath .. "/sfx/rock rolling", clipName = "rock_rolling" }
	createAudio{ fileName = audioPath .. "/sfx/special boost", clipName = "special_boost" }
	createAudio{ fileName = audioPath .. "/sfx/special egg explosion", clipName = "special_explosion" }
	createAudio{ fileName = audioPath .. "/sfx/special group", clipName = "special_egg" }
	createAudio{ fileName = audioPath .. "/sfx/special egg", clipName = "special_group" }
	createAudio{ fileName = audioPath .. "/sfx/wood collision a1", clipName = "wood collision a1" }
	createAudio{ fileName = audioPath .. "/sfx/wood collision a2", clipName = "wood collision a2" }
	createAudio{ fileName = audioPath .. "/sfx/wood collision a3", clipName = "wood collision a3" }
	createAudio{ fileName = audioPath .. "/sfx/wood collision a4", clipName = "wood collision a4" }
	createAudio{ fileName = audioPath .. "/sfx/wood collision a5", clipName = "wood collision a5" }
	createAudio{ fileName = audioPath .. "/sfx/wood collision a6", clipName = "wood collision a6" }
	createAudio{ fileName = audioPath .. "/sfx/wood damage a1", clipName = "wood damage a1" }
	createAudio{ fileName = audioPath .. "/sfx/wood damage a2", clipName = "wood damage a2" }
	createAudio{ fileName = audioPath .. "/sfx/wood damage a3", clipName = "wood damage a3" }
	createAudio{ fileName = audioPath .. "/sfx/wood destroyed a1", clipName = "wood destroyed a1" }
	createAudio{ fileName = audioPath .. "/sfx/wood destroyed a2", clipName = "wood destroyed a2" }
	createAudio{ fileName = audioPath .. "/sfx/wood destroyed a3", clipName = "wood destroyed a3" }
	createAudio{ fileName = audioPath .. "/sfx/wood rolling", clipName = "wood_rolling" }
	createAudio{ fileName = audioPath .. "/sfx/balloon_pop", clipName = "balloon_pop" }
	createAudio{ fileName = audioPath .. "/sfx/bird pushing egg out", clipName = "bird_pushing_egg_out" }
	createAudio{ fileName = audioPath .. "/sfx/slingshot streched", clipName = "slingshot_stretched" }
	createAudio{ fileName = audioPath .. "/sfx/tnt box explodes", clipName = "tnt_explodes" }
	createAudio{ fileName = audioPath .. "/sfx/boomerang_swish", clipName = "boomerang_swish" }
	createAudio{ fileName = audioPath .. "/sfx/boomerang_activate", clipName = "boomerang_activate" }
	createAudio{ fileName = audioPath .. "/sfx/trampoline", clipName = "trampoline" }
	createAudio{ fileName = audioPath .. "/sfx/redbird_yell01", clipName = "red_special_1" }
	createAudio{ fileName = audioPath .. "/sfx/redbird_yell02", clipName = "red_special_2" }
	createAudio{ fileName = audioPath .. "/sfx/redbird_yell03", clipName = "red_special_3" }
	createAudio{ fileName = audioPath .. "/sfx/bigbrother_yell", clipName = "big_brother_special_1" }
	createAudio{ fileName = audioPath .. "/sfx/mightyeagle", clipName = "mighty_eagle_yell" }
	createAudio{ fileName = audioPath .. "/sfx/sardine_can_shot", extension = "mp3", alwaysStream = true, clipName = "sardine_can_shot" }
	createAudio{ fileName = audioPath .. "/sfx/sardine_can_physics_a2", extension = "mp3", alwaysStream = true, clipName = "sardine_can_physics_a2" }
	createAudio{ fileName = audioPath .. "/sfx/mighty_eagle_bounce", extension = "mp3", alwaysStream = true, clipName = "mighty_eagle_thump" }
	createAudio{ fileName = audioPath .. "/sfx/mighty_eagle_fly", extension = "mp3", alwaysStream = true, clipName = "mighty_eagle_fly" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a1", clipName = "piglette_a1" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a2", clipName = "piglette_a2" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a3", clipName = "piglette_a3" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a4", clipName = "piglette_a4" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a5", clipName = "piglette_a5" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a8", clipName = "piglette_a8" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a9", clipName = "piglette_a9" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a10", clipName = "piglette_a10" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a11", clipName = "piglette_a11" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink a12", clipName = "piglette_a12" }
	createAudio{ fileName = audioPath .. "/sfx/star_collect", clipName = "star_collect" }
	createAudio{ fileName = audioPath .. "/sfx/button_radio", clipName = "button_radio" }
	createAudio{ fileName = audioPath .. "/sfx/goldenegg", clipName = "goldenegg" }
	createAudio{ fileName = audioPath .. "/sfx/piano-c", clipName = "noteC" }
	createAudio{ fileName = audioPath .. "/sfx/piano-cis", clipName = "noteCis" }
	createAudio{ fileName = audioPath .. "/sfx/piano-d", clipName = "noteD" }
	createAudio{ fileName = audioPath .. "/sfx/piano-dis", clipName = "notedis" }
	createAudio{ fileName = audioPath .. "/sfx/piano-e", clipName = "noteE" }
	createAudio{ fileName = audioPath .. "/sfx/piano-f", clipName = "noteF" }
	createAudio{ fileName = audioPath .. "/sfx/piano-fis", clipName = "noteFis" }
	createAudio{ fileName = audioPath .. "/sfx/piano-g", clipName = "noteG" }
	createAudio{ fileName = audioPath .. "/music/level_complete", extension = "mp3", alwaysStream = true, clipName = "level_complete" }
	createAudio{ fileName = audioPath .. "/music/game_complete", extension = "mp3", alwaysStream = true, clipName = "game_complete" }
	createAudio{ fileName = audioPath .. "/music/title_theme", extension = "mp3", alwaysStream = true, clipName = "title_theme" }
	createAudio{ fileName = audioPath .. "/music/ambient_white_dryforest", extension = "mp3", alwaysStream = true, clipName = "ambient_theme1" }
	createAudio{ fileName = audioPath .. "/music/ambient_green_jungleish", extension = "mp3", alwaysStream = true, clipName = "ambient_theme2" }
	createAudio{ fileName = audioPath .. "/music/ambient_red_savannah", extension = "mp3", alwaysStream = true, clipName = "ambient_theme3" }
	createAudio{ fileName = audioPath .. "/music/ambient_city", extension = "mp3", alwaysStream = true, clipName = "ambient_theme7" }
	createAudio{ fileName = audioPath .. "/music/birds_outro", extension = "mp3", alwaysStream = true, clipName = "birds_outro" }
	createAudio{ fileName = audioPath .. "/music/birds_intro", extension = "mp3", alwaysStream = true, clipName = "birds_intro" }
	createAudio{ fileName = audioPath .. "/music/birds_boss", extension = "mp3", alwaysStream = true, clipName = "birds_boss" }
	createAudio{ fileName = audioPath .. "/music/funky_theme", extension = "mp3", alwaysStream = true, clipName = "funky_theme" }
	createAudio{ fileName = audioPath .. "/sfx/piglette oink story", clipName = "piglette_oink_story" }
	createAudio{ fileName = audioPath .. "/sfx/ball_bounce", clipName = "ball_bounce" }
	createAudio{ fileName = audioPath .. "/music/ambient_construction", extension = "mp3", alwaysStream = true, clipName = "construction_theme1" }
	createAudio{ fileName = audioPath .. "/sfx/pig_bd", clipName = "pig_bd" }
	createAudio{ fileName = audioPath .. "/sfx/pig_snare_1", clipName = "pig_snare_1" }
	createAudio{ fileName = audioPath .. "/sfx/pig_snare_2", clipName = "pig_snare_2" }
	createAudio{ fileName = audioPath .. "/sfx/pig_snare_3", clipName = "pig_snare_3" }
	createAudio{ fileName = audioPath .. "/sfx/pig_snare_4", clipName = "pig_snare_4" }
	createAudio{ fileName = audioPath .. "/sfx/pig_hi-hat_1", clipName = "pig_hi-hat_1" }
	createAudio{ fileName = audioPath .. "/sfx/pig_hi-hat_2", clipName = "pig_hi-hat_2" }
	createAudio{ fileName = audioPath .. "/sfx/cminor_left", clipName = "cminor_left" }
	createAudio{ fileName = audioPath .. "/sfx/dismajor_left", clipName = "dismajor_left" }
	createAudio{ fileName = audioPath .. "/sfx/fmajor_left", clipName = "fmajor_left" }
	createAudio{ fileName = audioPath .. "/sfx/gminor_left", clipName = "gminor_left" }
	createAudio{ fileName = audioPath .. "/sfx/bmajor_left", clipName = "bmajor_left" }
	createAudio{ fileName = audioPath .. "/sfx/cminor_right", clipName = "cminor_right" }
	createAudio{ fileName = audioPath .. "/sfx/dismajor_right", clipName = "dismajor_right" }
	createAudio{ fileName = audioPath .. "/sfx/fmajor_right", clipName = "fmajor_right" }
	createAudio{ fileName = audioPath .. "/sfx/gminor_right", clipName = "gminor_right" }
	createAudio{ fileName = audioPath .. "/sfx/bmajor_right", clipName = "bmajor_right" }
	createAudio{ fileName = audioPath .. "/sfx/accordion_empty_pull", clipName = "empty_accordion_left" }
	createAudio{ fileName = audioPath .. "/sfx/accordion_empty_push", clipName = "empty_accordion_right" }
	createAudio{ fileName = audioPath .. "/sfx/accordion_break", clipName = "accordion_break" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_1", clipName = "pig_singing_1" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_2", clipName = "pig_singing_2" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_3", clipName = "pig_singing_3" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_4", clipName = "pig_singing_4" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_5", clipName = "pig_singing_5" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_6", clipName = "pig_singing_6" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_7", clipName = "pig_singing_7" }
	createAudio{ fileName = audioPath .. "/sfx/pig_singing_8", clipName = "pig_singing_8" }
	createAudio{ fileName = audioPath .. "/music/ab_cave_ambient", extension = "mp3", alwaysStream = true, clipName = "ambient_cave" }
	createAudio{ fileName = audioPath .. "/sfx/jewel_break_01", clipName = "jewel_break_1" }
	createAudio{ fileName = audioPath .. "/sfx/jewel_break_02", clipName = "jewel_break_2" }
	createAudio{ fileName = audioPath .. "/sfx/jewel_break_03", clipName = "jewel_break_3" }
	createAudio{ fileName = audioPath .. "/sfx/stalaktite_break_01", clipName = "stalaktite_break_1" }
	createAudio{ fileName = audioPath .. "/sfx/stalaktite_break_02", clipName = "stalaktite_break_2" }
	createAudio{ fileName = audioPath .. "/sfx/stalaktite_break_03", clipName = "stalaktite_break_3" }
	createAudio{ fileName = audioPath .. "/sfx/gamescorescreen_score_count_loop", extension = "wav", clipName = "score_count" }
	createAudio{ fileName = audioPath .. "/sfx/star_1", extension = "mp3", alwaysStream = true, clipName = "star_1" }
	createAudio{ fileName = audioPath .. "/sfx/star_2", extension = "mp3", alwaysStream = true, clipName = "star_2" }
	createAudio{ fileName = audioPath .. "/sfx/star_3", extension = "mp3", alwaysStream = true, clipName = "star_3" }
	createAudio{ fileName = audioPath .. "/sfx/highscore", extension = "mp3", alwaysStream = true, clipName = "new_highscore" }
	
	-- GLOBE BIRD REMOVE
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Death_remove_1", extension = "mp3", clipName = "Globe_Bird_Death_remove_1", volume = 1}
	
	-- GLOBE BIRD HIT
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Hit_1", extension = "mp3", clipName = "Globe_Bird_Hit_1", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Hit_2", extension = "mp3", clipName = "Globe_Bird_Hit_2", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Hit_3", extension = "mp3", clipName = "Globe_Bird_Hit_3", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Hit_4", extension = "mp3", clipName = "Globe_Bird_Hit_4", volume = 1}

	-- GLOBE BIRD HIT
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_idle_01", extension = "mp3", clipName = "Globe_Bird_idle_01", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_idle_02", extension = "mp3", clipName = "Globe_Bird_idle_02", volume = 1}		
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_idle_03", extension = "mp3", clipName = "Globe_Bird_idle_03", volume = 1}			
	
	-- GLOBE BIRD LAUNCH
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Launch_3", extension = "mp3", clipName = "Globe_Bird_Launch_3", volume = 1}
	
	-- GLOBE BIRD SPECIAL ACTIVATION
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Special_Activation_1", extension = "mp3", clipName = "Globe_Bird_Special_Activation_1", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Special_Activation_2", extension = "mp3", clipName = "Globe_Bird_Special_Activation_2", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Special_Activation_3", extension = "mp3", clipName = "Globe_Bird_Special_Activation_3", volume = 1}

	-- GLOBE BIRD SELECTION
	createAudio{fileName = audioPath .. "/sfx/Globe_Bird_Selection_1", extension = "mp3", clipName = "Globe_Bird_Selection_1", volume = 1}
	
	-- BIRTHDAY ITEMS
	createAudio{fileName = audioPath .. "/sfx/birthday_ambience", extension = "mp3", clipName = "birthday_ambience", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/birthday_cake1", extension = "mp3", clipName = "birthday_cake1", volume = 1}
	createAudio{fileName = audioPath .. "/sfx/birthday_cake2", extension = "mp3", clipName = "birthday_cake2", volume = 1}
	

	
	audioGroups = {
		--bad_shot = { "bad shot a1", "bad shot a2" },
		bird_01_collision = { "bird 01 collision a1", "bird 01 collision a2", "bird 01 collision a3", "bird 01 collision a4" },
		bird_02_collision = { "bird 02 collision a1", "bird 02 collision a2", "bird 02 collision a3", "bird 02 collision a4", "bird 02 collision a5" },
		bird_03_collision = { "bird 03 collision a1", "bird 03 collision a2", "bird 03 collision a3", "bird 03 collision a4", "bird 03 collision a5" },
		bird_04_collision = { "bird 04 collision a1", "bird 04 collision a2", "bird 04 collision a3", "bird 04 collision a4" },
		bird_05_collision = { "bird 05 collision a1", "bird 05 collision a2", "bird 05 collision a3", "bird 05 collision a4", "bird 05 collision a5" },
		big_brother_collision = { "bird 01 collision a1_low", "bird 01 collision a2_low", "bird 01 collision a3_low", "bird 01 collision a4_low" },
		bird_next = { "bird next a1", "bird next a2", "bird next a3" },
		bird_next_military = { "bird next military a1", "bird next military a2", "bird next military a3" },
		bird_shot = { "bird shot a1", "bird shot a2", "bird shot a3"},
		--good_shot = { "good shot a1", "good shot a2", "good shot a3"},
		--level_clear = { "level clear a1", "level clear a2" },
		level_clear_military = { "level clear military a1", "level clear military a2" },
		--level_failed = { "level failed a1", "level failed a2" },
		level_failed_piglets = { "level failed piglets a1", "level failed piglets a2" },
		--level_start = { "level start a1", "level start a2" },
		level_start_military = { "level start military a1", "level start military a2" },
		light_collision = { "light collision a1", "light collision a2", "light collision a3", "light collision a4", "light collision a5", "light collision a6", "light collision a7", "light collision a8" },
		light_damage = { "light damage a1", "light damage a2", "light damage a3" },
		light_destroyed = { "light destroyed a1", "light destroyed a2", "light destroyed a3" },
		piglette_collision = { "piglette collision a1", "piglette collision a2", "piglette collision a3", "piglette collision a4", "piglette collision a5", "piglette collision a6", "piglette collision a7", "piglette collision a8" },
		piglette_damage = { "piglette damage a1", "piglette damage a2", "piglette damage a3", "piglette damage a4", "piglette damage a5", "piglette damage a6", "piglette damage a7", "piglette damage a8" },
		rock_collision = { "rock collision a1", "rock collision a2", "rock collision a3", "rock collision a4", "rock collision a5" },
		rock_damage = { "rock damage a1", "rock damage a2", "rock damage a3" },
		rock_destroyed = { "rock destroyed a1", "rock destroyed a2", "rock destroyed a3" },
		wood_collision = { "wood collision a1", "wood collision a2", "wood collision a3", "wood collision a4", "wood collision a5", "wood collision a6" },
		wood_damage = { "wood damage a1", "wood damage a2", "wood damage a3" },
		wood_destroyed = { "wood destroyed a1", "wood destroyed a2", "wood destroyed a3" },
		bird_misc = { "bird_misc_a1", "bird_misc_a2", "bird_misc_a3", "bird_misc_a4", "bird_misc_a5", "bird_misc_a6", "bird_misc_a7", "bird_misc_a8", "bird_misc_a9", "bird_misc_a10", "bird_misc_a11", "bird_misc_a12" },
		--piglette_snoring = { "piglette snoring a1", "piglette snoring a2", "piglette snoring a3", "piglette snoring a4", "piglette snoring a5" },
		piglette = { "piglette_a1", "piglette_a2", "piglette_a3", "piglette_a4", "piglette_a5", "piglette_a8", "piglette_a9", "piglette_a10", "piglette_a11", "piglette_a12" },
		--, "piglette_a6", "piglette_a7"
		red_special = { "red_special_1", "red_special_2", "red_special_3" },
		--big_brother_special = { "big_brother_special_1", "big_brother_special_2", "big_brother_special_3" },
		big_brother_special = { "big_brother_special_1", },
		pig_accordion = {"pig_singing_1", "pig_singing_2", "pig_singing_3", "pig_singing_4", "pig_singing_5", "pig_singing_6", "pig_singing_7", "pig_singing_8" },
		stalaktite_break = {"stalaktite_break_1", "stalaktite_break_2", "stalaktite_break_3" },
		jewel_break = {"jewel_break_1", "jewel_break_2", "jewel_break_3" },
		
		globe_hit = { "Globe_Bird_Hit_1", "Globe_Bird_Hit_2", "Globe_Bird_Hit_3", "Globe_Bird_Hit_4"},
		globe_special = { "Globe_Bird_Special_Activation_1", "Globe_Bird_Special_Activation_2", "Globe_Bird_Special_Activation_3"},
		birthday_cake = { "birthday_cake1", "birthday_cake2"},
		
	}
	
	currentMainMenuSong = "title_theme"

	if not settingsWrapper:isAudioEnabled() then
		_G.res.stopAudioOutput()
		setEffectsVolume(0)
		setMusicVolume(0)
	else
		_G.res.startAudioOutput()
		setEffectsVolume(1)
		setMusicVolume(1)
	end

	if(showEditor == false) then
		for k,v in _G.pairs(blockTable.themes) do
			if k == settingsWrapper:getCurrentMainMenuTheme() then
				loadThemeGraphics(k)
				break
			end
		end
	else
		loadAllThemeGraphics()
	end

	--loadAllThemeGraphics()
	
	assetsCreated = true
end 

function saveLuaFileWrapper(fileName, tableName, appData)
	if isLiteVersion == true and deviceModel == "s60" then
		if tableName == "settings" then
			fileName = "settings_trial.lua"
		end
		
		if tableName == "highscores" then
			fileName = "highscores_trial.lua"
		end
	end
	
	saveLuaFile(fileName, tableName, appData)

	if tableName == "settings" and ABIDEnabled then
	
		if localSettings ~= nil then
			saveLuaFile("localSettings.lua", "localSettings", true)			
		end
		--[[
		if ABIDSettingsServerState ~= nil then
			saveLuaFile("ABIDSettingsServerState.lua", "ABIDSettingsServerState", true)			
		end
		
		if ABIDHighscoresServerState ~= nil then			
			saveLuaFile("ABIDHighscoresServerState.lua", "ABIDHighscoresServerState", true)				
		end]]
		
		if purchases ~= nil then
			saveLuaFile("purchases.lua", "purchases", true)		
		end
	end	
end

function getAudioName(name)
	if audioGroups[name] ~= nil then
		local index = _G.math.random(1, #audioGroups[name])
		return audioGroups[name][index]
	end

	return name
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Game main function, this is called every frame by the engine
--void GameLua::drawLine2D(float x0, float y0, float x1, float y1, float w, float r, float g, float b, float a)
function drawLine(r,g,b,a,x1,y1,x2,y2,inWorld, lineSize)
	local lz = lineSize or 1
	
	if(inWorld == false) then
		setRenderState(0,0,1,1)
	end
	
	drawLine2D(x1,y1,x2,y2,lz,r,g,b,a)
end

-- XXX: ADD TO OTHERS
function drawString(text, scale,x,y, anchorX, anchorY, inWorld)
	local ax = anchorX or "HCENTER"
	local ay = anchorY or "VCENTER"
	
	--void GameLua::drawRect( float r, float g, float b, float a, float x1, float y1, float x2, float y2, bool inWorld)
	--drawRect(1.0,1.0,1.0,1.0, 0,screenHeight / 2 + 1, screenWidth, screenHeight / 2 , false)
	--drawLine(255,255,255,255,0,0, screenWidth, screenHeight, false, 12)
	setFont(fontBasic);
	--setRenderState(x * scale, y * scale, scale,scale)
	if(inWorld ~= true) then
		setRenderState(0, 0 , scale,scale)	
		_G.res.drawString("", text, x * ((screenWidth / scale) / screenWidth), y * ((screenHeight / scale) / screenHeight), ay, ax)
	else
		local xp,yp = worldToScreenTransform(x,y)
		scale = scale * worldScale
		setRenderState(0,0,scale,scale,0,0)	
		_G.res.drawString("", text, xp * ((screenWidth / scale) / screenWidth), yp * ((screenHeight / scale) / screenHeight), ay, ax)
	end
	setRenderState(0,0,1,1)
end

showFps = false

if not releaseBuild or cheatsEnabled then
	showFps = true
end

showBG = true
showSleepingObjects = false

fpsTimer = 0
fpsFrames = 0
fps = 0
zoomLevel = 0

function initCollisionDummy(selectedObject)
	local name = selectedObject.name
	--local name = selectedObjects[1].name
	local selected = objects.world[name]
	local blockDef = blockTable.blocks[selected.definition]
	local dir = 1
			
	adjustedBlockDef = adjustedBlockDef or {}
	adjustedBlockDef.objectNames = adjustedBlockDef.objectNames or {}
	
	adjustedBlockDef.objectNames[name] = adjustedBlockDef.objectNames[name] or {}
			-- Initialize dummy
	if(adjustedBlockDef.objectNames[name].radius == nil and blockDef.radius) then
		adjustedBlockDef.objectNames[name].radius = blockDef.radius			
	end
    
	if(adjustedBlockDef.objectNames[name].spritePivotX == nil and blockDef.spritePivotX) then
		adjustedBlockDef.objectNames[name].spritePivotX = blockDef.spritePivotX			
	end
    
	if(adjustedBlockDef.objectNames[name].spritePivotY == nil and blockDef.spritePivotY) then
		adjustedBlockDef.objectNames[name].spritePivotY = blockDef.spritePivotY			
	end
				
	if(adjustedBlockDef.objectNames[name].width == nil and blockDef.width) then
		adjustedBlockDef.objectNames[name].width = blockDef.width			
	end

	if(adjustedBlockDef.objectNames[name].height == nil and blockDef.height) then
		adjustedBlockDef.objectNames[name].height = blockDef.height			
	end
			
	if(adjustedBlockDef.objectNames[name].vertices == nil and blockDef.vertices ~= nil) then
		--adjustedBlockDef.objectName.height = blockDef.height			
		adjustedBlockDef.objectNames[name].vertices = {}
		for k,v in _G.pairs(blockDef.vertices) do					
			_G.table.insert(adjustedBlockDef.objectNames[name].vertices, {x = v.x, y = v.y})
		end
	end
end

function updateIapInitTimer(dt)
	-- iap init timer handling
	if iapInitTimer ~= nil then
		iapInitTimer = iapInitTimer - dt
		--print(iapInitTimer .. "\n")
		if iapInitTimer <= 0 then
			iapInitTimer = nil
			iapBuyItem(mightyEagleItemId, "inAppPurchaseBuyCallback")
		end
	end
end

function update(dt, realDt)
	
	local localDelta = dt or 0
	
	if releaseBuild ~= true and keyReleased["F5"] then		
		loadFiles()
	end		
	
	if g_hatcheryEnabled == true and g_hatcheryServerTimeSync["timeToRequest"] >= g_hatcheryServerTimeSync["totalRequestWaitTime"] then
		requestCurrentTimeOnServer()
		g_hatcheryServerTimeSync["timeToRequest"] = 0
	elseif g_hatcheryEnabled == true and g_hatcheryServerTimeSync["timeToRequest"] > -1 then
		g_hatcheryServerTimeSync["timeToRequest"] = g_hatcheryServerTimeSync["timeToRequest"] + dt
	end		

	
	if g_hatcheryLocalTimeCompared == nil and settings.hatcheryLocalTime ~= nil then
		g_hatcheryLocalTimeCompared = true
		
		local currentTime = getCurrentTime()
		
		g_hatcheryTimeBackwardsDetected = false
		
		--its not safe to just perform a subtraction on the seconds, if the user has spend a lot of time away, the number of seconds might not fit
		--into the number type so it could loop back from zero
		if settings.hatcheryLocalTime.year > currentTime.year then
			g_hatcheryTimeBackwardsDetected = true
		elseif settings.hatcheryLocalTime.year == currentTime.year then
			if settings.hatcheryLocalTime.month > currentTime.month then
				g_hatcheryTimeBackwardsDetected = true
			elseif settings.hatcheryLocalTime.month == currentTime.month then
				if settings.hatcheryLocalTime.day > currentTime.day then
					g_hatcheryTimeBackwardsDetected = true
				elseif settings.hatcheryLocalTime.day == currentTime.day then
					if settings.hatcheryLocalTime.minutes > currentTime.minutes then
						g_hatcheryTimeBackwardsDetected = true
					elseif settings.hatcheryLocalTime.minutes == currentTime.minutes then
						if settings.hatcheryLocalTime.seconds > currentTime.seconds then
							g_hatcheryTimeBackwardsDetected = true							
						end
					end
				end
			end
		end
		
	end
	
	
	
	if ABIDEnabled then
		if ABIDSubSystem ~= nil then
			ABIDSubSystem:update(dt,realDt)
		end
	end
	
	
	if keyReleased["F7"] then
		--menuManager.currentRoot:onKeyEvent("RELEASE", "BACK")
		
		 --[[	
		local world = 2
		local episode = 1
		local levelNumber = 3
		local levelName = g_episodes[1].pages[world].levels[levelNumber].name
		loginfo("CHANGING LEVEL TO " ..levelName)
		 
		local meta = {
			episode = episode,
			page = world,
			level = levelNumber,
			levelName = levelName
		}
		 
		eventManager:notify({id = events.EID_CHANGE_LEVEL, data = meta})]]
		 
	end
	
	updateAudioRamp(dt)
	
	if loadFrameCount ~= nil and loadFrameCount > 0 then
		loadFrameCount = loadFrameCount - 1
		if loadFrameCount == 0 then
			loadLevelInternal(levelFolder .. levelName)			
		end
	end
	
	g_dt = dt
	g_time = g_time and g_time + dt or 0
	
	if settingsWrapper ~= nil and settingsWrapper:getEagleUsedTime() ~= nil and eventManager ~= nil then
		if timeDiff(currentTime(), settingsWrapper:getEagleUsedTime()) >= eagleLockedTime then 
			print("Mighty eagle available again!\n")
			eventManager:notify({id = events.EID_MIGHTY_EAGLE_AVAILABLE})	
			--oldEagleButtonStatusDisabled = false
			
			eagleInfoTimer = nil
			settingsWrapper:setEagleUsedTime(nil)			
			settingsWrapper:resetEaglesUsedIn()			
		end
	end

	if menuManager ~= nil then		
		
		--small hack, sometimes we need to draw both scenes, the hacthery and menumanager
		
		if g_hatcheryEnabled and Hatchery.isHatcheryVisible() == true then
			local returnEvent = Hatchery.update(dt, time)
			
			if Hatchery.isHatcheryViewVisible() ~= true and returnEvent ~= "HATCHERY_RETURN" then
				menuManager:update(dt, time)
			end
		else
			menuManager:update(dt, time)
		end
	end

	
 	if adSystem ~= nil then
		adSystem:update(dt,time)
	end
	
	
	if(releaseSplashes == true and mainMenu ~= nil and currentMenuPage ~= nil and currentMenuPage == mainMenu) then
		releaseImages( {"SPLASHES"} )
		releaseSplashes = false
	end

	for i = 1, #subSystemsList do
		subSystemsList[i]:update(dt)
	end
	
	if eventManager ~= nil then
		eventManager:tick()	
	end
	processManager:update(dt)	

	if(releaseBuild == false) then
		if(keyHold["CONTROL"]) then
			if(keyPressed["1"]) then
				changeLocale("en_EN")
			elseif(keyPressed["2"]) then
				changeLocale("fr_FR")
			elseif(keyPressed["3"]) then
				changeLocale("it_IT")
			elseif(keyPressed["4"]) then
				changeLocale("de_DE")
			elseif(keyPressed["5"]) then
				changeLocale("es_ES")
			elseif(keyPressed["6"]) then
				changeLocale("zh_CN")
			elseif(keyPressed["7"]) then
				changeLocale("zh_TW")
			elseif(keyPressed["8"]) then
				changeLocale("ja_JA")
			elseif(keyPressed["9"]) then
				changeLocale("pt_PT")
			elseif(keyPressed["0"]) then
				changeLocale("pl_PL")
		--	elseif(keyPressed["q"]) then
			--	changeLocale("pt_BR")
			end
		end


		if(keyPressed["K"]) then
			unlockMightyEagleNFC()
		end
		
		if keyHold["G"] and keyPressed["C"] or keyPressed["G"] and keyHold["C"] then
			debugShowGameCenter = not debugShowGameCenter
			print("debugShowGameCenter set to " .. _G.tostring(debugShowGameCenter) .. "\n")
			if debugShowGameCenter then
				enableGameCenter()
			else
				disableGameCenter()
			end
		end
	end
	
	--[[
	if (oldScreenWidth ~= screenWidth or oldScreenHeight ~= screenHeight) and deviceModel == "iphone4" then
		-- iphone4 changes screen resolution between 960x640 and 480x320 resolution so the cameras and floating scores scaling need to be reset after resolution change
		if objects.castleCameraData ~= nil and objects.castleCameraData[deviceModel] ~= nil then
			resetCameras()
			for i = 1, #floatingScores do
				floatingScores[i].xs = floatingScores[i].xs * ( screenWidth / oldScreenWidth)
			end
		end
	end
	]]--

	if prepareMenusAfterAd == true then
		prepareMenusAfterAd = false
		if birdTutorialPopups ~= nil and #birdTutorialPopups > 0 then
			prepareMenuPage(tutorials)
		end
		if currentMenuPage ~= nil then
			prepareMenuPage(currentMenuPage)	
		end
		if popupPage ~= nil then
			prepareMenuPage(popupPage)
		end
	end

	if newMenuPageNeedsPrepare == true or currentMenuPage ~= newMenuPage then
		setActiveMenuPageDelayed(newMenuPage, newMenuPageNeedsPrepare, newMenuPageResumed)
		newMenuPageNeedsPrepare = nil
	end
	
	
	if additionalPopupPageDelay ~= true and newPopupPage ~= nil and popupPage ~= newPopupPage then
		popupPage = newPopupPage
		if popupPage == upsellPage then
			releaseCutScenes()
		end
		
		if newPopupPageNeedsPrepare ~= false then
			prepareMenuPage(popupPage)
			if popupPage == goldenEggAchievedPage then
				print("goldenEggAchievedPage prepared\n")
			end
		end
		print("popup delayed: "..popupPage.name)
		newPopupPageNeedsPrepare = nil
		newPopupPage = nil
	end
	
	if additionalPopupPageDelay == true then
		additionalPopupPageDelay = nil
	end

	-- Initialize current game mode to splash sequence
	currentGameMode = currentGameMode or updateSplashes

	-- Keep track of elapsed time
	time = time and time + dt or 0
	playtimeCounter = playtimeCounter and playtimeCounter + dt or 0
	if lastVideoAdTime == nil then
		lastVideoAdTime = time
	end
	
	updateIapInitTimer(dt)
	
	
	if settingsWrapper:getEagleUsedTime() ~= nil then
		local timeLeft = eagleLockedTime - timeDiff(currentTime(), settingsWrapper:getEagleUsedTime())
		
		if timeLeft > 0 and timeLeft <= 5 and (eagleInfoTimer == nil or eagleInfoTimer < timeLeft) then
			eagleInfoTimer = timeLeft
		end
		
--		if eagleInfoTimer ~= nil and (currentMenuPage == pausePage or currentGameMode == updateGame) then
		if eagleInfoTimer ~= nil and currentGameMode == updateGame then
			eagleInfoTimer = eagleInfoTimer - dt
			--[[
			if levelFailed ~= nil and levelFailed.items ~= nil and currentMenuPage == levelFailed and 
			   getItemByName(levelFailed.items, "buttonEagleLost").visible == true then
				local eagleTimeLeft = getItemByName(levelFailed.items, "eagleTimeLeft")
				eagleTimeLeft.text = formatTime(timeLeft)
				prepareTextItem(levelFailed, eagleTimeLeft)
				eagleTimeLeft.visible = true
				if eagleInfoTimer < 0 or timeLeft < 1 then
					eagleTimeLeft.visible = false
					eagleInfoTimer = nil
				end]]
			--elseif eagleInfoTimer < 0 then 
			if eagleInfoTimer < 0 then 			
				eagleInfoTimer = nil
			end
		end
	end
	
	-- Check for double clicks
	doubleClick = false
	
	if doubleClickTimer == nil then
		doubleClickTimer = 0
	end
	
	
	if keyPressed["LBUTTON"] then
		if doubleClickState ~= 2 then
			doubleClickState = 1
			doubleClickTimer = 0.5
		else
			doubleClickState = 3
		end
	elseif doubleClickTimer > 0 and keyReleased["LBUTTON"] then
		if doubleClickState == 1 then
			doubleClickState = 2
		elseif doubleClickState == 3 then
			doubleClick = true
		end
	end
	
	doubleClickTimer = doubleClickTimer - dt
	if doubleClickTimer <= 0 then
		doubleClickTimer = 0
		doubleClickState = 0
	end
	
	
	-- Update current "game scene"
	currentGameMode(dt, time)
	
	if menuManager ~= nil then
	
		if g_hatcheryEnabled then			
			
			if Hatchery.isHatcheryViewVisible() ~= true then
			
				--this means the ingame hatchery bar is visible, when the game is at this stage the update method is updateMenu (change later)
				if Hatchery.isHatcheryVisible() == true and currentGameMode == updateMenu then
					drawGame()
				end
				
				menuManager:draw()	
			end
			
			if Hatchery.isHatcheryVisible() == true then
				Hatchery.draw()
			end
			
			
		else
			menuManager:draw()	
		end
				
	end

	if keyPressed["F"] then
		showFps = not showFps
	end

	if keyPressed["9"] then
		showBG = not showBG
	end

	if keyPressed["8"] then
		showSleepingObjects = not showSleepingObjects
	end
	
	if iOS and achievementProcessor ~= nil then		
		if #achievementProcessor.achievementUnlockQueue > 0 then
			if lastAchievementUnlockTime == nil then
				lastAchievementUnlockTime = -3
			end
			
			if time - lastAchievementUnlockTime > 3 then
				if gameCenterEnabled then
					if gameCenter and gameCenter.achievements and gameCenter.achievements.loading ~= true then
						achievementProcessor:unlockNextAchievement()
						lastAchievementUnlockTime = time
					end
				else
					achievementProcessor:unlockNextAchievement()
					lastAchievementUnlockTime = time
				end
			end
		end
	
		if checkForCrystalEnabled == true and userEnabledCrystal() == true then
			checkForCrystalEnabled = false
			showCrystalInMainMenu = true
			activateCrystalUIAtProfile()
		end
	end
	
	if oldScreenWidth ~= screenWidth or oldScreenHeight ~= screenHeight then
		oldScreenWidth = screenWidth
		oldScreenHeight = screenHeight
	end
	
	local animateTime = 0.4
	
	
	--if currentGameMode == updateGame then
	--	hud:update(dt,time)
	--	hud:draw(0,0)			
	--end
	
	
	
	notificationsFrame:update(dt,time)
	notificationsFrame:draw()
	setRenderState(0,0,1,1,0,0)

	if showFps and assetsCreated == true then
		if fpsTimer >= 1 then
			fps = fpsFrames / fpsTimer
			fpsTimer = 0
			fpsFrames = 0
		end
		fpsString = _G.string.format("%.1f", fps)
		setFont(fontBasic);
		_G.res.drawString("", fpsString, screenWidth*0.5, screenHeight, "BOTTOM", "HCENTER")
		fpsTimer = fpsTimer + realDt
		fpsFrames = fpsFrames + 1
	end
	
	if rovioNewsSubSystem ~= nil then
		if rovioNewsSubSystem.testRovioNews then
			rovioNewsSubSystem:draw(0,0)
		end
	end
	
	if adSystem ~= nil and testAds then
		adSystem:debugDraw()
	end
	
end 

counter = 1

function updateAudioRamp(dt)
	if audioRampVolume then
		audioRampVolume = audioRampVolume + (dt / audioRampLength)
		
		if audioRampVolume <= 0 then
			_G.res.stopAudioOutput()
			audioRampVolume = nil
		elseif audioRampVolume > 1 then
			audioRampVolume = nil
		else
			-- Use squared volume because it gives more linear response
			setMusicVolume( audioRampVolume * audioRampVolume )
			setEffectsVolume( audioRampVolume * audioRampVolume )
		end
	end
end





------------------------------------------------------------------------------
--	function to remove ads after purchase (available on Android devices)	--
------------------------------------------------------------------------------
function removeAds()
	hideAd()
	stopAds()
	settingsWrapper:setPremium(true)
	saveLuaFileWrapper("settings.lua", "settings", true)
end

function gameResumed()
	getCurrentLocale()
	
	-- Hide any visible banner ad (chances are we have clicked it already).
	if shouldShowAd() then
		hideAd()
	end
	
	if currentMenuPage ~= nil then
		setActiveMenuPage(currentMenuPage, true, true)
	end
		
	
	if(popupPage ~= nil) then
		prepareMenuPage(popupPage)
	end

	if currentBirdIndex and rubberBandPos and levelStartPosition then
		rubberBandPos.x, rubberBandPos.y = levelStartPosition.x, levelStartPosition.y
		rubberBandLength = 0
		dragStarted = false
	end
	
	if gameCenterEnabled and gameCenter and gameCenter.leaderboards and leaderboards and g_menuInitialised then
		refreshLocalGameCenterData()
		postTotalHighScores()
	end
	
	if menuManager ~= nil then
		menuManager:gameResumed()
	end
	
	
	if eventManager ~= nil and not startedFromEditor then
		local mode = ""
		if currentGameMode == updateGame then
			mode = "INGAME"
		end
		eventManager:notify({id = events.EID_GAME_RESUMED, mode = mode, })
	end
	
end

function gamePaused()
	
	calculatePlaytime()
	saveLuaFileWrapper("settings.lua", "settings", true)

	if eventManager ~= nil and not startedFromEditor then
		local mode = ""
		if currentGameMode == updateGame then
			mode = "INGAME"
		end
        eventManager:queueEvent({id = events.EID_GAME_PAUSED, mode = mode, })
    end

	if birdTutorialPopups ~= nil and #birdTutorialPopups == 0 and updateGame ~= nil and currentGameMode ~= nil and currentGameMode == updateGame and not startedFromEditor then
		setPhysicsEnabled(false)
		setGameMode(function() end)
		--[[
		if deviceModel == "iphone4" then
			wantedResolution = "HALF" 
			changeResolution = true	
		end
		]]--
	end
end

function setFont(fontName)
	_G.res.useFont(fontName)
end

function setGameMode(gameMode)
	currentGameMode = gameMode
	if currentGameMode == updateGame then
		setGameOn(true)
		avoidCrystalBackgroundActivity(true)
	else
		setGameOn(false)
		avoidCrystalBackgroundActivity(false)
	end
end

function setActivePopupPage(popupPage, prepare, info)	
	newPopupPage = popupPage
	--[1.5.4
	if(popupPage == mightyEagleDemoPage and info ~= nil) then
		print("(1.5.4) mighty eagle demo page opened from "..info.."\n")
		logFlurryEventWithParam("ME: popup opened", "From", info)	
	end
	
	-- Checked just in case..
	if(newPopupPage ~= nil and info ~= nil) then
		print("(1.5.4) INFO FOR POPUP PAGE = "..info.."\n")
		newPopupPage.info = info	
	end
	
	-- 1.5.4]
	newPopupPageNeedsPrepare = prepare
end

function changeSliderStatus()
	local buttonSliderBG = getItemByName(mainMenu.items, "buttonSliderBG")
	local sliderBGRight = getItemByName(mainMenu.items, "sliderBGRight")
	if buttonSliderBG.state == "closed" then
		sliderBGRight.visible = true
		buttonSliderBG.state = "opening"
	elseif buttonSliderBG.state == "open" then
		buttonSliderBG.state = "closing"
	end
end

function changeOptionSliderStatus()
	local buttonSliderBGOptions = getItemByName(mainMenu.items, "buttonSliderBGOptions")
	local sliderBGLeft = getItemByName(mainMenu.items, "sliderBGLeft")
	if buttonSliderBGOptions.state == "closed" then
		sliderBGLeft.visible = true
		buttonSliderBGOptions.state = "opening"
	elseif buttonSliderBGOptions.state == "open" then
		buttonSliderBGOptions.state = "closing"
	end
end

function setActiveMenuPage(menuPage, prepare, resume)
	--print("setActiveMenuPage: "..menuPage.name)
	newMenuPage = menuPage
	newMenuPageNeedsPrepare = prepare
	newMenuPageResumed = resume
	if newMenuPage ~= nil and newMenuPage.bgColor ~= nil then
		setBGColor(newMenuPage.bgColor.red, newMenuPage.bgColor.green, newMenuPage.bgColor.blue)
	end
end

function setActiveMenuPageDelayed(menuPage, prepare, resumed)
	oldMenuPage = currentMenuPage
	
	currentMenuPage = menuPage
		
	if prepare ~= false and currentMenuPage ~= nil then
		prepareMenuPage(currentMenuPage, resumed)
	end
	
	if showCrystalInMainMenu then
		if menuPage == mainMenu then
			activateCrystalUI()
		else
			playerInitializedCrystalUiDeactivation = false
			deactivateCrystalUI()
		end
	end
end

function crystalUiDeactivated()
	if playerInitializedCrystalUiDeactivation ~= false then
		showCrystalInMainMenu = false
	end
	
	playerInitializedCrystalUiDeactivation = true
end

function goldenEggAchieved(level)
	if not settingsWrapper:isGoldenEggUnlocked(level) then
		settingsWrapper:unlockGoldenEgg(level)
		highscores[level] = {completed = false, birds = 0, score = 0, lowScore = 0}
		saveLuaFileWrapper("highscores.lua", "highscores", true)
		saveLuaFileWrapper("settings.lua", "settings", true)
		--additionalPopupPageDelay = true
		--setActivePopupPage(goldenEggAchievedPage)
		
		showRewardPopup("GOLDEN_EGG")
		
		eventManager:notify({id = events.EID_GOLDEN_EGG_GAINED, data = {openedLevelsAmount = calculateOpenGoldenEggLevels()}})
		
		--[[
		if deviceModel == "iphone4" then
			changeResolution = true
			wantedResolution = "HALF"
			print("change resolution to half\n")
		end
		]]--
	end
end

function showAchievementPopUp()

	local show_gamecenter_popups = true
	
	if show_gamecenter_popups then
		if gameCenterEnabled and gameCenter and gameCenter.achievements 
		  and gameCenter.achievements.showPopUpID then
			local achi = gameCenter.achievements[gameCenter.achievements.showPopUpID]
			if achi then
				--[[
				if deviceModel == "iphone4" and currentGameMode ~= updateMenu then
						changeResolution = true
						wantedResolution = "FULL"
				end	
				]]--
	
				local achievementBox = AchievementPopup:new(gameCenter.achievements.showPopUpID)
				achievementBox.name = "achievement"
				notificationsFrame:addChild(achievementBox)
				--temp
				achievementBox:onEntry()
				achievementBox:layout()
				
				if currentGameMode == updateGame then
					setPhysicsEnabled(true)
				end
			end
		end
	end
end

function goldenEggStarAchieved(level)
	
	local first_time

	--setActivePopupPage(goldenEggStarAchievedPage)
	--goldenEggStarAchievedPage.currentLevel = level
	
	if highscores[level] and highscores[level].completed then
		--goldenEggStarAchievedPage.items[1].sprite = "BIG_STAR_2"
		--goldenEggStarAchievedPage.items[2].visible = false
		--goldenEggStarAchievedPage.items[1].alpha = 0.65
		first_time = false
	else
		--goldenEggStarAchievedPage.items[1].sprite = "BIG_STAR_2"
		--goldenEggStarAchievedPage.items[2].visible = true
		--goldenEggStarAchievedPage.items[1].alpha = nil
		--_G.res.playAudio("star_collect", 1, false)
		first_time = true
	end
	
	eventManager:notify({ id = events.EID_STAR_POPUP, first_time = first_time })
	
	if highscores[level] ~= nil then
		highscores[level].completed = true
	else
		highscores[level] = {completed = true, birds = 0, score = 0, lowScore = 0}
	end
	saveLuaFileWrapper("highscores.lua", "highscores", true)
	saveLuaFileWrapper("settings.lua", "settings", true)
	
	eventManager:notify({id = events.EID_GOLDEN_EGG_STAR_GAINED, data = {starsGained = calculateStarsFromGoldenEggLevels(), levelName = level}})
end

function aboutGoldenEggAchieved()
	goldenEggAchieved("LevelGE_14")
end

function episode3LevelSelectionEggAchieved()
	--levelSelectionPagesPack3.items.goldenEgg.visible = false
	goldenEggAchieved("LevelGE_7")
end

function mightyEagleNotificationCallback()
	settingsWrapper:resetEaglesUsedIn()
	settingsWrapper:setEagleUsedTime(nil)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mode for splash sequences

function updateSplashes(dt, time)
	
	
	-- Initialize on first time
	if splashTimer == nil then
		splashTimer = 0
		current = 1
		splashes = { 	{ sprite = "SPLASH_CLICKGAMER", time = 2, bgColor = { red = 255, green = 255, blue = 255} },
						{ sprite = "SPLASH_ROVIO", time = 3, bgColor = { red = 255, green = 255, blue = 255}},
						{ sprite = "SPLASH_ANGRY_BIRDS", time = 1, bgColor = { red = 0, green = 0, blue = 0}} }
		
		if isKorea then
			_G.table.insert(splashes, 2, { sprite = "KOREA_IMAGE_1", time = 3, bgColor = { red = 255, green = 255, blue = 255}})
		end
		
		if deviceModel == "bada" then
			current = 3
		elseif deviceModel ~= "iphone" and deviceModel ~= "ipad" and deviceModel ~= "iphone4" then
			current = 2
		end
		
		loadingSplash = 3
		if(isKorea == true) then
			loadingSplash = 4
		end
	end

	-- Update timer
	splashTimer = splashTimer + dt
	
	if keyPressed["LBUTTON"] and splashes[current].sprite ~= "KOREA_IMAGE_1" then
		splashTimer = splashes[current].time + 1
	end

	
	local sw, sh = _G.res.getSpriteBounds("", splashes[current].sprite)
	local scale = false
	local xs, ys = 1, 1
	local xCoord, yCoord =  screenWidth / 2, screenHeight / 2
	if splashes[current].sprite == "SPLASH_ROVIO" and screenHeight * 0.8 < sh then
		scale = true
		ys = screenHeight / sh
		xs = screenHeight / sh
		local newWidth = sw * xs
		if newWidth > screenWidth then
			ys = screenWidth / sw
			xs = screenWidth / sw
		end
	elseif splashes[current].sprite ~= "SPLASH_ROVIO" and splashes[current].sprite ~= "KOREA_IMAGE_1" and screenHeight ~= sh then
		if splashes[current].sprite ~= "SPLASH_CLICKGAMER" and deviceModel ~= "ipad" then
			scale = true
			ys = screenHeight / sh
			xs = screenHeight / sh
			local newWidth = sw * xs
			if newWidth > screenWidth then
				ys = screenWidth / sw
				xs = screenWidth / sw
			end
		end
	end
			
	if scale then
		setRenderState(0, 0, xs, ys)
		_G.res.drawSprite("", splashes[current].sprite, _G.math.floor(xCoord / xs), _G.math.floor(yCoord / ys))
		if splashes[current].sprite == "SPLASH_ANGRY_BIRDS" then
			if (isBetaVersion and deviceModel == "android") or isLiteVersion then
				_G.res.drawSprite("", "LITE_SPLASH", _G.math.floor(xCoord / xs), _G.math.floor(yCoord / ys))
			end
			--setRenderState(0, 0, 1, 1)
			if isBetaVersion and deviceModel == "android" then
				_G.res.drawSprite("", "SPLASH_LOADING", screenWidth, screenHeight)
			else
				_G.res.drawSprite("", _G.res.getString("TEXTS_BASIC", "TEXT_SPLASH_LOADING_SPRITE"), screenWidth / xs, screenHeight / ys)
			end		
		end
		setRenderState(0, 0, 1, 1)
	else
		_G.res.drawSprite("", splashes[current].sprite, screenWidth/2, screenHeight/2)
		-- loading text in different languages
		if splashes[current].sprite == "SPLASH_ANGRY_BIRDS" then
			_G.res.drawSprite("", _G.res.getString("TEXTS_BASIC", "TEXT_SPLASH_LOADING_SPRITE"), screenWidth, screenHeight)
			if (isBetaVersion and deviceModel == "android") or isLiteVersion then
				_G.res.drawSprite("", "LITE_SPLASH", screenWidth / 2, screenHeight / 2)
				_G.res.drawSprite("", "SPLASH_LOADING", screenWidth, screenHeight)
			end
		elseif splashes[current].sprite == "KOREA_IMAGE_1" then
			_G.res.drawSprite("", "KOREA_IMAGE_2", screenWidth - 30, screenHeight - 35)
		end
	end
	
	
	
	if current >= loadingSplash and splashTimer > dt and assetsCreated ~= true then
		if (isLiteVersion or deviceModel == "android") and not settingsWrapper:isPremium() then
			requestAndShowVideo()
		end
		createAssets()
	end
	
	-- Change sprite if showed long enough
	if splashTimer > splashes[current].time then
		splashTimer = 0
		current = current + 1
		if splashes[current] ~= nil then
			setBGColor(splashes[current].bgColor.red, splashes[current].bgColor.green, splashes[current].bgColor.blue)
		end
		if current > #splashes then
			initialize()
			setTheme(settingsWrapper:getCurrentMainMenuTheme())
			if not settingsWrapper:isGfxLowQuality() then
				drawBackgroundNative()	
				-- ugly fix.. draw the splash page again there, since drawBackgroundNative draws the game on top of the splash a little bit
				-- ugly fix of an ugly fix!
				if scale then
					setRenderState(0,0,xs,ys,0,0)
					_G.res.drawSprite("", "SPLASH_ANGRY_BIRDS", _G.math.floor((screenWidth / 2) / xs), _G.math.floor((screenHeight / 2) / ys))
				else
					setRenderState(0,0,1,1,0,0)
					_G.res.drawSprite("", "SPLASH_ANGRY_BIRDS", screenWidth / 2, screenHeight / 2)
				end		
			end
			setGameMode(updateMenu)
		end
	end

end

-- change ingame settings here so that the settings are refreshed properly
function updateValues()
	defaultForce = -925.0
	boostForce = defaultForce
	collisionParticleForceThreshold = 10
	collisionSoundForceThreshold = 3
	blockDestroyedScoreIncrement = 500
	pigletteDestroyedScoreIncrement = 5000
	birdsLeftScoreIncrement = 10000
	hardLimitSimultaneousParticles = 150
	softLimitSimultaneousParticles = 75
end


-------------
--Scene-class
-------------

Scene = {}

function Scene:new(o)
	o = o or {}
	o.pages = {}
	o.order = {}
	_G.setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

function Scene:init() end

function Scene:onEntry() 
	for i = 1, #self.order do
		self.pages[self.order[i]]:onEntry()
	end
end

function Scene:onExit() 
	for i = 1, #self.order do	
		self.pages[self.order[i]]:onExit()
	end
end

function Scene:insertPage(key, page, pushback)
	--self:setPageDefaults(page)
	if not pushback then
		_G.table.insert(self.order, key)
		self.pages[key] = page
	else
		local index = self:getIndexOfPage(pushback)
		if index then
			_G.table.insert(self.order, index, key)
			self.pages[key] = page
		end
	end	
end

function Scene:removePage(key)
	local index = self:getIndexOfPage(key)
	if index then
		_G.table.remove(self.order, index)
		for i, v in _G.ipairs(self.pages) do
			if v == self.pages.key then
				_G.table.remove(self.pages, i)
				return
			end
		end
	end
end

function Scene:getIndexOfPage(name)
	for i = 1, #self.order do
		if self.order[i] == name then
			return i
		end
	end
	return false
end

function Scene:update(dt, time)
	if self.visible ~= false then
		for k, v in _G.pairs(self.order) do
			if self.pages[v].visible ~= false then				
				self.pages[v]:update(dt, time)
			end
		end
	end
end

function Scene:draw()
	if self.visible ~= false then
		for k, v in _G.pairs(self.order) do
			if self.pages[v].visible ~= false then
				self.pages[v]:draw()
			end
		end
	end
end

function initialize()
	_G.math.randomseed(_G.os.time())
	
	if g_notificationsEnabled then
		magic.initializeNotification()
	end
	
	numberKeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

	-- these coordinates are the screen in world space, scaling affects here
	screen = { x = screenWidth*0.5, y = screenHeight*0.5, top = 0, left = 0, bottom = screenHeight, right = screenWidth }

	if showCameraDebugData then
		visualizeScreen = { x = 0, y = 0 }
	end
	
	oldScreenWidth = screenWidth
	oldScreenHeight = screenHeight	
	
	
		
	cameraShakeX, cameraShakeY = 0, 0
		
	floatingScoreScaling = 1
	if deviceModel == "iphone4" then
		floatingScoreScaling = 2
	end
	
	loading = false
	
	menuSunsetAngle = 0
	
	goldenEggsStarEffectAngle = 0

	rubberBandPos = { x = 0, y = 0 }
	rubberBandSpeed = 0

	floatingScores = {}

	objectCounts = {}

	scoreTable = {}

	draggingSpeed = 0
	draggingStartPosPhysics = { x = -1, y = -1 }
	draggingStartPosWorld = { x = -1, y = -1 }
	draggingStartPosScreen = { x = -1, y = -1 }
	selectedObjects = { }
	selectedObjectPos = { x = 0, y = 0 }
	selectedBird = nil

	objectToAdd = nil
	objectToAddAngle = 0

	currentGroupIndex = 1
	currentGroup = nil

	currentThemeIndex = 1
	currentTheme = nil

	cameraTargetObject = nil

	doubleClickTimer = 0
	quadClickTimer = 0
	quadClickCounter = 0
	gameTimer = 0
	levelCompleteTimer = 0
	birdBuffTimer = 0
	currentBirdIndex = 1
	currentBirdName = nil
	flyingBird = nil
	birdSpecialtyAvailable = false
	particleAmount = 0
	blockMoveTimer = 0
	
	cursor.x, cursor.y = 0, 0
	cursorPhysics = {x = 0, y = 0}
	cursorWorld = {x = 0, y = 0}
	oldCursorWorld = {x = 0, y = 0}
	oldCursor = {x = 0, y = 0}
	tapPosWorld = {x = 0, y = 0}

	springConstant = 1500
	springDampening = 50

	difficultyLevel = 1
	score = 0
	zoomLevel = 0
	
	defaultForce = -800.0
	blockDestroyedScoreIncrement = 100

	physicsToWorld = 20
	physicsScale = 1/physicsToWorld
	shootRange = 2.2

	continueButtonY = screenHeight*0.5 + 70

	oldScale = 1
	levelStartPosition = { x = 0, y = 0 }
	animationScreen = { x = 0, y = 0 }
	animationWorldScale = 1

	setPhysicsSimulationScale(physicsToWorld)

	levelName = ""

	cameraFunction = defaultCamera
	castleCameraTimer = 0

	levelStartTimer = 0

	currentLevelNumber = -1
	currentThemeNumber = -1
	currentWorldNumber = -1
	inExtraWorld = false
	currentLevelNumberInTheme = -1
	currentPageNumber = -1
	
	collisionParticleForceThreshold = 5

	physicsEnabled = false
	levelSaved = true
	selectionRectActive = false
	birdFired = false

	loadingPageDrawn = false
	
	-- particle table
	particles = {}

	-- main menu page animations
	elementAnimations = {}

	
		-- HATCHERY: could be listening to game initialized event
	if g_hatcheryEnabled then
		loadLuaFileToObject("hatchery/hatchery.lua", this, "Hatchery")
		Hatchery.init(selectAssetProfile(), selectFontProfile(), settingsWrapper:getHatcheryStars())
		settingsWrapper:addHatcheryStars(60)
	end
	
	
	initializeMenu()

	updateValues()

	setPhysicsEnabled(false)
	
	cos = _G.math.cos
	sin = _G.math.sin

	-- in-app purchase
	if isIapEnabled() then
		setNotificationCallback("mightyEagleNotificationCallback")
	end
		
	--createDirectory("/temp")
	

	
	--utils.ABSync.bootstrap(localSettings.ABIDrefreshToken)
	eventManager:notify({id = events.EID_GAME_INITIALIZED, screenWidth = screenWidth, screenHeight = screenHeight, customerString = customerString, deviceModel = deviceModel})
	

end


-- in-app purchase starts
function inAppPurchaseInitCallback(pid, status, errorCode)
	-- pid is not used for anything 
	if status ~= nil and errorCode ~= nil then
		print("gameLogic.lua::itemPurchaseCallback(): status: ".. status .. ", errorCode: ".. errorCode .. "\n")
		if status == 1 then
			local count = iapGetItemCount()
			print("  gameLogic.lua::itemPurchaseCallback(): itemCount: ".. count .. "\n")
			if count > 0 then
				local eagleItemFound = false
				for i = 0, count - 1 do
					local item = iapGetItemAt(i)
					print("  gameLogic.lua::itemPurchaseCallback(): item(i): ")
					print("    name: ".. item.name ..", id: ".. item.id ..", type: ".. item.type ..", quantity: ".. item.quantity ..", desc: ".. item.description .."\n")
					if item.id == mightyEagleItemId then
						eagleItemFound = true
						mightyEagleItem = { name = item.name, id = item.id, type = item.type, quantity = item.quantity, description = item.description }
					end
				end
				if eagleItemFound ~= true then
					print("  gameLogic.lua::itemPurchaseCallback(): mighty eagle item not found\n")
				end
			else
				print("  gameLogic.lua::itemPurchaseCallback(): no items found\n")
			end
		else
			print("  gameLogic.lua::itemPurchaseCallback(): init failed\n")
		end
	end
	-- iapBuyItem is called when iapInitTimer <= 0 
	iapInitTimer = 0
end


function purchaseAdRemoval()
	logFlurryEvent("Ads removal purchase started")
	iapBuyItem(adRemovalItemId, "adRemovalPurchaseCallback")
end

function purchaseMightyEagle()
	print("gameLogic.lua:: purchaseMightyEagle(): enter\n")
	--print("Initializing In-App purchase\n")	
	iapInitTimer = iapInitTimeOut
	iapInitItemPurchase("inAppPurchaseInitCallback")
end
--	logFlurryEventWithParam("Ads removal purchase", "Result", "user cancelled")


function inAppPurchaseBuyCallback(pid, status, errorCode)
	--local elements = getItemByName(mainMenu.items, "buttonSliderBGOptions").elements
	
	local failed = true
	
	if status ~= nil and errorCode ~= nil then 
		loginfo("gameLogic.lua::inAppPurchaseBuyCallback(): (status: " .. status .. ", errorCode: ".. errorCode .. ")\n")
		
		if status == 2 then
			loginfo("gameLogic.lua::inAppPurchaseBuyCallback  (fail) \n")
			if errorCode == 2 then
				loginfo("gameLogic.lua::inAppPurchaseBuyCallback user cancelled \n")
				
				eventManager:notify({id = events.EID_ME_PURCHASE_CANCELLED_BY_USER, status = status, errorCode = errorCode})
				cancelMightyEaglePurchase()
				--return 
			else
				
				eventManager:notify({id = events.EID_ME_PURCHASE_FAILED_OTHER, status = status, errorCode = errorCode})
				loginfo("gameLogic.lua::inAppPurchaseBuyCallback  (fail : other)\n")
			end
		end						
		
		if (status == 1 or status == 3 or (status == 4 and useShop)) and pid == mightyEagleItemId then
			failed = false
			enableMightyEagle()
			
			-- changes trial scores to real scores.
			settingsWrapper:setMightyEagleUpsellPageViewed()
			saveLuaFileWrapper("settings.lua", "settings", true)
			
			if g_eagleClickedFrom == "INGAME" or g_eagleClickedFrom == "LEVEL_FAILED" then
				launchEagleBaitInGame()
			end
			
			--_G.table.insert(mainMenu.items, {name = "trailerEagle", sprite = "BUTTON_MEVIDEO", callFunction = gotoMightyEagleTrailer, selectable = false, visible = false })
			if status == 1 then
				loginfo("gameLogic.lua::inAppPurchaseBuyCallback  (success) \n")
				local from = nil
				if g_eagleClickedFrom == "MAIN_MENU" then
					from = "MAIN_MENU"
				else
					from = getWorldLevelNumberCombination()
				end
				
				if(levelName ~= nil ) then
					if(highscores[levelName] == nil or (highscores[levelName] ~= nil and highscores[levelName].completed ~= true)) then
						usedAsLevelSkip = "yes"							
					end
				end												
				eventManager:notify({id = events.EID_MIGHTYEAGLE_PURCHASED, status = status, errorCode = errorCode, from = from, usedAsLevelSkip = usedAsLevelSkip})				
			elseif status == 3 then
				loginfo("gameLogic.lua::inAppPurchaseBuyCallback (mighty eagle restored)")				
				eventManager:notify({id = events.EID_MIGHTYEAGLE_RESTORED, status = status, errorCode = errorCode})				
			end
			loginfo("gameLogic.lua::inAppPurchaseBuyCallback: (Mighty Eagle Enabled) \n")
		end
	end
	
	--[[
	if currentMenuPage == mainMenu then
		-- back to mainmenu
		setActiveMenuPageDelayed(mainMenu, true)
		loginfo("gameLogic.lua::inAppPurchaseBuyCallback(): (back to mainmenu) \n")
	elseif currentMenuPage == levelFailed then
		if isEagleEnabled() then
			getItemByName(levelFailed.items, "buttonEagle").visible = true
			getItemByName(levelFailed.items, "buttonEagleLost").visible = false
			getItemByName(levelFailed.items, "buttonEagleBuy").visible = false
		else
			getItemByName(levelFailed.items, "buttonEagleBuy").visible = true
		end
		setActiveMenuPageDelayed(levelFailed, true)
	elseif currentGameMode == updateGame then
	
	
		if deviceModel == "iphone4" then
			changeResolution = true
			wantedResolution = "FULL"
		end
		
	end
	popupPage = nil
	]]--
	
	if g_eagleClickedFrom == "MAIN_MENU" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU" })
	elseif g_eagleClickedFrom == "INGAME" then
		menuManager:changeRoot(ui.GameHud:new())
		--setGameMode(updateGame)
		--setPhysicsEnabled(true)
	elseif g_eagleClickedFrom == "LEVEL_FAILED" then
		if not failed then
			menuManager:changeRoot(ui.GameHud:new())
		else
			local frame = menuManager:popFrame()
			eventManager:notify({ id = events.EID_PUSH_FRAME, target = frame.return_screen })
		end
	end
	
end

function adRemovalPurchaseCallback(pid, status, errorCode)
	local STATUS_SUCCESS = 1
	local STATUS_FAIL = 2
	local STATUS_RESTORE = 3
	local STATUS_PENDING = 4
	
	local ERRCODE_USER_CANCELLED = 2
	
	print("gameLogic.lua::inAppPurchaseBuyCallback(): status: " .. _G.tostring(status) .. ", errorCode: ".. _G.tostring(errorCode) .. "\n")
	if status ~= nil and errorCode ~= nil then 
		if status == STATUS_FAIL then
			print("  fail\n")
			
			if errorCode == ERRCODE_USER_CANCELLED then
				print("  user cancel\n")
				logFlurryEventWithParam("Ads removal purchase", "Result", "user cancelled")
			else
				print("  other\n")
				logFlurryEventWithParam("Ads removal purchase", "Result", "fail")
			end			
		end
		
		
		if (status == STATUS_SUCCESS or status == STATUS_RESTORE or (status == STATUS_PENDING and useShop )) and pid == adRemovalItemId then
			removeAds()				
			scoreAdOffsetY = 0
			
		-- Pending status
			if(status == STATUS_PENDING and useShop) then
				logFlurryEventWithParam("Ads removal purchase", "Result", "pending")						
			elseif status == STATUS_SUCCESS then
				logFlurryEventWithParam("Ads removal purchase", "Result", "success")
				print(" success\n")				
			elseif status == STATUS_RESTORE then
				print("  restored")
			end
		end
	end
	
	backToGameFromPopup()
end

function initializeMenu()
	
	-- initialize settings
	if not settingsWrapper:isFlurryFirstTimeLevelCollected() then
		
		for i = 1, #g_episodes do
			for j = 1, #g_episodes[i].pages do
				for k = 1, #g_episodes[i].pages[j].levels do
					local level = g_episodes[i].pages[j].levels[k]
					if highscores[level.name] ~= nil and g_episodes[i].pages[j].extra ~= true then
						levelCompleteFirstTimeFlurryParams = {}
						levelCompleteFirstTimeFlurryParams["Level"] = g_episodes[i].pages[j].world_number .. "-" .. k
						logFlurryEventWithParams("Level complete first time", "levelCompleteFirstTimeFlurryParams")
					end
				end
			end
		end
		settingsWrapper:setFlurryFirstTimeLevelCollected()
	end
	
	
	
	local ct = currentTime()
	
	if settingsWrapper:getCumulativeStars() == nil then
		settingsWrapper:setCumulativeStars(0)		
		for i = 1, #g_episodes do
			local stars, _ = calculateEpisodeStars(i)			
			settingsWrapper:setCumulativeStars(settingsWrapper:getCumulativeStars() + stars)
		end
	end
	
	for _, v in _G.pairs(g_episodes) do
		if not v.extra then
			for _, v2 in _G.pairs(v.pages) do
				if not v2.extra and not settingsWrapper:isThemeCompleted(v2.world_number) then
					if highscores[v2.levels[#v2.levels].name] ~= nil and highscores[v2.levels[#v2.levels].name].completed then
						settingsWrapper:setThemeCompleted(v2.world_number)
					end
				end
			end
		end
	end
		
	for i = 1, #g_episodes do
		if not settingsWrapper:isEpisodeThreeStarred(i) then
			local epStars, epTotalStars = calculateEpisodeStars(i)
			if epStars >= epTotalStars then
				settingsWrapper:setEpisodeThreeStarred(i)
			end
		end
	end
	
	-- if there's no previous information, reset things.
	if #settingsWrapper:getEagleUsedIn() == 0 then
		settingsWrapper:resetEaglesUsedIn()
		settingsWrapper:setEagleUsedTime(nil)
	end
	
	if isEagleEnabled() ~= true and checkEagleStatusFromHighscores() == true then
		enableMightyEagle()
		settingsWrapper:setMightyEagleUpsellPageViewed()
	end
	
	settingsWrapper:restoreGoldenEggsFromHighscores()
	
	-- code to unlock all golden eggs
	
	if releaseBuild ~= true then
		for i = 1, #g_episodes.G.pages do
			for j = 1, #g_episodes.G.pages[i].levels do
				local level = g_episodes.G.pages[i].levels[j]
				settingsWrapper:unlockGoldenEgg(level.name)
			end
		end
	end
	
	settingsWrapper:incrementGameStarts()
	
	saveLuaFileWrapper("settings.lua", "settings", true)
	
	createMenuPages()
	
	selectedMenuItem = -1
	oldMenuPage = nil
	
	if not releaseBuild then
		for i = 1, #g_episodes do
			settingsWrapper:setLastOpenLevel(i, 200)
		end
		--page 3 of first pack unlocks the remaining episodes
		settingsWrapper:setThemeCompleted(3)
	end
	
	limitLevels = false
	openDemoLevels = { 1, 6, 17, 26, 34, 36, 45, 49, 58 }
	
	--newAnimation("ingamePausePageScroll", "HIDDEN", pausePage, 600, 600)
	
	popupPage = nil
	birdAnimations = {}
	
	
	baitSardine = {
        y = 0,
        x = 0,
        name = "BaitSardine_1",
        startNumber = nil,
        angle = 0,
        definition = "BaitSardine",
		}
	
	if isBetaVersion then
		setActivePopupPage(betaDisclaimerPage)
	end	
	
	if(useShop == true) then				
		dummyPopupPage.rootContainer = shop.getShopPage()		
		-- Create purchase ads remove button if it's needed.
		local width,height = _G.res.getSpriteBounds("BUTTON_X_CLOSE")
		purchaseAdsRemoveButton = {
			sprite = "BUTTON_X_CLOSE",
			x = screenWidth - 320 - width / 2,
			y = 0,
			w = width,
			h = height,
		}
	end
	
	
	menuManager:addLink("CREDITS", Credits:new())
	
	--if hatcherymenus enabled, override the default implementation and use hatchery menus instead
	
	if g_hatcheryEnabled == true and g_enableNewMenus == true then
		loadLuaFile(scriptPath .. "/../hatchery/scripts/UI/MainMenu.lua","")
		menuManager:addLink("MAIN_MENU", HatcheryMainMenu:new())
	else
		menuManager:addLink("MAIN_MENU", MainMenu:new())
	end
	
	for _, v in _G.pairs(g_episodeIds) do
		if g_hatcheryEnabled == true and g_enableNewMenus == true  then
			loadLuaFile(scriptPath .. "/../hatchery/scripts/UI/LevelSelection.lua","")
			menuManager:addLink("LEVEL_SELECTION_"..v,HatcheryLevelSelection:new(nil,v))
		else
			menuManager:addLink("LEVEL_SELECTION_"..v,LevelSelection:new(nil,v))
		end
	end
			
		
	if g_hatcheryEnabled == true and g_enableNewMenus == true then
		loadLuaFile(scriptPath .. "/../hatchery/scripts/UI/EpisodeSelection.lua","")
		menuManager:addLink("EPISODE_SELECTION",HatcheryEpisodeSelection:new(nil))
	else
		menuManager:addLink("EPISODE_SELECTION",EpisodeSelection:new(nil))
	end
	menuManager:addLink("INFO_FRAME",info.InfoFrame:new())
	--menuManager:addLink("LOADING_PAGE", LevelLoadingPage:new())
	menuManager:addLink("CHALLENGE_PAGE", ChallengeFrame:new())
	-- menuManager:addLink("HATCHERY_NEST_VIEW",LevelSelection:new(nil,v))
	menuManager:addLink("MIGHTY_EAGLE_PURCHASE_PAGE", MEPage:new())

	
	g_menuInitialised = true
	
	eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU", from = "BOOT" })
	--if not settingsWrapper:isMightyEagleEnabled() and settingsWrapper:isThemeCompleted(3) and not settingsWrapper:isMightyEagleUpsellPageViewed() then
	--	eventManager:notify({ id = events.EID_MIGHTY_EAGLE_BUTTON_CLICKED, from = "MAIN_MENU", })
	--end
end


function getWorldLevelNumberCombination()
	local level = "999-999"
	if(currentWorldNumber ~= nil and currentLevelNumberInTheme ~= nil) then
		level = currentWorldNumber.."-"..currentLevelNumberInTheme	
	end
	return level
end

function startCrystal()

	if isCrystalUIShowing() then
		showCrystalInMainMenu = false
		deactivateCrystalUI()
		eventManager:notify({id = events.EID_CRYSTAL_DEACTIVATED})
		
	else
		showCrystalInMainMenu = true
		postTotalHighScores()
		eventManager:notify({id = events.EID_CRYSTAL_STARTED})
		activateCrystalUI()
	end
	
end

function changeGFXQuality()
	settingsWrapper:toggleGfxLowQuality()
end

-- <GameCenter>
-- <GameCenter getters>
function refreshLocalGameCenterData()
	print("gamelogic refreshLocalGameCenterData \n")
	if gameCenterEnabled and leaderboards then
		for k, v in _G.pairs(leaderboards) do
			getLeaderboardScoresForRange(v, 1, 1)
		end
	end
end

-- <leaderboard name getters>
function getLeaderboardNameForWorld(worldNumber)
	local lboardName = "totalScoreWorld" .. worldNumber
	return lboardName
end

function getLeaderboardNameForEpisode(episodeNumber)
	local lboardName = false
	if _G.type(episodeNumber) == "number" and episodeNumber <= #g_episodes then
		lboardName = "totalScoreEpisode" .. episodeNumber
	end
	return lboardName
end

function getLeaderboardNameForTotalScore()
	if isLiteVersion then
		return "liteTotalScore"
	else
		return "totalScore"
	end
end

-- </leaderboard name getters>
-- <score getters>

function getWorldScore(episode, page)
	local totalScore = 0
	
	for i = 1, #g_episodes[episode].pages[page].levels do
		local level = g_episodes[episode].pages[page].levels[i]
		if highscores[level.name] ~= nil and highscores[level.name].score ~= nil then
			totalScore = totalScore + highscores[level.name].score
		end
	end
	
	return totalScore
end
-- </score getters>

function getLeaderboardNamesForLevel(levelName)
	if g_menuInitialised then
		local worldNumber = 0
		
		for k, v in allLevels() do
			if k == levelName then
				local level, episode, page, _ = getLevelById(levelName)
				local lboardNames = {}
				local lboardNameWorld = getLeaderboardNameForWorld(g_episodes[episode].pages[page].world_number)
				local lboardNameEpisode = getLeaderboardNameForEpisode(episode)
				local lboardNameTotal = getLeaderboardNameForTotalScore()
				if lboardNameWorld then
					_G.table.insert(lboardNames, lboardNameWorld)
				end
				if lboardNameEpisode then
					_G.table.insert(lboardNames, lboardNameEpisode)
				end
				if lboardNameTotal then
					_G.table.insert(lboardNames, lboardNameTotal)
				end
				return lboardNames
			end
		end
	end
	return false
end
-- </GameCenter getters>

function setPostedStatus(levelName)
	if gameCenterEnabled and gameCenter and gameCenter.leaderboards and leaderboards then
		local lboardNames = getLeaderboardNamesForLevel(levelName)
		if lboardNames then
			for k, v in _G.pairs(lboardNames) do
				if gameCenter.leaderboards[leaderboards[v]] then
					print("Setting posted status to false for leaderboard " .. v .. ".\n")
					gameCenter.leaderboards[leaderboards[v]].posted = false
				end
			end
		end
	end
	
end

function setIndicatorPositions()
	if gameCenterEnabled and gameCenter and gameCenter.leaderboards and leaderboards then
		local bg = getItemByName(episodeSelectionPage.items[1].children, "ep1MeterBG")
		local _, bgH = _G.res.getSpriteBounds("", bg.sprite)
		if bg.x and bgH ~= 0 then
			
			for i = 1, #g_episodes do
				local lboardName = getLeaderboardNameForEpisode(i)
				if lboardName then
					local lboardId = leaderboards[lboardName]
					if lboardId then
						if gameCenter.leaderboards[lboardId] and gameCenter.leaderboards[lboardId].loading ~= true then
							local lboard = gameCenter.leaderboards[lboardId]
							if lboard.localRank and lboard.range then
								local localRank = lboard.localRank
								local range = lboard.range
								local posInMeter = 1
								if localRank > 0 then
									if range > 1 then
										posInMeter = (localRank - 1) / (range - 1)
									else -- range and rank are 1
										posInMeter = 0
									end
								end
								local epMeterIndicator = getItemByName(episodeSelectionPage.items[i].children, "ep" .. i .. "MeterIndicator")
								if epMeterIndicator then
									epMeterIndicator.x, epMeterIndicator.y = bg.x, _G.math.min(bg.y - (bgH * 0.645) + ((bgH * 0.645) * posInMeter), bg.y)
								else
									print("No global rank meter added to episode " .. i .. "\n")
								end
							end
						end
					end
				end
			end
		end
	end
end

function disableGameCenter()
	if not menuManager then return end
	local main_menu = menuManager:getLink("MAIN_MENU")
	local episode_selection = menuManager:getLink("EPISODE_SELECTION")
	
	if main_menu then
		main_menu:setGameCenterEnabled(false)
	end
	
	if episode_selection then
		episode_selection:disableGameCenter()
	end
end

function enableGameCenter()
	if not menuManager then return end
	local main_menu = menuManager:getLink("MAIN_MENU")
	local episode_selection = menuManager:getLink("EPISODE_SELECTION")
	
	if main_menu then
		main_menu:setGameCenterEnabled(true)
	end
	
	if episode_selection then
		episode_selection:enableGameCenter()
	end
end

-- GameCenter stuff ends.

function getAllThreeStars()
	print("Get all three stars cheat\n")
	for k, v in allLevels() do
		if highscores[k] == nil then
			highscores[k] = {}
		end
		highscores[k].score = 500000
		highscores[k].completed = true
	end
	saveLuaFileWrapper("highscores.lua", "highscores", true)
end

function createMenuPages()
	
	loadLuaFile(scriptPath .. "/menus/level_selection.lua", "")
	loadLuaFile(scriptPath .. "/menus/episode_selection.lua", "")
	loadLuaFile(scriptPath .. "/menus/main_menu.lua", "")
	loadLuaFile(scriptPath .. "/menus/credits.lua", "")
	loadLuaFile(scriptPath .. "/menus/tutorials.lua", "")
	loadLuaFile(scriptPath .. "/menus/egg_hint.lua", "")
	loadLuaFile(scriptPath .. "/menus/loading.lua", "")
	loadLuaFile(scriptPath .. "/menus/level_end.lua", "")
	loadLuaFile(scriptPath .. "/menus/achievements.lua", "")
	loadLuaFile(scriptPath .. "/menus/reward_popups.lua", "")
	if gameCenterSupported or not releaseBuild then
		loadLuaFile(scriptPath .. "/subsystems/game_center.lua", "")
	end
	--
	local loading = LevelLoadingPage:new({name = "loading", visible = "false"})
	notificationsFrame:addChild(loading)
	loading:layout()
	--notificationsFrame.loading = LevelLoadingPage:new()

	initSubsystems()
	createPopupBoxSpriteTables()
	
	emptyMenuPage = { items = {} }
	emptyUpdateMenu = function() end
	
	g_menu_metatable =
	{
		__index = itemIndex,
		__newindex = itemNewIndex
	}
	
	mainMenu = {}
	upsellPage = {}
	
	--[[
	goldenEggAchievedPage = {
		name = "goldenEggAchievedPage",
		popup = true,
		back = nil,
		state = "READY",
		backgroundOverlay = { sprite = "DIM_BLOCK", visible = true },
		items = {
			{sprite = "GOLDEN_EGG_5", selectable = false},
		}
	}
	_G.setmetatable(goldenEggAchievedPage.items, g_menu_metatable)
	
	goldenEggStarAchievedPage = {
		name = "goldenEggStarAchievedPage",
		popup = true,
		back = nil,
		state = "READY",
		backgroundOverlay = { sprite = "DIM_BLOCK", visible = true },
		items = {
			{sprite = "BIG_STAR_2", selectable = false},
			{sprite = "", selectable = false},
		}
	}
	_G.setmetatable(goldenEggStarAchievedPage.items, g_menu_metatable)
	
	boomerangBirdAchievedPage = {
		name = "boomerangBirdAchievedPage",
		popup = true,
		back = nil,
		state = "READY",
		backgroundOverlay = { sprite = "DIM_BLOCK", visible = true },
		items = {
			{sprite = "BIRD_BOOMERANG_STILL", selectable = false},
		}
	}
	_G.setmetatable(boomerangBirdAchievedPage.items, g_menu_metatable)
	]]--
	
	tutorials = {
		name = "tutorials",
		back = nil,
		backgroundBox = { name = "tutorialBg", sprites = {left = "TUTORIAL_LEFT", bottomLeft = "TUTORIAL_BOTTOM_LEFT", 
						  bottomMiddle = "TUTORIAL_BOTTOM_MIDDLE", bottomRight = "TUTORIAL_BOTTOM_RIGHT", right = "TUTORIAL_RIGHT", 
						  topRight = "TUTORIAL_TOP_RIGHT", topMiddle = "TUTORIAL_TOP_MIDDLE", topLeft = "TUTORIAL_TOP_LEFT", 
						  center = "TUTORIAL_CENTER" }, hanchor = "HCENTER", vanchor = "VCENTER"},
		items = { 
				{ name = "TUTORIAL_1", sprite = "TUTORIAL_RED", selectable = false }, --red
				{ name = "TUTORIAL_2", sprite = "TUTORIAL_BLUE", selectable = false }, --blue
				{ name = "TUTORIAL_3", sprite = "TUTORIAL_YELLOW", selectable = false }, --yellow
				{ name = "TUTORIAL_4", sprite = "TUTORIAL_BLACK", selectable = false }, --black
				{ name = "TUTORIAL_5", sprite = "TUTORIAL_WHITE", selectable = false }, --white
				{ name = "TUTORIAL_6", sprite = "TUTORIAL_BOOMERANG", selectable = false }, --boomerang
				{ name = "TUTORIAL_7", sprite = "TUTORIAL_BIG_BROTHER", selectable = false }, --bigbrother
				{ name = "TUTORIAL_8", sprite = "TUTORIAL_MIGHTYEAGLE", selectable = false }, --mightyeagle
				{ name = "TUTORIAL_9", sprite = "TUTORIAL_PUFFER", selectable = false }, --puffer/globe
				
				}
		}
		
	_G.setmetatable(tutorials.items, g_menu_metatable)
				
	if deviceModel == "s60" or deviceModel == "n900" or deviceModel == "android" then
		areYouSurePage = {
			name = "areYouSure",
			state = "READY",
			back = nil,
			popup = true,
			backgroundOverlay = { sprite = "DIM_BLOCK", visible = true },
			backgroundBox = { name = "backgroundAreYouSure", 
							  sprites = {topLeft = "POPUP_TOP_LEFT", left = "POPUP_LEFT", 
										 bottomLeft = "POPUP_BOTTOM_LEFT", bottomMiddle = "POPUP_BOTTOM_MIDDLE", 
										 bottomRight = "POPUP_BOTTOM_RIGHT", right = "POPUP_RIGHT", topRight = "POPUP_TOP_RIGHT", 
										 topMiddle = "POPUP_TOP_MIDDLE", center = "POPUP_CENTER"}, 
							  sheet = "POPUPS_SHEET_1", hanchor = "HCENTER", vanchor = "VCENTER"},
			items = {
				{name = "areYouSureText", text = "TEXT_EXIT_CONFIRM", font = fontBasic, hanchor = "HCENTER", vanchor = "BASELINE"},
				{name = "buttonNo", sprite = "MENU_NO", selectable = true, callFunction = closeBetaDisclaimerPage},
				{name = "buttonYes", sprite = "MENU_YES", selectable = true, callFunction = requestExit},
			}
		
		}
		_G.setmetatable(areYouSurePage.items, g_menu_metatable)
	end
	
	systemPopup = {
		name = "systemPopup",	
		back = nil,
		backgroundOverlay = { sprite = "DIM_BLOCK", visible = true, shade = 0.65 },
		state = "READY",
		sound = "menu_confirm",
		popup = true,
		nextPage = nil,	
		backgroundBox = { name = "bgSystemPopup", 
							  sprites = {topLeft = "POPUP_TOP_LEFT", left = "POPUP_LEFT", 
										 bottomLeft = "POPUP_BOTTOM_LEFT", bottomMiddle = "POPUP_BOTTOM_MIDDLE", 
										 bottomRight = "POPUP_BOTTOM_RIGHT", right = "POPUP_RIGHT", topRight = "POPUP_TOP_RIGHT", 
										 topMiddle = "POPUP_TOP_MIDDLE", center = "POPUP_CENTER"}, 
							  sheet = "POPUPS_SHEET_1", hanchor = "HCENTER", vanchor = "VCENTER"},
		items = {
			{name = "title", text = "", selectable = false, hanchor="HCENTER", vanchor="VCENTER" } ,
			{name = "message", text = "", selectable = false, hanchor="HCENTER", vanchor="VCENTER" } ,
			{name = "icon", sprite = "", hanchor="HCENTER", vanchor="BOTTOM" },
			{name = "buttonYes", sprite = "TUTORIAL_OK", selectable = true, callFunction = hideSystemPopup, activateOnRelease = true },
		}
	}
	_G.setmetatable(systemPopup.items, g_menu_metatable)
	
	tutorialGoldenEggPosition = { }
	
	if gameCenterEnabled and gameCenter and gameCenter.leaderboards then
		postTotalHighScores()
	end
end

function showEagleBuyFromFailed()

	if(isEagleEnabled() ~= true) then
		setGameMode(updateMenu)
		if(useShop ~= true) then
			setActivePopupPage(mightyEagleDemoPage, nil, "level failed")
			setActiveMenuPage(levelFailed)
			print("(1.5.4) ME demo page opened from failed\n")			
		else
			gotoShopMEPage()
		end
	end
end

-- goes to Fortumo & boku shop where mighty eagle can be bought
function gotoShopMEPage()
	dummyPopupPage.rootContainer:setEnterPageIndex(1)
	dummyPopupPage.rootContainer:onEntry()
	dummyPopupPage.rootContainer:layout()
	setActivePopupPage(dummyPopupPage, nil)			
	
end

function showEagleBuyFromMain()
	
	setGameMode(updateMenu)
	
	if useShop == true then		
		gotoShopMEPage()
	else
		setActivePopupPage(mightyEagleDemoPage, nil, "main menu")		
	end
	setActiveMenuPage(mainMenu)
	--print("(1.5.4) ME demo page opened from main\n")
		
end
--, page = mightyEagleDemoPage 
--{name = "buttonEagleBuy", sprite = "BUTTON_EAGLE", callFunction = showEagleBuy, page = mightyEagleDemoPage },


function updateMenu(dt, time)
	-- TODO: this should be fixed properly
	if(currentMenuPage == nil) then
		return
	end
	selectedMenuItem = -1
	if oldScreenWidth ~= screenWidth or oldScreenHeight ~= screenHeight then
		--oldScreenWidth = screenWidth
		--oldScreenHeight = screenHeight
		--createMenuPages()
		--initializeMenu()
		notificationsFrame:layout()

		prepareMenuPage(currentMenuPage)

		if popupPage then
			if popupPage == dummyPopupPage and dummyPopupPage ~= nil then
				dummyPopupPage.rootContainer:layout()
			else
				prepareMenuPage(popupPage)
			end
		end		
	end
		
	goldenEggsStarEffectAngle = goldenEggsStarEffectAngle + 0.6 * dt
	if goldenEggsStarEffectAngle > _G.math.pi then
		goldenEggsStarEffectAngle = goldenEggsStarEffectAngle - 2 * _G.math.pi
	end
	
	if currentMenuPage.bgColor ~= nil then
		setBGColor( currentMenuPage.bgColor.red, currentMenuPage.bgColor.green, currentMenuPage.bgColor.blue)
	end
	
	-- handle dragging
	if menuDrag ~= nil then
		menuDrag = nil
	end
	
	
	if keyPressed["LBUTTON"] then
		menuDragStart = { x = cursor.x, y = cursor.y, time = time, page = currentMenuPage}
	elseif menuDragStart ~= nil and keyReleased["LBUTTON"] then
		if menuDragStart.page == currentMenuPage then
			dist = distance(menuDragStart.x, menuDragStart.y, cursor.x, cursor.y)
			menuDrag = { startX = menuDragStart.x, startY = menuDragStart.y, endX = cursor.x, endY = cursor.y, speed = dist / (time - menuDragStart.time) }
		end
		menuDragStart = nil
	end

	
	if popupPage == nil then
		updateMenuPage(currentMenuPage, dt)
	else
		updateMenuPage(popupPage, dt)
	end
	
	if (deviceModel == "n900" or deviceModel == "s60") and currentMenuPage.animationState == nil and currentMenuPage ~= upsellPage then
		updateMenuPage(overlayMenuPage, dt)
	end
	
	-- do not fade background if tutorials are going to be shown next
	if birdTutorialPopups == nil or #birdTutorialPopups == 0 then
		--pausePage.backgroundOverlay.shade = elementAnimations["ingamePausePageScroll"].percentage / 100 * 0.65
	else
		--pausePage.backgroundOverlay.shade = 0
	end
	--pausePage.offsetX = elementAnimations["ingamePausePageScroll"].percentage / 100 * pauseBGw - pauseBGw
	drawMenu(dt)
end

-- uses page offset values to offset current coordinates
function offsetCoordinates(page, x, y)
	if page.offsetX ~= nil then
		x = x + page.offsetX
	end
	if page.offsetY ~= nil then
		y = y + page.offsetY
	end

	return x, y
end

function updateMenuPage(page, dt)
	
	
	if page == nil then
		return
	end
	updateGameMenuPage(page, dt)

	-- update new model UI 
	if(page == dummyPopupPage) then
		if(dummyPopupPage.rootContainer ~= nil) then
			updateUIPage(dt,nil,dummyPopupPage.rootContainer) 
		end
		return
	end
	
	-- if page is not ready for input
	if page.state ~= "READY" then
		return
	end
	
	-- Handle menu items
	-- update items and select one that is under the cursor
	if keyPressed["LBUTTON"] or keyReleased["LBUTTON"] then
		local i = #page.items
		local j = 0
		local distanceToSelected = 10000
		local hasChildren = false
		local selectedMenuItemChildren = -1
		while i >= 1 or j >= 1 do
			local ci = page.items[i]
			local parent = nil			
			if ci.selectableChildren == true and hasChildren == true then
				parent = ci
				ci = page.items[i].children[j]
			end
			
			-- is menu item visible
			if ci.visible ~= false and ci.selectable ~= false then
				if ci.activateOnRelease ~= true and keyPressed["LBUTTON"] or ci.activateOnRelease == true and keyReleased["LBUTTON"] then
					local selectionCandidate = nil
					local selectionCandidateChildren = nil
					local x = ci.x and ci.x or 0
					local y = ci.y and ci.y or 0
					if parent ~= nil then
						x = x + parent.x
						y = y + parent.y
					end
					
					x, y = offsetCoordinates(page, x, y)
					-- menu item is text
					if ci.text ~= nil then
						x = screenWidth/2
						y = screenHeight/(#page.items + 1) * i
						x = ci.x and ci.x or x
						y = ci.y and ci.y or y
						x, y = offsetCoordinates(page, x, y)

						if ci.font ~= nil then
							--use item default
							setFont(ci.font)
						elseif page.font ~= nil then
							--use page override
							setFont(page.font)
						else
							--use menu default
							setFont(defaultMenuFont)
						end

						if checkTextBounds("TEXTS_BASIC", ci.text, ci.hanchor, ci.vanchor, x, y, cursor.x, cursor.y) then
							selectionCandidate = i
							selectionCandidateChildren = j
						end
					end

					-- menu item is image
					if ci.sprite ~= nil then
						if checkSpriteBounds("", ci.sprite, x, y, cursor.x, cursor.y) then
							selectionCandidate = i
							selectionCandidateChildren = j
						end
					end

					-- menu item is just touch area
					if ci.w ~= nil and ci.h ~= nil then
						if checkBounds(x, y, ci.w, ci.h, cursor.x, cursor.y) then
							selectionCandidate = i
							selectionCandidateChildren = j
						end
					end
					
					if ci.box ~= nil and ci.width ~= nil and ci.height ~= nil then
						if checkBounds(x, y, ci.width, ci.height, cursor.x, cursor.y, nil, ci.hanchor, ci.vanchor) then
							selectionCandidate = i
							selectionCandidateChildren = j
						end
					end
					
					if selectionCandidate ~= nil and page.items[selectionCandidate].disableSelection ~= true then
						local dist = distance(x, y, cursor.x, cursor.y)
						if dist < distanceToSelected then
							selectedMenuItem = selectionCandidate
							if hasChildren == true then
								selectedMenuItemChildren = selectionCandidateChildren
							end
							distanceToSelected = dist
						end
					end
				end
			end
			
			if (parent == nil and (ci.selectableChildren ~= true or ci.children == nil)) or j == 1 then
				i = i - 1
				hasChildren = false
				j = 0
			else
				hasChildren = true
				if j == 0 then
					j = #page.items[i].children
				else
					j = j - 1
				end
			end
		end
		-- TODO: remove spaghetti
		if selectedMenuItem > -1 then
			local selectedItem = page.items[selectedMenuItem]
			if selectedMenuItemChildren > -1 then
				selectedItem = page.items[selectedMenuItem].children[selectedMenuItemChildren]
			end
			-- do not change game mode if update function is not available
			if selectedItem.updateFunction ~= nil and page.items[selectedMenuItem].disableUpdateFunctionChange ~= true then
				
				if(selectedItem.name ~= nil) then
					if(selectedItem.name == "extraLevel1" or selectedItem.name == "extraLevel2" or selectedItem.name == "extraLevel3") then
						print("(1.5.4) Facebook level clicked!"..(selectedItem.name).."\n")
						logFlurryEvent("Facebook level clicked "..(selectedItem.name))
					end
				end
				
				setGameMode(selectedItem.updateFunction)
				if currentGameMode == updateMenu then
					if selectedItem.page.popup == true then
						setActivePopupPage(selectedItem.page)
					else
						if selectedItem.needLoadingScreen == true then
							setGameMode(updateLoadingEx)
							loading = true
							loadingPage.nextPage = selectedItem.page
						else
							setActiveMenuPage(selectedItem.page)
							popupPage = nil
						end
					end
				end
				if currentGameMode == addPopupMenu then
					setGameMode(updateMenu)
					setActivePopupPage(selectedItem.page)
				end
				if currentGameMode == removePopupMenu then
					setGameMode(updateMenu)
					popupPage = nil
				end			
				handleGameModeChange(page, selectedMenuItem)
				
				-- Item selection sound
				local sound = page.sound
				if selectedItem.sound ~= nil then
					sound = selectedItem.sound
				end
				if sound ~= nil then
					_G.res.playAudio(sound, 1, false)
				end
			end
			
			if selectedItem.callFunction ~= nil then
				selectedItem.callFunction( selectedItem.callParam1 )
			end
			
			selectedMenuItem = -1
		end	
	end
end


-- Game specific menu update logic
function updateGameMenuPage(page, dt)
	
	if page.backgroundOverlay ~= nil then
		if page.backgroundOverlay.sprite ~= nil and page.backgroundOverlay.visible ~= false then
			if page.backgroundOverlay.sprite == "DIM_BLOCK" then
				if page.backgroundOverlay.shade == nil then
					page.backgroundOverlay.shade = 0
				end
				page.backgroundOverlay.shade = page.backgroundOverlay.shade + dt * 2.7
				if page.backgroundOverlay.shade > 0.65 then
					page.backgroundOverlay.shade = 0.65
				end
			end
		end
	end
	
	if page == mainMenu then
		if currentMainMenuSong ~= nil and _G.res.isAudioPlaying(currentMainMenuSong) == false  then
			_G.res.playAudio(currentMainMenuSong, 0.8, true, 7)
		end
	end
	
	
	if levelSelectionPagesGoldenEggs and page == levelSelectionPagesGoldenEggs[1] and levelSelectionPagesPressed then

		if getItemByName(page.items, "overlay") ~= nil then
			if getItemByName(page.items, "overlay").shade == nil then
				getItemByName(page.items, "overlay").shade = 0
			end
			
			if getItemByName(page.items, "overlay").fadeSpeed > 0 then
				getItemByName(page.items, "overlay").shade = getItemByName(page.items, "overlay").shade + dt * getItemByName(page.items, "overlay").fadeSpeed
				if getItemByName(page.items, "overlay").shade > 0.65 then
					getItemByName(page.items, "overlay").shade = 0.65
					getItemByName(page.items, "overlay").fadeSpeed = 0
				end
			elseif getItemByName(page.items, "overlay").fadeSpeed < 0 then
				getItemByName(page.items, "overlay").shade = getItemByName(page.items, "overlay").shade + dt * getItemByName(page.items, "overlay").fadeSpeed
				if getItemByName(page.items, "overlay").shade < 0 then
					getItemByName(page.items, "overlay").shade = 0
					getItemByName(page.items, "overlay").fadeSpeed = 0
					getItemByName(page.items, "overlay").visible = false
				end
			end
		end
	
		-- help text bubble

		
		if page == levelSelectionPagesGoldenEggs[1] and keyReleased["LBUTTON"] then
			helpAreaPressed = false
			for i = page.firstLevelIndex, page.firstLevelIndex + page.levelCount do
				if page.items[i].visible ~= false and page.items[i].disableSelection and not(page.dragging) then 
					local w, h = _G.res.getSpriteBounds("", page.items[i].sprite)
					local px, py = _G.res.getSpritePivot("", page.items[i].sprite)
					if cursor.x > page.items[i].x - px and cursor.x < page.items[i].x + (w - px) and
					   cursor.y > page.items[i].y - py and cursor.y < page.items[i].y + (h - py) then
						getItemByName(page.items, "tipContent").sprite = page.items[i].children[1].sprite
						helpAreaPressed = true
					end
				end
			end
			
			if helpAreaPressed and getItemByName(page.items, "tipBubble").visible ~= true then 
				getItemByName(page.items, "tipBubble").visible = true
				getItemByName(page.items, "overlay").visible = true
				getItemByName(page.items, "overlay").shade = 0
				getItemByName(page.items, "overlay").fadeSpeed = 2.7
				getItemByName(page.items, "tipContent").visible = true

				-- disable egg buttons until the help text is dismissed
				for i = page.firstLevelIndex, page.firstLevelIndex + page.levelCount do
					page.items[i].selectable = false
				end
			else
				getItemByName(page.items, "tipBubble").visible = false	
				getItemByName(page.items, "tipContent").visible = false
				getItemByName(page.items, "overlay").fadeSpeed = -2.7
			end
		end
	end
	
	if page == goldenEggAchievedPage then -- or page == mightyEagleAvailablePage then
		page.timer = page.timer - dt
		local _, eggHeight = _G.res.getSpriteBounds("", page.items[1].sprite)
		page.items[1].angle = page.items[1].angle + 1.6 * dt
		
		if page.animationState == "FADEIN" then
			page.backgroundOverlay.shade = (page.fadeInLength - page.timer) / page.fadeInLength * page.fullyShaded
			page.items[1].visible = true
			page.items[1].y = (screenHeight*0.5) + _G.math.pow(page.timer / page.fadeInLength, 2) * ((screenHeight*0.5) + eggHeight)
			if page.timer < 0 then
				page.timer = page.fadedLength
				page.animationState = "FADED"
			end
		end
		
		if page.animationState == "FADED" then
			page.backgroundOverlay.shade = page.fullyShaded
			page.items[1].y = screenHeight*0.5
			if page.timer < 0 then
				page.timer = page.fadeOutLength
				page.animationState = "FADEOUT"
			end
		end
		
		if page.animationState == "FADEOUT" then
			page.backgroundOverlay.shade = (page.timer / page.fadeOutLength) * page.fullyShaded
			page.items[1].y = (screenHeight*0.5) - _G.math.pow((page.fadeInLength - page.timer) / page.fadeInLength, 2) * ((screenHeight*0.5) + eggHeight)
			if page.timer < 0 then
				if page.enablePhysicsWhenDone then
					setPhysicsEnabled(true)
				end
				popupPage = nil
				--[[
				if deviceModel == "iphone4" and currentGameMode ~= updateMenu then
					changeResolution = true
					wantedResolution = "FULL"
					resolutionChanged = true
				end
				]]--
			end
		end
	end
	
	-- effects in levelcomplete when mighty eagle is used 
	if page == levelComplete then
		if eagleBaitLaunched == true then
			local starEffect = getItemByName(levelComplete.items, "starEffect")
			starEffect.angle = starEffect.angle + 1.6 * dt
			
			local eagleFeatherFill = getItemByName(levelComplete.items, "eagleFeatherFill")
			local eagleScoreNumber = getItemByName(levelComplete.items, "eagleScoreNumber")
			local eagleHighScoreNumber = getItemByName(levelComplete.items, "eagleHighScoreNumber")
			
			-- some little delay before starting filling the feather
			if starEffect.angle > 0.8 then
				eagleFeatherFill.fill = eagleFeatherFill.fill + 50 * dt 
				if eagleFeatherFill.fill > mightyEagleScore then
					eagleFeatherFill.fill = mightyEagleScore
				end
				eagleScoreNumber.text = _G.string.format("%d", eagleFeatherFill.fill) .. "%"
				eagleHighScoreNumber.text = _G.string.format("%d", _G.math.max(eagleHighScoreNumber.number, eagleFeatherFill.fill)) .. "%"
				prepareTextItem(page, eagleScoreNumber)
				prepareTextItem(page, eagleHighScoreNumber)
			end
			
			local totalDestruction = getItemByName(levelComplete.items, "totalDestruction")
			local eagleFeatherFull = getItemByName(levelComplete.items, "eagleFeatherFull")
			local eagleFeatherEmpty = getItemByName(levelComplete.items, "eagleFeatherEmpty")
			local eagleHighScoreFeatherEmpty = getItemByName(levelComplete.items, "eagleHighScoreFeatherEmpty")
			local eagleHighScoreFeatherFull = getItemByName(levelComplete.items, "eagleHighScoreFeatherFull")
			
			
			if eagleHighScoreNumber.number >= 100 then
				eagleHighScoreFeatherEmpty.visible = false
				eagleHighScoreFeatherFull.visible = true 
			end
			
			if eagleFeatherFill.fill >= 100 then
				eagleScoreNumber.visible = false
				totalDestruction.visible = true
				eagleFeatherFull.visible = true
				eagleFeatherFill.visible = false
				eagleFeatherEmpty.visible = false
				starEffect.visible = true
				eagleHighScoreFeatherEmpty.visible = false
				eagleHighScoreFeatherFull.visible = true 
			end
		end
	end
	
	if page == goldenEggStarAchievedPage then
		page.timer = page.timer - dt
		local _, eggHeight = _G.res.getSpriteBounds("", page.items[1].sprite)
		page.items[1].angle = page.items[1].angle + 1.6 * dt
		
		if page.animationState == "FADEIN" then
			page.backgroundOverlay.shade = (page.fadeInLength - page.timer) / page.fadeInLength * page.fullyShaded
			page.items[1].visible = true
			page.items[1].y = (screenHeight*0.5) + _G.math.pow(page.timer / page.fadeInLength, 2) * ((screenHeight*0.5) + eggHeight)
			if page.timer < 0 then
				page.timer = page.fadedLength
				page.animationState = "FADED"
			end
		end
		
		if page.animationState == "FADED" then
			page.backgroundOverlay.shade = page.fullyShaded
			page.items[1].y = screenHeight*0.5

			if page.timer < 0 then
				page.timer = page.fadeOutLength
				page.animationState = "FADEOUT"
			end
		end
		
		if page.animationState == "FADEOUT" then
			page.backgroundOverlay.shade = (page.timer / page.fadeOutLength) * page.fullyShaded
			page.items[1].y = (screenHeight*0.5) - _G.math.pow((page.fadeInLength - page.timer) / page.fadeInLength, 2) * ((screenHeight*0.5) + eggHeight)
			if page.timer < 0 then
				if page.enablePhysicsWhenDone then
					setPhysicsEnabled(true)
				end
				popupPage = nil
			end
		end
	end
	
	if page == mightyEaglePaymentPage then
		local progress = getItemByName(page.items, "progress")
		progress.timer = progress.timer + dt
		if(progress.timer > 0.1) then -- and (progress.angle <= 1080) then
			progress.angle = progress.angle + _G.math.pi / 6
			progress.timer = 0
		end
	end
	
	if page == boomerangBirdAchievedPage then
		page.timer = page.timer - dt
		local _, birdHeight = _G.res.getSpriteBounds("", page.items[1].sprite)
		page.items[1].angle = page.items[1].angle + 1.6 * dt
		
		if page.animationState == "FADEIN" then
			page.backgroundOverlay.shade = (page.fadeInLength - page.timer) / page.fadeInLength * page.fullyShaded
			page.items[1].visible = true
			page.items[1].y = (screenHeight*0.5) + _G.math.pow(page.timer / page.fadeInLength, 2) * ((screenHeight*0.5) + birdHeight)
			if page.timer < 0 then
				page.timer = page.fadedLength
				page.animationState = "FADED"
			end
		end
		
		if page.animationState == "FADED" then
			page.backgroundOverlay.shade = page.fullyShaded
			page.items[1].y = screenHeight*0.5
			if page.timer < 0 then
				page.timer = page.fadeOutLength
				page.animationState = "FADEOUT"
			end
		end
		
		if page.animationState == "FADEOUT" then
			page.backgroundOverlay.shade = (page.timer / page.fadeOutLength) * page.fullyShaded
			page.items[1].y = (screenHeight*0.5) - _G.math.pow((page.fadeInLength - page.timer) / page.fadeInLength, 2) * ((screenHeight*0.5) + birdHeight)
			if page.timer < 0 then
				setPhysicsEnabled(true)
				popupPage = nil
				--[[
				if deviceModel == "iphone4" and currentGameMode ~= updateMenu then
					changeResolution = true
					wantedResolution = "FULL"
					resolutionChanged = true
				end
				]]--
				
				if currentMenuPage == levelComplete then
					prepareMenuPage(currentMenuPage)
				end
			end
		end
	end
	
	if page == gameFinished or page == gameFinishedThreeStars or
	   page == gameFinishedLP2 or page == gameFinishedThreeStarsLP2 or 
	   page == gameFinishedLP3 or page == gameFinishedThreeStarsLP3 or
	   page == gameFinishedLP4 or page == gameFinishedThreeStarsLP4 or 
	   page == gameFinishedLP5 or page == gameFinishedThreeStarsLP5 or
	   page == gameFinishedLP6 or page == gameFinishedThreeStarsLP6 then
		page.items[1].angle = page.items[1].angle + 0.8 * dt
	end
end


function prepareTextItem(page, ci)
	if ci.text ~= nil then
		local textBoxSize = ci.textBoxSize and ci.textBoxSize or screenWidth
		local group = ci.group and ci.group or "TEXTS_BASIC"
		
		--check font
		if ci.font == nil then
			-- use default
			ci.font = defaultMenuFont
			--use page default if it exists
			if page.font ~= nil then
				ci.font = page.font
			end
		end
		setFont(ci.font)
		clipText(group, ci.text, textBoxSize)
		local fh = _G.res.getFontLeading()
		local textHeight = #clippedText.lines * fh
		ci.h = textHeight
		ci.w = clippedText.widestLine
		ci.lines = {}
		
		local k = 1
		while  k <= #clippedText.lines do
			ci.lines[k] = clippedText.lines[k]
			--print("Calculated new lines: " .. ci.lines[k] .. "\n")
			k = k + 1
		end
	end
end

function calculateEpisodeStars(episode)
	local stars = 0
	local total_stars = 0
	
	for i = 1, #g_episodes[episode].pages do
		local page = g_episodes[episode].pages[i]
		total_stars = total_stars + #page.levels * 3
		for j = 1, #page.levels do
			local level = page.levels[j]
			if highscores[level.name] ~= nil and highscores[level.name].completed then
				local score = highscores[level.name].score
				
				if score >= starTable[level.name].goldScore then
					stars = stars + 3
				elseif score >= starTable[level.name].silverScore then
					stars = stars + 2
				else
					stars = stars + 1
				end
			end
		end
	end
	
	return stars, total_stars
end

function calculateEpisodeScore(episode)
	local score = 0
	
	for i = 1, #g_episodes[episode].pages do
		local page = g_episodes[episode].pages[i]
		for j = 1, #page.levels do
			local level = page.levels[j]
			if highscores[level.name] ~= nil and highscores[level.name].completed then
				score = score + highscores[level.name].score
			end
		end
	end
	
	return score
end

function getEagleScore(levelName)
	-- Check that this is actually availabe
	if(levelName == nil or highscores[levelName] == nil or highscores[levelName].eagleScore == nil) then
		return -1;
	end
	
	local eagleScore = 0

	if(highscores[levelName].eagleScore ~= nil) then
		eagleScore = highscores[levelName].eagleScore
	end		
	--print("---------- Returning score : "..eagleScore.."\n")
	return eagleScore
end

function storeEagleScore(levelName, score)
--	print(" -------------- STORING EAGLE SCORE : "..score.."\n")
	if settingsWrapper:isMightyEagleEnabled() then
		highscores[levelName].eagleScore = score
	elseif settingsWrapper:getNFCMeUnlocked() then
		highscores[levelName].eagleScore = score
		highscores[levelName].freeEagleUsed = true
		settingsWrapper:setNFCMeUnlocked(false)
	end
end

function calculateFeatherScore(episode)
	local total_feathers = 0
	local feathers = 0
	
	for i = 1, #g_episodes[episode].pages do
		local page = g_episodes[episode].pages[i]
		total_feathers = total_feathers + #page.levels
		for j = 1, #page.levels do
			local level = page.levels[j]
			if highscores[level.name] ~= nil and getEagleScore(level.name) >= 100 then
				feathers = feathers + 1
			end
		end
	end
	
	return feathers, total_feathers
end

function calculateAllFeathers()
	local feathers = 0
	local total_feathers = 0
	for i = 1, #g_episodes do
		local f, tf = calculateFeatherScore(i)
		feathers = feathers + f
		total_feathers = total_feathers + tf
	end
	return feathers, total_feathers
end

function calculateEpisodeLevelsCompleted(episode)
	local total_levels = 0
	
	for i = 1, #g_episodes[episode].pages do
		local page = g_episodes[episode].pages[i]
		for j = 1, #page.levels do
			local level = page.levels[j]
			if highscores[level.name] ~= nil and highscores[level.name].completed then
				total_levels = total_levels + 1
			end
		end
	end
	
	return total_levels
end

function calculateLastOpenLevel(episode)
	local pages = g_episodes[episode].pages
	local last_level = 1
	for i = 1, #pages do
		for j = 1, #pages[i].levels do
			local level = pages[i].levels[j]
			if highscores[level.name] ~= nil then
				last_level = last_level + 1
			else
				return last_level
			end
		end
	end
	return last_level
end

function checkEagleStatusFromHighscores()
	
	local eagleEnabled = false
	
	for i = 1, #g_episodes do
		for j = 1, #g_episodes[i].pages do
			for k = 1, #g_episodes[i].pages[j].levels do
				local level = g_episodes[i].pages[j].levels[k]
				if highscores[level.name] ~= nil and highscores[level.name].eagleScore ~= nil and highscores[level.name].eagleScore > 0 and not highscores[level.name].freeEagleUsed then
					eagleEnabled = true
					break
				end
			end
		end
	end
	
	return eagleEnabled
end


function calculateStarsFromGoldenEggLevels()
	stars = 0
	for i = 1, #g_episodes.G.pages do
		for j = 1, #g_episodes.G.pages[i].levels do
			local level = g_episodes.G.pages[i].levels[j]
			if highscores[level.name] and highscores[level.name].completed then
				stars = stars + 1
			end
		end
	end

	return stars
end

function calculateOpenGoldenEggLevels()
	count = 0
	
	for i = 1, #g_episodes.G.pages do
		for j = 1, #g_episodes.G.pages[i].levels do
			if settingsWrapper:isGoldenEggUnlocked(g_episodes.G.pages[i].levels[j].name) then
				count = count + 1
			end
		end
	end
	
	return count
end

-- prepare current menu page when it is set as active page
function prepareMenuPage(page, resume)

	if page == nil then
		return
	end
	
	if levelSelectionEdit ~= nil and page == levelSelectionEdit[1] then
		startedFromEditor = true
	end
	
	if page.backgroundOverlay ~= nil and page ~= loadingPage then
		page.backgroundOverlay.shade = 0
	end
	
	if page == systemPopup then
		prepareSystemPopup(page, resume)
	end
	
	if page == loadingPage then
		local loadingText = getItemByName(page.items, "loadingText")
		loadingText.x, loadingText.y = screenWidth / 2, screenHeight / 2
	end
	
	-- page specific controls
	
	if page == areYouSurePage then
		prepareAreYouSurePage(page, resume)
	end
	
	if page == mightyEaglePurchasePage then
		local whiteBackground = page.backgroundBox
		
		whiteBackground.x, whiteBackground.y = screenWidth / 2, screenHeight / 2
		whiteBackground.width, whiteBackground.height = 0.47 * screenWidth, 0.83 * screenHeight
		
		for i = 1, #page.items do
			page.items[i].x, page.items[i].y = screenWidth / 2, screenHeight / 2
		end
	end
	
	if page == mightyEagleDemoPage then
		prepareMightyEagleDemoPage(page, resume)	
	end
	
	---- 	
	
	if page == mightyEaglePaymentPage then
				
		page.items[1].angle = 0
		
		for i = 1, #page.items do
			if page.items[i].name == "confirming" then
				page.items[i].x, page.items[i].y = screenWidth / 2, screenHeight / 2 + 0.06 * screenHeight
			else
				page.items[i].x, page.items[i].y = screenWidth / 2, screenHeight / 2
			end
		end
	end
	

	--[[	
	if page == pausePage then
		if currentMainMenuSong ~= nil and _G.res.isAudioPlaying(currentMainMenuSong) == true then
			_G.res.stopAudio(currentMainMenuSong)
		end
		pausePage.menuButton = "goToGame"
		local buttonSfx = getItemByName(page.items, "buttonSfx")
		local sw, sh = _G.res.getSpriteBounds("", buttonSfx.sprite)
		
		page.background.x, page.background.y = 0, 0
		
		page.background.width = sw * 2.5
		buttonSfx.x, buttonSfx.y = page.background.width / 2 - sw * 0.54, screenHeight - sh * 0.66
		
		local buttonOff = getItemByName(page.items, "buttonOff")
		buttonOff.x, buttonOff.y = page.background.width / 2 - sw * 0.54, screenHeight - sh * 0.66
		
		local buttonTutorials = getItemByName(page.items, "buttonTutorials")
		buttonTutorials.x, buttonTutorials.y = page.background.width / 2 + sw * 0.54, screenHeight - sh * 0.66
		
		if deviceModel == "s60" and isLiteVersion then
			local buttonOvi = getItemByName(page.items, "buttonOvi")
			buttonOvi.visible = false
		end
		page.background.height = screenHeight + 1
			
		local buttonMenu = getItemByName(page.items, "buttonMenu")
		buttonMenu.x, buttonMenu.y = page.background.width / 2, screenHeight / 2 + (sh * 0.7)
		
		local buttonRestart = getItemByName(page.items, "buttonRestart")
		buttonRestart.x, buttonRestart.y = page.background.width / 2, screenHeight / 2 - (sh * 0.7)
		
		local borderSw, _ = _G.res.getSpriteBounds("", "MAIN_SETTINGS_LEFT")
		local buttonResume = getItemByName(page.items, "buttonResume")
		buttonResume.x, buttonResume.y = page.background.width + borderSw / 2, screenHeight/2
		
		local buttonResumeW, _ = _G.res.getSpriteBounds("", buttonResume.sprite)
		pauseBGw = page.background.width + buttonResumeW
		
		local hideArea = getItemByName(page.items, "hideArea")
		hideArea.x, hideArea.y = pauseBGw, 0
		--hideArea.w, hideArea.h = screenWidth, screenHeight
		hideArea.w , hideArea.h = 0,0
		local levelText = getItemByName(page.items, "levelText")
		levelText.x, levelText.y = page.background.width / 2, sh * 1.0
		
		if deviceModel == "s60" then
			local taskSwitcher = getItemByName(page.items, "taskSwitcher")
			taskSwitcher.x, taskSwitcher.y = 0, 0
		end	
		
		getItemByName(page.items, "buttonOff").visible = not settingsWrapper:isAudioEnabled()
		
		getItemByName(page.items, "buttonMenu").callFunction = function()
			setGameMode(function() end)
			stopIngameSounds()
			if g_currentChallenge == nil then
				eventManager:notify({id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_"..currentThemeNumber })
			else
				eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "CHALLENGE_PAGE" })
			end
			
			showHatcheryIngameMenu(false)
		end
		
		getItemByName(page.items, "levelText").text = g_currentLevelString
		
		--local grindBar = page.items.grindBar
		--grindBar.x = page.background.width * 0.5
		--grindBar.y = levelText.y + _G.res.getFontHeight(levelText.font) * 1.25
		
		page.background.width = buttonResume.x
	end]]
	
	if page == upsellPage then
		if deviceModel == "n900" then
		
		elseif deviceModel == "s60" then
		
		else
			local backgroundWidth, backgroundHeight = _G.res.getSpriteBounds("", "UPSELL_BG")
			page.backgroundSprite.x, page.backgroundSprite.y = 0, 0
				
			if screenHeight ~= backgroundHeight then
				page.backgroundSprite.scale = true
				page.backgroundSprite.ys = screenHeight / backgroundHeight
				page.backgroundSprite.xs = screenHeight / backgroundHeight
				local newWidth = backgroundWidth * page.backgroundSprite.xs
				if newWidth < screenWidth then
					page.backgroundSprite.x = (screenWidth - newWidth) / 2
				else
					page.backgroundSprite.ys = screenWidth / backgroundWidth
					page.backgroundSprite.xs = screenWidth / backgroundWidth
					local newHeight = backgroundHeight * page.backgroundSprite.ys
					if newHeight < screenHeight then
						page.backgroundSprite.y = (screenHeight - newHeight) / 2
					end
				end
			elseif screenWidth ~= backgroundWidth then
				page.backgroundSprite.x = (screenWidth - backgroundWidth) / 2
			end
			
			local back = getItemByName(page.items, "back")
			back.x, back.y = 0, screenHeight
			
			local button = getItemByName(page.items, "button")
			button.x, button.y = screenWidth * 0.5, screenHeight * 0.5
			
		end
	end
	
	if page == tutorials then
		
		local maxW, maxH = 0, 0
		for i = 1, #tutorials.items do
			local itm = tutorials.items[i]
			itm.x, itm.y = screenWidth / 2, screenHeight / 2
			local x1, y1, x2, y2 = _G.res.getCompoSpriteBounds("", itm.sprite)
			if x2 - x1 > maxW then
				maxW = x2 - x1
			end
			if y2 - y1 > maxH then
				maxH = y2 - y1
			end
		end
		
		local _, borderH = _G.res.getSpriteBounds("", "TUTORIAL_BOTTOM_MIDDLE")
		local borderW, _ = _G.res.getSpriteBounds("", "TUTORIAL_LEFT")
		page.backgroundBox.x, page.backgroundBox.y = _G.math.floor(screenWidth / 2), _G.math.floor(screenHeight / 2)
		page.backgroundBox.width, page.backgroundBox.height = _G.math.floor(maxW - (borderW * 1.5)), _G.math.floor(maxH - (borderH * 1.5))
		local sw, sh = _G.res.getSpriteBounds("", "TUTORIAL_OK")
		local gew, geh = _G.res.getSpriteBounds("", "GOLDEN_EGG_1")
		page.okButtonX, page.okButtonY = page.backgroundBox.x + page.backgroundBox.width / 2 - sw / 3, _G.math.floor(page.backgroundBox.y + page.backgroundBox.height / 2 + borderH * 0.7)
		tutorialGoldenEggPosition.x, tutorialGoldenEggPosition.y = (page.backgroundBox.x + page.backgroundBox.width / 6) * 1.54, (page.backgroundBox.y - page.backgroundBox.height / 7) * 1.54
		tutorialGoldenEggPosition.hitBoxMinX, tutorialGoldenEggPosition.hitBoxMaxX = tutorialGoldenEggPosition.x * 0.65 - gew, tutorialGoldenEggPosition.x * 0.65 + gew
		tutorialGoldenEggPosition.hitBoxMinY, tutorialGoldenEggPosition.hitBoxMaxY = tutorialGoldenEggPosition.y * 0.65 - geh, tutorialGoldenEggPosition.y * 0.65 + geh
	end
		
	if page == goldenEggAchievedPage then -- or page == mightyEagleAvailablePage then
		_G.res.playAudio("goldenegg", 1, false)
		page.enablePhysicsWhenDone = isPhysicsEnabled()
		setPhysicsEnabled(false)
		page.animationState = "FADEIN"
		page.fadeInLength = 0.8
		page.fadedLength = 1.5
		page.fadeOutLength = 0.8
		page.fullyShaded = 0.75
		page.timer = page.fadeInLength
		page.items[1].angle = 0
		page.items[1].visible = false
		page.items[1].x = screenWidth*0.5
		page.items[1].y = screenHeight*0.5
	end
	
	if page == goldenEggStarAchievedPage then
		page.enablePhysicsWhenDone = isPhysicsEnabled()
		setPhysicsEnabled(false)
		page.animationState = "FADEIN"
		page.fadeInLength = 0.8
		page.fadedLength = 1.5
		page.fadeOutLength = 0.8
		page.fullyShaded = 0.75
		page.timer = page.fadeInLength
		page.items[1].angle = 0
		page.items[1].visible = false
		page.items[1].x = screenWidth*0.5
		page.items[1].y = screenHeight*0.5
	end
	
	if page == boomerangBirdAchievedPage then
		setPhysicsEnabled(false)
		page.animationState = "FADEIN"
		page.fadeInLength = 0.8
		page.fadedLength = 1.5
		page.fadeOutLength = 0.8
		page.fullyShaded = 0.75
		page.timer = page.fadeInLength
		page.items[1].angle = 0
		page.items[1].visible = false
		page.items[1].x = screenWidth*0.5
		page.items[1].y = screenHeight*0.5
	end
	
	-- page specific controls end
	
	if deviceModel == "n900" or deviceModel == "s60" then
		getItemByName(overlayMenuPage.items, "close").x = screenWidth
	elseif deviceModel == "android" and isBetaVersion then
		local betaUp = getItemByName(overlayMenuPage.items, "betaUp")
		betaUp.x, betaUp.y = 0, 0
	end
	
	
	--page.prepared = true
	
	-- prepare all text items
	if page.items ~= nil then
		local i = 1
		while i <= #page.items do
			local ci = page.items[i]
			prepareTextItem(page, ci)
			if ci.children ~= nil then
				for j = 1, #ci.children do
					prepareTextItem(page, ci.children[j])
				end
			end
			i = i + 1
		end
	end
end

function prepareSystemPopup(page, resume)
	local bgBox = page.backgroundBox
	local title = getItemByName(page.items, "title")
	prepareTextItem(page, title)
	bgBox.x, bgBox.y = screenWidth / 2, screenHeight / 2
	bgBox.width, bgBox.height = title.w * 2, title.h * 4
	
	local message = getItemByName(page.items, "message")
	
	message.textBoxSize = screenWidth * 0.5
	prepareTextItem(page, message)
	
	if message.w < message.textBoxSize then
		message.textBoxSize = message.w * 1.1
	end
	
	local fontH = _G.res.getFontLeading(message.font)
	
	bgBox.width, bgBox.height = message.textBoxSize * 1.1, (title.h * 2 + message.h) * 1.1 + fontH
	
	title.x, title.y = screenWidth / 2, bgBox.y - bgBox.height / 2.25
	message.x, message.y = screenWidth / 2, title.y + title.h * 1.5 + message.h / 2
	
	local icon = getItemByName(page.items, "icon")
	if icon ~= nil then
		icon.x, icon.y = bgBox.x + bgBox.width * 0.35, bgBox.y - bgBox.height / 2 - 53
	end
	
	local buttonYes = getItemByName(page.items, "buttonYes")
	buttonYes.x, buttonYes.y = bgBox.x + bgBox.width * 0.35, bgBox.y + bgBox.height * 0.6
end

function prepareAreYouSurePage(page, resume)
	local bg = page.backgroundBox
	bg.x, bg.y = screenWidth / 2, screenHeight / 2
	local fl = _G.res.getFontLeading()
	local areYouSureText = getItemByName(page.items, "areYouSureText")
	areYouSureText.x, areYouSureText.y = screenWidth / 2, screenHeight / 2 - fl / 6
	setFont(areYouSureText.font)
	areYouSureText.textBoxSize = screenWidth * 0.7
	prepareTextItem(page, areYouSureText)
	
	local okButton = getItemByName(page.items, "buttonYes")
	local sw, sh = _G.res.getSpriteBounds("", okButton.sprite)
	
	bg.width, bg.height = areYouSureText.w, _G.math.max(#areYouSureText.lines * fl, sw) 
	if bg.width < sw * 3 then
		bg.width = sw * 3
	end
	
	okButton.x, okButton.y = (screenWidth / 2) - bg.width / 2 + sw / 1.5, screenHeight / 2 + bg.height / 2 + sh / 6
	local noButton = getItemByName(page.items, "buttonNo")
	noButton.x, noButton.y = (screenWidth / 2) + bg.width / 2 - sw / 1.5 , screenHeight / 2 + bg.height / 2 + sh / 6
end



function prepareMightyEagleDemoPage(page, resume)
inGamePressed = nil
	setPhysicsEnabled(false)
	local demoBackground = page.backgroundBox
	local buttonYes = getItemByName(page.items, "buttonYes")
	local buttonNo = getItemByName(page.items, "buttonNo")
	local wButton, hButton = _G.res.getSpriteBounds("", buttonYes.sprite)
	local eagle = getItemByName(page.items, "eagle")
	local eWidth, eHeight = _G.res.getSpriteBounds("",eagle.sprite)
	local blackBox = getItemByName(page.items, "upsellBlackBox")
	local title = getItemByName(page.items, "upsellTitle")
	local titleW, titleH = _G.res.getSpriteBounds("",title.sprite)
	local upsellText = getItemByName(page.items, "upsellText")
	local trailerButton = getItemByName(page.items, "trailerButton")
	local payOnceText = getItemByName(page.items, "upsellPayOnce")
	local blackBoxW = 0
	
	if(deviceModel == "ipad") then
		blackBoxW = titleW * 1.50
	else
		blackBoxW = titleW * 1.30
	end

	upsellText.textBoxSize = blackBoxW
	prepareTextItem(page, upsellText)

	
	payOnceText.textBoxSize = blackBoxW
	prepareTextItem(page, payOnceText)
	--title.y + titleH + upsellText.h / 2
	--, blackBox.y - blackBox.height / 2.25
	
	local fontH = _G.res.getFontLeading(payOnceText.font)
	
	if deviceModel == "ipad" then
		eHeight = _G.math.max(eHeight, upsellText.h + payOnceText.h + fontH * 4  + titleH)
		demoBackground.x, demoBackground.y = screenWidth / 2, screenHeight * 0.45
		
		demoBackground.width, demoBackground.height = eWidth * 1.75, eHeight 
		blackBox.width, blackBox.height = blackBoxW, demoBackground.height / 1.2
		blackBox.x, blackBox.y = demoBackground.x - demoBackground.width / 2, demoBackground.y
		eagle.x, eagle.y = demoBackground.x + demoBackground.width / 2 , demoBackground.y + demoBackground.height / 2
		title.x, title.y = blackBox.x + (blackBox.width - titleW) / 2, blackBox.y - blackBox.height / 2.25
	else
		demoBackground.x, demoBackground.y = screenWidth / 2, screenHeight * 0.5 		
		demoBackground.width, demoBackground.height = eWidth * 1.3, eHeight 
		blackBox.width, blackBox.height = blackBoxW, demoBackground.height
		blackBox.x, blackBox.y = demoBackground.x - demoBackground.width / 2, demoBackground.y
		eagle.x, eagle.y = demoBackground.x + demoBackground.width / 1.92 , demoBackground.y + demoBackground.height / 1.92
		title.x, title.y = blackBox.x + (blackBox.width - titleW) / 2, blackBox.y - blackBox.height / 2
	end
	
	
	buttonYes.x, buttonYes.y = screenWidth / 2 + 0.4 * demoBackground.width, demoBackground.y + demoBackground.height / 2 + hButton / 6
	trailerButton.x, trailerButton.y = buttonYes.x - 1.2 * wButton, buttonYes.y
	buttonNo.x, buttonNo.y = screenWidth / 2 - 0.4 * demoBackground.width, buttonYes.y
	
	upsellText.x, upsellText.y = blackBox.x, title.y + titleH + upsellText.h / 2

	payOnceText.x, payOnceText.y = upsellText.x, upsellText.y + upsellText.h / 2 + fontH + payOnceText.h / 2 


end

function getItemValues(item)
	if(item.sprite ~= nil) then
		local w,h = _G.res.getSpriteBounds(item.sprite)
		local px,py = _G.res.getSpritePivot(item.sprite)
		return {width = w, height = h, pivotX = px, pivotY = py}
	elseif(item.text ~= nil) then
		local w = _G.res.getStringWidth(item.text)
		local h = _G.res.getFontLeading(item.text)
		local px,py = w / 2, h / 2
		return {width = w, height = h, pivotX = px, pivotY = py}		
	end
end

function flowPosition(x,y,w,h,items)
	local totalw = 0
	
	for k,v in _G.pairs(items) do
	
		totalw = totalw + getItemValues(v).width
	end
	
	local diff = w - totalw
	local item1values = getItemValues(items[1])
	
	local x1 = x + (diff / 2) + item1values.pivotX
	
	
	items[1].x = x1 
	
	if(#items > 1) then
		for i = 2, #items do	
			items[i].x = x1 + getItemValues(items[i]).pivotX
--			items[i].y = y + h / 2
		end	
	end	
end

function restartLevelIngame()
	if currentGameMode == updateGame then
		-- level restarted
		settingsWrapper:incrementGameRestarted()

		if numberOfAttemptsInLevel == nil then
			numberOfAttemptsInLevel = 0
		end						
		
		if currentEpisode == "G" then
			eventManager:notify({id = events.EID_GE_LEVEL_RESTARTED, levelName = levelName})		
		elseif currentEpisode ~= "G" then
			eventManager:notify({id = events.EID_LEVEL_RESTARTED, 
								currentWorldNumber = currentWorldNumber, 
								currentLevelNumberInTheme = currentLevelNumberInTheme,
								numberOfAttemptsInLevel = numberOfAttemptsInLevel,
								birdsShot = birdsShot,
								birdsCounter = birdsCounter,
								levelRestartedFrom = levelRestartedFrom										
							})		
		end
		
		numberOfAttemptsInLevel = numberOfAttemptsInLevel + 1
		
	end
	
	setEditing(false)
	setPhysicsEnabled(false)
	--currentLevelNumber = page.items[selectedMenuItem].levelIndex or currentLevelNumber
	--currentThemeNumber = page.items[selectedMenuItem].themeIndex or currentThemeNumber
	--currentPageNumber = page.pageNumber or currentPageNumber
	--currentGameMode = function() end
	
	if not isChallengeMode() then
		eventManager:notify({id = events.EID_LEVEL_LOADING_INIT})
	else
		eventManager:notify({ id = events.EID_CHALLENGE_RESTARTED, challenge = g_currentChallenge })
		eventManager:notify({id = events.EID_CHALLENGE_STARTED, challenge = g_currentChallenge})					
	end
end

function handleGameModeChange(page, selectedMenuItem)	
	-- game specific
	
	
	if currentGameMode == updateSoundboard then
		soundboardName = page.items[selectedMenuItem].soundboard
		if soundboardName ~= nil then
			currentSoundboard = soundboardName
			currentLevelNumberInTheme = page.items[selectedMenuItem].pageLevelIndex
			initSoundboard()
		end
	end
	
	if currentGameMode == updateEditor then
		_G.res.stopAudio(currentMainMenuSong)
		levelName = page.items[selectedMenuItem].filename
		levelFolder = page.items[selectedMenuItem].folder
		setEditing(true)
		setPhysicsEnabled(physicsEnabled)
		currentLevelNumberInTheme = page.items[selectedMenuItem].pageLevelIndex or currentLevelNumberInTheme		
		currentLevelNumber = page.items[selectedMenuItem].levelIndex or currentLevelNumber
		currentThemeNumber = page.items[selectedMenuItem].themeIndex or currentThemeNumber
		currentWorldNumber = page.items[selectedMenuItem].worldNumber or currentWorldNumber
		currentPageNumber = page.pageNumber or currentPageNumber
		loadLevelInternal(levelFolder .. levelName)
	end
end



function checkLogLevelNotCompleted()
	if(highscores ~= nil and levelName ~= nil) then
		local levelNotCompleted = highscores[levelName] == nil
		
		if (levelNotCompleted and currentWorldNumber ~= nil and currentLevelNumberInTheme ~= nil) then				
			local level = getWorldLevelNumberCombination()
			eventManager:notify({id = events.EID_FLURRY_EVENT_STARTED_BEFORE_COMPLETION, level = level})	
		end				
	end
end



function releaseCutScenes()
	releaseCompoSprites( {"CUTSCENES_COMPOSPRITES"} )
	releaseImages( {"CUTSCENES"} )	
	loadBackgrounds()
	loadImages( {"MENU", "OTHER", "INGAME"} )
	loadCompoSprites( {"TUTORIALS_COMPOSPRITES", "COMPO", "MENU_COMPOSPRITES"} )
end

function releaseBackgrounds()	
	releaseImages( {"BACKGROUNDS"} )		
end

function loadBackgrounds()
	loadImages( {"BACKGROUNDS"} )
end

function loadCutScenes()
	--print(_G.debug.traceback())
	-- Fix for bug# 1758
	if(currentGameMode ~= updateGame) then
		releaseCompoSprites( {"TUTORIALS_COMPOSPRITES", "COMPO", "MENU_COMPOSPRITES"} )
		releaseImages( {"OTHER", "MENU" } )				
		releaseImages({"INGAME"})		
		releaseBackgrounds()		
		loadImages( {"CUTSCENES"} )
		loadCompoSprites( {"CUTSCENES_COMPOSPRITES"} )	
	end
end

function gotoLevelSelectionGoldenEggs(dt)
	print("(1.5.4) ep Golden Eggs clicked..\n")
	currentGameMode = function() end
	eventManager:notify({id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_G"})
end

function getGotoLevelSelection(n)

	local packIndex = n

	local f = function(dt)
		print("episode " .. packIndex .. " clicked..\n")
	
		currentMenuPage = nil
		newMenuPage = nil
		setGameMode(function() end)
		
		releaseCutScenes() --load assets before layouting newmenu		
		eventManager:notify({id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_"..n})
	end
	
	return f
end

function loadPreviousLevel(dt)
	drawGame()
	drawMenu()																																																															-- ADDED
	if isLevelSelectionPage(levelSelectionPages) then
		if currentLevelNumberInTheme <= 1 then
			levelSelectionPages.currentPage = levelSelectionPages.currentPage - 1
			if levelSelectionPages.currentPage <= 0 then
				if levelSelectionPages == levelSelectionPagesBasic then
					levelSelectionPages.currentPage = 1
				else
					if levelSelectionPages == levelSelectionPagesExtra then
						levelSelectionPages = levelSelectionPagesBasic
					elseif levelSelectionPages == levelSelectionPagesPack3 then
						levelSelectionPages = levelSelectionPagesExtra
					elseif levelSelectionPages == levelSelectionPagesPack4 then
						levelSelectionPages = levelSelectionPagesPack3
					elseif levelSelectionPages == levelSelectionPagesPack5 then						
						levelSelectionPages = levelSelectionPagesPack4
						-- ADDED
					elseif levelSelectionPages == levelSelectionPagesPack6 then						
						levelSelectionPages = levelSelectionPagesPack5
					end
					levelSelectionPages.currentPage = levelSelectionPages.pageCount
					currentLevelNumberInTheme = levelSelectionPages.levelsPerPage
					currentLevelNumber = levelSelectionPages.pageCount * levelSelectionPages.levelsPerPage
					currentThemeNumber = currentThemeNumber	- 1
					currentWorldNumber = currentWorldNumber - 1
				end
			else
				currentLevelNumberInTheme = levelSelectionPages.levelsPerPage
				currentLevelNumber = currentLevelNumber - 1
				currentThemeNumber = currentThemeNumber	- 1
				currentWorldNumber = currentWorldNumber - 1
			end

		else
			currentLevelNumberInTheme = currentLevelNumberInTheme - 1
			currentLevelNumber = currentLevelNumber - 1
		end
		
		local index = (levelSelectionPages.currentPage - 1) * levelSelectionPages.levelsPerPage + levelSelectionPages.firstLevelIndex		
		levelName = levelSelectionPages.items[currentLevelNumberInTheme + index - 1].filename
		levelFolder = levelSelectionPages.items[currentLevelNumberInTheme + index - 1].folder
			
	end
	
	levelRestartedFrom = nil
	loading = true
	setGameMode(updateLoading)
end

function loadNextLevel(dt)
	drawGame()
	
	local currentEpisode = g_episodes[currentThemeNumber]
	local currentPage = currentEpisode.pages[currentPageNumber]
	local currentLevel = currentPage.levels[currentLevelNumber]
	
	if currentLevelNumberInTheme >= #currentPage.levels then
		if currentPageNumber >= #currentEpisode.pages then
			if currentThemeNumber >= #g_episodes then
				currentThemeNumber = #g_episodes
			else
				currentLevelNumberInTheme = 1
				currentPageNumber = 1
				currentThemeNumber = currentThemeNumber + 1
			end
		else
			currentLevelNumberInTheme = 1
			currentPageNumber = currentPageNumber + 1
		end
	else
		currentLevelNumberInTheme = currentLevelNumberInTheme + 1
	end
	
	local currentLevelNumber = 0
	for i = 1, currentPageNumber - 1 do
		currentLevelNumber = currentLevelNumber + #currentEpisode.pages[i]
	end
	currentLevelNumber = currentLevelNumber + currentLevelNumberInTheme
	
	currentEpisode = g_episodes[currentThemeNumber]
	currentPage = currentEpisode.pages[currentPageNumber]
	currentLevel = currentPage.levels[currentLevelNumberInTheme]
	
	numberOfAttemptsInLevel = 1

	levelName = currentLevel.name
	levelFolder = "levels/" .. currentPage.folder_name .. "/"
	
	levelRestartedFrom = nil

	print("loadNextLevel [" .. _G.tostring(levelFolder) .. _G.tostring(levelName) .. "] (" .. _G.tostring(currentThemeNumber) .. "-" .. _G.tostring(currentLevelNumberInTheme) .. ")\n")

	eventManager:notify({id = events.EID_LEVEL_LOADING_INIT})	
	currentGameMode = function() end
end	

function hasLevelPack(n)
	return true
end

function isEpisodeOpen(id)
	--if id == 1 then return true end
	--if id == "G" then return true end
	--return settingsWrapper:isThemeCompleted(3)
	return true
end

-- Game Center main menu animations
function showLoadingInitGameCenter()
	if mainMenu and mainMenu.items then
		local leaderboards = getItemByName(mainMenu.items, "leaderboards")
		local achievements = getItemByName(mainMenu.items, "achievements")
		local loaderLB = getItemByName(mainMenu.items, "loaderLB")
		local loaderAC = getItemByName(mainMenu.items, "loaderAC")
		
		achievements.selectable = false
		leaderboards.selectable = false
		
		loaderLB.x, loaderLB.y = leaderboards.x, leaderboards.y
		loaderAC.x, loaderAC.y = achievements.x, achievements.y
		
		loaderLB.show = true
		loaderAC.show = true
		
		loaderLB.angle = 0
		loaderAC.angle = 0
		
		leaderboards.sprite = "BUTTON_EMPTY"
		achievements.sprite = "BUTTON_EMPTY"
		
		initGameCenter()

		leaderboards.callFunction = nil
		achievements.callFunction = nil
	end
end

function hideLoadingInitGameCenter()

end

function showLoadingLeaderboards()
	local leaderboards = getItemByName(mainMenu.items, "leaderboards")
	local loader = getItemByName(mainMenu.items, "loaderLB")
	
	getItemByName(mainMenu.items, "achievements").selectable = false
	getItemByName(mainMenu.items, "achievements").sprite = "BUTTON_ACHIEVEMENTS_DISABLED"
	
	loader.x, loader.y = leaderboards.x, leaderboards.y
	loader.show = true
	loader.angle = 0
	leaderboards.sprite = "BUTTON_EMPTY"
	
	showLeaderboards()

	leaderboards.callFunction = nil
end

function hideLoadingLeaderboards()
	local main_menu = menuManager:getLink("MAIN_MENU")
	
	if main_menu then
		main_menu:resetGameCenterButtons()
	end
end

function showLoadingAchievements()
	local achievements = getItemByName(mainMenu.items, "achievements")
	local loader = getItemByName(mainMenu.items, "loaderAC")
	
	getItemByName(mainMenu.items, "leaderboards").selectable = false
	getItemByName(mainMenu.items, "leaderboards").sprite = "BUTTON_LEADERBOARDS_DISABLED"
	
	loader.x, loader.y = achievements.x, achievements.y
	loader.show = true
	loader.angle = 0
	achievements.sprite = "BUTTON_EMPTY"
	
	showAchievements()
	
	achievements.callFunction = nil
end

function hideLoadingAchievements()
	local main_menu = menuManager:getLink("MAIN_MENU")
	
	if main_menu then
		main_menu:resetGameCenterButtons()
	end
end

--- end of Game Center main menu animations

-- Show system game popup
function showSystemPopup(title, message, icon)
	getItemByName(systemPopup.items, "title").text = title
	getItemByName(systemPopup.items, "message").text = message
	getItemByName(systemPopup.items, "icon").sprite = icon
	setActivePopupPage(systemPopup)
end

function hideSystemPopup()
	popupPage = nil
end

-- FB Like popup
function showFBLikePopup()
	showSystemPopup("TEXT_FB_LEVELS_HINT_TITLE", "TEXT_FB_LEVELS_HINT")
end

-- about
function showPauseMenu(dt)
	levelRestartedFrom = "pause menu"
	setGameMode(updateMenu)
	
	_G.res.stopAudio("wood_rolling")
	_G.res.stopAudio("rock_rolling")
	_G.res.stopAudio("light_rolling")
		
	
	--print(_G.debug.traceback())
	loginfo(" - Show pausemenu - ")
--	processManager:reset()
	--setAnimationState("ingamePausePageScroll", "ENTERING")
	--setActiveMenuPage(pausePage, true)
		
	--stop looping rolling sounds
	--drawMenu()
	-- create a web view if it has not been created yet
end


function hidePauseMenu(dt)
	showHatcheryIngameMenu(true)
end

function showEagleTimeLeft()
	eagleInfoTimer = 3.0
	--setGameMode(updateMenu)
	--drawMenu()
	--print("eagle lost clicked\n")
end

function launchEagleBaitInGame()
	--inGameEagleButtonVisible = false
	--setAnimationState("ingamePausePageScroll", "EXITING")
	--setActiveMenuPage(pausePage, false)
	
	rubberBandPos.x = levelStartPosition.x
	rubberBandPos.y = levelStartPosition.y
	rubberBandSpeed = 0
	
	if currentBirdName ~= nil and objects.world[currentBirdName].shot ~= true then
		removeBird(objects.world[currentBirdName])
	elseif birdToSlingshotBirdName ~= nil then 
		removeBird(objects.world[birdToSlingshotBirdName])
		currentBirdIndex = currentBirdIndex + 1
	end
	local nextBirdName = nil
	repeat
		currentBirdIndex = currentBirdIndex + 1
		nextBirdName = getNextBird(currentBirdIndex)
		if nextBirdName ~= nil then
			removeBird(objects.world[nextBirdName])
		end
	until nextBirdName == nil
	currentBirdIndex = currentBirdIndex - 1
	birdToSlingshotBirdName = nil
	currentBirdName = nil
	launchEagleBait()
	if #birdTutorialPopups == 0 then
		changeResolution = nil
	end
	fillInNextBird = true
end

function launchEagleBait()
	eventManager:notify({ id = events.EID_EAGLE_BAIT_LAUNCHED })
	local tempFlyingBird = flyingBird
	returnToBirdCamera()
	flyingBird = tempFlyingBird

	eagleSoundPlayed = nil
	eagleBaitLaunched = true
	--inGameEagleButtonVisible = false
	levelCompleteTimer = 0
	levelFailedTimer = -200
	
	-- baitsardine is the next bird
	--baitSardine.x, baitSardine.y = levelStartPosition.x, levelStartPosition.y
	local obj = baitSardine
	local name = createObject(blockTable, obj.definition, obj.name, obj.x*scaleFactor, obj.y*scaleFactor)

	-- clamp angle to 0 - 2*PI range
	obj.angle = _G.math.fmod(obj.angle, _G.math.pi*2)
	if obj.angle < 0 then
		obj.angle = obj.angle + _G.math.pi*2
	end
	
	setRotation(name, obj.angle)
	setMaterial(name, objects.world[name].material)

	if objects.world[name].texture ~= nil then	
		local texture = blockTable.themes[name].texture		
		setTexture(name, texture)
	end
	
	if objects.world[name].controllable then
		birdsCounter = birdsCounter + 1
		objects.world[name].startNumber = birdsCounter
	end
	objects.world[name].animTimer = 3
	objects.world[name].jumpTimer = 3
	birds[name] = objects.world[name]
	local sprites = getDamageSprite(objects.world[name], blockTable.blocks)
	objects.world[name].damageSprite = sprites.sprite
	objects.world[name].blinkSprite = sprites.blink		
	objects.world[name].smileSprite = sprites.smile		
	objects.world[name].frozen = false
	objects.world[name].isEagleBait = true
	objects.world[name].recordTrajectory = false
	
	if not settingsWrapper:getTutorialsForItem(objects.world[name].sprite) then
		settingsWrapper:createTutorialForItem(objects.world[name].sprite, blockTable.blocks[objects.world[name].definition].tutorialInfo)
		_G.table.insert(birdTutorialPopups, blockTable.blocks[objects.world[name].definition].tutorialInfo)
		--[[
		if deviceModel == "iphone4" then
			changeResolution = true
			wantedResolution = "HALF"
		end
		]]--
	else
		--[[
		if deviceModel == "iphone4" then
			changeResolution = true
			wantedResolution = "FULL"
		end
		]]--
	end
	
	--menuManager:deactivate()
	setGameMode(updateGame)
	setPhysicsEnabled(true)
	nextBirdTimer = 0.1
	drawGame()
end

function setEffectsVolume(volume)
	for i = 0, 4 do
		_G.res.setTrackVolume(volume, i)
	end
end

function setMusicVolume(volume)
	_G.res.setTrackVolume(volume, 7)
end

function changeAudio()
	if settingsWrapper:isAudioEnabled() then
		audioRampVolume = _G.res.getTrackVolume(7)
		audioRampLength = -0.5
--		pausePage.items[2].visible = true
	else
		audioRampVolume = _G.res.getTrackVolume(7)
		audioRampLength = 0.5
--		pausePage.items[2].visible = false
		_G.res.startAudioOutput()
	end
	settingsWrapper:toggleAudioEnabled()
	saveLuaFileWrapper("settings.lua", "settings", true)
end

function gotoMightyEagleTrailer()
	eventManager:notify({id = events.EID_MIGHTY_EAGLE_TRAILER_CLICKED})
	--_G.res.openURL(MIGHTY_EAGLE_TRAILER)
end

function gotoSeasonsInAppStore()
	eventManager:notify({events.EID_SEASONS_LINK_CLICKED})
	_G.res.openURL(APP_STORE_HALLOWEEN_URL)
end

function gotoNewsLetter()
	eventManager:notify({id = events.EID_NEWSLETTER_CLICKED})
	_G.res.openURL(NEWSLETTER_URL)
end


function gotoABFBConnect()
	
	eventManager:notify({id = events.EID_SHOW_LOADING_PAGE})			
	if(iOS ~= true) then
		
		if not settingsWrapper:isFbPageLiked() then
			settingsWrapper:setFbPageLiked()				
			eventManager:notify({id = events.EID_HIDE_LOADING_PAGE})
			_G.res.openURL(AB_FBCONNECT_URL)
			eventManager:notify( { id = events.EID_FACEBOOK_LIKE_CLICKED })
		else
			showFBLiked()		
		end
	else
		-- Create a WebView if it hasn't been created yet
		if not ABLikeViewCreated and not settingsWrapper:isFbPageLiked() and webViewIsSupported then
			if deviceModel == "ipad" then
				ABLikeView = _G.WebView.new((screenWidth - 640) / 2, (screenHeight - 480) / 2, 480, 640)
			else
				ABLikeView = _G.WebView.new(0, 0, screenHeight, screenWidth)
			end
			print("1. Created AB Like view\n")

			ABLikeViewCreated = true
			isWebViewLoading = true
			-- Add onLinkClicked call-back
			local onLinkClickedABLike = function(view, url)
				print("link clicked: "..url.."\n")
				local beginIndex, endIndex = _G.string.find(url, "close")
				if beginIndex ~= nil and beginIndex >= 1 then
					return _G.WebView.LOAD_PAGE_INTO_WEBVIEW
				else
					return _G.WebView.DONT_LOAD_PAGE
				end
			end
			
			ABLikeView:setOnLinkClickedCallback(onLinkClickedABLike)
			
			-- Load RovioNews
			local onPageLoadedABLike = function(view, success, pageTitle)
				isWebViewLoading = false
				--webViewTimeout = 0
				print(" - - onPageLoadedABLike()\n")
				
				local beginIndex, endIndex = _G.string.find(pageTitle, "404")
				if success and beginIndex == nil then
					if pageTitle == "dismissABLikePage[jqrt]" then
						ABLikeView:hide()
						popupPage = nil

						eventManager:notify({id = events.EID_HIDE_LOADING_PAGE})
--						menuManager:setEnabled(true)
						
						print("2. dismissABLikePage[jqrt]")
--						menuManager:setUpdateEnabled(true)
						
					elseif pageTitle == "dismissABLikePage[jqrtakta]" then
						popupPage = nil
						eventManager:notify({id = events.EID_HIDE_LOADING_PAGE})
						view:hide()
						settingsWrapper:setFbPageLiked()
						
						eventManager:notify( { id = events.EID_FACEBOOK_LIKE_CLICKED })
						view:delete()
						ABLikeView = nil
						ABLikeViewCreated = nil
--						menuManager:setUpdateEnabled(false)
						
						print("3. dismissABLikePage[jqrtakta]")						
						--setActiveMenuPage(currentMenuPage, true)
					else
						print("4. Show ABLikeView")						
						ABLikeView:executeJavaScript("document.addEventListener('touchmove', function(e){ e.preventDefault(); });")
						isWebViewLoading = true						
						
						view:show()
					end
				else
					if popupPage ~= systemPopup then
						popupPage = nil
						eventManager:notify({id = events.EID_HIDE_LOADING_PAGE})
--						menuManager:setUpdateEnabled(true)
						print("5. Network error\n")
						--showSystemPopup("TEXT_NETWORK_ERROR_TITLE", "TEXT_NETWORK_ERROR")
						eventManager:notify({id = events.EID_PUSH_FRAME, target = ui.Prompt:new({title = "TEXT_NETWORK_ERROR_TITLE", content = "TEXT_NETWORK_ERROR"})}) 
					end
				end
				print("pageTitle: "..pageTitle.."\n")
			end
			
			ABLikeView:setOnPageLoadedCallback(onPageLoadedABLike)					
		elseif not webViewIsSupported and not settingsWrapper:isFbPageLiked() then
			print("6.Network error\n")
			
			_G.res.openURL(AB_FBCONNECT_URL)
			eventManager:notify( { id = events.EID_FACEBOOK_LIKE_CLICKED })
			eventManager:notify({id = events.EID_HIDE_LOADING_PAGE})
			
		elseif settingsWrapper:isFbPageLiked() then
			--showSystemPopup("TEXT_LIKE_CONFIRMED_TITLE", "TEXT_LIKE_CONFIRMED")
			print("7. page was liked \n")
			showFBLiked()
		end
		
		if ABLikeView ~= nil then
			print("8. Loading web view \n")
			isWebViewLoading = true
			--setActivePopupPage(loadingPage)
			ABLikeView:loadPage(ABLIKE_URL)
		end		
	end
end

function showFBLiked()
	eventManager:notify({id = events.EID_PUSH_FRAME, target = ui.Prompt:new({title = "TEXT_LIKE_CONFIRMED_TITLE", content = "TEXT_LIKE_CONFIRMED"})}) 
	eventManager:notify({id = events.EID_HIDE_LOADING_PAGE})				
	
end

function gotoABShop()
	setGameMode(updateMenu)
	if isLiteVersion then
		setActiveMenuPage(levelSelectionPagesBasic, true)
	else
		setActiveMenuPage(episodeSelectionPage, true)
	end
	drawMenu()
	eventManager:notify({id = events.EID_ABSHOP_LINK_CLICKED})
	
	_G.res.openURL(ABSHOP_URL)
end

function gotoAndroidMarket()
	_G.res.openURL(ANDROID_MARKET_FULL_VERSION_URL)
end

function gotoPrivacyPolicy()
	_G.res.openURL(PRIVACY_POLICY_URL)
end

function gotoEula()
	_G.res.openURL(EULA_URL)
end

function gotoFacebook()
	eventManager:notify({id = events.EID_FACEBOOK_LINK_CLICKED})
	_G.res.openURL(FACEBOOK_URL)
end

function gotoTwitter()
	eventManager:notify({id = events.EID_TWITTER_LINK_CLICKED})	
	_G.res.openURL(TWITTER_URL)
end

function gotoAngryBirdsTrailer()
	eventManager:notify({id = events.EID_CINEMATIC_TRAILER_CLICKED})
	_G.res.openURL(ANGRY_BIRDS_TRAILER_URL)
	
	--playVideo( "videos/lite_iPhone.m4v" )
end

function gotoOviStore(dt)
	if deviceModel == "n900" then
		_G.res.openURL(OVI_STORE_URL)
	elseif deviceModel == "s60" then
		_G.res.openURL(OVI_STORE_URL_S60)
	end
	setGameMode(updateMenu)
end

function gotoS60UpdatePage()
	_G.res.openURL(ROVIO_UPDATE_URL_S60)
end

function gotoMoreOnOviStore()
	_G.res.openURL(OVI_STORE_MORE_GAMES_URL_S60)
	removePopupMenu()
end


function showTutorials()
	eventManager:notify({id = events.EID_TUTORIAL_VIEWED})

	if settingsWrapper:getTutorialsForItem("BIRD_RED") then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_RED").sprite)
	end
	if settingsWrapper:getTutorialsForItem("BIRD_BLUE") then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_BLUE").sprite)
	end
	if settingsWrapper:getTutorialsForItem("BIRD_YELLOW") then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_YELLOW").sprite)
	end
	if settingsWrapper:getTutorialsForItem("BIRD_GREY") then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_GREY").sprite)
	end
	if settingsWrapper:getTutorialsForItem("BIRD_GREEN") then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_GREEN").sprite)
		showTutorialGoldenEgg = true
	end
	if settingsWrapper:getTutorialsForItem("BIRD_BOOMERANG") ~= nil then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_BOOMERANG").sprite)
	end
	if settingsWrapper:getTutorialsForItem("BIRD_BIG_BROTHER") ~= nil then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BIRD_BIG_BROTHER").sprite)
	end
	if settingsWrapper:getTutorialsForItem("BAIT_SARDINE") ~= nil then
		_G.table.insert(birdTutorialPopups, settingsWrapper:getTutorialsForItem("BAIT_SARDINE").sprite)
	end
	--setGameMode(hidePauseMenu)
--	pausePage.backgroundOverlay.shade = 0
	if #birdTutorialPopups > 0 then
		prepareMenuPage(tutorials)
	end
	drawMenu()
end

function addPopupMenu()
end

function removePopupMenu()
end

-------------------------------------------------------------------------------


function drawMenuPage(page)
	
	if page == nil then
		return
	end
	
	if(page ~= nil and page == dummyPopupPage and page.rootContainer ~= nil) then
		page.rootContainer:draw(0,0)
	end
	
	if deviceModel == "iphone4" and ((changeResolution ~= true and wantedResolution == "FULL") or (changeResolution == true and wantedResolution == "HALF")) then
		setRenderState(-screenWidth * 0.5, -screenHeight * 0.5, 2, 2, 0)
	else
		setRenderState(0, 0, 1, 1, 0)
	end

	if page.backgroundDrawFunction ~= nil then
		page.backgroundDrawFunction(page)
	end
	
	if page.backgroundOverlay ~= nil then
		if page.backgroundOverlay.sprite ~= nil and page.backgroundOverlay.visible ~= false then
			if page.backgroundOverlay.sprite == "DIM_BLOCK" and page.backgroundOverlay.shade ~= nil then
				if page.backgroundOverlay.shade ~= 0 then
					drawRect( 0, 0, 0, page.backgroundOverlay.shade, 0, 0, screenWidth, screenHeight, false)
				end
			else
				w, h = _G.res.getSpriteBounds("", page.backgroundOverlay.sprite)
				for y = 0, screenHeight/h do
					for x = 0, screenWidth/w do
						_G.res.drawSprite("", page.backgroundOverlay.sprite, _G.math.floor(x*w), _G.math.floor(y*h))
					end
				end
			end
		end
	end

	drawMenuBackground(page)
	
	
	drawMenuItems(page)
	drawMenuTitle(page)	
	setRenderState(0, 0, 1, 1, 0)
end

function drawMenuBackground(page)

	if page.backgroundBox ~= nil then
		local sx, sy = 0, 0

		if page.backgroundBox.x ~= nil then
			sx = page.backgroundBox.x
		end
		if page.backgroundBox.y ~= nil then
			sy = page.backgroundBox.y
		end
		
		local x, y = offsetCoordinates(page, sx, sy)
		local sheet = ""
		if page.backgroundBox.sheet ~= nil then
			sheet = page.backgroundBox.sheet
		end
		
		setRenderState(0, 0, 1, 1, 0, 0, 0)
		if page.backgroundBox.color ~= nil then
			local r,g,b,a = 1.0, 1.0, 1.0, 1.0
			if page.backgroundBox.color.red ~= nil then
				r = page.backgroundBox.color.red
			end
			if page.backgroundBox.color.green ~= nil then
				g = page.backgroundBox.color.green
			end
			if page.backgroundBox.color.blue ~= nil then
				b = page.backgroundBox.color.blue
			end
			if page.backgroundBox.color.alpha ~= nil then
				a = page.backgroundBox.color.alpha
			end
			
			drawBox(page.backgroundBox.sprites, sheet, _G.math.floor(x), _G.math.floor(y), _G.math.floor(page.backgroundBox.width), _G.math.floor(page.backgroundBox.height), page.backgroundBox.hanchor, page.backgroundBox.vanchor, { red = r, green = g, blue = b, alpha = a })
		else
			drawBox(page.backgroundBox.sprites, sheet, _G.math.floor(x), _G.math.floor(y), _G.math.floor(page.backgroundBox.width), _G.math.floor(page.backgroundBox.height), page.backgroundBox.hanchor, page.backgroundBox.vanchor, nil)
		end
	
	elseif page.backgroundSprite ~= nil then
		if page.backgroundSprite.scale and page.backgroundSprite.xs and page.backgroundSprite.ys then
			setRenderState(0, 0, page.backgroundSprite.xs, page.backgroundSprite.ys, 0)
			_G.res.drawSprite("", page.backgroundSprite.name, _G.math.floor(page.backgroundSprite.x) / page.backgroundSprite.xs, _G.math.floor(page.backgroundSprite.y) / page.backgroundSprite.ys)
			setRenderState(0, 0, 1, 1, 0)
		else
			local sx, sy = 0, 0

			if page.backgroundSprite.x ~= nil then
				sx = page.backgroundSprite.x
			end
			if page.backgroundSprite.y ~= nil then
				sy = page.backgroundSprite.y
			end
			
			local x, y = offsetCoordinates(page, sx, sy)
				
			setRenderState(0, 0, 1, 1, 0)
			_G.res.drawSprite("", page.backgroundSprite.name, _G.math.floor(x), _G.math.floor(y))
		end
	end
end

function drawMenuTitle(page)
	if page.title == nil then
		return
	end
	
	local title = page.title
	
	local x = 0
	local y = 0
	
	if title.text ~= nil then
		x = screenWidth * 0.5
		y = (_G.res.getFontMaxAscending() + _G.res.getFontMaxDescending()) * 0.75
	end
	
	if title.x ~= nil then
		x = title.x
	end		
	if title.y ~= nil then
		y = title.y
	end		

	x, y = offsetCoordinates(page, x, y)

	setRenderState(0, 0, 1, 1, 0)
	if title.text ~= nil then
		local hanchor = "HCENTER"
		local vanchor = "VCENTER"
		hanchor = title.hanchor and title.hanchor or hanchor
		vanchor = title.vanchor and title.vanchor or vanchor
		
		setFont(defaultMenuFont) --japanese version

		if title.font ~= nil then
			setFont(title.font)
		end
		_G.res.drawString("TEXTS_BASIC", title.text, _G.math.floor(x), _G.math.floor(y), hanchor, vanchor)
	end

	if title.sprite ~= nil then
		_G.res.drawSprite("", title.sprite, _G.math.floor(x), _G.math.floor(y))
	end
end

function drawMenuItems(page)
	
	-- check if user want's to draw one whole item at a time or all sprites (and boxes) first and then text
	local drawSprites = true
	local drawText = true
	local loops = 0
	if page.drawSpritesFirst == true then
		drawText = false
		loops = 1
	end
	
	if (page == goldenEggAchievedPage or page == boomerangBirdAchievedPage) and page.items[1].visible == true then
		local starEffectSprite = "GOLDEN_EGG_STAR_EFFECT"
		setRenderState(0, 0, 1, 1, page.items[1].angle, _G.res.getSpritePivot("", starEffectSprite))
		_G.res.drawSprite("", starEffectSprite, page.items[1].x, page.items[1].y)
		setRenderState(0, 0, 1, 1, 0)
	end
	
	if page == mightyEaglePaymentPage and page.items[1].angle < 1080 then		
		setRenderState(0, 0, 1, 1, page.items[1].angle, _G.res.getSpritePivot("", page.items[1].sprite))
		_G.res.drawSprite("", page.items[1].sprite, page.items[1].x, page.items[1].y)
		setRenderState(0, 0, 1, 1, 0)
	end
	
	if page == goldenEggStarAchievedPage and page.items[1].visible == true and page.items[2].visible == true then
		local starEffectSprite = "GOLDEN_EGG_STAR_EFFECT"
		setRenderState(0, 0, 1, 1, page.items[1].angle, _G.res.getSpritePivot("", starEffectSprite))
		_G.res.drawSprite("", starEffectSprite, page.items[1].x, page.items[1].y)
		setRenderState(0, 0, 1, 1, 0)
	end
	
	-- draw normal menu items
	for k = 0, loops do
		local i = 1
		while i <= #page.items do
			local ci = page.items[i]
			if ci.visible ~= false then
				-- calculate position
				local x = screenWidth/2
				local y = screenHeight/(#page.items + 1) * i
				x = ci.x and ci.x or x
				y = ci.y and ci.y or y
				x, y = offsetCoordinates(page, x, y)
				if ci.itemDrawFunction ~= nil then
					ci.itemDrawFunction(page, ci, x, y, drawSprites, drawText)
				else
					drawMenuItem(page, ci, _G.math.floor(x), _G.math.floor(y), drawSprites, drawText)
				end
			end
			i = i + 1
		end
		drawSprites = not drawSprites
		drawText = not drawText
	end
end

function drawHatcheryStar(page, star, x, y, drawSprites, drawText)
	if(star.visible == false) then
		return
	end
	local starEffectSprite = star.sprite
	star.sx = star.sx or 1
	star.sy = star.sy or 1
	star.angle = star.angle or 0
	setRenderState(0, 0, star.sx, star.sy, star.angle, _G.res.getSpritePivot("", starEffectSprite))
	_G.res.drawSprite("", starEffectSprite, star.x / star.sx, star.y / star.sy)
	setRenderState(0, 0, 1, 1, 0)
	
end

function drawMenuItem(page, item, x, y, drawSprites, drawText)
	
	if item.visible == false then
		return
	end
	
	local ci = item
	
	-- get anchor data
	local hanchor = ci.hanchor and ci.hanchor or "HCENTER"
	local vanchor = ci.vanchor and ci.vanchor or "VCENTER"
	
	if drawSprites == true then
		if ci.sprite ~= nil then
			local sheet = ""
			if ci.sheet ~= nil then
				sheet = ci.sheet
			end
			
			if ci.alpha ~= nil then
				setAlpha(ci.alpha)
			end
			
			if page.scale and page.xs and page.ys then
				if ci.isCompoSprite then
					setRenderState(0, 0, page.xs, page.ys)
					_G.res.drawCompoSprite("", ci.sprite, _G.math.floor(x) / page.xs, _G.math.floor(y) / page.ys)
					setRenderState(0, 0, 1, 1)
				else
					setRenderState(0, 0, page.xs, page.ys)
					_G.res.drawSprite(sheet, ci.sprite, _G.math.floor(x) / page.xs, _G.math.floor(y) / page.ys)
					setRenderState(0, 0, 1, 1)
				end
			else
				if ci.isCompoSprite then
					_G.res.drawCompoSprite("", ci.sprite, _G.math.floor(x), _G.math.floor(y))
				else
					_G.res.drawSprite(sheet, ci.sprite, _G.math.floor(x), _G.math.floor(y))
				end
			end
			
			if ci.alpha ~= nil then
				setAlpha(1)
			end
			
		elseif ci.box ~= nil then
			
			local sheet = ""
			if ci.sheet ~= nil then
				sheet = ci.sheet
			end
			
			if ci.color ~= nil then
				local r,g,b,a = 1.0, 1.0, 1.0, 1.0
				if ci.color.red ~= nil then
					r = ci.color.red
				end
				if ci.color.green ~= nil then
					g = ci.color.green
				end
				if ci.color.blue ~= nil then
					b = ci.color.blue
				end
				if ci.color.alpha ~= nil then
					a = ci.color.alpha
				end
				
				drawBox(ci.box, sheet, _G.math.floor(x), _G.math.floor(y), _G.math.floor(ci.width), _G.math.floor(ci.height), ci.hanchor, ci.vanchor, { red = r, green = g, blue = b, alpha = a })
			else
				drawBox(ci.box, sheet, _G.math.floor(x), _G.math.floor(y), _G.math.floor(ci.width), _G.math.floor(ci.height), ci.hanchor, ci.vanchor, nil)
			end
		end
	end
	
	if drawText == true then
		if ci.lines ~= nil then
			--check font
			setFont(ci.font)

			local fh = _G.res.getFontLeading()			
			local k = 1
			while k <= #ci.lines do
				_G.res.drawString("", ci.lines[k], _G.math.floor(x), _G.math.floor(y - ci.h * 0.5 + fh * (k-0.5)), hanchor, vanchor)
				k = k + 1
			end			
		end
	end
	
	if ci.children ~= nil then
		for i = 1, #ci.children do
			local childItem = ci.children[i]
--			if(childItem.name ~= nil) then
	--			print("name = "..(childItem.name).."\n")
		--	end
			drawMenuItem(page, childItem, childItem.x + x, childItem.y + y, drawSprites, drawText)
		end
	end
end

function goldenEggMenuDimDraw(page, item, x, y, drawSprites, drawText)
	if getItemByName(page.items, "overlay").visible then
		local itm = getItemByName(page.items, "overlay")
		drawRect( 0, 0, 0, itm.shade, itm.x, itm.y, screenWidth, screenHeight, false)
	end
end

-- Menu stuff ends
-------------------------------------------------------------------------------

function drawLevelSelectionBackground(page)
	setRenderState(0, 0, -1, 1, 0)
	_G.res.drawSprite("", "LS_BACKGROUND", -screenWidth, 0, "LEFT", "TOP", _G.math.ceil(screenWidth / 2), screenHeight)
	setRenderState(0, 0, 1, 1, 0)
	_G.res.drawSprite("", "LS_BACKGROUND", 0, 0, "LEFT", "TOP", _G.math.floor(screenWidth / 2), screenHeight)
	setRenderState(0, 0, 1, 1, 0)	
end

--hack: draw new UI progress bar component on the old pause page
--todo: remove when getting rid of the old pause page!
--[[
function drawOldPausePageGrindBar(page, item, x, y, drawSprites, drawText)

	if isChallengeMode() then return end
	if g_episodes[currentThemeNumber].extra then return end

	local max_stars = getHatcheryStarMaximum(levelName)
	local stars = 0
	if highscores[levelName] and highscores[levelName].hatcheryStars then
		stars = highscores[levelName].hatcheryStars
	end
	local bar =
	{
		children = {},
		x = x + pausePage.offsetX,
		y = y,
		scaleX = 1,
		scaleY = 1,
		backgroundImage = "STAR_METER_EMPTY",
		barImage = "STAR_METER_FULL",
		value = max_stars - stars,
		max = max_stars,
	}

	ui.ProgressBar.draw(bar, 0, 0)
end]]

--hack: draw old pause page background in new style
--todo: get rid of when updating pause page to use new menu system
function drawOldPauseBackground(page)
	drawGame()
	drawRect(0, 0, 0, 0.65, page.offsetX, 0, page.offsetX + page.background.width, screenHeight, false)
end

function starEffectItemDraw(page, item, x, y, drawSprites, drawText)
	local ci = item
	local starEffectSprite = "GOLDEN_EGG_STAR_EFFECT"
	if ci.sprite ~= nil then
		starEffectSprite = ci.sprite
	end
	setRenderState(0, 0, 1, 1, ci.angle, _G.res.getSpritePivot("", starEffectSprite))
	_G.res.drawSprite("", starEffectSprite, ci.x, ci.y)
	setRenderState(0, 0, 1, 1, 0)
--	ci.angle = ci.angle + 1.6 * dt
end

function buttonSliderDraw(page, item, x, y, drawSprites, drawText)
	local ci = item
	local buttonSprite = "BUTTON_OPTIONS"
	if ci.sprite ~= nil then
	buttonSprite = ci.sprite
	end
	local px, py = _G.res.getSpritePivot("", buttonSprite)
	if deviceModel == "ipad" then
	setRenderState(0, 0, 1, 1, ci.angle, px, py)
	_G.res.drawSprite("", buttonSprite, ci.x, ci.y)
	else
	setRenderState(0, 0, 1, 1, ci.angle, px - 0.5, py - 0.5)
	_G.res.drawSprite("", buttonSprite, ci.x, ci.y + 1)
	end
	setRenderState(0, 0, 1, 1, 0)	
end

function buttonSliderOptionsDraw(page, item, x, y, drawSprites, drawText)
	local ci = item
	local buttonSprite = "BUTTON_SLIDER"
	if ci.sprite ~= nil then
		buttonSprite = ci.sprite
	end
	
	local px, py = _G.res.getSpritePivot("", buttonSprite)
	if deviceModel == "ipad" or (deviceModel == "android" and isHDVersion) then
		setRenderState(0, 0, 1, 1, ci.angle, px + 0.25, py - 0.5)
		_G.res.drawSprite("", buttonSprite, ci.x, ci.y)
	else
		setRenderState(0, 0, 1, 1, ci.angle, px + 0.5, py + 0.5)
		_G.res.drawSprite("", buttonSprite, ci.x, ci.y)
	end
	setRenderState(0, 0, 1, 1, 0)	
end

function eagleFeatherFillDraw(page, item, x, y, drawSprites, drawText)
	local ci = item
	local fillEffectSprite = "EAGLE_METER_FILL"
	if ci.sprite ~= nil then
		fillEffectSprite = ci.sprite
	end
	local w, h = _G.res.getSpriteBounds("", fillEffectSprite)
	local px, py = _G.res.getSpritePivot("", fillEffectSprite)
	local left = x - px
	local top = y - py
	
	_G.res.setClipRect(left, 0, _G.math.floor(w * (ci.fill / 100)), screenHeight)
	_G.res.drawSprite("", fillEffectSprite, ci.x, ci.y)
	_G.res.setClipRect(0, 0, screenWidth, screenHeight)
end
-------------------------------------------------------------------------------

function filterLoadedLevel()
	if currentGameMode ~= updateEditor then
		
		local goldenEgg = function(level)
			return settingsWrapper:isGoldenEggUnlocked(level)
		end
		
		local boomerangBird = function(s)
			return settings[s] == true
		end
		
		local filterItems =
		{
			{ world =  4, level =  7, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_5") },
			{ world =  5, level = 19, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_3") },
			{ world =  8, level = 15, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_8") },
			{ world =  6, level =  4, item = "ExtraBoomerangBird_1", check = boomerangBird("boomerangBirdAchieved") },
			{ world =  9, level =  5, item = "ExtraBoomerangBird_1", check = boomerangBird("boomerangBirdAchieved2") },
			{ world =  9, level = 14, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_9") },
			{ world = 11, level = 15, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_11") },
			{ world = 13, level = 10, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_17") },
			{ world = 13, level = 12, item = "ExtraSuperBowl_2", check = goldenEgg("LevelGE_19") },
			{ world = 14, level =  4, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_18") },
			{ world = 15, level = 12, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_20") },
			{ world = 16, level =  9, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_21") },
			{ world = 17, level = 12, item = "ExtraTreasureChest_1", check = goldenEgg("LevelGE_23") },
			{ world = 18, level =  6, item = "ExtraGoldenEgg_1", check = goldenEgg("LevelGE_24") },
		}
		
		for i = 1, #filterItems do
			if currentWorldNumber == filterItems[i].world and
			   currentLevelNumberInTheme == filterItems[i].level and
			   filterItems[i].check then
			
				loadedObjects.world[filterItems[i].item] = nil
				
				for k, v in _G.pairs(loadedObjects.joints) do
					if v.end1 == filterItems[i].item or v.end2 == filterItems[i].item then
						loadedObjects.joints[k] = nil
					end
				end
			end
		end
	end
end

function showRewardPopup(type, params)
	local popup
	
	if type == "GOLDEN_EGG" then
		popup = GoldenEgg:new()
		_G.res.playAudio("goldenegg", 1, false)
	elseif type == "BOOMERANG_BIRD" then
		popup = BoomerangBirdPopup:new()
		_G.res.playAudio("star_collect", 1, false)
	elseif type == "STAR" then
		popup = StarPopup:new(params.first_time)
		_G.res.playAudio("star_collect", 1, false)
	elseif type == "GENERIC_REWARD" then
		popup = RewardPopup:new(params.sprite)
		_G.res.playAudio(params.sound, 1, false)
	end
	
	notificationsFrame:addChild(popup)
	popup.x = screenWidth * 0.5
	popup.y = screenHeight * 0.9
	
	local duration = 1.2
	
	processManager:insertAction({name = "golden egg rise", finished = false, item = popup, start = 0, duration = duration, meta = {},
		action = function(item,elapsed,target,dt,meta)
			local moveRate = tweenEaseCubicIn(elapsed, 0,1,target)
			local rate = elapsed / target
			item.y = (2.5 - moveRate * 1.5) * (screenHeight * 0.5)
			item.x = screenWidth * 0.5
			item.angle = item.angle + dt * 2	
			item.visible = true
			item:getChild("egg").visible = true
			item:getChild("egg").angle = -item.angle
			item.rate = rate
		end
	})
	
	processManager:insertAction({name = "golden egg stay middle", finished = false, item = popup, start = duration, duration = duration, meta = {},
		action = function(item,elapsed,target,dt,meta)
			item.angle = item.angle + dt * 2	
			item.x = screenWidth * 0.5			
			item:getChild("egg").angle = -item.angle			
		end
	})
	
	processManager:insertAction({name = "golden egg go away", finished = false, item = popup, start = duration * 2, duration = duration, meta = {},
		action = function(item,elapsed,target,dt,meta)
			local moveRate = tweenEaseCubicIn(elapsed, 0,1,target)
			local rate = elapsed / target
			item.y = screenHeight * 0.5 - (moveRate * 0.7 * screenHeight)
			item.angle = item.angle + dt * 2	
			item.rate = 1.0 - rate			
			item.x = screenWidth * 0.5			
			item:getChild("egg").angle = -item.angle			
		end
	})
	
	processManager:start()
	
end

function revealGoldenEgg(name)
	settingsWrapper:unlockGoldenEgg(name)
	
	--[[
	local egg = GoldenEgg:new()
	egg.name = name
	
	notificationsFrame:addChild(egg)
	egg.x = screenWidth / 2
	egg.y = screenHeight * 0.9	
	
	
	local duration = 1.2
	processManager:insertAction({name = "golden egg rise", finished = false, item = egg, start = 0, duration = duration, meta = {},
		action = function(item,elapsed,target,dt,meta)
			local moveRate = tweenEaseCubicIn(elapsed, 0,1,target)
			local rate = elapsed / target
			item.y = (2.5 - moveRate * 1.5) * (screenHeight * 0.5)
			item.x = screenWidth * 0.5
			item.angle = item.angle + dt * 2	
			item.visible = true
			item:getChild("egg").visible = true
			item:getChild("egg").angle = -item.angle
			item.rate = rate
		end
	})
	
	processManager:insertAction({name = "golden egg stay middle", finished = false, item = egg, start = duration, duration = duration, meta = {},
		action = function(item,elapsed,target,dt,meta)
			item.angle = item.angle + dt * 2	
			item.x = screenWidth * 0.5			
			item:getChild("egg").angle = -item.angle			
		end
	})
	
	processManager:insertAction({name = "golden egg go away", finished = false, item = egg, start = duration * 2, duration = duration, meta = {},
		action = function(item,elapsed,target,dt,meta)
			local moveRate = tweenEaseCubicIn(elapsed, 0,1,target)
			local rate = elapsed / target
			item.y = screenHeight * 0.5 - (moveRate * 0.7 * screenHeight)
			item.angle = item.angle + dt * 2	
			item.rate = 1.0 - rate			
			item.x = screenWidth * 0.5			
			item:getChild("egg").angle = -item.angle			
		end
	})
	
	processManager:start()
	]]--
	
	showRewardPopup("GOLDEN_EGG")
	
end




function loadLevelInternal(levelFileName)
	
	-- HATCHERY
	if g_hatcheryEnabled then
		g_hatcheryBirdsToUse = nil
	end

	if(levelFileName ~= nil) then
		print("  ------------  LOAD LEVEL INTERNAL.. fileName = "..levelFileName.."\n")		
	end
	
	
	releaseCutScenes()
	prepareMenuPage(loadingPage)
	prepareMenuPage(tutorials)

	--[[ BEGIN FPS DEBUG CODE --
	FPSFrames = 0
	FPSTime = 0
	FPSMin = nil
	FPSMax = nil
	drawFPSStatistics = false
	-- END FPS DEBUG CODE --]] 

	setAnimationState("ingamePausePageScroll", "HIDDEN")
	--pausePage.offsetX = elementAnimations["ingamePausePageScroll"].percentage / 100 * pauseBGw - pauseBGw
	--pausePage.backgroundOverlay.shade = elementAnimations["ingamePausePageScroll"].percentage / 100 * 0.65
	_G.res.stopAllAudio()
	
	quadClick = false
	quadClickCounter = 0	
	eagleBaitLaunched = false
	eagleTimer = nil
	cameraShake = nil
	
	editor = {drawOneLayer = false, currentLayer = 0}
	
	birdToSlingshotAnimationTimer = 0
	birdToSlingshotAnimationAngle = 135 / 180 * _G.math.pi
	birdToSlingshotSurplusAngle =  birdToSlingshotAnimationAngle - _G.math.pi * 0.5
	birdToSlingshotAnimationHeight = 0
	birdToSlingshotAnimationStartX = 0
	birdToSlingshotAnimationStartY = 0
	birdToSlingshotBirdName = nil	
	
	currentBirdIndex = 1
	currentBirdName = nil
	flyingBird = nil
	birdSpecialtyAvailable = false
	birdFired = false
	birdReady = false
	fillInNextBird = false
	birdSelected = false
	showTapIcon = true
	birdsShot = 0

	tapStarted = false
	tapCount = 0
	tapTimer = 0
	tapPosition = { x = 0, y = 0 }
	doubleClickTimer = 0
	levelCompleteTimer = 0
	levelCompleted = false
	levelFailedTimer = 0
	birdBuffTimer = 0
	castleCameraTimer = 0
	dragCursorIndex = 1
	dragCursorTable = { {dx = 0, dy = 0, dt = 1} }
	
	rubberBandAngle = 0
	rubberBandLength = 0
	oldRubberBandLength = 0

	cameraResetTimer = 0
	showTapTimer = 0
	nextBirdTimer = 0.5
	zoomLevel = 0
	oldZoomLevel = 0
	worldScale = 1
	oldScoreLen = 0
	
	sweepSpeed = 0
	particleAmount = 0
	
	levelLeftEdge = 100000
	levelRightEdge = -100000
	
	g_challengeHudTimer = 0
	
	--local birdsCounter = 0
	birdsCounter = 0
	objectCounts = {}

	floatingScores = {}
	score = 0
	scoreTable = {}
	scoreTable.blocks = { score = 0, blockDestroyedScore = blockDestroyedScoreIncrement }
	scoreTable.birds = { score = 0 }
	
	oldScore = 0
	lastScoreTime = 0
	endTimeout = false
	
	selectedObjects = { }
	cameraTargetObject = nil
	allowResetToBirdCamera = false
	
	particles = {}
	birdTutorialPopups = {}
	showTutorialGoldenEgg = false
	deadBlocks = {}
	
	
	if objects.world ~= nil then
		-- this removed mighty eagle from level if level was restarted and eagle was used before.	
		if objects.world["MightyEagle_a"] ~= nil then
			removeObject("MightyEagle_a")
			objects.world["MightyEagle_a"] = nil
		end
		for k, v in _G.pairs(objects.world) do
			objects.world[k] = nil
		end
	end
	
	birds = {}
	levelGoals = {}
	
	flyingGrenades = {}
	birdTrajectory = { {}, {}, {} }
	otherBirds = {}
	
	episode4BGCranes = { startX = 64 }
	
	eagleInfoTimer = nil
	--oldEagleButtonStatusDisabled = false
	--inGameEagleButtonVisible = (isIapEnabled() or isEagleEnabled()) and g_episodes[currentEpisode].mighty_eagle_disabled ~= true 
	
	--[[
	oldEagleButtonStatusDisabled = false
	
	if not startedFromEditor then
		inGameEagleButtonVisible = (isIapEnabled() or isEagleEnabled()) and g_episodes[currentEpisode].mighty_eagle_disabled ~= true
	else
		inGameEagleButtonVisible = false
	end]]
	
	--loginfo("episode name = "..currentEpisode.."_G.tostring(currentEpisode.mighty_eagle_disabled))
	--print(nil)
	--inGameEagleButtonScalingTimer = 0
	--inGameEagleButtonScale = nil

	currentThemeIndex = 1

	objects.world = {}
	objects.joints = {}
	objects.counts = {}
	objects.themeSprites = {}
	objects.physicsToWorld = physicsToWorld
	objects.theme = "theme1"
	objects.castleCameraData = nil
	objects.birdCameraData = nil
	
	-- Reset scale and screen position
	setWorldScale(worldScale)
	screen.x = 0
	screen.y = 0
	levelStartPosition.x = 0
	levelStartPosition.y = 0
	rubberBandPos.x = 0
	rubberBandPos.y = 0
	rubberBandSpeed = 0
	
	objects.levelParticles = {}
	
	loadLevel(levelFileName)
	print(" - - - Level loaded \n")
	filterLoadedLevel()
	
	print(" - - - Filter loaded level done \n")
	-- level was not found
	if loadedObjects == nil then
		-- find the current theme based on the theme index in blocktable
		for k0, v0 in _G.pairs(blockTable.themes) do
			if v0.index ~= nil and v0.index == currentThemeIndex then
				currentTheme = k0
			end
		end		
		
		createBox("ground", "", (levelLeftEdge + levelRightEdge)*0.5, 5, 2000, 10, 0, 0.8, 0, true, false, 0)
		objects.world["ground"].material = "staticGround"
		objects.world["ground"].definition = "Ground"
		objects.world["ground"].strength = 30
		objects.world["ground"].defence = 1000000		
		print("Setting current theme to "..currentTheme.."\n")
		--loadThemeGraphics(currentTheme)
		setTheme(currentTheme)
		themeSpriteObjects = {}
		return		
	end

	-- init counts table
	local countsSaved = false
	if loadedObjects.counts ~= nil then
		countsSaved = true
		for k, v in _G.pairs(loadedObjects.counts) do
			objects.counts[k] = v
		end
	end

	-- temp code for testing the right scale
	local pscale = 100
	if loadedObjects.physicsToWorld ~= nil then
		pscale = loadedObjects.physicsToWorld
	end
	scaleFactor = pscale/physicsToWorld
	
	
	-- handle theme
	if loadedObjects.theme ~= nil then
		objects.theme = loadedObjects.theme
		currentThemeIndex = blockTable.themes[objects.theme].index
		-- find the current theme based on the theme index in blocktable
		settingsWrapper:setCurrentZoomLevelMainMenu(0)
		for k0, v0 in _G.pairs(blockTable.themes) do
			if v0.index ~= nil and v0.index == currentThemeIndex then
				currentTheme = k0
				settingsWrapper:setCurrentMainMenuTheme(k0)
				local layersAmount = 0
				for l = 1, #v0.bgLayers do
					layersAmount = layersAmount + 1
					settingsWrapper:setCurrentZoomLevelMainMenu(v0.bgLayers[l][4] + settingsWrapper:getCurrentZoomLevelMainMenu())
				end
				settingsWrapper:setCurrentZoomLevelMainMenu(settingsWrapper:getCurrentZoomLevelMainMenu() /  layersAmount)
				currentMusic = v0.music
				currentMainMenuSong = "title_theme"
			end
		end
	end
	
	if(showEditor == false) then
		loadThemeGraphics(currentTheme)
		setTheme(currentTheme)
	else
		loadAllThemeGraphics()
		setTheme(currentTheme)	
	end
	
	themeSpriteObjects = {}

	print("Theme set\n")
	--print("Creating objects\n")
	if loadedObjects.world ~= nil then
		for k, v in _G.pairs(loadedObjects.world) do
			local obj = v
			-- quick fix to disable ground block creation from the level data
			if obj.name ~= "ground" then
				local name = createObject(blockTable, obj.definition, obj.name, obj.x*scaleFactor, obj.y*scaleFactor)

				-- clamp angle to 0 - 2*PI range
				obj.angle = _G.math.fmod(obj.angle, _G.math.pi*2)
				if obj.angle < 0 then
					obj.angle = obj.angle + _G.math.pi*2
				end
				
				setRotation(name, obj.angle)
				setMaterial(name, objects.world[name].material)
				
				if objects.world[name].texture ~= nil then
					local texture = blockTable.themes[currentTheme].texture				
					setTexture(name, texture)
				end


				local width = objects.world[name].width
				if width == nil then width = objects.world[name].radius end
				if objects.world[name].x - width < levelLeftEdge then
					levelLeftEdge = objects.world[name].x - width
				end
				if objects.world[name].x + width > levelRightEdge then
					levelRightEdge = objects.world[name].x + width
				end

				
				if objects.world[name].controllable then
					birdsCounter = birdsCounter + 1
					if obj.startNumber ~= nil then
						objects.world[name].startNumber = obj.startNumber
					else
						-- Ignores controllable creation on challenge mode	
						objects.world[name].startNumber = birdsCounter
					end					

					if isChallengeMode() then

						if obj.startNumber == 1 then
							challengeBirdStartX	= objects.world[name].x
							challengeBirdStartY	= objects.world[name].y
						end
						
						objects.world[name] = nil
						removeObject(obj.name)								
					end					
				end				
			end
		end
	end
	
	if isChallengeMode() then
		birdsCounter = 1

		if g_currentChallenge.type == "BIRD_FLOCK" then
			local x = 1
			local bird = g_currentChallengeProgress.shotsQueue[x]
			local name = createObject(blockTable, bird, "challengeBird"..birdsCounter..bird, challengeBirdStartX * scaleFactor, challengeBirdStartY * scaleFactor)
			setRotation(name, 0)
			setMaterial(name, objects.world[name].material)
			objects.world[name].controllable = true
			
			if objects.world[name].texture ~= nil then
				local texture = blockTable.themes[currentTheme].texture				
				setTexture(name, texture)
			end
			
			birdsCounter = birdsCounter + 1
			objects.world[name].startNumber = 1
		end
		
		for _, v in _G.ipairs(g_currentChallengeProgress.shotsQueue) do
			if blockTable.blocks[v].tutorialInfo ~= nil then
				local birdSprite = blockTable.blocks[v].sprite
				if not settingsWrapper:getTutorialsForItem(birdSprite) then
				
					
					local hasExtraTutorial = false				
					-- Extra tutorials
					if(birdSprite == "BIRD_GREEN" or birdSprite == "BIRD_BLUE" or birdSprite == "BIRD_YELLOW" or birdSprite == "BIRD_GREY" or birdSprite == "BIRD_BOOMERANG") then
						hasExtraTutorial = true
					end
					
					settingsWrapper:createTutorialForItem(birdSprite, blockTable.blocks[v].tutorialInfo, hasExtraTutorial)
					_G.table.insert(birdTutorialPopups, blockTable.blocks[v].tutorialInfo)

					eventManager:notify({id = events.EID_TUTORIAL_WATCHED, data = {sprite = birdSprite}})
				end
			end
		end
	end
	
	createBox("ground", "", (levelLeftEdge + levelRightEdge)*0.5, 5, 2000, 10, 0, 0.8, 0, true, false, 0)
	objects.world["ground"].material = "staticGround"
	objects.world["ground"].definition = "Ground"
	objects.world["ground"].strength = 30
	objects.world["ground"].defence = 1000000
	
	countsSaved = true
	
	--creating theme sprites
	if loadedObjects.themeSprites then
		for k, v in _G.pairs(loadedObjects.themeSprites) do
	
			addThemeSprite(k,v)		

			if not objects.themeSprites then
				objects.themeSprites = {}
			end
						
			objects.themeSprites[v.name] = { definition = v.definition, 
											 name = v.name, x = v.x, y = v.y, 
											 layer = v.layer, 
											angle = v.angle, scale = v.scale }			
		end
	end	
	
	print("Creating joints\n")
	if loadedObjects.joints ~= nil then
		for k, v in _G.pairs(loadedObjects.joints) do
			--createJoint(v.name, v.end1, v.end2, v.type, v.coordType, v.x1, v.y1, v.x2, v.y2)
			createJoint(v)
			
		end
	end

	-- level camera data
	objects.castleCameraData = loadedObjects.castleCameraData
	objects.birdCameraData = loadedObjects.birdCameraData
	
	-- level end condition
	objects.doNotWaitForMovingObjects = loadedObjects.doNotWaitForMovingObjects
	
	if loadedObjects.levelParticles ~= nil and _G.type(loadedObjects.levelParticles) == "table" and loadedObjects.levelParticles.settingsFrame then
		g_levelParticlesEnabled = true
		objects.levelParticles = loadedObjects.levelParticles
		print("enabled level particles\n")
	else
		g_levelParticlesEnabled = false
		print("no level particles\n")
	end
	
	for k, v in _G.pairs(loadedObjects) do
		loadedObjects[k] = nil
	end
	loadedObjects.cameraData = nil
	selectedBird = nil
	
	local maxScore = 0
	birdCount = 0
		
	for k, v in _G.pairs(objects.world) do
		if v.controllable == true then
			
			if(modifiers ~= nil) then
			--	v.definition = "SmallBlueBird"			
			--	v.sprite = "BIRD_BLUE"
			--	setSprite(v.name,v.sprite)
			end
			
			birdCount = birdCount + 1
			-- add bird to bird table for faster access
			v.animTimer = _G.math.random(10, 30) / 10
			v.jumpTimer = _G.math.random(10, 30) / 10
			setRotation(v.name, 0)
			setObjectParameter(v.name, 2, 0)
			birds[k] = v


			if blockTable.blocks[v.definition].tutorialInfo ~= nil then
				if not settingsWrapper:getTutorialsForItem(v.sprite) then
				
					local birdSprite = blockTable.blocks[v.definition].sprite
					local hasExtraTutorial = false				
					-- Extra tutorials
					if(birdSprite == "BIRD_GREEN" or birdSprite == "BIRD_BLUE" or birdSprite == "BIRD_YELLOW" or birdSprite == "BIRD_GREY" or birdSprite == "BIRD_BOOMERANG") then
						hasExtraTutorial = true
					end
					
					settingsWrapper:createTutorialForItem(v.sprite, blockTable.blocks[v.definition].tutorialInfo, hasExtraTutorial)
					_G.table.insert(birdTutorialPopups, blockTable.blocks[v.definition].tutorialInfo)

					eventManager:notify({id = events.EID_TUTORIAL_WATCHED, data = {sprite = birdSprite}})
					
				end
			end
		end
		if v.levelGoal then
			v.blinkTimer = _G.math.random(5, 30) / 10
			v.oinkTimer = _G.math.random(5, 30) / 10			
			levelGoals[k] = v
			setObjectParameter(k, 1, 1) -- set this object as level goal
		end
		local sprites = getDamageSprite(v, blockTable.blocks)
		v.damageSprite = sprites.sprite
		v.blinkSprite = sprites.blink		
		v.smileSprite = sprites.smile		
		v.frozen = false
		
		if v.controllable  then
			maxScore = maxScore + birdsLeftScoreIncrement
		elseif v.levelGoal then
			maxScore = maxScore + v.strength * 10 + pigletteDestroyedScoreIncrement
		elseif v.defence <= 1000 then
			
			maxScore = maxScore + v.strength * 10
			
			destroyedBonus = blockDestroyedScoreIncrement
			if blockTable.blocks[v.definition].destroyedScoreInc ~= nil then
				destroyedBonus = blockTable.blocks[v.definition].destroyedScoreInc
			end
			maxScore = maxScore + destroyedBonus
		end
	end
	
	-- one bird must be shot...
	maxScore = maxScore - birdsLeftScoreIncrement
	print("Max score for " .. currentWorldNumber .. "-" .. currentLevelNumberInTheme .. ": " .. maxScore .. "\n")
	
	-- init level positions
	levelStartTimer = 0
	local startObjectName = getNextBird(1)
	if startObjectName ~= nil then
		setObjectParameter(startObjectName, 2, 1)
	end

	if startObjectName ~= nil and objects.world[startObjectName] ~= nil then
		local px, py = _G.res.getSpritePivot("", "SLING_SHOT_01_BACK")
		local sw, sh = _G.res.getSpriteBounds("", "SLING_SHOT_01_BACK")
		local r = objects.world[startObjectName].radius
		if r == nil then
			r = 0
		end
		levelStartPosition.x = objects.world[startObjectName].x
		levelStartPosition.y = objects.world[startObjectName].y - (sh - py) * physicsScale + r + 0.2
		rubberBandPos.x = levelStartPosition.x - 0.1
		rubberBandPos.y = levelStartPosition.y - 0.1
		baitSardine.x, baitSardine.y = objects.world[startObjectName].x, objects.world[startObjectName].y
	end

	local c = blockTable.themes[objects.theme].color
	setBGColor(c.r, c.g, c.b)
	
	initCameras()
	
	if objects.levelParticles ~= nil then
		local birdCamera = objects.birdCameraData
		local castleCamera = objects.castleCameraData
	
		if objects.levelParticles.startAtGroundLevel then
			objects.levelParticles.y = 0 
		else
			objects.levelParticles.y = _G.math.min(castleCamera[deviceModel].py, castleCamera[deviceModel].py) - screenHeight * 0.5 / (screenHeight*minWorldScale/screenWidth)
		end
		objects.levelParticles.x = (((castleCamera[deviceModel].px + screenWidth / castleCamera[deviceModel].sx) + (birdCamera[deviceModel].px - screenWidth * 0.5 / birdCamera[deviceModel].sx) + _G.math.abs(objects.levelParticles.y)) / 2) 
		objects.levelParticles.width = ((castleCamera[deviceModel].px +  castleCamera[deviceModel].screenWidth / castleCamera[deviceModel].sx) - (birdCamera[deviceModel].px - birdCamera[deviceModel].screenWidth  / birdCamera[deviceModel].sx)) + _G.math.abs(objects.levelParticles.y)
		objects.levelParticles.firstFrame = true
		levelParticlesTimer = 0
	end
	
	-- mighty eagle is available if it's 'locked' in current level
	eagleUsedInCurrentLevel = false
	for k, v in _G.pairs(settingsWrapper:getEagleUsedIn()) do
		if v.level == levelName then
			eagleUsedInCurrentLevel = true
			break
		end
	end
	
	-- event?
	if g_hatcheryEnabled then	
		setupIngameBirdsFromHatchery()
	end
	
	editor = {drawOneLayer = false, currentLayer = 0}
	loadedObjects = nil
	loading = false
	loadingPageDrawn = false
	print("level load complete\n")
	
	checkLogLevelNotCompleted()
	_G.collectgarbage("collect")

	eventManager:notify({id = events.EID_LEVEL_LOADING_DONE})
	if not startedFromEditor then
		eventManager:notify({id = events.EID_GOTO_GAME })
	end
	
	showHatcheryIngameMenu(true)
	if g_hatcheryEnabled then
		Hatchery.resetIngameBirdSelector()	
	end
end



function getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

-- Creates object from definition (blocks.lua)
function createObject(definitions, objectDefinition, objName, xpos, ypos)
	local name = ""
	--print("objName = ".._G.tostring(objName).."\n")
	local blockDef = definitions.blocks[objectDefinition]
	
	if blockDef == nil then
		print("<ERROR> level contains a nonexistant block \"" .. _G.tostring(objectDefinition) .. "\"")
		return ""
	end
	
	local materialDef = definitions.materials[blockDef.material]
	
	-- get basic data from block definition
	local density = blockDef.density
	local friction = blockDef.friction
	local restitution = blockDef.restitution
	local controllable = blockDef.controllable
	local strength = blockDef.strength
	local defence = blockDef.defence
	local levelGoal = blockDef.levelGoal
	local collision = blockDef.collision
	local damageFactors = blockDef.damageFactors
	local useLegacyCollisionPath = blockDef.useLegacyCollisionPath
	local z_order = blockDef.z_order

	local pivotx, pivoty
    local forceX, forceY
	-- get rest of the information from material if it has not been overridden in the block definition

	if materialDef ~= nil then
        if forceX == nil then
            forceX = materialDef.forceX            
        end

        if forceY == nil then
            forceY = materialDef.forceY   
        end
    	
	
		if density == nil then
			density = materialDef.density
			definitions.blocks[objectDefinition].density = density
		end
		if friction == nil then
			friction = materialDef.friction
			definitions.blocks[objectDefinition].friction = friction
		end
		if restitution == nil then
			restitution = materialDef.restitution
			definitions.blocks[objectDefinition].restitution = restitution
		end
		if controllable == nil then
			controllable = materialDef.controllable
			definitions.blocks[objectDefinition].controllable = controllable
		end
		if strength == nil then
			strength = materialDef.strength
			definitions.blocks[objectDefinition].strength = strength
		end
		if defence == nil then
			defence = materialDef.defence
			definitions.blocks[objectDefinition].defence = defence
		end

		if forceX == nil then
			forceX = materialDef.forceX
			definitions.blocks[objectDefinition].forceX = forceX
		end
		
		if z_order == nil then
			z_order = materialDef.z_order
			definitions.blocks[objectDefinition].z_order = z_order
		end		
	end

	-- failsafe if z_order not defined
	if z_order == nil then
		z_order = 0
		definitions.blocks[objectDefinition].z_order = z_order
	end
	
	--set object names using cumulative counter
	if countsSaved == false or objName == nil then
		if objects.counts[objectDefinition] == nil then
			objects.counts[objectDefinition] = 0
		end
		objects.counts[objectDefinition] = objects.counts[objectDefinition] + 1
		name = objectDefinition .. "_" .. objects.counts[objectDefinition]
	else
		name = objName
	end

	local sprite = blockDef.sprite
	local w, h = 1, 1
	local sizeFactor = 0.92
	
	-- if sprite has not been set use the first damage sprite
	if sprite == nil then
		if blockDef.damageSprites ~= nil then
			sprite = blockDef.damageSprites.damage1.sprite
		end
	end
	
	-- set physics related settings
	if blockDef.type == "box" then
		-- use sprite if available if not use defined width and height
		if blockDef.width == nil or blockDef.height == nil then
			w, h = _G.res.getSpriteBounds("", sprite)
			-- immovable walls have always the sprites size to prevent gaps
			if blockDef.density == 0 then
				sizeFactor = 1
			end
			w = w * physicsScale * sizeFactor
			h = h * physicsScale * sizeFactor
			pivotx, pivoty = _G.res.getSpritePivot("", sprite)
		else
			w = blockDef.width
			h = blockDef.height
			pivotx, pivoty = _G.res.getSpritePivot("", sprite)
		end

		if collision == nil then
			collision = true
		end
		
		createBox(name, sprite, xpos, ypos, w, h, density, friction, restitution, collision, controllable, z_order)
		
		-- set damage factors for birds
		if controllable then
			objects.world[name].damageFactors = damageFactors
			objects.world[name].useLegacyCollisionPath = useLegacyCollisionPath
		end
	end

	-- set physics related settings
	if blockDef.type == "polygon" then
			--use sprite if available if not use defined width and height
		if sprite ~= "" and sprite ~= nil then
			w, h = _G.res.getSpriteBounds("", sprite)
			--immovable walls have always the sprites size to prevent gaps
			if blockDef.density == 0 then
				sizeFactor = 1
			end
			w = w * physicsScale * sizeFactor
			h = h * physicsScale * sizeFactor
			pivotx, pivoty = _G.res.getSpritePivot("", sprite)
		else
			w = blockDef.width
			h = blockDef.height
			pivotx, pivoty = _G.res.getSpritePivot("", sprite)
		end

		if collision == nil then
			collision = true
		end

		clearVertices()
		if blockDef.vertices ~= nil then
			for i = 1, #blockDef.vertices do
				local vert = blockDef.vertices[i]
				addVertex(vert.x * w - w * 0.5, vert.y * h - h * 0.5)
			end
		end
		
		createPolygon(name, sprite, xpos, ypos, w, h, density, friction, restitution, collision, controllable, z_order)
	
		-- set damage factors for birds
		if controllable then
			objects.world[name].damageFactors = damageFactors
			objects.world[name].useLegacyCollisionPath = useLegacyCollisionPath
		end
	end	
	
	if blockDef.type == "circle" then
		-- use sprite if available if not use defined width and height
		if blockDef.radius ~= nil then
			w = blockDef.radius
		else
			if sprite ~= "" and sprite ~= nil then
				w, h = _G.res.getSpriteBounds("", sprite)
				w = w * 0.5 * physicsScale * sizeFactor
			end
		end
		pivotx, pivoty = _G.res.getSpritePivot("", sprite)
		createCircle(name, sprite, xpos, ypos, w, density, friction, restitution, controllable, z_order)
		
		-- set damage factors for birds
		if controllable then
			objects.world[name].damageFactors = damageFactors
			objects.world[name].useLegacyCollisionPath = useLegacyCollisionPath
			
			-- local index = _G.math.random(1, getTotalCompoBirds())
			-- local compoBirdTable = setupCompoBirdTableFromIndex(index)
			-- local compoBirdTable = setupCompoBirdTable("BIRD_BODY_RED", {"BIRD_EYES_RED_NORMAL", "BIRD_BEAK_RED_NORMAL", "H_BIRD_ACCESSORY_TOP_HAT_2"})						
			-- local compoBirdTable = setupCompoBirdTable(compoBirdsPrefabs["RED_BIRD"].body, compoBirdsPrefabs["RED_BIRD"].items)															
			-- setupCompoObject(name, compoBirdTable, 0.4)
			
			-- local index = _G.math.random(1, #hatcheryBirdsSaves)
			
		end
	end

	-- set general settings
	objects.world[name].definition = objectDefinition
	objects.world[name].damageSprite = sprite	
	objects.world[name].controllable = controllable
	objects.world[name].strength = strength
	objects.world[name].defence = defence
	objects.world[name].material = blockDef.material
	objects.world[name].texture = blockDef.texture
	objects.world[name].levelGoal = levelGoal
	objects.world[name].spritePivotX = pivotx
	objects.world[name].spritePivotY = pivoty
	objects.world[name].forceX = forceX
	objects.world[name].forceY = forceY
	
	return name
end

-------------------------------------------------------------------------------
-- Editor stuff starts

function checkDirectories()
	if not checkDirectory(levelFolder) then
		createDirectory(levelFolder)
	end
	if not checkDirectory(levelFolder .. "temp/") then
		createDirectory(levelFolder .. "temp/")
	end		
end

-- updates current cursor object to match theme
function updateCursorObjectAccordingToTheme()
	for k, v in _G.pairs(blockTable.blocks) do
		-- check the group
		if v.group == currentGroup and v.groupIndex == currentGroupIndex then
			--print("Object candidate " .. k .. " group:" .. v.group .. " groupIndex:" .. v.groupIndex .. "\n")
			--if theme is defined check if it matches the current theme
			if v.theme == nil or v.theme == currentTheme then
				--print("Selected object to add " .. k .. "\n")
				objectToAdd = k
				selectedObjects = { }
			end
		end
	end
end

function getObjectListBounds(objects)
	local w, h, px, py
	local minx = 1000000 
	local maxx = -1000000
	local miny = 1000000 
	local maxy = -1000000

	for k, v in _G.pairs(objects) do
		local width = v.width
		local height = v.height
		if width == nil then
			width = v.radius
			height = v.radius
		else
			width = width * 0.5
			height = height * 0.5
		end
		
		if v.x - width < minx then
			minx = v.x - width
		end
		if v.x + width > maxx then
			maxx = v.x + width
		end

		if v.y - height < miny then
			miny = v.y - height
		end
		if v.y + height > maxy then
			maxy = v.y + height
		end
	end
	
	w = maxx - minx
	h = maxy - miny
	px = (maxx + minx) * 0.5
	py = (maxy + miny) * 0.5
	
	return px, py, w, h
end

function updateEditor(dt, time)
	
	if not editorJointPage then
		editorJointPage = EditorJointPage:new()
		editorJointPage:onEntry()
	end

	if oldZoomLevel ~= zoomLevel then
		worldScale = worldScale + zoomLevel - oldZoomLevel
		setWorldScale(worldScale)
		oldZoomLevel = zoomLevel
	end	

	updateScale()
	cursorPhysics.x, cursorPhysics.y = screenToPhysicsTransform(cursor.x, cursor.y)
	cursorWorld.x, cursorWorld.y = screenToWorldTransform(cursor.x, cursor.y)
	
	

	-- XXX: ADD TO OTHERS
	if(selectedObjects ~= nil and #selectedObjects == 1) then
		initCollisionDummy(selectedObjects[1])	
	end
	
	if(keyReleased["LBUTTON"] or keyReleased["RBUTTON"]) then
		
	end
	
	if(keyHold["RETURN"] and keyPressed["DOWN"]) then
		alignObjects("DOWN")
	end
	
	if(keyHold["RETURN"] and keyPressed["UP"]) then
		alignObjects("UP")
	end

	if(keyHold["RETURN"] and keyPressed["RIGHT"]) then
		alignObjects("RIGHT")
	end
	
	if(keyHold["RETURN"] and keyPressed["LEFT"]) then
		alignObjects("LEFT")
	end

	-- XXX: ADD TO OTHERS
	if (keyHold["SHIFT"] or keyHold["CONTROL"]) and (keyPressed["W"] or keyPressed["E"]) and showSleepingObjects == true then
		if  #selectedObjects == 1 then
			local name = selectedObjects[1].name
			local selected = objects.world[name]
			local blockDef = blockTable.blocks[selected.definition]
			local dir = 1

			if(keyHold["CONTROL"]) then dir = -1 end

			if(blockDef.radius) then
				adjustedBlockDef.objectNames[name].radius = adjustedBlockDef.objectNames[name].radius + 0.1 * dir
				
				if(adjustedBlockDef.objectNames[name].radius < 0) then
					adjustedBlockDef.objectNames[name].radius = 0
				end
				
			elseif(blockDef.width and blockDef.height) then
				if(keyPressed["W"]) then
					adjustedBlockDef.objectNames[name].width = adjustedBlockDef.objectNames[name].width + 0.1 * dir
					if(adjustedBlockDef.objectNames[name].width < 0) then
						adjustedBlockDef.objectNames[name].width = 0
					end			

				else
					adjustedBlockDef.objectNames[name].height = adjustedBlockDef.objectNames[name].height + 0.1 * dir
					if(adjustedBlockDef.objectNames[name].height < 0) then
						adjustedBlockDef.objectNames[name].height = 0
					end			
				end
			elseif(blockDef.vertices ~= nil) then
				for k,v in _G.pairs(blockDef.vertices) do
					local vert = adjustedBlockDef.objectNames[name].vertices[k]
					if(keyPressed["W"]) then
						if(vert.x > 0.5) then
							vert.x = vert.x + 0.05 * dir
						elseif(vert.x < 0.5) then
							vert.x = vert.x - 0.05 * dir
						end
					else
						if(vert.y > 0.5) then
							vert.y = vert.y + 0.05 * dir										
						elseif(vert.y < 0.5) then
							vert.y = vert.y - 0.05 * dir
						end
					end
				end
			end
		end		
	end
	
	
	--the m_cursorWorldDownX will keep the values of the cursor in world coordinates when 
	--the RMB was pressed on the screen, will be used for scaling sprites on the background
	if(keyHold["RBUTTON"]) then
		if editor.m_cursorWorldDownX == nil and editor.m_cursorWorldDownY == nil then
			editor.m_cursorWorldDownX = cursorWorld.x
			editor.m_cursorWorldDownY = cursorWorld.y
		end
	else
		editor.m_cursorWorldDownX = nil
		editor.m_cursorWorldDownY = nil
	end

	if keyReleased["ESCAPE"] or touchcount == 3 then

		--setGameMode(updateMenu)
		setPhysicsEnabled(false)
		physicsEnabled = false
		--setActiveMenuPage(levelSelectionEdit[currentThemeNumber])
		currentGameMode = function() end
		if g_editorPage == "folder" then
			menuManager:changeRoot(EditorFolderPage:new(currentPageNumber))
		elseif g_editorPage == "pack" then
			menuManager:changeRoot(EditorEpPage:new(currentThemeNumber, currentPageNumber))
		end
		editorJointPage:onExit()
		editorJointPage = nil
		return
	end

	if keyHold["CONTROL"] and keyPressed["S"] then
		print("derp\n")
		print("levelFolder: " .. _G.tostring(levelFolder) .. "\n")
		print("levelName: " .. _G.tostring(levelName) .. "\n")
		checkDirectories()
		saveLevel(levelFolder .. levelName)
		saveLevel(levelFolder .. "temp/" .. levelName .. ".temp")
		levelSaved = true
	end

	if not keyHold["CONTROL"] and keyHold["SHIFT"] and keyPressed["C"] then
		if objects.castleCameraData == nil then
			objects.castleCameraData = {}
		end
		
		objects.castleCameraData.version = "0.02"
		objects.castleCameraData[deviceModel] = { px = screen.x,
												  py = screen.y,
												  sx = worldScale,
												  sy = worldScale,
												  screenWidth = screenWidth,
												  screenHeight = screenHeight }
		levelSaved = false
	end

	if not keyHold["CONTROL"] and keyHold["SHIFT"] and keyPressed["B"] then
		if objects.birdCameraData == nil then
			objects.birdCameraData = {}
		end
		
		objects.birdCameraData.version = "0.02"
		objects.birdCameraData[deviceModel] = { px = screen.x,
												py = screen.y,
												sx = worldScale,
												sy = worldScale,
												screenWidth = screenWidth,
												screenHeight = screenHeight }
		levelSaved = false
	end

	if (keyHold["SHIFT"] and keyPressed["P"]) or touchcount == 2 then
		setEditing(false)
		setPhysicsEnabled(false)

		local name = "temp/" .. levelName .. ".temp.playtest"
		
		if(touchcount == 2) then
			name = levelName
		end
		
		if(touchcount ~= 2) then
			checkDirectories()
			saveLevel(levelFolder .. name)
		end
		
		loadLevelInternal(levelFolder .. name)		
		setGameMode(updateGame)
		levelSelectionPageNumber = currentThemeNumber
		currentThemeNumber = currentThemeIndex
		menuManager:changeRoot(ui.GameHud:new())
	end

	if keyPressed["TAB"] then
		physicsEnabled = not physicsEnabled
		if physicsEnabled then
			checkDirectories()
			saveLevel(levelFolder .. "temp/" .. levelName .. ".temp")
		else
			loadLevelInternal(levelFolder .. "temp/" .. levelName .. ".temp")
		end
		setPhysicsEnabled(physicsEnabled)
	end

	if keyPressed["MBUTTON"] then
		if keyPressed["SHIFT"] then
			setWorldScale(1)
			worldScale = 1
		else
			setWorldScale(1)
			worldScale = 1
			screen.x = 0
			screen.y = 0
		end
	end

	-- set active theme
	if keyHold["SHIFT"] and keyPressed[blockTable.themes.settings.keyCode] and not editor.edit_particles then
		currentThemeIndex = currentThemeIndex + 1
		if currentThemeIndex > blockTable.themes.settings.themeAmount then
			currentThemeIndex = 1
		end

		for k0, v0 in _G.pairs(blockTable.themes) do
			if v0.index ~= nil and v0.index == currentThemeIndex then
				currentTheme = k0
				setTheme(currentTheme)
				-- replace all blocks that are theme dependent
				for k1, v1 in _G.pairs(objects.world) do
					v1def = blockTable.blocks[v1.definition]
					if v1def.theme ~= nil and v1def.theme ~= currentTheme then
						-- go through all block definitions to find the correct block to replace this one
						for k2, v2 in _G.pairs(blockTable.blocks) do
							-- if this block definition's group is the same as the one on the current block and the group indexes match then check the theme
							if v2.group == v1def.group and v2.groupIndex == v1def.groupIndex then
								-- does the theme match to the current theme requirements
								if v2.theme == nil or v2.theme == currentTheme then
									-- we found a replacement, update values accordingly
									v1.definition = k2
									v1.sprite = v2.sprite
									v1.damageSprite = v1.sprite
									setSprite(k1, v1.sprite)
									levelSaved = false
								end
							end
						end
					end
				end

				-- update the cursor object
				if objectToAdd ~= nil then
					updateCursorObjectAccordingToTheme()
				end
				-- replace level defines
				objects.theme = currentTheme

			end
		end
	end

	birdSelected = false
	if selectedObjects[1] ~= nil then
		if selectedObjects[1].controllable then
			birdSelected = true
			for i = 1, #numberKeys do
				if keyPressed[numberKeys[i]] then
					selectedObjects[1].startNumber = i
				end
			end
		end
	end


	-- create blocks from the blocks.lua definitions
	if keyHold["CONTROL"] == false and keyHold["SHIFT"] == false and birdSelected == false and not editor.edit_particles then
		for k, v in _G.pairs(blockTable.groups) do
			local groupDataUpdate = false
			if keyPressed[v.keyUp] then
				-- update group information
				if currentGroup == k then
					currentGroupIndex = currentGroupIndex + 1
				else
					currentGroup = k
				end
				groupDataUpdate = true
			end
			if keyPressed[v.keyDown] then
				-- update group information
				if currentGroup == k then
					currentGroupIndex = currentGroupIndex - 1
				else
					currentGroup = k
				end
				groupDataUpdate = true
			end
			-- find the next object to add based on group information
			if groupDataUpdate then
				if currentGroupIndex > blockTable.groups[currentGroup].lastIndex then
					currentGroupIndex = blockTable.groups[currentGroup].firstIndex
				end
				if currentGroupIndex < blockTable.groups[currentGroup].firstIndex then
					currentGroupIndex = blockTable.groups[currentGroup].lastIndex
				end

				--print("Searching for group " .. currentGroup .. " " .. currentGroupIndex .. "\n")
				updateCursorObjectAccordingToTheme()
			end
		end
	end

	if keyPressed["RBUTTON"] then
		if copiedObjects ~= nil then
			copiedObjects = nil
		end
		
		if objectToAdd ~= nil then
			objectToAdd = nil
		else
			if not keyHold["SHIFT"] and not keyHold["ALT"] then
				selectedObjects = { }
			end
			selectedObjectPos.x = 0
			selectedObjectPos.y = 0

			draggingStartPosWorld.x = cursorWorld.x
			draggingStartPosWorld.y = cursorWorld.y
			
			if editor.drawOneLayer then
				--find object that was clicked
				for k, v in _G.pairs(themeSpriteObjects) do
					object = v
					if object.type == "polygon" then						
						if checkPolygonObjectBounds(object.x, object.y, object.width * object.scale.x, object.height * object.scale.y, object.angle, object.vertices, cursorPhysics.x, cursorPhysics.y) then
							addObjectToSelection(object, true)
						end
					end
					if object.type == "box" then
						if checkObjectBounds( object.x, object.y, object.width * object.scale.x, object.height * object.scale.y, object.angle, cursorPhysics.x, cursorPhysics.y) then
							addObjectToSelection(object, true)
						end
					end
					if object.type == "circle" then
						local t_scale = _G.math.max(object.scale.x, object.scale.y)
						if distance(object.x, object.y, cursorPhysics.x, cursorPhysics.y) < (object.radius * t_scale) then
							addObjectToSelection(object, true)
						end
					end
				end
			else
				--find object that was clicked
				for k, v in _G.pairs(objects.world) do
					object = v
					if object.type == "polygon" then
						x = object.x
						y = object.y
						--print(object.name .. " ")
						if checkPolygonObjectBounds(x, y, object.width, object.height, object.angle, getObjectDefinition(k).vertices, cursorPhysics.x, cursorPhysics.y) then
							addObjectToSelection(object, true)
						end
					end
					if object.type == "box" then
						x = object.x
						y = object.y
						--print(object.name .. " ")
						if checkObjectBounds(x, y, object.width, object.height, object.angle, cursorPhysics.x, cursorPhysics.y) then
							addObjectToSelection(object, true)
						end
					end
					if object.type == "circle" then
						if distance(object.x, object.y, cursorPhysics.x, cursorPhysics.y) < object.radius then
							addObjectToSelection(object, true)
						end
					end
				end
			end
		end
	end

	if keyHold["RBUTTON"] and (not keyHold["CONTROL"]) then
		selectionRectActive = true
	end
	
	--scales backgrond sprites
	if keyHold["RBUTTON"] and keyHold["CONTROL"] and editor.drawOneLayer and (#selectedObjects > 0) then
		
		for k, v in _G.pairs(selectedObjects) do
			object = v
			
			local t_scaleX = 1
			local t_scaleY = 1
			
			--if the user is pressing shif, we scale both axis equally
			if(keyHold["SHIFT"]) then
				local t_oldCursorPhysicsX, t_oldCursorPhysicsY = worldToPhysicsTransform(editor.m_cursorWorldDownX, editor.m_cursorWorldDownY)
									
				local t_originalDistance = distance(v.x, v.y, t_oldCursorPhysicsX, t_oldCursorPhysicsY)
				
				local t_newDistance = distance(v.x, v.y, cursorPhysics.x, cursorPhysics.y)
				
				local t_scale = t_newDistance / t_originalDistance
				
				t_scaleX = t_scale
				t_scaleY = t_scale
			else
				local t_oldCursorPhysicsX, t_oldCursorPhysicsY = worldToPhysicsTransform(editor.m_cursorWorldDownX, editor.m_cursorWorldDownY)
									
				local t_oldDistanceX = t_oldCursorPhysicsX - v.x
				local t_oldDistanceY = t_oldCursorPhysicsY - v.y
				
				local t_newDistanceX = cursorPhysics.x - v.x
				local t_newDistanceY = cursorPhysics.y - v.y
								
				t_scaleX = t_newDistanceX / t_oldDistanceX
				t_scaleY = t_newDistanceY / t_oldDistanceY
			end
			
			modifyThemeSprite(object.name, object.x, object.y, t_scaleX, t_scaleY, object.angle, object.layer)
			
			object.scale = {x = t_scaleX, y = t_scaleY}			
			objects.themeSprites[object.name].scale = { x =  t_scaleX, y = t_scaleY}			
			
		end
		
	end
	
	-- this is here so that the dragging position is not set on this frame if LBUTTON is released
	if keyReleased["RBUTTON"] then
		if objectToAdd ~= nil and selectedObjects == nil or #selectedObjects < 1 then
			if editor.drawOneLayer then
				selectedObjects = getThemeObjectsInsideRect(draggingStartPosWorld.x, draggingStartPosWorld.y, cursorWorld.x, cursorWorld.y, editor.currentLayer)
			else 
				selectedObjects = getObjectsInsideRect(draggingStartPosWorld.x, draggingStartPosWorld.y, cursorWorld.x, cursorWorld.y)
				
			end
		else
			if keyHold["SHIFT"] then
				local tempObjects = getObjectsInsideRect(draggingStartPosWorld.x, draggingStartPosWorld.y, cursorWorld.x, cursorWorld.y)
				for k, v in _G.pairs(tempObjects) do
					addObjectToSelection(object, false)
				end
			end
			if keyHold["ALT"] then
				local tempObjects = getObjectsInsideRect(draggingStartPosWorld.x, draggingStartPosWorld.y, cursorWorld.x, cursorWorld.y)
				for k, v in _G.pairs(tempObjects) do
					for soi = 1, #selectedObjects do
						if selectedObjects[soi] == v then
							_G.table.remove(selectedObjects, soi)
							soi = #selectedObjects
						end
					end
				end				
			end
		end
		selectionRectActive = false
	end

	if keyPressed["LBUTTON"] then
		oldCursor.x = cursor.x
		oldCursor.y = cursor.y
		if not keyHold["SPACE"] then
			if objectToAdd ~= nil then
				if not editor.drawOneLayer then
					local name = createObject(blockTable, objectToAdd, nil, cursorPhysics.x, cursorPhysics.y)
					setRotation(name, objectToAddAngle)
					selectedObjects = {}
					birdSelected = false
					_G.table.insert(selectedObjects, objects.world[name])
				else
					local spr = blockTable.blocks[objectToAdd].sprite
					if not spr and blockTable.blocks[objectToAdd].damageSprites then
						spr = blockTable.blocks[objectToAdd].damageSprites.damage1
					end
					if spr then
					
						if objects.counts[objectToAdd] == nil then
							objects.counts[objectToAdd] = 0
						end
	
						objects.counts[objectToAdd] = objects.counts[objectToAdd] + 1
						local name = objectToAdd .. "_" .. objects.counts[objectToAdd]
						selectedObjects = {}
						
						addThemeSprite(name, {definition=objectToAdd, name=name, x = cursorPhysics.x, y = cursorPhysics.y, angle = 0, scale = {x=1,y=1}, layer = editor.currentLayer })
						
						if not objects.themeSprites then
							objects.themeSprites = {}
						end
						objects.themeSprites[name] = { definition = objectToAdd, 
													   name = name, x = cursorPhysics.x, 
													   y = cursorPhysics.y, layer = editor.currentLayer, 
													   angle = objectToAddAngle, scale = {x=1,y=1} }							   						
					end
				end	
			end
			if copiedObjects ~= nil then
				
				--this table will be indexed by the copied objects names, and the values
				--will be the new copies name
				local t_nameRelationTable = {}
				for k, v in _G.pairs(copiedObjects) do
					if editor.drawOneLayer then
						--print("k = "..k.." value = " ..v.definition)
						
						if objects.counts[v.definition] then
							objects.counts[v.definition] = objects.counts[v.definition] + 1						
						else
							objects.counts[v.definition] = 1			
						end
						local name = v.definition .. "_" .. objects.counts[v.definition]
						addThemeSprite(name, {definition=v.definition, name=name, x = cursorPhysics.x + v.x, y = cursorPhysics.y + v.y, angle = v.angle, scale = v.scale, layer = editor.currentLayer })
						
						if not objects.themeSprites then
							objects.themeSprites = {}
						end
						objects.themeSprites[name] = { 	definition = v.definition, 
														name = name, x = cursorPhysics.x + v.x, 
														y = cursorPhysics.y + v.y, 
														layer = editor.currentLayer, 
														angle = v.angle,
														scale = v.scale}
					else
						local name = createObject(blockTable, v.definition, nil, cursorPhysics.x + v.x, cursorPhysics.y + v.y)
						t_nameRelationTable[v.name] = name
						setRotation(name, v.angle)
						objects.world[name].strength = v.strength
					end
					
				end						
				
				--will create new joints based on the new objects
				if copiedJoints ~= nil then
					for k, v in _G.pairs(copiedJoints) do
						
						
						local t_newJointName = t_nameRelationTable[v.end1] .. t_nameRelationTable[v.end2]
						
						--makes a copy of the joint to be copied, with updated name, and1 and end2 values					
						
						t_newJoint = {}
						
						
						--distance joint
						if v.type == 1 then
							t_newJoint = { name = t_newJointName, type =  v.type, end1 = t_nameRelationTable[v.end1], end2= t_nameRelationTable[v.end2], x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, dampingRatio=v.dampingRatio, frequency=v.frequency }
						--weld joint
						elseif v.type == 2 then
							t_newJoint = { name = t_newJointName, type =  v.type, end1 = t_nameRelationTable[v.end1], end2= t_nameRelationTable[v.end2], x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected }
						--revolute joint
						elseif v.type == 3 then
							t_newJoint = { name = t_newJointName, type =  v.type, end1 = t_nameRelationTable[v.end1], end2= t_nameRelationTable[v.end2], x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, maxTorque=v.maxTorque,limit=v.limit,backAndForth=v.backAndForth,motorSpeed=v.motorSpeed,motor=v.motor,lowerLimit=v.lowerLimit,upperLimit=v.upperLimit }
						--prismatic joint
						elseif v.type == 4 then
							t_newJoint = { name = t_newJointName, type =  v.type, end1 = t_nameRelationTable[v.end1], end2= t_nameRelationTable[v.end2], x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, maxTorque=v.maxTorque, limit=v.limit, backAndForth=v.backAndForth,motorSpeed=v.motorSpeed,worldAxisY=v.worldAxisY, motor=v.motor, lowerLimit=v.lowerLimit, upperLimit=v.upperLimit, worldAxisX = v.worldAxisX}
						--anihilation joint
						elseif v.type == 5 then
							t_newJoint = { name = t_newJointName, type =  v.type, end1 = t_nameRelationTable[v.end1], end2= t_nameRelationTable[v.end2], x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, destroyTimer = v.destroyTimer}
						end					
						
						--print("\nnew joint name: " .. t_newJointName)
						createJoint(t_newJoint)
						editorJointPage.addJoint(editorJointPage, t_newJointName)
					end
				end
			end
		end
	end

	if keyHold["LBUTTON"] then
		if keyHold["SPACE"] then
			screen.x = screen.x - (cursorWorld.x - draggingStartPosWorld.x) * 0.5
			screen.y = screen.y - (cursorWorld.y - draggingStartPosWorld.y) * 0.5
		else
			if objectToAdd ~= nil then
				-- do not allow object selection if object to add is active
			elseif selectedObjects ~= nil and #selectedObjects > 0 and (not editor.drawOneLayer)then
				for k, v in _G.pairs(selectedObjects) do
					object = v
					x, y = worldToPhysicsTransform(cursor.x - oldCursor.x, cursor.y - oldCursor.y)
					x = x / worldScale
					y = y / worldScale
					setSleeping(object.name, false)
					if keyHold["CONTROL"] then
						setRotation(object.name, object.angle + (cursor.x - oldCursor.x)/180 * _G.math.pi )
					else
						setPosition(object.name, x + object.x, y + object.y)
					end
				end
				levelSaved = false
			elseif selectedObjects ~= nil and #selectedObjects > 0 and editor.drawOneLayer then
				for k, v in _G.pairs(selectedObjects) do
					object = v
					x, y = worldToPhysicsTransform(cursor.x - oldCursor.x, cursor.y - oldCursor.y)
					x = x / worldScale
					y = y / worldScale
					if keyHold["CONTROL"] then
						modifyThemeSprite(object.name, object.x, object.y, object.scale.x, object.scale.y, object.angle + (cursor.x - oldCursor.x)/180 * _G.math.pi , object.layer)
						object.angle = object.angle + (cursor.x - oldCursor.x)/180 * _G.math.pi 
						objects.themeSprites[object.name].angle = object.angle
					else
						modifyThemeSprite(object.name,  x + object.x, y + object.y, object.scale.x, object.scale.y, object.angle, object.layer)
						object.x = x + object.x
						object.y = y + object.y
						objects.themeSprites[object.name].x = object.x
						objects.themeSprites[object.name].y = object.y
					end
				end
				levelSaved = false
			end
		end
	end

	if not keyHold["LBUTTON"] and not keyHold["RBUTTON"] then
		draggingStartPosWorld.x = cursorWorld.x
		draggingStartPosWorld.y = cursorWorld.y
	end

	-- handle key input
	if selectedObjects ~= nil and #selectedObjects > 0 then
		local moveAmount = 1
		if keyHold["SHIFT"] then
			moveAmount = 10
		end	
		if keyHold["SHIFT"] and keyHold["CONTROL"] then
			moveAmount = 100
		end
		if not keyHold["SHIFT"] and keyHold["CONTROL"] then
			-- remove movement if only control pressed
			moveAmount = 0
		end
		
		if keyReleased["DELETE"] then
			if editor.drawOneLayer then
				for k, v in _G.pairs(selectedObjects) do					
					local name = v.name
					objects.themeSprites[v.name] = nil
					themeSpriteObjects[v.name] = nil
					removeThemeSprite(name, editor.currentLayer)
				end
			else
	
				for k, v in _G.pairs(selectedObjects) do
					for key, value in _G.pairs(objects.joints) do
						if value.end1 == v.name or value.end2 == v.name then
							editorJointPage:removeItem(value.name)
							editorJointPage:removeItem(value.name .. "_ANCHOR_1")
							editorJointPage:removeItem(value.name .. "_ANCHOR_2")
						end
					end
					
					local name = v.name
					objects.world[name] = nil
					removeObject(name)
				end
				
			end
			selectedObjects = {}
			levelSaved = false
		end
		if not keyHold["RETURN"] then
			local moveKeyDown = false

			if (keyHold["LEFT"] or keyHold["RIGHT"] or keyHold["UP"] or keyHold["DOWN"])then
				moveKeyDown = true
			end
			
			if blockMoveTimer == 0 or blockMoveTimer > 0.3 then
				if keyHold["LEFT"] then
					setPositions(-moveAmount, 0)
				end
				if keyHold["RIGHT"] then
					setPositions(moveAmount, 0)
				end
				if keyHold["UP"] then
					setPositions(0, -moveAmount)
				end
				if keyHold["DOWN"] then
					setPositions(0, moveAmount)
				end
			end
			
			if moveKeyDown then
				blockMoveTimer = blockMoveTimer + dt
			else
				blockMoveTimer = 0
			end		
		end
	end

	if keyHold["SHIFT"] then
		if keyPressed["R"] then
			local angle = _G.math.pi / 8
			if keyHold["CONTROL"] then
				angle = -angle
			end
			if copiedObjects ~= nil then
				local px, py, w, h = getObjectListBounds(copiedObjects)
				for k, v in _G.pairs(copiedObjects) do
	
					v.angle = v.angle + angle
					
					-- move to origin
					local cx = v.x - px
					local cy = v.y - py
					
					-- rotate around origin
					local tcx = cx * _G.math.cos(angle) - cy * _G.math.sin(angle)
					local tcy = cx * _G.math.sin(angle) + cy * _G.math.cos(angle)
	
					-- move back
					v.x = tcx + px
					v.y = tcy + py
					--print("Rotating copied object: " .. k .. "\n")
				end
			else
				if objectToAdd ~= nil then
					objectToAddAngle = objectToAddAngle + angle
				else
					if selectedObjects ~= nil and #selectedObjects > 0 then
						for k, v in _G.pairs(selectedObjects) do
							setRotation(v.name, v.angle + angle)
						end
						levelSaved = false
					end
				end
			end
		end
		
		if keyPressed["J"] then
			if #selectedObjects == 2 then
				--createJoint(selectedObjects[1].name .. selectedObjects[2].name, selectedObjects[1].name, selectedObjects[2].name, 1, 2, 0, 0, 0, 0)
				--levelSaved = false
				
				editor.newJoint = { name = selectedObjects[1].name .. selectedObjects[2].name, 
								end1 = selectedObjects[1].name, end2 = selectedObjects[2].name, type = 1,
								coordType = 2, x1 = 0, y1 = 0, x2 = 0, y2 = 0, collideConnected = false }
				editorJointPage.newJoint = true	
				levelSaved = false
				
			end
		end
	end
	
	if #selectedObjects == 2 then
		if keyPressed["F1"] then -- distance joint
			editor.newJoint = { name = selectedObjects[1].name .. selectedObjects[2].name, 
								end1 = selectedObjects[1].name, end2 = selectedObjects[2].name, type = 1,
								coordType = 2, x1 = 0, y1 = 0, x2 = 0, y2 = 0 }
			editorJointPage.newJoint = true		
		elseif keyPressed["F2"] then -- weld joint
			editor.newJoint = { name = selectedObjects[1].name .. selectedObjects[2].name, 
								end1 = selectedObjects[1].name, end2 = selectedObjects[2].name, type = 2,
								coordType = 2, x1 = 0, y1 = 0, x2 = 0, y2 = 0 }
			editorJointPage.newJoint = true	
		elseif keyPressed["F3"] then -- revolute joint
			editor.newJoint = { name = selectedObjects[1].name .. selectedObjects[2].name, 
								end1 = selectedObjects[1].name, end2 = selectedObjects[2].name, type = 3,
								coordType = 2, x1 = 0, y1 = 0, x2 = 0, y2 = 0 }
			editorJointPage.newJoint = true		
		elseif keyPressed["F4"] then -- prismatic joint
			editor.newJoint = { name = selectedObjects[1].name .. selectedObjects[2].name, 
								end1 = selectedObjects[1].name, end2 = selectedObjects[2].name, type = 4,
								coordType = 2, x1 = 0, y1 = 0, x2 = 0, y2 = 0}
			editorJointPage.items.x.visible = true
			editorJointPage.items.y.visible = true
			editorJointPage.items.x.text = editorJointPage.xTexts[1]
			editorJointPage.items.y.text = editorJointPage.yTexts[1]
			editorJointPage.newJoint = true	
		elseif keyPressed["F5"] then -- "destroy attached" -joint
			editor.newJoint = { name = selectedObjects[1].name .. selectedObjects[2].name,
								end1 = selectedObjects[1].name, end2 = selectedObjects[2].name, type = 5,
								coordType = 2, x1 = 0, y1 = 0, x2 = 0, y2 = 0								}
			editorJointPage.newJoint = true	
		end
	end
		
	if not keyHold["SHIFT"] and keyHold["CONTROL"] then		
		if keyPressed["LEFT"] or keyPressed["RIGHT"] then
			if selectedObjects ~= nil and #selectedObjects > 0 then
				local px, py, w, h = getObjectListBounds(selectedObjects)
								
				for k, v in _G.pairs(selectedObjects) do
					setPosition(v.name, px + (px - v.x), v.y)
				end
				levelSaved = false
			end			
		end
	
		if keyPressed["UP"] or keyPressed["DOWN"] then
			if selectedObjects ~= nil and #selectedObjects > 0 then
				local px, py, w, h = getObjectListBounds(selectedObjects)
								
				for k, v in _G.pairs(selectedObjects) do
					setPosition(v.name, v.x, py + (py - v.y))
				end
				levelSaved = false
			end
		end
	end
	
	if keyHold["SHIFT"] and keyHold["CONTROL"] and (keyPressed["B"] or keyPressed["HOME"]) then
		if objects.birdCameraData and objects.birdCameraData[deviceModel] ~= nil then
			screen.x = objects.birdCameraData[deviceModel].px
			screen.y = objects.birdCameraData[deviceModel].py
			worldScale = objects.birdCameraData[deviceModel].sx
			setWorldScale(worldScale)
			oldScale = worldScale
		end
	end
	
	if keyHold["SHIFT"] and keyHold["CONTROL"] and (keyPressed["C"] or keyPressed["END"]) then
		if objects.castleCameraData ~= nil and objects.castleCameraData[deviceModel]then
			screen.x = objects.castleCameraData[deviceModel].px
			screen.y = objects.castleCameraData[deviceModel].py
			worldScale = objects.castleCameraData[deviceModel].sx
			setWorldScale(worldScale)
			oldScale = worldScale
		end
	end
	
	if not keyHold["SHIFT"] and not keyHold["CONTROL"] and keyPressed["END"] then
		if objects.doNotWaitForMovingObjects ~= nil then
			objects.doNotWaitForMovingObjects = nil
		else
			objects.doNotWaitForMovingObjects = true
		end
	end
	
	if not keyHold["SHIFT"] and keyHold["CONTROL"] and keyPressed["C"] then
		copiedObjects = {}
		copiedJoints = {}
		local x, y, w, h = getObjectListBounds(selectedObjects)
		for k, v in _G.pairs(selectedObjects) do
			--print("Adding to copied objects: " .. v.name .. "\n")
			copiedObjects[v.name] = { name = v.name, definition = v.definition, x = v.x - x, y = v.y - y, angle = v.angle }
			if v.width == nil then
				copiedObjects[v.name].width = v.radius
				copiedObjects[v.name].height = v.radius
			else
				copiedObjects[v.name].width = v.width
				copiedObjects[v.name].height = v.height
			end
			
			if editor.drawOneLayer then
				copiedObjects[v.name].scale = v.scale
			end	
			
		end
		
		for k, v in _G.pairs(objects.joints) do
			--print("Current joints to check: " .. v.name .. "\n")
			
			--change the clause below to or if you want to select a joint even if you have
			--only selected one block of it
			--if isKeyInList(v.end1, copiedObjects) and isKeyInList(v.end2, copiedObjects) then
			if copiedObjects[v.end1] ~= nil and copiedObjects[v.end2] ~= nil then
				--print("this joint is going to get copied " .. v.name .. "\n")
				
				--distance joint
				if v.type == 1 then
					copiedJoints[v.name] = { type =  v.type, end1 = v.end1, end2= v.end2, x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, dampingRatio=v.dampingRatio, frequency=v.frequency }
				--weld joint
				elseif v.type == 2 then
					copiedJoints[v.name] = { type =  v.type, end1 = v.end1, end2= v.end2, x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected }
				--revolute joint
				elseif v.type == 3 then
					copiedJoints[v.name] = { type =  v.type, end1 = v.end1, end2= v.end2, x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, maxTorque=v.maxTorque,limit=v.limit,backAndForth=v.backAndForth,motorSpeed=v.motorSpeed,motor=v.motor,lowerLimit=v.lowerLimit,upperLimit=v.upperLimit }
				--prismatic joint
				elseif v.type == 4 then
					copiedJoints[v.name] = { type =  v.type, end1 = v.end1, end2= v.end2, x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, maxTorque=v.maxTorque, limit=v.limit, backAndForth=v.backAndForth,motorSpeed=v.motorSpeed,worldAxisY=v.worldAxisY, motor=v.motor, lowerLimit=v.lowerLimit, upperLimit=v.upperLimit, worldAxisX = v.worldAxisX}
				--anihilation joint
				elseif v.type == 5 then
					copiedJoints[v.name] = { type =  v.type, end1 = v.end1, end2= v.end2, x1=v.x1, y1=v.y1, x2=v.x2, y2=v.y2, coordType=v.coordType,collideConnected=v.collideConnected, destroyTimer = v.destroyTimer}
				end
			end
			
		end
		--the loop below is for selecting blocks that were left off from the selection
		--but are connected to a joint that is connected to a selected block. 
		--uncomment it out if needed later
		--[[
		for k, v in _G.pairs(copiedJoints) do
			--print("this joint will be copied: " .. k .. "\n")
			
			
			
			if (not isKeyInList(v.end1, copiedObjects)) then
				--print("this object is not selected, but will be copied " .. v.end1 .. "\n")				
				
				copiedObjects[v.end1] = { name = v.end1, definition = objects.world[v.end1].definition, x = objects.world[v.end1].x - x, y = objects.world[v.end1].y - y, angle = objects.world[v.end1].angle, strength=objects.world[v.end1].strength }
				if objects.world[v.end1].width == nil then
					copiedObjects[v.end1].width = objects.world[v.end1].radius
					copiedObjects[v.end1].height = objects.world[v.end1].radius
				else
					copiedObjects[v.end1].width = objects.world[v.end1].width
					copiedObjects[v.end1].height = objects.world[v.end1].height
				end
			
			elseif (not isKeyInList(v.end2, copiedObjects)) then
				--print("this object is not selected, but will be copied " .. v.end1 .. "\n")				
				
				copiedObjects[v.end2] = { name = v.end2, definition = objects.world[v.end2].definition, x = objects.world[v.end2].x - x, y = objects.world[v.end2].y - y, angle = objects.world[v.end2].angle, strength=objects.world[v.end2].strength }
				if objects.world[v.end2].width == nil then
					copiedObjects[v.end2].width = objects.world[v.end2].radius
					copiedObjects[v.end2].height = objects.world[v.end2].radius
				else
					copiedObjects[v.end2].width = objects.world[v.end2].width
					copiedObjects[v.end2].height = objects.world[v.end2].height
				end
			end
			
		end
		]]--
		
		--for k, v in _G.pairs(copiedObjects) do
		--	print("Final objects to copy: " .. v.name .. "\n")
		--end
		
		selectedObjects = {}
	end
	
	if (keyHold["CONTROL"] and keyPressed["P"]) or (editor.edit_particles and keyPressed["RETURN"]) then
		editor.edit_particles = not editor.edit_particles
		if editor.particle_amount == nil then
			if objects.levelParticles and objects.levelParticles.settingsFrame and objects.levelParticles.settingsFrame.amount then
				editor.particle_amount = objects.levelParticles.settingsFrame.amount
			else
				editor.particle_amount = 0
			end
		end
		if editor.particle_type == nil then
			editor.particle_type = 0
			if objects.levelParticles and objects.levelParticles.particles then
				local p = objects.levelParticles.particles
				if particleTable.particles[p] then
					for k, v in _G.ipairs(particleTable.levelParticles) do
						if v == p then
							editor.particle_type = k
						end
					end
				end
			end
		end
	end
	
	if editor.edit_particles and not keyHold["CONTROL"] then
		local refreshParticleData = function()
			if editor.particle_amount > 0 and editor.particle_type > 0 then
				objects.levelParticles =
				{
					settingsBegin =
					{
						ignoreLimits = false,
						amount = editor.particle_amount * 10,
					},
					settingsFrame =
					{
						ignoreLimits = false,
						amount = editor.particle_amount,
					},
					particles = particleTable.levelParticles[editor.particle_type]
				}
			else
				objects.levelParticles = nil
			end
		end
	
		if keyPressed["M"] then
			editor.particle_amount = editor.particle_amount + 1
			refreshParticleData()
		end
		if keyPressed["L"] then
			if editor.particle_amount > 0 then
				editor.particle_amount = editor.particle_amount - 1
				refreshParticleData()
			end
		end
		if keyPressed["T"] then
			editor.particle_type = editor.particle_type + 1
			if editor.particle_type > #particleTable.levelParticles then
				editor.particle_type = 0
			end
			refreshParticleData()
		end
		if keyPressed["D"] then
			editor.particle_amount = 0
			editor.particle_type = 0
			refreshParticleData()
		end
	end
	
	if keyPressed["0"] then
		editor.drawOneLayer = not editor.drawOneLayer
		selectedObjects = {}
		copiedObjects = {}
		copiedJoints = {}
		objectToAdd = nil
	end
	
	defaultCamera(dt)

	oldCursor.x = cursor.x
	oldCursor.y = cursor.y	
	
--	drawGame()
	for k, v in _G.pairs(objects.joints) do
		if v.backAndForth then
			checkJointLimits(v.name)
		end
	end
	
	if editor.drawOneLayer and keyHold["CONTROL"] and cursor.wheelTriggered then
		editor.currentLayer = editor.currentLayer - cursor.wheel
		local maxLayer = #blockTable.themes[objects.theme].bgLayers + #blockTable.themes[objects.theme].fgLayers 
		if editor.currentLayer >= maxLayer then
			editor.currentLayer = 0
		elseif editor.currentLayer < 0 then
			editor.currentLayer = maxLayer - 1
		end
	end
	
	editorJointPage:update(dt)
	drawEditor()
	editorJointPage:draw()
	
	if cursor.wheelTriggered then
		cursor.wheelTriggered = false
	end
	

	
end

function roundNumber(number, decimalDigits) 	
	local t_shift = 10 ^ decimalDigits
	
	return (_G.math.floor( number*t_shift + 0.5 ) / t_shift)
end

function returnToEditor()
	setEditing(true)
	local name = "temp/" .. levelName .. ".temp.playtest"
	currentThemeNumber = levelSelectionPageNumber
	menuManager:changeRoot(nil)
	loadLevelInternal(levelFolder .. name)
	setGameMode(updateEditor)
	setPhysicsEnabled(false)
end

function goToMenu()
	--pausePage.offsetX = -pauseBGw
	--setGameMode(showPauseMenu)
	showHatcheryIngameMenu(false)
	--[[
	if deviceModel == "iphone4" then
		wantedResolution = "HALF" 
		changeResolution = true	
	end
	]]--
	eventManager:queueEvent({ id = events.EID_PAUSE_CLICKED })
	drawGame()
end

function addObjectToSelection(object, removeDuplicate)
	local objectFound = false
	for soi = 1, #selectedObjects do
		if selectedObjects[soi] == object then
			if removeDuplicate then
				_G.table.remove(selectedObjects, soi)
			end
			objectFound = true
			soi = #selectedObjects
		end
	end
	if not objectFound then
		_G.table.insert(selectedObjects, object)
	end
end


function postTotalHighScores()
	if postHighscores == true then
		local totalScore = 0
		local worldNumber = 0
		
		-- iterate through episodes
		for i = 1, #g_episodes do
			local epTotalScore = 0
			for j = 1, #g_episodes[i].pages do
				local page = g_episodes[i].pages[j]
				local world = page.world_number
				local score = getWorldScore(i, j)
				
				epTotalScore = epTotalScore + score
				
				-- post world score
				local lboardName = getLeaderboardNameForWorld(world)
				if lboardName and score > 0 then
					postLevelHighScore(lboardName, score, false)
				end
			end
			
			totalScore = totalScore + epTotalScore
			
			-- post episode score
			local lboardName = getLeaderboardNameForEpisode(i)
			if lboardName and epTotalScore > 0 then
				postLevelHighScore(lboardName, epTotalScore, false)
			end
		end
		
		-- post total score
		local lboardName = getLeaderboardNameForTotalScore()
		if lboardName and totalScore > 0 then
			postLevelHighScore(lboardName, totalScore, false)
		end
	end
end

function postLevelHighScore(levelName, score, isLevelScore)
	if postHighscores == true then
		if leaderboards ~= nil then
			leaderboardid = leaderboards[levelName]
			if leaderboardid ~= nil then
				print("Posting highscore for level " .. levelName .. " (score = " .. score ..  " leaderboard = " .. leaderboardid .. ")\n")
				postHighscore(leaderboardid, score, isLevelScore)
			else
				print("Leaderboard id for level " .. levelName .. " not found!\n")
			end
		end
	end
end

function returnToLevelSelection()
	stopIngameSounds()
	currentMenuPage = nil
	newMenuPage = nil
	setGameMode(function() end)
	eventManager:notify({id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_"..currentThemeNumber})
end

--tween ease functions
function tweenLinear (currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	return c*t/d + b;
end


function tweenEaseCubicIn(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d
	return c*(t)*t*t + b;
end


function tweenEaseCubicOut(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d-1
	return c*((t)*t*t + 1) + b;
end


function tweenEaseCubicInOut(currentTime, startValue, changeOfValue, duration)
	
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue

	t = t / (d/2);
	if (t < 1) then
		return (c/2) * (t*t*t) + b;  
	end 
	t = t-2
	return (c/2) * (t*t*t + 2) + b;

end

function updateLevelEnding(dt)
	-- level has been completed puff the birds
	if levelCompleted then
		eagleDarkness = nil
		birdBuffTimer = birdBuffTimer - dt
		if birdBuffTimer < 0 then
			local nextBirdName = getNextBird(birdsLeftCounter)
			if nextBirdName ~= nil then
				birdsLeftCounter = birdsLeftCounter + 1
				
				-- if mighty eagle is selected don't add points from unused birds
				if eagleBaitLaunched ~= true then
					scoreTable["birds"].score = scoreTable["birds"].score + birdsLeftScoreIncrement
				end
				
				local nbo = objects.world[nextBirdName]
				-- if nbo == selectedBird then
					-- birdFired = true
				-- end
				_G.res.playAudio(getAudioName("bird_misc"), 1, false, 0)
				_G.table.insert(floatingScores, { x = nbo.x, y = nbo.y, sprite = getObjectDefinition(nextBirdName).spriteScore, score = birdsLeftScoreIncrement, time = 0, lifetime = 0.9, maxScale = floatingScoreScaling * 1, xs = 0 } )
				birdBuffTimer = 0.5
				--removeBird(nbo)
			else
				-- show boomerang bird popup just before going to level complete screen
				if showBoomerangBirdPopup == true and (levelCompleteTimer > 0 and levelCompleteTimer - dt <= 0) then
					showBoomerangBirdPopup = false
					--setActivePopupPage(boomerangBirdAchievedPage)
					--_G.res.playAudio("star_collect", 1, false)
					
					levelCompleteTimer = levelCompleteTimer + 3.6
					
					eventManager:notify({ id = events.EID_BOOMERANG_BIRD_POPUP, })
					
					if currentLevelNumberInTheme == 4 and currentWorldNumber == 6 then
						settingsWrapper:setBoomerangBirdAchieved()
					elseif currentLevelNumberInTheme == 5 and currentWorldNumber == 9 then
						settingsWrapper:setBoomerangBird2Achieved()
					end
					
					eventManager:notify({id = events.EID_BOOMERANG_BIRD_POPUP_SHOWN})
					
					--[[
					if deviceModel == "iphone4" then
						changeResolution = true
						wantedResolution = "HALF"
					end
					]]--
				else
					levelCompleteTimer = levelCompleteTimer - dt
				end
			end
			updateScore(dt)
			-- for testing
			if quadClick == true then
				score = starTable[levelName].goldScore
				if eagleBaitLaunched == true then
					score = starTable[levelName].eagleScore
				end
			end
		end
	else
		levelCompleteTimer = levelCompleteTimer - dt
	end
	-- is level going to end
	if levelCompleteTimer <= 0 then
		--gotoLevelEnding()
		if not isChallengeMode() then
			if devideModel == "iphone4" then
				changeResolution = true
				wantedResoluion = "HALF"
			end
			eventManager:queueEvent({ id = events.EID_LEVEL_ENDED, level = levelName, score = score, levelComplete = levelCompleted })
		else

			print("levelIndex = "..g_currentChallengeProgress.levelIndex.."\n")
			print("shots queue = ".._G.tostring(#g_currentChallengeProgress.shotsQueue).."\n")
			print("total levels = "..#g_currentChallenge.levels.."\n")
			
			if g_currentChallenge.type == "BIRD_FLOCK" then			
				if (g_currentChallengeProgress.shotsQueue == nil or #g_currentChallengeProgress.shotsQueue == 0) and g_currentChallengeProgress.levelIndex < #g_currentChallenge.levels then
					levelCompleted = false
				end
			end
			eventManager:notify({ id = events.EID_CHALLENGE_LEVEL_ENDED,  challenge = g_currentChallenge, progress = g_currentChallengeProgress, levelComplete = levelCompleted})
		end
	end
end


function initLevelComplete()
	
	--hide eagle button
	--if not isEagleUnavailableForShot() then
		--inGameEagleButtonVisible = false
	--end
	eventManager:notify({id = events.EID_LEVEL_COMPLETE_INIT})
	--reset the slingshot rubberband
	rubberBandPos.x = levelStartPosition.x
	rubberBandPos.y = levelStartPosition.y
	rubberBandSpeed = 0
	
	allowResetToBirdCamera = false
	showTapIcon = false
	showTapTimer = 0
	levelCompleted = true
	
	--count birds that haven't been fired for giving score for them
	birdsLeftCounter = currentBirdIndex
	if currentBirdName == nil or objects.world[currentBirdName].shot == true then
		birdsLeftCounter = birdsLeftCounter + 1
	end
	
	-- if some birds are left go to launch camera and show the scores
	if getNextBird(birdsLeftCounter) ~= nil then
		birdBuffTimer = 2.5			
		if cameraFunction ~= launchCamera then
			birdBuffTimer = 3.5
			castleCameraTimer = 1.0
			cameraFunction = launchCamera
			animationScreen.x = screen.x
			animationScreen.y = screen.y
			animationWorldScale = worldScale					
		end
	end
	
	_G.res.playAudio(getAudioName("level_clear_military"), 1, false)
	levelCompleteTimer = 1.0
	if eagleBaitLaunched then
		levelCompleteTimer = 2.0
	end
	
	--FIXME: move this to level metadata in episodes.lua?
	if (currentWorldNumber == 6 and currentLevelNumberInTheme == 4 and settingsWrapper:isBoomerangBirdAchieved() ~= true) or
	   (currentWorldNumber == 9 and currentLevelNumberInTheme == 5 and settingsWrapper:isBoomerangBird2Achieved() ~= true) then
		showBoomerangBirdPopup = true
	end
	
end

function initLevelFailed(dt)
	-- wait for 1.5 seconds until declare level as failed
	levelFailedTimer = levelFailedTimer + dt
	if levelFailedTimer > 1.5 then
		--setPhysicsEnabled(false)
		levelCompleteTimer = 0.5
		_G.res.playAudio(getAudioName("level_failed_piglets"), 1, false)
	end
end

--
--
--


-------------------------------------------------------------------------------
-- GAME
--

--screenCaptureDelay = 0.4
function updateGame(dt, time)

	--[[
	screenCaptureDelay = screenCaptureDelay - dt
	
	if(screenCaptureDelay <= 0 and #challengeQueue > 0) then
		captureScreen(currentWorldNumber.."-"..currentLevelNumberInTheme..".png")
		eventManager:notify(_G.table.remove(challengeQueue,1))
		screenCaptureDelay = 0.4
	end]]
	
	--[[ BEGIN FPS DEBUG CODE -- 
	
	if drawFPSStatistics or FPSFrames > 1 then
	
		if not drawFPSStatistics then
			drawFPSStatistics = true
			FPSFrames = 0
			FPSTime = 0
			FPSMin = 1000000
			FPSMax = 0
		end
		
		local FPS = 1/dt
		if FPS < FPSMin then
			FPSMin = FPS
		end
		if FPS > FPSMax then
			FPSMax = FPS
		end
	end
	FPSFrames = FPSFrames + 1
	FPSTime = FPSTime + dt
	
	-- END FPS DEBUG CODE --]]
	
	if g_currentChallenge ~= nil then
		if g_currentChallenge.type == "BIRD_FLOCK" then
			updateBirdFlockChallenge(dt, time)
		end
	end
	
	if flyingBird ~= nil then
		local bDef = getObjectDefinition(flyingBird.name)
		
		if bDef ~= nil and bDef.sprite ~= nil and settingsWrapper:getTutorialsForItem(bDef.sprite) and settingsWrapper:getTutorialsForItem(bDef.sprite).showHelp then
			extraTutorialTimer = extraTutorialTimer + dt
		end		
	end
	
	--[[
	if oldScreenWidth ~= screenWidth or oldScreenHeight ~= screenHeight then

		if #birdTutorialPopups > 0 then
			prepareMenuPage(tutorials)
		end
		
		if popupPage ~= nil then
			
			if(popupPage == dummyPopupPage and dummyPopupPage ~= nil and dummyPopupPage.rootContainer ~= nil) then
				dummyPopupPage.rootContainer:layout()
			end
		end
	end
	]]--
	
	cameraShakeX, cameraShakeY = 0, 0
	if cameraShake ~= nil and cameraShake ~= 0 then
		cameraShakeX = _G.math.floor(_G.math.random(-_G.math.abs(cameraShake), _G.math.abs(cameraShake)))
		cameraShakeY = _G.math.floor(_G.math.random(-_G.math.abs(cameraShake), _G.math.abs(cameraShake)))
	end
	--[[
	if inGameEagleButtonScale ~= nil then
		inGameEagleButtonScalingTimer = inGameEagleButtonScalingTimer + dt * 6
		if inGameEagleButtonVisible == true then
			inGameEagleButtonScale = _G.math.cos(inGameEagleButtonScalingTimer) * 0.25 + 0.75
		else
			inGameEagleButtonScale = inGameEagleButtonScale - dt * 3
			if inGameEagleButtonScale <= 0 then
				inGameEagleButtonScale = nil
			end
		end
	end]]
	
	if settingsWrapper:getEagleUsedTime() ~= nil and timeDiff(currentTime(), settingsWrapper:getEagleUsedTime()) >= eagleLockedTime then 
		print("Mighty eagle available again!\n")
			
		settingsWrapper:setEagleUsedTime(nil)
		settingsWrapper:resetEaglesUsedIn()
	end
	
	--[[
	if popupPage ~= nil then
		updateMenuPage(popupPage, dt)
		drawGame()
		return
	end
	]]--
		
	--if currentMenuPage ~= pausePage then
		--setActiveMenuPage(pausePage)
	--end
			
			
	--check if force end timer is running
	if time ~= nil and lastScoreTime ~= 0 then
	
		--score has changed, reset the timer
		if oldScore ~= score then
			oldScore = score
			lastScoreTime = time
		end
		
		--timer expired
		if time - lastScoreTime >= 15 then
			levelTimeout = true
		else
			levelTimeout = false
		end
		
		--print("oldscore=" .. oldScore .. " lastscoretime=" .. lastScoreTime .. " leveltimeout=" .. _G.tostring(levelTimeout) .. "\n")
	end
	
	--updateScale()
	updateAnimations(dt)
	
	-- update cursors
	oldCursorWorld.x = cursorWorld.x
	oldCursorWorld.y = cursorWorld.y
	cursorPhysics.x, cursorPhysics.y = screenToPhysicsTransform(cursor.x, cursor.y)
	cursorWorld.x, cursorWorld.y = screenToWorldTransform(cursor.x, cursor.y)
	
	rightSweep = false
	leftSweep = false	
	
	-- update game timers
	quadClickTimer = quadClickTimer - dt
	
	-- Handle input -- 
	if keyReleased["ESCAPE"] or keyReleased["KEY_BACK"] or (startedFromEditor == true and touchcount == 3) then
		_G.res.stopAudio(currentMusic)
		--setPhysicsEnabled(false)
		if startedFromEditor then
			returnToEditor()
		end
		return
	end
	
	if startedFromEditor ~= true then
		if keyPressed["LEFT"] then
			levelRestartedFrom = "keyboard command"
			setGameMode(loadPreviousLevel)
		end
		
		if keyPressed["RIGHT"] then
			levelRestartedFrom = "keyboard command"
			setGameMode(loadNextLevel)
		end
		
		if keyPressed["F5"] or keyPressed["R"] then
			levelRestartedFrom = "keyboard command"
			--loading = true
			--setGameMode(updateLoading)
			--eventManager:notify({id = events.EID_SET_MENU, target = LevelLoadingPage:new(nil, levelFolder .. levelName), immediate = true})
			--menuManager:setRoot(LevelLoadingPage:new(nil, levelFolder .. levelName))
			if not isChallengeMode() then
				eventManager:notify({id = events.EID_LEVEL_LOADING_INIT})
			else
				eventManager:notify({id = events.EID_CHALLENGE_STARTED, challenge = g_currentChallenge})
			end
			--initializeForceTimers()
			currentGameMode = function() end
		end
	else
		if keyPressed["F5"] or keyPressed["R"] then
			levelRestartedFrom = "keyboard command"
			--initializeForceTimers()			
			
			setEditing(false)
			setPhysicsEnabled(false)
			local name = "temp/" .. levelName .. ".temp.playtest"
			checkDirectories()
			loadLevelInternal(levelFolder .. name)
			setGameMode(updateGame)
			if startedFromEditor ~= true then
				levelSelectionPageNumber = currentThemeNumber
			end
			currentThemeNumber = currentThemeIndex
		end
	end
	
	if levelStartTimer == 0 then
		levelStartTimer = levelStartTimer + 0.01
		_G.res.playAudio(getAudioName("level_start_military"), 1, false)
		_G.res.stopAudio(currentMainMenuSong)
		currentBirdIndex = 0
		fillInNextBird = true
	end
	
	if currentMusic ~= nil and _G.res.isAudioPlaying(currentMusic) == false then
		_G.res.playAudio(currentMusic, 1, true,7)
	end

--[[
	if keyPressed["LBUTTON"] then
		if cursor.x < pauseButtonW and cursor.y < pauseButtonH then
			if startedFromEditor then
				returnToEditor()
			else
				goToMenu()
				drawGame()
				return
			end 
		elseif not isChallengeMode() and (isIapEnabled() or isEagleEnabled()) and inGameEagleButtonVisible == true and ( cursor.x < eagleButtonW + pauseButtonW and cursor.x > eagleButtonW and cursor.y < eagleButtonH ) then
			
			eventManager:notify({id = events.EID_MIGHTY_EAGLE_BUTTON_CLICKED, from = "INGAME"})
			
		elseif(shouldShowAd() == true and isShowingAd == true and useShop == true and isAdsOffPurchaseEnabled() and
				cursor.x >= purchaseAdsRemoveButton.x - purchaseAdsRemoveButton.w / 2 and cursor.x <= purchaseAdsRemoveButton.x + purchaseAdsRemoveButton.w / 2 and 
				cursor.y < purchaseAdsRemoveButton.h / 2 + purchaseAdsRemoveButton.y) then
			
			dummyPopupPage.rootContainer:setEnterPageIndex(2)
			dummyPopupPage.rootContainer:onEntry()
			dummyPopupPage.rootContainer:layout()
			setActivePopupPage(dummyPopupPage, nil)			
		end
	end
]]	
	if not startedFromEditor then
		if keyPressed["KEY_MENU"] or keyPressed["P"] then
			goToMenu()
			drawGame()
			return
		end
	end

	if keyPressed["MBUTTON"] then
		setWorldScale(1)
		worldScale = 1
	end
	
	if doubleClick == true then
		if currentWorldNumber == 1 and currentLevelNumberInTheme == 8 then
			treasureChest = objects.world["ExtraTreasureChest_1"]
			if treasureChest ~= nil then
				if distance(cursorPhysics.x, cursorPhysics.y, treasureChest.x, treasureChest.y) < 2.5 then
					goldenEggAchieved("LevelGE_15")
					-- additional popup delay isn't needed (and must not be used) here, because goldenEggAchieved is not called from removeBlocks
					additionalPopupPageDelay = false
				end
			end
		end
	end

	if levelStartTimer < 1 or levelStartTimer > 6 then
		levelStartTimer = levelStartTimer + dt
	else
		setPhysicsEnabled(true)
		levelStartTimer = 10
	end
	
	-- check level complete rule
	if levelCompleteTimer > 0 then
		updateLevelEnding(dt)
	else
		if checkLevelComplete() or keyPressed["C"] or quadClick == true then
			initLevelComplete()
		end
		if checkLevelFailed() then 
			--initLevelFailed(dt)
			initLevelFailed(dt)
		end
	end
	
	-- update timers
	gameTimer = gameTimer + dt
	
	-- update tap timer
	if tapStarted then
		tapTimer = tapTimer + dt
				
		if tapTimer > 0.25 then
			if tapCount == 1 and showTapIcon then
				-- todo: put these to own function, this code is used in three places
				returnToBirdCamera()
			end
			-- reset camera scale
			if tapCount == 2 then
				if cameraAnimationSliderTarget == 0 then
					currentZoomedScale = objects.birdCameraData[deviceModel].sx
				else
					currentZoomedScale = objects.castleCameraData[deviceModel].sx
				end
				maxZoomLevel = true
			end
		
			tapTimer = 0
			tapCount = 0
			tapStarted = false
		end
	end
	
	-- update level background particles
	if objects.levelParticles ~= nil and g_levelParticlesEnabled then
		if objects.levelParticles.firstFrame == true then
			if objects.levelParticles.startAtGroundLevel then
				_G.particles.addLevelParticles(objects.levelParticles.particles, objects.levelParticles.settingsFrame.amount * 15, objects.levelParticles.x, objects.levelParticles.y / 3, objects.levelParticles.width, 0, 0, alse)
			else
				_G.particles.addLevelParticles(objects.levelParticles.particles, objects.levelParticles.settingsFrame.amount * 15, objects.levelParticles.x, objects.levelParticles.y / 3, objects.levelParticles.width, objects.levelParticles.y, 0, false)
			end
			objects.levelParticles.firstFrame = false
			--objects.levelParticles.x = objects.levelParticles.x - (particleTable.particles[objects.levelParticles.particles].maxVel * particleTable.particles[objects.levelParticles.particles].maxVel / (particleTable.particles[objects.levelParticles.particles].maxVel / 3)) / 2
		else
			levelParticlesTimer = levelParticlesTimer + dt
			if levelParticlesTimer > (1 / objects.levelParticles.settingsFrame.amount) and isPhysicsEnabled() then
				levelParticlesTimer = 0
				_G.particles.addLevelParticles(objects.levelParticles.particles, 1, objects.levelParticles.x, objects.levelParticles.y, objects.levelParticles.width, 0, 0, false)
			end
		end
	end

	-- Handle keypress
	if keyPressed["LBUTTON"] and not levelCompleted then
		if skipInput ~= true then
			inGamePressed = true
		
			draggingStartPosPhysics.x = cursorPhysics.x
			draggingStartPosPhysics.y = cursorPhysics.y
			
			draggingStartPosScreen.x = cursor.x
			draggingStartPosScreen.y = cursor.y

			oldCursor.x = cursor.x
			oldCursor.y = cursor.y

			if tapStarted == false then
				tapPosition.x = cursor.x
				tapPosition.y = cursor.y
				tapStarted = true
				tapTimer = 0
			end
		end

		-- if gamestate is bird flying use special action
		
		if flyingBird ~= nil and birdSpecialtyAvailable and flyingBird.hatcheryBird then
			flyingBird.hatcheryBird:triggerSpecialty(flyingBird)
		elseif flyingBird ~= nil and birdSpecialtyAvailable then
			birdSpecialtyAvailable = false
			local bDef = getObjectDefinition(flyingBird.name)
			birdSpecialty = bDef.specialty
			
			if birdSpecialty == "GLOBE" then
                flyingBird.globeTimer = dt*2
			end
			
			if birdSpecialty == "BOOST" then
				settingsWrapper:setExtraTutorialShown(bDef.sprite) --1.5.4
			
				local force = boostForce * physicsScale * flyingBird.mass
				local x, y = vNormalize(flyingBird.xVel, flyingBird.yVel)
				applyImpulse( flyingBird.name,
							-x * force,
							-y * force,
							flyingBird.x,
							flyingBird.y )
				addParticles(flyingBird.name, blockTable.blocks[flyingBird.definition].particles, 10, false, false)
				_G.res.playAudio(getAudioName(blockTable.blocks[flyingBird.definition].specialSound), 1, false)
				objects.world[flyingBird.name].sprite = "BIRD_YELLOW_SPECIAL"
				setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				local lx, ly = physicsToWorldTransform(flyingBird.x, flyingBird.y)
				addPuffToTrajectory(1, lx, ly)
			end
			if birdSpecialty == "BOMB" then
				--birdSpecialtyAvailable = true
				
				settingsWrapper:setExtraTutorialShown(bDef.sprite) --1.5.4
				
				makeExplosion(flyingBird, bDef, getAudioName(blockTable.blocks[flyingBird.definition].specialSound))
				
				removeBird(flyingBird)
			end
			if birdSpecialty == "SOUND" then
				_G.res.playAudio(getAudioName(blockTable.blocks[flyingBird.definition].specialSound), 1, false)
			end
			if birdSpecialty == "CLUSTER_BOMB" then
				--
				settingsWrapper:setExtraTutorialShown(bDef.sprite) --1.5.4
				
				local lx, ly = physicsToWorldTransform(flyingBird.x, flyingBird.y)
				addPuffToTrajectory(1, lx, ly)
				
				local x, y = vNormalize(flyingBird.yVel, -flyingBird.xVel)
				local newName = flyingBird.name .. "a"
				createCircle(newName, flyingBird.sprite, flyingBird.x - x, flyingBird.y - y, flyingBird.radius, flyingBird.density, flyingBird.friction, flyingBird.restitution, flyingBird.controllable, flyingBird.z_order)
				objects.world[newName].definition = flyingBird.definition
				objects.world[newName].controllable = flyingBird.controllable
				objects.world[newName].strength = flyingBird.strength
				objects.world[newName].defence = flyingBird.defence
				objects.world[newName].material = flyingBird.material
				objects.world[newName].levelGoal = flyingBird.levelGoal
				objects.world[newName].damageFactors = flyingBird.damageFactors
				objects.world[newName].spritePivotX = flyingBird.spritePivotX
				objects.world[newName].spritePivotY = flyingBird.spritePivotY
				objects.world[newName].damageSprite = flyingBird.damageSprite
				objects.world[newName].useLegacyCollisionPath = flyingBird.useLegacyCollisionPath
				objects.world[newName].shot = true
				objects.world[newName].sleeping = false
				objects.world[newName].hasCollided = false
				objects.world[newName].parentName = flyingBird.name
				objects.world[newName].xVel = flyingBird.xVel - x*7
				objects.world[newName].yVel = flyingBird.yVel - y*7
				setSprite(newName, flyingBird.damageSprite)
				setRotation(newName, flyingBird.angle)
				setVelocity(newName, flyingBird.xVel - x*7, flyingBird.yVel - y*7)
				--_G.table.insert(extraObjects, newName)
				birds[newName] = objects.world[newName]
				
				newName = flyingBird.name .. "b"
				createCircle(newName, flyingBird.sprite, flyingBird.x, flyingBird.y, flyingBird.radius, flyingBird.density, flyingBird.friction, flyingBird.restitution, flyingBird.controllable, flyingBird.z_order)
				objects.world[newName].definition = flyingBird.definition
				objects.world[newName].controllable = flyingBird.controllable
				objects.world[newName].strength = flyingBird.strength
				objects.world[newName].defence = flyingBird.defence
				objects.world[newName].material = flyingBird.material
				objects.world[newName].levelGoal = flyingBird.levelGoal
				objects.world[newName].damageFactors = flyingBird.damageFactors
				objects.world[newName].spritePivotX = flyingBird.spritePivotX
				objects.world[newName].spritePivotY = flyingBird.spritePivotY
				objects.world[newName].damageSprite = flyingBird.damageSprite				
				objects.world[newName].useLegacyCollisionPath = flyingBird.useLegacyCollisionPath
				objects.world[newName].shot = true
				objects.world[newName].sleeping = false
				objects.world[newName].hasCollided = false
				objects.world[newName].parentName = flyingBird.name
				objects.world[newName].xVel = flyingBird.xVel
				objects.world[newName].yVel = flyingBird.yVel
				setSprite(newName, flyingBird.damageSprite)				
				setRotation(newName, flyingBird.angle)
				setVelocity(newName, flyingBird.xVel, flyingBird.yVel)
				--_G.table.insert(extraObjects, newName)
				birds[newName] = objects.world[newName]
				
				newName = flyingBird.name .. "c"
				createCircle(newName, flyingBird.sprite, flyingBird.x + x, flyingBird.y + y, flyingBird.radius, flyingBird.density, flyingBird.friction, flyingBird.restitution, flyingBird.controllable, flyingBird.z_order)
				objects.world[newName].definition = flyingBird.definition
				objects.world[newName].controllable = flyingBird.controllable
				objects.world[newName].strength = flyingBird.strength
				objects.world[newName].defence = flyingBird.defence
				objects.world[newName].material = flyingBird.material
				objects.world[newName].levelGoal = flyingBird.levelGoal
				objects.world[newName].damageFactors = flyingBird.damageFactors
				objects.world[newName].spritePivotX = flyingBird.spritePivotX
				objects.world[newName].spritePivotY = flyingBird.spritePivotY
				objects.world[newName].damageSprite = flyingBird.damageSprite				
				objects.world[newName].useLegacyCollisionPath = flyingBird.useLegacyCollisionPath
				objects.world[newName].shot = true
				objects.world[newName].sleeping = false
				objects.world[newName].hasCollided = false
				objects.world[newName].parentName = flyingBird.name
				objects.world[newName].xVel = flyingBird.xVel + x*7
				objects.world[newName].yVel = flyingBird.yVel + y*7
				setSprite(newName, flyingBird.damageSprite)				
				setRotation(newName, flyingBird.angle)
				setVelocity(newName, flyingBird.xVel + x*7, flyingBird.yVel + y*7)
				birds[newName] = objects.world[newName]
				
				otherBirds = { flyingBird.name .. "a", flyingBird.name .. "b" }
				removeBird(flyingBird)
				--objects.world[flyingBird.name] = nil
				flyingBird = objects.world[newName]
				cameraTargetObject = flyingBird

				_G.res.playAudio(blockTable.blocks[flyingBird.definition].specialSound, 1, false)

			end
			-- drop explosive
			if birdSpecialty == "GRENADE" then
				settingsWrapper:setExtraTutorialShown(bDef.sprite) --1.5.4
			
				local x, y = vNormalize(flyingBird.yVel, -flyingBird.xVel)
				local newName = flyingBird.name .. "a"
				objects.world[flyingBird.name].sprite = "BIRD_GREEN_SPECIAL"
				setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				
				createCircle(newName, "DROPPABLE_EGG", flyingBird.x, flyingBird.y + flyingBird.radius*2, flyingBird.radius, flyingBird.density, flyingBird.friction, flyingBird.restitution, true, flyingBird.z_order)
				objects.world[newName].definition = "EggGranade"
				objects.world[newName].controllable = true
				objects.world[newName].strength = flyingBird.strength
				objects.world[newName].defence = flyingBird.defence
				objects.world[newName].material = flyingBird.material
				objects.world[newName].damageFactors = blockTable.blocks[objects.world[newName].definition].damageFactors
				objects.world[newName].useLegacyCollisionPath = flyingBird.useLegacyCollisionPath
				objects.world[newName].levelGoal = false
				local xp, yp = _G.res.getSpritePivot("INGAME_BIRDS_1","DROPPABLE_EGG")
				objects.world[newName].spritePivotX = xp
				objects.world[newName].spritePivotY = yp
				objects.world[newName].damageSprite = "DROPPABLE_EGG"
				objects.world[newName].xVel = 0 --flyingBird.xVel * 0.5
				objects.world[newName].yVel = 100 --flyingBird.yVel * 0.5
				setSprite(newName, objects.world[newName].damageSprite)
				setRotation(newName, flyingBird.angle)
				--setVelocity(newName, flyingBird.xVel*0.5, flyingBird.yVel*0.5)
				setVelocity(newName, objects.world[newName].xVel, objects.world[newName].yVel)
				--objects.world[newName].specialty = "BOMB"
				_G.table.insert(flyingGrenades, { name = newName, timer = 5 })
				--_G.table.insert(extraObjects, newName)
				_G.res.playAudio(getAudioName(blockTable.blocks[flyingBird.definition].specialSound), 1, false)
				--_G.res.playAudio(getAudioName("bird_pushing_egg_out"), 1, false)
				cameraTargetObject = objects.world[newName]
				
				applyImpulse( flyingBird.name,
							-0.04*defaultForce * flyingBird.mass,
							0.08*defaultForce * flyingBird.mass,
							flyingBird.x-0.5,
							flyingBird.y )
				local lx, ly = physicsToWorldTransform(flyingBird.x, flyingBird.y)
				addPuffToTrajectory(1, lx, ly)
			end
			if birdSpecialty == "BOOMERANG" then
				settingsWrapper:setExtraTutorialShown(bDef.sprite) --1.5.4
				
				flyingBird.boomerangActive = true
				if flyingBird.xVel ~= 0 then
					yForceCoeff = 2 - _G.math.min(_G.math.abs(flyingBird.yVel / flyingBird.xVel), 2)
				else
					yForceCoeff = 0
				end
				
				flyingBird.boomerangXForce = flyingBird.xVel * physicsScale * flyingBird.mass * blockTable.blocks[flyingBird.definition].boomerangHorizontalForce
				flyingBird.boomerangYForce = yForceCoeff * physicsScale * flyingBird.mass * blockTable.blocks[flyingBird.definition].boomerangVerticalForce
				flyingBird.boomerangMinXVel = -blockTable.blocks[flyingBird.definition].boomerangMaxHorizontalSpeed
				flyingBird.boomerangMaxXVel = blockTable.blocks[flyingBird.definition].boomerangMaxHorizontalSpeed
				
				--flyingBird.angularVelocity = 0
				objects.world[flyingBird.name].sprite = "BIRD_BOOMERANG_SPECIAL"
				setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				
				_G.res.playAudio(getAudioName(blockTable.blocks[flyingBird.definition].specialSound), 1, false)
				
				local lx, ly = physicsToWorldTransform(flyingBird.x, flyingBird.y)
				addPuffToTrajectory(1, lx, ly)
			end
		elseif skipInput ~= true then
			dragStarted = true
			dragCursorTable = {}
			dragCursorIndex = 1
			dragCursorTable[dragCursorIndex] = { dx = 0, dy = 0, dt = dt }
			tapPosWorld.x = cursorWorld.x
			tapPosWorld.y = cursorWorld.y
			
			if touchcount == 1 then
				if currentBirdName ~= nil then
					local obj = objects.world[currentBirdName]
					if distance(obj.x, obj.y, cursorPhysics.x, cursorPhysics.y) < shootRange/worldScale * screenWidth/480 then
						selectedBird = obj
					end
				end
			end			
		end
	end

	if keyHold["LBUTTON"] and not levelCompleted and inGamePressed and skipInput ~= true then
		if dragStarted == true then
			dragCursorIndex = dragCursorIndex + 1
			if dragCursorIndex > 5 then
				dragCursorIndex = 1
			end
			dragCursorTable[dragCursorIndex] = { dx = cursor.x - oldCursor.x, dy = cursor.y - oldCursor.y, dt = dt }
		
			if selectedBird ~= nil then
				draggingStartPosPhysics.x = levelStartPosition.x
				draggingStartPosPhysics.y = levelStartPosition.y
				-- for the slingshot
				if birdReady == true then
					local distToRest = distance(draggingStartPosPhysics.x, draggingStartPosPhysics.y, cursorPhysics.x, cursorPhysics.y)
					local vecToRest = { x = draggingStartPosPhysics.x - cursorPhysics.x, y = draggingStartPosPhysics.y - cursorPhysics.y }

					rubberBandAngle = _G.math.atan2(vecToRest.y, vecToRest.x)
					shootMaxLength = shootRange + 3.2

					if distToRest < shootMaxLength then
						rubberBandPos.x, rubberBandPos.y = cursorPhysics.x, cursorPhysics.y
						rubberBandLength = distToRest
						if _G.math.abs(rubberBandLength - oldRubberBandLength) > 0.1 and _G.res.isAudioPlaying("slingshot_stretched") == false then
							_G.res.playAudio("slingshot_stretched", 1, false)
						end
						oldRubberBandLength = rubberBandLength
						if birdSelected == false then
							_G.res.playAudio(getObjectDefinition(selectedBird.name).selectionSound, 1, false)
							birdSelected = true
						end
					else
						rubberBandPos.x = draggingStartPosPhysics.x - vecToRest.x * shootMaxLength / distToRest
						rubberBandPos.y = draggingStartPosPhysics.y - vecToRest.y * shootMaxLength / distToRest
						rubberBandLength = shootMaxLength
						rubberBandSpeed = 0

						if birdSelected == false then
							_G.res.playAudio("slingshot_stretched", 1, false)
							_G.res.playAudio(getObjectDefinition(selectedBird.name).selectionSound, 1, false)
							birdSelected = true
						end
					end
					local factor = 1
					if rubberBandAngle >= -1.9 and rubberBandAngle < -1.75 then
						factor = -(rubberBandAngle + 1.75) / 0.15
					end
					if rubberBandAngle >= -1.75 and rubberBandAngle < -1.5 then
						factor = 0.25
					end
					if rubberBandAngle >= -1.5 and rubberBandAngle < -1.35 then
						factor = (1.5 + rubberBandAngle) / 0.15
					end

					if factor < 0.25 then factor = 0.25 end
					if rubberBandLength > factor * shootMaxLength then 
						rubberBandPos.y = draggingStartPosPhysics.y - shootMaxLength * factor * vecToRest.y / distToRest
						rubberBandLength = distance(draggingStartPosPhysics.x, draggingStartPosPhysics.y, rubberBandPos.x, rubberBandPos.y)
					end
				end
			else
				local dx = (objects.castleCameraData[deviceModel].px - objects.birdCameraData[deviceModel].px)
				if dx > 1 then
					local delta = dragCursorTable[dragCursorIndex].dx / (dx * worldScale)
					sweepSpeed = 0
					cameraAnimationSlider = cameraAnimationSlider - delta
					--print("keyHold[LBUTTON] and not levelCompleted: cameraFunction = doItAllCamera\n")									
					cameraFunction = doItAllCamera					
				end
				--print("dx: " .. dragCursorTable[dragCursorIndex].dx .. ", dy " .. dragCursorTable[dragCursorIndex].dy .. "\n")
				
				if deviceModel == "n900" then
					local angle = _G.math.abs(_G.math.atan2(dragCursorTable[dragCursorIndex].dy, dragCursorTable[dragCursorIndex].dx))
					--print("angle: " .. angle .. "\n")
					if _G.math.pi*0.3333 < angle and angle < _G.math.pi*0.6666 or _G.math.pi*1.3333 < angle and angle < _G.math.pi*1.6666 then
						--local deltay = dragCursorTable[dragCursorIndex].dy * 0.00125 * (((objects.castleCameraData[deviceModel].right - objects.birdCameraData[deviceModel].left)/screenWidth) - worldScale) / worldScale
						local deltay = dragCursorTable[dragCursorIndex].dy * 0.00125
						zoomLevel = zoomLevel + deltay
					end
				end
			end
		end
	end
	

	
	if (keyReleased["LBUTTON"] or not keyHold["LBUTTON"]) and skipInput ~= true then
		--not holding LBUTTON
		if dragStarted then
			dragStarted = false
					
			if selectedBird ~= nil and not levelCompleted then
			
				if isChallengeMode() then
					if g_currentChallenge.type == "BIRD_FLOCK" then
						if g_currentChallengeProgress ~= nil then
							_G.table.remove(g_currentChallengeProgress.shotsQueue, 1)
						end					
					end
				end
			
				local distToRest = distance(draggingStartPosPhysics.x, draggingStartPosPhysics.y, cursorPhysics.x, cursorPhysics.y)
				local vecToRest = { x = draggingStartPosPhysics.x - cursorPhysics.x, y = draggingStartPosPhysics.y - cursorPhysics.y }
				
				if eagleBaitLaunched ~= true and vecToRest.x < 0 then
					settingsWrapper:incrementBackwardsBirdCount()
				end
			
				settingsWrapper:incrementBirdsShot()
				eventManager:notify({id = events.EID_BIRD_SHOT, birdsShooted = settingsWrapper:getBirdsShot(), backwardsBirdCount = settingsWrapper:getBackwardsBirdCount()})


				local distFactor = rubberBandLength / shootMaxLength
				if distFactor < 0 then distFactor = 0 end
				if distFactor > 1 then distFactor = 1 end

				local force = -defaultForce * physicsScale * selectedBird.mass
				setPosition(selectedBird.name, rubberBandPos.x, rubberBandPos.y)
				setVelocity(selectedBird.name, 0, 0)
				applyImpulse(selectedBird.name,
							vecToRest.x / distToRest * force * distFactor,
							vecToRest.y / distToRest * force * distFactor,
							selectedBird.x,
							selectedBird.y)
				--setAngularVelocity(selectedBird.name, 0)
				cameraTargetObject = selectedBird
				flyingBird = selectedBird
			

				-- Reset timer [1.5.4]
				extraTutorialTimer = 0
				
				--print("keyReleased[LBUTTON] && dragging: cameraFunction = doItAllCamera\n")					
				cameraFunction = doItAllCamera
				
				-- set target camera based on shooting direction
				if vecToRest.x > 0 then
					cameraAnimationSliderTarget = 1
				else
					cameraAnimationSliderTarget = 0
				end

				animationScreen.x = screen.x
				animationScreen.y = screen.y
				animationWorldScale = worldScale
				animationWorldScale2 = worldScale
				
				selectedBird.shot = true
				selectedBird.hasCollided = false
				birdSpecialtyAvailable = true
				allowResetToBirdCamera = true
				--print("Can reset to bird camera\n")
				allowTrajectoryClearing = true
				hasMovingObjectsAboveTolerance = true
				birdSelected = false
				birdReady = false
				birdFired = true
				showTapIcon = false
				birdsShot = birdsShot + 1
				cameraResetTimer = 0
				showTapTimer = 0
				
				if not isChallengeMode() then
					nextBirdTimer = 1
				else
					--challenge birds puff directly to the slingshot, so put in a longer delay to prevent
					--the launched bird from hitting the old bird
					nextBirdTimer = 2
				end
				currentBirdName = nil
				
				--start force end timer if last bird was fired
				if birdsShot == birdCount then
					lastScoreTime = time
					oldScore = score
				end

				--print(currentFrame .. " Bird shot\n")
				
				otherBirds = {}
				birdTrajectory =  { {}, {}, {} }
				
				flyingBird.sprite = getObjectDefinition(flyingBird.name).spriteFlying
				setSprite(flyingBird.name, flyingBird.sprite)

				if getObjectDefinition(selectedBird.name).launchSound ~= nil then
					_G.res.playAudio(getAudioName("bird_shot"), 1, false)
					_G.res.playAudio(getObjectDefinition(selectedBird.name).launchSound, 1, false)
				end
					
				selectedBird = nil
				
				--moved trajectory clearing here so that trajectory is always started when new bird is shot
				startNewTrajectory()
				
				--check if hatcherybird and set a custom bird trail
				if (flyingBird and flyingBird.hatcheryBird) then
					flyingBird.hatcheryBird:birdLaunched(flyingBird)
					local spr1,spr2,spr3,spr4 = flyingBird.hatcheryBird:getTrajectorySprites()
					setCustomTrajectorySprites(spr1,spr2,spr3,spr4)
				end
				
			else
				local i = 1
				local dxSum = 0
				local dtSum = 0
				local speed = 0
				while i <= #dragCursorTable do
					dtSum = dtSum + dragCursorTable[i].dt
					dxSum = dxSum + dragCursorTable[i].dx
					--print("SEvent: dx:" .. dragCursorTable[i].dx .. " dt:" .. dragCursorTable[i].dt .. "\n")
					i = i + 1
				end
				speed = dxSum / dtSum
				
				dragCursorTable = {}

				if touchcount == 1 and distance(draggingStartPosScreen.x, draggingStartPosScreen.y, cursor.x, cursor.y) > screenWidth * 0.1 or _G.math.abs(speed) > 200 then
					sweepSpeed = speed
					if _G.math.abs(sweepSpeed) > 0 then
						--print("SweepSpeed: " .. sweepSpeed .. "\n")
						if _G.math.abs(draggingStartPosScreen.x - cursor.x) > _G.math.abs(draggingStartPosScreen.y - cursor.y) then
							if draggingStartPosScreen.x - cursor.x > 0 then
								leftSweep = true
							else
								rightSweep = true
							end
						end
						
						if _G.math.abs(sweepSpeed) < 200 then
							--take sign and multiply by 100
							sweepSpeed = sweepSpeed/_G.math.abs(sweepSpeed) * 200
						end
						if _G.math.abs(sweepSpeed) > 5000 then
							sweepSpeed = sweepSpeed/_G.math.abs(sweepSpeed) * 5000
						end
					end
				else
					sweepSpeed = 0
				end
			end
	
			if leftSweep == true and sweepSpeed < 0 then
				--print("leftSweep: cameraFunction = doItAllCamera\n")
				cameraFunction = doItAllCamera
				cameraAnimationSliderTarget = 1
				if cameraAnimationSlider < 0 then
					cameraAnimationSlider = 0
				end
				doubleClickTimer = 0
			end
			if rightSweep == true and sweepSpeed > 0 then
				animationScreen.x = screen.x
				animationScreen.y = screen.y
				animationWorldScale = worldScale
				--print("rightSweep: cameraFunction = doItAllCamera\n")	
				cameraFunction = doItAllCamera
				cameraAnimationSliderTarget = 0
				if cameraAnimationSlider > 1 then
					cameraAnimationSlider = 1
				end
				allowResetToBirdCamera = false
				cameraTargetObject = nil
				--print(currentFrame .. " Right sweep: camera target object set to nil\n")
				--flyingBird = nil  -- this was commented as a bugfix to boomerang bird beak not bruising after camera sweep
				doubleClickTimer = 0
				showTapIcon = false
				showTapTimer = 0
			end

			if tapStarted then
				if vLength(cursor.x - tapPosition.x, cursor.y - tapPosition.y) < tapRadius then
					tapCount = tapCount + 1
					tapTimer = 0
				end
			end	
		end
	end

	if cheatsEnabled == true then
		if keyPressed["LBUTTON"] then
			if quadClickTimer > 0 and cursor.x > screenWidth - 60 and cursor.y > screenHeight - 60 then
				quadClickCounter = quadClickCounter + 1
				quadClickTimer = 0.5
				if quadClickCounter >= 4 then
					quadClick = true
				end
			elseif quadClickTimer > 0 and cursor.x < 160 and cursor.y > screenHeight - 60 then
				print("CLICK\n")
				quadClickCounter = quadClickCounter + 1
				quadClickTimer = 0.5
				if quadClickCounter >= 4 then
					--quadClick = true
					print(" THREE STARS UNLOCKED \n")
					getAllThreeStars()
				end
			else
				quadClick = false
				quadClickTimer = 0.5
				quadClickCounter = 1
			end
		end
	end
	
	
	
	
	
	if allowResetToBirdCamera == true and
	   hasMovingObjectsAboveTolerance == false and
	   hasMovingObjects == false and
	   levelCompleted == false and
	   birdSpecialtyAvailable == false and
	   (not isChallengeMode() or #g_currentChallengeProgress.shotsQueue > 0) then
		if cameraResetTimer <= 0 then
			cameraResetTimer = 0.5
		end
		
		cameraResetTimer = cameraResetTimer - dt

		if cameraResetTimer <= 0 then
			--print("Moving to start position. Camera target object set to nil.\n")
			--print(currentFrame .. " Automatic camera reset: camera target object set to nil\n")
			returnToBirdCamera()
		end

	end	

	
	if showTapTimer <= 0 and cameraAnimationSliderTarget == 1 and birdSpecialtyAvailable == false and cameraTargetObject == nil then
		showTapTimer = 0.5
	end
	
	if cameraAnimationSliderTarget == 0 then
		showTapTimer = 0
		showTapIcon = false
	end
	
	if showTapTimer > 0 then
		showTapTimer = showTapTimer - dt
		if showTapTimer <= 0 then
			showTapIcon = true
		end
	end	
	
	-- fill the next bird
		
	if not isChallengeMode() then
		animateBirdToSlingShot(dt)
	else
		if birdsShot == 0 then
			animateBirdToSlingShot(dt)
		else
			animateChallengeBirdToSlingshot(dt)		
		end		
	end

	
	-- trajectory
	local recordTrajectory = false
	if flyingBird ~= nil then
		if flyingBird.recordTrajectory ~= false then
			recordTrajectory = true
			local lx, ly = physicsToWorldTransform(flyingBird.x, flyingBird.y)
			local bt = birdTrajectory[1]
			if #bt < 1 or vLengthsq(lx - bt[#bt].x, ly - bt[#bt].y) > 400 then
				_G.table.insert(bt, { x = lx, y = ly })
				addToTrajectory(1, lx, ly)
			end
		end
		
		-- space invader achievement (not allowed for the bomb bird)
		if eagleBaitLaunched ~= true and flyingBird.definition ~= "BasicBird2" then
			if previousSpaceInvaderY == nil then
				previousSpaceInvaderY = 0
			end
			
			if previousSpaceInvaderY > -125 and flyingBird.y <= -125 then
				eventManager:notify({id = events.EID_SPACE_INVANDER})
			end
			
			previousSpaceInvaderY = flyingBird.y
		end
	end
	
	if otherBirds ~= nil then
		for i = 1, 2 do
			local obj = objects.world[otherBirds[i]]
			if obj ~= nil then
				if obj.recordTrajectory ~= false then
					recordTrajectory = true
					local lx, ly = physicsToWorldTransform(obj.x, obj.y)
					local bt = birdTrajectory[i+1] 
					if #bt < 1 or vLengthsq(lx - bt[#bt].x, ly - bt[#bt].y) > 400 then
						_G.table.insert(bt, { x = lx, y = ly })
						addToTrajectory(i+1, lx, ly)
					end
				end
			end
		end
	end
	
	
	
	if birdReady == true then
		--print("Bird is ready!\n")
		if currentBirdName ~= nil then
			--print("Setting position and velocity. " .. currentBirdName .. "\n")
			setPosition(currentBirdName, rubberBandPos.x, rubberBandPos.y)
			setVelocity(currentBirdName, 0, 0)
		end
	end

	-- we have fired a bird from the slingshot
	if birdFired then
	
		local rubberBandDtLeft = dt
		local rubberBandDt
		
		-- Integrate rubber band position multiple times if time step is too large
		while rubberBandDtLeft > 0 do
		
			if rubberBandDtLeft < 0.05 then
				rubberBandDt = rubberBandDtLeft
			else
				rubberBandDt = 0.05
			end
			
			rubberBandDtLeft = rubberBandDtLeft - rubberBandDt
		
			local distToRest = distance(levelStartPosition.x, levelStartPosition.y, rubberBandPos.x, rubberBandPos.y)
			local vecToRest = { x = levelStartPosition.x - rubberBandPos.x, y = levelStartPosition.y - rubberBandPos.y }

			rubberBandAngle = _G.math.atan2(vecToRest.y, vecToRest.x)
			rubberBandLength = distToRest

			rubberBandSpeed = rubberBandSpeed + dampedSpring(springConstant, springDampening, distToRest, rubberBandSpeed) * 0.05 * physicsScale
			if distToRest > 0 then
				rubberBandPos.x = rubberBandPos.x + (vecToRest.x / distToRest) * rubberBandSpeed * rubberBandDt
				rubberBandPos.y = rubberBandPos.y + (vecToRest.y / distToRest) * rubberBandSpeed * rubberBandDt
				rubberBandLength = distance(levelStartPosition.x, levelStartPosition.y, rubberBandPos.x, rubberBandPos.y)
			end
		end
	end
	
	-- explode the granade
	for i = #flyingGrenades, 1, -1 do
		if flyingGrenades[i].explode == true then
			local flyingGrenade = flyingGrenades[i].name
			local grenadeDef = getObjectDefinition(flyingGrenade)
			addParticles(flyingGrenade, grenadeDef.particles, 6, true, false)
			makeExplosion(objects.world[flyingGrenade], grenadeDef, getAudioName("special_explosion"))
			addParticles(flyingGrenade, "eggShells", 5, true, false)
			if cameraTargetObject ~= nil and cameraTargetObject.name == flyingGrenades[i].name then
				cameraTargetObject = nil
			end
			removeObject(flyingGrenade)
			objects.world[flyingGrenade] = nil
			_G.table.remove(flyingGrenades, i)
		end
	end

	if eagleTimer ~= nil then
		eagleTimer = eagleTimer - dt
	end

	if eagleDarkness ~= nil then
		eagleDarkness = eagleDarkness - dt * 0.4
		eagleDarkness = _G.math.max(_G.math.min(eagleDarkness, 0.5), 0)
	end
	
	
	for k, v in _G.pairs(objects.world) do
		
		if isPhysicsEnabled() then
			-- apply force (balloons etc.)
			local bDef = getObjectDefinition(v.name)			
			if bDef.forceX ~= nil and bDef.forceY ~= nil then			
				applyForce(v.name, bDef.forceX * v.mass, bDef.forceY * v.mass, v.x, v.y)
			elseif v.forceX ~= nil and v.forceY ~= nil then
				applyForce(v.name, v.forceX * v.mass, v.forceY * v.mass, v.x, v.y)
			end
		end
		
		
	-- remove birds if criteria is met
		if v.bombTimer ~= nil then
			v.bombTimer = v.bombTimer - dt
			if v.bombTimer < 0 then
				makeExplosion(v, getObjectDefinition(k), getAudioName("special_explosion"))
				removeBird(v)
			elseif v.bombTimer < 1 then
				v.damageSprite = "BIRD_GREY_3"
				setSprite(v.name, v.damageSprite)
			elseif v.bombTimer < 2 then
				v.damageSprite = "BIRD_GREY_2"			
				setSprite(v.name, v.damageSprite)			
			end
		elseif v.globeTimer ~= nil then
			v.globeTimer = v.globeTimer - dt
			if v.globeTimer < 0 then
                if not flyingBird.hasCollided then 
                    local lx, ly = physicsToWorldTransform(flyingBird.x, flyingBird.y) 
                    addPuffToTrajectory(1, lx, ly)
                end
--                sounds.playAudio(sounds.getAudioName(blockTable.blocks[flyingBird.definition].specialSound), 5, false, 1)
				_G.res.playAudio(getAudioName(blockTable.blocks[flyingBird.definition].specialSound), 1, false)
                local name = "a" .. flyingBird.name .. "a"
				
				local def = blockTable.blocks.GlobeBirdBig
				createCircle(name, def.sprite, flyingBird.x, flyingBird.y, def.radius, def.density, def.friction, def.restitution, flyingBird.controllable, flyingBird.z_order)
				
				objects.world[name].definition = "GlobeBirdBig"
				objects.world[name].controllable = def.controllable
				objects.world[name].strength = def.strength
				objects.world[name].defence = def.defence
				objects.world[name].material = def.material
				objects.world[name].levelGoal = def.levelGoal
				objects.world[name].damageFactors = def.damageFactors
				
				local xp, yp = _G.res.getSpritePivot("", def.sprite)
				objects.world[name].spritePivotX = xp
				objects.world[name].spritePivotY = yp
				objects.world[name].damageSprite = def.damageSprite
				objects.world[name].useLegacyCollisionPath = def.useLegacyCollisionPath
				objects.world[name].shot = true
                objects.world[name].finalGlobe = true
				objects.world[name].xVel = flyingBird.xVel
				objects.world[name].yVel = flyingBird.yVel
				objects.world[name].hasCollided = flyingBird.hasCollided
				setRotation(name, flyingBird.angle)
				setVelocity(name, flyingBird.xVel, flyingBird.yVel)
				birds[name] = objects.world[name]

				removeBird(flyingBird,true)
				flyingBird = objects.world[name] 
				objects.world[flyingBird.name].sprite = def.sprite
				setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				flyingBird.sprite = def.sprite
				cameraTargetObject = flyingBird
			elseif v.globeTimer <= dt then
				local name = flyingBird.name .. "a"
				-- makeExplosion(flyingBird, getObjectDefinition(k), sounds.getAudioName(blockTable.blocks[flyingBird.definition].specialSound))
				makeExplosion(flyingBird, getObjectDefinition(k), nil)
				
				local def = blockTable.blocks.GlobeBirdBig
				createCircle(name, def.sprite, flyingBird.x, flyingBird.y, def.radius/2, def.density, def.friction, def.restitution, flyingBird.controllable, flyingBird.z_order)
				
				objects.world[name].definition = "GlobeBirdBig"
				objects.world[name].controllable = def.controllable
				objects.world[name].strength = def.strength
				objects.world[name].defence = def.defence
				objects.world[name].material = def.material
				objects.world[name].levelGoal = def.levelGoal
				objects.world[name].damageFactors = def.damageFactors
				
				local xp, yp = _G.res.getSpritePivot("", def.sprite)
				objects.world[name].spritePivotX = xp
				objects.world[name].spritePivotY = yp
				objects.world[name].damageSprite = def.damageSprite
				objects.world[name].useLegacyCollisionPath = def.useLegacyCollisionPath
				objects.world[name].shot = true
				objects.world[name].xVel = flyingBird.xVel
				objects.world[name].yVel = flyingBird.yVel
				objects.world[name].hasCollided = flyingBird.hasCollided
				objects.world[name].globeTimer = flyingBird.globeTimer
				setRotation(name, flyingBird.angle)
				setVelocity(name, flyingBird.xVel, flyingBird.yVel)
                setObjectParameter(name,5,0.5)
                setObjectParameter(name,6,1)
				birds[name] = objects.world[name]
										
				removeBird(flyingBird,true)
				flyingBird = objects.world[name] 
				objects.world[flyingBird.name].sprite = def.sprite
				setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				flyingBird.sprite = def.sprite
				cameraTargetObject = flyingBird
			end
        elseif v.isGlobeDeath == true then
            if v.deathTimer > 0 then
                v.deathTimer = v.deathTimer - dt
                v.directionChangeTimer = v.directionChangeTimer - dt
                if v.directionChangeTimer <= 0 then
                    v.directionChangeTimer = 0.05
                    v.xVelChange = _G.math.random(-50,50)
                    v.yVelChange = _G.math.random(-50,50)
                end
                v.scale = v.deathTimer/v.deathTimerFull
                v.updateCount = v.updateCount + 1
                setObjectParameter(v.name,5,v.scale)
                
                if v.updateCount % 3 == 0 then
                    local name = v.name .. "a"
					
                    local def = blockTable.blocks.GlobeBirdBig
                    --local newX = v.x + v.xVel * dt
                    --local newY = _G.math.min(0, v.y + v.yVel * dt)
                    createCircle(name, def.sprite, v.x, v.y, def.radius * v.scale, 0.000001, 0, def.restitution, v.controllable, v.z_order)
                    
                    objects.world[name].definition = "GlobeBirdBig"
                    objects.world[name].controllable = def.controllable
                    objects.world[name].strength = def.strength
                    objects.world[name].defence = def.defence
                    objects.world[name].material = def.material
                    objects.world[name].levelGoal = def.levelGoal
                    objects.world[name].damageFactors = def.damageFactors
                    
                    local xp, yp = _G.res.getSpritePivot("", def.sprite)
                    objects.world[name].spritePivotX = xp
                    objects.world[name].spritePivotY = yp
                    objects.world[name].damageSprite = def.damageSprite
                    objects.world[name].useLegacyCollisionPath = def.useLegacyCollisionPath
                    objects.world[name].shot = true
                    objects.world[name].isGlobeDeath = true
                    objects.world[name].updateCount = v.updateCount
                    objects.world[name].deathTimerFull = v.deathTimerFull
                    objects.world[name].deathTimer = v.deathTimer
                    objects.world[name].scale = v.scale
                    objects.world[name].directionChangeTimer = v.directionChangeTimer
                    objects.world[name].xVelChange = v.xVelChange
                    objects.world[name].yVelChange = v.yVelChange
                    objects.world[name].xVel = v.xVel + v.xVelChange
                    objects.world[name].yVel = v.yVel + v.yVelChange
                    setRotation(name, _G.math.atan2(-(objects.world[name].xVel), objects.world[name].yVel) - _G.math.pi/2)
                    setVelocity(name, objects.world[name].xVel, objects.world[name].yVel)
                    setObjectParameter(name,5,v.scale)
                    setObjectParameter(name,6,1)
                    birds[name] = objects.world[name]
                    
                    removeBird(v, true, 1)
                end
            else
                allowResetToBirdCamera = true
                removeBird(v)
            end
        elseif v.pufferLifeTimeTimer ~= nil then    
            v.pufferLifeTimeTimer = v.pufferLifeTimeTimer - dt
            if v.pufferLifeTimeTimer < 0 then
                removeBird(v)
            end
        elseif v.hasCollided and v.definition == "GlobeBirdBig" then
            v.pufferLifeTimeTimer = 4  			
		elseif v.isEagleBait == true and eagleTimer ~= nil then
			if eagleTimer < 6.2 and eagleMoving == true then
				birdSpecialtyAvailable = false
				eagleMoving = false
				createMightyEagle(v.x, v.y)
				--print("Mighty Eagle coming!")
			end
		elseif v.isMightyEagle then
			--local eagleHeight = objects.world["ground"].y - v.y
			eagleHeight = levelStartPosition.y - v.y
			if objects.world["ground"].y - v.y < 0 then
				v.lowerThanGround = true
			end
			eagleHeight = _G.math.max(_G.math.min(eagleHeight, 50), 0)
			--print("eagleHeight: " .. eagleHeight .. "\n")
			local speed = 10000
			v.particleTimer = v.particleTimer + dt
			local particleAmount = _G.math.floor(v.particleTimer / v.particleTimerLimit)
			if particleAmount > 0 then
				v.particleTimer = _G.math.fmod(v.particleTimer, v.particleTimerLimit)
				addParticles(v.name, "mightyEagleParticles", particleAmount, false,false)
			end	
			if v.hitGround ~= true then -- and v.x < v.targetX then
				--cameraShake = ((50 - eagleHeight) * (50 - eagleHeight) * (50 - eagleHeight) * (50 - eagleHeight)) / 209000
				--v.wantedVelX, v.wantedVelY = vNormalize(v.targetX - v.x, v.targetY - v.y)
				local angle = _G.math.atan2(v.initVelY, v.initVelX)
				setVelocity(v.name, v.initVelX * speed, v.initVelY * speed)
				setRotation(v.name, angle)
			elseif v.hitGround == true then
				setVelocity(v.name, v.initVelX * speed, -v.initVelY * speed)
				setAngularVelocity(v.name, _G.math.pi * 4)
			end
		else
			if v.controllable and v.shot == true then
				
				if v.isReadyForRemoveTimer ~= nil and vLengthsq(v.xVel, v.yVel) < 0.0025 then
					v.isReadyForRemoveTimer = v.isReadyForRemoveTimer - dt
				else
					v.isReadyForRemoveTimer = 1.0
				end
				
				if v.isReadyForRemoveTimer < 0 and cameraTargetObject == nil then
					--print(currentFrame .. " Removing stopped bird.\n")
					removeBird(v)
					v = nil
				end
			end
		end
		
		if v and v.hatcheryBird then
			v.hatcheryBird:update(dt, time)
		end
		
		-- remove all frozen objects
		if v ~= nil and v.frozen then
			
			if v.controllable then
				if v.isEagleBait == true then
					eagleX, eagleY = v.x, v.y
					--print("baitSardine frozen!\N")
					if eagleTimer == nil then
						eagleTimer = 8.7
						eagleMoving = true
					end
				end
				if v.boomerangActive ~= true then
					removeBird(v)
				end
				if v.isMightyEagle and v.hitGround ~= true then
					cameraShake = 100
					_G.res.playAudio("mighty_eagle_thump", 1, false)
					for k2, v2 in _G.pairs(objects.world) do
						if v2 ~= nil then
							if v2.strength ~= nil and v2.levelGoal then
								local force = -v2.mass * 15
								applyImpulse( v2.name,
											0,
											force,
											v2.x,
											v2.y )
								v2.strength = 0.00001
								v2.defence = 0
							end
						end
					end
					if objects.joints ~= nil then
						for k, v in _G.pairs(objects.joints) do
							destroyJoint(v.name)
						end
					end
					eagleTimer = 4
				end
			else
				removeObject(k)
				objects.world[k] = nil
				levelGoals[k] = nil
				
				--[[
				if isEagleEnabled() == true and checkLevelGoalsDestroyed() == true and isEagleUnavailableForShot() ~= true then
					inGameEagleButtonScale = 1
				end]]
				
				if checkLevelGoalsDestroyed() then
					eventManager:notify({id = events.EID_LEVEL_GOALS_CLEARED})				
				end
			end
			v = nil
		end
	end
	
	if eagleTimer ~= nil then
		--print("eagleTimer: " .. eagleTimer .. "\n")
		if eagleTimer < 6.2 and eagleMoving == true and eagleX ~= nil and eagleY ~= nil then
			birdSpecialtyAvailable = false
			eagleMoving = false
			createMightyEagle(eagleX, eagleY)
		elseif eagleTimer < 7.7 and eagleSoundPlayed ~= true then
			_G.res.playAudio("mighty_eagle_yell", 1, false)
			_G.res.playAudio("mighty_eagle_fly", 1, false)
			eagleSoundPlayed = true
		end
		if cameraShake ~= nil and cameraShake > 0 then
			--cameraShake = _G.math.max(cameraShake - 200 * dt, 0)
			cameraShake = _G.math.max(cameraShake - cameraShake*dt*2.2, 0)
		end
		if eagleTimer < 0 then
			for k, v in _G.pairs(objects.world) do
				if v.strength ~= nil and v.levelGoal then
					v.strength = 0
					deadBlocks[k] = v
				end
			end
		end
		
		-- Delete all joints when eagle hits ground, joints cannot be destroyed from BirdCollision
		if destroyJoints then
			if objects.joints ~= nil then
				for k, v in _G.pairs(objects.joints) do
					destroyJoint(v.name)
				end
			end
			destroyJoints = nil
		end
	end
	
	-- update camera
	if cameraFunction ~= nil then
		cameraFunction(dt)
	end
	
	for k,v in _G.pairs(birds) do
		bird = v
		if bird.shot == true and bird.definition == "BoomerangBird" then
			if v.boomerangActive == true then
				
				if bird.prevAngle ~= nil then
					if bird.prevAngle < -1 and bird.angle >= -1 then
						
						if bird.x < levelLeftEdge then
							vol = _G.math.max( 1 - ((levelLeftEdge - bird.x) / 100.0),  0.0)
						elseif bird.x > levelRightEdge then
							vol = _G.math.max( 1 - ((bird.x - levelRightEdge) / 100.0),  0.0)
						else
							vol = 1.0
						end
						_G.res.playAudio("boomerang_swish", vol, false)
					end
				end
				bird.prevAngle = bird.angle
				
				if bird.xVel >= bird.boomerangMinXVel and bird.xVel <= bird.boomerangMaxXVel then
					applyForce( bird.name,
										bird.boomerangXForce,
										0,
										bird.x,
										bird.y )
				end
				
				if bird.yVel > 5 then
					applyForce( bird.name,
										0,
										bird.boomerangYForce,
										bird.x,
										bird.y )
				end
				
				bird.angularVelocity = bird.angularVelocity + dt * 20
				if bird.angularVelocity > 20 then
					bird.angularVelocity = 20
				end
				
				setAngularVelocity(bird.name, bird.angularVelocity)
			elseif bird == flyingBird and birdSpecialtyAvailable then
				applyForce( bird.name,
									0,
									blockTable.blocks[bird.definition].flyVerticalForce,
									bird.x,
									bird.y )
				--setAngularVelocity(bird.name, 0)
				if bird.angularVelocity == nil then
					bird.angularVelocity = 0
				end
				
				bird.angularVelocity = bird.angularVelocity + dt * 15
				if bird.angularVelocity > 6.28 then
					bird.angularVelocity = 6.28
				end
				
				setAngularVelocity(bird.name, bird.angularVelocity)
			end
		elseif bird.shot == true and bird.definition == "BaitSardine" then
			if bird.angularVelocity == nil then
				bird.angularVelocity = 0
			end
				
			if bird.hasCollided ~= true then
				bird.angularVelocity = bird.angularVelocity + dt * 10
				if bird.angularVelocity > 20 then
					bird.angularVelocity = 20
				end
				setAngularVelocity(bird.name, bird.angularVelocity)
			end
		end
	end
	
	--updateParticles(dt)
	for k, v in _G.pairs(objects.joints) do
		if v.backAndForth then
			checkJointLimits(v.name)
		end
	end
	updateCharacterAnimations(dt)
	
	updateFloatingScores(dt)

	updateScore(dt)
	
	-- store current values to old for the next frame
	oldCursor.x = cursor.x
	oldCursor.y = cursor.y
	
	-- Draw game
	drawGame()
	--[[
	if currentMenuPage == pausePage and elementAnimations["ingamePausePageScroll"].state ~= "HIDDEN" and (birdTutorialPopups == nil or #birdTutorialPopups == 0) then
		pausePage.offsetX = elementAnimations["ingamePausePageScroll"].percentage / 100 * pauseBGw - pauseBGw
		pausePage.backgroundOverlay.shade = elementAnimations["ingamePausePageScroll"].percentage / 100 * 0.65
		drawMenuPage(pausePage)
	end]]
	
	if tempWorldScale ~= nil then
		print("tempWorldScale = nil\n")
		tempWorldScale = nil
	end

	
	skipInput = false
end

function updateBirdFlockChallenge(dt, time)
	g_challengeHudTimer = g_challengeHudTimer + dt
end

function closeMightyEaglePurchasePage()
	setGameMode(updateMenu)
	popupPage = nil
	setActiveMenuPage(levelFailed)
	setPhysicsEnabled(false)
	drawGame()
end

function closeBetaDisclaimerPage()
	setGameMode(updateMenu)
	popupPage = nil
	setActiveMenuPage(mainMenu)
	drawMenu()
end

function cancelMightyEaglePurchase()
end

function backToGameFromPopup()
		print("going to pause menu\n")
		popupPage = nil
		showPauseMenu()
		setPhysicsEnabled(false)
		--pausePage.offsetX = 0
		--pausePage.backgroundOverlay.shade = 0.65
		--setAnimationState("ingamePausePageScroll", "VISIBLE")
		
end


function goToMightyEagleDemoPageFromGame()
	--mightyEagleDemoPage.enablePhysicsWhenDone = isPhysicsEnabled()
	
	settingsWrapper:setMightyEagleUpsellPageViewed()	
	
	if(useShop == true) then
		dummyPopupPage.rootContainer:setEnterPageIndex(1)
		dummyPopupPage.rootContainer:onEntry()
		dummyPopupPage.rootContainer:layout()
		setActivePopupPage(dummyPopupPage, nil)
		setPhysicsEnabled(false)
	else
		--setActivePopupPage(mightyEagleDemoPage, nil, "ingame")
		setPhysicsEnabled(false)
		currentGameMode = function() end
		--game is drawn once here because game won't get drawn anymore on this frame otherwise
		--on next frame it will be drawn by ingame eagle page
		drawGame()
		setGameOn(false)
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = IngameEaglePage:new() })
	end 
	
	--[[
	if deviceModel == "iphone4" then
		changeResolution = true
		wantedResolution = "HALF"
		print("change resolution to half\n")
	end
	]]--
end

function goToMightyEaglePaymentPage()
	-- TODO: Unify iOS and other platform shop UIs
	if(useShop ~= true) then
		newPopupPage =  mightyEaglePaymentPage	
	end
	
	if isEagleEnabled() ~= true then
		purchaseMightyEagle()
		if g_eagleClickedFrom == "MAIN_MENU" then
			menuManager:changeRoot(MainMenuEaglePurchasePage:new())
		elseif g_eagleClickedFrom == "INGAME" then
			menuManager:changeRoot(IngameEaglePurchasePage:new())
		elseif g_eagleClickedFrom == "LEVEL_FAILED" then
			eventManager:notify({id = events.EID_PUSH_FRAME, target = EaglePurchasePage:new({ return_screen = menuManager:popFrame() })})
		end
	end
	
	--[ 1.5.4
	if(mightyEagleDemoPage ~= nil and mightyEagleDemoPage.info ~= nil) then
		print("Mighty Eagle purchase button clicked, from = "..(mightyEagleDemoPage.info).."\n")
		logFlurryEventWithParam("ME: purchase clicked", "From", mightyEagleDemoPage.info)		
	end
	-- ]
	--[[
	if deviceModel == "iphone4" then
		changeResolution = true
		wantedResolution = "HALF"
		print("change resolution to half\n")
	end
	]]--
end


function resetMightyEagleFeature()
	settingsWrapper:resetMightyEagle()
	settingsWrapper:resetEaglesUsedIn()
	
	setActiveMenuPage(mainMenu)
	setGameMode(updateMenu)
	drawMenu()
	highscores = {}
end

function createMightyEagle(meX, meY)
	levelCompleteTimer = 0
	levelFailedTimer = -200
	eagleX, eagleY = nil, nil
	--print("createMightyEagle: " .. meX .. ", " .. meY)
			
	local newName = "MightyEagle_a"
	local blockDef = blockTable.blocks["MightyEagleBird"]
	--print("eagleX: " .. levelLimitMinX .. ", eagleY: " .. meY - (meX - levelLimitMinX) / 2  .. "\n")
	createCircle(newName, blockDef.sprite, levelLimitMinX + 1, meY - (meX - levelLimitMinX+1) / 2, blockDef.radius, blockDef.density, blockDef.friction, blockDef.restitution, true, blockDef.z_order)
	objects.world[newName].targetX = meX
	objects.world[newName].targetY = meY
	-- eagle init velocity
	objects.world[newName].initVelX, objects.world[newName].initVelY = vNormalize(objects.world[newName].targetX - objects.world[newName].x, objects.world[newName].targetY - objects.world[newName].y)
	objects.world[newName].definition = "MightyEagleBird"
	objects.world[newName].controllable = blockDef.controllable
	objects.world[newName].strength = blockDef.strength
	objects.world[newName].defence = blockDef.defence
	objects.world[newName].material = blockDef.material
	objects.world[newName].damageFactors = blockDef.damageFactors
	objects.world[newName].useLegacyCollisionPath = blockDef.useLegacyCollisionPath
	objects.world[newName].levelGoal = false
	local xp, yp = _G.res.getSpritePivot("INGAME_BIRDS_2",blockDef.sprite)
	objects.world[newName].spritePivotX = xp
	objects.world[newName].spritePivotY = yp
	objects.world[newName].damageSprite = blockDef.sprite
	objects.world[newName].xVel = 0
	objects.world[newName].yVel = 0
	setSprite(newName, objects.world[newName].damageSprite)
	setRotation(newName, 0)
	setVelocity(newName, objects.world[newName].xVel, objects.world[newName].yVel)
	objects.world[newName].animTimer = 9999
	objects.world[newName].jumpTimer = 9999
	objects.world[newName].animOn = false
	objects.world[newName].isMightyEagle = true
	objects.world[newName].shot = true
	objects.world[newName].particleTimer = 0 
	objects.world[newName].particleTimerLimit = 0.025
	objects.world[newName].recordTrajectory = false
	birds[newName] = objects.world[newName]
	--_G.res.playAudio(getAudioName(blockTable.blocks[objects.world[newName].definition].specialSound), 1, false)
	birdsCounter = birdsCounter + 1
	currentZoomedScale = objects.castleCameraData[deviceModel].sx
	--cameraAnimationSliderTarget = 1
	flyingBird = objects.world[newName]
	setMaxTranslation(5)
	_G.particles.setHardLimit(250)
	_G.particles.setSoftLimit(0, 0.2)
end

function removeBlocks()
	if objects.world == nil then
		return
	end

	for k, v in _G.pairs(deadBlocks) do
		if v ~= nil and v.strength ~= nil then
			local bDef = getObjectDefinition(k)
			local scoreToAdd = blockDestroyedScoreIncrement
			
			if bDef.destroyedScoreInc ~= nil then
				scoreToAdd = blockTable.blocks[v.definition].destroyedScoreInc
			end
			
			if v.levelGoal then
				scoreToAdd = pigletteDestroyedScoreIncrement
				_G.res.playAudio(getAudioName("piglette_damage"), 1, false)
				_G.table.insert(floatingScores, { x = v.x, y = v.y, sprite = "5K_GREEN", score = scoreToAdd, time = 0, lifetime = 0.9, maxScale = floatingScoreScaling * 1, xs = 0  } )
				if isEagleEnabled() == true and startedFromEditor ~= true then
					-- check if only one piglette is still alive 
					local anyPiglettesAlive = 0
					for k2, v2 in _G.pairs(levelGoals) do
						if v2.levelGoal then
							anyPiglettesAlive = anyPiglettesAlive + 1
						end						
					end
					
					if anyPiglettesAlive == 1 then
						eventManager:notify({id = events.EID_LEVEL_GOALS_CLEARED})					
					end
					
					--[[
					if anyPiglettesAlive == 1 then
						--_G.res.playAudio(getAudioName("level_clear_military"), 1, false)
						if inGameEagleButtonVisible == true and isEagleUnavailableForShot() ~= true then
							inGameEagleButtonScale = 1
						end
					end]]
				end
			else
				if bDef.spriteScore ~= nil then
					_G.table.insert(floatingScores, { x = v.x, y = v.y, sprite = bDef.spriteScore, score = scoreToAdd, time = 0, lifetime = 0.9, maxScale = floatingScoreScaling * 1, xs = 0  } )
				else
					_G.table.insert(floatingScores, { x = v.x, y = v.y, text = "" .. scoreToAdd, score = scoreToAdd, time = 0, lifetime = 0.6, maxScale = floatingScoreScaling * (0.25 + scoreToAdd / 3000), xs = 0 } )
				end
			end
			scoreTable["blocks"].score = scoreTable["blocks"].score + scoreToAdd

			local bDef = getObjectDefinition(k)
			local particle = bDef.particles
			if particle == nil then
				particle = blockTable.materials[v.material].particles
			end

			local destroySound = blockTable.materials[v.material].destroyedSound
			local particleAmount = 12
			local batAmount = _G.math.random(12, 20)
			if particle == "smokeBuff" then
				particleAmount = 1
			elseif particle == "batBuff" then
				particleAmount = batAmount
			elseif particle == "flameBuff" then
				particleAmount = 1
			end
			if bDef.specialty == "BOMB" then
				makeExplosion(deadBlocks[k], bDef, getAudioName("tnt_explodes"))
			end

			if destroySound ~= nil then
				_G.res.playAudio(getAudioName(destroySound), 0.7, false, 3)
			end
			
			updateDestroyedBlocksValues(v)
			
			if eagleBaitLaunched ~= true then
				if currentLevelNumberInTheme == 2 and currentWorldNumber == 2 then
					if v.name == "ExtraBeachBall_1" then
						goldenEggAchieved("LevelGE_2")
					end
				end
				
				if currentLevelNumberInTheme == 14 and currentWorldNumber == 6 then
					if v.name == "StaticBalloon03_2" then
						goldenEggAchieved("LevelGE_6")
					end
				end
				
				if currentLevelNumberInTheme == 7 and currentWorldNumber == 4 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_5")
					end
				end
				
				if currentLevelNumberInTheme == 19 and currentWorldNumber == 5 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_3")
					end
				end
				
				if currentLevelNumberInTheme == 15 and currentWorldNumber == 8 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_8")
					end
				end
				
				if currentLevelNumberInTheme == 14 and currentWorldNumber == 9 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_9")
					end
				end
				
				if currentLevelNumberInTheme == 3 and currentWorldNumber == 10 then
					if v.name == "ExtraRubberDuck_1" then
						goldenEggAchieved("LevelGE_10")
					end
				end
				
				if currentLevelNumberInTheme == 15 and currentWorldNumber == 11 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_11")
					end
				end
				
				if currentLevelNumberInTheme == 12 and currentWorldNumber == 12 then
					if v.name == "ExtraHolyGrail_4" then
						goldenEggAchieved("LevelGE_16")
					end
				end
				
				if currentLevelNumberInTheme == 10 and currentWorldNumber == 13 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_17")
					end
				end
				
				if currentLevelNumberInTheme == 4 and currentWorldNumber == 14 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_18")
					end
				end
				
				if currentLevelNumberInTheme == 12 and currentWorldNumber == 13 then
					if v.name == "ExtraSuperBowl_2" then
						goldenEggAchieved("LevelGE_19")
					end
				end
			
				if currentLevelNumberInTheme == 12 and currentWorldNumber == 15 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_20")
					end
				end
				
				if currentLevelNumberInTheme == 9 and currentWorldNumber == 16 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_21")
					end
				end
				
				if currentLevelNumberInTheme == 12 and currentWorldNumber == 17 then
					if v.name == "ExtraTreasureChest_1" then
						goldenEggAchieved("LevelGE_23")
					end
				end
				
				if currentLevelNumberInTheme == 6 and currentWorldNumber == 18 then
					if v.name == "ExtraGoldenEgg_1" then
						goldenEggAchieved("LevelGE_24")
					end
				end
				
				if currentLevelNumberInTheme == 15 and currentWorldNumber == 18 then
					if v.name == "SPECIAL_CAKE_1_1" then
						if not settingsWrapper:isCakeCollected() then
							settingsWrapper:setCakeCollected()
							eventManager:notify({ id = events.EID_REWARD_POPUP, sprite = "GOLDEN_EGG_SPECIAL_CAKE", sound = "star_collect" })
						end
						eventManager:notify({ id = events.EID_CAKE_COLLECTED, })
					end
				end
			end

		
			addParticles(k, particle, particleAmount, false, false)
			
			--addParticles(k, particle, particleAmount, false, false)
			removeObject(k)
			levelGoals[k] = nil	
			objects.world[k] = nil
			deadBlocks[k] = nil
		end
	end
end

function updateDestroyedBlocksValues(v)
	if eagleBaitLaunched ~= true and (deviceModel == "iphone" or deviceModel == "ipad" or deviceModel == "iphone4") then
		if v.material ~= nil then
			if v.material == "wood" then
				settingsWrapper:setWoodBlocksDestroyed(settingsWrapper:getWoodBlocksDestroyed() + 1)
			elseif v.material == "light" then
				settingsWrapper:setIceBlocksDestroyed(settingsWrapper:getIceBlocksDestroyed() + 1)
			elseif v.material == "rock" then
				settingsWrapper:setRockBlocksDestroyed(settingsWrapper:getRockBlocksDestroyed() + 1)
			elseif v.material == "piglette" and not eagleBaitLaunched then
				settingsWrapper:incrementPigsDestroyed()
			elseif v.material == "amber" or v.material == "ruby" or v.material == "amethyst" and not eagleBaitLaunched then
				settingsWrapper:incrementJewelsDestroyed()
			elseif v.material == "stalaktite_tip" and not eagleBaitLaunched then
				settingsWrapper:incrementStalaktitesDestroyed()
			end
			totalBlocks = 0
			totalBlocks = totalBlocks + settingsWrapper:getWoodBlocksDestroyed()
			totalBlocks = totalBlocks + settingsWrapper:getIceBlocksDestroyed()
			totalBlocks = totalBlocks + settingsWrapper:getRockBlocksDestroyed()
		end
		
		local event = {id = events.EID_BLOCKS_DESTROYED,
			totalBlocks = totalBlocks or 0,
			stalaktitesDestroyed = settingsWrapper:getStalaktitesDestroyed(),
			jewelsDestroyed = settingsWrapper:getJewelsDestroyed(),
			pigsDestroyed = settingsWrapper:getPigsDestroyed(),
			rockBlocksDestroyed = settingsWrapper:getRockBlocksDestroyed(),
			iceBlocksDestroyed = settingsWrapper:getIceBlocksDestroyed(),
			woodBlocksDestroyed = settingsWrapper:getWoodBlocksDestroyed(),
		}
		eventManager:notify(event)
		
	end
	
	

end	

function updateScore(dt)
	score = 0
	for k, v in _G.pairs(scoreTable) do
		score = score + v.score
	end
end

----------------

function getItemByName(items, name)
	
	for i = 1, #items do
		if items[i].name == name then
			return items[i], i
		elseif items[i].children ~= nil then
			for j = 1, #items[i].children do
				if items[i].children[j].name == name then
					return items[i].children[j], i, j
				end
			end
		end
	end
	
end

function itemIndex(items, name)
	local item = getItemByName(items, name)
	return item
end

function itemNewIndex(items, name, value)
	local _, i, j = getItemByName(items, name)
	if j == nil then
		_G.rawset(items, i or name, value)
	else
		_G.rawset(items[i].children, j, value)
	end
end

function animateBirdToSlingShot(dt)

	local testIndex = currentBirdIndex + 1
	if nextBirdTimer > 0 then
		nextBirdTimer = nextBirdTimer - dt
		if nextBirdTimer <= 0 then
			if getNextBird(testIndex) ~= nil then
				if birdFired then
					birdFired = false
					fillInNextBird = true
					selectedBird = nil
				end
			else
				allowResetToBirdCamera = false
				--print("Can't reset to bird camera\n")
			end
		end
	end
	
	if fillInNextBird == true then

		if birdToSlingshotBirdName == nil then
			--print ("birdToSlingshotBirdName = nil\n")
			birdToSlingshotAnimationTimer = 0
			birdToSlingshotBirdName = getNextBird(testIndex)
			objects.world[birdToSlingshotBirdName].jumpTimer = 10000
			if objects.world[birdToSlingshotBirdName].jumpOn == true then
--				print("--- Jump to slingshot ---\n")
				birdToSlingshotAnimationStartY = objects.world[birdToSlingshotBirdName].oldY
				objects.world[birdToSlingshotBirdName].y = objects.world[birdToSlingshotBirdName].oldY
				objects.world[birdToSlingshotBirdName].jumpOn = false
				--print("levelStartPosition.y: " .. levelStartPosition.y .. "\n")
				--print("objects.world[birdToSlingshotBirdName].y: " .. objects.world[birdToSlingshotBirdName].y .. "\n")
				--print("birdToSlingshotAnimationHeight: " .. birdToSlingshotAnimationHeight .. "\n")
			end
			birdToSlingshotAnimationStartX = objects.world[birdToSlingshotBirdName].x
			birdToSlingshotAnimationStartY = objects.world[birdToSlingshotBirdName].y
			birdToSlingshotAnimationHeight = (levelStartPosition.y - objects.world[birdToSlingshotBirdName].y) * 1.33
		end
	
		--print("Bird to slingshot animation\n")
		birdToSlingshotAnimationTimer = birdToSlingshotAnimationTimer + dt
		
		local obj = objects.world[birdToSlingshotBirdName]
		
		if obj == nil then
			--print("OBJ = nil, returning..\n")
			return 
		end
			
		--print("newPos: " .. obj.y + _G.math.sin(birdToSlingshotAnimationAngle*birdToSlingshotAnimationTimer) * birdToSlingshotAnimationHeight .. "\n")
		setPosition(obj.name, 
			birdToSlingshotAnimationStartX * (1 - birdToSlingshotAnimationTimer) + levelStartPosition.x * birdToSlingshotAnimationTimer, 
			birdToSlingshotAnimationStartY + _G.math.sin(birdToSlingshotAnimationAngle*birdToSlingshotAnimationTimer) * birdToSlingshotAnimationHeight)
		setRotation(obj.name, obj.angle + _G.math.pi*2*dt)
		
		-- get next bird ready for action
		if birdToSlingshotAnimationTimer >= 1 then
			--print("Bird to slingshot animation timer >= 1\n")
			birdToSlingshotBirdName = nil
			birdToSlingshotAnimationTimer = 0
			fillInNextBird = false
			birdReady = true
			currentBirdIndex = currentBirdIndex + 1
			currentBirdName = getNextBird(currentBirdIndex)
			setPosition(currentBirdName, levelStartPosition.x - 0.1, levelStartPosition.y - 0.1)
			rubberBandPos.x, rubberBandPos.y = levelStartPosition.x - 0.1, levelStartPosition.y - 0.1
			rubberBandAngle = _G.math.atan2(-0.1, 0.1)
			
			local castleToBirdCamDist = _G.math.abs(distance(objects.birdCameraData[deviceModel].px, objects.birdCameraData[deviceModel].py,
				objects.castleCameraData[deviceModel].px, objects.castleCameraData[deviceModel].py))
			local camToBirdCamDist = _G.math.abs(distance(screen.x, screen.y, objects.birdCameraData[deviceModel].px, 
				objects.birdCameraData[deviceModel].py))
			local volume = _G.math.min(1, _G.math.max(0.25, 1 - (camToBirdCamDist / castleToBirdCamDist)))
			
			_G.res.playAudio(getAudioName("bird_next_military"), volume, false)
			setObjectParameter(currentBirdName, 2, 1)
			setRotation(currentBirdName, 0)
		end
	end
end

function animateChallengeBirdToSlingshot(dt)
	if nextBirdTimer > 0 then
		nextBirdTimer = nextBirdTimer - dt
		
		if nextBirdTimer <= 0 and birdFired then
			if #g_currentChallengeProgress.shotsQueue > 0 then
				local bird = g_currentChallengeProgress.shotsQueue[1]
				--_G.table.remove(g_currentChallengeProgress.shotsQueue, 1)
				
				local name = createObject(blockTable, bird, "challengeBird"..birdsCounter..bird, challengeBirdStartX * scaleFactor, challengeBirdStartY * scaleFactor)
				setRotation(name, 0)
				setMaterial(name, objects.world[name].material)
				objects.world[name].controllable = true
				
				if objects.world[name].texture ~= nil then
					local texture = blockTable.themes[currentTheme].texture				
					setTexture(name, texture)
				end
				
				birds[name] = objects.world[name]
				birds[name].animTimer = _G.math.random(10, 30) / 10
				birds[name].jumpTimer = _G.math.random(10, 30) / 10
				
				birdsCounter = birdsCounter + 1
				objects.world[name].startNumber = birdsCounter
				
				birdReady = true
				currentBirdIndex = currentBirdIndex + 1
				currentBirdName = name
				birdFired = false
				
				setPosition(currentBirdName, levelStartPosition.x - 0.1, levelStartPosition.y - 0.1)
				rubberBandPos.x, rubberBandPos.y = levelStartPosition.x - 0.1, levelStartPosition.y - 0.1
				rubberBandAngle = _G.math.atan2(-0.1, 0.1)

				local castleToBirdCamDist = _G.math.abs(distance(objects.birdCameraData[deviceModel].px, objects.birdCameraData[deviceModel].py,
					objects.castleCameraData[deviceModel].px, objects.castleCameraData[deviceModel].py))
				local camToBirdCamDist = _G.math.abs(distance(screen.x, screen.y, objects.birdCameraData[deviceModel].px, 
					objects.birdCameraData[deviceModel].py))
				local volume = _G.math.min(1, _G.math.max(0.25, 1 - (camToBirdCamDist / castleToBirdCamDist)))
				
				_G.res.playAudio(getAudioName("bird_next_military"), volume, false)
				setObjectParameter(currentBirdName, 2, 1)
				setRotation(currentBirdName, 0)
				
				addParticles(name, getObjectDefinition(name).particles, 10, false, false)
			end
		end
	end
end

function updateCharacterAnimations(dt)
	
	-- make piglets laugh when there are no birds left
	if checkLevelFailed() then
		--piglette smiles
		for k, v in _G.pairs(levelGoals) do
			setSprite(v.name, v.smileSprite)
		end
	else
		--piglette blinks
		for k, v in _G.pairs(levelGoals) do
			v.blinkTimer = v.blinkTimer - dt
			if v.blinkTimer < 0 then
				if v.blinkOn == true then
					v.blinkTimer = _G.math.random(1,30) / 10
					setSprite(v.name, v.damageSprite)
					v.blinkOn = false
				else
					v.blinkTimer = _G.math.random(1,4) / 10
					setSprite(v.name, v.blinkSprite)
					v.blinkOn = true
				end
			end
		end		
	end	
	
	--piglette oinks
	for k, v in _G.pairs(levelGoals) do
		v.oinkTimer = v.oinkTimer - dt
		if v.oinkTimer < 0 then
			v.oinkTimer = _G.math.random(10,60) / 10
			local lsx, lsy = physicsToWorldTransform(v.x, v.y)
			local dist = vLength(screen.x - lsx, screen.y - lsy)
			local volume = 1 - dist / 1000
			if volume > 0 then 
				_G.res.playAudio(getAudioName("piglette"), volume, false, 0) 
			end
		end
	end	

	
	-- bird animations
	for k, v in _G.pairs(birds) do
		
		if v.shot ~= true then
			v.animTimer = v.animTimer - dt
			-- blink and yell
			if v.animTimer < 0 then
				if v.animOn == true then
					v.animTimer = _G.math.random(10,150) / 100
					-- HATCHERY
					if g_hatcheryEnabled and v.hatcheryBird ~= nil then
						--restores
						--setupCompoObject(v.name, v.hatcheryBird.sprites, Hatchery.Bird.ingameScaling[v.hatcheryBird.shape])
						v.hatcheryBird:animationReset(v)
					else
						setSprite(v.name, v.damageSprite)
					end
					v.animOn = false
					
					
				else
					v.animTimer = _G.math.random(10,20) / 100
					local animType = _G.math.random(1,4)
					local sprite = nil
					local spriteChanged = false
					if animType == 1 then
						if g_hatcheryEnabled and v.hatcheryBird ~= nil then
							--changeHatcheryBirdBeakSprite(v.name, v.hatcheryBird, Hatchery.Bird.Sprites.BeaksYell[v.hatcheryBird.shape])
							v.hatcheryBird:animationBeak(v)
							sprite = nil
						else
							sprite = blockTable.blocks[v.definition].spriteYell
						end
						--if sprite ~= nil then
						local lsx, lsy = physicsToWorldTransform(levelStartPosition.x, levelStartPosition.y )
						local dist = vLength(screen.x - lsx, screen.y - lsy)
						local volume = 1 - dist / 1000
						if volume > 0 and eagleBaitLaunched ~= true then 
							_G.res.playAudio(getAudioName("bird_misc"), volume, false, 0) 
						end
						
						--end
					else
						
						if g_hatcheryEnabled and v.hatcheryBird ~= nil then
							--changeHatcheryBirdEyesSprite(v.name, v.hatcheryBird, Hatchery.Bird.Sprites.Blink[v.hatcheryBird.shape])
							v.hatcheryBird:animationEyes(v)
							sprite = nil
						else
							sprite = blockTable.blocks[v.definition].spriteBlink	
						end
					end
					
					if sprite ~= nil then
						setSprite(v.name, sprite)
					end
					
					v.animOn = true
				end			
			end
			
			-- jump
			if currentBirdName ~= v.name then
				if v.jumpOn ~= true then
					v.jumpTimer = v.jumpTimer - dt			
				end

				if v.jumpTimer < 0 then
					v.jumpTimer = _G.math.random(0,35) / 10
					v.jumpHeight = _G.math.random(5,15) / 10
					v.jumpSpeed = 7 / v.jumpHeight * 1.2
					if levelCompleted then
						v.jumpTimer = 0
						v.jumpHeight = _G.math.random(25,35) / 10
						v.jumpSpeed = 7 / v.jumpHeight * 1.6
					end
					v.jumpAngle = 0
					v.jumpOn = true
					v.jumpRebound = false
					v.jumpRoll = 0
					if blockTable.blocks[v.definition].allowRoll == true and v.jumpHeight > 0.9 then
						v.jumpRoll = _G.math.random(0,4) - 1
					end
					v.oldY = v.y
					v.oldAngle = v.angle
				end
				
				if v.jumpOn == true then
					v.jumpAngle = v.jumpAngle + dt * v.jumpSpeed
					setPosition(v.name, v.x, v.oldY - _G.math.sin(v.jumpAngle) * v.jumpHeight)
					if (v.jumpRoll == -1 or v.jumpRoll == 1) and v.jumpRebound ~= true then
						setRotation(v.name, v.jumpAngle * 2 * v.jumpRoll)
					end
					-- if jump complete
					if v.jumpAngle > _G.math.pi then
						if v.jumpRebound == true then
							v.jumpOn = false
							v.y = v.oldY
							v.angle = v.oldAngle
							setPosition(v.name, v.x, v.y)
							setRotation(v.name, v.angle)
						else
							v.jumpRebound = true
							v.jumpAngle = 0
							v.jumpHeight = v.jumpHeight * 0.3
							v.jumpSpeed = v.jumpSpeed * 2
						end
					end
				end
			end
		end
	end	
end

function drawCircle(x,y,radius, angle,r,g,b,a,w)
	local points = {}
					
	for i = 0,_G.math.pi * 2,0.5 do
			local px = _G.math.cos(i) * physicsToWorldTransform(radius,0)
			local py = _G.math.sin(i) * physicsToWorldTransform(radius,0)
			local point = {x + px, y +py}						
			_G.table.insert(points,point)							
	end
	
	drawPolygon(points,w, true,r,g,b,a,angle,0.5,0.5)	
end
function drawPolygon(points,lineW,inWorld,r,g,b,a,angle,pivotX,pivotY)
	local wScale = worldScale
	
	if tempWorldScale ~= nil then
		wScale = tempWorldScale
	end
	
	wScale = wScale or 1
	
	-- Add the last one again to complete polygon.	
	_G.table.insert(points, points[1])

	pivotX = pivotX or 0.5
	pivotY = pivotY or 0.5
	
	local temp = 99999999
	local w = 0
	local h = 0
	local minX = temp
	local maxX = -temp
	local minY = temp
	local maxY = -temp
	
	-- find bounds
	for k,v in _G.pairs(points) do

		minX = _G.math.min(minX, points[k][1])
		minY = _G.math.min(minY, points[k][2])
			
		maxX = _G.math.max(maxX, points[k][1])
		maxY = _G.math.max(maxY, points[k][2])			
	end
	
	local w = (maxX - minX) 
	local h = (maxY - minY) 

	local px = pivotX * w
	local py = pivotY * h
	
	-- draw polygon
	for k,v in _G.pairs(points) do
		if(k > 1) then
			
			local x1 = points[k-1][1]
			local y1 = points[k-1][2]
			
			local x2 = points[k][1]
			local y2 = points[k][2]
			
			-- calculate rotation pivot
			local rotatePivotX = (minX + px) - x1   
			local rotatePivotY = (minY + py) - y1 			
			
			setRenderState(-screen.left, -screen.top, wScale, wScale, angle, rotatePivotX, rotatePivotY)
			drawLine(r,g,b,a,x1,y1,x2,y2,inWorld,lineW)		
		end
	end	
end

-- XXX: ADD TO OTHERS
function drawWireFrameRect(x1,y1,x2,y2,lineW, inWorld,r,g,b,a,angle,pivotX, pivotY)
	local points = {{x1,y1}, {x2,y1}, {x2,y2},{x1,y2}}
	drawPolygon(points,lineW, inWorld,r,g,b,a,angle,pivotX,pivotY)
end

-- XXX: ADD TO OTHERS
function drawDummyCollisionBox(object)
	
	if showSleepingObjects == true then
		local objectName = object.name
			
		if(objectName ~= nil and adjustedBlockDef ~= nil and adjustedBlockDef.objectNames[objectName] ~= nil) then
			local selected = objects.world[objectName]
			local blockDef = adjustedBlockDef.objectNames[objectName]
			
			local x, y = physicsToWorldTransform(selected.x, selected.y)
			--local w, h = _G.res.getSpriteBounds("", v.sprite)
			local w, h = _G.res.getSpriteBounds("", selected.sprite)

			
			
			local radius = adjustedBlockDef.objectNames[objectName].radius 
			local width = adjustedBlockDef.objectNames[objectName].width 
			local height = adjustedBlockDef.objectNames[objectName].height 
			local vertices = adjustedBlockDef.objectNames[objectName].vertices 
					
			if(radius ~= nil) then
				drawCircle(x,y,radius, selected.angle,255,0,255,255,2)
				drawString(""..radius, 0.5, x,y, nil,nil, true)
			elseif(width ~= nil and height ~= nil) then
					local ww, hh = physicsToWorldTransform(width, height) 
					local x1, y1 = x - ww / 2, y - hh / 2
					local x2, y2 = x + ww / 2, y + hh / 2					
					local pivX = object.spritePivotX / (w ) 
					local pivY = object.spritePivotY / (h )
					drawWireFrameRect(x1,y1,x2,y2,1,true,255,0,255,255,selected.angle,pivX, pivY)					
					drawString("w="..width .." h="..height, 0.5, x,y, nil,nil, true)
			
			elseif(vertices ~= nil) then
				local points = {}
					
				for kk,vv in _G.pairs(blockDef.vertices) do
					local wx,wy = w * vv.x, h  * vv.y 
					local point = {x + (wx) - w / 2, y + (wy) - h / 2}
					_G.table.insert(points,point)
				end					
				drawPolygon(points,2, true,255,0,255,255,object.angle,0.5,0.5)					

				for kk,vv in _G.pairs(blockDef.vertices) do
					local wx,wy = w * vv.x, h  * vv.y 
					local xString = _G.string.format("%.2f", (vv.x))
					local yString = _G.string.format("%.2f", (vv.y))
					drawString("("..xString.."/"..yString..")", 0.1, x + wx - w / 2,y + wy - h / 2, nil,nil, true)
				end					
			end				
		end
	end
end	


-- XXX: ADD TO OTHERS
function checkCollide(object1, object2, dir) 
    local left1 = object1.x1
    local left2 = object2.x1
    local right1 = object1.x2
    local right2 = object2.x2
    local top1 = object1.y1
    local top2 = object2.y1
    local bottom1 = object1.y2
    local bottom2 = object2.y2
	
	if(dir == 1) then
		if (bottom1 < top2) then return nil end;
		if (top1 > bottom2) then return nil end;	
	end
  
	if(dir == 0) then
		if (right1 < left2) then return nil end;
		if (left1 > right2) then return nil end;	
	end

	return true

end
-- XXX: ADD TO OTHERS
function getBoundingBox(object)
	local w,h = _G.res.getSpriteBounds(object.sprite)
	w,h = worldToPhysicsTransform(w,h)
	local x1 = object.x - w / 2
	local y1 = object.y - h / 2

	local x2 = object.x + w / 2
	local y2 = object.y - h / 2

	local x3 = object.x + w / 2
	local y3 = object.y + h / 2

	local x4 = object.x - w / 2
	local y4 = object.y + h / 2

	local _x1 = object.x - x1
	local _y1 = object.y - y1
	local _x2 = object.x - x2
	local _y2 = object.y - y2
	local _x3 = object.x - x3
	local _y3 = object.y - y3
	local _x4 = object.x - x4 
	local _y4 = object.y - y4	
	
	local an = object.angle
	local cosinus = _G.math.cos(an)
	local sinus = _G.math.sin(an)
	
	local __x1 = _x1 * cosinus - _y1 * sinus + object.x
	local __y1 = _x1 * sinus + _y1 * cosinus + object.y
	local __x2 = _x2 * cosinus - _y2 * sinus + object.x
	local __y2 = _x2 * sinus + _y2 * cosinus + object.y
	local __x3 = _x3 * cosinus - _y3 * sinus + object.x
	local __y3 = _x3 * sinus + _y3 * cosinus + object.y
	local __x4 = _x4 * cosinus - _y4 * sinus + object.x
	local __y4 = _x4 * sinus + _y4 * cosinus + object.y

	local minx = _G.math.min(_G.math.min(__x1,__x2), _G.math.min(__x3,__x4))
	local maxx = _G.math.max(_G.math.max(__x1,__x2), _G.math.max(__x3,__x4))
	
	local miny = _G.math.min(_G.math.min(__y1,__y2), _G.math.min(__y3,__y4))
	local maxy = _G.math.max(_G.math.max(__y1,__y2), _G.math.max(__y3,__y4))
	
	return {x1 = minx, y1 = miny, x2 = maxx, y2 = maxy}	
end
-- XXX: ADD TO OTHERS
function alignObjects(dir)
	
	local xDir = 0
	local yDir = 0
	
	if(dir == "DOWN") then
		yDir = -1		
	elseif(dir == "UP") then
		yDir = 1
	elseif(dir == "LEFT") then
		xDir = -1
	elseif(dir == "RIGHT") then
		xDir = 1
	end
	
	
	if(selectedObjects ~= nil and #selectedObjects > 1) then
		-- sort selected objects according to direction
		if(dir == "DOWN") then _G.table.sort( selectedObjects, function(a,b) return a.y > b.y end )	end	
		if(dir == "UP") then _G.table.sort( selectedObjects, function(a,b) return a.y < b.y end )	end	
		if(dir == "LEFT") then _G.table.sort( selectedObjects, function(a,b) return a.x < b.x end )	end	
		if(dir == "RIGHT") then _G.table.sort( selectedObjects, function(a,b) return a.x > b.x end )	end	
		
		
		for i = 1, #selectedObjects do
			local sel = selectedObjects[i]
			cBox1 = getBoundingBox(sel)			
			local w = cBox1.x2 - cBox1.x1
			local h = cBox1.y2 - cBox1.y1
			
			-- insert to initial position
			if(yDir == 1) then
				setPosition(sel.name, sel.x,  selectedObjectsAreaCoords.y1 +  h / 2)									
			elseif(yDir == -1) then
				setPosition(sel.name, sel.x,  selectedObjectsAreaCoords.y2 - h / 2)									
			elseif(xDir == 1) then 
				setPosition(sel.name, selectedObjectsAreaCoords.x2 - w / 2,  sel.y)									
			elseif(xDir == -1) then 
				setPosition(sel.name, selectedObjectsAreaCoords.x1 + w / 2 ,  sel.y)									
			end
			
			local val = 99999999999999
			local mincX = val
			local maxcX = -val
			local mincY = val
			local maxcY = -val
			local collided = false
			-- collision checks					
			for j = 1, i do
				-- for boxes that won't move anymore
				local sel2 = selectedObjects[j]							
				cBox2 = getBoundingBox(sel2)
				
				if(sel2 ~= sel) then
					local collideArea = nil
					if(xDir ~= 0) then
						collideArea = checkCollide(cBox1,cBox2,1)					
					else
						collideArea = checkCollide(cBox1,cBox2,0)					
					end
					if(collideArea ~= nil) then 				
						mincX = _G.math.min(cBox2.x1, mincX)
						maxcX = _G.math.max(cBox2.x2, maxcX)
						mincY = _G.math.min(cBox2.y1, mincY)
						maxcY = _G.math.max(cBox2.y2, maxcY)
						collided = true
					end		
				end					
			end
			
			if(collided == true) then
				local ww,hh = worldToPhysicsTransform(1,1)
				if(xDir ~=0) then
					local w = cBox1.x2 - cBox1.x1
					local xp = 0
					if(xDir == -1) then
						xp = maxcX
					else
						xp = mincX
					end
					setPosition(sel.name, xp + (ww + w / 2) * -xDir, sel.y)														
				else
					local h = cBox1.y2 - cBox1.y1
					local yp = 0
					if(yDir == 1) then
						yp = maxcY
					else
						yp = mincY
					end
					setPosition(sel.name, sel.x, yp + (hh + h / 2) * yDir)														
				end
			end
		end			
	end	
end
-- XXX: ADD TO OTHERS
selectedObjectsAreaCoords = nil
function drawSelectedObjectsArea()
	-- draw box of selected items
	if(selectedObjects ~= nil and #selectedObjects > 1) then
		
		local val = 9999999999
		local minX = val local minY = val local maxX = -val local maxY = -val		

		
		for k,v in _G.pairs(selectedObjects) do
			
			local points = getBoundingBox(v)
			
			local w = points.x2 - points.x1
			local h = points.y2 - points.y1
			
			
			minX = _G.math.min(minX, v.x - w / 2)
			minY = _G.math.min(minY, v.y - h / 2)

			maxX = _G.math.max(maxX, v.x + w / 2)
			maxY = _G.math.max(maxY, v.y + h / 2)
			
		end		

		if(selectedObjectsAreaCoords == nil or keyHold["LBUTTON"]) then
			selectedObjectsAreaCoords = {}
			selectedObjectsAreaCoords.x1 = minX
			selectedObjectsAreaCoords.y1 = minY
			selectedObjectsAreaCoords.x2 = maxX
			selectedObjectsAreaCoords.y2 = maxY				
		end
		
		local worldMinX, worldMinY = physicsToWorldTransform(selectedObjectsAreaCoords.x1, selectedObjectsAreaCoords.y1)
		local worldMaxX, worldMaxY = physicsToWorldTransform(selectedObjectsAreaCoords.x2, selectedObjectsAreaCoords.y2)
		drawWireFrameRect(worldMinX,worldMinY,worldMaxX,worldMaxY,3,true,255,0,255,255,0,0.5,0.5)
		
	else
		selectedObjectsAreaCoords = nil
	end	
end


--[1.5.4 
extraTutorialTimer = 0
function drawExtraTutorial(sprite)	
	
	if extraTutorialTimer > 0.5 and birdSpecialtyAvailable == true and sprite ~= nil then		
		if settingsWrapper:getTutorialsForItem(sprite) then						
			if settingsWrapper:getTutorialsForItem(sprite).showHelp then
				if isRetinaGraphicsEnabled() then
					_G.res.drawSprite("", "TUTORIAL_FINGER_BIG", screenWidth * 0.90, screenHeight / 2, "BOTTOM", "HCENTER")
				--elseif deviceModel == "iphone4" and ((changeResolution ~= true and wantedResolution == "FULL") or (changeResolution == true and wantedResolution == "HALF")) then
				--	--TODO: REMOVE
				--	_G.res.drawSprite("", "TUTORIAL_FINGER_BIG", screenWidth * 0.90, screenHeight / 2, "BOTTOM", "HCENTER")			
				else
					_G.res.drawSprite("", "TUTORIAL_FINGER_BIG", screenWidth * 0.80, screenHeight, "BOTTOM", "HCENTER")							
				end
			end						
		end				
	end
end

function setHudRenderState()
	if deviceModel == "iphone4" and ((changeResolution ~= true and wantedResolution == "FULL") or (changeResolution == true and wantedResolution == "HALF")) then
		setRenderState(0, 0, 2, 2)
	else
		setRenderState(0, 0, 1, 1)
	end
end


------ The usual stuff
function drawCommonGameplayHud()
	--setHudRenderState()
	--local mbx, mby = _G.res.getSpritePivot("BUTTONS_SHEET_1", "MENU_BUTTON")
	--_G.res.drawSprite("BUTTONS_SHEET_1", "MENU_BUTTON", mbx, mby)
end


------ The usual HUD ingame
function drawNormalGameplayHud(bannerOffset)
	setFont(fontBasic)
	if deviceModel == "iphone4" and ((changeResolution ~= true and wantedResolution == "FULL") or (changeResolution == true and wantedResolution == "HALF")) then
		setRenderState(-screenWidth / 2, 0, 2, 2)
	else
		setRenderState(0, 0, 1, 1)
	end
	
	local scoreString = _G.string.format("%d", score)
	local scoreLen = _G.res.getStringWidth(scoreString)
	scoreLen = _G.math.max( scoreLen, oldScoreLen)
	oldScoreLen = scoreLen
	yAdd = 0
	if highscores[levelName] ~= nil and highscores[levelName].score > 0 then
		local highScoreLen = _G.res.getStringWidth("" .. highscores[levelName].score)
		yAdd = _G.res.getFontLeading() + 1
		if scoreLen < highScoreLen then
			scoreLen = highScoreLen
		end
		
		local highscoreStr = _G.res.getString("TEXTS_BASIC", "MI_HIGH_SCORE")
		_G.res.drawString("TEXTS_BASIC", highscoreStr .. " ", screenWidth - 3 - scoreLen, bannerOffset, "TOP", "RIGHT")
		_G.res.drawString("TEXTS_BASIC", _G.string.format("%d", highscores[levelName].score), screenWidth - 3, bannerOffset, "TOP", "RIGHT")
	end
	
	local scoreStr = _G.res.getString("TEXTS_BASIC", "MI_SCORE")
	_G.res.drawString("TEXTS_BASIC", scoreStr .. " ", screenWidth - 3 - scoreLen, yAdd + bannerOffset, "TOP", "RIGHT")
	_G.res.drawString("TEXTS_BASIC", scoreString, screenWidth - 3, yAdd + bannerOffset, "TOP", "RIGHT")
	setRenderState(0, 0, 1, 1, 0)
	setFont("FONT_SCORE")
	for i = 1, #floatingScores do
		local fs = floatingScores[i]
		local fx, fy = physicsToWorldTransform(fs.x, fs.y)
		local wScale = worldScale
		-- tempWorldScale is temporary scaling that is only used when iphone4 goes to 480x320 resolution to display in-game menu etc.
		if tempWorldScale ~= nil then
			wScale = tempWorldScale
		end
		fx = (fx - screen.left) * wScale
		fy = (fy - screen.top) * wScale
		local xs = fs.xs
		
		setRenderState(0, 0, xs, xs)
		if fs.text ~= nil then
			_G.res.drawString("TEXTS_BASIC", fs.text, fx/xs, fy/xs, "BOTTOM", "HCENTER")
		end
		if fs.sprite ~= nil then 
			_G.res.drawSprite("MENU_ELEMENTS_1", fs.sprite, _G.math.floor(fx/xs), _G.math.floor(fy/xs), "BOTTOM", "HCENTER")
		end
	end	
end

------ draws ME - specific HUD - elements (after eagle bait has been lanched)
function drawMEHud(bannerOffset)
	setHudRenderState()
	local tempEagleScore = 0
	if highscores[levelName] ~= nil and highscores[levelName].eagleScore ~= nil and highscores[levelName].eagleScore > 0 then
		tempEagleScore = highscores[levelName].eagleScore
	end
	local highScoreLen = _G.res.getStringWidth(tempEagleScore .. "%")
		
	local highscoreStr = _G.res.getString("TEXTS_BASIC", "TEXT_EAGLE_HIGHSCORE")
	_G.res.drawString("TEXTS_BASIC", highscoreStr .. " ", screenWidth - 3 - highScoreLen, bannerOffset, "TOP", "RIGHT")
	
	_G.res.drawString("TEXTS_BASIC", _G.string.format("%d", tempEagleScore) .. "%", screenWidth - 3, bannerOffset, "TOP", "RIGHT")	
end

------ Draws challenge - specific hud-elements
function drawChallengeHud(bannerOffset)
	setHudRenderState()
	
	local w, h = _G.res.getSpriteBounds("BIRDS_LEFT_SILHOUETTE")
	local box_w, box_h = _G.res.getSpriteBounds("INGAME_BOX")
	local lvl_w, lvl_h = _G.res.getSpriteBounds("LVL_MARK")
	local birdsLeft = _G.tostring(#g_currentChallengeProgress.shotsQueue)
	local levelProgress = g_currentChallengeProgress.levelIndex .. "/" .. #g_currentChallenge.levels
	local box_x = _G.math.floor(screenWidth - box_w * 0.6)
	local x1 = _G.math.floor(box_x - (w + _G.res.getStringWidth(birdsLeft)) * 0.5)
	local x2 = _G.math.floor(box_x - (lvl_w * 1.25 + _G.res.getStringWidth(levelProgress)) * 0.5)
	local y1 = box_h * 0.6 + bannerOffset
	local y2 = box_h * 1.7 + bannerOffset
	
	if g_challengeHudTimer < 3 then
		local w, h = _G.res.getSpriteBounds("FEATHER_BOX")
		local x = screenWidth * 0.5
		local start_y = h * -0.5
		local end_y = screenHeight + h * 0.5
		local mid_y = screenHeight * 0.5
		local y
		if g_challengeHudTimer < 1 then
			local t = g_challengeHudTimer / 1
			y = start_y + (mid_y - start_y) * t
		elseif g_challengeHudTimer < 2 then
			y = mid_y
		else
			local t = (g_challengeHudTimer - 2) / 1
			y = mid_y + (end_y - mid_y) * t
		end
		_G.res.drawSprite("FEATHER_BOX", x, y)
		setFont("FONT_BIG_NUMBERS")
		--print("drawing challenge featherbox @ " .. x .. ";" .. y .. "\n")
		_G.res.drawString("", levelProgress, x, y, "HCENTER", "VCENTER")
	end
	
	setFont("FONT_BIRDS_LEFT")
	
	_G.res.drawSprite("INGAME_BOX", box_x, y1)
	_G.res.drawSprite("INGAME_BOX", box_x, y2)
	_G.res.drawSprite("BIRDS_LEFT_SILHOUETTE", x1 + w * 0.5, y1)
	_G.res.drawSprite("LVL_MARK", x2 + lvl_w * 0.5, y2)
	_G.res.drawString("", birdsLeft, x1 + w, y1, "LEFT", "VCENTER")
	_G.res.drawString("", levelProgress, x2 + lvl_w * 1.25, y2, "LEFT", "VCENTER")
	
	
end
------- Draws tutorial finger help ingame
function drawFingerHelp()
	if(flyingBird ~= nil and flyingBird.name ~= nil) then
		local bDef = getObjectDefinition(flyingBird.name)
		drawExtraTutorial(bDef.sprite)
	end
end

------- Draws mighty eagle buttons ingame
function drawMEButtons()
	--[[
	local mbx, mby = _G.res.getSpritePivot("BUTTONS_SHEET_1", "MENU_BUTTON")
	if (isIapEnabled() == true or isEagleEnabled() == true) and g_episodes[currentThemeNumber].extra ~= true and eagleBaitLaunched ~= true and (inGameEagleButtonVisible == true or (inGameEagleButtonVisible ~= true and inGameEagleButtonScale ~= nil)) then
		local eagleButtonSprite = "BUTTON_USE_EAGLE"
			
		local w, _ = _G.res.getSpriteBounds("BUTTONS_SHEET_1", "MENU_BUTTON")
		local bw, bh = 0, 0
		local px, py = 0, 0
		
		if isEagleUnavailableForShot() == true then
			eagleButtonSprite = "BUTTON_USE_EAGLE_DISABLED"
			oldEagleButtonStatusDisabled = true
			bw, bh = _G.res.getSpriteBounds("BUTTONS_SHEET_1", eagleButtonSprite)
			px, py = _G.res.getSpritePivot("BUTTONS_SHEET_1", eagleButtonSprite)
			if eagleInfoTimer ~= nil and settingsWrapper:getEagleUsedTime() ~= nil and eagleInfoTimer > 0 then
				local timeLeft = eagleLockedTime - timeDiff(currentTime(), settingsWrapper:getEagleUsedTime())
				_G.res.drawString("TEXTS_BASIC", formatTime(timeLeft), _G.math.floor(mbx + px + bw), _G.math.floor(bh * 1.15), "VCENTER", "HCENTER")
			end
		else
			bw, bh = _G.res.getSpriteBounds("BUTTONS_SHEET_1", eagleButtonSprite)
			px, py = _G.res.getSpritePivot("BUTTONS_SHEET_1", eagleButtonSprite)
			if oldEagleButtonStatusDisabled == true and inGameEagleButtonVisible == true then
				oldEagleButtonStatusDisabled = false
				_G.res.playAudio("goldenegg", 1, false)
			end
		end

		
		
		local scaleFactor = inGameEagleButtonScale or 1
		if(startedFromEditor ~= true) then
			local yPos = (py / bh) * bh
			local xPos = mbx + px + bw

			xCoordEye = xPos + px * (1 - scaleFactor)
			yCoordEye = yPos + py * (1 - scaleFactor)
			
			_G.res.drawSprite("BUTTONS_SHEET_1", eagleButtonSprite, xCoordEye,  yCoordEye, "HPIVOT", "VPIVOT", bw * scaleFactor, bh * scaleFactor)				
			
		end	
	end	]]
end


-- Draws Ads Off Purhcase button, if the purchase option is available.
function drawPurchaseAdsOffButton()
	if(scoreAdOffsetY ~= nil and shouldShowAd() and isShowingAd == true and isAdsOffPurchaseEnabled() ) then
		setHudRenderState()
		purchaseAdsRemoveButton.x = screenWidth - 480 - purchaseAdsRemoveButton.w / 2				
		
		if(screenHeight < 480 and xCoordEye ~= nil) then
			purchaseAdsRemoveButton.x = xCoordEye + _G.res.getSpriteBounds("BUTTON_USE_EAGLE") / 2 + purchaseAdsRemoveButton.w * 0.52
		end

		purchaseAdsRemoveButton.y = scoreAdOffsetY / 2
		if(currentGameMode == updateGame and popupPage == nil) then 
			_G.res.drawSprite("", purchaseAdsRemoveButton.sprite, purchaseAdsRemoveButton.x, purchaseAdsRemoveButton.y)						
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- This function only draws the game without any logic

function drawGame()

	-- if true then return end

	--print("DRAW GAME\n")
	if showCameraDebugData then
		--store the current camera
		tempScreen = {}
		tempScreen.x = screen.x
		tempScreen.y = screen.y
		tempScreen.left = screen.left
		tempScreen.right = screen.right
		tempScreen.top = screen.top
		tempScreen.bottom = screen.bottom
		tempScreen.scale = worldScale

		--set the camera to zoomed out state
		local newScreenHeight = screenHeight / (screenWidth / ((levelRightEdge - levelLeftEdge) * physicsToWorld))
		worldScale = minWorldScale*0.9
		screen.x = (levelRightEdge + levelLeftEdge) * 0.5 * physicsToWorld
		screen.y = -newScreenHeight * 0.25
		setWorldScale(worldScale)
		defaultCamera(0)
	end
	
	local c = blockTable.themes[objects.theme].color
	setBGColor(c.r, c.g, c.b)
	
	--print("draw game\n")
	setFont(fontBasic)
	-- Draw background image
	if not settingsWrapper:isGfxLowQuality() then
		drawBackgroundNative()
		
		
	end
	
	----slingshot rubber band
	local rbx, rby = physicsToWorldTransform(rubberBandPos.x, rubberBandPos.y )
	local lsx, lsy = physicsToWorldTransform(levelStartPosition.x, levelStartPosition.y )
	
	local rbx1, rby1 = rbx, rby
	if currentBirdName ~= nil then
		local radius = objects.world[currentBirdName].radius
		if radius == nil then
			radius = objects.world[currentBirdName].width * 0.5
		end
		rbx1 = rbx - (radius + 0.05 ) * physicsToWorld * _G.math.cos(rubberBandAngle)
		rby1 = rby - (radius + 0.05 ) * physicsToWorld * _G.math.sin(rubberBandAngle)
	end
	
	local rbw = 50 / rubberBandLength
	if rbw > 25 then
		rbw = 25
	end

	if rbw < 10 then
		rbw = 10
	end
	
	--if currentGameMode == updateGame then
	local wScale = worldScale
	if tempWorldScale ~= nil then
		wScale = tempWorldScale
	end
	setRenderState(-screen.left - cameraShakeX, -screen.top - cameraShakeY, wScale, wScale, 0)
	_G.res.drawSprite("INGAME_BIRDS_1", "SLING_SHOT_01_BACK", lsx, lsy)
	local lsx1, lsy1 = lsx + 20, lsy
	drawLine2D(lsx1, lsy1, rbx1, rby1, rbw, 48, 23, 8, 255)
	if selectedBird == nil then
		_G.res.drawSprite("INGAME_BIRDS_1", "SLING_HOLDER", rbx1, rby1)
	end
	--end
	drawGameNative()
	
	if not settingsWrapper:isGfxLowQuality() and g_levelParticlesEnabled then
		drawLevelParticlesNative(1)
	end
	
	drawForegroundNative()
	
	if not settingsWrapper:isGfxLowQuality() and g_levelParticlesEnabled then
		drawLevelParticlesNative(2)
	end
	
	setRenderState(-screen.left - cameraShakeX, -screen.top - cameraShakeY, wScale, wScale, 0, 0, 0)
	
	local lsx2, lsy2 = lsx - 21, lsy - 3
	drawLine2D(lsx2, lsy2, rbx1, rby1, rbw, 48, 23, 8, 255)
	if selectedBird ~= nil then
		setRenderState(-screen.left - cameraShakeX, -screen.top - cameraShakeY, wScale, wScale, rubberBandAngle, _G.res.getSpritePivot("INGAME_BIRDS_1", "SLING_HOLDER"))
		_G.res.drawSprite("INGAME_BIRDS_1", "SLING_HOLDER", rbx1, rby1)
	end
	setRenderState(-screen.left - cameraShakeX, -screen.top - cameraShakeY, wScale, wScale, 0, 0, 0)
	_G.res.drawSprite("INGAME_BIRDS_1", "SLING_SHOT_01_FRONT", lsx, lsy)
	
	if useLevelLimits then
		if cameraTargetObject ~= nil then
			local ct = cameraTargetObject
			if ct.y*physicsToWorld < screen.top then
				setRenderState(-screen.left, -screen.top, wScale, wScale, 0, ct.spritePivotX, ct.spritePivotY)
				_G.res.drawSprite("INGAME_BIRDS_1", "HUD_ARROW_UP", _G.math.floor(ct.x*physicsToWorld), _G.math.floor(screen.top))
			end
		end
	end	
	
	if currentGameMode ~= updateEditor then

		setRenderState(0, 0, 1, 1, 0)
		
		local drawHud = true
		if(hideHud == true) then
			drawHud = false
		end
		
		-- http://i.imgur.com/zO1E0.jpg
		-- TODO: pray for miracle
		--[[
		if currentGameMode == updateMenu and (currentMenuPage == levelComplete or currentMenuPage == levelFailed or 
			currentMenuPage == gameFinished or currentMenuPage == gameFinishedThreeStars or 
			currentMenuPage == gameFinishedLP2 or currentMenuPage == gameFinishedThreeStarsLP2 or
			currentMenuPage == gameFinishedLP3 or currentMenuPage == gameFinishedThreeStarsLP3 or
			currentMenuPage == gameFinishedLP4 or currentMenuPage == gameFinishedThreeStarsLP4 or
			currentMenuPage == gameFinishedLP5 or currentMenuPage == gameFinishedThreeStarsLP5 or 
			currentMenuPage == gameFinishedLP6 or currentMenuPage == gameFinishedThreeStarsLP6) or 
			(levelCompleted == true and levelCompleteTimer <= 0) or currentGameMode == updateLoading or
			currentGameMode == updateLoadingEx or loadingPageDrawn == true then
			drawHud = false
		end
		
		if g_drawHud == false then
			drawHud = false
		end]]
		
		--[[
		if drawHud then
			bannerOffset = 0
			if scoreAdOffsetY ~= nil then
				bannerOffset = _G.math.min(_G.math.max(scoreAdOffsetY, 0), bannerHeight)
			end
			
			--------------------------------
			drawCommonGameplayHud()
			drawFingerHelp()			
			--------------------------------
			if not startedFromEditor then
				if isChallengeMode() then
					drawChallengeHud(bannerOffset)
				elseif eagleBaitLaunched == true then
					drawMEButtons()
					drawMEHud(bannerOffset)			
				else
					drawMEButtons()
					drawNormalGameplayHud(bannerOffset)
				end
			else
				drawNormalGameplayHud(bannerOffset)
			end
			setFont(fontBasic)
			setRenderState(0, 0, 1, 1)
		end
		
		drawPurchaseAdsOffButton()
		]]
		
	end

	--	void GameLua::drawCircle(float x, float y, float radius, float lineW, float r, float g, float b, float a);
	if currentGameMode == updateEditor then
		drawSelectedObjectsArea();
	end
	
	if(showSleepingObjects == true) then
		for k, v in _G.pairs(objects.world) do
			if v.sleeping == true and v.sprite ~= "" then
				local w, h = _G.res.getSpriteBounds("", v.sprite)
				w, h = w*0.5, h*0.5
				local x, y = physicsToWorldTransform(v.x, v.y)
				local x1, y1 = x - w, y - h
				local x2, y2 = x + w, y + h
				setRenderState(-screen.left, -screen.top, wScale, wScale, v.angle, v.spritePivotX, v.spritePivotY)
				drawRect(1, 0, 0, 0.5, x1, y1, x2, y2, true)
			end
			
			if(v.definition and v.sprite ~= "") then
				local blockDef = blockTable.blocks[v.definition]
		
				local w, h = _G.res.getSpriteBounds("", v.sprite)

				w, h = w*0.5, h*0.5
				local x, y = physicsToWorldTransform(v.x, v.y)
				local x1, y1 = x - w, y - h
				local x2, y2 = x + w, y + h
				
				if(blockDef.type == "circle") then
					local radius = blockDef.radius or _G.math.max(worldToPhysicsTransform(w,0),worldToPhysicsTransform(h,0))
					drawCircle(x,y,radius, v.angle,255,255,255,255,4)
					
				elseif (blockDef.type == "box" and blockDef.width ~= nil) then
					local ww, hh = physicsToWorldTransform(blockDef.width, blockDef.height) 
					local x1, y1 = x - ww / 2, y - hh / 2
					local x2, y2 = x + ww / 2, y + hh / 2
					
					local pivX = v.spritePivotX / (w * 2) 
					local pivY = v.spritePivotY / (h * 2)
					
					drawWireFrameRect(x1,y1,x2,y2,3,true,0,255,255,190,v.angle,pivX,pivY)
				
				elseif(blockDef.type == "box" and blockDef.width == nil) then
					local w, h = _G.res.getSpriteBounds("", v.sprite)
					w, h = w * 0.5, h * 0.5
					local x, y = physicsToWorldTransform(v.x, v.y)
					local x1, y1 = x - w, y - h
					local x2, y2 = x + w, y + h
					--setRenderState(-screen.left, -screen.top, wScale, wScale, v.angle, v.spritePivotX, v.spritePivotY)
					--drawRect(1, 0, 0, 0.5, x1, y1, x2, y2, true)
					drawWireFrameRect(x1,y1,x2,y2,3,true,0,255,255,190,v.angle,pivX,pivY)
				
				elseif (blockDef.type == "polygon" and blockDef.vertices) then
					local points = {}

					for kk,vv in _G.pairs(blockDef.vertices) do
						local wx,wy = w * 2 * vv.x, h * 2 * vv.y 
						local point = {x + wx - w, y + wy - h}
						_G.table.insert(points,point)
					end					
					drawPolygon(points,3, true,255,255,255,255,v.angle,0.5,0.5)
				end				
			end

			if v.strength ~= nil and v.sprite ~= nil and v.strength ~= blockTable.blocks[v.definition].strength and v.sprite ~= "" then
				local w, h = _G.res.getSpriteBounds("", v.sprite)
				w ,h = w * 0.50, h * 0.50
				local x, y = physicsToWorldTransform(v.x, v.y)
				local x1, y1 = x - w, y - h
				local x2, y2 = x + w, y + h 
				
				setRenderState(-screen.left, -screen.top, wScale, wScale, v.angle, v.spritePivotX, v.spritePivotY)
				
				drawLine(0,0,255,155,x1,y1,x2,y1,true,4)
				drawLine(0,0,255,155,x1,y1,x1,y2,true,4)
				setRenderState(-screen.left , -screen.top , wScale, wScale, v.angle, v.spritePivotX, -v.spritePivotY)
				drawLine(0,0,255,155,x1,y2,x2,y2,true,4)
				setRenderState(-screen.left, -screen.top, wScale, wScale, v.angle, -v.spritePivotX , v.spritePivotY )
				drawLine(0,0,255,155,x2,y1,x2,y2,true,4)
			end
			
			if(selectedObjects ~= nil and #selectedObjects == 1 and selectedObjects[1] == v) then			
				drawDummyCollisionBox(v)
			end
		end
	end	

	setRenderState(0, 0, 1, 1, 0)
	
	oldZoomLevel = zoomLevel
	
	if deviceModel == "android" and isBetaVersion and currentGameMode == updateGame and #birdTutorialPopups == 0 then
		_G.res.drawSprite("MENU_LITEBETA_1", "BETA_BOTTOM_RIGHT", screenWidth, screenHeight)
	end
	
	if objects.world["MightyEagle_a"] ~= nil then
		local eagle = objects.world["MightyEagle_a"]
		if eagle.targetX > eagle.x then
			eagleDarkness = (100 - _G.math.min(_G.math.max(_G.math.abs(eagle.targetX - eagle.x), 0), 100)) / 200
		end
	end	
	if eagleDarkness ~= nil then
		drawRect( 0, 0, 0, eagleDarkness, 0, 0, screenWidth, screenHeight, false)
	end
--	if popupPage ~= nil then
--		if(popupPage == dummyPopupPage) then		
--			print("PopupPage not nil is dummyPopoupPage")		
--		else
--			print("PopupPage not nil and NOT dummyPopoupPage")		
--		end
--	else
--		print("!!! PopupPage WAS nil")	
--	end
	if popupPage ~= nil then
		drawMenuPage(popupPage)
	end
	
	--[[if #feedMessages > 0 and feedMessages[1].sprite and feedMessages[1].offset then
		local sprite = feedMessages[1].sprite
		local bw, bh = _G.res.getSpriteBounds("", sprite)
		_G.res.drawSprite("", sprite, screenWidth / 2 - bw / 2,feedMessages[1].offset, "TOP", "LEFT", bw, bh)		
	end]]
	
	
	if showCameraDebugData then
		local bcd = objects.birdCameraData[deviceModel]
		local ccd = objects.castleCameraData[deviceModel]
		local swx = screenWidth * 0.5 / tempScreen.scale
		local swy = screenHeight * 0.5 / tempScreen.scale
		
		setRenderState(-screen.left, -screen.top, wScale, wScale, 0, 0, 0)
		drawLine2D(bcd.px, bcd.py, ccd.px, ccd.py, 3, 48, 23, 8, 255)
		drawLine2D(animationScreen.x, animationScreen.y-15, animationScreen.x, animationScreen.y+15, 3, 48, 23, 8, 255)
		drawRectLines(visualizeScreen.x-swx, visualizeScreen.y-swy, visualizeScreen.x+swx, visualizeScreen.y+swy, 3, 255, 255, 255, 255)
		
		drawLine2D(leftLimit, -500, leftLimit, 50, 3, 255, 23, 8, 255)
		drawLine2D(rightLimit, -500, rightLimit, 50, 3, 255, 23, 8, 255)
		
		drawLine2D(leftLimit, groundLimit, rightLimit, groundLimit, 3, 255, 23, 8, 255)
		
		setRenderState(0, 0, 1, 1, 0)

		
		screen.x = tempScreen.x 
		screen.y = tempScreen.y
		screen.left = tempScreen.left
		screen.right = tempScreen.right
		screen.top = tempScreen.top
		screen.bottom = tempScreen.bottom
		worldScale	= tempScreen.scale
		
		setWorldScale(worldScale)
	end
	
	--[[ BEGIN FPS DEBUG CODE -- 
	if drawFPSStatistics then
		local FPSMinStr = String
		_G.res.drawString("", _G.string.format("FPSMin: %.1f", FPSMin), 0, screenHeight-60, "BOTTOM", "LEFT")
		_G.res.drawString("", _G.string.format("FPSAvg: %.1f", FPSFrames/FPSTime), 0, screenHeight-30, "BOTTOM", "LEFT")
		_G.res.drawString("", _G.string.format("FPSMax: %.1f", FPSMax), 0, screenHeight, "BOTTOM", "LEFT")
	end
	-- END FPS DEBUG CODE --]]		
	
	
	-- setRenderState(500, 500, 1, 1, 1.57, 0, 0)
	-- _G.res.drawSprite("", "TUTORIAL_RED", 0, 0)
	
	
	
end


function drawEditor()
	
	local wScale = worldScale
	
	setRenderState(0, 0, 1, 1, 0)
	
	if editor.drawOneLayer then
		drawLayer(editor.currentLayer)				
		
		--draws selected objects on current layer
		for k, v in _G.pairs(selectedObjects) do										
			if v.definition ~= nil and v.definition ~= "" then
				local w, h = _G.res.getSpriteBounds("", blockTable.blocks[v.definition].sprite)
				w, h = w * v.scale.x, h * v.scale.y
				w, h = w * 0.5, h * 0.5
				local x, y = physicsToWorldTransform(v.x, v.y)
				local x1, y1 = x - w, y - h
				local x2, y2 = x + w, y + h
				local t_pivotX, t_pivotY = _G.res.getSpritePivot("", blockTable.blocks[v.definition].sprite)
				t_pivotX, t_pivotY = t_pivotX * v.scale.x, t_pivotY * v.scale.y
				--setRenderState(-screen.left, -screen.top, worldScale, worldScale, 0, 0, 0)
				setRenderState(	-screen.left, -screen.top, worldScale, worldScale, 
								v.angle, t_pivotX, t_pivotY)
				drawRect(1, 0, 0, 0.5, x1, y1, x2, y2, true)
			end			
		end
		
		if copiedObjects ~= nil then
			for k, v in _G.pairs(copiedObjects) do
				local sprite = blockTable.blocks[v.definition].sprite
				local blockDefScale = blockTable.blocks[v.definition].scale or 1
				local pivotX, pivotY = 0, 0
				local flip = 1
				if blockTable.blocks[v.definition].horFlip then
					flip = -flip
				end

				pivotX, pivotY = _G.res.getSpritePivot(sprite)
				--setRenderState(-screen.left, -screen.top, worldScale * v.scale.x, worldScale * v.scale.y, v.angle, res.getSpritePivot("", sprite))
				setRenderState(flip * -screen.left / (v.scale.x * blockDefScale), -screen.top / (v.scale.y * blockDefScale), flip * worldScale * v.scale.x, worldScale * v.scale.y, flip * v.angle, pivotX, pivotY)
				
				local x, y = physicsToWorldTransform(v.x + cursorPhysics.x, v.y + cursorPhysics.y)
				
				x, y = flip * x / v.scale.x, y / v.scale.y
				
				_G.res.drawSprite(sprite, _G.math.floor(x), _G.math.floor(y))
			end
			setRenderState(0, 0, 1, 1, 0)
		end		
		
		setRenderState(0, 0, 1, 1, 0)	
		
	else
		--this call will draw all in game elements
		drawGame()
		
		if keyHold["L"] then
			for k, v in _G.pairs(objects.world) do
				if v.startNumber then
					local sprite = blockTable.blocks[v.definition].sprite
					local blockDefScale = blockTable.blocks[v.definition].scale or 1
					local pivotX, pivotY = _G.res.getSpritePivot(sprite)
					setRenderState(-screen.left / blockDefScale, -screen.top / blockDefScale, worldScale, worldScale , v.angle, pivotX, pivotY)
					local x, y = physicsToWorldTransform(v.x, v.y)
					_G.res.drawString("TEXTS_BASIC", "" .. v.startNumber, x, y, "HCENTER", "VCENTER")
				end
			end
			setRenderState(0, 0, 1, 1, 0)
		end
	end
	
	
	setRenderState(0, 0, 1, 1, 0)
	_G.res.drawString("TEXTS_BASIC", levelName, 0, 0, "TOP", "LEFT")

	if selectionRectActive then
		local x1, y1 = draggingStartPosWorld.x, draggingStartPosWorld.y
		local x2, y2 = cursorWorld.x, cursorWorld.y
		if x1 > x2 then	x1, x2 = x2, x1	end
		if y1 > y2 then	y1, y2 = y2, y1	end
		setRenderState(-screen.left, -screen.top, wScale, wScale, 0)
		drawRect(1, 0, 0, 0.5, x1, y1, x2, y2, true)
	end		

	setRenderState(0, 0, 1, 1, 0)
	if not editor.drawOneLayer then
		for k, v in _G.pairs(objects.joints) do
			drawJoint(v, "EDITOR_JOINT")
		end
	end
	
	if selectedObjects[1] ~= nil then
		if selectedObjects[1].controllable then
			if selectedObjects[1].startNumber ~= nil then
				_G.res.drawString("TEXTS_BASIC", "Start: " .. selectedObjects[1].startNumber, 0, 35, "TOP", "LEFT")
			end
		end
	end

	for k, v in _G.pairs(selectedObjects) do
		if v.sprite ~= nil and v.sprite ~= "" then
			local w, h = _G.res.getSpriteBounds("", v.sprite)
			w, h = w*0.5, h*0.5
			local x, y = physicsToWorldTransform(v.x, v.y)
			local x1, y1 = x - w, y - h
			local x2, y2 = x + w, y + h
			setRenderState(-screen.left, -screen.top, wScale, wScale, v.angle, v.spritePivotX, v.spritePivotY)
			drawRect(1, 0, 0, 0.5, x1, y1, x2, y2, true)
		end
	end
	
	if physicsEnabled then
		for k, v in _G.pairs(objects.world) do
			if v.sleeping == true and v.sprite ~= "" then
				local w, h = _G.res.getSpriteBounds("", v.sprite)
				w, h = w*0.5, h*0.5
				local x, y = physicsToWorldTransform(v.x, v.y)
				local x1, y1 = x - w, y - h
				local x2, y2 = x + w, y + h
				setRenderState(-screen.left, -screen.top, wScale, wScale, v.angle, v.spritePivotX, v.spritePivotY)
				drawRect(1, 0, 0, 0.5, x1, y1, x2, y2, true)
			end
		end
	end
	
	-- Draw small rect to indicate origin
	if keyHold["O"] then
		setRenderState(-screen.left*wScale, -screen.top*wScale, 1, 1, 0, 0, 0)
	else
		setRenderState(-screen.left, -screen.top, wScale, wScale, 0, 0, 0)
	end
	_G.res.drawSprite("", "ORIGO", 0, 0)
	setRenderState(0, 0, 1, 1, 0)

	if objectToAdd ~= nil then
		local sprite = blockTable.blocks[objectToAdd].sprite
		setRenderState(-screen.left, -screen.top, wScale, wScale, objectToAddAngle, _G.res.getSpritePivot("", sprite))
		_G.res.drawSprite("", sprite, _G.math.floor(cursorWorld.x), _G.math.floor(cursorWorld.y))
		setRenderState(0, 0, 1, 1, 0)
	end
	
	if not editor.drawOneLayer then
		if copiedObjects ~= nil then
			for k, v in _G.pairs(copiedObjects) do
				local sprite = objects.world[v.name].sprite
				local blockDefScale = blockTable.blocks[v.definition].scale or 1
				local pivotX, pivotY = 0, 0
				local flip = 1
				if blockTable.blocks[v.definition].horFlip then
					flip = -flip
				end
				pivotX, pivotY = _G.res.getSpritePivot(sprite)
				setRenderState(flip * -screen.left / blockDefScale, -screen.top / blockDefScale, flip * worldScale * blockDefScale, worldScale * blockDefScale, flip * v.angle, pivotX, pivotY)
				local x, y = physicsToWorldTransform(v.x + cursorPhysics.x, v.y + cursorPhysics.y)
				x, y = flip * x / blockDefScale, y / blockDefScale
				_G.res.drawSprite(sprite, _G.math.floor(x), _G.math.floor(y))
			end
			
			setRenderState(0, 0, 1, 1, 0)
		end
		
		if levelSaved then
			_G.res.drawSprite("", "EDITOR_SAVED", screenWidth, 0)
		else
			_G.res.drawSprite("", "EDITOR_NOT_SAVED", screenWidth, 0)
		end

		if physicsEnabled then
			_G.res.drawSprite("", "EDITOR_PHYSICS_ON", screenWidth, 0)
		else
			_G.res.drawSprite("", "EDITOR_PHYSICS_OFF", screenWidth, 0)
		end

		if objects.castleCameraData and objects.castleCameraData[deviceModel] then
			_G.res.drawSprite("", "EDITOR_C_CAMERA_ON", screenWidth, 0)
		else
			_G.res.drawSprite("", "EDITOR_C_CAMERA_OFF", screenWidth, 0)
		end

		if objects.birdCameraData and objects.birdCameraData[deviceModel] then
			_G.res.drawSprite("", "EDITOR_B_CAMERA_ON", screenWidth, 0)
		else
			_G.res.drawSprite("", "EDITOR_B_CAMERA_OFF", screenWidth, 0)
		end
		
		if objects.doNotWaitForMovingObjects ~= nil then
			_G.res.drawString("", "QUICK END", screenWidth, screenHeight, "BOTTOM", "RIGHT")
		end
	end
	
	if editor.edit_particles then
	
		local type = "<none>"
		if editor.particle_type > 0 then
			type = particleTable.levelParticles[editor.particle_type]
		end
	
		_G.res.drawString("", "LEVEL PARTICLES - (D)ELETE", 50, 50, "TOP", "LEFT")
		_G.res.drawString("", "(T)YPE: " .. type, 75, 100, "TOP", "LEFT")
		_G.res.drawString("", "AMOUNT: " .. editor.particle_amount .. " (M)ore/(L)ess", 75, 150, "TOP", "LEFT")
	end

end

function drawJoint(joint, sprite)
	if joint.x1 == nil then
		return
	end
	
	local jointWorldX1 = joint.x1
	local jointWorldY1 = joint.y1
	local jointWorldX2 = joint.x2
	local jointWorldY2 = joint.y2
	
	if joint.coordType == 2 then
		jointWorldX1, jointWorldY1 = getWorldPoint(joint.end1, jointWorldX1, jointWorldY1);
		jointWorldX2, jointWorldY2 = getWorldPoint(joint.end2, jointWorldX2, jointWorldY2);
	end
	
	local xdif = jointWorldX2 - jointWorldX1
	local ydif = jointWorldY2 - jointWorldY1
	local tlen = vLength(xdif, ydif)
	local x = 0
	local y = 0

	--print(k .. " " .. tlen .. " " .. vLength(x, y) .."\n")
	if tlen == 0 then
		return
	end

	local vlen = 0
	while vlen <= tlen do
		sx, sy = physicsToScreenTransform(jointWorldX1 + x, jointWorldY1 + y )
		_G.res.drawSprite("", sprite, sx, sy)
		x = x + xdif * 0.13
		y = y + ydif * 0.13
		vlen = vLength(x, y)
		--print("vlen: " .. vlen .. " tlen: " .. tlen .. "\n")
	end
end

-------------------------------------------------------------------------------
-- Cameras 

function defaultCamera(dt)
	screen.left = screen.x - screenWidth * 0.5 / worldScale
	screen.top = screen.y - screenHeight * 0.5 / worldScale
	screen.right = screen.x + screenWidth * 0.5 / worldScale
	screen.bottom = screen.y + screenHeight * 0.5 / worldScale
	
	--print("left : " .. screen.left .. ", top: " .. screen.top .. "\n")
	--print("right: " .. screen.right .. ", bottom: " .. screen.bottom .. "\n")
	--print("Scale: " .. worldScale .. "\n")
	
	setTopLeft(screen.left + cameraShakeX, screen.top + cameraShakeY)
end


--kamera
--stay on the current target
--if target changes move to the new target using given speed
--keep the defined objects visible if possible by current restraints

function getTempBirdCamera()
	local tempCamera = {}
	
	local bcd = objects.birdCameraData[deviceModel]
	local ccd = objects.castleCameraData[deviceModel]
	
	-- use current zoom (user defined) if camera is not zoomed in at max level defined by current camera
	if maxZoomLevel == true then	
		tempCamera.sx = bcd.sx
	else
		tempCamera.sx = currentZoomedScale
	end
	
	if tempCamera.sx > bcd.sx then
		tempCamera.sx = bcd.sx
	end
	if tempCamera.sx < minWorldScale then
		tempCamera.sx = minWorldScale
	end
	
	tempCamera.py = bcd.py	
	local alpha = (tempCamera.sx - minWorldScale) / (bcd.sx - minWorldScale)
	--print("alpha: " .. alpha .. "\n")
	tempCamera.py = bcd.py * alpha + ccd.py * (1 - alpha)

	local groundPos = tempCamera.py + screenHeight * 0.5 / tempCamera.sx 
	if groundPos > groundLimit then
		tempCamera.py = tempCamera.py + (groundLimit - groundPos)
	end
	
	local leftPos = bcd.px - screenWidth * 0.5 / tempCamera.sx 
	tempCamera.px = bcd.px
	if leftPos < leftLimit then
		tempCamera.px = bcd.px + (leftLimit - leftPos)
	end	
	
	return tempCamera
end


function getTempCastleCamera()
	local tempCamera = {}
	local ccd = objects.castleCameraData[deviceModel]
		
	-- use current zoom (user defined) if camera is not zoomed in at max level defined by current camera
	if maxZoomLevel == true then		
		tempCamera.sx = ccd.sx
	else
		tempCamera.sx = currentZoomedScale
	end
	
	if tempCamera.sx > ccd.sx then
		tempCamera.sx = ccd.sx
	end
	if tempCamera.sx < minWorldScale then
		tempCamera.sx = minWorldScale
	end
	
	local groundPos = ccd.py + screenHeight * 0.5 / tempCamera.sx
	tempCamera.py = ccd.py
	if groundPos > groundLimit then
		tempCamera.py = ccd.py + (groundLimit - groundPos)
	end
		
	local rightPos = ccd.px + screenWidth * 0.5 / tempCamera.sx 
	tempCamera.px = ccd.px
	if rightPos > rightLimit then
		tempCamera.px = ccd.px + (rightLimit - rightPos)
	end
	
	return tempCamera
end

useLevelLimits = true
function doItAllCamera(dt)
	--print(currentFrame .. " doItAllCamera camera\n")

	local ccd = objects.castleCameraData[deviceModel]
	local bcd = objects.birdCameraData[deviceModel]
	
	-- do not allow to zoom beyond level limits
	-- if zoomLevel + bcd.sx < minWorldScale and zoomLevel + ccd.sx < minWorldScale then
		-- zoomLevel = oldZoomLevel
	-- end
	
	-- Zoom level has changed
	if oldZoomLevel ~= zoomLevel then
		maxZoomLevel = false
		currentZoomedScale = currentZoomedScale + zoomLevel - oldZoomLevel
		-- if current zoomed scale is bigger than the current target camera set the scale to the camera scale
		if cameraAnimationSliderTarget == 0 then
			if currentZoomedScale >= bcd.sx then
				currentZoomedScale = bcd.sx
				maxZoomLevel = true
			end
		else
			if currentZoomedScale >= ccd.sx then
				currentZoomedScale = ccd.sx
				maxZoomLevel = true
			end
		end
		if currentZoomedScale < minWorldScale then
			currentZoomedScale = minWorldScale
		end
		oldZoomLevel = zoomLevel
		animationWorldScale = currentZoomedScale
	end	
	
	local bcdt = getTempBirdCamera()
	local ccdt = getTempCastleCamera()
	
	if ccd ~= nil and bcd ~= nil then
		local springFactor = dt * 3.5
		local scaleFactor = screenWidth / ccd.screenWidth
		local screenTemp = { x = 0, y = 0 }
		local dx = ccdt.px - bcdt.px
		
		if dx < 1 then dx = 1 end
		
		animateScale = true
		-- camera left boundary limit
		if cameraAnimationSlider < 0 then
			cameraAnimationSlider = cameraAnimationSlider - cameraAnimationSlider * 0.3
			if cameraAnimationSlider < -0.01 then
				animateScale = false
			end
			forceSprings = true
			sweepSpeed = 0
		end

		-- camera right boundary limit
		if cameraAnimationSlider > 1 then
			cameraAnimationSlider = cameraAnimationSlider + (1-cameraAnimationSlider) * 0.3
			if cameraAnimationSlider > 1.01 then
				animateScale = false
			end
			forceSprings = true
			sweepSpeed = 0
		end
		
		-- choose closest camera
		if cameraAnimationSlider > 0 and cameraAnimationSlider < 1 and sweepSpeed == 0 then
			forceSprings = false
			if cameraAnimationSlider < 0.5 then
				cameraAnimationSliderTarget = 0
			else
				cameraAnimationSliderTarget = 1
			end
		end
		
		-- animate camera without target
		if cameraTargetObject == nil then
			--print(currentFrame .. " Camera target object is nil\n")
			if not keyHold["LBUTTON"] and sweepSpeed == 0 then
				cameraAnimationSlider = cameraAnimationSlider + (cameraAnimationSliderTarget-cameraAnimationSlider) * 0.3
				--print("LButton and sweepSpeed\n")
			else
				if forceSprings ~= true then
					springFactor = 1
				end
			end
		
			--print("before cameraAnimationSlider: " .. cameraAnimationSlider .. " sweepSpeed: " .. sweepSpeed .. " cameraAnimationSliderTarget: " .. cameraAnimationSliderTarget .. " dt: " .. dt .. " dx: " .. dx .. "\n")
			--print("Before animationWorldScale: " .. animationWorldScale .. " animationScreen.x: " .. animationScreen.x .. " animationScreen.y: " .. animationScreen.y .. "\n")
			cameraAnimationSlider = cameraAnimationSlider - dt * sweepSpeed / (dx * bcd.sx) -- * worldScale)
			local tsx = bcdt.sx + (ccdt.sx - bcdt.sx) * cameraAnimationSlider
			local tpx = bcdt.px + (ccdt.px - bcdt.px) * cameraAnimationSlider
			local tpy = bcdt.py + (ccdt.py - bcdt.py) * cameraAnimationSlider			
			animationScreen.x = animationScreen.x - (animationScreen.x - tpx) * springFactor
			animationScreen.y = animationScreen.y - (animationScreen.y - tpy) * springFactor
			if animateScale == true then
				animationWorldScale = animationWorldScale - (animationWorldScale - tsx) * springFactor
			end
			if maxZoomLevel == true then
				currentZoomedScale = animationWorldScale
			end
			
			-- set the current values
			screen.x = animationScreen.x
			screen.y = animationScreen.y
			
			worldScale = animationWorldScale
			setWorldScale(worldScale)
			repositionScreen()
		end
	
		----[[
		if cameraTargetObject ~= nil then
			--print(currentFrame .. " Camera target object is " .. cameraTargetObject.name .. "\n")
			-- camera target x, y
			--print("castle camera phase1 cas: " .. cameraAnimationSlider .. "\n")	
			local ctx, cty = physicsToWorldTransform(cameraTargetObject.x, cameraTargetObject.y)
			if cameraTargetObject.xVel > 0 then
				cameraAnimationSlider = cameraAnimationSlider + cameraTargetObject.xVel * physicsToWorld * dt * 10 / dx
			end
			if cameraAnimationSlider > 1 then
				cameraAnimationSlider = 1
			end
			
			--print("cameraAnimationSlider: " .. cameraAnimationSlider .. "\n")
			
			-- current animation targets based on the bird velocity
			local tsx = bcdt.sx + (ccdt.sx - bcdt.sx) * cameraAnimationSlider
			local tpx = bcdt.px + (ccdt.px - bcdt.px) * cameraAnimationSlider
			local tpy = bcdt.py + (ccdt.py - bcdt.py) * cameraAnimationSlider
			
			animationWorldScale = animationWorldScale - (animationWorldScale - tsx) * springFactor
			animationScreen.x = animationScreen.x - (animationScreen.x - tpx) * springFactor
			animationScreen.y = animationScreen.y - (animationScreen.y - tpy) * springFactor		

			-- camera x, y
			local cleft = animationScreen.x - screenWidth * 0.5 / animationWorldScale
			local ctop = animationScreen.y - screenHeight * 0.5 / animationWorldScale
			local cright = animationScreen.x + screenWidth * 0.5 / animationWorldScale
			local cbottom = animationScreen.y + screenHeight * 0.5 / animationWorldScale

			local minx = _G.math.min(cleft, ctx - 50)
			local miny = _G.math.min(ctop, cty - 50)
			local maxx = _G.math.max(cright, ctx + 50)
			local maxy = _G.math.max(cbottom, cty + 50)
			
			if useLevelLimits then
				minx = _G.math.max(leftLimit, minx)
				maxx = _G.math.min(rightLimit, maxx)
			end

			local xScale = _G.math.abs(screenWidth/(maxx-minx))
			local yScale = _G.math.abs(screenHeight/(maxy-miny))
			
			local worldScaleTemp = _G.math.min(xScale, yScale) * scaleFactor
			--print("worldScaleTemp: " .. worldScaleTemp .. " animws: " .. animationWorldScale .. "\n")

			-- scale is never closer than the animation to castle camera's scale
			if worldScaleTemp > animationWorldScale then
				worldScaleTemp = animationWorldScale
				--print("worldScaleTemp = animationWorldScale.\n")
			end
			--print("worldScaleTemp: " .. worldScaleTemp .. "\n")
			
			screenTemp.x = (maxx + minx) * 0.5
			screenTemp.y = (maxy + miny) * 0.5

			if useLevelLimits then								
				-- if y scale is smaller we need to check that x coordinates stay inside the boundaries
				local limitsReached = false
				if (screenTemp.x + screenWidth * 0.5 / worldScaleTemp) > rightLimit then
					maxx = rightLimit
					minx = maxx - screenWidth / worldScaleTemp
					limitsReached = true
					if minx < leftLimit then
						minx = leftLimit
					end
					--print("Limits reached 1\n")
				end
				if (screenTemp.x - screenWidth * 0.5 / worldScaleTemp) < leftLimit then
					minx = leftLimit
					maxx = minx + screenWidth / worldScaleTemp
					limitsReached = true
					if maxx > rightLimit then
						maxx = rightLimit
					end
					--print("Limits reached 1\n")
				end
				if limitsReached then
					screenTemp.x = (maxx + minx) * 0.5
					worldScaleTemp = _G.math.abs(screenWidth/(maxx-minx)) * scaleFactor 
				end
			end
			
			screen.x = screen.x - (screen.x - screenTemp.x) * springFactor
			animationWorldScale2 = animationWorldScale2 - (animationWorldScale2 - worldScaleTemp) * springFactor
			worldScale = animationWorldScale2
			
			screen.y = screen.y - (screen.y - screenTemp.y) * springFactor
			
			forceSprings = true
			
			if ctx >= rightLimit or ctx <= leftLimit then
				animationWorldScale = worldScale
				animationScreen.x = screen.x
				animationScreen.y = screen.y
				-- print("animationWorldScale: " .. animationWorldScale .. " animationScreen.x: " .. animationScreen.x .. " animationScreen.y: " .. animationScreen.y .. "\n")
				--print("Camera target object outside level limits\n")
				cameraTargetObject = nil
			end
			
			setWorldScale(worldScale)
			repositionScreen()			
		end
		--]]		
	end
	defaultCamera(dt)
end

function returnToBirdCamera()
	showTapIcon = false
	showTapTimer = 0
	cameraFunction = doItAllCamera
	sweepSpeed = objects.castleCameraData[deviceModel].px - objects.birdCameraData[deviceModel].px
	cameraAnimationSliderTarget = 0
	if cameraAnimationSlider >= 1 then
		cameraAnimationSlider = 1
	end
	allowResetToBirdCamera = false
	cameraTargetObject = nil
	flyingBird = nil
end

function repositionScreen()
	local ccd = objects.castleCameraData[deviceModel]
	local bcd = objects.birdCameraData[deviceModel]
		
	-- scale is too big, limit the scale
	if worldScale < minWorldScale then
		worldScale = minWorldScale
		setWorldScale(worldScale)
		--print("Forced scale to minWorldScale.\n")
	end
	
	if showCameraDebugData then
		visualizeScreen.x = screen.x
		visualizeScreen.y = screen.y
	end
	
	local groundPos = screen.y + screenHeight * 0.5 / worldScale 
	if groundPos > groundLimit then
		screen.y = screen.y + (groundLimit - groundPos)
	end
		
	local rightPos = screen.x + screenWidth * 0.5 / worldScale 
	if rightPos > rightLimit then
		screen.x = screen.x + (rightLimit - rightPos)
	end	

	local leftPos = screen.x - screenWidth * 0.5 / worldScale 
	if leftPos < leftLimit then
		screen.x = screen.x + (leftLimit - leftPos)
	end
end

function levelStartCamera(dt)
	--print("Level start camera\n")
	local ccd = objects.castleCameraData[deviceModel]
	local bcd = objects.birdCameraData[deviceModel]

	if castleCameraTimer < 2 then
		local wx, wy = ccd.px, ccd.py
		if levelRestartedFrom == nil or startedFromEditor then
			worldScale = ccd.sx
		else
			worldScale  = getTempCastleCamera().sx
		end
		setWorldScale(worldScale)
		screen.x = wx
		screen.y = wy
		castleCameraTimer = castleCameraTimer + dt
		animationWorldScale = worldScale
		animationScreen.x = screen.x
		animationScreen.y = screen.y		
		
		if levelRestartedFrom ~= nil or startedFromEditor ~= true then
			repositionScreen()
		end
		
		defaultCamera(dt)
		return
	end

	castleCameraTimer = 0
	cameraAnimationSlider = 1
	cameraAnimationSliderTarget = 0
	sweepSpeed = ccd.px - bcd.px
	showTapIcon = false
	--print("levelStartCamera: cameraFunction = doItAllCamera\n")	
	cameraFunction = doItAllCamera
	animationScreen.x = screen.x
	animationScreen.y = screen.y
	animationWorldScale = worldScale	
	defaultCamera(dt)
end

function gotoCastleCamera(dt)
	if objects.birdCameraData[deviceModel] ~= nil then
		local ccd = objects.castleCameraData[deviceModel]
		local wx, wy = ccd.px, ccd.py
		local springFactor = dt * 4

		animationWorldScale = animationWorldScale - (animationWorldScale - ccd.sx) * springFactor
		animationScreen.x = animationScreen.x - (animationScreen.x - wx) * springFactor
		animationScreen.y = animationScreen.y - (animationScreen.y - wy) * springFactor
		
		cameraAnimationSliderTarget = 1
		cameraAnimationSlider = 1
		screen.x = animationScreen.x
		screen.y = animationScreen.y
		worldScale = animationWorldScale
		setWorldScale(worldScale)		
	end
	--doItAllCamera(dt)
	defaultCamera(dt)
end

function launchCamera(dt)
	--print("launch camera\n")

	if castleCameraTimer < 3 then
		castleCameraTimer = castleCameraTimer + dt
		defaultCamera(dt)
		return
	end
	
	if objects.birdCameraData and objects.birdCameraData[deviceModel] ~= nil then
		local ccd = objects.castleCameraData[deviceModel]
		local bcd = objects.birdCameraData[deviceModel]
		local wx, wy = bcd.px, bcd.py
		local springFactor = dt * 4

		animationWorldScale = animationWorldScale - (animationWorldScale - bcd.sx) * springFactor
		animationScreen.x = animationScreen.x - (animationScreen.x - wx) * springFactor
		animationScreen.y = animationScreen.y - (animationScreen.y - wy) * springFactor
		
		cameraAnimationSlider = (bcd.px - animationScreen.x)/(bcd.px - ccd.px)
		--print("bird camera cas: " .. cameraAnimationSlider .. "\n")		
		screen.x = animationScreen.x
		screen.y = animationScreen.y
		worldScale = animationWorldScale
		setWorldScale(worldScale)		

		if _G.math.abs(worldScale - ccd.sx) < 0.05 and
			_G.math.abs(screen.x - wx) < 5 and
			_G.math.abs(screen.y - wy) < 5 then
			worldScale = bcd.sx
			setWorldScale(worldScale)
			screen.x = wx
			screen.y = wy
			cameraFunction = defaultCamera
			castleCameraTimer = 0
			cameraAnimationSlider = 0
			--print("Launch camera in place!\n")
		end
	end
	defaultCamera(dt)
end


-------------------------------------------------------------------------------
-- The Others

function setPositions(xadd, yadd)
	for k, v in _G.pairs(selectedObjects) do
		setPosition(v.name, v.x + xadd*physicsScale, v.y + yadd*physicsScale)
		setSleeping(v.name, false)
	end
	levelSaved = false
end

-- scale update, when animated or user controlled
function updateScale()
	if oldScale ~= worldScale then
		local wx = cursor.x / oldScale + screen.left
		local wy = cursor.y / oldScale + screen.top
		local newx = (wx * worldScale - cursor.x) / worldScale
		local newy = (wy * worldScale - cursor.y) / worldScale

		screen.x = newx + screenWidth * 0.5 / worldScale
		screen.y = newy + screenHeight * 0.5 / worldScale
	end
	oldScale = worldScale
end


function birdCollision(object1, object2, force, damage)
	local obj1 = objects.world[object1]
	local obj2 = objects.world[object2]
	
	-- update score
	if obj1.controllable and damage > 0 then
		local bird = obj1
		
		local resultDamage = damage * 10
		_G.table.insert(floatingScores, { x = bird.x, y = bird.y, text = "" .. resultDamage, score = resultDamage, time = 0, lifetime = 0.6, maxScale = floatingScoreScaling * (0.25 + resultDamage / 3000), xs = 0 } )

		if scoreTable[object1] == nil then
			scoreTable[object1] = {}
			scoreTable[object1].score = 0
			--scoreTable[object1].blockDestroyedScore = blockDestroyedScoreIncrement
		end

		scoreTable[object1].score = scoreTable[object1].score + resultDamage
		
	end
	-- bird has been launched
	
	-- Willhelm Tell and Bull's Eye achievement check
	-- if both are birds..
	
	
	
	if obj1.shot and obj2.shot then
		-- ..and none of them has collided and are not eagle baits
		if not(obj1.hasCollided) and not(obj2.hasCollided) and not(obj1.isEagleBait) and not(obj2.isEagleBait) then
			if (obj1.parentName == nil or obj2.parentName == nil) or (obj1.parentName ~= obj2.parentName) then
				--print("Wilhelm Tell achieved! bird "..obj1.name.." has collided with target bird "..obj2.name )
				obj1.hasCollided, obj2.hasCollided = true, true
				if eagleBaitLaunched ~= true then
					settingsWrapper:setWilhelmTell()
					eventManager:notify({id = events.EID_BIRDS_COLLIDED_ON_FLY})
				end
			end
		-- if mighty eagle collides eagle bait, remove bait by frozing it
		elseif obj1.isMightyEagle and obj2.isEagleBait then
			obj2.frozen = true
		elseif obj2.isMightyEagle and obj1.isEagleBait then
			obj1.frozen = true
		end
	-- else if one is a bird and the other is a pig
	elseif obj1.shot and obj2.levelGoal and not settingsWrapper:getBullsEye() then
		if not(obj1.hasCollided) and (obj2.x - levelStartPosition.x) > 75 then
			--print("Bull's eye achieved! bird "..obj1.name.." has collided with target pig "..obj2.name)
			obj1.hasCollided = true
			if eagleBaitLaunched ~= true then
				eventManager:notify({id = events.EID_ACHIEVEMENT_BULLSEYE})
				settingsWrapper:setBullsEye()
			end
		end
	elseif obj2.shot and obj1.levelGoal and not settingsWrapper:getBullsEye() then
		if not(obj2.hasCollided) and (obj1.x - levelStartPosition.x) > 75 then
			--print("Bull's eye achieved! bird "..obj2.name.." has collided with target pig "..obj1.name)
			obj2.hasCollided = true
			if eagleBaitLaunched ~= true then
				eventManager:notify({id = events.EID_ACHIEVEMENT_BULLSEYE})
				settingsWrapper:setBullsEye()
			end
		end
	-- else just ignore it and set hasCollided to true
	elseif obj1.shot then
		obj1.hasCollided = true
	elseif obj2.shot then
		obj2.hasCollided = true
	end
	
	if obj1.shot then
		local bDef = getObjectDefinition(obj1.name)
		local birdSpecialty = bDef.specialty
		if bDef.spriteCollision ~= nil then
			if birdSpecialty == "GRENADE" then
				if birdSpecialtyAvailable then
					objects.world[obj1.name].sprite = bDef.spriteCollision
					setSprite(obj1.name, objects.world[obj1.name].sprite)
				end
			else
				objects.world[obj1.name].sprite = bDef.spriteCollision
				setSprite(obj1.name, objects.world[obj1.name].sprite)
			end
		end
	end
	
	if obj1.hatcheryBird and selectedBird ~= obj1 and selectedBird ~= obj2 then
		obj1.hatcheryBird:collided(obj1, obj2)
	end
	if obj2.hatcheryBird and selectedBird ~= obj1 and selectedBird ~= obj2 then
		obj2.hatcheryBird:collided(obj2, obj1)
	end		
	
	-- bird has been launched
	if flyingBird ~= nil and (flyingBird.name == object1 or flyingBird.name == object2) then			
		
		-- if birds collide camera target object is not reset nor is collision timer set
		if obj1.controllable ~= true or obj2.controllable ~= true then
			if cameraTargetObject ~= nil then
				if cameraTargetObject == obj1 or cameraTargetObject == obj2 then
					--print("Setting camera target object to nil in bird collision.\n")
					cameraTargetObject = nil
					animationScreen.x = screen.x
					animationScreen.y = screen.y
					animationWorldScale = worldScale
				end
			end
		end
		
		local bDef = getObjectDefinition(flyingBird.name)
		local birdSpecialty = bDef.specialty

		if flyingBird.hatcheryBird then
			--if hatchery bird, don't do anything (already handled)
			--flyingBird.hatcheryBird:collided(flyingBird)
		elseif birdSpecialty ~= "BOMB" and birdSpecialty ~= "GLOBE" then
			birdSpecialtyAvailable = false
			
			
			if bDef.spriteCollision ~= nil then
				if birdSpecialty == "GRENADE" then
					if birdSpecialtyAvailable then
						objects.world[flyingBird.name].sprite = bDef.spriteCollision
						setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
					end
				else
					objects.world[flyingBird.name].sprite = bDef.spriteCollision
					setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				end
			end			
			
			
			
			if birdSpecialty == "SUMMON_MIGHTY_EAGLE" then
				if flyingBird.collision ~= true and eagleTimer == nil then
					eagleTimer = 8.7
					eagleMoving = true
					--birdSpecialtyAvailable = true
					--print("Summon mighty eagle.\n")
				end
			end
		elseif birdSpecialty == "BOMB" then
			if flyingBird.collision ~= true then
				objects.world[flyingBird.name].bombTimer = 1.5
				objects.world[flyingBird.name].damageSprite = "BIRD_GREY_1"
				objects.world[flyingBird.name].sprite = objects.world[flyingBird.name].damageSprite
				setSprite(flyingBird.name, objects.world[flyingBird.name].sprite)
				birdSpecialtyAvailable = true
			end			
		elseif birdSpecialty == "GLOBE" then
			if flyingBird.collision ~= true then
				objects.world[flyingBird.name].globeTimer = 1.5
				birdSpecialtyAvailable = true
			end
		end
		
		-- set collision flag to true
		flyingBird.collision = true
		
	end
	
	if obj1.controllable then
		local bird = obj1
		local bDef = getObjectDefinition(bird.name)
		local birdSpecialty = bDef.specialty
		if birdSpecialty == "BOOMERANG" then
			bird.boomerangActive = false
		end
	end
	
	if obj2.controllable then
		local bird = obj2
		local bDef = getObjectDefinition(bird.name)
		local birdSpecialty = bDef.specialty
		if birdSpecialty == "BOOMERANG" then
			bird.boomerangActive = false
		end
	end
	
	--set collision flags
	if obj1.shot and obj1.controllable then
		obj1.collision = true
		-- bird to bird collision does not stop trajectory recording
		if obj2.controllable ~= true then
			obj1.recordTrajectory = false
		end
	end
	if obj2.shot and obj2.controllable then
		obj2.collision = true
		-- bird to bird collision does not stop trajectory recording
		if obj1.controllable ~= true then
			obj2.recordTrajectory = false
		end
	end	
	
	-- mark the granade to explode
	for i = #flyingGrenades, 1, -1 do
		local flyingGrenade = flyingGrenades[i].name
		if flyingGrenade == object1 and obj2.controllable ~= true or
			flyingGrenade == object2 and obj1.controllable ~= true then
			flyingGrenades[i].explode = true
			if object1 == flyingGrenade then
				object1 = nil
			end
		end
		
		if object1 == flyingGrenade and obj2.controllable == true then
			return
		end
		if object2 == flyingGrenade and obj1.controllable == true then
			return
		end
	end
	
	--local particleAmount = _G.math.random(12,20)
	
	if object1 ~= nil then
		if objects.world[object1].definition == "MightyEagleBird" and objects.world[object2].definition == "BaitSardine" then
			objects.world[object2].strength = 0
		elseif objects.world[object1].lowerThanGround or (objects.world[object1].definition == "MightyEagleBird" and object2 == "ground")  then
			objects.world[object1].hitGround = true
			cameraShake = 100
			local bDef = getObjectDefinition(objects.world[object1].name)
			bDef.spriteCollision = "BIRD_MIGHTY_EAGLE_RADIAL"
			objects.world[object1].sprite = bDef.spriteCollision
			setSprite(object1, objects.world[object1].sprite)						
			_G.res.playAudio("mighty_eagle_thump", 1, false)
			for k, v in _G.pairs(objects.world) do
				if v.strength ~= nil and v.levelGoal then
					local force = -v.mass * 15
					applyImpulse( v.name,
								0,
								force,
								v.x,
								v.y )
					v.strength = 0.0001
					v.defence = 0
				elseif v.isEagleBait then
					v.strength = 0
				end
			end
			-- delete all joints later in updateGame
			destroyJoints = true
			eagleTimer = 4
		end
	
		local birdie = birds[object1]
		local birdieStartForce = 0
		
		if object2 ~= nil and (getObjectDefinition(object2).material == "immovable" or getObjectDefinition(object2).material == "staticGround") then
			if birdie ~= nil and birdie.xVel ~= nil and birdie.yVel ~= nil then
				birdieStartForce = (vLength(birdie.xVel, birdie.yVel) * birdie.mass) / 10.0
			end
		end
		
		
		if force > collisionParticleForceThreshold or birdieStartForce > collisionParticleForceThreshold then
		 
			--print("Material: " .. getObjectDefinition(object2).material .. "\n")
			-- play either collision or damage sound
			local mat = blockTable.materials[getObjectDefinition(object2).material]
			if mat ~= nil then
				local sound = mat.collisionSound
				if damage > 10 then
					sound = mat.damageSound or sound
				end
				if sound ~= nil then
					_G.res.playAudio(getAudioName(sound), 0.7, false, 2)
				end
			end
			--print("Object: " .. object1 .. "\n")
			local particle = getObjectDefinition(object1).particles
			--print("particles: " .. particle .. "\n")
			local particleAmount = _G.math.random(12, 20)
			if getObjectDefinition(object1).particlesAmountLimits ~= nil then
				particleAmount = _G.math.random(getObjectDefinition(object1).particlesAmountLimits[1], getObjectDefinition(object1).particlesAmountLimits[2])
			end
			addParticles(object1, particle, particleAmount, false,false)
			
			-- scale volume with collision force
			local volume = 0.7
			if birdie ~= nil then
				local maxForce = ((60.0 * birdie.mass) / 10.0)
				local dmgFactor = blockTable.damageFactors[birdie.damageFactors].damageMultiplier[getObjectDefinition(object2).material]
				if dmgFactor ~= nil and dmgFactor > 1 then
					maxForce = maxForce * dmgFactor
				end
				volume = _G.math.min(_G.math.max(_G.math.max(force, birdieStartForce) / maxForce, 0.20), 1.0)
			end
					
			-- bird sound
			if getObjectDefinition(object1).collisionSound ~= nil then
				_G.res.playAudio(getAudioName(getObjectDefinition(object1).collisionSound), volume, false, 2)
			end
		end
	end
	
	if obj2.controllable ~= true then
		local sprites = getDamageSprite(obj2, blockTable.blocks)
		obj2.damageSprite = sprites.sprite
		obj2.blinkSprite = sprites.blink
		obj2.smileSprite = sprites.smile
	end



end	
	
function blockCollision(object1, object2, force, wasDamageDone)
	
	if wasDamageDone then
		local obj1 = objects.world[object1]
		local sprites = getDamageSprite(obj1, blockTable.blocks)
		local dmgSprite = sprites.sprite
		if dmgSprite ~= obj1.damageSprite then
			obj1.damageSprite = dmgSprite
			obj1.blinkSprite = sprites.blink
			obj1.smileSprite = sprites.smile			
			if getObjectDefinition(object1).damageSound ~= nil then
				_G.res.playAudio(getAudioName(getObjectDefinition(object1).damageSound), 0.5, false, 2)
			end
		end
		
		local obj2 = objects.world[object2]
		local sprites = getDamageSprite(obj2, blockTable.blocks)
		local dmgSprite = sprites.sprite		
		if dmgSprite ~= obj2.damageSprite then
			obj2.damageSprite = dmgSprite
			obj2.blinkSprite = sprites.blink		
			obj2.smileSprite = sprites.smile
			if getObjectDefinition(object2).damageSound ~= nil then
				_G.res.playAudio(getAudioName(getObjectDefinition(object2).damageSound), 0.5, false, 2)
			end
		end
	end

	if force > collisionSoundForceThreshold then
		--print("Material: " .. getObjectDefinition(object1).material .. "\n")
		local material1 = blockTable.materials[getObjectDefinition(object1).material]
		local material2 = blockTable.materials[getObjectDefinition(object2).material]
		if material1 ~= nil then
			_G.res.playAudio(getAudioName(blockTable.materials[getObjectDefinition(object1).material].collisionSound), 0.5, false, 2)
		end

		--print("Material: " .. getObjectDefinition(object2).material .. "\n")
		if material2 ~= nil and material2 ~= material1 then
			_G.res.playAudio(getAudioName(blockTable.materials[getObjectDefinition(object2).material].collisionSound), 0.5, false, 2)
		end
	end
end


function addParticles(object, particle, amount, ignoreLimits, menu)
	
	local obj = objects.world[object]
	if obj == nil then
		return
	end

	local x, y = physicsToWorldTransform(obj.x, obj.y)
	local w, h = 1, 1
	if obj.radius == nil then
		w, h = physicsToWorldTransform(obj.width, obj.height)
	else
		w, h = physicsToWorldTransform(obj.radius*2, obj.radius*2)
	end

	
	
	if particle[1] then
		for i = 1, #particle do
			
			if particleTable.particles[particle[i] ].amount then
				amount = particleTable.particles[particle[i] ].amount
			end
			
			newParticles(particle[i], amount, x, y, w, h, getAngle(obj.name), ignoreLimits, menu)
		end
	else
		
		newParticles(particle, amount, x, y, w, h, getAngle(obj.name), ignoreLimits, menu)		
	end		
end

function globeBirdDeath(object)
    local name = "GlobeDeath"
    
    local def = blockTable.blocks.GlobeBirdBig
    createCircle(name, def.sprite, object.x, object.y, def.radius, 0.000001, 0, def.restitution, object.controllable, object.z_order)
    
    objects.world[name].definition = "GlobeBirdBig"
    objects.world[name].controllable = def.controllable
    objects.world[name].strength = def.strength
    objects.world[name].defence = def.defence
    objects.world[name].material = def.material
    objects.world[name].levelGoal = def.levelGoal
    objects.world[name].damageFactors = def.damageFactors
    
    local xp, yp = _G.res.getSpritePivot("", def.sprite)
    objects.world[name].spritePivotX = xp
    objects.world[name].spritePivotY = yp
    objects.world[name].damageSprite = def.damageSprite
    objects.world[name].useLegacyCollisionPath = def.useLegacyCollisionPath
    objects.world[name].shot = true
    objects.world[name].isGlobeDeath = true
    objects.world[name].updateCount = 0
    objects.world[name].deathTimerFull = 1.5
    objects.world[name].deathTimer = object.deathTimer or objects.world[name].deathTimerFull
    objects.world[name].scale = 1
    objects.world[name].directionChangeTimer = object.directionChangeTimer or 0
    objects.world[name].xVel = object.xVel
    objects.world[name].yVel = object.yVel
    setRotation(name, object.angle)
    setVelocity(name, object.xVel, object.yVel)
    birds[name] = objects.world[name]
    
	local k = object.name
    
    if cameraTargetObject == object then
		cameraTargetObject = nil
	end
	
	if currentBirdName == k then
		currentBirdName = nil
	end
	if flyingBird == object then
		flyingBird = nil
		birdSpecialtyAvailable = false
	end
	
	removeObject(k)
	objects.world[k] = nil
	birds[k] = nil
	otherBirds[k] = nil

	_G.res.playAudio(getAudioName("Globe_Bird_Death_remove_1"), 1, false)
end



function removeBird(object)
	local k = object.name
	
    local globeDeath = (object.finalGlobe == true)

	-- check that we really find object definition, if globe bird is removed due to being offs playing area, it might already be removed from world
	local particles = getObjectDefinition(k)
	if particles ~= nil then
		particles = particles.particles
	end
	
    if globeDeath then
        globeBirdDeath(object)
        return
    end
	
	
	if particles ~= nil and object.definition ~= "GlobeBird" and object.definition ~= "GlobeBirdBig" then
		addParticles(k, getObjectDefinition(k).particles , 10, false, globeDeath)	
	end
	
	
	
	if cameraTargetObject == object then
		--print("--------------   Remove bird: setting camera target object to nil\n")
		cameraTargetObject = nil
	end
	
	if currentBirdName == k then
		currentBirdName = nil
	end
	if flyingBird == object then
		flyingBird = nil
		birdSpecialtyAvailable = false
	end
	
	removeObject(k)
	objects.world[k] = nil
	birds[k] = nil
	otherBirds[k] = nil

	--print(_G.tostring(object.definition))
	if not object.isGlobeDeath and object.definition ~= "GlobeBird" and object.definition ~= "GlobeBirdBig" then
		_G.res.playAudio(getAudioName("bird_destroyed"), 1, false)
	end
end

-- This function finds the definition of the given level object based on its name
function getObjectDefinition(name)
	return blockTable.blocks[objects.world[name].definition]
end

-- returns the next bird name or nil if bird not found
function getNextBird(index)
	--print("Getting next bird: " .. index .. "\n")
	for k, v in _G.pairs(birds) do
		if v.controllable then
			if v.startNumber == index then
				return k
			end
		end
	end

	return nil
end

-- TODO: parse piglettes to own table
function checkLevelComplete()
	if eagleBaitLaunched == true and (eagleTimer == nil or eagleTimer > 0) then
		return false
	end
	if not levelTimeout then
		if hasMovingObjects and objects.doNotWaitForMovingObjects ~= true then
			return false
		end
	end
	for k, v in _G.pairs(levelGoals) do
		if v.levelGoal then
			return false
		end
	end
	return true
end

function checkLevelGoalsDestroyed()
	for k, v in _G.pairs(levelGoals) do
		if v.levelGoal then
			return false
		end
	end	
	return true
end

function checkLevelFailed()
	if not levelTimeout then
		if hasMovingObjects and objects.doNotWaitForMovingObjects ~= true then
			return false
		end
	end
	
		for k, v in _G.pairs(birds) do
			if v.controllable then
				return false
			end
		end
	if g_currentChallenge and g_currentChallenge.type == "BIRD_FLOCK" then
		if #g_currentChallengeProgress.shotsQueue > 0 then
			return false
		end
	end
	
	return true
end

function getDamageSprite(object, definitions)
	local sprites = {}
	sprites.sprite = object.sprite
	sprites.blink = object.sprite
	sprites.smile = object.sprite
	
	if object.definition == nil or object.definition == "" then
		return sprites
	end

	if definitions[object.definition] == nil then
		return sprites
	end

	if definitions[object.definition].damageSprites == nil then
		return sprites
	end

	if object.strength == nil then
		return sprites
	end

	local percentage = (object.strength / definitions[object.definition].strength) * 100
	for k, v in _G.pairs(definitions[object.definition].damageSprites) do
		if v.min < percentage and v.max >= percentage then
			setSprite(object.name, v.sprite)
			sprites.sprite = v.sprite
			sprites.blink = v.sprite
			sprites.smile = v.sprite
			if v.blinkSprite ~= nil then
				sprites.blink = v.blinkSprite
			end
			if v.smileSprite ~= nil then
				sprites.smile = v.smileSprite
			end
			return sprites
		end
	end

	-- fail safe
	return sprites
end


function makeExplosion(object, definition, sound)
	if definition.explosionForce ~= nil then
		if sound ~= nil then
			_G.res.playAudio(sound, 0.7, false, 1)
		end
		addParticles(object.name, "explosion", 1, true,false)
		addParticles(object.name, "explosionBuff", 1, true,false)

		for k, v in _G.pairs(objects.world) do
			if v.controllable or object == v then
				--do nothing
			else
				local dist = vLength(v.x - object.x, v.y - object.y)
				if dist < definition.explosionRadius then
					local x, y = vNormalize(v.x - object.x, v.y - object.y)
					local force = physicsScale * definition.explosionForce / dist
					applyImpulse( k,
								x * force,
								y * force,
								v.x,
								v.y )
				end
				if dist < definition.explosionDamageRadius then
					if v.defence < definition.explosionDamage/dist then
						v.strength = v.strength - definition.explosionDamage/dist
						local sprites = getDamageSprite(v, blockTable.blocks)
						v.damageSprite = sprites.sprite
						v.blinkSprite = sprites.blink
						v.smileSprite = sprites.smile
						if v.strength <= 0 then
							deadBlocks[k] = v
						end
						--print("st: " .. v.strength .. "\n")
					end
				end
			end
		end
	end
end

function makeClickExplosion(objectX, objectY, explosionForce, explosionRadius, explosionDamage, explosionDamageRadius, sound)
	if sound ~= nil then
		_G.res.playAudio(sound, 0.7, false, 1)
	end

	local wx, wy = physicsToWorldTransform(objectX, objectY)
	newParticles("explosion", 1, wx, wy, 4, 4, 0, false,false)
	newParticles("explosionBuff", 1, wx, wy, 4, 4, 0,false,false)

	for k, v in _G.pairs(objects.world) do
		local dist = vLength(v.x - objectX, v.y - objectY)
		local x, y = vNormalize(v.x - objectX, v.y - objectY)
		if dist < explosionRadius then
			local force = physicsScale * explosionForce / dist
			applyImpulse( k,
						x * force,
						y * force,
						v.x,
						v.y )
		end
		if dist < explosionDamageRadius then
			if v.defence ~= nil and v.defence < explosionDamage/dist then
				v.strength = v.strength - explosionDamage/dist
				local sprites = getDamageSprite(v, blockTable.blocks)
				v.damageSprite = sprites.sprite
				v.blinkSprite = sprites.blink
				v.smileSprite = sprites.smile
				--print("st: " .. v.strength .. "\n")
			end
		end
	end
end


-------------------------------------------------------------------------------
-- Miscellaneous stuff


function worldToPhysicsTransform(x, y)
	local px = x * physicsScale
	local py = y * physicsScale
	return px, py
end

function worldToScreenTransform(x, y)
	local sx = (x - screen.left) * worldScale
	local sy = (y - screen.top) * worldScale
	return sx, sy
end

function screenToWorldTransform(x, y)
	local wx = x / worldScale + screen.left
	local wy = y / worldScale + screen.top
	return wx, wy
end

function physicsToWorldTransform(x, y)
	local wx = x * physicsToWorld
	local wy = y * physicsToWorld
	return wx, wy
end

function physicsToScreenTransform(x, y)
	local wx, wy = physicsToWorldTransform(x, y)
	local sx, sy = worldToScreenTransform(wx, wy)
	return sx, sy
end

function screenToPhysicsTransform(x, y)
	local wx, wy = screenToWorldTransform(x, y)
	local px, py = worldToPhysicsTransform(wx, wy)
	return px, py
end

function distance(x1,y1,x2,y2)
	local dx = x2-x1
	local dy = y2-y1
	return _G.math.sqrt(dx*dx+dy*dy)
end

-- returns current time in seconds from start of the month
function currentTime()
	local timeNow = { d = _G.os.date("%d")*1, h = _G.os.date("%H")*1, m = _G.os.date("%M")*1, s = _G.os.date("%S")*1 }
	return timeNow
end

-- returns difference between t1 and t2 in seconds, t2 must be greater than t1 and max diffrence is limited to one day
function timeDiff(t2, t1)
	local temp1 = (t1.h * 60 * 60) + (t1.m * 60) + (t1.s)
	local temp2 = (t2.h * 60 * 60) + (t2.m * 60) + (t2.s)
	if t2.d ~= t1.d then
		temp2 = temp2 + (24 * 60 * 60)
	end
	--print("timeDiff: " .. (temp2 - temp1) .. "\n")
	return (temp2 - temp1)
end

-- formats time given in seconds to (h)h:mm:ss if it's more than 1 hour or to (m)m:ss if it's less than 1 hour
function formatTime(inputTime)
	local timeText = ""
	local hours = _G.string.format("%d", _G.math.floor(inputTime / 3600))
	local minutes = _G.string.format("%d", _G.math.floor(_G.math.fmod(inputTime, 3600) / 60))
	local seconds = _G.string.format("%d", _G.math.fmod(_G.math.fmod(inputTime, 3600), 60))
	if inputTime >= 3600 then
		minutes = "00" .. minutes
		minutes = _G.string.sub(minutes, #minutes -1, #minutes)
		seconds = "00" .. seconds
		seconds = _G.string.sub(seconds, #seconds -1, #seconds)
		timeText = hours .. ":" .. minutes .. ":" .. seconds
	else
		seconds = "00" .. seconds
		seconds = _G.string.sub(seconds, #seconds -1, #seconds)
		timeText = minutes .. ":" .. seconds
	end
	return timeText
end

function checkObjectBounds(x, y, width, height, angle, cursorX, cursorY)	 
	local cx = cursorX - x
	local cy = cursorY - y
	
	local tcx = cx * _G.math.cos(angle) + cy * _G.math.sin(angle)
	local tcy = -cx * _G.math.sin(angle) + cy * _G.math.cos(angle)

	local halfWidth = width * 0.5
	local halfHeight = height * 0.5
	
	local left = -halfWidth
	local top = -halfHeight
	local right = halfWidth
	local bottom = halfHeight
	
	if tcx >= left and tcx < right then
		if tcy >= top and tcy < bottom then
			return true
		end
	end
	return false
end


function checkPolygonObjectBounds(x, y, width, height, angle, vertices, cursorX, cursorY)	 
	local cx = cursorX - x
	local cy = cursorY - y
	
	local tcx = cx * _G.math.cos(angle) + cy * _G.math.sin(angle)
	local tcy = -cx * _G.math.sin(angle) + cy * _G.math.cos(angle)
	
	local tVerts = {}
	
	for i = 1, #vertices do
		tVerts[i] = {}
		tVerts[i].x = vertices[i].x * width - 0.5*width
		tVerts[i].y = vertices[i].y * height - 0.5*height
	end
	
	return testPointInPolygon(tcx, tcy, tVerts)
end


function checkBounds(left, top, w, h, cursorX, cursorY, angle, hanchor, vanchor)
	if hanchor and vanchor then
		if hanchor == "HCENTER" then
			left = left - w * 0.5
		elseif hanchor == "LEFT" then
			left = left + w
		elseif hanchor == "RIGHT" then
			left = left - w
		end
		if vanchor == "VCENTER" then
			top = top - h * 0.5
		elseif vanchor == "TOP" then
			top = top + h
		elseif vanchor == "BOTTOM" then
			top = top - h
		end
	end
	
	if cursorX >= left and cursorX < left + w then
		if cursorY >= top and cursorY < top + h then
			return true
		end
	end
	return false
	
end

function checkTextBounds(textGroup, text, hanchor, vanchor, x, y, cursorX, cursorY)
	local w = _G.res.getStringWidth(_G.res.getString(textGroup, text))
	local h = _G.res.getFontLeading()
	--print("String width " .. text .. " " .. w .. "\n")
	--print("Font leading " .. h .. "\n")
	if hanchor == nil then
		x = x - w * 0.5
	elseif hanchor == "RIGHT" then
		x = x - w
	elseif hanchor == "HCENTER" then
		x = x - w * 0.5
	end

	if vanchor == nil then
		y = y - h * 0.5
	elseif vanchor == "BOTTOM" then
		y = y - h
	elseif vanchor == "VCENTER" then
		y = y - h * 0.5
	end

	return checkBounds(x, y, w, h, cursorX, cursorY)
end

function checkSpriteBounds(sheet, sprite, x, y, cursorX, cursorY)
	local w, h = _G.res.getSpriteBounds(sheet, sprite)
	local px, py = _G.res.getSpritePivot(sheet, sprite)

	return checkBounds(x - px, y - py, w, h, cursorX, cursorY)
end


function getObjectsInsideRect(x1, y1, x2, y2)
	if x1 > x2 then
		x1, x2 = x2, x1
	end
	if y1 > y2 then
		y1, y2 = y2, y1
	end

	local t = {}

	for k, v in _G.pairs(objects.world) do
		x, y = physicsToWorldTransform(v.x, v.y)
		if x > x1 and x <= x2 then
			if y > y1 and y <= y2 then
				if v.name ~= "ground" then
					_G.table.insert(t, v)
				end
			end
		end
	end

	return t
end


function getThemeObjectsInsideRect(x1, y1, x2, y2, layer)
	if x1 > x2 then
		x1, x2 = x2, x1
	end
	if y1 > y2 then
		y1, y2 = y2, y1
	end

	local t = {}

	for k, v in _G.pairs(themeSpriteObjects) do
		
		x, y = physicsToWorldTransform(v.x, v.y)
		
		if v.layer == layer and x > x1 and x <= x2 and y > y1 and y <= y2 then			
			_G.table.insert(t, v)						
		end
	end

	return t
end


function testPointInPolygon(x, y, vertices)
	local s = #vertices
	local e = 1
	local counter = 0
	
	while e <= #vertices do
		-- check that the line is not below this point
		if y > _G.math.min(vertices[s].y, vertices[e].y) then
			-- check that the line is not above this point
			if y <= _G.math.max(vertices[s].y, vertices[e].y) then
				-- check that the line is to the right from this point
				if x <= _G.math.max(vertices[s].x, vertices[e].x) then
					-- horizontal lines are ignored
					if vertices[s].y ~= vertices[e].y then
						local crossPointX = (y - vertices[s].y) * (vertices[e].x - vertices[s].x) / (vertices[e].y - vertices[s].y) + vertices[s].x
						if vertices[s].x == vertices[e].x or x < crossPointX then
							counter = counter + 1
						end
					end
				end
			end
		end
		
		s = e
		e = e + 1
	end
	
	if counter % 2 == 0 then
		return false
	end
	
	return true
end

--[[
ks Spring constant.
kd Spring damping constant.
r Distance to rest length.
v Spring velocity

Usage: springspeed += dampedSpring(0.8,0.5,distancetorest,springspeed) * dt
springlength += springspeed * dt
]]
function dampedSpring(ks, kd, r, v)
	return (ks * r) - (kd * v)
end

--[[
Calculates 2 times the signed triangle area. <br>

Algorithm from "Real time collision detection" by Christer Ericson, page 152.

@param aX Point A x-component
@param aY Point A y-component
@param bX Point B x-component
@param bY Point B y-component
@param cX Point C x-component
@param cY Point C y-component
The result is positive if abc is ccw, negative if abc is cw, zero if abc is degenerate.
]]
function signed2DTriArea(aX, aY, bX, bY, cX, cY)
	return (aX - cX) * (bY - cY) - (aY - cY) * (bX - cX)
end

--[[
Test if segments ab and cd overlap. If they do, compute intersection value t along ab and
intersection position p. <br>

Algorithm from "Real time collision detection" by Christer Ericson, page 152-153.
]]
function test2DSegmentSegment(aX, aY, bX, bY, cX, cY, dX, dY, findPoint)

	local instersectionValue, intersectionPoint = nil, nil

	-- Compute winding of abd (+ or -)
	local a1 = signed2DTriArea(aX, aY, bX, bY, dX, dY)
	-- To intersect, must have sign opposite of a1
	local a2 = signed2DTriArea(aX, aY, bX, bY, cX, cY)

	-- If c and d are on different sides of ab, areas have different signs
	if a1 ~= 0 and a2 ~= 0 and a1 * a2 < 0 then
		-- Compute signs for a and b with respect to segment cd
		local a3 = signed2DTriArea(cX, cY, dX, dY, aX, aY) -- Compute winding of cda (+ or -)
		-- Since area is constant a1 - a2 = a3 - a4, or a4 = a3 + a2 - a1
		local a4 = a3 + a2 - a1
		-- Points a and b on different sides of cd if areas have different signs
		if(a3 ~= 0 and a4 ~= 0 and a3 * a4 < 0) then
			if(findPoint == true) then -- Test if we want to get also intersection value and point
				-- Segments intersect. Find intersection point along L(t) = a + t * (b - a).
				-- Given height h1 of an over cd and height h2 of b over cd,
				-- t = h1 / (h1 - h2) = (b*h1/2 - b*h2/2) = a3 / (a3 - a4),
				-- where b ( the base of the triangles cda and adb, i.e., the length
				-- of cd) cancels out.
				intersectionValue = a3 / (a3 - a4)
				intersectionPoint = { x = aX + intersectionValue * (bX - aX), y = aY + intersectionValue * (bY - aY) }
			end
			return true, instersectionValue, intersectionPoint
		end
	end
	return false -- Segments do not intersect (or collinear)
end

function vLength(x, y)
	local len = _G.math.sqrt(x * x + y * y)
	return len

end

function vLengthsq(x, y)
	local len = (x * x + y * y)
	return len
end


function vNormalize(x, y)
	local len = _G.math.sqrt(x * x + y * y)
	return x/len, y/len
end

-------------------------------------------------------------------------------
-- Floating scores

function updateFloatingScores(dt)
	-- update floating scores
	local i = 1
	while i <= #floatingScores do
		local fs = floatingScores[i]
		fs.time = fs.time + dt

		if fs.time < 0.25 then
			fs.xs = fs.maxScale * fs.time / 0.25
		else
			if fs.time < fs.lifetime - 0.25 then
				fs.xs = fs.maxScale
			else
				fs.xs = fs.maxScale * (fs.lifetime - fs.time) / 0.25
			end
		end

		if floatingScores[i].time > floatingScores[i].lifetime then
			_G.table.remove(floatingScores, i)
		else
			i = i + 1
		end
	end
end

-------------------------------------------------------------------------------
-- Animations

function newAnimation(name, state, page, speedIn, speedOut)
	local v = {}
	v.page = page
	v.state = state
	v.percentage = 0
	v.speedIn = speedIn
	v.speedOut = speedOut
	v.name = name
	elementAnimations[name] = v
end

function updateAnimations(dt)
	for k, v in _G.pairs(elementAnimations) do
		if v.state == "ENTERING" then
			v.percentage = v.percentage + v.speedIn * dt
			if v.percentage > 100 then
				v.percentage = 100
				v.state = "VISIBLE"
				v.page.state = "READY"
			end
		elseif v.state == "VISIBLE" then
		elseif v.state == "EXITING" then
			v.percentage = v.percentage - v.speedOut * dt
			if v.percentage < 0 then
				v.percentage = 0
				v.state = "HIDDEN"
				v.page.state = "DISABLED"
				--[[
				if k == "ingamePausePageScroll" then
					--onExitPage(pausePage)
					
					-- continue game after pause menu has scrolled out
					if deviceModel == "iphone4" and (birdTutorialPopups == nil or #birdTutorialPopups == 0) then
						changeResolution = true
						wantedResolution = "FULL"
						resolutionChanged = true
					end
					setGameMode(updateGame)
					setPhysicsEnabled(true)
				end]]
			end
		end
	end
end

function setAnimationState(animation, state)
	--[[
	local v = elementAnimations[animation]
	if state == "ENTERING" then
		if v.state == "HIDDEN" then
			v.state = state
			v.percentage = 0
			v.page.state = "DISABLED"
		elseif v.state == "EXITING" then
			v.state = state
		end
	elseif state == "VISIBLE" then
		if v.state == "ENTERING" or v.state == "HIDDEN" or v.state == "EXITING" then
			v.state = state
			v.percentage = 100
			v.page.state = "READY"			
		end
	elseif state == "EXITING" then
		if v.state == "VISIBLE" then
			v.state = state
			v.percentage = 100
			v.page.state = "READY"			
		elseif v.state == "ENTERING" then
			v.state = state
		end
	elseif state == "HIDDEN" then
		if v.state == "ENTERING" or v.state == "VISIBLE" or v.state == "EXITING" then
			v.state = state
			v.percentage = 0
			v.page.state = "DISABLED"
		end
	end]]
end


function newParticles(type, amount, x, y, w, h, angle, ignoreLimits, menu)
	local pt = particleTable.particles[type]

	if g_hatcheryEnabled and pt == nil then
		pt = hatcheryParticleTable.particles[type]
	end

	if pt == nil then
		return
	end
	
	if type == nil or type == "" then 
		return
	end
	
	_G.particles.addParticles(type, amount, x, y, w, h, angle, ignoreLimits, menu)
	
	
end
-------------------------------

function getCutsceneBackgroundWidth(sprites)
	local bgWidth = 0
	for k, v in _G.pairs(sprites) do
		if v.isBackground then
			local tsw, _ = _G.res.getSpriteBounds("", v.sprite)
			bgWidth = bgWidth + tsw
		end
	end
	return bgWidth
end

function drawBoxWithTiledBorders( borderSprites, sheet, x1, y1, width, height, hAnchor, vAnchor, color)
	
	local r, g, b, a = 1.0, 1.0, 1.0, 1.0
	if color ~= nil then
		if color.red ~= nil then
			r = color.red
		end
		if color.green ~= nil then
			g = color.green
		end
		if color.blue ~= nil then
			b = color.blue
		end
		if color.alpha ~= nil then
			a = color.alpha
		end
	end
	
	local x2 = x1 + width
	local y2 = y1 + height
	
	-- top (& bottom) part
	local pxTopLeft,   pyTopLeft   = 0, 0
	local pxTopMiddle, pyTopMiddle = 0, 0
	local pxTopRight,  pyTopRight  = 0, 0
	local twTopLeft,   thTopLeft   = 0, 0
	local twTopMiddle, thTopMiddle = 0, 0
	local twTopRight,  thTopRight  = 0, 0
	
	-- left (& right) part
	local pxMiddleLeft, pyMiddleLeft = 0, 0
	local pxBottomLeft, pyBottomLeft = 0, 0
	local twMiddleLeft, thMiddleLeft = 0, 0
	local twBottomLeft, thBottomLeft = 0, 0
		
	-- top (& bottom) part
	if borderSprites.topLeft ~= nil then
		pxTopLeft, pyTopLeft = _G.res.getSpritePivot(sheet, borderSprites.topLeft)
		twTopLeft, thTopLeft = _G.res.getSpriteBounds(sheet, borderSprites.topLeft)
	elseif borderSprites.bottomLeft ~= nil then
		pxTopLeft, pyTopLeft = _G.res.getSpritePivot(sheet, borderSprites.bottomLeft)
		twTopLeft, thTopLeft = _G.res.getSpriteBounds(sheet, borderSprites.bottomLeft)
		borderSprites.topLeft = ""
	else
		borderSprites.topLeft = ""
	end
	if borderSprites.topMiddle ~= nil then
		pxTopMiddle, pyTopMiddle = _G.res.getSpritePivot(sheet, borderSprites.topMiddle)
		twTopMiddle, thTopMiddle = _G.res.getSpriteBounds(sheet, borderSprites.topMiddle)
	elseif borderSprites.bottomMiddle ~= nil then
		pxTopMiddle, pyTopMiddle = _G.res.getSpritePivot(sheet, borderSprites.bottomMiddle)
		twTopMiddle, thTopMiddle = _G.res.getSpriteBounds(sheet, borderSprites.bottomMiddle)
		borderSprites.topMiddle = ""
	else
		borderSprites.topMiddle = ""
	end
	if borderSprites.topRight ~= nil then
		pxTopRight,  pyTopRight  = _G.res.getSpritePivot(sheet, borderSprites.topRight)
		twTopRight,  thTopRight  = _G.res.getSpriteBounds(sheet, borderSprites.topRight)
	elseif borderSprites.bottomRight ~= nil then
		pxTopRight,  pyTopRight  = _G.res.getSpritePivot(sheet, borderSprites.bottomRight)
		twTopRight,  thTopRight  = _G.res.getSpriteBounds(sheet, borderSprites.bottomRight)
		borderSprites.topRight = ""
	else
		borderSprites.topRight = ""
	end
					
	local startXTopMiddle = x1 + twTopLeft - pxTopLeft + pxTopMiddle
	local stopXTopMiddle = x2 - pxTopRight - (twTopMiddle - pxTopMiddle)
	if stopXTopMiddle < startXTopMiddle then
		stopXTopMiddle = startXTopMiddle + 1
	end
	
	-- left (& right) part
	if borderSprites.topLeft ~= nil then
		pxTopLeft, pyTopLeft = _G.res.getSpritePivot(sheet, borderSprites.topLeft)
		twTopLeft, thTopLeft = _G.res.getSpriteBounds(sheet, borderSprites.topLeft)
	elseif borderSprites.topRight ~= nil then 
		pxTopLeft, pyTopLeft = _G.res.getSpritePivot(sheet, borderSprites.topRight)
		twTopLeft, thTopLeft = _G.res.getSpriteBounds(sheet, borderSprites.topRight)
		borderSprites.topLeft = ""
	else
		borderSprites.topLeft = ""
	end
	if borderSprites.left ~= nil then
		pxMiddleLeft, pyMiddleLeft = _G.res.getSpritePivot(sheet, borderSprites.left)
		twMiddleLeft, thMiddleLeft = _G.res.getSpriteBounds(sheet, borderSprites.left)
	elseif borderSprites.right ~= nil then 
		pxMiddleLeft, pyMiddleLeft = _G.res.getSpritePivot(sheet, borderSprites.right)
		twMiddleLeft, thMiddleLeft = _G.res.getSpriteBounds(sheet, borderSprites.right)
		borderSprites.left = ""
	else
		borderSprites.left = ""
	end
	if borderSprites.bottomLeft ~= nil then
		pxBottomLeft, pyBottomLeft  = _G.res.getSpritePivot(sheet, borderSprites.bottomLeft)
		twBottomLeft, thBottomLeft  = _G.res.getSpriteBounds(sheet, borderSprites.bottomLeft)
	elseif borderSprites.bottomRight ~= nil then
		pxBottomLeft, pyBottomLeft  = _G.res.getSpritePivot(sheet, borderSprites.bottomRight)
		twBottomLeft, thBottomLeft  = _G.res.getSpriteBounds(sheet, borderSprites.bottomRight)
		borderSprites.bottomLeft = ""
	else
		borderSprites.bottomLeft = ""
	end
	
	if borderSprites.right == nil then
		borderSprites.right = ""
	end
	if borderSprites.bottomMiddle == nil then
		borderSprites.bottomMiddle = ""
	end
	if borderSprites.bottomRight == nil then
		borderSprites.bottomRight = ""
	end
	if borderSprites.center == nil then
		borderSprites.center = ""
	end
	
	local startYMiddleLeft = y1 + thTopLeft - pyTopLeft + pyMiddleLeft 
	local stopYMiddleLeft = y2 - pyBottomLeft - ( thMiddleLeft - pyMiddleLeft)
	if stopYMiddleLeft < startYMiddleLeft then
		stopYMiddleLeft = startYMiddleLeft + 1
	end
	
	local correctedX1, correctedX2, xPivot, yPivot, horBorderOffset, verBorderOffset = 0, 0, 0, 0, 0, 0
	
	-- top (& bottom) middle sprite is drawn as many times as necessary to fill the gap between corners so the width of the box might increase
	local horDrawCount = _G.math.ceil(width / twTopMiddle)
	local offsetX = 0
	if horDrawCount ~= 0 and twTopMiddle ~= 0 then
		offsetX = (horDrawCount * twTopMiddle) - width
	end
	if hAnchor == "HCENTER" then
		correctedX1 = x1 - offsetX /2
		correctedX2 = x2 + offsetX / 2
		xPivot = -width / 2
		horBorderOffset = -offsetX / 2
	elseif hAnchor == "RIGHT" then
		correctedX1 = x1 - offsetX
		correctedX2 = x2 
		xPivot = -width
		horBorderOffset = -offsetX
	else -- left
		correctedX1 = x1
		correctedX2 = x2 + offsetX 
		xPivot = 0
	end
	
	-- left (& right) middle sprite is drawn as many times as necessary to fill the gap between corners so the height of the box might increase
	local verDrawCount = _G.math.ceil((y2 - y1) / thMiddleLeft)
	local offsetY = 0
	if verDrawCount ~= 0 and thMiddleLeft ~= 0 then
		offsetY = (verDrawCount * thMiddleLeft) - height
	end
	if vAnchor == "VCENTER" then
		correctedY1 = y1 - offsetY / 2
		correctedY2 = y2 + offsetY / 2
		yPivot = -height / 2
		verBorderOffset = -offsetY / 2
	elseif vAnchor == "BOTTOM" then
		correctedY1 = y1 - offsetY
		correctedY2 = y2 
		yPivot = -height
		verBorderOffset = -offsetY
	else -- top
		correctedY1 = y1
		correctedY2 = y2 + offsetY 
		yPivot = 0
	end
	for i = 0, (horDrawCount-1) * twTopMiddle, twTopMiddle do
		_G.res.drawSprite(sheet, borderSprites.topMiddle, _G.math.floor(startXTopMiddle + i + horBorderOffset + xPivot), _G.math.floor(correctedY1 + yPivot))
		_G.res.drawSprite(sheet, borderSprites.bottomMiddle, _G.math.floor(startXTopMiddle + i + horBorderOffset + xPivot) , _G.math.floor(correctedY2 + yPivot + 1))
	end
	for i = 0, (verDrawCount-1) * thMiddleLeft, thMiddleLeft do
		_G.res.drawSprite(sheet, borderSprites.left, _G.math.floor(correctedX1 + xPivot), _G.math.floor(startYMiddleLeft + i + verBorderOffset + yPivot))
		_G.res.drawSprite(sheet, borderSprites.right, _G.math.floor(correctedX2 + xPivot + 1), _G.math.floor(startYMiddleLeft + i + verBorderOffset + yPivot))
	end
	
	-- draw corners
	_G.res.drawSprite(sheet, borderSprites.topLeft, _G.math.floor(correctedX1 + xPivot), _G.math.floor(correctedY1 + yPivot))
	_G.res.drawSprite(sheet, borderSprites.topRight, _G.math.floor(correctedX2 + xPivot + 1), _G.math.floor(correctedY1 + yPivot))
	_G.res.drawSprite(sheet, borderSprites.bottomLeft, _G.math.floor(correctedX1 + xPivot), _G.math.floor(correctedY2 + yPivot + 1))
	_G.res.drawSprite(sheet, borderSprites.bottomRight, _G.math.floor(correctedX2 + xPivot + 1), _G.math.floor(correctedY2 + yPivot + 1))
	
	-- if color isn't defined then fill with center sprite
	if color ~= nil then
		drawRect(r, g, b, a, _G.math.floor(correctedX1 + xPivot), _G.math.floor(correctedY1 + yPivot), _G.math.floor(correctedX2 + xPivot), _G.math.floor(correctedY2 + yPivot), false)
	else
		_G.res.drawSprite(sheet, borderSprites.center, _G.math.floor(correctedX1 + xPivot), _G.math.floor(correctedY1 + yPivot), "TOP", "LEFT", _G.math.floor(correctedX2 - correctedX1 + 1), _G.math.floor(correctedY2 - correctedY1 + 1))
	end
	
	local correctedWidth = correctedX2 - correctedX1 + 1
	local correctedHeight = correctedY2 - correctedY1 + 1
	return _G.math.floor(correctedX1), _G.math.floor(correctedY1), _G.math.floor(correctedWidth), _G.math.floor(correctedHeight)
end

function drawBox( borderSprites, sheet, x1, y1, width, height, hAnchor, vAnchor, color)
	
	local boxSprites = borderSprites
	local r, g, b, a = 1.0, 1.0, 1.0, 1.0
	if color ~= nil then
		if color.red ~= nil then
			r = color.red
		end
		if color.green ~= nil then
			g = color.green
		end
		if color.blue ~= nil then
			b = color.blue
		end
		if color.alpha ~= nil then
			a = color.alpha
		end
	end

	local x2 = x1 + width - 1
	local y2 = y1 + height - 1
	
	local thTopMiddle = 0
	local twMiddleLeft = 0
	local twMiddleRight = 0
	
	local thBottomMiddle = 0
		
	if boxSprites.topLeft == nil then
		boxSprites.topLeft = ""
	end
	
	if boxSprites.topRight == nil then
		boxSprites.topRight = ""
	end
	
	if boxSprites.bottomLeft == nil then
		boxSprites.bottomLeft = ""
	end
	
	if boxSprites.bottomRight == nil then
		boxSprites.bottomRight = ""
	end

	if boxSprites.center == nil then
		boxSprites.center = ""
	end
	
	if boxSprites.topMiddle ~= nil then
		_, thTopMiddle = _G.res.getSpriteBounds(sheet, boxSprites.topMiddle)
	else
		boxSprites.topMiddle = ""
	end
	
	if boxSprites.left ~= nil then
		twMiddleLeft, _ = _G.res.getSpriteBounds(sheet, boxSprites.left)
	else
		boxSprites.left = ""
	end
	
	if boxSprites.right ~= nil then 
		twMiddleRight, _ = _G.res.getSpriteBounds(sheet, boxSprites.right)
	else
		boxSprites.right = ""
	end
	
	if boxSprites.bottomMiddle ~= nil then
		_, thBottomMiddle = _G.res.getSpriteBounds(sheet, boxSprites.bottomMiddle)
	else
		boxSprites.bottomMiddle = ""
	end
	
	local xPivot, yPivot = 0, 0
	
	if hAnchor == "HCENTER" then
		xPivot = -width / 2
	elseif hAnchor == "RIGHT" then
		xPivot = -width
	else -- left
		xPivot = 0
	end
	if vAnchor == "VCENTER" then
		yPivot = -height / 2
	elseif vAnchor == "BOTTOM" then
		yPivot = -height
	else -- top
		yPivot = 0
	end
	
	local drawSprite = _G.res.drawSprite
	local floor = _G.math.floor
	-- check if some part of the box is on screen
	if floor(y1 - thTopMiddle + yPivot) <= screenHeight and floor(y1 + height + yPivot + thBottomMiddle) >= 0 then
		-- draw borders
		drawSprite(sheet, boxSprites.topMiddle, floor(x1 + xPivot) , floor(y1 - thTopMiddle + yPivot) , "TOP", "LEFT", floor(width), floor(thTopMiddle))
		drawSprite(sheet, boxSprites.bottomMiddle, floor(x1 + xPivot) , floor(y1 + height + yPivot), "TOP", "LEFT", floor(width), floor(thBottomMiddle))
		drawSprite(sheet, boxSprites.left,floor(x1 - twMiddleLeft + xPivot) , floor(y1 + yPivot) , "TOP", "LEFT", floor(twMiddleLeft), floor(height))
		drawSprite(sheet, boxSprites.right, floor(x1 + width + xPivot), floor(y1 + yPivot) , "TOP", "LEFT", floor(twMiddleRight), floor(height))
		
		-- draw corners
		drawSprite(sheet, boxSprites.topLeft, floor(x1 + xPivot), floor(y1 + yPivot), "BOTTOM", "RIGHT")
		drawSprite(sheet, boxSprites.topRight, floor(x1 + width + xPivot), floor(y1 + yPivot), "BOTTOM", "LEFT")
		drawSprite(sheet, boxSprites.bottomLeft, floor(x1 + xPivot), floor(y1 + height + yPivot), "TOP", "RIGHT")
		drawSprite(sheet, boxSprites.bottomRight, floor(x1 + width + xPivot),floor(y1 + height + yPivot), "TOP", "LEFT")
		
		-- if color isn't defined then fill with center sprite
		if color ~= nil then
			drawRect(r, g, b, a, floor(x1 + xPivot), floor(y1 + yPivot), floor(x2 + xPivot), floor(y2 + yPivot), false)
		else
			drawSprite(sheet, boxSprites.center, floor(x1 + xPivot), floor(y1 + yPivot), "TOP", "LEFT", floor(width), floor(height))
		end
	end
end

function createPopupBoxSpriteTables()

	popupBoxSprites = { topLeft = "POPUP_TOP_LEFT", topMiddle = "POPUP_TOP_MIDDLE", topRight = "POPUP_TOP_RIGHT",
						left = "POPUP_LEFT", center = "POPUP_CENTER", right = "POPUP_RIGHT", 
     				    bottomLeft = "POPUP_BOTTOM_LEFT", bottomMiddle = "POPUP_BOTTOM_MIDDLE", bottomRight = "POPUP_BOTTOM_RIGHT" }
						
	completeBoxSprites = { topLeft = "COMPLETE_TOP_LEFT", topMiddle = "COMPLETE_TOP_MIDDLE", topRight = "COMPLETE_TOP_RIGHT",
						   left = "COMPLETE_LEFT", center = "COMPLETE_CENTER", right = "COMPLETE_RIGHT", 
							}
	whiteBoxSprites = { topLeft = "WHITE_TOP_LEFT", topMiddle = "WHITE_TOP_MIDDLE", topRight = "WHITE_TOP_RIGHT",
						   left = "WHITE_LEFT", center = "WHITE_CENTER", right = "WHITE_RIGHT", 
						   bottomLeft = "WHITE_BOTTOM_LEFT", bottomMiddle = "WHITE_BOTTOM_MIDDLE", bottomRight = "WHITE_BOTTOM_RIGHT",
						}
	tutorialBoxSprites = { topLeft = "TUTORIAL_TOP_LEFT", topMiddle = "TUTORIAL_TOP_MIDDLE", topRight = "TUTORIAL_TOP_RIGHT",
						   left = "TUTORIAL_LEFT", center = "TUTORIAL_CENTER", right = "TUTORIAL_RIGHT", 
						   bottomLeft = "TUTORIAL_BOTTOM_LEFT", bottomMiddle = "TUTORIAL_BOTTOM_MIDDLE", bottomRight = "TUTORIAL_BOTTOM_RIGHT",
						}
	
	blackBoxSprites = { topLeft = "UPSELL_TOP_LEFT", topMiddle = "UPSELL_TOP_MIDDLE", topRight = "UPSELL_TOP_RIGHT",
						   left = "UPSELL_LEFT", center = "UPSELL_CENTER", right = "UPSELL_RIGHT", 
						   bottomLeft = "UPSELL_BOTTOM_LEFT", bottomMiddle = "UPSELL_BOTTOM_MIDDLE", bottomRight = "UPSELL_BOTTOM_RIGHT",
						}
	
	scoreBox = {topLeft = "SCORE_TOP_LEFT", left = "SCORE_LEFT", bottomLeft = "SCORE_BOTTOM_LEFT", bottomMiddle = "SCORE_BOTTOM_MIDDLE",
					  bottomRight = "SCORE_BOTTOM_RIGHT", right = "SCORE_RIGHT", topRight = "SCORE_TOP_RIGHT", topMiddle = "SCORE_TOP_MIDDLE",
					  center = "SCORE_CENTER"}
					  
	achievementBoxSprites = {left = "ACHIEVEMENT_BG_LEFT", center = "ACHIEVEMENT_BG_MIDDLE", right = "ACHIEVEMENT_BG_RIGHT"}
	playBoxSprites = {left = "PLAY_BUTTON_BG_LEFT", center = "PLAY_BUTTON_BG_MIDDLE", right = "PLAY_BUTTON_BG_RIGHT" }
end

function calculatePlaytime()
	if playtimeCounter == nil then
		playtimeCounter = 0
	end
	
	settingsWrapper:addPlaytime(playtimeCounter)
	playtimeCounter = 0
end
		
function resetCameras()
-- resets camera for current screen resolution from original castle camera

	local ccd = objects.castleCameraData[deviceModel]
	if ccd.screenWidth == nil then
		ccd.screenWidth = 1680
	end
	if ccd.screenHeight == nil then
		ccd.screenHeight = 1050
	end

	local cameraAspectRation = ccd.screenWidth / ccd.screenHeight
	local currentAspectRation = screenWidth / screenHeight
	local tempCcd = {}
	if currentAspectRation >= cameraAspectRation then
		-- Current aspect ratio is wider than the one used to make the level, expand horizontally
		tempCcd.sx = originalCcd.sx * screenHeight / ccd.screenHeight
	else
		-- Current aspect ratio is narrower than the one used to make the level, expand vertically
		tempCcd.sx = originalCcd.sx * screenWidth / ccd.screenWidth
	end
	tempWorldScale = worldScale * (tempCcd.sx / ccd.sx)
	setWorldScale(tempWorldScale)
	--print("resetCameras! worldScale: " .. worldScale .. ", screenWidth: " .. screenWidth .. "\n")
end

function resolutionChanged(width, height)
end

-- iphone4 needs to init cameras again after the level is loaded when the screen resolution is changed 
function initCameras()
	cameraFunction = levelStartCamera
		
	if objects.castleCameraData ~= nil then
		local cameraSelected = false
		
		-- Try loading cameras in priority order
		for i=1,#g_cameraProfileList do
			local cameraProfile = g_cameraProfileList[i]
			if objects.castleCameraData[cameraProfile] ~= nil then
				cameraSelected = true
				if cameraProfile ~= deviceModel then
					objects.castleCameraData[deviceModel] = {}
					objects.castleCameraData[deviceModel].px = objects.castleCameraData[cameraProfile].px
					objects.castleCameraData[deviceModel].py = objects.castleCameraData[cameraProfile].py
					objects.castleCameraData[deviceModel].sx = objects.castleCameraData[cameraProfile].sx
					objects.castleCameraData[deviceModel].sy = objects.castleCameraData[cameraProfile].sy
					objects.castleCameraData[deviceModel].screenWidth = objects.castleCameraData[cameraProfile].screenWidth
					objects.castleCameraData[deviceModel].screenHeight = objects.castleCameraData[cameraProfile].screenHeight
				end
				break
			end
		end
		
		if cameraSelected == false then
			if objects.castleCameraData.px ~= nil then
				-- If no camera data is found for any profile, use generic data
				objects.castleCameraData[deviceModel] = {}
				objects.castleCameraData[deviceModel].px = objects.castleCameraData.px
				objects.castleCameraData[deviceModel].py = objects.castleCameraData.py
				objects.castleCameraData[deviceModel].sx = objects.castleCameraData.sx
				objects.castleCameraData[deviceModel].sy = objects.castleCameraData.sy
				objects.castleCameraData[deviceModel].screenWidth = objects.castleCameraData.screenWidth
				objects.castleCameraData[deviceModel].screenHeight = objects.castleCameraData.screenHeight
			else
				-- If no generic data found, assume very old format
				objects.castleCameraData[deviceModel] = {}
				objects.castleCameraData[deviceModel].px = screen.x
				objects.castleCameraData[deviceModel].py = screen.y
				objects.castleCameraData[deviceModel].sx = 1
				objects.castleCameraData[deviceModel].sy = 1
				objects.castleCameraData[deviceModel].screenWidth = screenWidth
				objects.castleCameraData[deviceModel].screenHeight = screenHeight
			end
		end
	
		local ccd = objects.castleCameraData[deviceModel]
		
		if ccd.screenWidth == nil then
			ccd.screenWidth = 1680
		end
		if ccd.screenHeight == nil then
			ccd.screenHeight = 1050
		end

		local cameraAspectRation = ccd.screenWidth / ccd.screenHeight
		local currentAspectRation = screenWidth / screenHeight
		
		if currentAspectRation >= cameraAspectRation or startedFromEditor == true then
			-- Current aspect ratio is wider than the one used to make the level, expand horizontally
			ccd.sx = ccd.sx * screenHeight / ccd.screenHeight
			ccd.sy = ccd.sy * screenHeight / ccd.screenHeight
		else
			-- Current aspect ratio is narrower than the one used to make the level, expand vertically
			ccd.sx = ccd.sx * screenWidth / ccd.screenWidth
			ccd.sy = ccd.sy * screenWidth / ccd.screenWidth
		end
		originalCcd = {}
		originalCcd.sx = ccd.sx
		originalCcd.sy = ccd.sy
		if objects.castleCameraData.version == nil then
			-- old version has the screen center position in wrong place
			worldScale = ccd.sx
			setWorldScale(worldScale)
			screen.left = ccd.px - screenWidth * 0.5
			screen.top = ccd.py - screenHeight * 0.5
			screen.right = screen.left + screenWidth / worldScale
			screen.bottom = screen.top + screenHeight / worldScale
			screen.x = (screen.right + screen.left) * 0.5
			screen.y = (screen.bottom + screen.top) * 0.5
			--print("CScreen: " .. screen.left .. ", " .. screen.top .. " - " .. screen.right .. ", " .. screen.bottom .. "\n")
			--print("CScreen: " .. screen.x .. ", " .. screen.y .. "\n")
			ccd.px = screen.x
			ccd.py = screen.y
			--updateScale()
		else
			worldScale = ccd.sx
			setWorldScale(worldScale)
			screen.x = ccd.px
			screen.y = ccd.py
			screen.left = screen.x - screenWidth * 0.5 / worldScale
			screen.top = screen.y - screenHeight * 0.5 / worldScale
			screen.right = screen.x + screenWidth * 0.5 / worldScale
			screen.bottom = screen.y + screenHeight * 0.5 / worldScale
			--updateScale()
		end
	else
		-- camera not defined set default camera
		objects.castleCameraData = {}
		objects.castleCameraData[deviceModel] = {}
		local ccd = objects.castleCameraData[deviceModel]
		ccd.sx = 1
		ccd.sy = 1
		ccd.px = screen.x
		ccd.py = screen.y
	end
	
	--animationWorldScale = worldScale 
	
	local ccd = objects.castleCameraData[deviceModel]
	ccd.top = screen.top
	ccd.left = screen.left
	ccd.right = screen.right
	ccd.bottom = screen.bottom
	cameraAnimationSlider = 1
	cameraAnimationSliderTarget = 1
	defaultCamera()
	
	local wx1, _ = worldToPhysicsTransform(ccd.left, ccd.top)
	local wx2, _ = worldToPhysicsTransform(ccd.right, ccd.bottom)
	--setTheme(currentTheme)
	
	if objects.birdCameraData ~= nil then
	
		local cameraSelected = false
		-- Try loading cameras in priority order
		for i=1,#g_cameraProfileList do
			local cameraProfile = g_cameraProfileList[i]
			if objects.birdCameraData[cameraProfile] ~= nil then
				cameraSelected = true
				if cameraProfile ~= deviceModel then
					objects.birdCameraData[deviceModel] = {}
					objects.birdCameraData[deviceModel].px = objects.birdCameraData[cameraProfile].px
					objects.birdCameraData[deviceModel].py = objects.birdCameraData[cameraProfile].py
					objects.birdCameraData[deviceModel].sx = objects.birdCameraData[cameraProfile].sx
					objects.birdCameraData[deviceModel].sy = objects.birdCameraData[cameraProfile].sy
					objects.birdCameraData[deviceModel].screenWidth = objects.birdCameraData[cameraProfile].screenWidth
					objects.birdCameraData[deviceModel].screenHeight = objects.birdCameraData[cameraProfile].screenHeight
				end
				break
			end
		end
		
		if cameraSelected == false then
			if objects.birdCameraData.px ~= nil then
				-- If no camera data is found for any profile, use generic data
				objects.birdCameraData[deviceModel] = {}
				objects.birdCameraData[deviceModel].px = objects.birdCameraData.px
				objects.birdCameraData[deviceModel].py = objects.birdCameraData.py
				objects.birdCameraData[deviceModel].sx = objects.birdCameraData.sx
				objects.birdCameraData[deviceModel].sy = objects.birdCameraData.sy
				objects.birdCameraData[deviceModel].screenWidth = objects.birdCameraData.screenWidth
				objects.birdCameraData[deviceModel].screenHeight = objects.birdCameraData.screenHeight
			else
				-- If no generic data found, assume very old format
				objects.birdCameraData[deviceModel] = {}
				objects.birdCameraData[deviceModel].px = screen.x
				objects.birdCameraData[deviceModel].py = screen.y
				objects.birdCameraData[deviceModel].sx = 1
				objects.birdCameraData[deviceModel].sy = 1
				objects.birdCameraData[deviceModel].screenWidth = screenWidth
				objects.birdCameraData[deviceModel].screenHeight = screenHeight
			end
		end
	
		local bcd = objects.birdCameraData[deviceModel]
		
		if bcd.screenWidth == nil then
			bcd.screenWidth = 1680
		end
		if bcd.screenHeight == nil then
			bcd.screenHeight = 1050
		end

		local cameraAspectRation = bcd.screenWidth / bcd.screenHeight
		local currentAspectRation = screenWidth / screenHeight
		
		if currentAspectRation >= cameraAspectRation then
			-- Current aspect ratio is wider than the one used to make the level, expand horizontally
			bcd.sx = bcd.sx * screenHeight / bcd.screenHeight
			bcd.sy = bcd.sy * screenHeight / bcd.screenHeight
		else
			-- Current aspect ratio is narrower than the one used to make the level, expand vertically
			bcd.sx = bcd.sx * screenWidth / bcd.screenWidth
			bcd.sy = bcd.sy * screenWidth / bcd.screenWidth
		end
		
		if objects.birdCameraData.version == nil then
			-- old version has the screen center position in wrong place
			scale = bcd.sx
			bcd.left = bcd.px - screenWidth * 0.5
			bcd.top = bcd.py - screenHeight * 0.5
			bcd.right = screen.left + screenWidth / scale
			bcd.bottom = screen.top + screenHeight / scale
			bcd.px = (screen.right + screen.left) * 0.5
			bcd.py = (screen.bottom + screen.top) * 0.5
			--print("BScreen: " .. screen.left .. ", " .. screen.top .. " - " .. screen.right .. ", " .. screen.bottom .. "\n")
			--print("BScreen: " .. screen.x .. ", " .. screen.y .. "\n")
		else
			bcd.left = bcd.px - screenWidth * 0.5 / bcd.sx
			bcd.top = bcd.py - screenHeight * 0.5 / bcd.sy
			bcd.right = screen.left + screenWidth / bcd.sx
			bcd.bottom = screen.top + screenHeight / bcd.sy
		end
	else
		-- bird camera not defined
		objects.birdCameraData = {}
		objects.birdCameraData[deviceModel] = {}
		local bcd = objects.birdCameraData[deviceModel]
		bcd.sx = 1
		bcd.sy = 1
		bcd.px = screen.x
		bcd.py = screen.y
		bcd.left = bcd.px - screenWidth * 0.5
		bcd.top = bcd.py - screenHeight * 0.5
		bcd.right = screen.left + screenWidth * 0.5
		bcd.bottom = screen.top + screenHeight * 0.5
	end

	local bcd = objects.birdCameraData[deviceModel]
	ccd.screenWidth = screenWidth
	ccd.screenHeight = screenHeight
	bcd.screenWidth = screenWidth
	bcd.screenHeight = screenHeight
		
	leftLimit = bcd.left - screenWidth * 0.20
	rightLimit = ccd.right + screenWidth * 0.20
	
	local leftLimitPhysics, rightLimitPhysics = worldToPhysicsTransform(leftLimit, rightLimit)
	if rightLimitPhysics > levelRightEdge then
		levelRightEdge = rightLimitPhysics
	end
	if leftLimitPhysics < levelLeftEdge then
		levelLeftEdge = leftLimitPhysics
	end
	-- set level left and right limit, other values do not affect at the moment
	levelLimitMinX = levelLeftEdge - screenWidth*0.75*physicsScale
	levelLimitMaxX = levelRightEdge + screenWidth*0.75*physicsScale
	setLevelLimits(levelLimitMinX, -10000, levelLimitMaxX, 20)
	
	-- calculate minimum scale. ie the player can't see the world smaller than this size
	maxLevelWidth = rightLimit - leftLimit
	minWorldScale = screenWidth / maxLevelWidth
	groundLimit = bcd.bottom
	if groundLimit < ccd.bottom then
		groundLimit = ccd.bottom
	end
	groundLimit = screenHeight / (minWorldScale * 5)
	if levelRestartedFrom == nil or startedFromEditor == true then
		currentZoomedScale = bcd.sx
		if currentZoomedScale < ccd.sx then
			currentZoomedScale = ccd.sx
		end
	end
end


function StringStartsWith(String,Start)
   return _G.string.sub(String,1,_G.string.len(Start))==Start
end


----------------------------------------------------
--name is the key for the theme sprite that is registered in the level file,
--attributes is the table to the key mentioned above
----------------------------------------------------
function addThemeSprite(name, attributes)

	--the global table themeSpriteObjects will have attributes that make 
	--selection/modifications available
	
	local obj = attributes
	local spr = blockTable.blocks[obj.definition].sprite
	if not spr and blockTable.blocks[obj.definition].damageSprites then
		spr = blockTable.blocks[obj.definition].damageSprites.damage1
	end
	
	local t_scaleX = 1
	local t_scaleY = 1
	
	if obj.scale ~= nil then
		t_scaleX = obj.scale.x or 1
		t_scaleY = obj.scale.y or 1
	end
	
	createThemeSprite(obj.name, spr, obj.x, obj.y, t_scaleX, t_scaleY, obj.angle, obj.layer)
	
	themeSpriteObjects[name] = { x = obj.x, y = obj.y, name = obj.name, definition = obj.definition,
								 scale = (obj.scale or {x=1,y=1}), angle = obj.angle, layer = obj.layer}
					
	--will hold the object in objects.world that represents the theme sprite. This is needed mostly for
	--selecting the object during editing, so we copy only the attributes that will be used
	local t_worldSprite = blockTable.blocks[obj.definition]
	
	local w, h = _G.res.getSpriteBounds("", spr)
	
	local sizeFactor = 0.92
	if t_worldSprite.density == 0 then
		sizeFactor = 1
	end
	
	w = w * physicsScale * sizeFactor
	h = h * physicsScale * sizeFactor
	
	themeSpriteObjects[name].type = t_worldSprite.type			
	themeSpriteObjects[name].width = w
	themeSpriteObjects[name].height = h
	themeSpriteObjects[name].vertices = t_worldSprite.vertices									
	
	if t_worldSprite.type == "circle" then
		if t_worldSprite.radius ~= nil then
			themeSpriteObjects[name].radius = t_worldSprite.radius
		else
			if spr ~= "" and spr ~= nil then
				local w, h = _G.res.getSpriteBounds("", spr)
				themeSpriteObjects[name].radius = w * 0.5 * physicsScale * sizeFactor
			end
		end								
	end
end



-----------------------------------------------
--- Mighty eagle property wrapper functions ---
-----------------------------------------------
function inAppPurchasingBecameAvailable()
	if iapEnabled ~= true then
		iapEnabled = true
		if currentMenuPage ~= nil and mainMenu ~= nil then
			if currentMenuPage == mainMenu then
				prepareMenuPage(mainMenu)
			end
		end
	end
end

function enableMightyEagle()
	settingsWrapper:setMightyEagleEnabled()
end

-- Eagle is enabled if it's purchased (settings.mightyEagleEnabed = true), or it's available by other condition (one time launch via nfc etc.) 
function isEagleEnabled()
	return settingsWrapper:isMightyEagleEnabled() or settingsWrapper:getNFCMeUnlocked() -- and not isChallengeMode() 
end


function isAdsOffPurchaseEnabled()
	return iapEnabled == true and deviceModel == "android" and isPremium ~= true and useShop == true
end

-- Iap flag is true if platform-specific purchase option is available. This flag can be toggled on/off at runtime depending on platform
function isIapEnabled()
	return iapEnabled == true
end

function showEagleUIElements()
	return (settingsWrapper:isMightyEagleEnabled() or iapEnabled == true) and not isChallengeMode()
end

-- presents if eagle is unavailable for shot. This behaviour is presented by user interface with grayed out icon
-- in level failed & ingame screens

function isEagleUnavailableForShot()
	local disabled = false
	local eagleUsedTimeCheck = settingsWrapper:getEagleUsedTime() ~= nil
	local highscoreCheck = (highscores[levelName] == nil or ((highscores[levelName].score == 0 or highscores[levelName].completed ~= true) and highscores[levelName].eagleScore == nil))
	local currentLevelCheck = eagleUsedInCurrentLevel ~= true
	local timeCheck = settingsWrapper:getEagleUsedTime() ~= nil and timeDiff( currentTime(), settingsWrapper:getEagleUsedTime()) < eagleLockedTime
	
	--loginfo("eagleUsedTimeCheck = ".._G.tostring(eagleUsedTimeCheck))
	--loginfo("highscoreCheck = ".._G.tostring(highscoreCheck))
	--loginfo("currentLevelCheck = ".._G.tostring(currentLevelCheck))
	--loginfo("timeCheck = ".._G.tostring(timeCheck).. " timediff = ".._G.tostring(timeDiff(currentTime(), settingsWrapper:getEagleUsedTime())).. " locked  time = "..eagleLockedTime)
	
	if  eagleUsedTimeCheck and highscoreCheck and currentLevelCheck and timeCheck then
		disabled = true
	end
	
	--if startedFromEditor == true then
	--	disabled = true
	--end
	
	return disabled
end

function unlockMightyEagleNFC()	
	
	-- if mighty eagle is alreadyt available, the NFC unlock is not on.
	if settingsWrapper:isMightyEagleEnabled() then
		return
	end
	
	local event = {}
	--if not in cooldown
	
	if getMightyEagleNFCUnlockCooldown() == 0 then
		
		if not settingsWrapper:getNFCMeUnlocked() then
			settingsWrapper:setNFCUnlockTimer(currentTime())
		end
		--[[
		if levelCompleted ~= true and eagleBaitLaunched ~= true then
			inGameEagleButtonVisible = true
		end]]
		--popupPage = mightyEaglePopUp
		--prepareMenuPage(mightyEaglePopUp)
		settingsWrapper:setNFCMeUnlocked(true)
		settingsWrapper:setEagleUsedTime(nil)
		saveLuaFileWrapper("settings.lua", "settings", true)
		eventManager:queueEvent({id = events.EID_MIGHTYEAGLE_UNLOCK_ONCE, text = "ME_NFC_UNLOCK_SUCCESFULL"})

	else
		--if nfc in cooldown
		local timeDiff = getMightyEagleNFCUnlockCooldown()
		eventManager:queueEvent({id = events.EID_MIGHTY_EAGLE_UNLOCK_ONCE_COOLDOWN, text = "ME_NFC_UNLOCK_CD" .. formatTime(timeDiff) })
	end
end

function getMightyEagleNFCUnlockCooldown()
	if not settingsWrapper:getNFCUnlockTimer() then
		return 0
	else
		local timeDiff = (NFCUnlockTime - timeDiff(currentTime(), settingsWrapper:getNFCUnlockTimer()))
		timeDiff = _G.math.max(0,timeDiff)
		return timeDiff
	
	end
	
end

--stop sounds from ingame
function stopIngameSounds()
	_G.res.stopAllAudio()
	_G.res.stopAudio(currentMusic)
	
	--looping rolling sounds
	_G.res.stopAudio("wood_rolling")
	_G.res.stopAudio("rock_rolling")
	_G.res.stopAudio("light_rolling")
end

--get number of stars earned in the given level with the score
function getStarCount(level, score)
	if score >= starTable[level].goldScore then
		return 3
	elseif score >= starTable[level].silverScore then
		return 2
	end
	return 1
end

--check if the challenge passed to this function is currently available
function checkChallengeUnlockCondition(challenge)
	if challenge.unlockCondition.date ~= nil then
		local time = _G.os.date("*t")
		if challenge.unlockCondition.date.y > time.year then
			return false
		elseif challenge.unlockCondition.date.y < time.year then
			--year is bigger than unlock year
		elseif challenge.unlockCondition.date.m > time.month then
			return false
		elseif challenge.unlockCondition.date.m < time.month then
			--year & month is bigger than unlock year
		elseif challenge.unlockCondition.date.d > time.day then
			return false
		end
	end
	
	return true
end


--get a countdown to the next date-unlocked challenge being unlocked, or nil if
--there are no more challenges left to unlock
function getNextChallengeUnlockCountdown()
	local next = nil
	for _, v in _G.pairs(g_challenges) do
		if not checkChallengeUnlockCondition(v) and v.unlockCondition.date then
			if next == nil then
				next = v
			elseif v.unlockCondition.date.y < next.unlockCondition.date.y then
				next = v
			elseif v.unlockCondition.date.y == next.unlockCondition.date.y and v.unlockCondition.date.m < next.unlockCondition.date.m then
				next = v
			elseif v.unlockCondition.date.y == next.unlockCondition.date.y and v.unlockCondition.date.m == next.unlockCondition.date.m and v.unlockCondition.date.d < next.unlockCondition.date.d then
				next = v
			end
		end
	end
	
	if next ~= nil then
		local now = getCurrentTime()
		
		local diff = getTimeDifference({ year = next.unlockCondition.date.y, month = next.unlockCondition.date.m, day = next.unlockCondition.date.d }, now)
		
		if diff.days > 0 then
			return _G.string.format("%u:%02u:%02u:%02u", diff.days, diff.hours, diff.minutes, diff.seconds)
		elseif diff.hours > 0 then
			return _G.string.format("%u:%02u:%02u", diff.hours, diff.minutes, diff.seconds)
		else
			return _G.string.format("%u:%02u", diff.minutes, diff.seconds)
		end
	end
	
	return nil
end

--refill hatchery stars as needed for the given episode
function refreshEpisodeHatcheryStars(episode)
	local now = _G.os.time()
	local save_highscores = false
	
	for i = 1, #g_episodes[episode].pages do
		for _, v in _G.ipairs(g_episodes[episode].pages[i].levels) do
			if highscores[v.name] and highscores[v.name].hatcheryStars and highscores[v.name].hatcheryStars > 0 and highscores[v.name].hatcheryTime then
			
				local timediff = _G.os.difftime(now, highscores[v.name].hatcheryTime)
				local days = _G.math.floor(timediff / 86400)
				--print("- LEVEL " .. v.name .. " d = " .. timediff .. "\n")
				
				if days > 0 then
					highscores[v.name].hatcheryStars = _G.math.max(0, highscores[v.name].hatcheryStars - days)
					highscores[v.name].hatcheryTime = highscores[v.name].hatcheryTime + days * 86400
					save_highscores = true
				end
			end
		end
	end
	
	if save_highscores then
		saveLuaFileWrapper("highscores.lua", "highscores", true)
	end
end

-- when new challenges open up, show number of those.
function getUnviewedChallengesCount()
	local unviewedCount = 0
	for i = 1, #g_challenges do
		if checkChallengeUnlockCondition(g_challenges[i]) then
			local id = g_challenges[i].id			
			if highscores[id] ~= nil then
				if highscores[id].viewed ~= true then
					unviewedCount = unviewedCount + 1
				end
			else
				unviewedCount = unviewedCount + 1			
			end
		end
	end			
	return unviewedCount
end



function setupCompoBirdTable(body, items)
	local returnTable = {}
	
	_G.table.insert(returnTable, {sprite=body, x=0, y=0, scale=1, angle=0})
	
	for k, v in _G.pairs(items) do
		
				
		if compoBirds[v] == nil then
			print("\n compo bird attribute not defined for" .. v)
			_G.table.insert(returnTable, {sprite=v, x = 0, y = 0, scale=1, angle=0})
		else
		
			local entry = compoBirds[v][body]-- = {scale=1, x = 0, y = 0}
			
			if entry == nil then
				print("\n compo bird " .. v " is not defined for body" .. body)
				_G.table.insert(returnTable, {sprite=v, x = 0, y = 0, scale=1, angle=0})
			else		
				local childX = entry.x or 0
				local childY = entry.y or 0
				local childAngle = entry.angle or 0
				local childScale = entry.scale or 1
				_G.table.insert(returnTable, {sprite=v, x = childX, y = childY,  scale=childScale, angle=childAngle})
			end
		end
	end
	
	return returnTable
end

--this function is very slow, used only for debuggin
function setupCompoBirdTableFromIndex(index)
	local accesoryIndex = _G.math.fmod(index, #compoBirds["ACCESORIES"])
	
	local finalBodyIndex = 1
	local finalBeakIndex = 1
	local finalEyeIndex = 1
	local finalAccessoryIndex = 1
	
	local count = 1
	for bodyIndex = 1, #compoBirds["BODIES"] do
		for beakIndex = 1, #compoBirds["BEAKS"] do
			for eyeIndex = 1, #compoBirds["EYES"] do
				for accessoryIndex = 1, #compoBirds["ACCESORIES"] do
					count = count + 1
					
					if count == index then
						finalBodyIndex = bodyIndex
						finalBeakIndex = beakIndex
						finalEyeIndex = eyeIndex
						finalAccessoryIndex = accessoryIndex
						break
					end
					
				end
			end
		end
	end
	
	return setupCompoBirdTable(compoBirds["BODIES"][finalBodyIndex], { compoBirds["BEAKS"][finalBeakIndex], compoBirds["EYES"][finalEyeIndex], compoBirds["ACCESORIES"][finalAccessoryIndex]})
end

function getTotalCompoBirds()
	return #compoBirds["BODIES"] * #compoBirds["BEAKS"] * #compoBirds["EYES"] * #compoBirds["ACCESORIES"]
end


function changeHatcheryBirdBeakSprite(objectName, hatcheryBirdTable, newBeakSprite)
	local newSprites = {}
	
	for k, v in _G.pairs(hatcheryBirdTable.sprites) do
		local newEntry = {}
		newEntry.sprite = v.sprite
		newEntry.x = v.x
		newEntry.y = v.y
		newEntry.angle = v.angle
		newEntry.scale = v.scale
		_G.table.insert(newSprites, newEntry)		
	end
		
	newSprites[hatcheryBirdTable.beakIndex].sprite = newBeakSprite	
	setupCompoObject(objectName, newSprites, Hatchery.Bird.ingameScaling[hatcheryBirdTable.shape])	
end

function changeHatcheryBirdEyesSprite(objectName, hatcheryBirdTable, newEyesSprite)
	local newSprites = {}
	
	for k, v in _G.pairs(hatcheryBirdTable.sprites) do
		local newEntry = {}
		newEntry.sprite = v.sprite
		newEntry.x = v.x
		newEntry.y = v.y
		newEntry.angle = v.angle
		newEntry.scale = v.scale
		_G.table.insert(newSprites, newEntry)		
	end
	
	
	newSprites[hatcheryBirdTable.eyesIndex].sprite = newEyesSprite
	
	setupCompoObject(objectName, newSprites, Hatchery.Bird.ingameScaling[hatcheryBirdTable.shape])
	
end

function logwarning(s)
	print("WARNING: ".._G.tostring(s).."\n")
end

function logerror(s)
	print("ERROR: ".._G.tostring(s).."\n")
end

function loginfo(s)
	print("INFO: ".._G.tostring(s).."\n")	
end

function setupIngameBirdsFromHatchery()
	local selectedBirds = Hatchery.getSelectedBirds()
		
	local hatcheryBirdsToUse = {}
	
	-- indexed by the birds definitions
	local hatcheryNextBirdsToUse = {}		
		
	for k, v in _G.pairs(selectedBirds) do
		print("\n selected birds " .. k)
		_G.table.insert(hatcheryBirdsToUse, v)
	end
	
	for k, v in _G.pairs(birds) do
		if hatcheryNextBirdsToUse[v.definition] == nil then
			hatcheryNextBirdsToUse[v.definition] = {startNumber = v.startNumber, bird = v}
		else
			if hatcheryNextBirdsToUse[v.definition].startNumber > v.startNumber then
				hatcheryNextBirdsToUse[v.definition] = {startNumber = v.startNumber, bird = v}
			end
		end
	end
	
	for k, v in _G.pairs(hatcheryBirdsToUse) do
		local selectedBirdDefinition = Hatchery.Bird.definitionsMapping[v.shape]
		
		if hatcheryNextBirdsToUse[selectedBirdDefinition] ~= nil then
			setupCompoObject(hatcheryNextBirdsToUse[selectedBirdDefinition].bird.name, v.sprites, Hatchery.Bird.ingameScaling[v.shape])
			
			
			objects.world[hatcheryNextBirdsToUse[selectedBirdDefinition].bird.name].hatcheryBird = v
			
			--the hatchery bird needs to know about the ingame bird it's bound to. To for example add particle effects around it etc.
			v:setupBird(objects.world[hatcheryNextBirdsToUse[selectedBirdDefinition].bird.name])
			local foundStartNumber = hatcheryNextBirdsToUse[selectedBirdDefinition].startNumber
			-- insert the first bird with a different start index
			for kk, vv in _G.pairs(birds) do
				if vv.definition == selectedBirdDefinition and vv.startNumber > foundStartNumber then
					hatcheryNextBirdsToUse[selectedBirdDefinition] = {startNumber = vv.startNumber, bird = vv}
					break
				end					
			end
			
			-- substitute entry 
			for kk, vv in _G.pairs(birds) do
				if vv.definition == selectedBirdDefinition and vv.startNumber > foundStartNumber and hatcheryNextBirdsToUse[vv.definition].startNumber > vv.startNumber then
					hatcheryNextBirdsToUse[selectedBirdDefinition] = {startNumber = vv.startNumber, bird = vv}						
				end					
			end
			
			if hatcheryNextBirdsToUse[selectedBirdDefinition].startNumber == foundStartNumber then
				hatcheryNextBirdsToUse[selectedBirdDefinition] = nil
			end
		end
	end	
end

function getTableSize(list)
	local count = 0
	
	for k,v in _G.pairs(list) do
		count = count + 1
	end
	
	return count
end

function getItemAt(list, index)
	local count = 1
	
	for k,v in _G.pairs(list) do
		if index == count then
			return v
		end
		count = count + 1
		
	end
	
	return nil
end

function replaceNextAvailableBird(newBird, startNumber)
	local newBird = Hatchery:getBirds()[newBird.id]
	local selectedBirdDefinition = Hatchery.Bird.definitionsMapping[newBird.shape]
	
	
	local birdToRemove = nil
	
	local totalBirds = getTableSize(birds)
	
	for i = 1, totalBirds do
		local bird = getItemAt(birds,i)
		if bird.startNumber == startNumber then
			if flyingBird ~= nil and flyingBird == bird then
				i = 1
				startNumber = startNumber + 1
			else				
				birdToRemove = bird
				break
			end
		end
	end
	
	if birdToRemove == nil then
		return -1
	end
	
	
	if birdToRemove ~= nil then
		local removedObjectName = birdToRemove.name
		local birdX = birdToRemove.x
		local birdY = birdToRemove.y
		local birdAngle = 0--birdToRemove.angle --discard angle, because if the bird was just jumping, the bird spawned would be misoriented
		local birdStartNumber = birdToRemove.startNumber
		local birdShot = birdToRemove.shot
		local birdAnimTimer = birdToRemove.animTimer
		local birdJumpTimer = birdToRemove.jumpTimer
		
		
		
		removeObject(removedObjectName)
		objects.world[removedObjectName] = nil
		birds[removedObjectName] = nil
		otherBirds[removedObjectName] = nil
		
		
		--this is a hack for creating objects that differ in size from the definition. Later write a proper function for this
		local def = blockTable.blocks[selectedBirdDefinition]
		local originalRad = def.radius 
		def.radius = newBird:getIngameSize(def.radius)
		local name = createObject(blockTable, selectedBirdDefinition, removedObjectName, birdX*scaleFactor, birdY*scaleFactor)
		def.radius = originalRad
		
		setRotation(removedObjectName, birdAngle)
		setMaterial(removedObjectName, objects.world[removedObjectName].material)
		
		if removedObjectName ~= currentBirdName then
			setObjectParameter(removedObjectName, 2, 0)
		end
		
		objects.world[removedObjectName].startNumber = birdStartNumber
		objects.world[removedObjectName].definition = selectedBirdDefinition
		objects.world[removedObjectName].controllable = true
		objects.world[removedObjectName].shot = birdShot
		objects.world[removedObjectName].animTimer = birdAnimTimer
		objects.world[removedObjectName].jumpTimer = birdJumpTimer
		birds[removedObjectName] = objects.world[removedObjectName]
		otherBirds[removedObjectName] = objects.world[removedObjectName]
		
		
		setupCompoObject(removedObjectName, newBird.sprites, Hatchery.Bird.ingameScaling[newBird.shape])
		
		objects.world[removedObjectName].hatcheryBird = newBird
		newBird:setupBird(objects.world[removedObjectName])
			
		
		local birdSprite = blockTable.blocks[objects.world[removedObjectName].definition].sprite
		
		if not settingsWrapper:getTutorialsForItem(birdSprite) then
			
			local hasExtraTutorial = false				
			-- Extra tutorials
			if(birdSprite == "BIRD_GREEN" or birdSprite == "BIRD_BLUE" or birdSprite == "BIRD_YELLOW" or birdSprite == "BIRD_GREY" or birdSprite == "BIRD_BOOMERANG") then
				hasExtraTutorial = true
			end
			
			settingsWrapper:createTutorialForItem(birdSprite, blockTable.blocks[objects.world[removedObjectName].definition].tutorialInfo, hasExtraTutorial)
			_G.table.insert(birdTutorialPopups, blockTable.blocks[objects.world[removedObjectName].definition].tutorialInfo)

			eventManager:notify({id = events.EID_TUTORIAL_WATCHED, data = {sprite = birdSprite}})
			
		end
		
	end
	
	return startNumber + 1
end


function startMightyEagleFromHatchery()
	if isEagleEnabled() == true then				
		if isEagleUnavailableForShot() == true then 
		   -- eagle sleeping
		   eagleInfoTimer = 3.0
		else
			launchEagleBaitInGame()
		end
	else
		-- if event.from == "LEVEL_FAILED" then
			-- g_eagleClickedFrom = "LEVEL_FAILED"
			-- eventManager:notify({id = events.EID_PUSH_FRAME, target = MEPage:new({from = "LEVEL_FAILED", shade = 0.65})})
			
		-- elseif event.from == "INGAME" then
			-- g_eagleClickedFrom = "INGAME"
			-- menuManager:deactivate()
			-- goToMightyEagleDemoPageFromGame()				
		-- end
	end
end


--subsystems.unitTestFlurry()

function showHatcheryIngameMenu(show)
	if g_hatcheryEnabled then	
		if show == true then
			Hatchery.showIngameHatcheryMenu()
		else
			Hatchery.hideIngameHatcheryMenu()
		end
	end
end

function currentTimeOnServerReceived(serverTime, localTime)
	g_hatcheryServerTimeSync["timeToRequest"] = 0		
	
	if settings.hatcheryLastSavedServerTime ~= nil then
		local timeDifferenceLocal = getTimeDifference(localTime, settings.hatcheryLastSavedServerTime.localTime)
		local timeDifferenceServer = getTimeDifference(serverTime, settings.hatcheryLastSavedServerTime.serverTime)				
		
		local differenceDays = _G.math.abs(timeDifferenceServer.days - timeDifferenceLocal.days)
		
		g_hatcheryTimeForwardDetected = false
		--if we have many days difference, the floating point type might not be enough to hold all seconds, so its better to perform this check first
		if differenceDays > 2 then
			g_hatcheryTimeForwardDetected = true
		else
			local timeDifferenceSecondsLocal = getTimeDifferenceInSeconds(localTime, settings.hatcheryLastSavedServerTime.localTime)
			local timeDifferenceSecondsServer = getTimeDifferenceInSeconds(serverTime, settings.hatcheryLastSavedServerTime.serverTime)
			
			if _G.math.abs(timeDifferenceSecondsServer - timeDifferenceSecondsLocal) > 60 then
				g_hatcheryTimeForwardDetected = true
			end
		end		
		
	end
	
	settingsWrapper:setHatcheryLastSavedServerTime(serverTime, localTime)
	saveLuaFileWrapper("settings.lua", "settings", true)					
	
end

--used by the hatchery
function pauseGame(pause)	
	
	if pause == true then
		-- setGameMode(hidePauseMenu)	
		setGameMode(updateMenu)		
	else
		setGameMode(updateGame)
	end
	
	setPhysicsEnabled(not pause)
end

--for some weird reason, this doesnt work when called from the hatchery
function getNumberFromString(str)
	return _G.tonumber(str)
end

function isRetinaGraphicsEnabled()
	return deviceModel == "iphone4" and ((changeResolution ~= true and wantedResolution == "FULL") or (changeResolution == true and wantedResolution == "HALF"))
end

filename="gamelogic.lua"
