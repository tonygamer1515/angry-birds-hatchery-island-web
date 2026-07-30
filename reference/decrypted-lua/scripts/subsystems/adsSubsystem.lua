--
-- NOTE: this is a Weird combination of a subsystem and gamelogic. At least (almost) everything is in one place.
--
AdsSubSystem = subsystems.SubSystem:new()
currentFrame = 0


function AdsSubSystem:eventTriggered(event)
	if event.id == events.EID_LEVEL_LOADING_DONE then
		-- TODO: request video ad if available
		
	end
	
	if event.id == events.EID_MENUMANAGER_ROOT_CHANGED then
		--showAd()
		--requestAdSuccesful()
		if event.root.name == "LevelSelectionRoot" then
			hideAd()
		end		
		if event.root.name == "LevelEnd" then
			-- TODO: keep ad visible
			
		end
	end
	
	if event.id == events.EID_GOTO_GAME then
		if currentFrame == nil then
			showAdFrame = 10
		else
			showAdFrame = currentFrame + 10
		end		
	end
	
	if event.id == events.EID_GAME_INITIALIZED then
		self.bannerWidth = 320 * (event.screenWidth / 320)
		self.bannerHeight = 48 * (event.screenHeight / 320)	
		isShowingAd = false
		
		if(shouldShowAd()) then
			requestAd()
			requestExpandableAd()
			adRequested = true	
		end

		local isAndroid, isHD = subsystemsapi:isAndroid()

		if  isAndroid and isHD then
			self.bannerHeight = 48
		end
	end
end


-- NOTE: this is changing game globals which is error prone.
function AdsSubSystem:update(dt,time)
	--print = gamelua.print
	-- hiding and requesting ads, animating scores	
	if currentGameMode == updateGame then
		currentFrame = currentFrame + 1	
	end

	if shouldShowAd() then 
		local adDuration = 15
		local animationDuration = 0.7
		
		if isShowingAd == true and isHidingAd ~= true and time - lastAdTime > adDuration then
			adHidingStartedTime = time
			hideAd()				
		end
			
		
		if isHidingAd == true and isShowingAd == true and adHidingStartedTime ~= nil then
			self.scoreAdOffsetY = self.bannerHeight - (self.bannerHeight * (time - adHidingStartedTime) / animationDuration)
		elseif isHidingAd ~= true and isShowingAd == true then
			self.scoreAdOffsetY = self.bannerHeight * (_G.math.min(time - adShowingStartedTime, animationDuration) / animationDuration)
		elseif isShowingAd ~= true then
			self.scoreAdOffsetY = 0
		end
		
		--print(_G.tostring(self.scoreAdOffsetY))
		
		if videoAdRequested ~= true and videoReady ~= true and time - lastVideoAdTime > 300 then
			requestVideoAd()
			videoAdRequested = true
			print("Requesting next video ad\n")
		end
		
		if self.expandableTimer ~= nil then
			self.expandableTimer = self.expandableTimer - dt
			if self.expandableTimer < 0 then
				requestExpandableAd()
				self.expandableTimer = nil
			end						
		end
		
		
		if showAdFrame ~= nil and currentFrame ~= nil and currentFrame >= showAdFrame then
			if videoReady then
				showVideoAd()
			elseif expandableAdReady then
				eventManager:notify({id = events.EID_FULLSCREEN_AD_SHOWING})
				showExpandableAd()			
				showingExpandableAd = true
				expandableAdReady = false
				-- TODO: time should be ~5 minutes
				adSystem.expandableTimer = 30
			else
				-- if expandable is showing, don't do this stuff
				if not showingExpandableAd then
					showAd()				
				end
			end
			-- make sure that ad is not tried to be shown more than once
			showAdFrame = nil
		end
	end	
	
end

------------------------
-- adMob stuff starts --
------------------------
	
-- banner
function showAd()
	if shouldShowAd() then
		print("Trying to show ad\n")
		if isShowingAd == true then
			print("Still showing previous ad, reseting ad timer\n")
			lastAdTime = time
		elseif adRequested == true then 
			adSystem.scoreAdOffsetY = 0 
			print("Still requesting ad, doing nothing\n")
		elseif adReady == true then
			
			
			adReady = false
			isShowingAd = true
			isHidingAd = false
			lastAdTime = time
			adShowingStartedTime = time
			showAdvertisement()
			adSystem.scoreAdOffsetY = 0 
			print("showing ad\n")
			eventManager:notify({id = events.EID_AD_READY})
			
		elseif adRequested ~= true then
			print("No ad ready and not requesting ad, requesting now.\n")
			requestAd()
			adRequested = true
			adSystem.scoreAdOffsetY = 0 
		end
	end
end

function requestAdSuccesful()
	if shouldShowAd() then
		print("requestAdSuccesful\n")
		adReady = true
		adRequested = false
	end
end

function requestAdFailed()
	if shouldShowAd() then
		print("requestAdFailed\n")
		adRequested = false
	end
end
-- banner
function hideAd()
	if shouldShowAd() then
		print("Trying to hide ad\n")
		if isShowingAd == true and isHidingAd ~= true then
			hideAdvertisement()
			isHidingAd = true
			print("hideAd\n")
		end
	end
end

function startAdTimer()
	if shouldShowAd() then
		isShowingAd = true
		lastAdTime = time
		print("Starting Ad Timer, starting to show ad\n")
	end
end
-- interstitial
function showVideoAd()
	if shouldShowAd() then
		print("Checking if it's time for video ad\n")
		if videoReady == true and isShowingAd ~= true then
			print("Show video\n")
			showVideoAdvertisement()
			lastVideoAdTime = time
			videoAdRequested = false
		end
	end
end

function fullScreenAdDismissed()
	print("Fullscreen ad dismissed.\n")
	--prepareMenusAfterAd = true
	adSystem.scoreAdOffsetY = 0 
	eventManager:notify({id = events.EID_FULLSCREEN_AD_DISMISSED})
	
	if currentGameMode == updateGame and _G.res.isAudioPlaying(currentMainMenuSong) == true then
		_G.res.stopAudio(currentMainMenuSong)
	end
end

function fullScreenVideoDismissed()

	fullScreenAdDismissed()
	
	--if currentGameMode == updateGame or (currentGameMode == updateMenu and currentMenuPage == pausePage) then
	--	setGameMode(hidePauseMenu)
	--end
end

function shouldShowAd()
	return ((isLiteVersion == true and (deviceModel == "iphone" or deviceModel == "iphone4" or deviceModel == "ipad")) or deviceModel == "android") and not settingsWrapper:isPremium()
end

function onExpandableAdReady()
	expandableAdReady = true
	adSystem.expandableTimer = nil
end

function onExpandableAdRequestFailed()
	adSystem.expandableTimer = 10	-- TODO: Change the delay to something like 300 seconds
end

function onExpandableAdWillExpand()
	
end

function onExpandableAdWasHidden()
	showingExpandableAd = false
	adSystem.expandableTimer = 60 -- the expandable was shown, get a new one
								  -- TODO: Change the delay to something like 300 seconds
	eventManager:notify({id = events.EID_FULLSCREEN_AD_DISMISSED})
								  
end

filename="adsSubsystem.lua"
