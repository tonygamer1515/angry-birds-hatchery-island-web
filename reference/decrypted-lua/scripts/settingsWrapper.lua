settingsWrapper = {}

-- ABID stuff
--[[
props_localSettingKeys = {
	"attemptsAfterEagleOffer", -- x not found?
	"audioEnabled", -- o
	"averagePlaytime", -- x
	"crystalSplashShown", -- x
	"cumulativeScore", -- x
	"currentLevelSelectionPages", o --
	"currentMainMenuSong", -- x
	"currentMainMenuTheme", -- o
	"currentThemeIndex", -- x
	"currentZoomLevelMainMenu", -- x
	"eaglesUsedIn", -- o
	"eagleUsedTime", -- o
	"gfxLowQuality", -- 
	"musicEnabled", -- x
	
	"selectedEpisode", -- 
	
--	"themeAmount",-- DEPRECATED? x

	"vibraEnabled", -- x
	"ABIDrefreshToken", --
	"mightyEagleEnabled", --
	"isPremium", --
}

]]
------------------------------------------------------------------------
-- if isPremium - flag is true, then application is free from ads
------------------------------------------------------------------------
	
if ABIDEnabled ~= true then	
	localSettings = settings
	purchases = settings
else
	localSettings = localSettings or {}
	purchases = purchases or {}
end

function settingsWrapper:setPremium(premium)
	purchases.isPremium = premium
end

function settingsWrapper:isPremium()
	return purchases.isPremium
end


----------------------------------------------------
----- Boomerang Bird methods for showing popups ----
----------------------------------------------------

---------------- Boomerang Bird 1-----------------
function settingsWrapper:isBoomerangBirdAchieved()
	return settings.boomerangBirdAchieved
end

function settingsWrapper:setBoomerangBirdAchieved()
	settings.boomerangBirdAchieved = true
end
---------------- Boomerang Bird 2 ------------
function settingsWrapper:isBoomerangBird2Achieved()
	return settings.boomerangBirdAchieved
end

function settingsWrapper:setBoomerangBird2Achieved()
	settings.boomerangBirdAchieved = true
end
-----------------------------------------------------------------------------------------------------
---------- Mighty Eagle used Time is used to determine the next time eagle will be available --------
-----------------------------------------------------------------------------------------------------
function settingsWrapper:getEagleUsedTime()
	return localSettings.eagleUsedTime
end

function settingsWrapper:setEagleUsedTime(t)	
	loginfo(" Eagle used time set to ".._G.tostring(t))
	localSettings.eagleUsedTime = t	
end
----------------------------------------------------------------------
------------ Mighty Eagle Levels, where eagle has been used in. ------
----------------------------------------------------------------------

function settingsWrapper:getEagleUsedIn()
	if localSettings.eaglesUsedIn == nil then
		localSettings.eaglesUsedIn = {}
	end
	return localSettings.eaglesUsedIn
end

-- Resets eagles used in table
function settingsWrapper:resetEaglesUsedIn()
	localSettings.eaglesUsedIn = {}
end

function settingsWrapper:removeEagleUsedInLevel(levelName)
	local index = nil
	
	if(levelName == nil) then
		return
	end
	
	for i,v in _G.ipairs(localSettings.eaglesUsedIn) do
		if v.level == levelName then
			index = i
		end
	end
	
	if(index ~= nil) then
		_G.table.remove(localSettings.eaglesUsedIn, i)	
		return true
	end
	return false
end

--- adds a level(levelName) that eagle has been used in.  
function settingsWrapper:setEagleUsedInLevel(levelName)
	if  localSettings.eaglesUsedIn == nil then
		localSettings.eaglesUsedIn = {}
	end
	
	if(levelName ~= nil) then
		_G.table.insert(localSettings.eaglesUsedIn, { level = levelName } )		
	end
end
----------------------
---- Cumulative Stars 
----------------------
function settingsWrapper:getCumulativeStars()
	return settings.cumulativeStars
end
function settingsWrapper:setCumulativeStars(stars)
	settings.cumulativeStars = stars
end

------------------------------------------------------
function settingsWrapper:getSettingsVersion()
	return settings.settingsVersion or { id = 0, version = "pre-2.0" }
end

function settingsWrapper:convertSettings()
	if settingsWrapper:getSettingsVersion().id == 0 then
	
		if settings.openGoldenEggLevels ~= nil then
		
			local oldGoldenEggs = settings.openGoldenEggLevels
			settings.openGoldenEggLevels = {}
		
			--convert old eggs format to the new format
			for k, v in _G.pairs(oldGoldenEggs) do
				if _G.type(v) == "number" then
					--26 is the number of golden eggs available before new system
					--was put to place, do not increment!!
					for i = 1, 26 do 
						if k == "Level" .. i then
						
							local page
							local level_number
							if i <= 15 then
								page = 1
								level_number = i
							else
								page = 2
								level_number = i - 15
							end
							
							local level = g_episodes.G.pages[page].levels[level_number]
							
							local level_entry
							if v == 0 then
								level_entry =
								{
									unlocked = true,
									opened = false,
								}
							elseif v == 1 or v == 2 then
								level_entry =
								{
									unlocked = true,
									opened = true,
								}
							end
							
							settings.openGoldenEggLevels[level.name] = level_entry
						end
					end
				else
					settings.openGoldenEggLevels[k] = v
				end
			end

			--fill in all missing eggs
			for i = 1, #g_episodes.G.pages do
				for j = 1, #g_episodes.G.pages[i].levels do
					local level = g_episodes.G.pages[i].levels[j]
					
					if not settings.openGoldenEggLevels[level.name] then
						settings.openGoldenEggLevels[level.name] =
						{
							unlocked = false,
							opened = false,
						}
					end
				end
			end
		end
		
		--renamed variable
		if settings.gameCompleted then
			settings.theme3Completed = true
		end
		
		if settings.lastOpenLevel then
			settings.lastOpenLevelLP1 = settings.lastOpenLevel
		end
		
		--erase old eagle use data
		settings.eaglesUsedIn = nil
		settings.eagleUsedTime = nil
		
		--stars didn't exist at this point, set them to 0 incase someone has tried hacking their stars
		settings.hatcheryStars = 0	
		
		
		
		settings.settingsVersion = { id = 1, version = "2.0" }
		if ABIDEnabled then
			ABIDUtils.convertSettings()
		end
	end
end

--wilhelm tell achievement
function settingsWrapper:getWilhelmTell()
	return settings.wilhelmTell or false
end

function settingsWrapper:setWilhelmTell()
	settings.wilhelmTell = true
end

--bull's eye achievement
function settingsWrapper:getBullsEye()
	return settings.bullsEye or false
end

function settingsWrapper:setBullsEye()
	settings.bullsEye = true
end

--number of wooden blocks destroyed, used for achievement
function settingsWrapper:getWoodBlocksDestroyed()
	return settings.woodBlocksDestroyed or 0
end

function settingsWrapper:setWoodBlocksDestroyed(blocks)
	settings.woodBlocksDestroyed = blocks
end

--number of rock blocks destroyed, used for achievement
function settingsWrapper:getRockBlocksDestroyed()
	return settings.rockBlocksDestroyed or 0
end

function settingsWrapper:setRockBlocksDestroyed(blocks)
	settings.rockBlocksDestroyed = blocks
end

--number of ice blocks destroyed, used for achievement
function settingsWrapper:getIceBlocksDestroyed()
	return settings.iceBlocksDestroyed or 0
end

function settingsWrapper:setIceBlocksDestroyed(blocks)
	settings.iceBlocksDestroyed = blocks
end

--number of destroyed stalaktites, used for achievement
function settingsWrapper:getStalaktitesDestroyed()
	return settings.stalaktitesDestroyed or 0
end

function settingsWrapper:incrementStalaktitesDestroyed()
	if settings.stalaktitesDestroyed == nil then
		settings.stalaktitesDestroyed = 0
	end
	settings.stalaktitesDestroyed = settings.stalaktitesDestroyed + 1
end

--number of destroyed jewels, used for achievement
function settingsWrapper:getJewelsDestroyed()
	return settings.jewelsDestroyed or 0
end

function settingsWrapper:incrementJewelsDestroyed()
	if settings.jewelsDestroyed == nil then
		settings.jewelsDestroyed = 0
	end
	settings.jewelsDestroyed = settings.jewelsDestroyed + 1
end

--number of destroyed pigs, used for achievement
function settingsWrapper:getPigsDestroyed()
	return settings.pigsDestroyed or 0
end

function settingsWrapper:incrementPigsDestroyed()
	if settings.pigsDestroyed == nil then
		settings.pigsDestroyed = 0
	end
	settings.pigsDestroyed = settings.pigsDestroyed + 1
end

--get tutorials table; internal only!
function settingsWrapper:getTutorials()
	if settings.tutorials == nil then
		settings.tutorials = {}
	end
	
	return settings.tutorials
end

--get data for tutorials for the given item (bird ID)
function settingsWrapper:getTutorialsForItem(tutorial_item)
	return settingsWrapper:getTutorials()[tutorial_item]
end

--create a data item for the given tutorial, and set the tutorial sprite
function settingsWrapper:createTutorialForItem(tutorial_item, sprite, extra_tutorial)
	local tutorials = settingsWrapper:getTutorials()
	tutorials[tutorial_item] = { sprite = sprite }
	if extra_tutorial then
		tutorials[tutorial_item].showHelp = true
	end
end

--mark an extra tutorial as being shown
function settingsWrapper:setExtraTutorialShown(tutorial_item)
	local tutorial = settingsWrapper:getTutorialsForItem(tutorial_item)
	if tutorial.showHelp then
		tutorial.showHelp = false
	end
end

--reset mighty eagle feature
function settingsWrapper:resetMightyEagle()
	local tutorials = settingsWrapper:getTutorials()
	tutorials.BAIT_SARDINE = nil
	purchases.mightyEagleEnabled = nil
end

--check if an episode has been three starred
function settingsWrapper:isEpisodeThreeStarred(episode)
	return settings["threeStarsLP" .. episode] or false
end

--mark an episode as three starred
function settingsWrapper:setEpisodeThreeStarred(episode)
	settings["threeStarsLP" .. episode] = true
end

--check if a theme has been completed
function settingsWrapper:isThemeCompleted(theme)
	return settings["theme" .. theme .. "Completed"] or false
end

--mark a theme as completed
function settingsWrapper:setThemeCompleted(theme)
	settings["theme" .. theme .. "Completed"] = true
end

--get a golden egg data array (internal only)
function settingsWrapper:getGoldenEgg(level)
	if settings.openGoldenEggLevels == nil then
		settings.openGoldenEggLevels = {}
	end
	
	if settings.openGoldenEggLevels[level] == nil then
		settings.openGoldenEggLevels[level] =
		{
	        unlocked = false,
	        opened = false,
		}
	end
	
	return settings.openGoldenEggLevels[level]
end

--mark a golden egg level as being opened (removes the golden shiny effect from the golden egg level selection)
function settingsWrapper:setGoldenEggPlayed(level)
	settingsWrapper:getGoldenEgg(level).opened = true
end

function settingsWrapper:isGoldenEggPlayed(level)
	return settingsWrapper:getGoldenEgg(level).opened
end

--check if a golden egg is unlocked
function settingsWrapper:isGoldenEggUnlocked(level)
	return settingsWrapper:getGoldenEgg(level).unlocked
end

--unlock a golden egg
function settingsWrapper:unlockGoldenEgg(level)
	settingsWrapper:getGoldenEgg(level).unlocked = true
end



--restore golden egg unlock status from highscores in case settings file has been lost, or
--restore any missing eggs if they have somehow disappeared
function settingsWrapper:restoreGoldenEggsFromHighscores()
	for i = 1, #g_episodes.G.pages do
		for j = 1, #g_episodes.G.pages[i].levels do
			local level = g_episodes.G.pages[i].levels[j]
			
			if highscores[level.name] then
				settingsWrapper:unlockGoldenEgg(level.name)
				if highscores[level.name].completed then
					settingsWrapper:setGoldenEggPlayed(level.name)
				end
			end
		end
	end
end

--mighty eagle upsell page viewed flag
function settingsWrapper:setMightyEagleUpsellPageViewed()
	settings.mightyEagleUpsellPageViewed = true
end

function settingsWrapper:isMightyEagleUpsellPageViewed()
	return settings.mightyEagleUpsellPageViewed or false
end

--is mighty eagle enabled
function settingsWrapper:setMightyEagleEnabled()
	purchases.mightyEagleEnabled = true
end

function settingsWrapper:isMightyEagleEnabled()
	return purchases.mightyEagleEnabled or false
end

--are low quality graphics enabled
function settingsWrapper:isGfxLowQuality()
	return localSettings.gfxLowQuality or false
end

function settingsWrapper:toggleGfxLowQuality()
	if localSettings.gfxLowQuality == nil then
		localSettings.gfxLowQuality = true
	else
		localSettings.gfxLowQuality = not localSettings.gfxLowQuality
	end
end

--has level completion data been sent on first boot after flurry was added from saves
--started before flurry was added
function settingsWrapper:isFlurryFirstTimeLevelCollected()
	return settings.flurryFirstTimeLevelCollected or false
end

function settingsWrapper:setFlurryFirstTimeLevelCollected()
	settings.flurryFirstTimeLevelCollected = true
end

--has the facebook page been liked, used to unlock the FB levels
function settingsWrapper:isFbPageLiked()
	return settings.fbPageLiked or false
end

function settingsWrapper:setFbPageLiked()
	settings.fbPageLiked = true
end

--number of birds shot, used for achievement
function settingsWrapper:getBirdsShot()
	return settings.birdsShooted or 0
end

function settingsWrapper:incrementBirdsShot()
	settings.birdsShooted = settingsWrapper:getBirdsShot() + 1
end

--number of birds that have been flung backwards, used for achivement
function settingsWrapper:getBackwardsBirdCount()
	return settings.backwardsBirdCount or 0
end

function settingsWrapper:incrementBackwardsBirdCount()
	settings.backwardsBirdCount = settingsWrapper:getBackwardsBirdCount() + 1
end

--currently selected episode in the episode selection menu
function settingsWrapper:getSelectedEpisode()
	return localSettings.selectedEpisode or 1
end

function settingsWrapper:setSelectedEpisode(episode)
	localSettings.selectedEpisode = episode
end

--get last open level for an episode
function settingsWrapper:getLastOpenLevel(episode)
	local last = settings["lastOpenLevelLP" .. episode] or calculateLastOpenLevel(episode)
	if not settings["lastOpenLevelLP" .. episode] then
		settings["lastOpenLevelLP" .. episode] = last
	end
	return last
end

function settingsWrapper:setLastOpenLevel(episode, level)
	settings["lastOpenLevelLP" .. episode] = level
end

function settingsWrapper:incrementLastOpenLevel(episode)
	settings["lastOpenLevelLP" .. episode] = settingsWrapper:getLastOpenLevel(episode) + 1
end

--current zoom level in the main menu background scene
function settingsWrapper:getCurrentZoomLevelMainMenu()
	return localSettings.currentZoomLevelMainMenu or 1.83
end

function settingsWrapper:setCurrentZoomLevelMainMenu(zoom)
	localSettings.currentZoomLevelMainMenu = zoom
end

--current main menu background level theme
function settingsWrapper:getCurrentMainMenuTheme()
	return localSettings.currentMainMenuTheme or "theme1"
end

function settingsWrapper:setCurrentMainMenuTheme(theme)
	localSettings.currentMainMenuTheme = theme
end

--current level selection menu page, per episode
function settingsWrapper:getCurrentLevelSelectionPages()
	if localSettings.currentLevelSelectionPages == nil then
		localSettings.currentLevelSelectionPages = {}
	end

	return localSettings.currentLevelSelectionPages
end

function settingsWrapper:getCurrentLevelSelectionPage(episode)
	return settingsWrapper:getCurrentLevelSelectionPages()["pack" .. episode] or 1
end

function settingsWrapper:setCurrentLevelSelectionPage(episode, page)
	settingsWrapper:getCurrentLevelSelectionPages()["pack" .. episode] = page
end

--is audio enabled
function settingsWrapper:isAudioEnabled()
	if localSettings.audioEnabled == nil then return true end
	return localSettings.audioEnabled
end

function settingsWrapper:toggleAudioEnabled()
	if localSettings.audioEnabled == nil then
		localSettings.audioEnabled = true
	else
		localSettings.audioEnabled = not localSettings.audioEnabled
	end
end

--total play time counter, used for achievement
function settingsWrapper:getPlaytime()
	return settings.playtime or 0
end

function settingsWrapper:addPlaytime(time)
	settings.playtime = _G.math.floor(settingsWrapper:getPlaytime() + time)
end

--number of times the game has been started
function settingsWrapper:getGameStarts()
	return settings.gameStarts or 0
end

function settingsWrapper:incrementGameStarts()
	settings.gameStarts = settingsWrapper:getGameStarts() + 1
end

--total number of level restarts
function settingsWrapper:getGameRestarted()
	return settings.gameRestarted or 0
end

function settingsWrapper:incrementGameRestarted()
	settings.gameRestarted = settingsWrapper:getGameRestarted() + 1
end

--number of spendable stars in hatchery
function settingsWrapper:getHatcheryStars()
	return settings.hatcheryStars or 0
end

function settingsWrapper:addHatcheryStars(stars)
	settings.hatcheryStars = settingsWrapper:getHatcheryStars() + stars
end

--cutscene skip
function settingsWrapper:getCutscenes()
	if settings.cutscenesWatched == nil then
		settings.cutscenesWatched = {}
	end
	return settings.cutscenesWatched
end

function settingsWrapper:canSkipCutscene(cutscene)
	return settingsWrapper:getCutscenes()[cutscene] == true
end

function settingsWrapper:setCutsceneWatched(cutscene)
	settingsWrapper:getCutscenes()[cutscene] = true
end

-- location
function settingsWrapper:isFirstTimeUseLocation()
	if settings.firstTimeUseLocation == nil then
		return true
	else
		return settings.firstTimeUseLocation
	end
end

function settingsWrapper:setLocationUsed()
	settings.firstTimeUseLocation = false
end

--NFC me unlock
function settingsWrapper:getNFCMeUnlocked()
	return localSettings.NFCMeUnlock or false
end

function settingsWrapper:setNFCMeUnlocked(value)
	localSettings.NFCMeUnlock = value
end

function settingsWrapper:getNFCUnlockTimer()
	return localSettings.NFCUnlockTimer or false
end

function settingsWrapper:setNFCUnlockTimer(time)
	localSettings.NFCUnlockTimer = time
end

---achievement status
function settingsWrapper:getAchievementStatusList()
	if settings.achievementStatus == nil then
		settings.achievementStatus = {}
	end
	return settings.achievementStatus
end

function settingsWrapper:getAchievementStatus(achievement)
	local status = settingsWrapper:getAchievementStatusList()
	
	local valid_achievement = false
	
	for k, v in _G.pairs(g_achievements) do
		if k == achievement then
			valid_achievement = true
			break
		end
	end
	
	if not valid_achievement then
		print("invalid achievement id " .. _G.tostring(achievement) .. "\n")
		return false
	end
	
	if not status[achievement] then
		status[achievement] = { unlocked = false }
	end
	return status[achievement]
end

function settingsWrapper:isAchievementAlreadyUnlocked(achievement)
	local status = settingsWrapper:getAchievementStatus(achievement)
	if not status then return false end --bad ID
	
	return status.unlocked
end

function settingsWrapper:markAchievementUnlocked(achievement)
	local status = settingsWrapper:getAchievementStatus(achievement)
	if not status then return end --bad ID
	
	status.unlocked = true
end

function settingsWrapper:isCakeCollected()
	return settings.cakeCollected or false
end

function settingsWrapper:setCakeCollected()
	settings.cakeCollected = true
end

function settingsWrapper:setHatcheryLocalTime(localTime)
	settings.hatcheryLocalTime = localTime
end

function settingsWrapper:setHatcheryLastSavedServerTime(a_serverTime, a_localTime)
	settings.hatcheryLastSavedServerTime = {serverTime = a_serverTime, localTime = a_localTime}
end

function settingsWrapper:setHatcheryState(hatcheryTable)
	settings.hatcheryState = hatcheryTable
end

function settingsWrapper:getAvailableStarCoins()
	if not settings.starCoins then
		settings.starCoins = 1000
	end
	return settings.starCoins
end

function settingsWrapper:setAvailableStarCoins(val)
	settings.starCoins = val
end

function settingsWrapper:getAvailableStars()
	if not settings.stars then
		settings.stars = 1000
	end
	return settings.stars
end

function settingsWrapper:setAvailableStars(val)
	settings.stars = val
end





filename="settingsWrapper.lua"
