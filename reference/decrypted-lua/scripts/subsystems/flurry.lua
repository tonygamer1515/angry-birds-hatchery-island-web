Flurry = gamelua.subsystems.SubSystem:new()

function Flurry:eventTriggered(event)

	local events = gamelua.events
	local loginfo = gamelua.loginfo
	
	if event.id == events.EID_GOTO_FACEBOOK_CONNECT then
		self:logEvent("ABFBConnect link clicked")
	end
	
	if event.id == events.EID_GE_LEVEL_RESTARTED then
		--logFlurryEventWithParam("Golden egg level restarted", "Level", "" .. goldenEggLevelMapping["Level" .. currentLevelNumberInTheme]) 
		self:logEvent("Golden egg level restarted", {
			Level = event.levelName
		
		})		
	end
	
	-- menu movement events stuffies
	if event.id == events.EID_CHANGE_SCENE then		
		if event.target == nil or (event.target ~= nil and _G.type(event.target) == "table" and event.target.name == nil) then 
			logwarning("Flurry:eventTriggered, no target for event EID_CHANGE_SCENE")
			return
		end
		
		local targetName = event.target
		if _G.type(event.target) == "table" then
			targetName = event.target.name
		end

		loginfo("Flurry:eventTriggered, event = EID_CHANGE_SCENE, target = ".._G.tostring(targetName))
				
		-- <episode enter events>
		local episodes = gamelua.subsystemsapi:getTotalEpisodes()
		for i = 1, episodes do
			if targetName == "LEVEL_SELECTION_"..i then
				self:logEvent("goto episode "..i)
			end		
		end
		
		if targetName == "LEVEL_SELECTION_G" then
			self:logEvent("goto episode GE")			
		end	
		-- </episode enter events>

		-- entered episode selection
		if targetName == "EPISODE_SELECTION" then
			self:logEvent("Episode selection entered")			
		end			
	end

	
	if event.id == events.EID_LEVEL_PLAYED_WITH_EAGLE then
		local _, episode, page, index = gamelua.getLevelById(event.level)
		local world_number = gamelua.g_episodes[episode].pages[page].world_number or -1
	
		self:logEvent("ME: Level played",
		{
			Level = world_number .. "-" .. index,
		})
		
		-- if the level was skipped using the eagle, send a separate event about it
		if event.skipped then
			self:logEvent("ME: Level skipped",
			{
				Level = world_number .. "-" .. index,
			})
		end
	end
	
	
	if event.id == events.EID_ABOUT_MENU_OPENED then
		self:logEvent("About menu viewed")
	end

	
	if event.id == events.EID_CHANGE_LEVEL then
		if event.data ~= nil then
			if event.data.flurryId ~= nil then
				self:logEvent("Facebook level clicked "..event.data.flurryId)
			end
		end
	end
	
	if event.id == events.EID_EAGLE_FEATHER_GAINED then
		local _, episode, page, index = gamelua.getLevelById(event.level)
		local world_number = gamelua.g_episodes[episode].pages[page].world_number or -1
		
		self:logEvent("ME: got feather",
		{
			Level = world_number .. "-" .. index,
		})
	end
	
	-- Tested on windows
	if event.id == events.EID_MIGHTYEAGLE_PURCHASED then		
		
		if event.from ~= "MAIN_MENU" then
			-- params needs to be global table, since flurry is using it.			

			params = {}
			params["From"] = event.from or "" --gamelua.getWorldLevelNumberCombination()
			local levelSkip = "no"
			if event.usedAsLevelSkip then
				levelSkip = "yes"
			end
			params["levelSkip"] = levelSkip
			
			if event.status ~=4 and gamelua.subsystemsapi:isAndroid() then
				self:logEvent("ANDROID: ME purchase",{Result = "success"})
			end				

			loginfo("Flurry: mighty eagle purchased at "..gamelua.getWorldLevelNumberCombination()..", level skip = "..levelSkip.."\n")
			self:logEvent("ME: purchased", params)
		else
			params = {}
			params["From"] = "MainMenu"
			params["levelSkip"] = "no"
			
			if event.status ~=4  and gamelua.subsystemsapi:isAndroid() then
				--logFlurryEventWithParam("ANDROID: ME purchase", "Result", "success")	
				self:logEvent("ANDROID: ME purchase", {Result = "success"})
					
			end

			gamelua.loginfo("Flurry: mighty eagle purchased at MainMenu, level skip = no \n")
			self:logEvent("ME: purchased", params)
			
		end
	end
	
	-- TODO: test
	if event.id == events.EID_MIGHTYEAGLE_RESTORED then
		loginfo("Flurry: Mighty eagle restored")	
		self:logEvent("Mighty eagle restored")
	end
	
	
	
	-- TODO: test
	if event.id == events.EID_ME_PURCHASE_FAILED_OTHER then
		if gamelua.subsystemsapi.isAndroid() then
			self:logEvent("ANDROID: ME purchase", {Result = "fail"})
		end
		self:logEvent("Mighty eagle purchase failed")		
	end
	
	-- TODO: test
	if event.id == events.EID_ME_PURCHASE_CANCELLED_BY_USER then
		loginfo("Flurry: Mighty eagle purchase cancelled by user")	
		
		if gamelua.subsystemsapi.isAndroid() then
			self:logEvent("ANDROID: ME purchase", {Result = "user cancelled"})	
		end
		self:logEvent("Mighty eagle purchase canceled")
	end
	
	
	if event.id == events.EID_NEW_HIGHSCORE then
		local _, episode, page, index = gamelua.getLevelById(event.level)
		local world_number = gamelua.g_episodes[episode].pages[page].world_number or -1
	
		if event.oldHighscore < gamelua.starTable[event.level].silverScore and event.newHighscore >= gamelua.starTable[event.level].silverScore then
			self:logEvent("Level complete first time 2 stars",
			{
				Level = world_number .. "-" .. index,
			})
		end
		
		if event.oldHighscore < gamelua.starTable[event.level].goldScore and event.newHighscore >= gamelua.starTable[event.level].goldScore then
			self:logEvent("Level complete first time 3 stars",
			{
				Level = world_number .. "-" .. index,
			})
		end
	end
	
	
	if event.id == events.EID_CRYSTAL_STARTED then
		self:logEvent("Crystal UI started")
	end
	
	if event.id == events.EID_FACEBOOK_LIKE_CLICKED then
		--self:logEvent("Crystal UI started")
	end
	
	if event.id == events.EID_LEVEL_COMPLETE_FIRST_TIME then
		local _, episode, page, index = gamelua.getLevelById(event.level)
		local world_number = gamelua.g_episodes[episode].pages[page].world_number or -1
		
		self:logEvent("Level complete first time",
		{
			Level = world_number .. "-" .. index,
		})
	end
	
	if event.id == events.EID_GOLDEN_EGG_COMPLETED then
		self:logEvent("Golden egg level completed",
		{
			Level = event.level,
		})
	end
	
	if event.id == events.EID_ABSHOP_LINK_CLICKED then
		self:logEvent("ABshop link clicked")
	end
	
	if event.id == events.EID_GIFT_PURCHASE_CLICKED then
		self:logEvent("Apple gift purchase link clicked")
	end
	
	if event.id == events.EID_FACEBOOK_LINK_CLICKED then
		self:logEvent("Facebook link clicked")		
	end
	
	if event.id == events.EID_TWITTER_LINK_CLICKED then
		self:logEvent("Twitter link clicked")
	end
	
	if event.id == events.EID_CINEMATIC_TRAILER_CLICKED then
		self:logEvent("Trailer link clicked")		
	end

--ME: trailer viewed
--[[

** Line 14755: 	logFlurryEvent("ABshop link clicked")
** Line 14763: 	logFlurryEvent("Apple gift purchase link clicked")
* Line 14771: 	logFlurryEvent("Lenovo no ads link clicked")
** Line 14795: 	logFlurryEvent("Facebook link clicked")
** Line 14800: 	logFlurryEvent("Twitter link clicked")
**				logFlurryEvent("Trailer link clicked")

]]	
	
	if event.id == events.EID_GOLDEN_EGG_FAILED then
		self:logEvent("Golden egg level failed",
		{
			Level = event.level,
		})
	end
	
	if event.id == events.EID_MAIN_MENU_ENTERED then
		self:logEvent("Main menu entered")
	end
	
	if event.id == events.EID_LEVEL_COMPLETED then
		local _, episode, page, index = gamelua.getLevelById(event.levelName)
		local world_number = gamelua.g_episodes[episode].pages[page].world_number or -1
		
		self:logEvent("Level complete",
		{
			Level = world_number .. "-" .. index,
			Stars = "" .. event.gainedStars,
			Attempts = "" .. gamelua.numberOfAttemptsInLevel,
			["Birds used"] = "" .. gamelua.birdsShot,
			["Birds available"] = "" .. gamelua.birdsCounter,
		})
	end
	
	if event.id == events.EID_LEVEL_FAILED then
		local _, episode, page, index = gamelua.getLevelById(event.level)
		local world_number = gamelua.g_episodes[episode].pages[page].world_number or -1
		
		self:logEvent("Level failed",
		{
			Level = world_number .. "-" .. index,
			Attempts = "" .. gamelua.numberOfAttemptsInLevel,
			["Birds used"] = "" .. gamelua.birdsShot,
			["Birds available"] = "" .. gamelua.birdsCounter,
		})
	end
	
	if event.id == events.EID_CHALLENGE_STARTED then
		self:logEvent("Challenge started first time",
		{
			Challenge = event.challenge.id,
		})
	end
	
	if event.id == events.EID_CHALLENGE_STARTED_FIRSTTIME then
		self:logEvent("Challenge started first time",
		{
			Challenge = event.challenge.id,
		})
	end
	
	if event.id == events.EID_CHALLENGE_RESTARTED then
		self:logEvent("Challenge restarted",
		{
			Challenge = event.challenge.id,
		})
	end
	
	if event.id == events.EID_CHALLENGE_FAILED then
		self:logEvent("Challenge failed",
		{
			Challenge = event.challenge.id,
		})
	end
	
	if event.id == events.EID_CHALLENGE_COMPLETE then
		self:logEvent("Challenge complete",
		{
			Challenge = event.challenge.id,
		})
	end

	if event.id == events.EID_CHALLENGE_COMPLETE_FIRST_TIME then
		self:logEvent("Challenge complete first time",
		{
			Challenge = event.challenge.id,
		})
	end
	
	if event.id == events.EID_CHALLENGE_UNLOCKED then
		self:logEvent("Challenge unlocked",
		{
			Challenge = event.challenge.id,
		})
	end
	
	if event.id == events.EID_CHALLENGE_MENU_ENTERED then
		self:logEvent("Challenge menu entered", {})
	end
	
	if event.id == events.EID_MIGHTY_EAGLE_TRAILER_CLICKED then
		self:logEvent("ME: trailer viewed")
	end
	
	if event.id == events.EID_SEASONS_LINK_CLICKED then
		self:logEvent("AB Seasons link clicked.")		
	end
	
	if event.id == events.EID_NEWSLETTER_CLICKED then
		self:logEvent("Newsletter link clicked")		
	end
	
	if event.id == events.EID_ROVIO_NEWS_SHOWN then
		self:logEvent("Rovio news shown")				
	end
	
	if event.id == events.EID_TUTORIAL_VIEWED then
		self:logEvent("Tutorials viewed")
	end
	
	if event.id == events.EID_FLURRY_EVENT_STARTED_BEFORE_COMPLETION then		
			--logFlurryEventWithParam("Level started before completion", "Level", level)					
		self:logEvent("Level started before completion",{
		Level = event.level
		})
	end
	
	if event.id == events.EID_GOLDEN_EGG_STAR_GAINED then
		--logFlurryEventWithParam("Golden egg level completed", "Level", "" .. level) 		
		if event.data ~= nil then
			self:logEvent("Golden egg level completed",{
				Level = _G.tostring(event.data.levelName)
			})		
		end
	end
	
	-- logFlurryEventWithParam("Golden egg level started", "Level", "" .. goldenEggLevelMapping["Level5"]) 
	if event.id == events.EID_GE_LEVEL_STARTED then
		self:logEvent("Golden egg level started",{
			Level = _G.tostring(event.levelName)
		})
	end	
	
	if event.id == events.EID_LEVEL_STARTED then
		levelRestartedFlurryParams = {}
		self:logEvent("Level started", {
			Level = event.currentWorldNumber.."-"..event.currentLevelNumberInTheme,
			From = event.from
		})
		
		--levelRestartedFlurryParams["Level"] = event.currentWorldNumber .. "-" .. event.currentLevelNumberInTheme
		--levelRestartedFlurryParams["From"] = "levelselection menu"
		--logFlurryEventWithParams("Level started", "levelRestartedFlurryParams")
		
	end
	
	if event.id == events.EID_LEVEL_RESTARTED then
		
		levelRestartedFlurryParams = {}
		
		if event.currentWorldNumber ~= nil and event.currentLevelNumberInTheme ~= nil then
			levelRestartedFlurryParams["Level"] = event.currentWorldNumber .. "-" .. event.currentLevelNumberInTheme
		else
			levelRestartedFlurryParams["Level"] = "undefined"
		end
		
		if event.numberOfAttemptsInLevel ~= nil then
			levelRestartedFlurryParams["Attempts"] = "" .. event.numberOfAttemptsInLevel
		else
			levelRestartedFlurryParams["Attempts"] = "undefined"
		end
		
		if event.birdsShot ~= nil then
			levelRestartedFlurryParams["Birds used"] = "" .. event.birdsShot
		else
			levelRestartedFlurryParams["Birds used"] = "undefined"
		end
		
		if event.birdsCounter ~= nil then
			levelRestartedFlurryParams["Birds available"] = "" .. event.birdsCounter
		else
			levelRestartedFlurryParams["Birds available"] = "undefined"
		end
		
		if event.levelRestartedFrom ~= nil then
			levelRestartedFlurryParams["From"] = "" .. event.levelRestartedFrom
		else
			levelRestartedFlurryParams["From"] = "undefined" 
		end
		
		
		
		--logFlurryEventWithParams("Level restarted", "levelRestartedFlurryParams")
			
		self:logEvent("Level restarted", levelRestartedFlurryParams)
		--print("FlurryEventWithParam: Level restarted, Level, " .. currentWorldNumber .. "-" ..currentLevelNumberInTheme .. "\n")
	
	end
	
end

function Flurry:logEvent(event, params)
	local params_str = ""
	if params ~= nil then
		for k, v in _G.pairs(params) do
			if params_str ~= "" then
				params_str = params_str .. "; "
			end
			params_str = params_str .. _G.tostring(k) .. " -> " .. _G.tostring(v)
		end	
	end
	
	gamelua.print("<Flurry> logging flurry event [" .. _G.tostring(event) .. "] with params [" .. params_str .. "]\n")
	gamelua.flurryParams = params
	
	--if gamelua.releaseBuild then
		if params == nil or (params ~= nil and #params == 0) then
--			gamelua.loginfo("<Flurry> logging event without params ")
			gamelua.logFlurryEvent(event)
		elseif params ~= nil and #params == 1 then
			
			for k, v in params do				
				gamelua.loginfo("<Flurry> logging event with 1 param ")
				gamelua.logFlurryEventWithParam(event,  ""..k, ""..v)
			end			
		elseif params ~= nil and #params > 1 then
			gamelua.loginfo("<Flurry> logging event with >1 params ")
			gamelua.logFlurryEventWithParams(event, "flurryParams")						
		end

		if(do_unitTest == true) then
			if #params_str > 0 then
				_G.table.insert(unitTestResults, event..","..params_str)						
			else
				_G.table.insert(unitTestResults, event)										
			end
		end
	--end
end


function unitTest(flurryInstance, event, expected)
	unitTestResults = {}
	local testFailed = false
	gamelua.loginfo("<Flurry unit test for event : "..event.id)
	f:eventTriggered(event)	
	local fails = 0
	for i,v in _G.ipairs(expected) do
		if expected[i] ~= unitTestResults[i] then
			gamelua.logwarning("      Flurry unit test FAIL, event = ".._G.tostring(event.id).." result = <".._G.tostring(unitTestResults[i])..">, expected = <".._G.tostring(expected[i])..">")
			fails = fails + 1
		else
			gamelua.loginfo("      Flurry unit test PASS, event = ".._G.tostring(event.id).." result = <".._G.tostring(unitTestResults[i])..">, expected = <".._G.tostring(expected[i])..">")		
		end
	end
	
	if fails > 0 then
		gamelua.logwarning("<Flurry: "..event.id.." failed "..fails.." times")
	end
	
	--if not testFailed then
	--	gamelua.loginfo("	<Flurry unit test pass, event = ".._G.tostring(event.id).." result = ".._G.tostring(result)..", expected = ".._G.tostring(expected).." >")
	--end

	--else
		--gamelua.logwarning("<Flurry unit test FAIL, event = ".._G.tostring(event.id).." result = ".._G.tostring(result)..", expected = ".._G.tostring(expected)..">")
end


function unitTestFlurry()
	do_unitTest = true
	local events = gamelua.events
	f = Flurry:new()
	
	unitTest(f,{id = events.EID_CHALLENGE_MENU_ENTERED}, {"Challenge menu entered"})
	unitTest(f,{id = events.EID_LEVEL_PLAYED_WITH_EAGLE, level = "Level30"}, {"ME: Level played,Level -> 3-12"})
	unitTest(f,{id = events.EID_LEVEL_PLAYED_WITH_EAGLE, level = "Level1", skipped = true}, {"ME: Level played,Level -> 1-1", "ME: Level skipped,Level -> 1-1"})
	unitTest(f,{id = events.EID_EAGLE_FEATHER_GAINED, level = "Level1"}, {"ME: got feather,Level -> 1-1"})
	
	unitTest(f,{id = events.EID_ME_PURCHASE_CANCELLED_BY_USER}, {"Mighty eagle purchase canceled"})
	unitTest(f,{id = events.EID_MIGHTYEAGLE_RESTORED}, {"Mighty eagle restored"})
	unitTest(f,{id = events.EID_ME_PURCHASE_FAILED_OTHER}, {"Mighty eagle purchase failed"})
	unitTest(f,{id = events.EID_MIGHTYEAGLE_PURCHASED, status = 1, errorCode = 0, from = "3-1", usedAsLevelSkip = true}, {"ME: purchased,levelSkip -> yes; From -> 3-1"})
	unitTest(f,{id = events.EID_MIGHTYEAGLE_PURCHASED, status = 1, errorCode = 0, from = "5-1", usedAsLevelSkip = false}, {"ME: purchased,levelSkip -> no; From -> 5-1"})
	unitTest(f,{id = events.EID_MIGHTYEAGLE_PURCHASED, status = 1, errorCode = 0, from = "MAIN_MENU", usedAsLevelSkip = "false"}, {"ME: purchased,levelSkip -> no; From -> MainMenu"})

	-- test android
	local temp = gamelua.deviceModel
	gamelua.deviceModel = "android"
	unitTest(f,{id = events.EID_MIGHTYEAGLE_PURCHASED, status = 1, errorCode = 0, from = "MAIN_MENU", usedAsLevelSkip = "false"}, {"ANDROID: ME purchase,Result -> success", "ME: purchased,levelSkip -> no; From -> MainMenu"})
	
	gamelua.deviceModel = temp
	
	
	--	eventManager:notify({id = events.EID_MIGHTYEAGLE_PURCHASED, status = status, errorCode = errorCode, from = from, usedAsLevelSkip = usedAsLevelSkip})				

	-- TODO:
	--EID_NEW_HIGHSCORE
	--EID_LEVEL_COMPLETE_FIRST_TIME
	--EID_LEVEL_COMPLETE_FIRST_TIME
	--EID_GOLDEN_EGG_COMPLETED
	--EID_GOLDEN_EGG_FAILED
	--EID_LEVEL_COMPLETED
	--EID_LEVEL_FAILED
	--EID_CHALLENGE_STARTED
	--EID_CHALLENGE_STARTED_FIRSTTIME
	--EID_CHALLENGE_RESTARTED
	--EID_CHALLENGE_FAILED
	--EID_CHALLENGE_COMPLETE
	--EID_CHALLENGE_COMPLETE_FIRST_TIME
	--EID_CHALLENGE_UNLOCKED
	--EID_CHALLENGE_MENU_ENTERED
	do_unitTest = false
end	
	
	
	

filename="flurry.lua"
