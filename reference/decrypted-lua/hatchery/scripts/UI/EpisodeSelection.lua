
--episode override
HatcheryEpisodeSelection = EpisodeSelection:new()

--Add overridden scroll page
function HatcheryEpisodeSelection:init()
	local episodeButtons = HatcheryEpisodeScrollFrame:new()
	episodeButtons.name = "episodeButtons"
	self:addChild(episodeButtons)
	
	--gift button
	--[[if deviceModel == "iphone" or deviceModel == "iphone4" or deviceModel == "ipad" or (deviceModel == "android" and isHDVersion and not isPremium) then
		local giftButton = ui.ImageButton:new()
		giftButton.name = "giftButton"
		
		if deviceModel == "iphone" or deviceModel == "iphone4" or deviceModel == "ipad" then
			giftButton:setImage("BUTTON_GIFT_APP")
			giftButton.returnValue = "GOTO_GIFT_PURCHASE"
		end
		
		if deviceModel == "android" and isHDVersion and not isPremium then
			giftButton:setImage("BTN_ADFREE")
			giftButton.returnValue = "GOTO_LENOVO_ADFREE"
		end
		
		giftButton.attach = "fixed"
		giftButton.clickSound = "menu_confirm"
		self:addChild(giftButton)
	end]]
	
	local hatcheryButton = ui.InvisibleButton:new()
	hatcheryButton.name = "hatchButton"
	hatcheryButton.returnValue = Hatchery.hatcheryEvents.EID_HATCHERY_GO_TO_HATCHERY_FROM_EPISODE_SELECTION
	hatcheryButton.activateOnRelease = true
	self:addChild(hatcheryButton)
	
	--page indicator dots
	for i = 1, #g_episodeIds + extraButtons do
		local dot = ui.Image:new()
		dot.name = "dot" .. i
		dot:setImage("LS_DOT_BLACK")
		dot.attach = "fixed"
		self:addChild(dot)
	end

	--return to main menu button
	local backButton = ui.ImageButton:new()
	backButton.name = "backButton"
	backButton:setImage("LS_BACK_BUTTON")
	backButton.returnValue = "GOTO_MAIN_MENU"
	backButton.attach = "fixed"
	backButton.activateOnRelease = true
	backButton.clickSound = "menu_back"
	
	self:addChild(backButton)
	
	self.currentSelection = settingsWrapper:getSelectedEpisode() - episodeNumberOffset
	if self.currentSelection < 1 then
		self.currentSelection = 1
		settingsWrapper:setSelectedEpisode(self.currentSelection + episodeNumberOffset)
	elseif self.currentSelection > #g_episodeIds + extraButtons then
		self.currentSelection = #g_episodeIds + extraButtons
		settingsWrapper:setSelectedEpisode(self.currentSelection + episodeNumberOffset)
	end
	episodeButtons.currentSelection = self.currentSelection	
	self.backgroundColour = { r = 11, g = 101, b = 76, a = 255 }	
	LevelSelectionRoot.init(self)
	
	self.topBar = nil
	
	self.popup = nil
	
	self.transAnim = {}
	self.transAnim.state = 0
	self.transAnim.timer = 0
	self.transAnim.time =0 
	self.transAnim.drawOffsetX = 0
	self.transAnim.drawOffsetY = 0
	
	
end

function HatcheryEpisodeSelection:update(dt, time) 
	
	local hatcheryView = Hatchery.Hatchery:getNestView()
	hatcheryView:setInteractive(false)
	hatcheryView:update(dt, time)
	self:animateTransition(dt, time)
	EpisodeSelection.update(self,dt, time)
end

function HatcheryEpisodeSelection:onEntry()
	EpisodeSelection.onEntry(self)
	local hatcheryView = Hatchery.Hatchery:getNestView()
	hatcheryView:onEntry()
	
	--need to add top bar first so it caughts the pointer events first (otherwise scroll frame will bug)
	if self.topBar == nil then 
		self.topBar = hatcheryView:getTopBar()
	end
	
	self.hatcheryOffsetX, self.hatcheryOffsetY  = screenWidth*0.3, screenHeight*0.15
	self.hatcheryScaleX, self.hatcheryScaleY = 0.6,0.6
	
	
end

function HatcheryEpisodeSelection:animateTransition(dt, time)
	
	
	if self.transAnim.state == 0 then
		return
	else
		self.transAnim.timer = _G.math.max(self.transAnim.timer -dt,0)
		local interp =  (self.transAnim.timer/self.transAnim.time)
		
		--go to hatchery animation
		if	self.transAnim.state == 2 then

			if self.transAnim.timer == 0 then
				self.transAnim.state = 0
				--preinitialize returning from hatchery
				self:initializeFromHatcheryAnimation()
				eventManager:notify({id = events.EID_HATCHERY_CLICKED})
			else
				self.hatcheryOffsetX = (1- interp) * self.transAnim.targetX +  interp * self.transAnim.sourceX 
				self.hatcheryOffsetY = (1- interp) * self.transAnim.targetY +  interp * self.transAnim.sourceY 
				
				self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
				self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
				
				self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
				self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
				
				--episode buttons need special handling
				local epbuttons  = self:getChild("episodeButtons")
				epbuttons.scrollX = self.transAnim.drawOffsetX
				epbuttons.scrollY = self.transAnim.drawOffsetY
				epbuttons.dragStartX = cursor.x + 100
				epbuttons.dragStartY = cursor.y
				epbuttons.dragLastX = cursor.x + 100
				epbuttons.dragLastY = cursor.y
				
				self.transAnim.interp = interp
			end
		
		
		--enter from hatchery
		elseif self.transAnim.state == 1 then
			self.hatcheryOffsetX = (1- interp) * self.transAnim.targetX +  interp * self.transAnim.sourceX 
			self.hatcheryOffsetY = (1- interp) * self.transAnim.targetY +  interp * self.transAnim.sourceY 
				
			self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
			self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
				
			self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
			self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
		
			self.transAnim.interp = 1 -  interp

			
		
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0
			end
		
		

		--enter to level selection
		elseif self.transAnim.state == 3 then
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0

				self:initializeFromLevelSelectionAnimation()
				eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION", from = "EPISODE_SELECTION", })
			else
				
				
				self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
				self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
				
				self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
				self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY

				
				self.transAnim.interp = interp
			end
		--return from level selection
		elseif self.transAnim.state == 4 then
				
			self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
			self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
		
				
			self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
			self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
		
			self.transAnim.interp = 1 -  interp

			
		
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0
			end
		end

	end

end

--hatchery transition
function HatcheryEpisodeSelection:initializeGoToHatcheryAnimation()
		self.transAnim.state = 2
		
		self.transAnim.sourceX = self.hatcheryOffsetX
		self.transAnim.sourceY = self.hatcheryOffsetY
		
		self.transAnim.targetX = 0
		self.transAnim.targetY = 0
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = self.hatcheryScaleX, self.hatcheryScaleY 
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 1,1
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = screenWidth
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = 0
		self.transAnim.drawOffsetSourceY = 0
end


function HatcheryEpisodeSelection:initializeFromHatcheryAnimation()
		self.transAnim.state = 1
		
		self.transAnim.sourceX = 0
		self.transAnim.sourceY = 0
		
		self.transAnim.targetX, self.transAnim.targetY = screenWidth*0.3, screenHeight*0.15
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = 1, 1
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.6, 0.6
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = 0
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = screenWidth
		self.transAnim.drawOffsetSourceY = 0
end

--level selection transition
function HatcheryEpisodeSelection:initializeToLevelselectionAnimation()
		self.transAnim.state = 3
		
		self.transAnim.sourceX = 0
		self.transAnim.sourceY = 0
		
		self.transAnim.targetX, self.transAnim.targetY = screenWidth*0.3, screenHeight*0.15
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = 1, 1
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.6, 0.6
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = 0
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = screenWidth
		self.transAnim.drawOffsetSourceY = 0
end

function HatcheryEpisodeSelection:initializeFromLevelselectionAnimation()
		self.transAnim.state = 4
		
		self.transAnim.sourceX = 0
		self.transAnim.sourceY = 0
		
		self.transAnim.targetX, self.transAnim.targetY = screenWidth*0.3, screenHeight*0.15
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = 1, 1
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.6, 0.6
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = 0
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = screenWidth
		self.transAnim.drawOffsetSourceY = 0
end


function HatcheryEpisodeSelection:layout()
	
	setFont(fontBasic)
		
	--page indicator dots
	local num_dots = #g_episodeIds + extraButtons
	local dot_y = 10
	local dot_spacing = 15
	local first_dot_x = screenWidth * 0.5 - (num_dots - 1) * 0.5 * dot_spacing
	
	for i = 1, num_dots do
		local dot = self:getChild("dot" .. i)
		dot.x = first_dot_x + dot_spacing * (i - 1)
		dot.y = screenHeight - dot_y
		dot.scrollAnimationY = 2*dot_y
		dot.scrollAnimationX = 0
	end

	local backButton = self:getChild("backButton")
	backButton.x = 0
	backButton.y = screenHeight
	backButton.scrollAnimationX = -screenWidth
	backButton.scrollAnimationY = 0
	LevelSelectionRoot.layout(self)
	
	
	
	local hatchButton = self:getChild("hatchButton")
	hatchButton.height = screenHeight*0.25
	hatchButton.width = screenWidth*0.2
	hatchButton.x = screenWidth*0.5 + self.hatcheryOffsetX
	hatchButton.y = screenHeight*0.87
	
	
	
	

	
end

function HatcheryEpisodeSelection:draw(x,y)

	--hatcheryView
	local hatcheryView = Hatchery.Hatchery:getNestView()	
	
	hatcheryView:drawMenuNestView(x + self.hatcheryOffsetX, y+ self.hatcheryOffsetY,self.hatcheryScaleX,self.hatcheryScaleY)
	
	--need to draw some objects differently because of the offset animation
	-- drawLevelSelectionBackground()

	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	
	for i,v in _G.ipairs(self.children) do
		if v.visible == true then
			local offsetX, offsetY = self.transAnim.drawOffsetX, self.transAnim.drawOffsetY
			local animScaleX, animScaleY = 1,1
			if self.transAnim.interp then
				if v.scrollAnimationX then
					offsetX = v.scrollAnimationX*(1-self.transAnim.interp)
				end
				if v.scrollAnimationY then
					offsetY = v.scrollAnimationY * (1-self.transAnim.interp)
				end
				if v.scrollScaleX then
					animScaleX = (1-self.transAnim.interp) * v.scrollScaleX
					animScaleY = (1-self.transAnim.interp) * v.scrollScaleY
				end
			end
			
			v:draw((x + self.x + offsetX), (y+ self.y + offsetY), scaleX * self.scaleX* animScaleX, scaleY * self.scaleY*animScaleY, angle + self.angle)
		end
	end
	
	if self.topBar then
		for k,v in _G.pairs(self.topBar) do
			v:draw(x + self.x,y + self.y,  scaleX * self.scaleX, scaleY * self.scaleY, angle + self.angle)
		end
	end
	
	
	if self.popup then
		self.popup:draw(x,y)
	end
end

function HatcheryEpisodeSelection:showPopup(popup)
	self.popup = popup
end

function HatcheryEpisodeSelection:closePopup()
	self.popup = nil
end

function HatcheryEpisodeSelection:onPointerEvent(eventType,x,y)
	local result, meta = nil, nil
	
	
	-- because not all the ui elements in the scene are children to this scene, we need to do some custom input handling. First we check if popup is pressed, then top bar and if they were not handling the input, we use the normal input handling
	if self.popup then
		result, meta = self.popup:onPointerEvent(eventType,x,y)
	else
		if self.topBar then
			for k,v in _G.pairs(self.topBar) do
				result, meta = v:onPointerEvent(eventType,x,y)
				if result ~= nil then
					break
				end
			end
		end
		if result == nil then
			result, meta = EpisodeSelection.onPointerEvent(self,eventType,x,y)
		end
	end
	
	if result == Hatchery.hatcheryEvents.EID_HATCHERY_BUY_STARS then
		local buyStars = Hatchery.hatchery:getNestView():getChild("buyStars")
		self:showPopup(buyStars)
	elseif result == Hatchery.hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL or result == Hatchery.hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY  then
		self:closePopup()
	elseif result == Hatchery.hatcheryEvents.EID_HATCHERY_GO_TO_HATCHERY_FROM_EPISODE_SELECTION then
		
		self:initializeGoToHatcheryAnimation()

	end
	
	return result, meta
end

--ScrollPage override,
HatcheryEpisodeScrollFrame = EpisodeScrollFrame:new()

function HatcheryEpisodeScrollFrame:layout()

	
	local posY = screenHeight*0.4
	--create anchors for scrolling pages
	self.anchors = {}
	
	for i = 1, #g_episodeIds + extraButtons do
		_G.table.insert(self.anchors, i, { (i - 1) * -screenWidth * 0.5, 0 })
	end
	
	self:setCurrentAnchor(self.currentSelection)
	--self:setCurrentX((self.currentSelection - 1) * -screenWidth * 0.5)
	--print("scrollX= " .. self.scrollX .. " sel=" .. self.currentSelection .. "\n")

	ui.ScrollFrame.layout(self)
	
	local buttonIndex = 1
	if g_challengesEnabled then
		local challengeButton = self:getChild("challengeButton")
		local bg = challengeButton:getChild("")
		--challengeButton.w, challengeButton.h = self:getEpisodeButtonDimensions()
		--local w,h = self:getEpisodeButtonDimensions()
		--challengeButton:setSize(w,h)
		challengeButton.x = buttonIndex * screenWidth * 0.5
		challengeButton.y = posY
		buttonIndex = buttonIndex + 1	
	end

	
	--hatchery button
	if g_hatcheryEnabled then
		local hatcheryButton = self:getChild("hatcheryButton")
		hatcheryButton.x = buttonIndex * screenWidth * 0.5
		hatcheryButton.y = posY
		buttonIndex = buttonIndex + 1
	end


	
	--position episode boxes
	for i = 1, #g_episodeIds do
		local episodeBox = self:getChild("episode" .. g_episodeIds[i])
		episodeBox.x = buttonIndex * screenWidth * 0.5
		episodeBox.y = posY
		buttonIndex = buttonIndex + 1
	end
	
	--upsell button
	local upsellButton = self:getChild("upsellButton")
	upsellButton.x = buttonIndex * screenWidth * 0.5
	upsellButton.y = posY
	buttonIndex = buttonIndex + 1		
	
	--newsletter/seasons buttons
	local newsletterButton = self:getChild("newsletterButton")
	newsletterButton.x = buttonIndex * screenWidth * 0.5
	buttonIndex = buttonIndex + 1
	
	if isSeasonsAvailable then
		local seasonsButton = newsletterButton:getChild("seasonsButton")
		local _, seasonsButtonHeight = _G.res.getSpriteBounds(seasonsButton.image)
		seasonsButton.y = -seasonsButtonHeight
		newsletterButton.y = _G.math.floor(posY + seasonsButtonHeight * 0.5)
	else
		newsletterButton.y = posY
	end
	
	self:refreshVisibleChildren()
end



filename="EpisodeSelection.lua"
