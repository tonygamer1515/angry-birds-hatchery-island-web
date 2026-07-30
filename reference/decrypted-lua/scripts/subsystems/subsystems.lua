---------------------------------------------
------- Root class of subsystems-------------
---------------------------------------------
SubSystem = {}
function SubSystem:new(o)
	o = o or {}
	o.children = {}
	o.x = o.x or 0
	o.y = o.y or 0
	o.name = o.name or "UNDEFINED"
	_G.setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

function SubSystem:update(dt)		
end

function SubSystem:init()
end

-----------------------------------------------
-- Generic events listener
-------------------------------------------
LinkListener = SubSystem:new()
-- TODO: FLURRY EVENTS SHOULD HAVE THEIR OWN SUBSYSTEM
function LinkListener:eventTriggered(event)
	local events = gamelua.events
	if(event.id == events.EID_GIFT_PURCHASE_CLICKED) then
		gamelua.logFlurryEvent("Apple gift purchase link clicked")
		_G.res.openURL(gamelua.APPLE_GIFT_PURCHASE_URL)

	end
	
	if(event.id == events.EID_LENOVO_ADFREE_CLICKED) then
		gamelua.logFlurryEvent("Lenovo no ads link clicked")
		_G.res.openURL(gamelua.LENOVO_NO_ADS_URL)		
	end	
	
	if(event.id == events.EID_AB_SHOP_CLICKED) then
		gamelua.logFlurryEvent("ABshop link clicked")
		_G.res.openURL(gamelua.ABSHOP_URL)			
	end

	if(event.id == events.EID_MIGHTY_EAGLE_TRAILER_CLICKED) then
--		gamelua.logFlurryEvent("ABshop link clicked")
		_G.res.openURL(gamelua.MIGHTY_EAGLE_TRAILER)			
	end
	
	if event.id == events.EID_NEWSLETTER_CLICKED then
		gamelua.logFlurryEvent("Newsletter link clicked")
		_G.res.openURL(gamelua.NEWSLETTER_URL)	
	end
	
	if event.id == events.EID_SEASONS_CLICKED then
		 gamelua.logFlurryEvent("Halloween link clicked")
		_G.res.openURL(gamelua.APP_STORE_HALLOWEEN_URL)		
	end
	--[[	
	if event.id == events.EID_GOTO_FACEBOOK_CONNECT then
		--todo: move the flurry stuff from inside the gotoABFBConnect function to a flurry subsystem when one is made?
	end]]
end


------------------------------------------
-- 	AchievementProcessor class
------------------------------------------
AchievementProcessor = SubSystem:new()

function AchievementProcessor:init()
	self.achievementUnlockQueue = {}
end

function AchievementProcessor:update(dt)
	if angryBirdsFanAchieved == nil and settingsWrapper:getPlaytime() + gamelua.currentPlaytime >= 18000 then
		self:addToAchievementUnlockQueue("Angry Birds Fan", true)
		angryBirdsFanAchieved = true
	end
		
	if trueAngryBirdsFanAchieved == nil and settingsWrapper:getPlaytime() +gamelua.currentPlaytime >= 54000 then
		self:addToAchievementUnlockQueue("True Angry Birds Fan", true)
		trueAngryBirdsFanAchieved = true
	end
		
	if angryBirdsAddicted == nil and settingsWrapper:getPlaytime() + gamelua.currentPlaytime >= 108000 then
		self:addToAchievementUnlockQueue("Angry Birds Addict", true)
		angryBirdsAddicted = true
	end	
	
end

function AchievementProcessor:eventTriggered(event)
	local settingsWrapper = gamelua.settingsWrapper
	gamelua.print("listening to triggered event : AchievementProcessor() eventTriggered : event = "..(event.id).."\n")
	if(event.id == gamelua.events.EID_GOLDEN_EGG_GAINED) then
		if(event.data["openedLevelsAmount"] == 10) then
			self:addToAchievementUnlockQueue("Egg Hunter")			
		end
	elseif(event.id == gamelua.events.EID_GOLDEN_EGG_STAR_GAINED) then
		if(event.data["starsGained"] == 10) then		
			self:addToAchievementUnlockQueue("Egg Cracker")	
		end
	elseif(event.id == gamelua.events.EID_MIGHTY_EAGLE_PURCHASED) then
			self:addToAchievementUnlockQueue("Egg Cracker")			
	elseif(event.id == gamelua.events.EID_TUTORIAL_WATCHED) then
			
		if settingsWrapper:getTutorialsForItem("BIRD_BLUE") then
			self:addToAchievementUnlockQueue("Split it!")
		end
		if settingsWrapper:getTutorialsForItem("BIRD_YELLOW") then
			self:addToAchievementUnlockQueue("Speed is the Essence")
		end
		if settingsWrapper:getTutorialsForItem("BIRD_GREY") then
			self:addToAchievementUnlockQueue("Boom Boom!")
		end
		if settingsWrapper:getTutorialsForItem("BIRD_GREEN") then
			self:addToAchievementUnlockQueue("Mother of all Bombs")
		end
		if settingsWrapper:getTutorialsForItem("BIRD_BOOMERANG") then
			self:addToAchievementUnlockQueue("Return to Sender")
		end
		if settingsWrapper:getTutorialsForItem("BIRD_BIG_BROTHER") then
			self:addToAchievementUnlockQueue("Seeing Red") 
		end
		if settingsWrapper:getTutorialsForItem("BAIT_SARDINE") then
			self:addToAchievementUnlockQueue("Aquiline Benefactor")
		end
	elseif (event.id == gamelua.events.EID_LEVEL_COMPLETED) then
			
			if event.cumulativeStars >= 750 and event.cumulativeStars < 1500 then
				self:addToAchievementUnlockQueue("Star Collector", true)
			end
			
			if event.cumulativeStars >= 1500 then
				self:addToAchievementUnlockQueue("Star Gatherer", true)
			end		
			
			if event.stars >= event.totalStars then
				self:addToAchievementUnlockQueue("Episode " .. (event.themeNumber) .. " - Total Destruction");
			end
			
			if(event.scoreAchievementLimit and event.totalScore >= event.scoreAchievementLimit) then
				self:addToAchievementUnlockQueue("Episode " .. event.themeNumber .. " - Score Addict")
			end
			
			if event.feathers >= 200 then
				self:addToAchievementUnlockQueue("Feather Gatherer")
			end
			
			if event.feathers >= 100 then
				self:addToAchievementUnlockQueue("Feather Collector")
			end
			
			if event.feathers >= 50 then
				self:addToAchievementUnlockQueue("Feather Picker")		
			end
			
			
			
	elseif(event.id == gamelua.events.EID_WORLD_COMPLETED) then
		if event.firstTime == true and event.clearAchievement ~= nil then
			self:addToAchievementUnlockQueue(event.clearAchievement)			
		end
	
	elseif(event.id == gamelua.events.EID_BLOCKS_DESTROYED) then
		gamelua.print("Event total blocks = "..(event.totalBlocks).."\n")
		if event.totalBlocks >= 50000 then
			self:addToAchievementUnlockQueue("Block Smasher", true)
		else
			--gamelua.eventManager:notify({ id = gamelua.events.EID_ACHIEVEMENT_PROGRESS, achievement = "Block Smasher", progress = event.totalBlocks, target = 50000 })
		end
		
		if event.totalBlocks >= 500000 then
			self:addToAchievementUnlockQueue("Smash Maniac", true)
		else
			--gamelua.eventManager:notify({ id = gamelua.events.EID_ACHIEVEMENT_PROGRESS, achievement = "Smash Maniac", progress = event.totalBlocks, target = 500000 })
		end
		
		if event.stalaktitesDestroyed >= 100 then
			self:addToAchievementUnlockQueue("Hard as a Rock", true)
		end

		if event.jewelsDestroyed >= 100 then
			self:addToAchievementUnlockQueue("Ultimate Bejeweler", true)
		end			
			
		if event.pigsDestroyed >= 1000 then
			self:addToAchievementUnlockQueue("Pig Popper", true)
		end
		
		if event.rockBlocksDestroyed >= 5000 then
			self:addToAchievementUnlockQueue("Stonecutter", true)
		end
					
		if event.iceBlocksDestroyed >= 5000 then
			self:addToAchievementUnlockQueue("Icepicker", true)
		end
					
		if event.woodBlocksDestroyed >= 5000 then
			self:addToAchievementUnlockQueue("Woodpecker", true)
		end
	elseif event.id == gamelua.events.EID_BOOMERANG_BIRD_POPUP_SHOWN then
		self:addToAchievementUnlockQueue("Return to Sender")
	elseif event.id == gamelua.events.EID_BIRD_SHOT then

		if event.birdsShooted >= 5000 then
			self:addToAchievementUnlockQueue("Bird Slinger", true)
		end	
		
		if event.backwardsBirdCount >= 10 then
			self:addToAchievementUnlockQueue("Backward Compatibility", true)
		end
		
	elseif event.id == gamelua.events.EID_SPACE_INVANDER then
		self:addToAchievementUnlockQueue("Space Invader", true)	
	elseif event.id == gamelua.events.EID_BIRDS_COLLIDED_ON_FLY then
		self:addToAchievementUnlockQueue("Wilhelm Tell")	
	elseif event.id == gamelua.events.EID_ACHIEVEMENT_BULLSEYE then
		self:addToAchievementUnlockQueue("Bull's Eye")
	elseif event.id == gamelua.events.EID_CAKE_COLLECTED then
		self:addToAchievementUnlockQueue("Cakemonger")
	end	

end

function AchievementProcessor:unlockNextAchievement()
	gamelua.unlockAchievement(self.achievementUnlockQueue[1].id, self.achievementUnlockQueue[1].desc)
	_G.table.remove(self.achievementUnlockQueue, 1)	
end

function AchievementProcessor:addToAchievementUnlockQueue(desc, inFront)
	_G.assert(desc ~= nil)
	local first_time = not gamelua.settingsWrapper:isAchievementAlreadyUnlocked(desc)
	gamelua.eventManager:notify({id = gamelua.events.EID_ACHIEVEMENT_UNLOCKED, name = desc, first_time_unlocked = first_time })
	if first_time then
		gamelua.settingsWrapper:markAchievementUnlocked(desc)
		gamelua.saveLuaFileWrapper("settings.lua", "settings", true)
	end
	
	gamelua.print("<achievement> Added achievement '"..desc.."' to unlock queue\n")
	if gamelua.achievements ~= nil and gamelua.achievements[desc] ~= nil then
		local id = gamelua.achievements[desc].id
		for i = 1, #self.achievementUnlockQueue do
			if self.achievementUnlockQueue[i].id == id then
				return
			end
		end
		inFront = inFront or false
		if inFront then
			_G.table.insert(self.achievementUnlockQueue, 1, {id = id, desc = desc} )
		else
			_G.table.insert(self.achievementUnlockQueue, {id = id, desc = desc} )
		end
	end
end

function AchievementProcessor:checkForAchievements()
	gamelua.print("checking achievements...\n")
	local settings = gamelua.settings
	local settingsWrapper = gamelua.settingsWrapper
	local g_episodes = gamelua.g_episodes
	local totalBlocks = 0
	totalBlocks = totalBlocks + settingsWrapper:getWoodBlocksDestroyed()
	totalBlocks = totalBlocks + settingsWrapper:getIceBlocksDestroyed()
	totalBlocks = totalBlocks + settingsWrapper:getRockBlocksDestroyed()
	
	if settingsWrapper:getWilhelmTell() then
		self:addToAchievementUnlockQueue("Wilhelm Tell")
	end
	
	if settingsWrapper:getBullsEye() then
		self:addToAchievementUnlockQueue("Bull's Eye")
	end
	
	for i = 1, #g_episodes do
		if not g_episodes[i].extra then
			for j = 1, #g_episodes[i].pages do
				if settingsWrapper:isThemeCompleted(g_episodes[i].pages[j].world_number) and g_episodes[i].pages[j].clear_achievement then
					self:addToAchievementUnlockQueue(g_episodes[i].pages[j].clear_achievement)
				end
			end
		
			local stars, total_stars = gamelua.calculateEpisodeStars(i)
			if stars >= total_stars then
				self:addToAchievementUnlockQueue("Episode " .. i .. " - Total Destruction")
			end
			
			local total_score = gamelua.calculateEpisodeScore(i)
			if g_episodes[i].score_achievement_limit and total_score >= g_episodes[i].score_achievement_limit then
				self:addToAchievementUnlockQueue("Episode " .. i .. " - Score Addict")
			end
		
		end
	end
	
	local feathers, maxFeathers = gamelua.calculateAllFeathers()
	--print("Checking for feather achievement, feathers: " .. feathers .. ", maxFeathers: " .. maxFeathers .. "\n")
	if feathers >= 200 then
		self:addToAchievementUnlockQueue("Feather Gatherer")
	end
	if feathers >= 100 then
		self:addToAchievementUnlockQueue("Feather Collector")
	end
	if feathers >= 50 then
		self:addToAchievementUnlockQueue("Feather Picker")		
	end

	if settingsWrapper:getTutorialsForItem("BIRD_BLUE") ~= nil then
		self:addToAchievementUnlockQueue("Split it!")
	end
	
	if settingsWrapper:getTutorialsForItem("BIRD_YELLOW") ~= nil then
		self:addToAchievementUnlockQueue("Speed is the Essence")
	end
	
	if settingsWrapper:getTutorialsForItem("BIRD_GREY") ~= nil then
		self:addToAchievementUnlockQueue("Boom Boom!")
	end
	
	if settingsWrapper:getTutorialsForItem("BIRD_GREEN") ~= nil then
		self:addToAchievementUnlockQueue("Mother of all Bombs")
	end
	
	if settingsWrapper:getTutorialsForItem("BIRD_BOOMERANG") ~= nil then
		self:addToAchievementUnlockQueue("Return to Sender")
	end
	
	if settingsWrapper:getTutorialsForItem("BIRD_BIG_BROTHER") ~= nil then
		self:addToAchievementUnlockQueue("Seeing Red")
	end
	
	if settingsWrapper:getTutorialsForItem("BAIT_SARDINE") ~= nil then
		self:addToAchievementUnlockQueue("Aquiline Benefactor")
	end
	
	if settingsWrapper:getBackwardsBirdCount() >= 10 then
		self:addToAchievementUnlockQueue("Backward Compatibility", true)
	end
	
	if totalBlocks >= 50000 then
		self:addToAchievementUnlockQueue("Block Smasher", true)
	end
	
	if totalBlocks >= 500000 then
		self:addToAchievementUnlockQueue("Smash Maniac", true)
	end
	
	if settingsWrapper:getWoodBlocksDestroyed() >= 5000 then
		self:addToAchievementUnlockQueue("Woodpecker", true)
	end

	if settingsWrapper:getJewelsDestroyed() >= 100 then
		--print(" ::::::::::: ULTIMATE BEJEWELER ADDED TO ACH QUE")
		self:addToAchievementUnlockQueue("Ultimate Bejeweler", true)
	end

	if settingsWrapper:getStalaktitesDestroyed() >= 100 then
		--print(" ::::::::::: HARD AS ROCK ADDED TO ACH QUE")
		self:addToAchievementUnlockQueue("Hard as a Rock", true)
	end
	
	if settingsWrapper:getIceBlocksDestroyed() >= 5000 then
		self:addToAchievementUnlockQueue("Icepicker", true)
	end
	
	if settingsWrapper:getRockBlocksDestroyed() >= 5000 then
		self:addToAchievementUnlockQueue("Stonecutter", true)
	end
	
	if settingsWrapper:getPigsDestroyed() >= 1000 then
		self:addToAchievementUnlockQueue("Pig Popper", true)
	end
	
	if gamelua.calculateOpenGoldenEggLevels() >= 10 then
		self:addToAchievementUnlockQueue("Egg Hunter")
	end
	
	if gamelua.calculateStarsFromGoldenEggLevels() >= 10 then
		self:addToAchievementUnlockQueue("Egg Cracker")
	end
	
	if settingsWrapper:getPlaytime() >= 18000 then
		self:addToAchievementUnlockQueue("Angry Birds Fan", true)
	end
	
	if settingsWrapper:getPlaytime() >= 54000 then
		self:addToAchievementUnlockQueue("True Angry Birds Fan", true)
	end
	
	if settingsWrapper:getPlaytime() >= 108000 then
		self:addToAchievementUnlockQueue("Angry Birds Addict", true)
	end
	
	if settings.cumulativeStars ~= nil and settings.cumulativeStars >= 750 then
		self:addToAchievementUnlockQueue("Star Collector", true)
	end
	
	if settings.cumulativeStars ~= nil and settings.cumulativeStars >= 1500 then
		self:addToAchievementUnlockQueue("Star Gatherer", true)
	end
	
	if settingsWrapper:getBirdsShot() >= 5000 then
		self:addToAchievementUnlockQueue("Bird Slinger", true)
	end
	
	if settingsWrapper:isCakeCollected() then
		self:addToAchievementUnlockQueue("Cakemonger")
	end
end

filename="subsystems.lua"
