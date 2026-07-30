EpisodeSelection = LevelSelectionRoot:new()

-- Global. Easier this way though.
extraButtons = 2
episodeNumberOffset = 0
if g_challengesEnabled then
	extraButtons = extraButtons + 1
	episodeNumberOffset = episodeNumberOffset - 1
end
if g_hatcheryEnabled then
	extraButtons = extraButtons + 1
	episodeNumberOffset = episodeNumberOffset - 1
end

function EpisodeSelection:init()
	local episodeButtons = EpisodeScrollFrame:new()
	episodeButtons.name = "episodeButtons"
	self:addChild(episodeButtons)
	--gift button
	if deviceModel == "iphone" or deviceModel == "iphone4" or deviceModel == "ipad" or (deviceModel == "android" and isHDVersion and not isPremium) then
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
	end
	
	self:createDecorationSprites()
	
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
	
	self.name = "episodeSelectionRoot"

end

function EpisodeSelection:onKeyEvent(eventType, key)
	if key == "BACK" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU", from = "EPISODE_SELECTION" })
	end	
end



function EpisodeSelection:onPointerEvent(eventType,x,y)
	local result, meta = LevelSelectionRoot.onPointerEvent(self,eventType,x,y)
	
	-- Reveals golden egg from episode selection menu
	if x > screenWidth * 0.45 and x < screenWidth * 0.55 and y > screenHeight * 0.85 and y < screenHeight * 0.95 then
		if(eventType == "LPRESS") then
			self.GEClicks = self.GEClicks or 0
			self.GEClicks = self.GEClicks + 1
			-- TODO: level name here? get from episodes.
			local goldenEggLevel = "LevelGE_14"
			if self.GEClicks > 1 and not settingsWrapper:isGoldenEggUnlocked(goldenEggLevel) then
				eventManager:notify({id = events.EID_GOLDEN_EGG_FROM_MENU, levelName = goldenEggLevel})
				--revealGoldenEgg(goldenEggLevel)			
			end
		end
	else
		self.GEClicks = 0
	end
	
	if result == "GOTO_MAIN_MENU" then
		--eventManager:queueEvent({id = events.EID_GOTO_MAIN_MENU, from = "EPISODE_SELECTION"})
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU", from = "EPISODE_SELECTION" })
	elseif result == "GOTO_LEVEL_SELECTION" then
		eventManager:queueEvent({id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_"..meta, from = "EPISODE_SELECTION"})					
	elseif result == "GOTO_GIFT_PURCHASE" then
		eventManager:notify({id = events.EID_GIFT_PURCHASE_CLICKED})					
	elseif result == "GOTO_LENOVO_ADFREE" then
		eventManager:notify({id = events.EID_LENOVO_ADFREE_CLICKED})			
	elseif result == "GOTO_NEWSLETTER" then
		eventManager:notify({id = events.EID_NEWSLETTER_CLICKED})					
	elseif result == "GOTO_SEASONS" then
		eventManager:notify({id = events.EID_SEASONS_CLICKED})							
	elseif result == "GOTO_AB_SHOP" then
		eventManager:notify({id = events.EID_AB_SHOP_CLICKED})								
	elseif result == "GOTO_HATCHERY" then
		eventManager:notify({id = events.EID_HATCHERY_CLICKED})						
	elseif result == "GOTO_CHALLENGE" then
		eventManager:notify({id = events.EID_CHANGE_SCENE, target = "CHALLENGE_PAGE", from = "EPISODE_SELECTION"})						
		
	end
	return result,meta
end



--create decorative sprites in the bottom corners of the screen
function EpisodeSelection:createDecorationSprites()
	--left side decoration image
	local left = ui.Image:new()
	left.name = "left"
	left:setImage("LS_MAIN_LEFT")
	left.attach = "fixed"
	self:addChild(left)
	
	--right side decoration image
	local right = ui.Image:new()
	right.name = "right"
	right:setImage("LS_MAIN_RIGHT")
	right.attach = "fixed"
	self:addChild(right)
end




function EpisodeSelection:update(dt, time)
	LevelSelectionRoot.update(self, dt, time)
	
	if g_challengesEnabled then
		local unviewedChallengesCount = getUnviewedChallengesCount()
	
		local challengeButton = self:getChild("challengeButton")
		challengeButton:setUnviewedChallengesCount(unviewedChallengesCount)	
		challengeButton.timer = challengeButton.timer + dt * 3
		
		
		local newChallengesText = self:getChild("newChallengesText")
		local challengeImage = self:getChild("challengeImage")
		--local hRate = _G.res.getFontLeading(newChallengesText.font) / challengeImage.h
	
		newChallengesText.scaleY = 0.7 +  _G.math.sin(challengeButton.timer) * 0.15
		newChallengesText.scaleX = 0.7 +  _G.math.sin(challengeButton.timer) * 0.15
	
		challengeImage.scaleX = 1 +  _G.math.sin(challengeButton.timer) * 0.15
		challengeImage.scaleY = 1 +  _G.math.sin(challengeButton.timer) * 0.15
	end
	
	self:updateSelection()
end

function EpisodeSelection:updateSelection(initial_selection)

	local new_index = self.currentSelection
	if not initial_selection then
		new_index = self:getChild("episodeButtons"):getCurrentAnchor()
	end
	
	if self.currentSelection ~= new_index or initial_selection then
		
		settingsWrapper:setSelectedEpisode(new_index + episodeNumberOffset)
		
		local new_dot = self:getChild("dot" .. new_index)
		if new_dot ~= nil then
			self:getChild("dot" .. self.currentSelection):setImage("LS_DOT_BLACK")
			new_dot:setImage("LS_DOT_WHITE")
			self.currentSelection = new_index
			self:getChild("episodeButtons"):setEnabledSlot(new_index)
		end
		self:getChild("episodeButtons").currentSelection = new_index
	end
end

function EpisodeSelection:onEntry()

	self:updateSelection(true)
	self.GEClicks = 0	
	ui.Frame.onEntry(self)
end

function EpisodeSelection:draw(x,y)
	drawLevelSelectionBackground()
	ui.Frame.draw(self, x, y)
end

function EpisodeSelection:layout()
	
	setFont(fontBasic)

	local left = self:getChild("left")
	left.x = 0
	left.y = screenHeight
	
	local right = self:getChild("right")
	right.x = screenWidth
	right.y = screenHeight
		
	--page indicator dots
	local num_dots = #g_episodeIds + extraButtons
	local dot_y = 10
	local dot_spacing = 15
	local first_dot_x = screenWidth * 0.5 - (num_dots - 1) * 0.5 * dot_spacing
	
	for i = 1, num_dots do
		local dot = self:getChild("dot" .. i)
		dot.x = first_dot_x + dot_spacing * (i - 1)
		dot.y = screenHeight - dot_y
	end

	local backButton = self:getChild("backButton")
	backButton.x = 0
	backButton.y = screenHeight
	
	--gift button
	local giftButton = self:getChild("giftButton")
	if giftButton ~= nil then
		local giftButtonWidth, giftButtonHeight = _G.res.getSpriteBounds(giftButton.image)
		giftButton.x = _G.math.floor(screenWidth - giftButtonWidth * 0.5)
		giftButton.y = _G.math.floor(giftButtonHeight * 0.5)
	end
	
	LevelSelectionRoot.layout(self)
end


EpisodeScrollFrame = ui.ScrollFrame:new()

function EpisodeScrollFrame:init()
	--create episode buttons
	local episodeButtons = {}
	self.slots = {}
	
	local slotIndex = 1

	if g_challengesEnabled then
		-- Challenge button
--		local challengeButton = ui.BGBox:new()
--		challengeButton.components = { topLeft = "CHALLENGES_TOP_LEFT", topMiddle = "CHALLENGES_TOP_MIDDLE", topRight = "CHALLENGES_TOP_RIGHT",
--							left = "CHALLENGES_LEFT", center = "CHALLENGES_CENTER", right = "CHALLENGES_RIGHT", 
--							bottomLeft = "CHALLENGES_BOTTOM_LEFT", bottomMiddle = "CHALLENGES_BOTTOM_MIDDLE", bottomRight = "CHALLENGES_BOTTOM_RIGHT" }
		
		
		local challengeButton = ui.ImageButton:new()
		challengeButton.timer = 0
		--challengeButton.vanchor = "VCENTER"
		--challengeButton.hanchor = "HCENTER"

		challengeButton:setImage("CHALLENGES_EPISODE_SELECTION")		
		challengeButton.name = "challengeButton"
		
		challengeButton.returnValue = "GOTO_CHALLENGE"
		challengeButton.activateOnRelease = true
		
		challengeButton.onPointerEvent = function(o,eventType,x,y)
			if eventType == "LRELEASE" then
				x = x + challengeButton.w * 0.5
				y = y + challengeButton.h * 0.5
				if x >= challengeButton.x and x <= challengeButton.x + (challengeButton.w) and y >= challengeButton.y  and y <= challengeButton.y + (challengeButton.h) then
					_G.res.playAudio("menu_confirm", 1, false)
					return challengeButton.returnValue, challengeButton.meta
				end
			end
		end
		
		challengeButton.setUnviewedChallengesCount = function(o, count)
			if count == nil or count == 0 then
				challengeButton:getChild("newChallengesText").visible = false
				challengeButton:getChild("challengeImage").visible = false
				return 
			end
			
			challengeButton.newChallengesCount = count
			
			local text = challengeButton:getChild("newChallengesText")
			challengeButton:getChild("challengeImage").visible = true
			text.visible = true
			challengeButton:getChild("newChallengesText").text = _G.tostring(count)
			text:clip()			
		end	
		
		local challengeImage = ui.ImageButton:new({name = "challengeImage"})
		challengeImage:setImage("H_NOTIFICATION_ICON_BG")
		challengeImage.x = 0--challengeButton.w * 0.28 
		challengeImage.y = challengeButton.h * 0.45
		challengeImage.floorCoordinates = false
		challengeButton:addChild(challengeImage)		
		
		
		local newChallengesText = ui.Text:new({name = "newChallengesText", text = ""})		
		newChallengesText:clip()
		newChallengesText.x = challengeImage.x --challengeButton.w * 0.50
		newChallengesText.y = challengeImage.y ---challengeButton.h * 0.50
		newChallengesText.scaleX = 0.5
		newChallengesText.scaleY = 0.5
		newChallengesText.floorCoordinates = false
		
		challengeButton:addChild(newChallengesText)
		self:addChild(challengeButton)
		
		self.slots[slotIndex] = { "challengeButton" }
		slotIndex = slotIndex + 1		
	end
	
	--hatchery button
	if g_hatcheryEnabled then
		local hatcheryButton = ui.ScallableButton:new()
		hatcheryButton.name = "hatcheryButton"
		-- hatcheryButton:setImage("H_BTN_HATCHERY")
		hatcheryButton:setImage("H_BUTTON_HATCHERY")
		hatcheryButton.returnValue = "GOTO_HATCHERY"
		hatcheryButton.activateOnRelease = true
		hatcheryButton.sound = "menu_confirm"
		self:addChild(hatcheryButton)
		self.slots[slotIndex] = { "hatcheryButton" }
		slotIndex = slotIndex + 1		
	end
	
	for i = 1, #g_episodeIds do
		self.slots[slotIndex] = { "episode" .. g_episodeIds[i] }
		slotIndex = slotIndex + 1
	end
	
	for k, v in _G.pairs(g_episodes) do
		episodeButtons[k] = self:createEpisodeButton(k, v)
	end

	
	--upsell button
	local upsellButton = ui.ImageButton:new()
	upsellButton.name = "upsellButton"
	upsellButton:setImage("UPSELL_SHOP")
	upsellButton.returnValue = "GOTO_AB_SHOP"
	upsellButton.activateOnRelease = true
	upsellButton.clickSound = "menu_confirm"
	self:addChild(upsellButton)
	self.slots[slotIndex] = { "upsellButton" }
	slotIndex = slotIndex + 1
	
	--newsletter/AB seasons buttons
	local newsletterButton = ui.ImageButton:new()
	newsletterButton.name = "newsletterButton"
	newsletterButton:setImage("SIGNUP_NEWSLETTER")
	newsletterButton.returnValue = "GOTO_NEWSLETTER"
	newsletterButton.activateOnRelease = true
	newsletterButton.clickSound = "menu_confirm"
	self.slots[slotIndex] = { "newsletterButton" }	
	
	
	if isSeasonsAvailable then
		local seasonsButton = ui.ImageButton:new()
		seasonsButton.name = "seasonsButton"
		seasonsButton:setImage("UPSELL_HALLOWEEN")
		seasonsButton.returnValue = "GOTO_SEASONS"
		seasonsButton.activateOnRelease = true
		seasonsButton.clickSound = "menu_confirm"
		newsletterButton:addChild(seasonsButton)
		_G.table.insert(self.slots[slotIndex], "seasonsButton")
		
	end		

	slotIndex = slotIndex + 1		
	
	self:addChild(newsletterButton)
	
	--set episode button sizes
	local w, h = self:getEpisodeButtonDimensions()
	for _, v in _G.pairs(episodeButtons) do
		v.width = w
		v.height = h
		self:addChild(v)
	end
	
	ui.ScrollFrame.init(self)
end

--create an episode button
function EpisodeScrollFrame:createEpisodeButton(id, episode)

	local button
	if id == "G" then
		button = GoldenEggButton:new()
	else
		button = EpisodeButton:new()
	end
	
	button.name = "episode" .. id
	button:setEpisode(id, episode)
	button.returnValue = "GOTO_LEVEL_SELECTION"
	
	return button
end

--calculate dimensions for episode buttons
function EpisodeScrollFrame:getEpisodeButtonDimensions()
	local biggestEpisodeImageW = 0
	local biggestEpisodeImageH = 0
	local biggestTextW = 0
	
	setFont(fontBasic)
	
	--get the widest episode name string and biggest episode icon size
	--among the normal episodes
	for _, v in _G.pairs(g_episodes) do
		local w, h = _G.res.getSpriteBounds(v.icon)
		
		if w > biggestEpisodeImageW then
			biggestEpisodeImageW = w
		end
		
		if h > biggestEpisodeImageH then
			biggestEpisodeImageH = h
		end
		
		w = _G.res.getStringWidth(v.name)
		
		if w > biggestTextW then
			biggestTextW = w
		end
	end
	
	return _G.math.max(biggestTextW * 0.8, biggestEpisodeImageW * 0.95), biggestEpisodeImageH * 1.7
end

function EpisodeScrollFrame:setEnabledSlot(index)
	--disable all except the active button
	--[[
	for i = 1, #self.slots do
		for j = 1, #self.slots[i] do
			local element = self:getChild(self.slots[i][j])
			element.enabled = true
			element.enabled = i == index
		end
	end
	]]--
	self.enabled_slot = index
end

function EpisodeScrollFrame:onEntry()
	
	for k, _ in _G.pairs(g_episodes) do
		self:getChild("episode" .. k):setOpen(isEpisodeOpen(k))
	end
	
	ui.ScrollFrame.onEntry(self)
	
	self:refreshVisibleChildren()
end

function EpisodeScrollFrame:layout()

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
		challengeButton.y = screenHeight * 0.5
		buttonIndex = buttonIndex + 1	
	end

	
	--hatchery button
	if g_hatcheryEnabled then
		local hatcheryButton = self:getChild("hatcheryButton")
		hatcheryButton.x = buttonIndex * screenWidth * 0.5
		hatcheryButton.y = screenHeight * 0.5
		buttonIndex = buttonIndex + 1
	end


	
	--position episode boxes
	for i = 1, #g_episodeIds do
		local episodeBox = self:getChild("episode" .. g_episodeIds[i])
		episodeBox.x = buttonIndex * screenWidth * 0.5
		episodeBox.y = screenHeight * 0.5
		buttonIndex = buttonIndex + 1
	end
	
	--upsell button
	local upsellButton = self:getChild("upsellButton")
	upsellButton.x = buttonIndex * screenWidth * 0.5
	upsellButton.y = screenHeight * 0.5
	buttonIndex = buttonIndex + 1		
	
	--newsletter/seasons buttons
	local newsletterButton = self:getChild("newsletterButton")
	newsletterButton.x = buttonIndex * screenWidth * 0.5
	buttonIndex = buttonIndex + 1
	
	if isSeasonsAvailable then
		local seasonsButton = newsletterButton:getChild("seasonsButton")
		local _, seasonsButtonHeight = _G.res.getSpriteBounds(seasonsButton.image)
		seasonsButton.y = -seasonsButtonHeight
		newsletterButton.y = _G.math.floor(screenHeight * 0.5 + seasonsButtonHeight * 0.5)
	else
		newsletterButton.y = screenHeight * 0.5
	end
	
	self:refreshVisibleChildren()
end

function EpisodeScrollFrame:refreshVisibleChildren()
	self.visible_children = {}
	local i = 1
	
	local BackgroundBox_draw = BackgroundBox.draw
	local Image_draw = ui.Image.draw
	local Text_draw = ui.Text.draw
	
	local x = self.scrollX
	local y = self.scrollY
	
	for k, v in _G.ipairs(self.children) do
		if v.visible == true and v.x + x >= -screenWidth * 0.5 and v.x + x <= screenWidth * 1.5 then
			--v:draw(x, y, scaleX * self.scaleX, scaleY * self.scaleY, angle + self.angle)
			for k2, v2 in _G.ipairs(v.children) do
				if v2.visible then
					if v2.draw == BackgroundBox_draw then
						--v2:draw(v.x + x, v.y + y, 1, 1, 0)
						self.visible_children[i] = { x = v.x + x, y = v.y + y, item = v2 }
						i = i + 1
					end
					for k3, v3 in _G.ipairs(v2.children) do
						if v3.visible and v3.draw == BackgroundBox_draw then
							--v2:draw(v.x + x, v.y + y, 1, 1, 0)
							self.visible_children[i] = { x = v.x + v2.x + x, y = v.y + v2.y + y, item = v3 }
							i = i + 1
						end
					end
				end
			end
		end
	end
	
	for k, v in _G.ipairs(self.children) do
		if v.visible == true and v.x + x >= -screenWidth * 0.5 and v.x + x <= screenWidth * 1.5 then
			if v.draw == Image_draw then
				--v:draw(x, y, 1, 1, 0)
				self.visible_children[i] = { x = x, y = y, item = v }
				i = i + 1
			end
			for k2, v2 in _G.ipairs(v.children) do
				if v2.visible then
					if v2.draw == Image_draw then
						--v2:draw(v.x + x, v.y + y, 1, 1, 0)
						self.visible_children[i] = { x = v.x + x, y = v.y + y, item = v2 }
						i = i + 1
					end
					for k3, v3 in _G.ipairs(v2.children) do
						if v3.visible and v3.draw == Image_draw then
							--v2:draw(v.x + x, v.y + y, 1, 1, 0)
							self.visible_children[i] = { x = v.x + v2.x + x, y = v.y + v2.y + y, item = v3 }
							i = i + 1
						end
					end
				end
			end
		end
	end
	
	for k, v in _G.ipairs(self.children) do
		if v.visible == true and v.x + x >= -screenWidth * 0.5 and v.x + x <= screenWidth * 1.5 then
			for k2, v2 in _G.ipairs(v.children) do
					if v2.visible then
					if v2.draw == Text_draw then
						--v2:draw(v.x + x, v.y + y, 1, 1, 0)
						self.visible_children[i] = { x = v.x + x, y = v.y + y, item = v2 }
						i = i + 1
					end
					for k3, v3 in _G.ipairs(v2.children) do
						if v3.visible and v3.draw == Text_draw then
							--v2:draw(v.x + x, v.y + y, 1, 1, 0)
							self.visible_children[i] = { x = v.x + v2.x + x, y = v.y + v2.y + y, item = v3 }
							i = i + 1
						end
					end
				end
			end
		end
	end
end

function EpisodeScrollFrame:update(dt, time)
	local sx = self.scrollX
	self:doUpdate(dt, time)
	if sx ~= self.scrollX then
		self:refreshVisibleChildren()
	end
end

function EpisodeScrollFrame:onPointerEvent(eventType, x, y)
	local result, meta, element = ui.ScrollFrame.onPointerEvent(self, eventType, x, y)
	
	if result then
		for i = 1, #self.slots do
			for j = 1, #self.slots[i] do
				if element == self:getChild(self.slots[i][j]) then
					if self.enabled_slot == i then
						return result, meta, element
					else
						self:scrollToAnchor(i)
					end
				end
			end
		end
	end
	
	return nil, nil, nil
end

--custom draw function for performance reasons
function EpisodeScrollFrame:draw(x, y, scaleX, scaleY, angle)
	x = x or 0
	y = y or 0
	x = x + self.scrollX
	y = y + self.scrollY
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	x = _G.math.floor(x)
	y = _G.math.floor(y)
	
	for k, v in _G.ipairs(self.visible_children) do
		if v.item.drawFast ~= nil then
			v.item:drawFast(v.x, v.y)
		elseif v.item.drawSelf ~= nil then
			v.item:drawSelf(v.x, v.y, 1, 1, 0)
		else
			v.item:draw(v.x, v.y, 1, 1, 0)
		end
	end
end

BackgroundBox = ui.Frame:new()

function BackgroundBox:init()
	self.x = 0
	self.y = 0
	self.visible = true
	self.locked = false
	ui.Frame.init(self)
end

function BackgroundBox:drawSelf(x, y, scaleX, scaleY)
	if self.visible == false then return end
	
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	
	setRenderState(0, 0, 1, 1)

	drawBoxNative(
		self.components,
		_G.math.floor(self.x + x),
		_G.math.floor(self.y + y),
		_G.math.floor(self.width * scaleX),
		_G.math.floor(self.height * scaleY),
		self.hanchor,
		self.vanchor,
		nil
	)
end

function BackgroundBox:draw(x, y, scaleX, scaleY)
	self:drawSelf(x, y, scaleX, scaleY)
	
	ui.Frame.draw(self, x, y, scaleX, scaleY)
end

EpisodeButtonBase = ui.Frame:new()

function EpisodeButtonBase:init()
	self.x = 0
	self.y = 0
	self.enabled = true
		
	--the coloured background of the button
	local background = BackgroundBox:new()
	background.name = "background"
	background.hanchor = "HCENTER"
	background.vanchor = "VCENTER"
	self:addChild(background)
	
	--yellow line between text and image
	local yellowLine = BackgroundBox:new()
	yellowLine.name = "yellowLine"
	yellowLine.hanchor = "HCENTER"
	yellowLine.vanchor = "TOP"
	yellowLine.components = { topMiddle = "EPISODE_YELLOW_LINE" }
	background:addChild(yellowLine)
	
	--set button images
	local episodeIcon = ui.Image:new()
	episodeIcon.name = "episodeIcon"
	background:addChild(episodeIcon)
	
	--set episode name
	local episodeName = ui.Text:new()
	episodeName.name = "episodeName"
	episodeName.hanchor = "HCENTER"
	episodeName.vanchor = "BASELINE"
	background:addChild(episodeName)

	ui.Frame.init(self)
end

function EpisodeButtonBase:setOpen(open)
	self.locked = not open
end

function EpisodeButtonBase:layout()

	setFont(fontBasic)
	local fontHeight = _G.res.getFontHeight()

	local background = self:getChild("background")
	background.width = self.width
	background.height = self.height
	
	local episodeName = self:getChild("episodeName")
	episodeName.y = _G.math.floor(self.height * -0.44)
	
	local yellowLine = background:getChild("yellowLine")
	yellowLine.y = background:getChild("episodeName").y + fontHeight * 0.4
	yellowLine.width = self.width
	yellowLine.height = 1

	ui.Frame.layout(self)

end

function EpisodeButtonBase:setEpisode(id, episode)
	self.episode = id
	
	local background = self:getChild("background")
	background.components =
	{
		topLeft =      "EPISODE" .. id .. "_TOP_LEFT",
		topMiddle =    "EPISODE" .. id .. "_TOP_MIDDLE",
		topRight =     "EPISODE" .. id .. "_TOP_RIGHT",
		left =         "EPISODE" .. id .. "_LEFT",
		center =       "EPISODE" .. id .. "_CENTER",
		right =        "EPISODE" .. id .. "_RIGHT",
		bottomLeft =   "EPISODE" .. id .. "_BOTTOM_LEFT",
		bottomMiddle = "EPISODE" .. id .. "_BOTTOM_MIDDLE",
		bottomRight =  "EPISODE" .. id .. "_BOTTOM_RIGHT"
	}
	
	local episodeIcon = background:getChild("episodeIcon")
	episodeIcon:setImage(episode.icon)
	
	local episodeName = background:getChild("episodeName")
	episodeName.text = episode.name
end

function EpisodeButtonBase:draw(x, y)
	ui.Frame.draw(self, _G.math.floor(x), _G.math.floor(y))
end

function EpisodeButtonBase:onPointerEvent(eventType, x, y)
	
	local result, meta, element = ui.Frame.onPointerEvent(self, eventType, x, y)
	
	if not result and eventType == "LRELEASE" and self.enabled and not self.locked then
		local background = self:getChild("background")
		if x >= self.x - background.width * 0.5 and
		   x <= self.x + background.width * 0.5 and
		   y >= self.y - background.height * 0.5 and
		   y <= self.y + background.height * 0.5 then
		   result = self.returnValue
		   meta = self.episode
		   _G.res.playAudio("menu_confirm", 1, false)
		   return result, meta, self
		end
	end
	
	return result, meta, element
end

EpisodeButton = EpisodeButtonBase:new()

function EpisodeButton:init()
	
	self.scoreSprite = _G.res.getString("TEXTS_BASIC", "TEXT_SCORE_SPRITE")
	
	--feather score box below the main episode button
	local featherBox = BackgroundBox:new()
	featherBox.name = "featherBox"
	featherBox.hanchor = "HCENTER"
	featherBox.vanchor = "TOP"
	self:addChild(featherBox)
	
	EpisodeButtonBase.init(self)
	
	--feather icon
	local feather = ui.Image:new()
	feather.name = "feather"
	feather:setImage("EPISODE_SELECTION_FEATHER")
	self:addChild(feather)
	
	--feather score/maximum
	local featherScore = ui.Text:new()
	featherScore.name = "featherScore"
	featherScore.text = ""
	featherScore.font = "FONT_LS_SMALL"
	self:addChild(featherScore)
	
	--sprites for score box borders
	local scoreComponents =
	{
		topLeft =      "SCORE_TOP_LEFT",
		left =         "SCORE_LEFT",
		bottomLeft =   "SCORE_BOTTOM_LEFT",
		bottomMiddle = "SCORE_BOTTOM_MIDDLE",
		bottomRight =  "SCORE_BOTTOM_RIGHT",
		right =        "SCORE_RIGHT",
		topRight =     "SCORE_TOP_RIGHT",
		topMiddle =    "SCORE_TOP_MIDDLE",
		center =       "SCORE_CENTER"
	}
	
	local background = self:getChild("background")

	--total episode score box
	local scoreBoxLeft = BackgroundBox:new()
	scoreBoxLeft.name = "scoreBoxLeft"
	scoreBoxLeft.hanchor = "LEFT"
	scoreBoxLeft.vanchor = "BOTTOM"
	scoreBoxLeft.components = scoreComponents
	background:addChild(scoreBoxLeft)
	
	-- "SCORE" text in the score box
	local scoreText = ui.Image:new()
	scoreText.name = "scoreText"
	scoreText:setImage(self.scoreSprite)
	scoreText.hanchor = "HCENTER"
	scoreText.vanchor = "VCENTER"
	background:addChild(scoreText)
	
	-- actual total score number
	local score = ui.Text:new()
	score.name = "score"
	score.text = "0"
	score.font = "FONT_LS_SMALL"
	score.hanchor = "HCENTER"
	score.vanchor = "BOTTOM"
	background:addChild(score)
	
	--episode stars box
	local scoreBoxRight = BackgroundBox:new()
	scoreBoxRight.name = "scoreBoxRight"
	scoreBoxRight.hanchor = "RIGHT"
	scoreBoxRight.vanchor = "BOTTOM"
	scoreBoxRight.components = scoreComponents
	background:addChild(scoreBoxRight)
	
	--star image in the box
	local star = ui.Image:new()
	star.name = "star"
	star:setImage("LS_STAR_GOLD")
	background:addChild(star)
	
	--actual star count (out of maximum)
	local starCounter = ui.Text:new()
	starCounter.name = "starCounter"
	starCounter.text = ""
	starCounter.font = "FONT_LS_SMALL"
	starCounter.hanchor = "HCENTER"
	starCounter.vanchor = "BOTTOM"
	background:addChild(starCounter)
	
	--<gamecenter>
	--gamecenter rank indicator on the left side of the button
	if gameCenterSupported or (not releaseBuild and iOS) then
		local meterBG = ui.Image:new()
		meterBG.name = "meterBG"
		meterBG:setImage("GLOBAL_METER_BG")
		meterBG:setVisible(false)
		self:addChild(meterBG)
		
		local meterIndicator = ui.Image:new()
		meterIndicator.name = "meterIndicator"
		meterIndicator:setImage("GLOBAL_METER_INDICATOR")
		meterBG:setVisible(false)
		meterBG:addChild(meterIndicator)
	end
	--</gamecenter>
	
	local lock = ui.Image:new()
	lock.name = "lock"
	lock:setImage("LS_LEVEL_PACK_LOCK")
	lock:setVisible(false)
	self:addChild(lock)
end

function EpisodeButton:setEpisode(id, episode)
	
	local featherBox = self:getChild("featherBox")
	featherBox.components =
	{
		left =         "EPISODE" .. id .. "_LEFT",
		center =       "EPISODE" .. id .. "_CENTER",
		right =        "EPISODE" .. id .. "_RIGHT",
		bottomLeft =   "EPISODE" .. id .. "_BOTTOM_LEFT",
		bottomMiddle = "EPISODE" .. id .. "_BOTTOM_MIDDLE",
		bottomRight =  "EPISODE" .. id .. "_BOTTOM_RIGHT"
	}
	
	EpisodeButtonBase.setEpisode(self, id, episode)
end

function EpisodeButton:onEntry()
	
	local stars, total_stars = calculateEpisodeStars(self.episode)
	local starCounter = self:getChild("starCounter")
	starCounter.text = stars .. "/" .. total_stars
	
	local total_score = calculateEpisodeScore(self.episode)
	local score = self:getChild("score")
	score.text = _G.string.format("%d", total_score)
	
	local feathers, total_feathers = calculateFeatherScore(self.episode)
	local feather_score = self:getChild("featherScore")
	feather_score.text = feathers .. "/" .. total_feathers
	
	--<gamecenter>
	if gameCenterSupported or (not releaseBuild and iOS) then
		local meterBG = self:getChild("meterBG")
		meterBG:setVisible(gameCenterEnabled)
		local meterIndicator = meterBG:getChild("meterIndicator")
		meterIndicator:setVisible(gameCenterEnabled)
		self.gameCenterVisible = gameCenterEnabled
		
		self:setGameCenterIndicatorPositions()
	end
	--</gamecenter>

	EpisodeButtonBase.onEntry(self)
end

function EpisodeButton:layout()

	setFont(fontBasic)
	local fontHeight = _G.res.getFontHeight()
	setFont("FONT_LS_SMALL")
	local fontHeightSmall = _G.res.getFontHeight()
	
	local featherBox = self:getChild("featherBox")
	featherBox.y = self.height * 0.5 + fontHeightSmall * 0.8075
	featherBox.width = self.width * 0.35
	featherBox.height = fontHeightSmall * 0.85
	
	local background = self:getChild("background")

	--get positions of things for calculating the box position
	local _, topEdgeY = _G.res.getSpriteBounds(background.components.topMiddle)
	local scoreWidth, scoreHeight = _G.res.getSpriteBounds(self.scoreSprite)
	local starWidth, starHeight = _G.res.getSpriteBounds("LS_STAR_GOLD")
	
	local feather = self:getChild("feather")
	local featherScore = self:getChild("featherScore")
	
	local featherWidth, _ = _G.res.getSpriteBounds(feather.image)
	local featherPivotX, _ = _G.res.getSpritePivot(feather.image)
	local featherScoreWidth = _G.res.getStringWidth(featherScore.text)
	
	setFont(featherScore.font)
	feather.x = featherBox.width * -0.5 + (featherBox.width - featherWidth - featherScoreWidth) * 0.5 + featherPivotX
	feather.y = _G.math.floor(featherBox.y + (featherBox.height + topEdgeY) * 0.475)
	featherScore.x = feather.x + featherScoreWidth * 0.5
	featherScore.y = feather.y
	
	--width of the first box, used to calculate remaining space for the right side box
	local scoreBoxWidth = _G.math.max(self.width / 2.25, scoreWidth)

	local scoreBoxLeft = background:getChild("scoreBoxLeft")
	scoreBoxLeft.x = -self.width * 0.5
	scoreBoxLeft.y = self.height * 0.5 + topEdgeY / 6
	scoreBoxLeft.width = scoreBoxWidth
	scoreBoxLeft.height = fontHeightSmall + starHeight
	
	local scoreText = background:getChild("scoreText")
	scoreText.x = _G.math.floor(scoreBoxLeft.x + scoreBoxLeft.width * 0.5)
	scoreText.y = _G.math.floor(scoreBoxLeft.y - 0.8 * scoreBoxLeft.height)
	
	local score = background:getChild("score")
	score.x = _G.math.floor(self.width * -0.5 + scoreBoxLeft.width * 0.5)
	score.y = _G.math.floor(scoreBoxLeft.y)
	
	local scoreBoxRight = background:getChild("scoreBoxRight")
	scoreBoxRight.x = self.width * 0.5
	scoreBoxRight.y = self.height * 0.5 + topEdgeY / 6
	scoreBoxRight.width = _G.math.min(self.width / 2.25, 2 * (self.width / 2.25) - scoreBoxWidth)
	scoreBoxRight.height = fontHeightSmall + starHeight
	
	local star = background:getChild("star")
	star.x = _G.math.floor(scoreBoxRight.x - scoreBoxRight.width * 0.5)
	star.y = _G.math.floor(scoreBoxRight.y -0.8 * scoreBoxRight.height)
	
	local starCounter = background:getChild("starCounter")
	starCounter.x = _G.math.floor(self.width * 0.5 - scoreBoxRight.width * 0.5)
	starCounter.y = _G.math.floor(scoreBoxRight.y)

	--<gamecenter>
	if gameCenterSupported or (not releaseBuild and iOS) then
		local episodeBorderWidth, _ = _G.res.getSpriteBounds(background.components.left)
	
		local meterBG = self:getChild("meterBG")
		local meterWidth, meterHeight = _G.res.getSpriteBounds(meterBG.image)
		local meterPivotX, meterPivotY = _G.res.getSpritePivot(meterBG.image)
		
		meterBG.x = _G.math.floor(-self.width * 0.5 - episodeBorderWidth * 0.6)
		meterBG.y = _G.math.floor(meterPivotY - meterHeight * 0.5)
		
		local meterIndicator = meterBG:getChild("meterIndicator")
	end
	--</gamecenter>
	
	local lock = self:getChild("lock")
	lock:setVisible(self.locked)
	
	EpisodeButtonBase.layout(self)
end

--<gamecenter>
function EpisodeButton:setGameCenterIndicatorPositions()

	if not gameCenterEnabled or not gameCenter then
		print("<gamecenter> indicator: gc not enabled\n")
		return
	end
	
	if not gameCenter.leaderboards or not leaderboards then
		print("<gamecenter> indicator: leaderboards not loaded\n")
	end
	
	local leaderBoardName = getLeaderboardNameForEpisode(self.episode)
	local leaderBoardID = leaderboards[leaderBoardName]
	
	if not leaderBoardName or not leaderBoardID then
		print("<gamecenter> indicator: couldn't get leaderboard or leaderboard name (name=" .. _G.tostring(leaderBoardName) .. "\n")
		return
	end
	
	if not gameCenter.leaderboards[leaderBoardID] or gameCenter.leaderboards[leaderBoardID].loading then
		print("<gamecenter> indicator: leaderboard doesn't exist or is still loading\n")
		return
	end
	
	local leaderboard = gameCenter.leaderboards[leaderBoardID]
	if leaderboard.localRank and leaderboard.range then
		local local_rank = leaderboard.localRank
		local range = leaderboard.range
		
		--calculate position along the meter
		local pos_in_meter = 0
		if local_rank > 0 then
			if range > 1 then
				pos_in_meter = (local_rank - 1) / (range - 1)
			else
				pos_in_meter = 0
			end
		end
		
		local meterBG = self:getChild("meterBG")
		local _, meterHeight = _G.res.getSpriteBounds(meterBG.image)
		
		local meterIndicator = meterBG:getChild("meterIndicator")
		--cap to bottom of the indicator if the player is beyond the range
		meterIndicator.y = _G.math.min(meterHeight * -0.645 + meterHeight * 0.645 * pos_in_meter, 0)
	else
		print("<gamecenter> indicator: no leaderboard rank\n")
	end
end
--</gamecenter>

GoldenEggButton = EpisodeButtonBase:new()

function GoldenEggButton:init()

	EpisodeButtonBase.init(self)
	
	local background = self:getChild("background")
	
	local egg_left = ui.Image:new()
	egg_left.name = "eggLeft"
	egg_left:setImage("EPISODEG_EGG")
	background:addChild(egg_left)
	
	local egg_right = ui.Image:new()
	egg_right.name = "eggRight"
	egg_right:setImage("EPISODEG_EGG")
	background:addChild(egg_right)

--						{name = "epGScoreBox", box = scoreBox, hanchor = "HCENTER", vanchor = "BOTTOM"},
--						{name = "epGStar", sprite = "EPISODEG_STAR"},

	local score_box = BackgroundBox:new()
	score_box.name = "scoreBox"
	score_box.hanchor = "HCENTER"
	score_box.vanchor = "BOTTOM"
	score_box.components =
	{
		topLeft =      "SCORE_TOP_LEFT",
		left =         "SCORE_LEFT",
		bottomLeft =   "SCORE_BOTTOM_LEFT",
		bottomMiddle = "SCORE_BOTTOM_MIDDLE",
		bottomRight =  "SCORE_BOTTOM_RIGHT",
		right =        "SCORE_RIGHT",
		topRight =     "SCORE_TOP_RIGHT",
		topMiddle =    "SCORE_TOP_MIDDLE",
		center =       "SCORE_CENTER"
	}
	self:addChild(score_box)
	
	local star = ui.Image:new()
	star.name = "star"
	star:setImage("EPISODEG_STAR")
	score_box:addChild(star)
	
	local score = ui.Text:new()
	score.name = "score"
	score.text = ""
	score.font = "FONT_LS_SMALL"
	score.hanchor = "HCENTER"
	score.vanchor = "BASELINE"
	score_box:addChild(score)

end

function GoldenEggButton:onEntry()
	local background = self:getChild("background")
	local score_box = self:getChild("scoreBox")
	local score = score_box:getChild("score")
	score.text = "" .. calculateStarsFromGoldenEggLevels()

	EpisodeButtonBase.onEntry(self)
end

function GoldenEggButton:layout()

	EpisodeButtonBase.layout(self)
	
	local background = self:getChild("background")
	
	--background:getChild("episodeIcon").y = -0.05 * self.height

	local egg_left = background:getChild("eggLeft")
	egg_left.x = _G.math.floor(-self.width / 2.1)
	egg_left.y = _G.math.floor(-self.height / 2.05)

	local egg_right = background:getChild("eggRight")
	egg_right.x = _G.math.floor(self.width / 2.1)
	egg_right.y = _G.math.floor(-self.height / 2.05)
	
	setFont("FONT_LS_SMALL")
	local fontHeightSmall = _G.res.getFontHeight()
	local _, starHeight = _G.res.getSpriteBounds("LS_STAR_GOLD")
	local _, iconHeight = _G.res.getSpriteBounds(background:getChild("episodeIcon").image)
	local _, topEdgeY = _G.res.getSpriteBounds(background.components.topMiddle)
	
	local score_box = self:getChild("scoreBox")
	score_box.y = self.height * 0.5 + topEdgeY / 6
	score_box.width = self.width / 4.5
	score_box.height = fontHeightSmall + starHeight
	
	local star = score_box:getChild("star")
	star.y = score_box.height * -0.5 - fontHeightSmall * 0.125
	
	local score = score_box:getChild("score")
	score.y = score_box.height * -0.5 - fontHeightSmall * 0.125
end

filename="episode_selection.lua"
