------------
--Page-class
------------
Page = {}
    
function Page:new(o)
	o = o or {}
	o.items = {}
	o.order = {}
	_G.setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

function Page:init()
-- Overridden in classes that inherit this but needs to be declared here.
end

function Page:insertItem(key, item, pushback)
	
	self:setItemDefaults(item)
	
	if not pushback then
		_G.table.insert(self.order, key)
		self.items[key] = item
	else
		local index = self:getIndexOfItem(pushback)
		if index then
			_G.table.insert(self.order, index, key)
			self.items[key] = item
		end
	end	
end

function Page:removeItem(key)
	local index = self:getIndexOfItem(key)
	if index then
		_G.table.remove(self.order, index)
		for i, v in _G.ipairs(self.items) do
			if v == self.items.key then
				_G.table.remove(self.items, i)
				return
			end
		end
	end
end

function Page:setItemDefaults(item)
	
	item.x, item.y = item.x or 0, item.y or 0
	
	if item.sprite then
		item.sheet = item.sheet or self.sheet
	elseif item.text then
		item.font = item.font or self.font or defaultMenuFont
	end
	
	if item.renderState then
		item.xs = item.xs or 1
		item.ys = item.ys or 1
		item.angle = item.angle or 0
		if item.useSpritePivot and item.sprite then
			item.pivotX, item.pivotY = _G.res.getSpritePivot(item.sheet, item.sprite)
		else
			item.pivotX, item.pivotY = item.pivotX or 0, item.pivotY or 0
		end
	end
end

function Page:getIndexOfItem(name)
	for i = 1, #self.order do
		if self.order[i] == name then
			return i
		end
	end
	return false
end

function Page:getActivatedItems()
	local activatedItems = {}
	local activatedItemsTouchData = {}
	for k, v in _G.pairs(touches) do
		for key, value in _G.pairs(self.items) do
			if value.visible ~= false and value.selectable ~= false 
			  and value:checkBounds(v.x, v.y) then
				if #activatedItems == 0 or #activatedItems >= 1 and activatedItems[1] ~= key then
					_G.table.insert(activatedItems, key)
					activatedItemsTouchData[key] = k
				end
			end
		end
	end
	if #activatedItems >= 1 then
		return activatedItems, activatedItemsTouchData
	else
		return false
	end
end

function Page:getHoveredItems()
	local hoveredItems = {}
	for key, value in _G.pairs(self.items) do
		if value.visible ~= false and value.selectable ~= false 
		  and value:checkBounds(cursor.x, cursor.y) then
			if #hoveredItems == 0 or #hoveredItems >= 1 and hoveredItems[1] ~= key then
				_G.table.insert(hoveredItems, key)
			end
		end
	end

	if #hoveredItems >= 1 then
		return hoveredItems
	else
		return false
	end
end	


function Page:checkClicks()
	-- TODO: selectionCandidate functionality for overlapping sprites, texts and/or touch areas.
	-- Needs to take pivot and anchor into account.

	for k, v in _G.pairs(self.items) do
		if v.visible ~= false and v.selectable ~= false 
		 and (v.activateOnRelease ~= true and keyPressed["LBUTTON"] or v.activateOnRelease and keyReleased["LBUTTON"])
		 and v:checkBounds(cursor.x, cursor.y) then 
			if v.action then
				for key, value in _G.pairs(v.action) do
					key(value)
				end
			end
			return v
		end
	end
	return false
end


function Page:getClickedItem()
	-- TODO: selectionCandidate functionality for overlapping sprites, texts and/or touch areas.
	-- Needs to take pivot and anchor into account.

	for k, v in _G.pairs(self.items) do
		if v.visible ~= false and v.selectable ~= false 
		 and (v.activateOnRelease ~= true and keyPressed["LBUTTON"] or v.activateOnRelease and keyReleased["LBUTTON"])
		 and v:checkBounds(cursor.x, cursor.y) then 
			return v
		end
	end
	return false
end

function Page:draw()
	for i = 1, #self.order do
		local item = self.items[self.order[i]]
		if item.visible ~= false then
			item:draw()
		end
	end
end

------------
--Item-class
------------
Item = {}
    
function Item:new(o)
	o = o or {}
	o.x, o.y = o.x or 0, o.y or 0
	_G.setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

function Item:init()
end

function Item:checkBounds(xCoord, yCoord)
	if self.h == nil or self.w == nil then
		return false -- Height and width for click area must be set.
	else
		return yCoord >= self.y and yCoord <= self.y + self.h and
			xCoord >= self.x and xCoord <= self.x + self.w
	end
end



----------------------------------
--RectItem-class, inherits Item
----------------------------------

RectItem = Item:new()

function RectItem:init()
	self.red = self.red or 0
	self.green = self.green or 0
	self.blue = self.blue or 0
	self.alpha = self.alpha or 0
	self.x1 = self.x1 or 0
	self.x2 = self.x2 or screenWidth
	self.y1 = self.y1 or 0
	self.y2 = self.y2 or screenHeight
	self.inWorld = self.inWorld or false
end
					  
function RectItem:draw()
	if self.renderState then
		setRenderState(-screen.left, -screen.top, worldScale, worldScale, 0, 0, 0)
	end
	drawRect(self.red, self.green, self.blue, self.alpha, self.x1, self.y1, self.x2, self.y2, self.inWorld)
	setRenderState(0, 0, 1, 1, 0, 0, 0)
end

----------------------------------
--SpriteItem-class, inherits Item
----------------------------------

SpriteItem = Item:new()

function SpriteItem:checkBounds(xCoord, yCoord)

	if self.clickArea ~= nil then	   
		return xCoord >= self.clickArea.xLeft and xCoord <= self.clickArea.xRight and
			   yCoord >= self.clickArea.yTop and yCoord <= self.clickArea.yBot
	end
	self.sheet = self.sheet or ""
	local width, height = _G.res.getSpriteBounds(self.sheet, self.sprite)
	local pivotX, pivotY = _G.res.getSpritePivot(self.sheet, self.sprite)
	
	if self.renderState then
		local scaleCorrectionX, scaleCorrectionY = 0, 0
		local xs, ys = self.xs or 1, self.ys or 1
		if self.scale ~= nil then
			xs, ys = self.scale, self.scale
		end
		if xs ~= 1 then
			scaleCorrectionX = ((width * xs) - width) / 2
		end
		if ys ~= 1 then
			scaleCorrectionY = ((height * ys) - height) / 2
		end

		return yCoord >= (self.y - pivotY - scaleCorrectionY) and yCoord <= (self.y - pivotY + height + scaleCorrectionY)
			and xCoord >= (self.x - pivotX - scaleCorrectionX) and xCoord <= (self.x - pivotX + width + scaleCorrectionX)
	elseif self.inWorld then
		local scaleCorrectionX, scaleCorrectionY = 0, 0
		local xs, ys = self.xs or 1, self.ys or 1
		if self.scale ~= nil then
			xs, ys = self.scale, self.scale
		end
		worldScale = worldScale or 1
		--if xs > 1 then
			scaleCorrectionX = ((width * xs * worldScale) - width) / 2
		--end
		--if ys > 1 then
			scaleCorrectionY = ((height * ys * worldScale) - height) / 2
		--end
	
		local tmpx, tmpy = physicsToScreenTransform(self.x, self.y)	
		return yCoord >= (tmpy - pivotY - scaleCorrectionY) and yCoord <= (tmpy - pivotY + height + scaleCorrectionY)
			and xCoord >= (tmpx - pivotX - scaleCorrectionX) and xCoord <= (tmpx - pivotX + width + scaleCorrectionX)
	end
	
	return yCoord >= (self.y - pivotY) and yCoord <= (self.y - pivotY + height) and
		xCoord >= (self.x - pivotX) and xCoord <= (self.x - pivotX + width)
end

function SpriteItem:draw()
	if self.renderState then

		local xCoord, yCoord = self.x, self.y
		local xs, ys = self.xs or 1, self.ys or 1
		local angle = self.angle or 0
		local px, py = self.pivotX or 0, self.pivotY or 0
		if xs ~= 1 then
			xCoord =  xCoord / xs
		end
		if ys ~= 1 then
			yCoord = yCoord / ys
		end
		setRenderState(0, 0, xs, ys, angle, px, py)
		if self.drawToScreenSize then
			local sw, sh = _G.res.getSpriteBounds(self.sheet, self.sprite)
			local aspect = sw / sh
			local width = screenHeight * aspect
			local px, py = _G.res.getSpritePivot(self.sheet, self.sprite)
			
			_G.res.drawSprite(self.sheet, self.sprite, 0, 0, "LEFT", "TOP", screenWidth, screenHeight)
		else
			_G.res.drawSprite(self.sheet, self.sprite, _G.math.floor(xCoord), _G.math.floor(yCoord))
		end
		setRenderState(0, 0, 1, 1, 0, 0, 0)
	else
		_G.res.drawSprite(self.sheet, self.sprite, self.x, self.y)
	end
end

-------------------------------
--TextItem-class, inherits Item
-------------------------------

TextItem = Item:new({text = "", group = "TEXTS_BASIC", textBoxSize = screenWidth, hanchor = "HCENTER", vanchor = "VCENTER"})

function TextItem:init()
	self.text = self.text or ""
	self.group = self.group or "TEXTS_BASIC"
	self.textBoxSize = self.textBoxSize or screenWidth
	self.hanchor = self.hanchor or "HCENTER"
	self.vanchor = self.vanchor or "VCENTER"

	self.width = _G.res.getStringWidth(_G.res.getString(self.group, self.text))
end

function TextItem:clip()
	setFont(self.font)
	clipText(self.group, self.text, self.textBoxSize)
	local fl = _G.res.getFontLeading()
	self.textBlockHeight = #clippedText.lines * fl
	self.widestLine = clippedText.widestLine
	self.lines = {}
	
	local k = 1
	local yCorrection = 0
	if self.vanchor == "VCENTER" then
		yCorrection = (-self.textBlockHeight / 2) + (fl / 2)
	elseif self.vanchor == "BOTTOM" then
		yCorrection = -self.textBlockHeight + fl
	end
	while  k <= #clippedText.lines do
		local l = clippedText.lines[k]
		local tmpItm = TextItem:new({font = self.font, text = l, x = self.x, y = self.y + yCorrection, hanchor = self.hanchor, vanchor = self.vanchor})
		_G.table.insert(self.lines, tmpItm)
		k = k + 1
		yCorrection = yCorrection + fl
	end
	self.clipped = true
end

function TextItem:checkBounds(xCoord, yCoord)
	local w = _G.res.getStringWidth(_G.res.getString(self.group, self.text))
	if w > self.width then
		self.width = w
	end
	
	if self.clipped then
		for i = 1, #self.lines do
			if self.lines[i]:checkBounds(xCoord, yCoord) then
				return true
			end
		end
	else	
		local fl = _G.res.getFontLeading()
		local xCorrection, yCorrection = 0, 0
		if self.hanchor == "HCENTER" then
			xCorrection = -self.width / 2
		elseif self.hanchor == "RIGHT" then
			xCorrection = -self.width
		elseif self.hanchor == "LEFT" then
			xCorrection = 0
		end

		if self.vanchor == "VCENTER" then
			yCorrection = -fl / 2
		elseif self.vanchor == "BOTTOM" then
			yCorrection = -fl
		elseif self.vanchor == "TOP" then
			yCorrection = 0
		end
	
		return yCoord >= self.y + yCorrection and yCoord <= self.y + yCorrection + fl and
			xCoord >= self.x + xCorrection and xCoord <= self.x + xCorrection + self.width
	end
end

function TextItem:draw()
	if self.visible ~= false then

		setFont(self.font)
		if self.clipped then
			for i = 1, #self.lines do
				self.lines[i]:draw()
			end
		else
			_G.res.drawString(self.group, self.text, self.x, self.y, self.hanchor, self.vanchor )
		end
	end
end

--------------------------------
--AccordionPage-class, inherits Page
--------------------------------

AccordionPage = Page:new()

function AccordionPage:init()
	self.name = "AccordionPage"
	self.sheet = ""
	
	self.bellowsW, self.bellowsH = _G.res.getSpriteBounds("","ACCO_MID")
	self.bellowsPX, self.bellowsPY = _G.res.getSpritePivot("","ACCO_MID")
	self.grandpaW, self.grandpaH = _G.res.getSpriteBounds("","PIGLETTE_GRANDPA_01")
	
	self.rightHandleW, self.rightHandleH = _G.res.getSpriteBounds("","ACCO_RIGHT")
	self.cursorData = { x = 0, y = 0, speedX = 0, speedY = 0}
	self.handleCursorData = {x = 1, y = 1}
	self.cursorReleased = true
	self.activeButton = nil
	
	self.ripCount = 0
	self.levelComplete = false
	self.resetRipStatus = false
	self.ripTimer = 0
	
	self.currentVolumeLeft = 0
	self.currentVolumeRight = 0
	self.isPlaying = false
	self.direction = "left"
	self.timerVolume = 0
	self.currentTrack = 5
	
	self.grandpaTimer = 0
	self.grandpaIsActive = true
	
	self:insertItem("background", SpriteItem:new( { sheet = "", sprite = "GOLDEN_EGG_BG_1", selectable = false, x = screenWidth/2, y = screenHeight/2, renderState = true, drawToScreenSize = true } ))
	
	-- Accordion
	self:insertItem("accordionBellowsBroken", SpriteItem:new( { sheet = "", sprite = "ACCO_MID_BROKEN", visible = false, selectable = false, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2 } ))
	self:insertItem("accordionBellows", SpriteItem:new( { sheet = "", sprite = "ACCO_MID", selectable = false, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2, renderState = true, xs = (self.bellowsW / 2 + self.bellowsW / 4) / (self.bellowsW - self.bellowsPX) , ys = 1 } ))
	self:insertItem("accordionLHandle", SpriteItem:new( { sheet = "", sprite = "ACCO_LEFT", selectable = false, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2 } ))
	self:insertItem("accordionRHandle", SpriteItem:new( { sheet = "", sprite = "ACCO_RIGHT", selectable = true, x = screenWidth/2 + self.bellowsW / 4, y = screenHeight/2 } ))
	
	-- Buttons
	self:insertItem("accButton1", SpriteItem:new( { sheet = "", sprite = "ACCO_BTN_UP_1", spriteOn = "ACCO_BTN_DOWN_1", spriteOff = "ACCO_BTN_UP_1", selectable = true, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2, sound = "cminor" } ))
	self:insertItem("accButton2", SpriteItem:new( { sheet = "", sprite = "ACCO_BTN_UP_2", spriteOn = "ACCO_BTN_DOWN_2", spriteOff = "ACCO_BTN_UP_2", selectable = true, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2, sound = "dismajor" } ))
	self:insertItem("accButton3", SpriteItem:new( { sheet = "", sprite = "ACCO_BTN_UP_3", spriteOn = "ACCO_BTN_DOWN_3", spriteOff = "ACCO_BTN_UP_3", selectable = true, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2, sound = "fmajor" } ))
	self:insertItem("accButton4", SpriteItem:new( { sheet = "", sprite = "ACCO_BTN_UP_4", spriteOn = "ACCO_BTN_DOWN_4", spriteOff = "ACCO_BTN_UP_4", selectable = true, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2, sound = "gminor" } ))
	self:insertItem("accButton5", SpriteItem:new( { sheet = "", sprite = "ACCO_BTN_UP_5", spriteOn = "ACCO_BTN_DOWN_5", spriteOff = "ACCO_BTN_UP_5", selectable = true, x = screenWidth/2 - self.bellowsW / 2.5, y = screenHeight/2, sound = "bmajor" } ))
	
	-- Grandpa
	local grandpaScale = 0.75 * screenWidth / 480
	if grandpaScale > 1.5 then
		grandpaScale = 1.5
	end
	self:insertItem("birdShadow", SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_SHADOW", x = screenWidth - self.grandpaW * grandpaScale / 1.75, y = screenHeight - self.grandpaH * grandpaScale / 7, selectable = false}))
	self:insertItem("grandpa", SpriteItem:new( { sheet = "", sprite = "PIGLETTE_GRANDPA_01", selectable = true, x = screenWidth - self.grandpaW * grandpaScale / 1.75, y = screenHeight - self.grandpaH * grandpaScale / 1.75, xs = grandpaScale, ys = grandpaScale, renderState = true } ))
	
	-- Back Button
	self:insertItem("back", SpriteItem:new( {sheet = "BUTTONS_SHEET_1", sprite = "LS_BACK_BUTTON", y = screenHeight, selectable = false, activateOnRelease = true } ))
end

function AccordionPage:update(dt)
	_G.res.setTrackVolume(0, 7)
	if cursor.x > (self.items["accordionLHandle"].x + self.bellowsW * 1.2) and self.accordionIsActive == true and touchcount >= 1 then
		self.accordionIsActive = true
		self:play(-dt, self.direction, self.activeButton, dt)
		
	else
		self.accordionIsActive = false
	end
	
	if self.levelCompleted ~= true then
		if touchcount >= 1 then
			--print("touches: ".. touchcount .."\n")
			self.activatedItems, self.activatedItemsTouchData = self:getActivatedItems()
			
			if self.activatedItems then
				for k, v in _G.pairs(self.activatedItems) do
					
					if v == "accordionRHandle" and self.cursorData.x ~= 0 and self.cursorData.y ~= 0 then
						
						if self.handleCursorData.x ~= touches[self.activatedItemsTouchData[v]].x then
							self.handleCursorData = touches[self.activatedItemsTouchData[v]]						
							self:updateBellows(self.handleCursorData.x)
							local currentDirection = self.direction
						
							if self.handleCursorData.x - self.cursorData.x > 2 then
								currentDirection = "right"
							elseif self.handleCursorData.x - self.cursorData.x < -2 then
								currentDirection = "left"
							end
							
							if self.direction ~= currentDirection then
								if currentDirection == "right" then
									self.currentTrack = 6
									self.currentVolumeRight = self.currentVolumeLeft
									self.currentVolumeLeft = 0
									_G.res.setTrackVolume(self.currentVolumeRight, 6)
									_G.res.setTrackVolume(0, 5)
								else
									self.currentTrack = 5
									self.currentVolumeLeft = self.currentVolumeRight
									self.currentVolumeRight = 0
									_G.res.setTrackVolume(0, 6)
									_G.res.setTrackVolume(self.currentVolumeLeft, 5)
								end
								--print("changing direction")
								if self.grandpaIsActive == true then
									if self.items["grandpa"].sprite == "PIGLETTE_GRANDPA_01" then
										self.items["grandpa"].sprite = "PIGLETTE_GRANDPA_04_SMILE"
									else
										self.items["grandpa"].sprite = "PIGLETTE_GRANDPA_01"
									end
									_G.res.playAudio(getAudioName("pig_accordion"), 0.7, false, 0)
								end
								--self.isPlaying = false
								self.direction = currentDirection
							end
							
							self:play(_G.tonumber(_G.string.format("%.1f", self.cursorData.speedX)), self.direction, self.activeButton, dt)
							--self:updateGrandpa(dt)
						else
							self:play(-dt, self.direction, self.activeButton, dt)
						end

						self.accordionIsActive = true
					elseif v == "grandpa" and keyPressed["LBUTTON"] then
						self.grandpaIsActive = not self.grandpaIsActive
						if self.grandpaIsActive == false then
							self.items["grandpa"].sprite = "PIGLETTE_GRANDPA_01_BLINK"
						else
							self.items["grandpa"].sprite = "PIGLETTE_GRANDPA_01"
						end
					elseif _G.string.sub(v, 1, _G.string.len(v) - 1) == "accButton" and touchcount <= 2 then
						self:activateButton(self.items[v])
					end
				end
			self.cursorReleased = false
			end
			
			if self.items["accordionRHandle"].x >= (screenWidth/2 + self.bellowsW / 2.1) then
				self.ripTimer = self.ripTimer + dt
			else
				self.ripTimer = 0
			end
			
			if self.accordionIsActive == true and self.handleCursorData.x < (self.items["accordionLHandle"].x + self.bellowsW * 0.5) then
				self.resetRipStatus = false
			end
			self.cursorData.x = self.handleCursorData.x
			self.cursorData.y = self.handleCursorData.y
		else
			self.ripCount = 0
			self.ripTimer = 0
			self.cursorData.speedX = 0
			self.cursorReleased = true
		end
		
		if self.accordionIsActive ~= true then
			self:restoreBellows(dt)
		end
		
		if self.ripTimer >= 3 then
			_G.res.stopAllAudio()
			self.ripTimer = 0
			self.levelCompleted = true
			self.items["accordionBellowsBroken"].visible = true
			self.items["accordionBellows"].xs = 1
			self.items["accordionRHandle"].x = screenWidth / 2 + self.bellowsW / 2
			self:ripBellows()
		end
	else
		self:playRipAnimation(dt)
	end
	
end


function AccordionPage:playRipAnimation(dt)
	if self.items["accordionRHandle"].x <= (screenWidth * 2) then
		self.items["accordionRHandle"].x = self.items["accordionRHandle"].x + self.items["accordionRHandle"].x * 2*dt
		self.items["accordionBellows"].x = self.items["accordionBellows"].x + self.items["accordionRHandle"].x * 2*dt
	end
end

function AccordionPage:ripBellows()
	_G.res.playAudio(getAudioName("accordion_break"), 0.7, false, 0)
	goldenEggStarAchieved("ACCORDION")
end

function AccordionPage:updateBellows(posX)
	if posX > (self.items["accordionLHandle"].x + self.rightHandleW / 2 + self.bellowsPX) and posX <= (screenWidth/2 + self.bellowsW / 2 + self.rightHandleW / 2) then
								
		self.cursorData.speedX = (_G.math.abs((self.items["accordionRHandle"].x - (posX - self.rightHandleW / 2))) / (self.bellowsW / 20))
		if self.cursorData.speedX > 1 then
			self.cursorData.speedX = 1
		end
		
		self.items["accordionRHandle"].x = posX - self.rightHandleW / 2
		self.items["accordionBellows"].xs = (self.items["accordionRHandle"].x - self.items["accordionLHandle"].x) / (self.bellowsW - self.bellowsPX)
	end
	if self.items["accordionRHandle"].x > (screenWidth/2 + self.bellowsW / 2) then
		self.items["accordionRHandle"].x = screenWidth/2 + self.bellowsW / 2
		self.items["accordionBellows"].xs = (self.items["accordionRHandle"].x - self.items["accordionLHandle"].x) / (self.bellowsW - self.bellowsPX)
	end		
end

function AccordionPage:restoreBellows(dt)
	if self.items["accordionRHandle"].x < (screenWidth/2 + self.bellowsW / 4 ) then
		if self.isPlaying == true and self.direction ~= "right" then
			self.currentTrack = 6
			self.currentVolumeRight = self.currentVolumeLeft
			self.currentVolumeLeft = 0
			self.direction = "right"
			_G.res.setTrackVolume(self.currentVolumeRight, 6)
			_G.res.setTrackVolume(0, 5)
		end
		self.items["accordionRHandle"].x = self.items["accordionRHandle"].x + self.items["accordionRHandle"].x * dt
		
		if self.items["accordionRHandle"].x > (screenWidth/2 + self.bellowsW / 4) then
			self.items["accordionRHandle"].x = (screenWidth/2 + self.bellowsW / 4)
		end
		
		self.items["accordionBellows"].xs = (self.items["accordionRHandle"].x - self.items["accordionLHandle"].x) / (self.bellowsW - self.bellowsPX)
			
		self:play(-dt, self.direction, self.activeButton, dt)
	-- end
	elseif self.items["accordionRHandle"].x > (screenWidth/2 + self.bellowsW / 4 ) then
		if self.isPlaying == true and self.direction ~= "left" then
			self.currentTrack = 5
			self.currentVolumeLeft = self.currentVolumeRight
			self.currentVolumeRight = 0
			self.direction = "left"
			_G.res.setTrackVolume(self.currentVolumeLeft, 5)
			_G.res.setTrackVolume(0, 6)
		end
		self.items["accordionRHandle"].x = self.items["accordionRHandle"].x - self.items["accordionRHandle"].x * dt
		
		if self.items["accordionRHandle"].x < (screenWidth/2 + self.bellowsW / 4 ) then
			self.items["accordionRHandle"].x = (screenWidth/2 + self.bellowsW / 4 )
		end
		
		self.items["accordionBellows"].xs = (self.items["accordionRHandle"].x - self.items["accordionLHandle"].x) / (self.bellowsW - self.bellowsPX)
		
		self:play(-dt, self.direction, self.activeButton, dt)
	else
		self:play(-dt, self.direction, self.activeButton, dt)
		if self.grandpaIsActive == true then
			self.items["grandpa"].sprite = "PIGLETTE_GRANDPA_01"
		end
	end
end

function AccordionPage:activateButton(button)
	if button ~= self.activeButton  then
		_G.res.stopAllAudio()
		self.isPlaying = false
		self.activeButton = button
		for i = 1, 5 do
			if self.items["accButton"..i] == button then
				if self.items["accButton"..i].sprite == self.items["accButton"..i].spriteOff then
					self.items["accButton"..i].sprite = self.items["accButton"..i].spriteOn
				end
			else
				self.items["accButton"..i].sprite = self.items["accButton"..i].spriteOff
			end
		end
	end
end

function AccordionPage:play(volume, direction, activeButton, dt)
	if audioRampVolume then
		--_G.res.stopAllAudio()
		self.currentVolumeRight = 0
		self.currentVolumeLeft = 0
		self.isPlaying = false
		return
	end
	
	--volume = 0.5
	self.timerVolume = self.timerVolume + dt
	
	if self.timerVolume >= 0.03 then
		self.timerVolume = 0
		if self.currentTrack == 6 then
			if volume < 0 then
				if self.currentVolumeRight >= 0 then
					self.currentVolumeRight = self.currentVolumeRight + volume
				end
			else
				if (volume - self.currentVolumeRight) > 0.1 then
					self.currentVolumeRight = self.currentVolumeRight + 0.1
				elseif (volume - self.currentVolumeRight) < -0.1 then
					self.currentVolumeRight = self.currentVolumeRight - 0.1
				else
					self.currentVolumeRight = volume
				end
			end
			_G.res.setTrackVolume(self.currentVolumeRight, self.currentTrack)
		else
			if volume < 0 then
				if self.currentVolumeLeft >= 0 then
					self.currentVolumeLeft = self.currentVolumeLeft + volume
				end
			else
				if (volume - self.currentVolumeLeft) > 0.1 then
					self.currentVolumeLeft = self.currentVolumeLeft + 0.1
				elseif (volume - self.currentVolumeLeft) < -0.1 then
					self.currentVolumeLeft = self.currentVolumeLeft - 0.1
				else
					self.currentVolumeLeft = volume
				end
			end
			_G.res.setTrackVolume(self.currentVolumeLeft, self.currentTrack)
		end
		
		
	end		
	
	--if _G.res.isAudioPlaying(activeButton.sound.."_"..direction) == false then
		
		if self.isPlaying ~= true then
			_G.res.setTrackVolume(0, 5)
			_G.res.setTrackVolume(0, 6)
			--print(""..activeButton.sound.."_"..direction.." volumeRight: "..self.currentVolumeRight.." volumeLeft: "..self.currentVolumeLeft)
			if activeButton ~= nil then
				_G.res.playAudio(activeButton.sound.."_right", 1, true, 6)
				_G.res.playAudio(activeButton.sound.."_left", 1, true, 5)
			else
				_G.res.playAudio("empty_accordion_right", 1, true, 6)
				_G.res.playAudio("empty_accordion_left", 1, true, 5)
			end
			self.isPlaying = true
		end
end

--------------------------------
--SequencerPage-class, inherits Page
--------------------------------

SequencerPage = Page:new()

function SequencerPage:init()
	self.name = "SequencerPage"
	self.sheet = ""
	self.currentPosition = 0
	self.isPlaying = false
	self.timerTempo = 0
	self.currentTempo = 0.25
	self.timerPlayAnim = 0
	self.soundPlayed = false
	self.birdAnimationClockwise = true
	self.activatedItems = {}
	self.dragging = false
	self.birdStartDraggingX = 0
	self.maxTempo = false
	self.starAchieved = false
	
	self.barWidth, self.barHeight = _G.res.getSpriteBounds("", "SOUNDBOARD_4_BG")
	self.bfpw, bfph =  _G.res.getSpriteBounds("", "SOUNDBOARD_4_FOOTPRINT")
	
	local sw, sh = _G.res.getSpriteBounds("INGAME_BIRDS_1", "BIRD_BIG_BROTHER")

	local phw1, phh1 =  _G.res.getSpriteBounds("", "SOUNDBOARD_4_PIG_1")
	local phw2, phh2 =  _G.res.getSpriteBounds("", "SOUNDBOARD_4_PIG_1")
	local phw3, phh3 =  _G.res.getSpriteBounds("", "SOUNDBOARD_4_PIG_1")
	self.shw, self.shh =  _G.res.getSpriteBounds("", "SOUNDBOARD_4_HIGHLIGHT")
	
	self:insertItem("background", SpriteItem:new( { sheet = "", sprite = "GOLDEN_EGG_BG_1", selectable = false, x = screenWidth/2, y = screenHeight/2, renderState = true, drawToScreenSize = true } ))
	self:insertItem("sequencerBG", SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_BG", x = 0, y = screenHeight * 0.15, xs = screenWidth, selectable = false, renderState = true}))
	
	self:insertItem("sequencerHighlight", SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_HIGHLIGHT", x = ((66 * screenWidth) / 960) + (((66 * screenWidth) / 960) * 1.82 * self.currentPosition)  , y = screenHeight * 0.15, xs = 1.0, selectable = false, renderState = true}))
	
	
	local grassW, grassH = _G.res.getSpriteBounds("", "SOUNDBOARD_4_GRASS_TOP")
	local grassAmount = 0
	if grassW ~= 0 then
		grassAmount = _G.math.floor(screenWidth / grassW)
	end
	
	for i = 0, grassAmount do
		self:insertItem("grassTop"..i, SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_GRASS_TOP", x = i * grassW, y = screenHeight * 0.15, selectable = false}))
		self:insertItem("grassBottom"..i, SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_GRASS_BOTTOM", x = i * grassW, y = screenHeight * 0.15 + ((166 * self.barHeight) / 166), selectable = false}))
	end
	
	for i = 0, 7 do
		self:insertItem("pigLineOne_"..i+1, SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_PIG_1", spriteOn = "PIGLETTE_BIG_01", 
		spriteDefault = "SOUNDBOARD_4_PIG_1", spriteActive = "PIGLETTE_BIG_01_SMILE", spriteSleep = "PIGLETTE_BIG_01_BLINK", x = (i * screenWidth / 8) + ((23 * screenWidth) / 480) + ((10 * screenWidth) / 480), 
		y = (screenHeight * 0.15) + ((30 * self.barHeight) / 166) , selectable = true, renderState = true, xOns = 0.45 * phw1 / 42, yOns = 0.45 * phh1 / 44, xs = 1.0, ys = 1.0}))
		self:insertItem("pigLineTwo_"..i+1, SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_PIG_2", spriteOn = "PIGLETTE_HELMET_01", 
		spriteDefault = "SOUNDBOARD_4_PIG_2", spriteActive = "PIGLETTE_HELMET_01_SMILE", spriteSleep = "PIGLETTE_HELMET_01_BLINK", x = (i * screenWidth / 8) + ((23 * screenWidth) / 480) + ((10 * screenWidth) / 480), 
		y = (screenHeight * 0.15) + (((30 * self.barHeight) / 166) + ((50 * self.barHeight) / 166)) , selectable = true, renderState = true, xOns = 0.5 * phw2 / 46, yOns = 0.5 * phh2 / 44, xs = 1.0, ys = 1.0}))
		self:insertItem("pigLineThree_"..i+1, SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_PIG_3", spriteOn = "PIGLETTE_GRANDPA_01", 
		spriteDefault = "SOUNDBOARD_4_PIG_3", spriteActive = "PIGLETTE_GRANDPA_04_SMILE", spriteSleep = "PIGLETTE_GRANDPA_01_BLINK", x = (i * screenWidth / 8) + ((23 * screenWidth) / 480) + ((10 * screenWidth) / 480), 
		y = (screenHeight * 0.15) + (((30 * self.barHeight) / 166) + ((100 * self.barHeight) / 166)) , selectable = true, renderState = true, xOns = 0.45 * phw3 / 49, yOns = 0.45 * phh3 / 46, xs = 1.0, ys = 1.0}))
	end
	
	self:insertItem("birdFootprints", SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_FOOTPRINT", x = screenWidth / 2, y = screenHeight - (screenHeight * 0.16) + sh / 2.5, selectable = false}))
	self:insertItem("birdShadow", SpriteItem:new({ sheet = "", sprite = "SOUNDBOARD_4_SHADOW", x = screenWidth / 2, y = screenHeight - (screenHeight * 0.16) + sh / 2.5, selectable = false}))
	
	local birdScale = 1
	
	if screenWidth > 480 then
		birdScale = 1.5
	end
	
	self:insertItem("birdPlay", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_BIG_BROTHER_BLINK", spritePlay = "BIRD_BIG_BROTHER", 
	spritePressed = "BIRD_BIG_BROTHER_YELL", spriteDefault = "BIRD_BIG_BROTHER_BLINK", x = screenWidth / 2, y = screenHeight - (screenHeight * 0.16), renderState = true, 
	alwaysRender = true, angle = 0, pivotX = sw / 2, pivotY = sh, xs = birdScale, ys = birdScale} ))
	
	self:insertItem("back", SpriteItem:new( {sheet = "BUTTONS_SHEET_1", sprite = "LS_BACK_BUTTON", y = screenHeight, selectable = false, activateOnRelease = true } ))
end

function SequencerPage:update(dt)	
	
	if keyHold["LBUTTON"] then
		self.activatedItems = self:getActivatedItems()
		if self.activatedItems then
			for k, v in _G.pairs(self.activatedItems) do
				if v == "birdPlay" then
					local birdX = cursor.x
					if ( _G.math.abs(self.birdStartDraggingX - cursor.x) > 10) then
						if birdX < (self.items.birdFootprints.x - self.bfpw / 2) then
							birdX = self.items.birdFootprints.x - self.bfpw / 2
						elseif birdX > (self.items.birdFootprints.x + self.bfpw / 2) then
							birdX = self.items.birdFootprints.x + self.bfpw / 2
							self.maxTempo = true
						else
							self.maxTempo = false
						end
						self.items.birdShadow.x = birdX
						self.dragging = true
						self.items["birdPlay"].x = birdX
						self.currentTempo = 0.0007 * (self.items.birdFootprints.x + self.bfpw -  birdX ) 
					else
						self.dragging = false
					end
				end
			end
		end
	end
	
	if keyPressed["LBUTTON"]  then
		self.birdStartDraggingX = cursor.x
		self.activatedItems = self:getActivatedItems()
		self.dragging = false
	end
	
	if keyReleased["LBUTTON"] and not(self.dragging)  then		
		if self.activatedItems then
			for k, v in _G.pairs(self.activatedItems) do
				if v == "birdPlay" then
					self.isPlaying = not(self.isPlaying)
					if self.isPlaying then
					-- Wait 1 second to play the bird animation
						self.items["birdPlay"].sprite = self.items["birdPlay"].spritePressed
						_G.res.playAudio(getAudioName("big_brother_special_1"), 1.0, false, 0)
					else
						--_G.res.playAudio(getAudioName("big_brother_flying"), 1.0, false, 0)
						self.items["birdPlay"].sprite = self.items["birdPlay"].spriteDefault
						self.items["birdPlay"].angle = 0
						self.timerTempo = 0
						self.timerPlayAnim = 0
						self.currentPosition = 0
						self.items["sequencerHighlight"].x = ((66 * screenWidth) / 960) + (((66 * screenWidth) / 960) * 1.82 * self.currentPosition)
						for i = 1, 8 do
							if(self.items["pigLineOne_"..i].sprite == self.items["pigLineOne_"..i].spriteOn) or (self.items["pigLineOne_"..i].sprite == self.items["pigLineOne_"..i].spriteActive) then
								self.items["pigLineOne_"..i].sprite = self.items["pigLineOne_"..i].spriteSleep
							end
							if(self.items["pigLineTwo_"..i].sprite == self.items["pigLineTwo_"..i].spriteOn) or (self.items["pigLineTwo_"..i].sprite == self.items["pigLineTwo_"..i].spriteActive) then
								self.items["pigLineTwo_"..i].sprite = self.items["pigLineTwo_"..i].spriteSleep
							end
							if(self.items["pigLineThree_"..i].sprite == self.items["pigLineThree_"..i].spriteOn) or (self.items["pigLineThree_"..i].sprite == self.items["pigLineThree_"..i].spriteActive) then
								self.items["pigLineThree_"..i].sprite = self.items["pigLineThree_"..i].spriteSleep
							end
						end
					end
				else
					if (self.items[v].sprite == self.items[v].spriteDefault) and self.isPlaying then
						self.items[v].xs = self.items[v].xOns
						self.items[v].ys = self.items[v].yOns
						self.items[v].sprite = self.items[v].spriteOn				
					elseif (self.items[v].sprite == self.items[v].spriteDefault) and not(self.isPlaying) then
						self.items[v].xs = self.items[v].xOns
						self.items[v].ys = self.items[v].yOns
						self.items[v].sprite = self.items[v].spriteSleep
					else
						self.items[v].xs = 1.0
						self.items[v].ys = 1.0
						self.items[v].sprite = self.items[v].spriteDefault
					end
				end
			end
		end
	
	end
	if self.isPlaying then
		for i = 1, 8 do
			if(self.items["pigLineOne_"..i].sprite == self.items["pigLineOne_"..i].spriteSleep) then
				self.items["pigLineOne_"..i].sprite = self.items["pigLineOne_"..i].spriteOn
			end
			if(self.items["pigLineTwo_"..i].sprite == self.items["pigLineTwo_"..i].spriteSleep) then
				self.items["pigLineTwo_"..i].sprite = self.items["pigLineTwo_"..i].spriteOn
			end
			if(self.items["pigLineThree_"..i].sprite == self.items["pigLineThree_"..i].spriteSleep) then
				self.items["pigLineThree_"..i].sprite = self.items["pigLineThree_"..i].spriteOn
			end
		end
		self.timerPlayAnim = self.timerPlayAnim + dt
		if self.timerPlayAnim < 2.0 then
			self.timerPlayAnim = self.timerPlayAnim + dt
			return
		end
		self.items["birdPlay"].sprite = self.items["birdPlay"].spritePlay
		self:play(dt)
		self:playBirdAnimation(dt)
		self:checkComplete()
	end
end

function SequencerPage:checkComplete()
	local levelComplete = true
	
	for i = 1, 8 do
		levelComplete = levelComplete and (self.items["pigLineOne_"..i].sprite == self.items["pigLineOne_"..i].spriteOn)
		levelComplete = levelComplete and (self.items["pigLineTwo_"..i].sprite == self.items["pigLineTwo_"..i].spriteOn)
		levelComplete = levelComplete and (self.items["pigLineThree_"..i].sprite == self.items["pigLineThree_"..i].spriteOn)
	end
	
	if levelComplete and not(self.starAchieved) and self.maxTempo then
		self.isPlaying = false
		self.starAchieved = true
		self.items["birdPlay"].sprite = self.items["birdPlay"].spriteDefault
		self.items["birdPlay"].angle = 0
		self.timerTempo = 0
		self.timerPlayAnim = 0
		self.currentPosition = 0
		self.items["sequencerHighlight"].x = ((66 * screenWidth) / 960) + (((66 * screenWidth) / 960) * 1.82 * self.currentPosition)
		for i = 1, 8 do
			if(self.items["pigLineOne_"..i].sprite == self.items["pigLineOne_"..i].spriteOn) or (self.items["pigLineOne_"..i].sprite == self.items["pigLineOne_"..i].spriteActive) then
				self.items["pigLineOne_"..i].sprite = self.items["pigLineOne_"..i].spriteSleep
			end
			if(self.items["pigLineTwo_"..i].sprite == self.items["pigLineTwo_"..i].spriteOn) or (self.items["pigLineTwo_"..i].sprite == self.items["pigLineTwo_"..i].spriteActive) then
				self.items["pigLineTwo_"..i].sprite = self.items["pigLineTwo_"..i].spriteSleep
			end
			if(self.items["pigLineThree_"..i].sprite == self.items["pigLineThree_"..i].spriteOn) or (self.items["pigLineThree_"..i].sprite == self.items["pigLineThree_"..i].spriteActive) then
				self.items["pigLineThree_"..i].sprite = self.items["pigLineThree_"..i].spriteSleep
			end
		end
		goldenEggStarAchieved("SEQUENCER")
	end
end

function SequencerPage:playBirdAnimation(dt)
	
	if self.birdAnimationClockwise then
		if self.items["birdPlay"].angle < 0.1 then
			self.items["birdPlay"].angle = self.items["birdPlay"].angle + dt / (self.currentTempo * 6 )
		else
			self.birdAnimationClockwise = false
		end
	else
		if self.items["birdPlay"].angle > -0.1 then
			self.items["birdPlay"].angle = self.items["birdPlay"].angle - dt / (self.currentTempo * 6)
		else
			self.birdAnimationClockwise = true
		end
	end
end

function SequencerPage:play(dt)
	self.soundPlayed = false
	-- Start the sequencer
	if not(self.soundPlayed) then
		if(self.items["pigLineOne_"..self.currentPosition+1].sprite == "PIGLETTE_BIG_01") then
			_G.res.playAudio(getAudioName("pig_hi-hat_"..((self.currentPosition+1) % 2)+1), 1.0, false, 0)
			self.items["pigLineOne_"..self.currentPosition+1].sprite = self.items["pigLineOne_"..self.currentPosition+1].spriteActive
			self.items["pigLineOne_"..self.currentPosition+1].xs = self.items["pigLineOne_"..self.currentPosition+1].xOns
		end
		if(self.items["pigLineTwo_"..self.currentPosition+1].sprite == "PIGLETTE_HELMET_01") then
			_G.res.playAudio(getAudioName("pig_snare_"..((self.currentPosition+1) % 4)+1), 1.0, false, 0)
			self.items["pigLineTwo_"..self.currentPosition+1].sprite = self.items["pigLineTwo_"..self.currentPosition+1].spriteActive
			self.items["pigLineTwo_"..self.currentPosition+1].xs = self.items["pigLineTwo_"..self.currentPosition+1].xOns
		end
		if(self.items["pigLineThree_"..self.currentPosition+1].sprite == "PIGLETTE_GRANDPA_01") then
			_G.res.playAudio(getAudioName("pig_bd"), 1.0, false, 0)			
			self.items["pigLineThree_"..self.currentPosition+1].sprite = self.items["pigLineThree_"..self.currentPosition+1].spriteActive
			self.items["pigLineThree_"..self.currentPosition+1].xs = self.items["pigLineThree_"..self.currentPosition+1].xOns
		end
		self.soundPlayed = true
	end
	
	self.timerTempo = self.timerTempo + dt
	if self.timerTempo >= self.currentTempo then
		self.timerTempo = 0
		self.soundPlayed = false
		
		if(self.items["pigLineOne_"..self.currentPosition+1].sprite == self.items["pigLineOne_"..self.currentPosition+1].spriteActive) then
			self.items["pigLineOne_"..self.currentPosition+1].sprite = self.items["pigLineOne_"..self.currentPosition+1].spriteOn
		end
		if(self.items["pigLineTwo_"..self.currentPosition+1].sprite == self.items["pigLineTwo_"..self.currentPosition+1].spriteActive) then
			self.items["pigLineTwo_"..self.currentPosition+1].sprite = self.items["pigLineTwo_"..self.currentPosition+1].spriteOn
		end
		if(self.items["pigLineThree_"..self.currentPosition+1].sprite == self.items["pigLineThree_"..self.currentPosition+1].spriteActive) then
			self.items["pigLineThree_"..self.currentPosition+1].sprite = self.items["pigLineThree_"..self.currentPosition+1].spriteOn
		end
		
		self.currentPosition = self.currentPosition + 1
		
		if self.currentPosition > 7 then
			self.currentPosition = 0
		end
		self.items["sequencerHighlight"].x = ((66 * screenWidth) / 960) + (((66 * screenWidth) / 960) * 1.82 * self.currentPosition)
	end
end

--------------------------------
--KeyboardPage-class, inherits Page
--------------------------------

KeyboardPage = Page:new()

function KeyboardPage:init()
	self.name = "Keyboardpage"
	self.sheet = ""
	self.notesPlayed = ""
	self.notes = { C = {}, Cis = {}, D = {}, dis = {}, E = {}, F = {}, Fis = {}, G = {} }
	for k, v in _G.pairs(self.notes) do
		v.pressed = false
		v.playIDs = {nil, nil, nil}
		v.playCounter = 0
	end
	
	self.rightMelody = "CDdisCG"
	self.wholeMelody = "CDdCGGGFddDC"
	self.melodyPauses = { 0.5, 0.1875, 0.1875, 0.375, 0.375, 0.6, 0.375, 0.15, 0.225, 0.375, 0.15, 0.225 }
	self.melodyIndex = 1
	self.currentSound = "noteG"
	self.starCollected = highscores["KEYBOARD"] and highscores["KEYBOARD"].completed
	self.sessionStarCollected = false
	self.playMelody = false
	
	local boundingBoxWidth = screenWidth
	local boundingBoxHeight = screenHeight
	self.scale = screenHeight / 320
	
	if self.scale > 1.4 then
		self.scale = 1.4
	end
	
	if boundingBoxWidth > 640 then
		boundingBoxWidth = 640
	end
	
	if boundingBoxHeight > 480 then
		boundingBoxHeight = 480
	end
	
	local CY, CisY, DY, DisY, EY, FY, FisY, GY = 221 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												132 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												218 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												132 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												218 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												215 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												134 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2),
												222 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2)
	
	local rbW, rbH = _G.res.getSpriteBounds("INGAME_BIRDS_1","BIRD_RED")
	local bbW, bbH = _G.res.getSpriteBounds("INGAME_BIRDS_1","BIRD_BLUE")
	local ybW, ybH = _G.res.getSpriteBounds("INGAME_BIRDS_1","BIRD_YELLOW")
	local gbW, gbH = _G.res.getSpriteBounds("INGAME_BIRDS_1","BIRD_GREY")
	local pbW, pbH = _G.res.getSpriteBounds("INGAME_BIRDS_1","BIRD_BOOMERANG")
	local wbW, wbH = _G.res.getSpriteBounds("INGAME_BIRDS_1","BIRD_GREEN")
	
	self:insertItem("background", SpriteItem:new( { sheet = "", sprite = "GOLDEN_EGG_BG_1", selectable = false, x = screenWidth/2, y = screenHeight/2, renderState = true, drawToScreenSize = true } ))
	self:insertItem("shadow1", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 72 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = CisY + gbH / 2.75 * self.scale, selectable = false, xs = scale, ys = scale, renderState = true} ))
	self:insertItem("shadow2", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 168 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = DisY + gbH / 2.75 * self.scale, selectable = false, selectable = false, xs = self.scale, ys = self.scale, renderState = true } ))
	self:insertItem("shadow3", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 390 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = FisY + gbH / 2.75 * self.scale, selectable = false, selectable = false, xs = self.scale, ys = self.scale, renderState = true } ))
	self:insertItem("shadow4", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 41 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = CY + bbH / 2.75 * self.scale, selectable = false, renderState = true, xs = 0.5 * self.scale, ys = 0.5 * self.scale} ))
	self:insertItem("shadow5", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 122 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = DY + rbH / 2.75 * self.scale, selectable = false, renderState = true, xs = 0.65 * self.scale, ys = 0.65 * self.scale} ))
	self:insertItem("shadow6", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 212 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = EY + ybH / 2.75 * self.scale, selectable = false, renderState = true, xs = 0.9 * self.scale, ys = 0.9 * self.scale} ))
	self:insertItem("shadow7", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 315 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = FY + wbH / 2.75 * self.scale, selectable = false, selectable = false, xs = self.scale, ys = self.scale, renderState = true } ))
	self:insertItem("shadow8", SpriteItem:new( { sprite = "SOUNDBOARD_3_SHADOW", x = 420 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = GY + pbH / 2.5 * self.scale, selectable = false, renderState = true, xs = 0.85 * self.scale, ys = 0.85 * self.scale} ))
	self:insertItem("C", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_BLUE", sprite2 = "BIRD_BLUE_YELL", defaultSprite = "BIRD_BLUE", x = 39 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = CY, defaultY = 221 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	self:insertItem("Cis", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_GREY", sprite2 = "BIRD_GREY_YELL", defaultSprite = "BIRD_GREY", x = 72 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = CisY, defaultY = 132 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	self:insertItem("D", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_RED", sprite2 = "BIRD_RED_YELL", defaultSprite = "BIRD_RED", x = 123 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = DY, defaultY = 218 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale}))
	self:insertItem("dis", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_GREY_BLINK", sprite2 = "BIRD_GREY_YELL", defaultSprite = "BIRD_GREY_BLINK", x = 168 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = DisY, defaultY = 132 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	self:insertItem("E", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_YELLOW", sprite2 = "BIRD_YELLOW_YELL", defaultSprite = "BIRD_YELLOW", x = 212 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = EY, defaultY = 218 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	self:insertItem("F", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_GREEN", sprite2 = "BIRD_GREEN_YELL", defaultSprite = "BIRD_GREEN", x = 315 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = FY, defaultY = 215 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	self:insertItem("Fis", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_GREY_FLYING", sprite2 = "BIRD_GREY_YELL", defaultSprite = "BIRD_GREY_FLYING", x = 392 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = FisY, defaultY = 134 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	self:insertItem("G", SpriteItem:new( { sheet = "INGAME_BIRDS_1", sprite = "BIRD_BOOMERANG", sprite2 = "BIRD_BOOMERANG_YELL", defaultSprite = "BIRD_BOOMERANG", x = 434 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), y = GY, defaultY = 222 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = self.scale, ys = self.scale} ))
	
	self.items.C.clickArea = {xLeft = 10 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), xRight = 70 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), yBot = 241 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), yTop = 185 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = scale, ys = scale}
	self.items.D.clickArea = {xLeft = 77 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), xRight = 160 * (boundingBoxWidth / 480) + ((screenWidth - boundingBoxWidth) / 2), yBot = 250 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), yTop = 175 * (boundingBoxHeight / 320)+ ((screenHeight - boundingBoxHeight) / 2), renderState = true, xs = scale, ys = scale}

	
	self:insertItem("back", SpriteItem:new( {sheet = "BUTTONS_SHEET_1", sprite = "LS_BACK_BUTTON", y = screenHeight, selectable = false, activateOnRelease = true } ))
end


function KeyboardPage:update(dt)
	
	if self.playMelody then
		return self:play(dt)
	end
	
	if popupPage then
		return
	end
	
	if not settingsWrapper:isAudioEnabled() then
		_G.res.stopAllAudio()
	end
	
	for k, v in _G.pairs(self.notes) do
		for i = 1, 3 do
			if self.notes[k].playIDs[i] ~= nil and not _G.res.isAudioPlaying(self.notes[k].playIDs[i]) then
				self.notes[k].playIDs[i] = nil
				self.notes[k].playCounter = self.notes[k].playCounter - 1
			end
		end
	end
	
	local restore = false
	if touchcount >= 1 then
		-- Touches need to be checked with default bird sprites or sound might loop with
		-- certain cursor positions.
		local keysWithYellSprite = {}
		local tmpYs
		for k, v in _G.pairs(self.items) do
			if v.defaultSprite and v.sprite ~= v.defaultSprite then
				_G.table.insert(keysWithYellSprite, {key = k, y = v.y})
				v.sprite, v.sprite2 = v.sprite2, v.sprite
				v.y = v.defaultY
				if v.alwaysRender then
					tmpYs = v.ys
					v.ys = v.defaultYs
				end
			end
		end
		local activatedItems = self:getActivatedItems()
		-- Restore yell sprites.
		for k, v in _G.pairs(keysWithYellSprite) do
			local _, h = _G.res.getSpriteBounds(self.items[v.key].sheet, self.items[v.key].sprite)
			self.items[v.key].sprite, self.items[v.key].sprite2 = self.items[v.key].sprite2, self.items[v.key].sprite
			self.items[v.key].y = v.y
			if self.items[v.key].alwaysRender then
				self.items[v.key].ys = tmpYs	
			end
		end
	
		if activatedItems then
			for k, v in _G.pairs(activatedItems) do
				self.notes[v].activated = true
			end
			
			for key, value in _G.pairs(self.notes) do	
				if value.pressed and not value.activated then
					self:restoreKey(key)
				end
				local sound = "note" .. key
				if not value.pressed and value.activated then 
					if self.notes[key].playCounter <= 3 then
						self:pressKey(key)
						local c = _G.res.playAudio(sound, 1.0, false, 0)
						for i = 1, 3 do
							if self.notes[key].playIDs[i] == nil then
								self.notes[key].playIDs[i] = c
								self.notes[key].playCounter = self.notes[key].playCounter + 1
								break
							end
						end
						if not self.sessionStarCollected then
							self.notesPlayed = self.notesPlayed .. key	
						end	
					end
				end
				value.activated = false 
			end
		else
			restore = true
		end
	else
		restore = true
	end

	if restore then
		for k, v in _G.pairs(self.notes) do
			self:restoreKey(k)
		end
	end

	if _G.string.sub(self.rightMelody, 1, #self.notesPlayed) ~= self.notesPlayed then
		-- Check if new correct melody was started.
		if _G.string.sub(self.notesPlayed, #self.notesPlayed) == "C" then
			self.notesPlayed = "C"
		elseif _G.string.sub(self.notesPlayed, #self.notesPlayed - 1, #self.notesPlayed) == "CD" then
			self.notesPlayed = "CD"
		else
			self.notesPlayed = ""
		end
	elseif self.notesPlayed == self.rightMelody then
		self.notesPlayed = ""
		self.playMelody = true
	end
	
end

function KeyboardPage:play(dt)
	self.melodyPauses[self.melodyIndex] = self.melodyPauses[self.melodyIndex] - dt
	if self.melodyPauses[self.melodyIndex] > 0 then
		return
	else
		self:restoreKey(_G.string.sub(self.currentSound, 5, #self.currentSound))
		local key = _G.string.sub(self.wholeMelody, self.melodyIndex, self.melodyIndex)
		if key == "d" then
			key = key .. "is"
		end	
		self:pressKey(key)
		self.currentSound = "note" .. key
		_G.res.playAudio(self.currentSound, 1.0, false, 0)
		self.melodyIndex = self.melodyIndex + 1
		
		if self.melodyIndex > #self.wholeMelody then
			self.playMelody = false
			goldenEggStarAchieved("KEYBOARD")
			self.sessionStarCollected = true
		end
	end
end

function KeyboardPage:restoreKey(k)
	if self.notes[k].pressed then
		self.items[k].ys = self.scale
		self.items[k].y = self.items[k].defaultY
		if not self.items[k].alwaysRender then
			--self.items[k].renderState = false
		end
		if self.items[k].sprite ~= self.items[k].defaultSprite then
			self.items[k].sprite, self.items[k].sprite2 = self.items[k].sprite2, self.items[k].sprite
		end
		self.notes[k].pressed = false
	end
end

function KeyboardPage:pressKey(key)
	self.notes[key].pressed = true
	local item = self.items[key] 
	item.renderState = true
	local _, h = _G.res.getSpriteBounds(item.sheet, item.sprite)
	if item.alwaysRender and item.defaultYs then
		item.ys = item.ys * 0.85 * self.scale
		item.y = _G.math.floor(item.y + ((h * item.defaultYs - (h * item.ys)) / 2))
	else
		item.ys = 0.85 * self.scale
		item.y = _G.math.floor(item.y + ((h - (h * 0.85)) / 2))
	end
	self.items[key].sprite, self.items[key].sprite2 = self.items[key].sprite2, self.items[key].sprite
end


function drawPictureLevel(page)
	
	for i, v in _G.ipairs(page.items) do
		
		local xCoord = v.x or 0
		local yCoord = v.y or 0
		local sheet = v.sheet or page.defaultSheet or ""
	
		if v.name == "wheel" then
			local w, h = _G.res.getSpriteBounds(sheet, v.sprite)
			setRenderState(0, 0, 1, 1, v.angle, w / 2, h / 2)
			_G.res.drawSprite(sheet, v.sprite, xCoord, yCoord)
			setRenderState(0, 0, 1, 1, 0)
		elseif v.name == "bird" then
			local tmpWidth, tmpHeight = _G.res.getSpriteBounds(sheet, v.sprite)
			setRenderState(0, 0, 1, 1, v.angle, tmpWidth / 2, tmpHeight)
			_G.res.drawSprite(sheet, v.sprite, xCoord, yCoord)
			setRenderState(0, 0, 1, 1, 0)
		else
			if i == 1 then -- background
				_G.res.drawSprite(sheet, v.sprite, xCoord - screenWidth / 2, yCoord - screenHeight / 2, "TOP", "LEFT", screenWidth, screenHeight)
			else
				_G.res.drawSprite(sheet, v.sprite, xCoord, yCoord)
			end
		end
	end
	_G.res.drawSprite("BUTTONS_SHEET_1", "LS_BACK_BUTTON", 0, screenHeight)

end


function initSoundboard()
	_G.res.stopAudio(currentMainMenuSong)
	
	if currentSoundboard == "KEYBOARD" then
		keyboardPage = KeyboardPage:new()
		--print("FlurryEventWithParam: Golden egg level started, param: Level, paramValue: " .. goldenEggLevelMapping["Level12"] .. "\n")
		logFlurryEventWithParam("Golden egg level started", "Level", "KEYBOARD") 
	elseif currentSoundboard == "SEQUENCER" then
		sequencerPage = SequencerPage:new()	
		setGameOn(true) -- disable screen saver
	elseif currentSoundboard == "ACCORDION" then
		accordionPage = AccordionPage:new()	
		setGameOn(true) -- disable screen saver
	elseif currentSoundboard == "SOUNDBOARD1" then
		soundPage = { starEffect = false, 
				  starTimer = 0,
				  starAngle = 0,
				  items = {}
				}
		soundPage.state = 0
		soundPage.currentBird = 0
		soundPage.starState = 0
		soundPage.buttonPressTimes = {}
		soundPage.sessionStarCollected = false
		
		for i = 1, 16 do
			soundPage.buttonPressTimes[i] = 0
		end
		
		local boundingBox = { maxWidth = 1024, maxHeight = 768, left = 0, top = 0, width = screenWidth, height = screenHeight }
		
		if screenWidth > boundingBox.maxWidth then
			boundingBox.left = (screenWidth / 2) - (boundingBox.maxWidth / 2)
			boundingBox.width = boundingBox.maxWidth
		end
		
		if screenHeight > boundingBox.maxHeight then
			boundingBox.top = (screenHeight / 2) - (boundingBox.maxHeight / 2)
			boundingBox.height = boundingBox.maxHeight
		end
		
		
		_G.table.insert(soundPage.items, { sheet = "", sprite = "GOLDEN_EGG_BG_2", x = screenWidth / 2, y = screenHeight / 2})
		soundPage.defaultSheet = ""
		
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_BLOCK_ICE", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.89), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.50625)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_BLOCK_WOOD", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.78), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.5075)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_BLOCK_STONE", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.67), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.5049)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_TNT", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.52), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.5)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_SLINGSHOT", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.34), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.5)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_PIG_KING", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.89), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.82)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_PIG_OLD", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.68), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.82)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_PIG_HELMET", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.48), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.85)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_PIG_SMALL", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.305), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.88)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_LEVEL_FAIL", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.17), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.6460)})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_1_LEVEL_START", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.15), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.34)})
		_G.table.insert(soundPage.items, { sprite = "SOUNDBOARD_1_BIRD_WHITE", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.89), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.1837) })
		_G.table.insert(soundPage.items, { sprite = "SOUNDBOARD_1_BIRD_BLACK", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.7), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.1807) })
		_G.table.insert(soundPage.items, { sprite = "SOUNDBOARD_1_BIRD_YELLOW", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.52), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.16107) })
		_G.table.insert(soundPage.items, { sprite = "SOUNDBOARD_1_BIRD_RED", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.36), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.1415) })
		_G.table.insert(soundPage.items, { sprite = "SOUNDBOARD_1_BIRD_BLUE", x = _G.math.floor(boundingBox.left + boundingBox.width * 0.23), y = _G.math.floor(boundingBox.top + boundingBox.height * 0.13) })
		
		--print("FlurryEventWithParam: Golden egg level started, param: Level, paramValue: " .. goldenEggLevelMapping["Level4"] .. "\n")
		logFlurryEventWithParam("Golden egg level started", "Level", "SOUNDBOARD1") 
				
	elseif currentSoundboard == "RADIO" then
		soundPage = { starEffect = false, 
				  starTimer = 0,
				  starAngle = 0,
				  items = {}
				}
		
		soundPage.dragStartCursorX = 0
		soundPage.dragTouchId = -1
		soundPage.dragging = false
		soundPage.animating = false
		soundPage.animatingTo = 0
		soundPage.delayedButtonSound = false
		soundPage.birdDanceY = 0
		soundPage.dragAngle = 0
		soundPage.musicPlaying = false
		soundPage.musicStartedWhenMuted = false
		soundPage.sessionStarCollected = false
		soundPage.buttonPressed = false
		soundPage.oldSwitches = {}
		soundPage.radioSwitches = {0, 0, 0, 0}
		soundPage.wheelDivider = 23 * (screenHeight / 320)
	
		soundPage.defaultSheet = ""
		_G.table.insert(soundPage.items, {sheet = "", sprite = "GOLDEN_EGG_BG_1", x = screenWidth / 2, y = screenHeight / 2})
		_G.table.insert(soundPage.items, {name = "radio", sprite = "SOUNDBOARD_2_RADIO", x = screenWidth / 2, y = screenHeight / 2})
		
		local rx, ry = _G.res.getSpritePivot("", "SOUNDBOARD_2_RADIO")
		local sw, sh = _G.res.getSpriteBounds("", "SOUNDBOARD_2_RADIO")
		local radioLeft = -rx + getItemByName(soundPage.items, "radio").x
		local radioTop = -ry + getItemByName(soundPage.items, "radio").y
		
		_G.table.insert(soundPage.items, {name = "birdShadow", sprite = "SOUNDBOARD_2_BIRD_SHADOW", x = screenWidth / 2, y = screenHeight / 2})
		_G.table.insert(soundPage.items, {name = "wheel", sprite = "SOUNDBOARD_2_WHEEL", x = screenWidth / 2, y = screenHeight / 2, angle = 0})
		_G.table.insert(soundPage.items, {sprite = "SOUNDBOARD_2_LCD", x = screenWidth / 2, y = screenHeight / 2})
		_G.table.insert(soundPage.items, {name = "indicator", sprite = "SOUNDBOARD_2_INDICATOR", x = radioLeft + (sw * 0.383), y = radioTop + (sh * 0.42)})	
		for i = 1, 4 do
			_G.table.insert(soundPage.items, {name = "preset" .. i, sprite = "SOUNDBOARD_2_BUTTON_DOWN_" .. i, x = screenWidth / 2, y = screenHeight / 2})
		end
		_G.table.insert(soundPage.items, {name = "bird", sprite = "SOUNDBOARD_2_BIRD",  angle = 0})
		local bird = getItemByName(soundPage.items, "bird")
		local birdShadow = getItemByName(soundPage.items, "birdShadow")
		local bw, bh = _G.res.getSpriteBounds("", bird.sprite)
		local bsw, bsh = _G.res.getSpriteBounds("", birdShadow.sprite)
		bird.x = radioLeft + sw - bw / 2.5
		bird.y = radioTop + sh - bh / 2.5
		
		
		birdShadow.x = radioLeft + sw - bw / 2.5
		birdShadow.y = radioTop + sh + bsh / 2
		
		soundPage.indicatorX, soundPage.indicatorY = getItemByName(soundPage.items, "indicator").x, getItemByName(soundPage.items, "indicator").y
		soundPage.birdOriginalY = getItemByName(soundPage.items, "bird").y
		soundPage.presetCoords = { radioLeft + (sw * 0.383), radioLeft + (sw * 0.522), radioLeft + (sw * 0.667), radioLeft + (sw * 0.806), radioLeft + (sw * 0.736) }
		soundPage.defaultMultiplier = 300 * (sw / 599)	
		--print("FlurryEventWithParam: Golden egg level started, param: Level, paramValue: " .. goldenEggLevelMapping["Level7"] .. "\n")
		logFlurryEventWithParam("Golden egg level started", "Level", "RADIO") 
	
		setGameOn(true) -- disable screen saver
	end

end

function cursorOnSoundboardSprite(item)
	local px,py = _G.res.getSpritePivot("", item.sprite)
	local w, h = _G.res.getSpriteBounds("", item.sprite)
		
	return cursor.x > item.x - px and cursor.x < item.x - px + w and cursor.y > item.y - py and cursor.y < item.y - py + h	
end

function touchOnSoundboardSprite(sheet, sprite, touchid, x, y)
	local px,py = _G.res.getSpritePivot(sheet, sprite)
	local w, h = _G.res.getSpriteBounds(sheet, sprite)
	
	return touches[touchid].y >= ((screenHeight / 2) - py) and touches[touchid].y <= ((screenHeight / 2) - py + h)
		and touches[touchid].x >= ((screenWidth / 2) - px) and touches[touchid].x <= ((screenWidth / 2) - px + w)
	

	--return touches[touchid].x > -px and touches[touchid].x < -px + w and touches[touchid].y > -py and touches[touchid].y < -py + h
	
end

function drawSoundboardButton(sheet, sprite, pressed, x, y)
	
	local scale = 1
	if pressed == true then
		scale = 1.1
		setRenderState(0, 0, scale, scale, 0)
		local w, h = _G.res.getSpriteBounds(sheet, sprite)
		local px, py = _G.res.getSpritePivot(sheet, sprite)
		x = (x / scale) + (px - (w / 2)) * (1 - (1 / scale))
		y = (y / scale) + (py - (h / 2)) * (1 - (1 / scale))
	end
	
	_G.res.drawSprite(sheet, sprite, _G.math.floor(x), _G.math.floor(y))
	if pressed == true then
		setRenderState(0, 0, 1, 1, 0)
	end
end

function updateSoundboard(dt)
	
	if oldScreenWidth ~= screenWidth or oldScreenHeight ~= screenHeight then
		oldScreenWidth = screenWidth
		oldScreenHeight = screenHeight
		initSoundboard()
	end
	
	if popupPage ~= nil then
		updateMenuPage(popupPage, dt)
	end
	
	if currentSoundboard == "KEYBOARD" then
		keyboardPage:update(dt)
		keyboardPage:draw()
	elseif currentSoundboard == "SEQUENCER" then
		sequencerPage:update(dt)
		sequencerPage:draw()
	elseif currentSoundboard == "ACCORDION" then
		accordionPage:update(dt)
		accordionPage:draw()
	elseif currentSoundboard == "SOUNDBOARD1" then
		
		if keyPressed["LBUTTON"] and soundPage.starEffect == false and popupPage == nil then
			
			-- ice block
			if cursorOnSoundboardSprite(soundPage.items[2]) then
				soundPage.buttonPressTimes[1] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("light_destroyed"), 1.0, false, 0)
				else
					_G.res.playAudio(getAudioName("light_collision"), 1.0, false, 0)
					soundPage.starState = 0
					soundPage.state = 0
				end
			
			-- wood block
			elseif cursorOnSoundboardSprite(soundPage.items[3]) then
				soundPage.buttonPressTimes[2] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("wood_destroyed"), 1.0, false, 0)
				else
					_G.res.playAudio(getAudioName("wood_collision"), 1.0, false, 0)
					soundPage.starState = 0
					soundPage.state = 0
				end
			
			-- stone block
			elseif cursorOnSoundboardSprite(soundPage.items[4]) then
				soundPage.buttonPressTimes[3] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("rock_destroyed"), 1.0, false, 0)
				else
					_G.res.playAudio(getAudioName("rock_collision"), 1.0, false, 0)
					soundPage.starState = 0
					soundPage.state = 0
				end
			
			-- tnt box
			elseif cursorOnSoundboardSprite(soundPage.items[5]) then
				soundPage.buttonPressTimes[4] = time
				_G.res.playAudio(getAudioName("tnt_explodes"), 1.0, false, 0)
			
			-- slingshot
			elseif cursorOnSoundboardSprite(soundPage.items[6]) then
				soundPage.buttonPressTimes[5] = time
				soundPage.state = 1
				_G.res.playAudio(getAudioName("slingshot_stretched"), 1.0, false, 0)
				if soundPage.starState == 1 then
					soundPage.starState = 2
				else
					soundPage.starState = 0
				end
			
			-- king pig
			elseif cursorOnSoundboardSprite(soundPage.items[7]) then
				soundPage.buttonPressTimes[6] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("piglette_destroyed"), 1.0, false, 0)
					if soundPage.starState == 3 then
						soundPage.starState = 4
						soundPage.state = 0
					else
						soundPage.state = 0
						soundPage.starState = 0
					end
				else
					_G.res.playAudio(getAudioName("piglette"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
				end
				
			-- old pig
			elseif cursorOnSoundboardSprite(soundPage.items[8]) then
				soundPage.buttonPressTimes[7] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("piglette_destroyed"), 1.0, false, 0)
					if soundPage.starState == 3 then
						soundPage.starState = 4
						soundPage.state = 0
					else
						soundPage.state = 0
						soundPage.starState = 0
					end
				else
					_G.res.playAudio(getAudioName("piglette"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
				end
			
			-- helmet pig
			elseif cursorOnSoundboardSprite(soundPage.items[9]) then
				soundPage.buttonPressTimes[8] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("piglette_destroyed"), 1.0, false, 0)
					if soundPage.starState == 3 then
						soundPage.starState = 4
						soundPage.state = 0
					else
						soundPage.state = 0
						soundPage.starState = 0
					end
				else
					_G.res.playAudio(getAudioName("piglette"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
				end
			
			-- small pig
			elseif cursorOnSoundboardSprite(soundPage.items[10]) then
				soundPage.buttonPressTimes[9] = time
				if soundPage.state >= 2 then
					_G.res.playAudio(getAudioName("piglette_destroyed"), 1.0, false, 0)
					if soundPage.starState == 3 then
						soundPage.starState = 4
						soundPage.state = 0
					else
						soundPage.state = 0
						soundPage.starState = 0
					end
				else
					_G.res.playAudio(getAudioName("piglette"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
				end
			
			-- level fail
			elseif cursorOnSoundboardSprite(soundPage.items[11]) then
				soundPage.buttonPressTimes[10] = time
				for i = 1, #audioGroups["level_failed_piglets"] do
					if _G.res.isAudioPlaying(audioGroups["level_failed_piglets"][i]) then
						_G.res.stopAudio(audioGroups["level_failed_piglets"][i])
					end
				end				 
				_G.res.playAudio(getAudioName("level_failed_piglets"), 1.0, false, 0)
				soundPage.state = 0
				soundPage.starState = 0
			
			-- level start
			elseif cursorOnSoundboardSprite(soundPage.items[12]) then
				soundPage.buttonPressTimes[11] = time
				for i = 1, #audioGroups["level_start_military"] do
					if _G.res.isAudioPlaying(audioGroups["level_start_military"][i]) then
						_G.res.stopAudio(audioGroups["level_start_military"][i])
					end
				end
				_G.res.playAudio(getAudioName("level_start_military"), 1.0, false, 0)
				soundPage.state = 0
				soundPage.starState = 1
			
			-- white bird
			elseif cursorOnSoundboardSprite(soundPage.items[13]) then
				soundPage.buttonPressTimes[12] = time
				if soundPage.state == 1 then
					_G.res.playAudio(getAudioName("bird_05_flying"), 1.0, false, 0)
					soundPage.state = 2
					if soundPage.starState == 2 then
						soundPage.starState = 3
					else
						soundPage.starState = 0
					end
					soundPage.currentBird = 1
				elseif soundPage.state >= 2 then
					if soundPage.currentBird == 1 then
						if soundPage.state == 2 then
							_G.res.playAudio(getAudioName("special_egg"), 1.0, false, 0)
							soundPage.state = 3
						else
							_G.res.playAudio(getAudioName("bird_05_collision"), 1.0, false, 0)
						end
					else
						_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
						soundPage.state = 0
						soundPage.starState = 0
						soundPage.currentBird = 0
					end
				else
					_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
					soundPage.currentBird = 0
				end
			
			-- black bird
			elseif cursorOnSoundboardSprite(soundPage.items[14]) then
				soundPage.buttonPressTimes[13] = time
				if soundPage.state == 1 then
					_G.res.playAudio(getAudioName("bird_04_flying"), 1.0, false, 0)
					soundPage.state = 2
					if soundPage.starState == 2 then
						soundPage.starState = 3
					else
						soundPage.starState = 0
					end
					soundPage.currentBird = 2
				elseif soundPage.state >= 2 then
					if soundPage.currentBird == 2 then
						if soundPage.state == 2 then
							_G.res.playAudio(getAudioName("special_explosion"), 1.0, false, 0)
							soundPage.state = 3
						else
							_G.res.playAudio(getAudioName("bird_04_collision"), 1.0, false, 0)
						end
					else
						_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
						soundPage.state = 0
						soundPage.starState = 0
						soundPage.currentBird = 0
					end
				else
					_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
					soundPage.currentBird = 0
				end
			
			-- yellow bird
			elseif cursorOnSoundboardSprite(soundPage.items[15]) then
				soundPage.buttonPressTimes[14] = time
				if soundPage.state == 1 then
					_G.res.playAudio(getAudioName("bird_03_flying"), 1.0, false, 0)
					soundPage.state = 2
					if soundPage.starState == 2 then
						soundPage.starState = 3
					else
						soundPage.starState = 0
					end
					soundPage.currentBird = 3
				elseif soundPage.state >= 2 then
					if soundPage.currentBird == 3 then
						if soundPage.state == 2 then
							_G.res.playAudio(getAudioName("special_boost"), 1.0, false, 0)
							soundPage.state = 3
						else
							_G.res.playAudio(getAudioName("bird_03_collision"), 1.0, false, 0)
						end
					else
						_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
						soundPage.state = 0
						soundPage.starState = 0
						soundPage.currentBird = 0
					end
				else
					_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
					soundPage.currentBird = 0
				end
			
			-- red bird
			elseif cursorOnSoundboardSprite(soundPage.items[16]) then
				soundPage.buttonPressTimes[15] = time
				if soundPage.state == 1 then
					_G.res.playAudio(getAudioName("bird_01_flying"), 1.0, false, 0)
					soundPage.state = 2
					if soundPage.starState == 2 then
						soundPage.starState = 3
					else
						soundPage.starState = 0
					end
					soundPage.currentBird = 4
				elseif soundPage.state >= 2 then
					if soundPage.currentBird == 4 then
						if soundPage.state == 2 then
							_G.res.playAudio(getAudioName("red_special"), 1.0, false, 0)
							soundPage.state = 3
						else
							_G.res.playAudio(getAudioName("bird_01_collision"), 1.0, false, 0)
						end
					else
						_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
						soundPage.state = 0
						soundPage.starState = 0
						soundPage.currentBird = 0
					end
				else
					_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
					soundPage.currentBird = 0
				end
			
			-- blue bird
			elseif cursorOnSoundboardSprite(soundPage.items[17]) then
				soundPage.buttonPressTimes[16] = time
				if soundPage.state == 1 then
					_G.res.playAudio(getAudioName("bird_02_flying"), 1.0, false, 0)
					soundPage.state = 2
					if soundPage.starState == 2 then
						soundPage.starState = 3
					else
						soundPage.starState = 0
					end
					soundPage.currentBird = 5
				elseif soundPage.state >= 2 then
					if soundPage.currentBird == 5 then
						if soundPage.state == 2 then
							_G.res.playAudio(getAudioName("special_group"), 1.0, false, 0)
							soundPage.state = 3
						else
							_G.res.playAudio(getAudioName("bird_02_collision"), 1.0, false, 0)
						end
					else
						_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
						soundPage.state = 0
						soundPage.starState = 0
						soundPage.currentBird = 0
					end
				else
					_G.res.playAudio(getAudioName("bird_misc"), 1.0, false, 0)
					soundPage.state = 0
					soundPage.starState = 0
					soundPage.currentBird = 0
				end
			end
			
			if soundPage.starState == 4 then
				soundPage.state = 0
				soundPage.starState = 0
				soundPage.currentBird = 0
				if not soundPage.sessionStarCollected then
					goldenEggStarAchieved("SOUNDBOARD1")
					soundPage.sessionStarCollected = true
				end
			end
		end
		
		
	
		for i = 1, #soundPage.items do
			local sheet = soundPage.items[i].sheet or soundPage.defaultSheet
			if i >= 2 then
				drawSoundboardButton(sheet, soundPage.items[i].sprite, time - soundPage.buttonPressTimes[i - 1] < 0.2, soundPage.items[i].x, soundPage.items[i].y)
			else
				_G.res.drawSprite(sheet, soundPage.items[i].sprite, soundPage.items[i].x - screenWidth / 2, soundPage.items[i].y - screenHeight / 2,  "LEFT", "TOP", screenWidth, screenHeight)
			end
		end
		_G.res.drawSprite("BUTTONS_SHEET_1", "LS_BACK_BUTTON", 0, screenHeight)

		
	elseif currentSoundboard == "RADIO" then
	
		local tmpDeltaAngle = 0			
		if popupPage == nil then
			
			if touchcount == 2 or keyPressed["C"] then
		
				local tmpSwitches = {0, 0, 0, 0}
				
				for k, v in _G.pairs(touches) do
					for i = 1, 4 do
						if touchOnSoundboardSprite(soundPage.defaultSheet, "SOUNDBOARD_2_BUTTON_UP_" .. i, k) then
							tmpSwitches[i] = 1
						end
					end
				end
		
				if keyPressed["C"] then
					tmpSwitches = {1, 0, 1, 0}
				end
				
				for k, v in _G.pairs(tmpSwitches) do
					if soundPage.oldSwitches[k] ~= v then
						soundPage.buttonPressed = false
					end
					soundPage.oldSwitches[k] = v
				end
				
				local switchesDown = 0
				for i = 1, 4 do
					switchesDown = switchesDown + tmpSwitches[i]
				end
						
				if switchesDown == 2 then
					soundPage.radioSwitches = tmpSwitches
					if soundPage.upcomingTune ~= "funky_theme" then
						if soundPage.buttonPressed ~= true then
							_G.res.stopAllAudio()
							_G.res.playAudio("button_radio", 0.8, false)					
						end
						prepareRadioAnimation(soundPage.presetCoords[5], 0)
					end
					soundPage.dragTouchId = -1

					soundPage.buttonPressed = true
				end
			elseif keyPressed["LBUTTON"] then

				for i = 1, 4 do
					local itm = getItemByName(soundPage.items, "preset" .. i)
					itm.sprite = "SOUNDBOARD_2_BUTTON_UP_" .. i
					if soundPage.radioSwitches[i] == 0 and cursorOnSoundboardSprite(itm) then
						soundPage.radioSwitches = {0, 0, 0, 0}
						soundPage.radioSwitches[i] = 1	
						_G.res.stopAllAudio()
						_G.res.playAudio("button_radio", 1, false)
						soundPage.delayedButtonSound = false
						prepareRadioAnimation(soundPage.presetCoords[i], i)
						soundPage.buttonPressed = false
					end
				end			
				local px, py = _G.res.getSpritePivot(soundPage.defaultSheet, getItemByName(soundPage.items, "wheel").sprite)
				local w, h = _G.res.getSpriteBounds(soundPage.defaultSheet, getItemByName(soundPage.items, "wheel").sprite)
				local tmpDist = distance(-px + getItemByName(soundPage.items, "wheel").x + (w / 2), -py + getItemByName(soundPage.items, "wheel").y + (h / 2), cursor.x, cursor.y)
				
				if tmpDist < w * 2 then
					soundPage.dragAngle = _G.math.atan2((-py + getItemByName(soundPage.items, "wheel").y + (h / 2)- cursor.y), (-px + getItemByName(soundPage.items, "wheel").x + (w / 2) - cursor.x))
					soundPage.dragging = true
					soundPage.buttonPressed = false
				end
						
			elseif soundPage.dragging and keyHold["LBUTTON"] and touchcount == 1 then
				local px, py = _G.res.getSpritePivot(soundPage.defaultSheet, getItemByName(soundPage.items, "wheel").sprite)			
				local w, h = _G.res.getSpriteBounds(soundPage.defaultSheet, getItemByName(soundPage.items, "wheel").sprite)
				local tmpDist = distance(-px + getItemByName(soundPage.items, "wheel").x + (w / 2), -py + getItemByName(soundPage.items, "wheel").y + (h / 2), cursor.x, cursor.y)
				
				
				if tmpDist > w / 3 then 
					
					local tmpAngle = _G.math.atan2((-py + getItemByName(soundPage.items, "wheel").y  + (h / 2) - cursor.y), (-px + getItemByName(soundPage.items, "wheel").x + (w / 2) - cursor.x))
					if soundPage.dragAngle ~= nil then
						tmpDeltaAngle = tmpAngle - soundPage.dragAngle
						if tmpDeltaAngle >= _G.math.pi * 3/2 then
							tmpDeltaAngle = tmpDeltaAngle - _G.math.pi * 2
						elseif tmpDeltaAngle <= -_G.math.pi * 3/2 then
							tmpDeltaAngle = tmpDeltaAngle + _G.math.pi * 2
						end
						if _G.math.abs(tmpDeltaAngle) > 0 and soundPage.musicPlaying then
							_G.res.stopAllAudio()
							soundPage.musicPlaying = false
						end
						if _G.math.abs(tmpDeltaAngle) < _G.math.pi / 2 then
							soundPage.indicatorX = soundPage.indicatorX + tmpDeltaAngle * 12
							if soundPage.indicatorX < soundPage.presetCoords[1] then
								tmpDeltaAngle = 0
								soundPage.indicatorX = soundPage.presetCoords[1]
							elseif soundPage.indicatorX > soundPage.presetCoords[4] then
								tmpDeltaAngle = 0
								soundPage.indicatorX = soundPage.presetCoords[4]
							end
							getItemByName(soundPage.items, "wheel").angle = getItemByName(soundPage.items, "wheel").angle + tmpDeltaAngle
						end
					end
					soundPage.dragAngle = tmpAngle
				elseif tmpDist <= w / 2 then
					soundPage.dragAngle = nil
				end
		
			elseif keyReleased["LBUTTON"] and soundPage.dragging then	
				local shortDist, shortDistIndex = screenWidth, 0
				for i = 1, #soundPage.presetCoords do
					local tmpDist = _G.math.abs(soundPage.indicatorX - soundPage.presetCoords[i])
					if tmpDist < shortDist then
						shortDist = tmpDist
						shortDistIndex = i
					end
				end
							
				for i = 0, #soundPage.radioSwitches do
					soundPage.radioSwitches[i] = 0
				end
				soundPage.radioSwitches[shortDistIndex] = 1
				
				if shortDistIndex == 5 then 
					prepareRadioAnimation(soundPage.presetCoords[shortDistIndex], 0) -- funky station
					soundPage.radioSwitches = {1, 0, 1, 0}
				else
					prepareRadioAnimation(soundPage.presetCoords[shortDistIndex], shortDistIndex)
				end
				
				soundPage.dragging = false
				soundPage.delayedButtonSound = true
				
			elseif soundPage.animating then		
				updateSoundPageAnimation(dt)
			end
		end
		
		if soundPage.upcomingTune == "funky_theme" then
			soundPage.birdDanceY = (soundPage.birdDanceY + dt * 5) % _G.math.pi
			getItemByName(soundPage.items, "bird").angle = _G.math.sin(soundPage.birdDanceY) / 4
		elseif soundPage.birdDanceY > 0 then
			soundPage.birdDanceY = (soundPage.birdDanceY + dt * 5) 
			if soundPage.birdDanceY > _G.math.pi then
				soundPage.birdDanceY = 0
			end
			getItemByName(soundPage.items, "bird").angle = _G.math.sin(soundPage.birdDanceY) / 4
		end
	
		if soundPage.dragging ~= true then
			getItemByName(soundPage.items, "wheel").angle = (soundPage.indicatorX - soundPage.presetCoords[1]) / soundPage.wheelDivider
		end
		getItemByName(soundPage.items, "indicator").x = soundPage.indicatorX
		getItemByName(soundPage.items, "indicator").y = soundPage.indicatorY
		
		local _, birdHeight = _G.res.getSpriteBounds(soundPage.defaultSheet, getItemByName(soundPage.items, "bird").sprite)
		getItemByName(soundPage.items, "bird").y = soundPage.birdOriginalY - _G.math.sin(soundPage.birdDanceY) * birdHeight / 3
		
		for i = 1, 4 do
			local spriteName
			if soundPage.radioSwitches[i] == 1 then
				spriteName = "SOUNDBOARD_2_BUTTON_DOWN_" .. i
			else
				spriteName = "SOUNDBOARD_2_BUTTON_UP_" .. i
			end
			getItemByName(soundPage.items, "preset" .. i).sprite = spriteName
		end
		
		drawPictureLevel(soundPage)
		
	end
	
	_G.res.drawSprite("","MENU_SFX", 0, 0, "TOP", "LEFT")
	if not settingsWrapper:isAudioEnabled() then
		local pivotX, pivotY = _G.res.getSpritePivot("", "MENU_SFX")
		_G.res.drawSprite("","BUTTON_OFF", pivotX, pivotY)
	end
	if keyPressed["LBUTTON"] and popupPage == nil then
		local width, height = _G.res.getSpriteBounds("", "MENU_SFX")
		if cursor.x < width and cursor.y < height then
			changeAudio()
			if not settingsWrapper:isAudioEnabled() then
				if currentSoundboard ~= "RADIO" then
					_G.res.stopAllAudio()
				end
			elseif currentSoundboard == "RADIO" and soundPage.musicPlaying and soundPage.musicStartedWhenMuted then
				_G.res.playAudio(soundPage.upcomingTune, 0.8, true)
			end
		end
	end
	
	if audioRampVolume then
		audioRampVolume = audioRampVolume + (dt / audioRampLength)
		if audioRampVolume <= 0 then
			_G.res.stopAudioOutput()
			audioRampVolume = nil
		elseif audioRampVolume > 1 then
			audioRampVolume = nil
		else
			-- Use squared volume because it gives more linear response
			setMusicVolume( audioRampVolume * audioRampVolume )
			setEffectsVolume( audioRampVolume * audioRampVolume )
		end
	end
	
	if keyReleased["LBUTTON"] and popupPage == nil then
		local width, height = _G.res.getSpriteBounds("BUTTONS_SHEET_1", "LS_BACK_BUTTON")
		if currentSoundboard == "ACCORDION" then
			if cursor.y > (screenHeight - height * 0.7) and cursor.x < width then
				_G.res.stopAllAudio()
				--_G.res.setTrackVolume(1, 6)
				--_G.res.setTrackVolume(1, 7)
				setEffectsVolume(1)
				setMusicVolume(1)
				setGameOn(false) -- enable screen saver
				setGameMode(gotoLevelSelectionGoldenEggs)
			end
		else
			
			if cursor.y > (screenHeight - height) and cursor.x < width then
				_G.res.stopAllAudio()
				setGameOn(false) -- enable screen saver
				setGameMode(gotoLevelSelectionGoldenEggs)
			end
		end
	end
	
	if popupPage ~= nil then
		drawMenuPage(popupPage)
		return
	end
end

function prepareRadioAnimation(target, index)
	
	soundPage.animatingTo = target
	soundPage.animating = true
	
	if soundPage.animatingTo < soundPage.indicatorX then
		soundPage.animationMultiplier = -soundPage.defaultMultiplier
	else
		soundPage.animationMultiplier = soundPage.defaultMultiplier
	end
	
	if index == 0 then
		soundPage.upcomingTune = "funky_theme"
	elseif index == 1 then
		soundPage.upcomingTune = "title_theme"
	else
		local tmpIndex = index - 1
		soundPage.upcomingTune = "ambient_theme" .. tmpIndex
	end

end

function updateSoundPageAnimation(dt)
	
	soundPage.indicatorX = soundPage.indicatorX + dt * soundPage.animationMultiplier
				
	if (soundPage.indicatorX >= soundPage.animatingTo and soundPage.animationMultiplier > 0)
		or (soundPage.indicatorX <= soundPage.animatingTo and soundPage.animationMultiplier < 0) then
		
		if soundPage.delayedButtonSound then
			soundPage.delayedButtonSound = false
			_G.res.stopAllAudio()
			_G.res.playAudio("button_radio", 1, false)
		end
					
		soundPage.animating = false
		soundPage.indicatorX = soundPage.animatingTo
		if soundPage.upcomingTune == "funky_theme" then
			if not soundPage.sessionStarCollected then
				goldenEggStarAchieved("RADIO")
				soundPage.sessionStarCollected = true
			end
		end
					
		_G.res.playAudio(soundPage.upcomingTune, 0.8, true)
		soundPage.musicPlaying = true
		if settingsWrapper:isAudioEnabled() then
			soundPage.musicStartedWhenMuted = nil
		else
			soundPage.musicStartedWhenMuted = true
		end
	end

end


filename="soundboards.lua"
