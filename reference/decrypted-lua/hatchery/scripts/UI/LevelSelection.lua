HatcheryLevelSelection = LevelSelection


function HatcheryLevelSelection:init()

	
	
	local levelButtons = HatcheryLevelScrollFrame:new(nil, self.episode)
	levelButtons.name = "levelButtons"
	self:addChild(levelButtons)
	
	self.popup = nil
	
	--return to episode selection button
	local backButton = ui.ImageButton:new()
	backButton.name = "backButton"
	backButton:setImage("LS_BACK_BUTTON")
	backButton.returnValue = "EPISODE_SELECTION"
	backButton.attach = "fixed"
	backButton.activateOnRelease = true
	backButton.clickSound = "menu_back"
	backButton.scrollDirection = -1
	self:addChild(backButton)
	
	self.currentSelection = settingsWrapper:getCurrentLevelSelectionPage(self.episode)
	if self.currentSelection > #g_episodes[self.episode].pages then
		self.currentSelection = #g_episodes[self.episode].pages
		settingsWrapper:setCurrentLevelSelectionPage(self.episode, self.currentSelection)
	end
	levelButtons.currentSelection = self.currentSelection
	
	--page specific stuff
	for i = 1, #g_episodes[self.episode].pages do
	
		local page = g_episodes[self.episode].pages[i]
	
		--page indicator dots
		local dot = ui.Image:new()
		dot.name = "dot" .. i
		dot:setImage("LS_DOT_BLACK")
		dot.attach = "fixed"
		self:addChild(dot)
		
		--page numbers by the dots
		local pageNumber = ui.Text:new()
		pageNumber.name = "pageNumber" .. i
		if page.display_dot_numbers ~= false then
			pageNumber.text = page.display_number or ""
		else
			pageNumber.text = ""
		end
		pageNumber.font = "FONT_LS_SMALL"
		pageNumber.visible = false
		pageNumber.attach = "fixed"
		self:addChild(pageNumber)
	end
	self.topBarAdded = false
	eventManager:addEventListener(events.EID_SCROLL_TO_NEXT_WORLD, self)
	
	local hatcheryButton = ui.InvisibleButton:new()
	hatcheryButton.name = "hatchButton"
	hatcheryButton.returnValue = Hatchery.hatcheryEvents.EID_HATCHERY_GO_TO_HATCHERY_FROM_LEVELSELECTION
	hatcheryButton.activateOnRelease = true
	self:addChild(hatcheryButton)
	
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

function HatcheryLevelSelection:update(dt, time) 
	LevelSelectionRoot.update(self,dt, time)
	local hatcheryView = Hatchery.Hatchery:getNestView()
	hatcheryView:setInteractive(false)
	hatcheryView:update(dt, time)
	self:animateTransition(dt, time)
end

function HatcheryLevelSelection:onEntry()
	eventManager:addEventListener(events.EID_FACEBOOK_LIKE_CLICKED, self)
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_AVAILABLE, self)
	loginfo("added EID_MIGHTY_EAGLE_AVAILABLE for levelSelection")
	
	if rovioNewsIsShown then
		rovioNews:hide()
		rovioNewsIsShown = false
	end
	rovioNewsShowWhenLoaded = false
	
	self:shadeBackground(self.currentSelection)
	self:updateSelection(true)
	
	--causes camera to reset to default when a level is entered
	levelRestartedFrom = nil

	LevelSelectionRoot.onEntry(self)
	local hatcheryView = Hatchery.Hatchery:getNestView()
	hatcheryView:onEntry()
	
	self.hatcheryOffsetX, self.hatcheryOffsetY  = screenWidth*0.3, screenHeight*0.15
	self.hatcheryScaleX, self.hatcheryScaleY = 0.5,0.5

	if self.topBar == nil then 
		self.topBar = hatcheryView:getTopBar()
	end
end
function HatcheryLevelSelection:onPointerEvent(eventType,x,y)

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
			result, meta = LevelSelectionRoot.onPointerEvent(self,eventType,x,y)
		end
	end
		
	if result == Hatchery.hatcheryEvents.EID_HATCHERY_BUY_STARS then
		local buyStars = Hatchery.hatchery:getNestView():getChild("buyStars")
		buyStars.visible = true
		if not self:getChild("buyStars") then 
			self:addChild(buyStars)
		end
	elseif result == Hatchery.hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL or result == Hatchery.hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY  then
		local buyStars = Hatchery.hatchery:getNestView():getChild("buyStars")
		buyStars.visible = false
		self:removeChild(buyStars)
	elseif result == Hatchery.hatcheryEvents.EID_HATCHERY_GO_TO_HATCHERY_FROM_LEVELSELECTION then
		
		self:initializeGoToHatcheryAnimation()

	end
end
function HatcheryLevelSelection:draw(x, y)

	local hatcheryView = Hatchery.Hatchery:getNestView()
	hatcheryView:drawMenuNestView(x + self.hatcheryOffsetX, y+ self.hatcheryOffsetY,self.hatcheryScaleX,self.hatcheryScaleY)
	
	-- drawLevelSelectionBackground()	
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
	
	
end

function HatcheryLevelSelection:showPopup(popup)
	self.popup = popup
end

function HatcheryLevelSelection:closePopup()
	self.popup = nil
end

function HatcheryLevelSelection:layout()
		
	local backButton = self:getChild("backButton")
	backButton.y = screenHeight
	backButton.scrollAnimationX = -screenWidth
	backButton.scrollAnimationY = 0
	--page specific stuff
	
	--dot & text coordinate stuff
	local pages = g_episodes[self.episode].pages
	local dot_y = 10
	local dot_spacing = 15
	local first_dot_x = screenWidth * 0.5 - (#pages - 1) * 0.5 * dot_spacing
	local text_y = 0.03 * screenHeight + 12
	
	for i = 1, #pages do
	
		local dot = self:getChild("dot" .. i)
		dot.x = first_dot_x + dot_spacing * (i - 1)
		dot.y = screenHeight - dot_y
		dot.scrollAnimationY = 2*dot_y
		dot.scrollAnimationX = 0
		
		local pageNumber = self:getChild("pageNumber" .. i)
		pageNumber.x = dot.x
		pageNumber.y = screenHeight - text_y

		
	end
	
	LevelSelectionRoot.layout(self)
	

	local hatchButton = self:getChild("hatchButton")
	hatchButton.height = screenHeight*0.25
	hatchButton.width = screenWidth*0.2
	hatchButton.x = screenWidth*0.5 + self.hatcheryOffsetX
	hatchButton.y = screenHeight*0.87
end


HatcheryLevelScrollFrame =LevelScrollFrame



function HatcheryLevelScrollFrame:layout()

	--create anchors for scrolling pages
	self.anchors = {}
	local anchorAmount = #g_episodes[self.episode].pages

	for i = 1, anchorAmount do
		_G.table.insert(self.anchors, i, { (i - 1) * -screenWidth, 0 })
	end
	
	if not self.single_page then
		ui.ScrollFrame.layout(self)
	else
		ui.Frame.layout(self)
	end
	
	if(self.episode == 3) then
		local egg = self:getChild("GoldenEggEP3")		
		if(egg ~= nil) then
			local w, h =_G.res.getSpriteBounds(egg.image)
			egg.y = screenHeight * 0.5 - h / 2		
			egg.x = anchorAmount * screenWidth + w * 2		
		end
	end
	
	if not self.single_page then
		self:setCurrentAnchor(self.currentSelection)
	end

	for i = 1, #g_episodes[self.episode].pages do
	
		local page = g_episodes[self.episode].pages[i]
	
		--level buttons
		if page.layout == "grid" then
			
			--level positioning
			local y_begin = -0.0 * screenHeight
			local y_line_gap_multiplier = 1.0
			local content_width = 0.83
			local levels_per_page = page.layout_params.cols * page.layout_params.rows
			local x_begin = (i - 1) * screenWidth + 0.5 * screenWidth * (1 - content_width)
			local x_gap = (content_width * screenWidth) / (page.layout_params.cols - 1)
			
			for j = 1, page.layout_params.rows do
				local row_y = screenHeight * (j / (page.layout_params.rows + 2) * y_line_gap_multiplier)
				for k = 1, page.layout_params.cols do
					local level_button = self:getChild("level" .. i .. "-" .. (j - 1) * page.layout_params.cols + k)
					level_button.x = x_begin + x_gap * (k - 1)
					level_button.y = y_begin + row_y
					
					local level_button_width, level_button_height = _G.res.getSpriteBounds(level_button.image)
					
					local stars = level_button:getChild("stars")
					stars.y = level_button_height * 0.5
					
					--<hatchery>
					--[[
					if g_hatcheryCurrencyEnabled then
						local hatcheryProgress = level_button:getChild("hatcheryProgress")
						hatcheryProgress.y = level_button_height * 0.25
					end
					]]--
					--</hatchery>
					
				end
			end
			
		elseif page.layout == "facebook" then
		
			local fb_button = self:getChild("fbButton" .. i)
			local _, fbh = _G.res.getSpriteBounds(fb_button.image)
			local page_x = (i - 1) * screenWidth + 0.5 * screenWidth
			fb_button.x = page_x
			fb_button.y = screenHeight / 2.75
			
			--level positioning
			
			local lbw, lbh = _G.res.getSpriteBounds(page.level_button)
			
			for j = 1, page.layout_params.levels do
				local level_button = self:getChild("level" .. i .. "-" .. j)
				level_button.x = page_x - ((page.layout_params.levels - 1) * 0.5) * 1.5 * lbw + (j - 1) * 1.5 * lbw
				level_button.y = fb_button.y + fbh / 2.28 + lbh * 0.5
				
				local stars = level_button:getChild("stars")
				stars.y = lbh * 0.5
			end

		elseif page.layout == "goldeneggs" then
		
			for j = 1, #page.levels do
				local level_button = self:getChild("level" .. i .. "-" .. j)
				level_button.x = (i - 1) * screenWidth + (page.levels[j].x or 0.5) * screenWidth
				level_button.y = (page.levels[j].y or 0.5) * screenHeight
				local star_effect = self:getChild("starEffect" .. i .. "-" .. j)
				star_effect.x = level_button.x
				star_effect.y = level_button.y
			end
		
		end
	end
	
	self:refreshVisibleChildren()
end



function HatcheryLevelSelection:animateTransition(dt, time)
	
	
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
				
				
				self.transAnim.interp = interp
				
			end
		
		
		--enter from hatchery
		elseif self.transAnim.state == 1 then
		
		
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0
			end
		
			self.hatcheryOffsetX = (1- interp) * self.transAnim.targetX +  interp * self.transAnim.sourceX 
			self.hatcheryOffsetY = (1- interp) * self.transAnim.targetY +  interp * self.transAnim.sourceY 
				
			self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
			self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
				
			self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
			self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
			
			self.transAnim.interp = 1 -interp
			
		elseif self.transAnim.state == 3 then
		
		end
	end
	
	
	
	
end

function HatcheryLevelSelection:initializeGoToHatcheryAnimation()
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


function HatcheryLevelSelection:initializeFromHatcheryAnimation()
		self.transAnim.state = 1
		
		self.transAnim.sourceX = 0
		self.transAnim.sourceY = 0
		
		self.transAnim.targetX, self.transAnim.targetY = screenWidth*0.3, screenHeight*0.15
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = 1, 1
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.5, 0.5
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = 0
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = screenWidth
		self.transAnim.drawOffsetSourceY = 0
end


filename="LevelSelection.lua"
