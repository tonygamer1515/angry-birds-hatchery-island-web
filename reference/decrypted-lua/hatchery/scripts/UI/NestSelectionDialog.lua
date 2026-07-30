NestSelectionDialog = ui.Frame:new()
Frame = ui.Frame

function NestSelectionDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_BIG_TEMP")
	self:addChild(background)
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_OK")
	cancelButton.returnValue = "CANCEL"
	self:addChild(cancelButton)
	cancelButton.sound = getHatcherySound("cancel")
	cancelButton.activateOnRelease = true
	
	
	self.lastClickedButton = nil
	
end

function NestSelectionDialog:setNests(nests)
	self.nests = nests
	self.lastClickedButton = nil	
	
	for k,v in _G.pairs(self.nests) do 
		local existingNestButtonBg = self:getChild("nestButtonBg" .. v:getType())
		local existingNestButton = self:getChild(v:getType())
		local existingStarImage = self:getChild("star_" .. v:getType())
		local existingStarText = self:getChild("starText_" .. v:getType())
		local existingLock = self:getChild("nestLock" .. v:getType())
		
		if existingLock ~= nil then
			self:removeChild(existingLock)
		end
		
		if existingNestButtonBg ~= nil then
			self:removeChild(existingNestButtonBg)
		end
		
		if existingNestButton ~= nil then
			self:removeChild(existingNestButton)
		end
		
		if existingStarImage ~= nil then
			self:removeChild(existingStarImage)
		end
		
		if existingStarText ~= nil then
			self:removeChild(existingStarText)
		end
	
		local nestButtonBg = ui.ScallableButton:new()
		nestButtonBg.name = "nestButtonBg" .. v:getType()
		nestButtonBg:setImage("H_BUY_NEST_BG")
		nestButtonBg.returnValue = "BUY"
		nestButtonBg.nest = v
		self:addChild(nestButtonBg)
		nestButtonBg.activateOnRelease = true
	
		local nestButton = ui.ScallableButton:new()
		nestButton.name = v:getType()
		nestButton:setImage(v:getSprites().shop)
		nestButton.scaleX = 0.38
		nestButton.scaleY = 0.38
		nestButton.returnValue = "BUY"
		nestButton.nest = v
		self:addChild(nestButton)
		nestButton.activateOnRelease = true
		
	
		
		local starImage = ui.Image:new()
		starImage.name = "star_" .. v:getType()
		starImage:setImage("H_STAR_SMALL")		
		self:addChild(starImage)
		
		local starText = ui.Text:new()
		starText.name = "starText_" .. v:getType()
		starText.attach = "fixed"
		starText.hanchor = "LEFT"
		starText.vanchor = "VCENTER"
		starText.text = "" .. v:getPrice()
		self:addChild(starText)	

		local nestLock = ui.Image:new()
		nestLock.name = "nestLock" .. v:getType()
		nestLock:setImage("H_LOCK")
		self:addChild(nestLock)
		
	end
	
	
end

function NestSelectionDialog:getClickedButtonNest()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton.nest			
	end
	
	return nil
end

function NestSelectionDialog:setEvents(eventCancel, eventBuy)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
	for k,v in _G.pairs(self.nests) do 
		local nestButton = self:getChild(v:getType())	
		nestButton.returnValue = eventBuy
		
		local nestButtonBg = self:getChild("nestButtonBg" .. v:getType())
		nestButtonBg.returnValue = eventBuy
	end
	
	self.eventBuy = eventBuy
	self:layout()
end



function NestSelectionDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	
	local cancelButton = self:getChild("cancelButton")	
	-- cancelButton.y = (background.h * 0.4)
	cancelButton.y = 194
	
	local totalCols = 3
	local startX = -(background.w * 0.27)
	local startY = -(background.h * 0.22)
	local spacingX = 180
	local spacingY = 140
	
	local index = 0
	local maxItems = 6
	local playerRank = hatchery:getPlayerRank()
	
	for k, v in _G.pairs(self.nests) do 
		local nestButtonBg = self:getChild("nestButtonBg" .. v:getType())
		local nestButton = self:getChild(v:getType())	
		local star = self:getChild("star_" .. v:getType())	
		local starText = self:getChild("starText_" .. v:getType())	
		local nestLock = self:getChild("nestLock" .. v:getType())
		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)
		
		nestButton.x = startX + (colIndex * spacingX)
		nestButton.y = startY + (rowIndex * spacingY)
		nestButtonBg.x = nestButton.x
		nestButtonBg.y = nestButton.y + 22
		local stringWidth = 0
		-- local starOffsetY = 40
		local starOffsetY = 60
	
		if starText.text ~= nil then
			stringWidth = _G.res.getStringWidth(starText.text)
		end
		
		local starPivotX, starPivotY = _G.res.getSpritePivot("", star.image)
		
		local starSpacing = 19
		
		star.x = nestButton.x -( (starSpacing + stringWidth + star.w) * 0.5) + starPivotX
		star.y = nestButton.y + starOffsetY
		
		starText.x = nestButton.x +( (starSpacing + stringWidth + star.w) * 0.5) - stringWidth
		starText.y = star.y
		
		if k > playerRank then
			nestButton.alpha = 0.3
			nestButtonBg.alpha = 0.3
			nestButton.y = nestButtonBg.y
			nestLock.y = nestButton.y
			nestLock.x = nestButton.x
			star.visible = false
			starText.visible = false
			nestButtonBg.returnValue = nil
			nestButton.returnValue = nil
			nestLock.visible = true
			nestLock.alpha = 1
		else
			nestLock.visible = false
			nestButton.alpha = nil
			nestButtonBg.alpha = nil
			star.visible = true
			starText.visible = true
			nestButtonBg.returnValue = self.eventBuy
			nestButton.returnValue = self.eventBuy
		end
		
		if index >= maxItems then
			nestButtonBg.visible = false
			nestButton.visible = false
			star.visible = false
			starText.visible = false
			nestLock.visible = false
		end
		
		index = index + 1
	end
	
end

function NestSelectionDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == self.eventBuy then		
		self.lastClickedButton = meta
	end		
	
	return result, meta
end

filename="NestSelectionDialog.lua"
