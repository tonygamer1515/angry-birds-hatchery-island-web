NestAccessoryDialog = ui.Frame:new()
Frame = ui.Frame


function NestAccessoryDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_BIG_TEMP")
	self:addChild(background)
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_NO")
	cancelButton.returnValue = "CANCEL"
	self:addChild(cancelButton)
	cancelButton.sound = getHatcherySound("cancel")
	cancelButton.activateOnRelease = true
	
	self.lastClickedButton = nil
	
end

function NestAccessoryDialog:setAccessories(accessories, slot)
	-- self.accessories = accessories
	self.accessories = {}
	self.lastClickedButton = nil	
	
	for k,v in _G.pairs(accessories) do 
		if v:getSlot() == slot then
			local existingAccessoryBg = self:getChild("accessoryBg" .. v:getType())
			local existingAccessoryButton = self:getChild(v:getType())
			local existingStarImage = self:getChild("star_" .. v:getType())
			local existingStarText = self:getChild("starText_" .. v:getType())
			
			if existingAccessoryBg ~= nil then
				self:removeChild(existingAccessoryBg)
			end
			
			if existingAccessoryButton ~= nil then
				self:removeChild(existingAccessoryButton)
				if v:getType() == NestAccessory.TYPE.SLOT2_FAN then
					local existingAccessoryButton2 = self:getChild(v:getType() .. "2")
					self:removeChild(existingAccessoryButton2)
				end
			end
			
			if existingStarImage ~= nil then
				self:removeChild(existingStarImage)
			end
			
			if existingStarText ~= nil then
				self:removeChild(existingStarText)
			end
			
			local accessoryBg = ui.ScallableButton:new()
			accessoryBg.name = "accessoryBg" .. v:getType()
			accessoryBg:setImage("H_BUY_NEST_ACC_BG")
			accessoryBg.returnValue = "BUY"
			accessoryBg.accessory = v
			self:addChild(accessoryBg)
			accessoryBg.activateOnRelease = true
			
			local accessoryButton = ui.ScallableButton:new()
			accessoryButton.name = v:getType()
			accessoryButton:setImage(v:getSprite())
			accessoryButton.returnValue = "BUY"
			accessoryButton.scaleX = 0.7
			accessoryButton.scaleY = 0.7
			accessoryButton.accessory = v
			self:addChild(accessoryButton)
			accessoryButton.activateOnRelease = true
			
			if v:getType() == NestAccessory.TYPE.SLOT2_FAN then -- fan
				local accessoryButton2 = ui.ScallableButton:new()
				accessoryButton2.name = v:getType() .. "2"
				accessoryButton2:setImage(v:getAdditionalSprite())
				accessoryButton2.returnValue = "BUY"
				accessoryButton2.scaleX = 0.7
				accessoryButton2.scaleY = 0.7
				accessoryButton2.accessory = v
				self:addChild(accessoryButton2)
				accessoryButton2.activateOnRelease = true
			end
			
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

			_G.table.insert(self.accessories, v)
		end
	end
	
	
end

function NestAccessoryDialog:getClickedAccessory()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton.accessory			
	end
	
	return nil
end

function NestAccessoryDialog:setEvents(eventCancel, eventBuy)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
	for k,v in _G.pairs(self.accessories) do 
		local accessoryButton = self:getChild(v:getType())	
		accessoryButton.returnValue = eventBuy
		if v:getType() == NestAccessory.TYPE.SLOT2_FAN then
			local accessoryButton2 = self:getChild(v:getType().. "2")
			accessoryButton2.returnValue = eventBuy
		end
		local accessoryBg = self:getChild("accessoryBg" .. v:getType())
		accessoryBg.returnValue = eventBuy
	end
	
	self.eventBuy = eventBuy
end



function NestAccessoryDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	
	local cancelButton = self:getChild("cancelButton")	
	-- cancelButton.y = (background.h * 0.4)
	cancelButton.y = 194
	
	
	
	
	
	local maxWidth, maxHeight = _G.res.getSpriteBounds("H_BUY_NEST_ACC_BG") 
	local spacingX = maxWidth * 1.2
	maxWidth, maxHeight = maxWidth * 0.7, maxHeight * 0.7
	local totalCols = 2
	local startX = -spacingX * 0.5
	local startY = 10

	local index = 0
	local maxItems = 2
	for k,v in _G.pairs(self.accessories) do 
		
		
		local accBg = self:getChild("accessoryBg" .. v:getType())
		local accButton = self:getChild(v:getType())	
		
		local sw, sh = _G.res.getSpriteBounds(accButton.image)
		local px, py = _G.res.getSpritePivot(accButton.image)
		
		if sw > maxWidth or sh > maxHeight then
			local scale = _G.math.min(maxWidth / sw, maxHeight / sh)		
			accButton.scaleX, accButton.scaleY = scale, scale 
		end
		
		local star = self:getChild("star_" .. v:getType())	
		local starText = self:getChild("starText_" .. v:getType())	
		
		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)
		
		accBg.x, accBg.y = startX + (colIndex * spacingX), startY - background.h * 0.1
		
		accButton.x = accBg.x
		accButton.y = accBg.y + 50
		
		
		if v:getType() == NestAccessory.TYPE.SLOT2_FAN then 
			local accessoryButton2 = self:getChild(v:getType() .. "2")
			accessoryButton2.x = accButton.x
			accessoryButton2.y = accButton.y - gamelua.screenHeight * 0.175 * accButton.scaleY
		end
		
		local stringWidth = 0
		local starOffsetY = 40
	
		if starText.text ~= nil then
			stringWidth = _G.res.getStringWidth(starText.text)
		end
		
		local starPivotX, starPivotY = _G.res.getSpritePivot("", star.image)
		
		local starSpacing = 19
		
		star.x = accButton.x -( (starSpacing + stringWidth + star.w) * 0.5) + starPivotX
		star.y = accButton.y + starOffsetY
		
		starText.x = accButton.x +( (starSpacing + stringWidth + star.w) * 0.5) - stringWidth
		starText.y = star.y + 2
		
		if index >= maxItems then
			accButton.visible = false
			star.visible = false
			starText.visible = false
		end
		
		index = index + 1
	end
	
end

function NestAccessoryDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == self.eventBuy then		
		self.lastClickedButton = meta
	end		
	
	return result, meta
end

filename="NestAccessoryDialog.lua"
