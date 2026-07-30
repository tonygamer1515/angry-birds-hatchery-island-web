-- ABID stuff
props_localSettingKeys = {
	"attemptsAfterEagleOffer", -- 
	"audioEnabled", --
	"averagePlaytime", --
	"crystalSplashShown", --
	"cumulativeScore", --
	"currentLevelSelectionPages", --
	"currentMainMenuSong", --
	"currentMainMenuTheme", --
	"currentThemeIndex", -- 
	"currentZoomLevelMainMenu", --
	"gfxLowQuality", -- 
	"musicEnabled", --
	
	"selectedEpisode", -- 
	
	"eaglesUsedIn", --
	"eagleUsedTime", --

	"vibraEnabled", --
	"ABIDrefreshToken", --
}

props_shopKeys = {
	"mightyEagleEnabled",
	"isPremium",
	
}

function getCombinedTable(tables)
	local combined = {}
	
	for k,v in _G.pairs(tables) do
		for k1,v1 in _G.pairs(v) do
			combined[k1] = v1
		end
	end	
	return combined
end

function generateFilteredTable(reference, exclude, keys)
	local exclude = exclude or false
	
	local filteredSettings = {}
	
	for k,v in _G.pairs(reference) do
		
		local filtered = false
		for i = 1, #keys do		
			local ignoreKey = keys[i]
			if _G.string.find(k, ignoreKey) ~= nil then
				filtered = true
				break
			end
		end
		
		if(filtered == exclude) then
			filteredSettings[k] = v
		end
	end	
	return filteredSettings
end

--------------------------
-- splits settings.lua to different files: 
-- 1. local settings(localSettings.lua), which holds state data that 
-- 	  we don't want to sync with server
--
-- 2. server state (settings.lua), which is state data that we 
--	  want to be able to restore.
--
-- 3. iAp purchased items (purchases.lua)
--     
--    
--------------------------

function convertSettings()
	gamelua.print("-------------------   CONVERTING SETTINGS")
	
	local serverFilters = getCombinedTable({props_localSettingKeys, props_shopKeys})
	
	gamelua.serverSettings = generateFilteredTable(gamelua.settings,false, serverFilters)	

	gamelua.localSettings = generateFilteredTable(gamelua.settings,true,serverFilters)	
	
	gamelua.purchases = generateFilteredTable(gamelua.settings,true, props_shopKeys)
	
	gamelua.saveLuaFileWrapper("settings.lua", "settings", true)
	gamelua.saveLuaFileWrapper("localSettings.lua", "localSettings", true)	
	gamelua.saveLuaFileWrapper("purchases.lua", "purchases", true)	

end

filename="ABIDUtils.lua"
