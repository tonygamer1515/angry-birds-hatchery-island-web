loggingEnabled = true

RovioNews = gamelua.subsystems.SubSystem:new()

function RovioNews:init()
	-- instance variables
	self.configInit = false

	-- location
	self.hasLocationCapability = false
	-- when this flag is true, users haven't opened the map view for the 1st time yet
	-- Thus we need to show a simple tutorial and after that ask for permission to use location
	self.firstTimeUseLocation = true
	-- if location serviec enabled
	self.locationEnabled = false
	-- is the map visible now? This affects how accurate we demand from the location framework
	self.mapVisible = false

	self.locationTimer = 0 -- location polling timer
	self.locationPollingInterval = 30 -- polling interval for location. More frequent when map is visible
	self.latitude = 0
	self.longitude = 0

	-- NEWS, FEED and ACHIEVEMENTS
	self.news = {}
	self.feed = {}
	self.numOfNewFeeds = 0
	self.numOfNewAchs = 0

	-- Events
	local events = gamelua.events	
	self.name = "RovioNews"
	self.testRovioNews = false
	gamelua.eventManager:addEventListener(events.EID_SHOW_TUTORIAL, self)
	gamelua.eventManager:addEventListener(events.EID_PAUSE_CLICKED, self)
	gamelua.eventManager:addEventListener(events.EID_GAME_PAUSED, self)
	gamelua.eventManager:addEventListener(events.EID_LEVEL_LOADING_DONE, self)
	gamelua.eventManager:addEventListener(events.EID_BACK_TO_GAME_CLICKED, self)
	gamelua.eventManager:addEventListener(events.EID_MENUMANAGER_ROOT_CHANGED, self)
	gamelua.eventManager:addEventListener(events.EID_GAME_RESUMED, self)
	
	if gamelua.g_notificationsEnabled then
		if not gamelua.subsystemsapi.isiOS() then
			gamelua.eventManager:addEventListener(events.EID_ACHIEVEMENT_UNLOCKED, self)		
		end
		gamelua.eventManager:addEventListener(events.EID_MIGHTY_EAGLE_UNLOCK_ONCE_COOLDOWN, self)
		gamelua.eventManager:addEventListener(events.EID_MIGHTYEAGLE_UNLOCK_ONCE, self)
		gamelua.eventManager:addEventListener(events.EID_EAGLE_BAIT_LAUNCHED, self)
	end

	self:initializeLocation()
end

function RovioNews:eventTriggered(event)
	local events = gamelua.events
	local notify = false
	local text = ""
	local action = ""
	local icon = ""

	if gamelua.currentGameMode == gamelua.updateGame and (event.id == events.EID_GAME_RESUMED or event.id == events.EID_PAUSE_CLICKED or event.id == events.EID_GAME_PAUSED) then
		self.active = true
--		if gamelua.g_tutorialActive ~= nil then
--			return
--		end
	
		if gamelua.rovioNewsCreated ~= true and (gamelua.subsystemsapi.isAndroid() or gamelua.subsystemsapi.isiOS()) then
			self:initializeRovioNews()
		else
			self:showRovioNews()
		end
	elseif event.id == events.EID_LEVEL_LOADING_DONE then
		self:hideRovioNews()
	elseif event.id == events.EID_BACK_TO_GAME_CLICKED then
		self:hideRovioNews()
	elseif event.id == events.EID_SHOW_TUTORIAL then
		self:hideRovioNews()		
	elseif event.id == events.EID_MENUMANAGER_ROOT_CHANGED then
		self.active = false
		
		if event.root.name == "LevelSelectionRoot" then
			self:hideRovioNews()
		end
	elseif event.id == events.EID_ACHIEVEMENT_UNLOCKED then
		if event.first_time_unlocked then
			notify = true
			text = event.name
			icon = gamelua.subsystemsapi.getAchievementIconByName(event.name)
			self.numOfNewAchs = self.numOfNewAchs + 1
		end
	elseif event.id == events.EID_MIGHTY_EAGLE_UNLOCK_ONCE_COOLDOWN then
		--notify = true
		text = "You can't unlock the Mighty Eagle now"
	elseif event.id == events.EID_MIGHTYEAGLE_UNLOCK_ONCE then
		notify = true
		text = "You found a treasure"
		action = gamelua.magic.actions.SHOW_NEWS
		-- icon is defined by notification css
		icon = "TREASURE_ICON"
		-- todo properly define the reward object as well as reward id!
		self:addReward({id = "MIGHTYEAGLE_UNLOCK_ONCE"})
	elseif event.id == events.EID_EAGLE_BAIT_LAUNCHED then
		self:removeReward({id = "MIGHTYEAGLE_UNLOCK_ONCE"})
	end

	if text == "" then return end

	if notify then
		self:notifyEvent(text, action, icon)
	end
end

function RovioNews:notifyEvent(text, action, icon)
	if text == "" then return end
	action = action or ""
	icon = icon or ""

	gamelua.magic.notifyTopbar(text, action, icon)
end

function RovioNews:showRovioNews()
	-- showView() function will take care that if the current Rovio
	-- news view is Map, it will be set to visible
	self.active = true
	if gamelua.rovioNews ~= nil then
		gamelua.rovioNews:executeJavaScript("showView()")
	end
end

function RovioNews:hideRovioNews()
	self.active = false
	if gamelua.rovioNewsIsShown then
		gamelua.rovioNews:hide()
		gamelua.rovioNewsIsShown = false
	end
	gamelua.rovioNewsShowWhenLoaded = false

	-- Pause menu is dismissed and if the current view is Map, we need to set it to invisible
	if self.mapVisible then
		self:setMapVisible(false)
		log("Pause menu is dismissed, and set map invisible")
	end
end

function RovioNews:initializeRovioNews()

	if self.testRovioNews then
		gamelua.rovioNewsIsLoaded = true		
		gamelua.rovioNewsIsShown = true
	end

	gamelua.loginfo(" - creating rovio news")
	local screenHeight = gamelua.screenHeight
	local screenWidth = gamelua.screenWidth
	
	local x = gamelua.ui.PausePage.getTotalW()		
	local y = 0
	local height = screenHeight
	local width = screenWidth - x
	
	if gamelua.subsystemsapi.isiPhone4() and screenWidth ~= 480 then
		height = screenHeight/2
		width = screenWidth/2 - x
	end
		
	-- Create a WebView	
	if(_G.WebView == nil) then
		gamelua.loginfo(" - creating rovio news: WebView Was nil, returning")		
		return		
	end
	
	gamelua.rovioNews = _G.WebView.new(x, y, height, width)
	gamelua.rovioNewsCreated = true
	
	-- Add onLinkClicked call-back
	local onLinkClicked = function(view, url)
		local linkAction = self:processStoreURL(url)
		return linkAction
	end
	
	gamelua.rovioNews:setOnLinkClickedCallback(onLinkClicked)
	
	-- Load RovioNews
	local onPageLoaded = function(view, success, pageTitle)
		if success and pageTitle == "Rovio News [hjsdu]" then
			gamelua.rovioNewsIsLoaded = true
			if gamelua.rovioNewsShowWhenLoaded then
				gamelua.hideAd()
				view:show()
				gamelua.rovioNewsIsShown = true
			end

			self:initConfiguration()
		end
	end

	if not gamelua.releaseBuild then
		gamelua.ROVIO_NEWS_URL = "http://ec2-50-19-40-11.compute-1.amazonaws.com/ui/";
	end
	
	gamelua.rovioNewsShowWhenLoaded = true
	gamelua.rovioNews:setOnPageLoadedCallback(onPageLoaded)

	gamelua.rovioNews:loadPage(gamelua.ROVIO_NEWS_URL)
	gamelua.loginfo(" - creating rovio news: Done")
end

function RovioNews:initConfiguration()
	if self.configInit then return end

	self.configInit = true
	gamelua.rovioNews:allowCallsFromJavaScript("_G.rovioNewsNamespace")

	-- todo: Get Rovio's official API key and account!!!!!!!!
	-- mapAPIKey is from account "miaoqing.tan" at http://cloudmade.com/
	local config = { firstTimeUseLocation = self.firstTimeUseLocation,
			  uniqueDeviceId = gamelua.uniqueDeviceId,
			  mapAPIKey = "2db38246cba74fb8a846a3b30000cbd9",
			  mapUserId = "miaoqing.tan" }
	local configJSON = luaTableToJSON(config)
	log("initConfiguration: " .. configJSON)
	gamelua.rovioNews:executeJavaScript("initConfiguration(".. configJSON ..")")
end

function RovioNews:update(dt, time)
	if not self.active then return end

	if gamelua.menuManager ~= nil and gamelua.menuManager:getRoot() ~= nil then
		--if gamelua.menuManager:getRoot().name == "gameHud" and gamelua.menuManager:getRoot():getChild("pausePage").visible then
			if gamelua.rovioNewsIsLoaded and not gamelua.rovioNewsIsShown then --and gamelua.g_tutorialActive ~= nil then
				gamelua.print(" - - - - - - - - - - - update")
				gamelua.hideAd()
				gamelua.rovioNews:show()
				gamelua.rovioNewsIsShown = true
				gamelua.eventManager:notify({id = gamelua.events.EID_ROVIO_NEWS_SHOWN})				
			end	
		
		--end
		gamelua.rovioNewsShowWhenLoaded = false
	end

	if not self.hasLocationCapability then return end
	self.locationTimer = self.locationTimer + dt
	if self.locationTimer > self.locationPollingInterval then
		if gamelua.isLocationEnabled() then
			self:updateLocation()
			-- user has turned on the location service
			if not self.locationEnabled then
				self:enableLocation()
			end
		elseif self.locationEnabled == true then
			-- user has turned off the location service
			self:disableLocation()
		end
		self.locationTimer = 0
	end
end

-------------------------------------------------------------------------
-- Location related methods						 --
-------------------------------------------------------------------------

function RovioNews:initializeLocation()
	self.hasLocationCapability = gamelua.hasLocationCapability()
	if self.hasLocationCapability then
		self.firstTimeUseLocation = gamelua.settingsWrapper:isFirstTimeUseLocation()
		if self.firstTimeUseLocation == false then
			if gamelua.isLocationEnabled() then
				self:setMapVisible(false)
				self:enableLocation()
				log("Location is enabled, start tracking location updating")
			end
		else
			log("User has not yet used the location feature")
		end
	else
		log("The current platform does not have location capability")
	end
end

-- only call this function when gamelua.isLocationEnabled() is true
function RovioNews:updateLocation()
	local lat = gamelua.latitude()
	local lng = gamelua.longitude()
	if self.latitude ~= lat or self.longitude ~= lng then
		self.latitude = lat
		self.longitude = lng

		if gamelua.rovioNews ~= nil then
			local func = "updateMyLocation(" .. self.latitude .. "," .. self.longitude .. ")"
			gamelua.rovioNews:executeJavaScript(func)
		end

		log("new location: " .. self.latitude .. ", " .. self.longitude)
	end
end

function RovioNews:enableLocation()
	self.locationEnabled = true
	gamelua.startLocationUpdating()

	log("enableLocation")
end

function RovioNews:disableLocation()
	self.locationEnabled = false
	gamelua.stopLocationUpdating()

	log("disableLocation")
end

function RovioNews:setMapVisible(visible)
	if self.hasLocationCapability == false then return end

	if self.firstTimeUseLocation then
		if visible then
			-- 1st time use case: start tracking location update
			self:visibleSetting()

			-- this will trigger the location permission dialog
			-- if location service is disabled, this WILL trigger permission dialog
			self.firstTimeUseLocation = false
			gamelua.settingsWrapper:setLocationUsed()
			-- if user deny it, we will stop location update in next update()
			self:enableLocation()
			gamelua.saveLuaFileWrapper("settings.lua", "settings", true)
			log("Use location for the first time. Ask user's permission")
		end
	else
		if visible then
			self:visibleSetting()
		else
			self:invisibleSetting()
		end
	end
end

function RovioNews:visibleSetting()
	-- when map is visible, we should poll the location update more frequently with best accuracy
	self.mapVisible = true
	gamelua.setLocationAccuracy(gamelua.location.ACCURACY_BEST)
	gamelua.setDistanceFilter(10)
	self.locationPollingInterval = 5
	log("setMapVisible: true")
end

function RovioNews:invisibleSetting()
	-- TODO ACCURACY_NORMAL is defined as kCLLocationAccuracyHundredMeters in iOS currently
	-- Need to verify if it's good enough
	self.mapVisible = false
	gamelua.setLocationAccuracy(gamelua.location.ACCURACY_NORMAL)
	gamelua.setDistanceFilter(100)
	self.locationPollingInterval = 30
	log("setMapVisible: false")
end

-------------------------------------------------------------------------
-- NEWS, REWARDS, FEED and ACHIEVEMENTS						 --
-------------------------------------------------------------------------

function RovioNews:addNews(news)
	if news == "" then return end

	for i, v in _G.ipairs(self.news) do
		if v == news then
			return
		end
	end

	log("Adding local news")
	_G.table.insert(self.news, news)
end

function RovioNews:removeNews(news)
	if news == "" then return end

	for i, v in _G.ipairs(self.news) do
		if v == news then
			log("Removing local news")
			_G.table.remove(self.news, i)
			return
		end
	end
end

function RovioNews:readNews()
	return stringArrayToJS(self.news)
end

-- e.g. reward object: { id = "MIGHTYEAGLE_UNLOCK_ONCE" }
function RovioNews:addReward(reward)
	if gamelua.rovioNews ~= nil then
		local callback = "addGameReward(".. luaTableToJSON(reward) ..")"
		gamelua.rovioNews:executeJavaScript(callback)
	end
end

function RovioNews:removeReward(reward)
	if gamelua.rovioNews ~= nil then
		local callback = "removeGameReward(".. luaTableToJSON(reward) ..")"
		gamelua.rovioNews:executeJavaScript(callback)
	end
end

function RovioNews:addFeedItem(item)
	if item ~= "" then
		_G.table.insert(self.feed, item)
		self.numOfNewFeeds = self.numOfNewFeeds + 1
		log(item.." added to feed")
	end
end

function RovioNews:readFeed()
	return stringArrayToJS(self.feed)
end

function RovioNews:readAchievements()
	local res = objectArrayToJSON(gamelua.subsystemsapi.getAchievements())
	log("readAchievements: " .. res)

	return res
end

function RovioNews:readUnlockedAchievements()
	local res = objectArrayToJSON(gamelua.subsystemsapi.getUnlockedAchievements())
	-- [{name:'Speed is the Essence',icon:'ACHIEVEMENT_GET_YELLOW_BIRD'},
	--  {name:'Return to Sender',icon:'ACHIEVEMENT_GET_BOOMERANG_BIRD'}]
	log("readUnlockedAchievements: " .. res)

	return res
end

-------------------------------------------------------------------------
-- rovioNewsNamespace namespace functions which can be invoked from javascript code --
-------------------------------------------------------------------------

_G.rovioNewsNamespace = {}

_G.rovioNewsNamespace.unlockReward = function(rewardId)
	if rewardId == "MIGHTYEAGLE_UNLOCK_ONCE" then
		gamelua.unlockMightyEagleNFC()
	end

	log("unlockReward called from javascript: " .. rewardId)
end

-- parameter item is a text string descibing the item
_G.rovioNewsNamespace.addNotification = function(item, action, icon)
	action = action or ""
	icon = icon or ""
	gamelua.magic.notifyTopbar(item, action, icon)

	log("addNotification called from javascript. action: "..action)
end

_G.rovioNewsNamespace.removeNews = function(news)
	gamelua.rovioNewsSubSystem:removeNews(news)
end

_G.rovioNewsNamespace.readNews = function()
	if gamelua.rovioNews ~= nil then
		local callback = "setNewsSource(".. gamelua.rovioNewsSubSystem:readNews() ..")"
		gamelua.rovioNews:executeJavaScript(callback)

		log("readNews called from javascript. Callback: " .. callback)
	end
end

_G.rovioNewsNamespace.readFeed = function()
	log("readFeed called from javascript. Number of new feeds: " .. gamelua.rovioNewsSubSystem.numOfNewFeeds)
	gamelua.rovioNewsSubSystem.numOfNewFeeds = 0
end

_G.rovioNewsNamespace.readAchievements = function()
	if gamelua.rovioNews ~= nil then
		local callback  = "setAchievementSource("..gamelua.rovioNewsSubSystem:readAchievements()..")"
		gamelua.rovioNews:executeJavaScript(callback)
		log("readAchievements called from javascript. Number of new achivements: " .. gamelua.rovioNewsSubSystem.numOfNewAchs)
		gamelua.rovioNewsSubSystem.numOfNewAchs = 0
	end
end

_G.rovioNewsNamespace.readUnlockedAchievements = function()
	if gamelua.rovioNews ~= nil then
		local callback  = "setUnlockedAchievementSource("..gamelua.rovioNewsSubSystem:readUnlockedAchievements()..")"
		gamelua.rovioNews:executeJavaScript(callback)
		log("readUnlockedAchievements called from javascript. Number of new achivements: " .. gamelua.rovioNewsSubSystem.numOfNewAchs)
		gamelua.rovioNewsSubSystem.numOfNewAchs = 0
	end
end

_G.rovioNewsNamespace.setMapVisible = function(visible)
	-- looks like javascript can only pass a string as parameter at the moment
	visible = visible or "0"
	local v = false;
	if visible == "1" then
		v = true;
	end

	log("setMapVisible called from javascript.")
	if gamelua.rovioNewsSubSystem.mapVisible ~= v then
		gamelua.rovioNewsSubSystem:setMapVisible(v)
	else
		log("Ignore the call since it's same with the current visibility")
	end
end

-------------------------------------------------------------------------
-- APP Launcher processing
-------------------------------------------------------------------------

function RovioNews:processStoreURL(url) 
		-- local url = "http://www.angrybirds.com/redirect.php?device=iphone4&product=angrybirdsrio&version=1.3.0&variant=full&type=angrybirdsseasonsfull&ref=news"
		-- check that url begins with storelink
		-- new url: http://cloud.rovio.com/link/redirect/?d=iphone&p=abc&a=full&v=1.6.3&t=angrybirdsseasonsfull&r=news

		-- Only for iOS devices for now
		if (gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4" or gamelua.deviceModel == "ipad") then 
		
			-- get the product type (classic, seasons, rio, etc..) from link URL
			local sStart, sEnd = _G.string.find(url, "t=")
			local productType = _G.string.sub(url, sEnd+1) -- .. might want to cut to next &

			-- if there is & separator found, we cut to that
			local cStart, cEnd = _G.string.find(productType, "&")
			if (cEnd ~= nil) then
				productType = _G.string.sub(productType, cEnd+1)
			end

			-- use current device to see if there is a game installed for this device
			local device = gamelua.deviceModel
			if (device == "iphone4") then
				device = "iphone"
			end

			local gameURL = applauncher_schemas[device .. "-" .. productType];
			local gameSchema = ""

			if gameURL ~= nil then
				gameSchema = gameURL.schema .. "://"
			else
				gameSchema = "no such product???"
			end

			gamelua.loginfo("Selected gameschema: " .. _G.tostring(gameSchema) .. "\n")

			if (gamelua.canOpenProgram(gameSchema)) then
				-- open installed app in iPhone
				gamelua.openProgram(gameSchema)

				return _G.WebView.DONT_LOAD_PAGE
			else 
				-- open in external browser
				return _G.WebView.LOAD_PAGE_INTO_EXTERNAL_BROWSER
			end

		end
end

applauncher_schemas = {
	["iphone-angrybirdsfull"] = { schema = "angrybirds" },
	["iphone-angrybirdsfree"] = { schema = "angrybirds-free" },
	["ipad-angrybirdsfull"] = { schema = "angrybirds-hd" },
	["ipad-angrybirdsfree"] = { schema = "angrybirds-free-hd" },

	["iphone-angrybirdsseasonsfull"] = { schema = "angrybirds-seasons" },
	["iphone-angrybirdsseasonsfree"] = { schema = "angrybirds-seasons-free" },
	["ipad-angrybirdsseasonsfull"] = { schema = "angrybirds-seasons-hd" },
	["ipad-angrybirdsseasonsfree"] = { schema = "angrybirds-seasons-free-hd" },

	["iphone-angrybirdsriofull"] = { schema = "angrybirds-rio" },
	["iphone-angrybirdsriofree"] = { schema = "angrybirds-rio-free" },
	["ipad-angrybirdsriofull"] = { schema = "angrybirds-rio-hd" },
	["ipad-angrybirdsriofree"] = { schema = "angrybirds-rio-free-hd" },
}

-------------------------------------------------------------------------
-- Utils		 						 --
-------------------------------------------------------------------------

function log(message)
	if loggingEnabled then
		gamelua.print("[RovioNews] " .. _G.tostring(message) .. "\n")
	end
end

function stringArrayToJS(array)
	local n = _G.table.getn(array)
	local arrayString = "[]"

	if n > 0 then
		arrayString = "['"..array[1].."'"

		if n>1 then
			for i=2, n do
				arrayString = arrayString..",'"..array[i].."'"
			end
		end

		arrayString = arrayString.."]"
	end

	return arrayString
end

function objectArrayToJSON(array)
	local n = _G.table.getn(array)
	local arrayString = "[]"

	if n > 0 then
		arrayString = "[".. luaTableToJSON(array[1])..""
		if n > 1 then
			for i = 2, n do
				arrayString = arrayString..","..luaTableToJSON(array[i])
			end
		end
		arrayString = arrayString.."]"
	end

	return arrayString
end

function luaTableToJSON(luatable)
	local keyvalues = {}
	for k, v in _G.pairs(luatable) do
		if v == true then
			_G.table.insert(keyvalues, "\"" .. k.."\":".. 1 .."")
		elseif v ~= false then
			_G.table.insert(keyvalues, "\"" .. k.."\":\"".. v .."\"")
		end
	end

	local obj = "{}"
	local len = _G.table.getn(keyvalues)
	if len > 0 then
		obj = "{" .. keyvalues[1]
		if len > 1 then
			for i = 2, len do
				obj = obj .. ","..keyvalues[i]
			end
		end
		obj = obj .. "}"
	end

	return obj
end

--[[
else
			if gamelua.rovioNewsIsShown then
				self:hideRovioNews()
			end
]]
-- debug draw only!
function RovioNews:draw(x,y)
	if gamelua.rovioNewsIsShown then
		gamelua.drawRect(1,0,0,0.5,gamelua.screenWidth * 0.5,0, gamelua.screenWidth * 0.95, gamelua.screenHeight, false)		
	end
end

filename="RovioNews.lua"
