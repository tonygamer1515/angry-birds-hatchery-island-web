EggSelectionDialog = ui.Frame:new()
Frame = ui.Frame

function EggSelectionDialog:init()
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
	cancelButton.sound = getHatcherySound("cancel")
	self:addChild(cancelButton)
	cancelButton.activateOnRelease = true
	
	
	self.lastClickedButton = nil
	
	
	
end

function EggSelectionDialog:setEggs(eggs)
	self.eggs = eggs
	self.lastClickedButton = nil	
	
	local eggCounter = 1
	for k,v in _G.pairs(self.eggs) do 
		local existingEggButtonBg = self:getChild("eggButtonBg" .. eggCounter)
		local existingEggButton = self:getChild("eggButton" .. eggCounter)
		local existingClockImage = self:getChild("clock_" .. v:getType())
		local existingClockText = self:getChild("clockText_" .. v:getType())
		local existingEggText = self:getChild("eggText_" .. v:getType())
		local existingStarImage = self:getChild("star_" .. v:getType())
		local existingStarText = self:getChild("starText_" .. v:getType())
		
		if existingEggButtonBg ~= nil then
			self:removeChild(existingEggButtonBg)
		end
		
		if existingEggButton ~= nil then
			self:removeChild(existingEggButton)
		end
		
		if existingClockImage ~= nil then
			self:removeChild(existingClockImage)
		end
		
		if existingClockText ~= nil then
			self:removeChild(existingClockText)
		end
		
		if existingEggText ~= nil then
			self:removeChild(existingEggText)
		end
		
		if existingStarImage ~= nil then
			self:removeChild(existingStarImage)
		end
		
		if existingStarText ~= nil then
			self:removeChild(existingStarText)
		end
		
		local eggButtonBg = ui.ScallableButton:new()
		eggButtonBg.name = "eggButtonBg" .. eggCounter
		eggButtonBg:setImage("H_BUY_EGG_BG")
		eggButtonBg.returnValue = "BUY"
		eggButtonBg.egg = v
		self:addChild(eggButtonBg)
		eggButtonBg.activateOnRelease = true
		
		local eggButton = ui.ScallableButton:new()
		eggButton.name = "eggButton" .. eggCounter
		eggButton:setImage(v:getSprites().shop)
		eggButton.returnValue = "BUY"
		eggButton.egg = v
		self:addChild(eggButton)
		eggButton.activateOnRelease = true
		
		local clockImage = ui.Image:new()
		clockImage.name = "clock_" .. v:getType()
		clockImage:setImage("H_CLOCK_SMALL")		
		self:addChild(clockImage)
		
		local clockText = ui.Text:new()
		clockText.name = "clockText_" .. v:getType()
		clockText.attach = "fixed"
		clockText.hanchor = "LEFT"
		clockText.vanchor = "VCENTER"
		clockText.text = "" .. v:getSpeedName()
		clockText.scaleX = 0.7
		clockText.scaleY = 0.7
		self:addChild(clockText)		
		
		local eggText = ui.Text:new()
		eggText.name = "eggText_" .. v:getType()
		eggText.attach = "fixed"
		eggText.hanchor = "HCENTER"
		eggText.vanchor = "VCENTER"
		eggText.text = "" .. v:getName()
		self:addChild(eggText)		
		
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
		starText.scaleX = 0.7
		starText.scaleY = 0.7
		self:addChild(starText)		
		
		eggCounter = eggCounter + 1
	end
	
	
end

function EggSelectionDialog:getClickedButtonEgg()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton.egg			
	end
	
	return nil
end

function EggSelectionDialog:setEvents(eventCancel, eventBuy)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
	local eggCounter = 1
	for k,v in _G.pairs(self.eggs) do 
		local eggButton = self:getChild("eggButton"..eggCounter)	
		eggButton.returnValue = eventBuy
		
		local eggButtonBg = self:getChild("eggButtonBg" .. eggCounter)
		eggButtonBg.returnValue = eventBuy
		
		eggCounter = eggCounter + 1
	end
	
	self.eventBuy = eventBuy
	
	
end



function EggSelectionDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	
	local cancelButton = self:getChild("cancelButton")	
	-- cancelButton.y = (background.h * 0.4)
	cancelButton.y = 194
	
	local totalCols = 3
	local startX = -(background.w * 0.27)
	local startY = -(background.h * 0.165)
	local spacingX = 170
	local spacingY = 130
	-- local t_textsStartY = 30
	local t_textsStartY = 12
	
	local index = 0
	local maxItems = 6
	
	local eggCounter = 1
	for k,v in _G.pairs(self.eggs) do 
		-- local eggButton = self:getChild(v:getType())	
		local eggButtonBg = self:getChild("eggButtonBg" .. eggCounter)
		local eggButton = self:getChild("eggButton" .. eggCounter)	
		local eggButtonPivotX, eggButtonPivotY = _G.res.getSpritePivot("", eggButton.image)
		
		local star = self:getChild("star_" .. v:getType())	
		local starText = self:getChild("starText_" .. v:getType())	
		local clockImage = self:getChild("clock_" .. v:getType())	
		local clockText = self:getChild("clockText_" .. v:getType())	
		local eggText = self:getChild("eggText_" .. v:getType())	
		
		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)
		
		eggButton.x = startX + (colIndex * spacingX)
		eggButton.y = startY + (rowIndex * spacingY)
		
		eggButtonBg.x = eggButton.x
		eggButtonBg.y = -background.h * 0.07
		
		eggText.x = eggButton.x
		eggText.y = t_textsStartY
		
		gamelua.setFont(eggText.font)
		
		local eggTextWidth = _G.res.getStringWidth(eggText.text) * eggText.scaleX
		
		local t_yOffset = 35	
		
		local stringWidth = 0
		
		gamelua.setFont(clockText.font)
		
		if clockText.text ~= nil then
			stringWidth = _G.res.getStringWidth(clockText.text) * clockText.scaleX
		end
		
		
		
		local clockPivotX, clockPivotY = _G.res.getSpritePivot("", clockImage.image)
		
		local clockSpacing = 10
		
		clockImage.x = eggText.x - eggTextWidth * 0.5 + clockPivotX
		clockImage.y = eggText.y + t_yOffset
		
		-- clockText.x = eggButton.x +( (clockSpacing + stringWidth + clockImage.w) * 0.5) - stringWidth
		clockText.x = clockImage.x + (clockSpacing + clockImage.w - clockPivotX)
		clockText.y = eggText.y + t_yOffset
		
		gamelua.setFont(starText.font)
		
		if starText.text ~= nil then
			stringWidth = _G.res.getStringWidth(starText.text) * starText.scaleX
		end
		
		local starPivotX, starPivotY = _G.res.getSpritePivot("", star.image)
		
		local starSpacing = 10
		
		-- star.x = eggButton.x -( (starSpacing + stringWidth + star.w) * 0.5) + starPivotX
		star.x = eggText.x - eggTextWidth * 0.5 + starPivotX
		star.y = clockText.y + t_yOffset
		
		-- starText.x = eggButton.x +( (starSpacing + stringWidth + star.w) * 0.5) - stringWidth
		starText.x = star.x + (starSpacing + star.w - starPivotX)
		starText.y = star.y
		
		
		index = index + 1
		
		eggCounter = eggCounter + 1
	end
	
	--sets up egg buttons to be aligned by the bottom of the third one
	local eggButton3 = self:getChild("eggButton3")	
	local eggButton3PivotX, eggButton3PivotY = _G.res.getSpritePivot("", eggButton3.image)
	
	local bottom = eggButton3.y - eggButton3PivotY + eggButton3.h
	
	for i = 1, 2 do
		-- local eggButtonBg = self:getChild("eggButtonBg" .. i)
		local eggButton = self:getChild("eggButton" .. i)	
		local eggButtonPivotX, eggButtonPivotY = _G.res.getSpritePivot("", eggButton.image)
		eggButton.y = bottom - eggButton.h + eggButtonPivotY
		-- eggButtonBg.y = eggButton.y
	end
	
end

function EggSelectionDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == self.eventBuy then		
		self.lastClickedButton = meta
	end		
	
	return result, meta
end

filename="EggSelectionDialog.lua"
