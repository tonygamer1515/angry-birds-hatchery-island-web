-- non-release builds have all levels unlocked
gamelua.releaseBuild = true

-- show editor button in the menu. Note: not working right now!
gamelua.showEditor = false

-- enable cheats
gamelua.cheatsEnabled = false

-- premium builds don't have ads on android
gamelua.isPremium = false

--enable hatchery
gamelua.g_hatcheryEnabled = true



--enable challenges
gamelua.g_challengesEnabled = false

--enable in-game notifications
gamelua.g_notificationsEnabled = true

--enable magic (profile, feed, location)
gamelua.g_magicEnabled = false

--enable star grinding and display of star count
gamelua.g_hatcheryCurrencyEnabled = false

--we are having memory issues so we need to separate the
--sprite assets
gamelua.g_hatcheryEnableBirdSelector = false

-- change this to true if the build needs korean splash etc.
gamelua.isKorea = false

-- enable or disable seasons link
gamelua.isSeasonsAvailable = true

--This needs to be used if the build is going to China markets
gamelua.applyChinaRestictions = false

--gamelua.ABIDEnabled = true

-- game version number is replaced in the about text with this one
-- build script updates the correct version here
gamelua.gameVersionNumber = "2.0.0"

-- Tracker ID, used for build customization
gamelua.customerString = "rovio"

-- svn revision for detailed build id
gamelua.svnRevisionNumber = "66662"

-- magic server environment: dev,beta,live
gamelua.magicServerEnvironment = "dev"


-- 1 = Cheats
-- 2 = Unlocked
-- 3 = Release
--[[
BUILD_MODE = 1

---------------------
-- CHEATS
----------------------
if(BUILD_MODE == 1) then

	gamelua.cheatsEnabled = true
	gamelua.releaseBuild = true
----------------
------ UNLOCKED
-------------------
elseif(BUILD_MODE == 2) then

	gamelua.cheatsEnabled = true
	gamelua.releaseBuild = false

	
----- RELEASE
elseif(BUILD_MODE == 3) then
	gamelua.cheatsEnabled = false
	gamelua.releaseBuild = true	
end
]]

filename="options.lua"
