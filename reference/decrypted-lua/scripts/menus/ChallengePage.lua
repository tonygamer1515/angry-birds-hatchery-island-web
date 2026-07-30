ChallengeFrame = ui.Frame:new()

g_playButtonAnimTime = .1
g_challengeButtonW = screenWidth * 0.60
g_scrollAlphaTime = 0.2

--------------------------------
--------- 	ScrollBar ----------
--------------------------------
ScrollBar = ui.Frame:new()

function ScrollBar:init()
	
	self.scrollY = 0
	self.h = 0
	
	local scrollBaseTop = ui.Image:new()
	scrollBaseTop.name = "scrollBaseTop"
	scrollBaseTop:setImage("SCROLLBAR_BASE_TOP")
	self:addChild(scrollBaseTop)
	
	local scrollBaseMiddle = ui.Image:new()
	scrollBaseMiddle.name = "scrollBaseMiddle"
	
	-- OOPS: image name is wrong in GGS
	scrollBaseMiddle:setImage("SCROLLBAR_BASE_BOTTOM")
	self:addChild(scrollBaseMiddle)
	
	local scrollBaseBottom = ui.Image:new()
	scrollBaseBottom.name = "scrollBaseBottom"
	scrollBaseBottom:setImage("SCROLLBAR_BASE_MIDDLE")
	self:addChild(scrollBaseBottom)	
	
	local marker = ui.Image:new()
	marker.name = "marker"
	marker:setImage("SCROLLBAR_CHALLENGEMENU")
	self:addChild(marker)
	
end

function ScrollBar:setHeight(height)
	self.h = height

	local scrollBaseMiddle = self:getChild("scrollBaseMiddle")	
	scrollBaseMiddle:setSize(nil, self.h)
	
	local scrollBaseBottom = self:getChild("scrollBaseBottom")
	scrollBaseBottom.y = self.h
	
end

function ScrollBar:setAlpha(alpha)
	
	self:getChild("scrollBaseTop").alpha = alpha
	self:getChild("scrollBaseMiddle").alpha = alpha
	self:getChild("scrollBaseBottom").alpha = alpha
	self:getChild("marker").alpha = alpha	
	if alpha == nil then
		self.visible = false
	else
		self.visible = true
	end
end

function ScrollBar:draw(x,y)
	if self.visible then
		ui.Frame.draw(self,x,y)
	end
end

--- Param relativeScrollY: 0.0f - 1.0f
function ScrollBar:setScrollY(relativeScrollY)
	self.scrollY = self.h * relativeScrollY
	local marker = self:getChild("marker")
	marker.y = self.scrollY
end

--------------------------------------
---------- ChallengeFrame ------------
--------------------------------------

function ChallengeFrame:init()

	local bg = ui.BGBox:new()
	eventManager:addEventListener(events.EID_REQUEST_LAYOUT, self)
	
	bg.components = { topLeft = "CHALLENGE_LIST_TOP_LEFT", topMiddle = "CHALLENGE_LIST_TOP_MIDDLE", topRight = "CHALLENGE_LIST_TOP_RIGHT",
						left = "CHALLENGE_LIST_LEFT", center = "CHALLENGE_LIST_CENTER", right = "CHALLENGE_LIST_RIGHT", 
     				    bottomLeft = "CHALLENGE_LIST_BOTTOM_LEFT", bottomMiddle = "CHALLENGE_LIST_BOTTOM_MIDDLE", bottomRight = "CHALLENGE_LIST_BOTTOM_RIGHT" }
	
	self.backgroundColour = { r = 21, g = 31, b = 63, a = 255}
	bg.name = "bg"
	bg.x = 0
	bg.y = 0
	self:addChild(bg)
	
	local closeButton = ui.ImageButton:new()
	self.challengeButtons = 0
	closeButton.name = "closeButton"
	closeButton:setImage("LS_BACK_BUTTON")
	closeButton.returnValue = "EXIT"
	closeButton.activateOnRelease = true
	closeButton.clickSound = "menu_back"
	self:addChild(closeButton)		
	
	local slider = ui.SliderFrame:new()
	slider.name = "slider"	
	self:addChild(slider)			

	local sliderBGImage = slider:getBGImage()
	sliderBGImage:setImage("BG_BARGAP_CHALLENGEMENU")
	
	local gridFrame = ui.GridFrame:new()
	gridFrame.name = "gridFrame"
	slider:addChild(gridFrame)
	--
	local scrollBar = ScrollBar:new()
	scrollBar.name = "scrollBar"
	self:addChild(scrollBar)	
	--
end

function ChallengeFrame:createChallenges()
	self.challengeButtons = 0

	local gridFrame = self:getChild("gridFrame")
	gridFrame:reset()
	local hasLockedChallenge = false
	for i = 1, #g_challenges do
		-- TODO: challenges should be added to the list, but those 
		-- 		 unavailable yet should be in a locked state.
		if checkChallengeUnlockCondition(g_challenges[i]) then
			self:addChallenge(g_challenges[i],i)
			
		else
			hasLockedChallenge = true					
		end		
	end
	
	-- Stores information that the user has viewed the challenge.
	-- The amount of unviewed challenges is shown in episode selection				
	for i = 1, #g_challenges do
		if checkChallengeUnlockCondition(g_challenges[i]) then
			local id = g_challenges[i].id	
			if highscores ~= nil and  id ~= nil then
				
				-- create new entry if not existing.
				if highscores[id] == nil then
					highscores[id] = {}
				end
				
			end	
			
			if not highscores[id].viewed then
				highscores[id].viewed = true
				eventManager:notify({ id = events.EID_CHALLENGE_UNLOCKED, challenge = g_challenges[i] })
			end
		end
	end
	
	-- save information
	saveLuaFileWrapper("highscores.lua", "highscores", true)	
	if hasLockedChallenge then		
		self:addLockedChallenge()		
	end	
	
end

function ChallengeFrame:addLockedChallenge(rowIndex)
	self.challengeButtons = self.challengeButtons + 1
	
	local challengeButton = ChallengeButton:new({rowIndex = self.challengeButtons})
	challengeButton.locked = true
	challengeButton.name = "challengeButton"..self.challengeButtons
	challengeButton.returnValue = ""
	
	local bg = challengeButton:getChild("bg")
	bg:setImage("BG_LOCKED_CHALLENGEMENU")
	
	local isCompleted = challengeButton:getChild("isCompleted")
	isCompleted:setImage("CLOCK_CHALLENGEMENU")
		
	local gridFrame = self:getChild("gridFrame")
	gridFrame:insert(1,self.challengeButtons,challengeButton)	
end
	

function ChallengeFrame:addChallenge(challenge, rowIndex)
	self.challengeButtons = self.challengeButtons + 1
	
	local challengeButton = ChallengeButton:new({id = challenge.id, description = challenge.description, challengeName = challenge.name, reward = challenge.reward, rowIndex = rowIndex})
	challengeButton.name = "challengeButton"..self.challengeButtons
	challengeButton.returnValue = "CHALLENGE_CLICKED"
	challengeButton.challenge = challenge	
	
	local gridFrame = self:getChild("gridFrame")
	gridFrame:insert(1,self.challengeButtons,challengeButton)	
end


function ChallengeFrame:onEntry()		
	self:createChallenges()
	ui.Frame.onEntry(self)
	
	if rovioNewsIsShown then
		rovioNews:hide()
		rovioNewsIsShown = false
	end
	rovioNewsShowWhenLoaded = false
	
	-- TODO: set the last opened challenge as active on entry.
	local currentButton = self:getChild("challengeButton1")
	currentButton:unFold()
	self:collapseOthers("challengeButton1")
	--self:storeViewedChallenges()
	
	eventManager:notify({ id = events.EID_CHALLENGE_MENU_ENTERED })
end
--[[
function ChallengeFrame:storeViewedChallenges()

	
	if not highscores[event.challenge.id] or not highscores[event.challenge.id].completed then
		highscores[event.challenge.id] =
		{
			completed = true,
		}
		
		reward = event.challenge.reward
		settingsWrapper:addHatcheryStars(reward)
		saveLuaFileWrapper("highscores.lua", "highscores", true)
	end
end]]

function ChallengeFrame:layout()
	g_challengeButtonW = screenWidth * 0.60
	
	local closeButton = self:getChild("closeButton")
	closeButton.x = 0
	closeButton.y = screenHeight 
	
	local gridFrame = self:getChild("gridFrame")
	gridFrame.x = 0
	gridFrame.y = 0
	
	local slider = self:getChild("slider")	
	slider.h = _G.math.min(screenHeight * 0.5, gridFrame:getGridHeight() * 0.98)
	slider.x = (screenWidth - g_challengeButtonW) * 0.5
	slider.y = (screenHeight - slider.h) * 0.5
	slider.w = g_challengeButtonW
	slider.maxScrollY = gridFrame:getGridHeight() - slider.h 
	slider.clip = {x1 = slider.x, y1 = slider.y, clipW = slider.w, clipH = slider.h} 		

	local sliderBGImage = slider:getBGImage()
	sliderBGImage:setSize(slider.w, slider.h)
		
	local bg = self:getChild("bg")	
	bg:setSize(slider.w, slider.h)
	bg.x = slider.x
	bg.y = slider.y
	
	local scrollBar = self:getChild("scrollBar")
	scrollBar.x = slider.x + g_challengeButtonW * 0.98
	local w,h = _G.res.getSpriteBounds("SCROLLBAR_BASE_TOP")
	scrollBar.y = h + slider.y
	scrollBar:setHeight(slider.h - h * 2)
	ui.Frame.layout(self)		
end

function ChallengeFrame:onPointerEvent(eventType,x,y)			
	local result, meta = ui.Frame.onPointerEvent(self,eventType,x,y)

	if result == "PLAY_CHALLENGE" then
		eventManager:notify({id = events.EID_CHALLENGE_STARTED, challenge = meta.challenge})		
	end
	
	if result == "EXIT" then
		eventManager:notify({id = events.EID_CHANGE_SCENE, target = "EPISODE_SELECTION", from = "CHALLENGES_PAGE"})
	elseif result == "CHALLENGE_CLICKED" then
		if meta.expanded == true then
		else
			self:getChild(meta.name):expand()			
			self:collapseOthers(meta.name)
		end
	end	
end

function ChallengeFrame:unlock()
	self:createChallenges()
	self:onEntry()
	self:layout()
end


-----------------
function ChallengeFrame:update(dt,time)
	if _G.res.isAudioPlaying(currentMainMenuSong) == false and currentMainMenuSong ~= nil then
		_G.res.playAudio(currentMainMenuSong, 0.8, true, 7)
	end

	local slider = self:getChild("slider")
	local scrollBar = self:getChild("scrollBar")
	local relativeScroll = slider:getRelativeScrollY()
	local marker = scrollBar:getChild("marker")
	local w,h = _G.res.getSpriteBounds(marker.image)	
	
	if keyReleased["P"] then
		self:unlock()
	end
	
	if slider:wasDragged() then
		scrolledTime = scrolledTime or 0
		if scrolledTime < g_scrollAlphaTime then 
			scrolledTime = _G.math.min(scrolledTime + dt,g_scrollAlphaTime) 
		end
	else
		if scrolledTime ~= nil then
			scrolledTime = _G.math.max(scrolledTime - dt,0)
			if scrolledTime == 0 then
				scrolledTime = nil
			end			
		end
	end
	
	if scrolledTime == nil then	
		scrollBar:setAlpha(scrolledTime)	
	else
		scrollBar:setAlpha(scrolledTime / g_scrollAlphaTime)	
	end
	
	-- TODO: this should be in scrollBar instead
	if(relativeScroll < 0 ) then		
		marker.scaleY = 1 - _G.math.min(_G.math.abs(relativeScroll), 0.5)	
		relativeScroll = 0
		marker.y = - (h - (h * marker.scaleY)) * 0.5
		
	elseif (relativeScroll > 1) then
		marker.scaleY = 1 - _G.math.min(_G.math.abs(1 - relativeScroll), 0.5)	
		relativeScroll = 1		
		marker.y = scrollBar.h + (h - (h * marker.scaleY)) * 0.5
	else
		marker.scaleY = 1
		scrollBar:setScrollY(relativeScroll)	
	end
	
	-- Cap marker movement & scale
	local ww,hh = _G.res.getSpriteBounds("SCROLLBAR_BASE_TOP")
	
	if marker.y - hh < marker.h * 0.5 then 
		marker.y = -hh +  marker.h * 0.5 - (h - (h * marker.scaleY)) * 0.5 
	end
	
	if marker.y > hh + scrollBar.h - marker.h * 0.5 then 
		marker.y = hh + scrollBar.h - marker.h * 0.5 + (h - (h * marker.scaleY)) * 0.5 
	end


	local unviewedChallengesCount = getUnviewedChallengesCount()

	if unviewedChallengesCount > 0 then		
		self:unlock()
	end
	
	ui.Frame.update(self,dt,time)
	
end	

function ChallengeFrame:eventTriggered(event)
	--if event.id == events.EID_REQUEST_LAYOUT and event.target == self then
		self:getChild("gridFrame"):layout()
	--end	
end

function ChallengeFrame:collapseOthers(name)	
	for i = 1, self.challengeButtons do
		local v = self:getChild("challengeButton"..i)
		if v.name ~= name then
			v:collapse()
		end
	end
end


function ChallengeFrame:draw(x,y)
	drawLevelSelectionBackground()
	ui.Frame.draw(self,x,y)
end


------------------------
---- ChallengeButton ---
------------------------
ChallengeButton = ui.Frame:new()

function ChallengeButton:init()

	local w,h = _G.res.getSpriteBounds("PLAY_BUTTON_CHALLENGEMENU")
	self.expanded = false
	self.referenceH = h
	self.h = self.referenceH
	self.px = 0
	self.py = 0
	self.expandH = self.referenceH * 2
	self.activateOnRelease = true
	
	local bg = ui.Image:new()
	bg.name = "bg"
	bg:setImage("BG_BAR_CHALLENGEMENU")
	
	bg:setSize(self.w,self.h)
	bg.hanchor = "LEFT"
	bg.vanchor = "TOP"
	self:addChild(bg)
	
	local text = ui.Text:new({text = self.challengeName})
	text.name = "title"
	text.textBoxSize = 200
	text.hideOnCollapse = false
	text.vanchor = "VCENTER"
	text.hanchor = "LEFT"
	text.scaleX = 0.75
	text.scaleY = 0.75
	text:clip()
	self:addChild(text)
	
	local desc = ui.Text:new({text = self.description})
	desc.name = "desc"	
	desc.textBoxSize = 200
	desc.hideOnCollapse = true
	desc.vanchor = "VCENTER"
	desc.hanchor = "LEFT"
	desc.scaleX = 0.75
	desc.scaleY = 0.75
	self:addChild(desc)
	
	local isCompleted = ui.Image:new()
	isCompleted.name = "isCompleted"	
	isCompleted:setImage("STAR_EMPTY_CHALLENGEMENU")
	self:addChild(isCompleted)

	local starReward = ui.Image:new()
	starReward.name = "starReward"	
	starReward.hideAfterComplete = true
	starReward.hideOnCollapse = true
	starReward:setImage("BG_STARBOX_CHALLENGEMENU")
	self:addChild(starReward)

	local starsRewardText = ui.Text:new()
	starsRewardText.name = "starsRewardText"
	starsRewardText.text = "+".._G.tostring(self.reward)
	starsRewardText.vanchor = "VCENTER"
	starsRewardText.hanchor = "HCENTER"
	starsRewardText.scaleX = 0.5
	starsRewardText.scaleY = 0.5
	starsRewardText.hideOnCollapse = true	
	starsRewardText.hideAfterComplete = true
	starsRewardText:clip()
	self:addChild(starsRewardText)

	local playButton = ui.ImageButton:new()
	playButton.name = "playButton"
	playButton.hideOnCollapse = true
	playButton:setImage("PLAY_BUTTON_CHALLENGEMENU")
	playButton.returnValue = "PLAY_CHALLENGE"
	self:addChild(playButton)
	

	local bar = ui.ImageButton:new()
	bar.name = "bar"
	bar:setImage("BG_BARGAP_CHALLENGEMENU")
	self:addChild(bar)		
	
	-- First one has the bar also in top
	if self.rowIndex == 1 then
		local topBar = ui.ImageButton:new()
		topBar.name = "topBar"
		topBar:setImage("BG_BARGAP_CHALLENGEMENU")
		self:addChild(topBar)		
	end
end	

function ChallengeButton:onEntry()
	self:hideCollapsedItems()
	local isCompleted = self:getChild("isCompleted")
	
	if not self.locked then
		if self:isChallengeCompleted() then
			isCompleted:setImage("STAR_FULL_CHALLENGEMENU")		
		else
			isCompleted:setImage("STAR_EMPTY_CHALLENGEMENU")	
		end	
	end
	
	local playButton = self:getChild("playButton")
	playButton.scaleX = 1
	playButton.scaleY = 1	
end

function ChallengeButton:layout()
	self.w = g_challengeButtonW 
	self.x = 0 
	self.y = 0
	self.unfoldSpeed = 900
	
	local bg = self:getChild("bg")
	bg.y = 0 
	bg.x = 0	
	bg:setSize(self.w, _G.math.floor(self.h))
	
	local isCompleted = self:getChild("isCompleted")
	local w,h = _G.res.getSpriteBounds("STAR_EMPTY_CHALLENGEMENU")
	isCompleted.x = w * 1.55
	isCompleted.y = self.referenceH * 0.5

	local starReward = self:getChild("starReward")
	starReward.x = isCompleted.x
	starReward.y = self.referenceH * 1.5

	local starsRewardText = self:getChild("starsRewardText")
	starsRewardText.x = starReward.x - _G.res.getStringWidth(starsRewardText.text) * 0.2
	starsRewardText.y = starReward.y
	
	local playButton = self:getChild("playButton")
	playButton.x = self.w - playButton.w * 0.80
	playButton.y = self.referenceH

	local text = self:getChild("title")
	text.y = self.referenceH * 0.5
	text.x = starReward.x + starReward.w
	
	local desc = self:getChild("desc")
	desc.y = self.referenceH * 1.5
	desc.x = starReward.x + starReward.w
	
	local bar = self:getChild("bar")
	bar.x = 0
	bar.y = self.h - 1
	bar:setSize(g_challengeButtonW,nil)
	
	if self.rowIndex == 1 then
		local topBar = self:getChild("topBar")
		topBar.x = 0
		topBar.y = 0
		topBar:setSize(g_challengeButtonW,nil)
	end
end

function ChallengeButton:onPointerEvent(eventType,x,y)
	local result, meta = ui.Frame.onPointerEvent(self, eventType,x,y)

	if result == "PLAY_CHALLENGE" then
		return result, {challenge = self.challenge}		
	end
	
	if ((not self.activateOnRelease and eventType == "LPRESS") or (self.activateOnRelease and eventType == "LRELEASE")) and self.enabled ~= false then
		worldScale = 1		
		if x >= self.x - self.px and x <= self.x + (self.w - self.px) and y >= self.y - self.py and y <= self.y + (self.h - self.py) then				
			return self.returnValue, {expanded = self.expanded, name = self.name, challenge = self.challenge}			
				
		end		
	end	
	return nil
end

function ChallengeButton:animatePlayButton(dt, expand)
	local playButton = self:getChild("playButton")

	if expand then
		scale = _G.math.min( (g_playButtonAnimTime - self.playButtonScaleTime) / g_playButtonAnimTime , 1.0)
	else
		scale = _G.math.max( self.playButtonScaleTime / g_playButtonAnimTime, 0.0)
	end	

	playButton.scaleY = scale
	playButton.scaleX = scale		


	self.playButtonScaleTime = self.playButtonScaleTime - dt
	if self.playButtonScaleTime <= 0 then 
		self.playButtonScaleTime = nil 
		if(expand) then
		-- Normalize values
			playButton.scaleX = 1
			playButton.scaleY = 1		
		else
		-- Normalize values
			playButton.scaleX = 0
			playButton.scaleY = 0
		end
	end
end

function ChallengeButton:update(dt,time)

	if self.locked then
		local title = self:getChild("title")
		local nextTime = getNextChallengeUnlockCountdown() 
		
		-- don't want to clip every frame
		if title.text ~= nextTime then
			title.text = nextTime or ""		
			title:clip()		
		end		
	end

	if self.playButtonScaleTime ~= nil then
		self:animatePlayButton(dt,self.expanded)		
	end

	-- Button is expanding
	if(self.expanded and self.h < self.expandH) then
		self.h = self.h + dt * self.unfoldSpeed
		if self.h > self.expandH then
			self:unFold()
			self.playButtonScaleTime = g_playButtonAnimTime			
		end		
		eventManager:notify({id = events.EID_REQUEST_LAYOUT, target = self})

	-- Button is collapsing
	elseif(not self.expanded and self.h > self.referenceH) then		
		self.h = self.h - dt * self.unfoldSpeed
		if(self.h < self.referenceH) then		
			self:hideCollapsedItems()
		end		
		eventManager:notify({id = events.EID_REQUEST_LAYOUT, target = self})
	end	
end 


function ChallengeButton:unFold()
	self.h = self.expandH
	self.expanded = true
	self:revealAllItems()	
end
	
function ChallengeButton:draw(x,y)
	
	local x1 = x + self.x - self.px
	local y1 = y + self.y - self.py
	local x2 = x - self.px + self.x + self.w
	local y2 = y - self.py + self.y + self.h
	ui.Frame.draw(self,x,y)
end 

function ChallengeButton:revealAllItems()
	for i,v in _G.ipairs(self.children) do		
		if self:isChallengeCompleted() and v.hideAfterComplete then
			v.visible = false
		else
			v.visible = true
		end
	end		
end

function ChallengeButton:hideCollapsedItems()
	self.h = self.referenceH
	for i,v in _G.ipairs(self.children) do
		if v.hideOnCollapse == true then
			v.visible = false
		end
	end		
end	

	
function ChallengeButton:collapse()
	self.expanded = false
	self.playButtonScaleTime = g_playButtonAnimTime
end

function ChallengeButton:expand()
	self.expanded = true
end

function ChallengeButton:isChallengeCompleted()
	if highscores ~= nil and highscores[self.id] ~= nil then
		if highscores[self.id].completed == true then
			return true
		end
	end
	return false
end

filename="ChallengePage.lua"
