BuyStarsDialog = ui.Frame:new()
Frame = ui.Frame

function BuyStarsDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_BIG_TEMP")
	self:addChild(background)
	
	local cancelButton = ui.StaticButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_OK")
	cancelButton.returnValue = "CANCEL"
	cancelButton.sound = getHatcherySound("cancel")
	self:addChild(cancelButton)
	cancelButton.activateOnRelease = true
	
	self.packages = {10, 50, 100, 500}
	self.lastClickedButton = nil
	
	
	for k,v in _G.pairs(self.packages) do 
		local packageButton = ui.StaticButton:new()
		packageButton.name = "packageButton"..v
		packageButton:setImage("H_BTN_STARS_" .. v)
		packageButton.returnValue = "BUY"
		self:addChild(packageButton)
		packageButton.sound = getHatcherySound("starsBought")
		packageButton.activateOnRelease = true
	end
	
	
end

function BuyStarsDialog:getClickedButtonAmount()
	if self.lastClickedButton ~= nil then		
		
		for k,v in _G.pairs(self.packages) do 
			local packageButton = self:getChild("packageButton"..v)	
			if packageButton.name == self.lastClickedButton.name then
				return v
			end
		end
	
	end
	return 0
end

function BuyStarsDialog:setEvents(eventCancel, eventBuy)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
	for k,v in _G.pairs(self.packages) do 
		local packageButton = self:getChild("packageButton"..v)	
		packageButton.returnValue = eventBuy
	end
	
	self.eventBuy = eventBuy
end



function BuyStarsDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	
	--values found by experimenting
	local cancelButton = self:getChild("cancelButton")	
	
	-- cancelButton.y = (background.h * 0.4)
	cancelButton.y = background.h * (194/682)
	
	--TODO: remove this hack
	local buttonW, buttonH = _G.res.getSpriteBounds("", "H_BTN_STARS_10")
	local buttonPX, buttonPY= _G.res.getSpritePivot("", "H_BTN_STARS_10")
	
	local totalRows = 2
	local totalCols = 2
	
	-- local startX = -130	
	-- local startY = -65	
	-- local spacingX = 242	
	-- local spacingY = 103
	-- local startX = - background.w * (130/682)
	
	local startX = - buttonW * (130/185)
	-- local startY = - background.h * (65/580)
	local startY = - buttonH * (65/79)
	local spacingX = buttonW * (242/185)
	local spacingY = buttonH * (103/79)
	
	
	local index = 0
	for k,v in _G.pairs(self.packages) do 
		local packageButton = self:getChild("packageButton"..v)	
		
		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)
		
		
		packageButton.x = startX + (colIndex * spacingX)
		packageButton.y = startY + (rowIndex * spacingY)
		
		
		
		index = index +1
	end
	
end

function BuyStarsDialog:onPointerEvent(eventType,x,y)
	local result,meta, button = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == self.eventBuy then		
		self.lastClickedButton = button
		local starsBought = self:getClickedButtonAmount()
	end		
	
	return result, meta, button
end

filename="BuyStarsDialog.lua"
