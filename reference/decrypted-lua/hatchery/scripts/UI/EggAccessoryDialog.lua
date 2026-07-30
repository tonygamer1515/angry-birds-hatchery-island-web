EggAccessoryDialog = ui.Frame:new()
Frame = ui.Frame


function EggAccessoryDialog:init()
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
	
	local egg = ui.Image:new()
	egg.name = "egg"
	egg:setImage("H_ITEMS_EGG")
	self:addChild(egg)
	
	local femaleButton = ui.ScallableButton:new()
	femaleButton.name = "femaleButton"
	femaleButton.onImage = "H_BUTTON_FEMALE_ON"
	femaleButton.offImage = "H_BUTTON_FEMALE_OFF"
	femaleButton:setImage("H_BUTTON_FEMALE_OFF")
	femaleButton.returnValue = hatcheryEvents.EID_HATCHERY_EGGACCESSORY_DIALOG_FEMALE_ON
	self:addChild(femaleButton)
	
	local maleButton = ui.ScallableButton:new()
	maleButton.onImage = "H_BUTTON_MALE_ON"
	maleButton.offImage = "H_BUTTON_MALE_OFF"
	maleButton.name = "maleButton"
	maleButton:setImage("H_BUTTON_MALE_ON")
	self:addChild(maleButton)
	
	self.currentGender = "male"
	self.lastClickedButton = nil
	self.accessories = {}
	self.boughtAccessories = {TOP = false, MIDDLE = false, BOTTOM = false}

end

function EggAccessoryDialog:setAccessories(accessories, nestView)

	self.accessories = {}
	self.nestView = nestView
	self.boughtAccessories = {TOP = false, MIDDLE = false, BOTTOM = false}
	self.lastClickedButton = nil	
	
	for k,v in _G.pairs(accessories) do 
		local existingAccessoryBg = self:getChild("accessoryBg" .. v:getGender() .. v:getType())
		local existingAccessoryButton = self:getChild(v:getGender() .. v:getType())
		local existingAccessoryImage = self:getChild("image" .. v:getGender() .. v:getType())
		local existingStarImage = self:getChild("star_" .. v:getGender() .. v:getType())
		local existingStarText = self:getChild("starText_" .. v:getGender() .. v:getType())	


		if existingAccessoryBg ~= nil then
			self:removeChild(existingAccessoryBg)
		end
		
		if existingAccessoryImage ~= nil then
			self:removeChild(existingAccessoryImage)
		end
		
		if existingStarImage ~= nil then
			self:removeChild(existingStarImage)
		end
		
		if existingStarText ~= nil then
			self:removeChild(existingStarText)
		end
		
		if existingAccessoryButton ~= nil then
			self:removeChild(existingAccessoryButton)
		end
		
		local accessoryBg = ui.ScallableButton:new()
		accessoryBg.name = "accessoryBg" .. v:getGender() .. v:getType()
		accessoryBg:setImage("H_EGG_ACC_ICON_BG")
		accessoryBg.returnValue = "EID_HATCHERY_EGGACCESSORY_DIALOG_BUY" --.. v:getType()
		accessoryBg.accessory = v
		self:addChild(accessoryBg)
		accessoryBg.activateOnRelease = true
		
		local accessoryButton = ui.ScallableButton:new()
		accessoryButton.name = v:getGender() .. v:getType()
		accessoryButton:setImage(v:getSprite())
		accessoryButton.returnValue = "EID_HATCHERY_EGGACCESSORY_DIALOG_BUY" --.. v:getType()
		-- accessoryButton.scaleX = 0.7
		-- accessoryButton.scaleY = 0.7
		accessoryButton.accessory = v
		self:addChild(accessoryButton)
		accessoryButton.activateOnRelease = true
		
		local accessoryImage = ui.Image:new()
		accessoryImage.name = "image" .. v:getGender() .. v:getType()
		accessoryImage:setImage(v:getItemSprite())
		self:addChild(accessoryImage)
		
		local starImage = ui.Image:new()
		starImage.name = "star_" .. v:getGender() .. v:getType()
		starImage:setImage("H_STAR_SMALL")		
		self:addChild(starImage)
		
		local starText = ui.Text:new()
		starText.name = "starText_" .. v:getGender() .. v:getType()
		starText.attach = "fixed"
		starText.hanchor = "LEFT"
		starText.vanchor = "VCENTER"
		starText.font = "FONT_HATCHERY"
		starText.scaleX = 0.6
		starText.scaleY = 0.6
		starText.text = "" .. v:getPrice()
		self:addChild(starText)

		_G.table.insert(self.accessories, v)
	
	end
	
	self:setVisibilities()
end

function EggAccessoryDialog:getClickedAccessory()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton.accessory			
	end
	
	return nil
end

function EggAccessoryDialog:setEvents(eventCancel, eventBuy)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel

	
	for k,v in _G.pairs(self.accessories) do 
		local accessoryButton = self:getChild(v:getGender() .. v:getType())	
		accessoryButton.returnValue = eventBuy
	end
	
	self.eventBuy = eventBuy
end



function EggAccessoryDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.y = 194
	
	local egg = self:getChild("egg")
	egg.x = background.w * 0.2
	egg.y = -background.h  * 0.05
	
	local imageMaleTop = self:getChild("imagemaleTOP")
	local imageMaleMiddle = self:getChild("imagemaleMIDDLE")
	local imageMaleBottom = self:getChild("imagemaleBOTTOM")
	imageMaleTop.x, imageMaleTop.y = egg.x, egg.y
	imageMaleMiddle.x, imageMaleMiddle.y = egg.x, egg.y
	imageMaleBottom.x, imageMaleBottom.y = egg.x, egg.y
	
	local imageFemaleTop = self:getChild("imagefemaleTOP")
	local imageFemaleMiddle = self:getChild("imagefemaleMIDDLE")
	local imageFemaleBottom = self:getChild("imagefemaleBOTTOM")
	imageFemaleTop.x, imageFemaleTop.y = imageMaleTop.x, imageMaleTop.y
	imageFemaleMiddle.x, imageFemaleMiddle.y = imageMaleMiddle.x, imageMaleMiddle.y
	imageFemaleBottom.x, imageFemaleBottom.y = imageMaleBottom.x, imageMaleBottom.y
	
	local femaleButton = self:getChild("femaleButton")
	femaleButton.x, femaleButton.y = egg.x - femaleButton.w * 0.6, egg.y + egg.h * 0.7
	
	local maleButton = self:getChild("maleButton")
	maleButton.x, maleButton.y = egg.x + maleButton.w * 0.6, egg.y + egg.h * 0.7
	
	local maxWidth, maxHeight = _G.res.getSpriteBounds("H_EGG_ACC_ICON_BG") 
	local spacingX = maxWidth * 1.2
	local spacingY = maxHeight * 1.2
	maxWidth, maxHeight = maxWidth * 0.7, maxHeight * 0.7
	local totalCols = 1
	local startX = -spacingX * 0.5
	local startY = -background.h * 0.3
	local spacingX = 170
	local spacingY = maxHeight * 1.5
	
	local index = 0
	local maxItems = 3
	for k, v in _G.pairs(self.accessories) do 
		
		local accBg = self:getChild("accessoryBg" .. v:getGender() .. v:getType())
		local accButton = self:getChild(v:getGender() .. v:getType())	
		
		local sw, sh = _G.res.getSpriteBounds(accButton.image)
		local px, py = _G.res.getSpritePivot(accButton.image)
		
		-- if sw > maxWidth or sh > maxHeight then
			-- local scale = _G.math.min(maxWidth / sw, maxHeight / sh)		
			-- accButton.scaleX, accButton.scaleY = scale, scale 
		-- end
		
		local star = self:getChild("star_" .. v:getGender() .. v:getType())	
		local starText = self:getChild("starText_" .. v:getGender() .. v:getType())	
		
		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)
	
		accBg.x, accBg.y = startX + (colIndex * spacingX), startY + (rowIndex * spacingY)
		
		accButton.x = -background.w * 0.25
		accButton.y = accBg.y
		
		local stringWidth = 0
		if starText.text ~= nil then
			stringWidth = _G.res.getStringWidth(starText.text)
		end
		
		local starPivotX, starPivotY = _G.res.getSpritePivot("", star.image)
		
		local starSpacing = 50
		
		star.x = -background.w * 0.13 
		star.y = accBg.y
		
		starText.x = star.x + star.w * 0.75
		starText.y = star.y + 2
		
	
		index = index + 1
		if index >= maxItems then
			index = 0
		end
	end
	self:setVisibilities()
end

function EggAccessoryDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == self.eventBuy then		
		self.lastClickedButton = meta
	elseif result == hatcheryEvents.EID_HATCHERY_EGGACCESSORY_DIALOG_MALE_ON then
		local maleButton = self:getChild("maleButton")
		local femaleButton = self:getChild("femaleButton")
		
		maleButton:setImage(maleButton.onImage)
		femaleButton:setImage(femaleButton.offImage)
		
		femaleButton.returnValue = hatcheryEvents.EID_HATCHERY_EGGACCESSORY_DIALOG_FEMALE_ON
		maleButton.returnValue = nil
		self.currentGender = "male"
		self.nestView.currentNest:getEgg():changeAccessoryGender()
		self:setVisibilities()
		
	elseif result == hatcheryEvents.EID_HATCHERY_EGGACCESSORY_DIALOG_FEMALE_ON then
		local maleButton = self:getChild("maleButton")
		local femaleButton = self:getChild("femaleButton")
		
		maleButton:setImage(maleButton.offImage)
		femaleButton:setImage(femaleButton.onImage)
		
		femaleButton.returnValue = nil
		maleButton.returnValue = hatcheryEvents.EID_HATCHERY_EGGACCESSORY_DIALOG_MALE_ON
		self.currentGender = "female"
		self.nestView.currentNest:getEgg():changeAccessoryGender()
		self:setVisibilities()
	elseif result == hatcheryEvents.EID_HATCHERY_EGGACCESSORY_DIALOG_BUY then
		if self.nestView.hatchery:purchaseEggAccessory(self.nestView.currentNest, meta.accessory) ~= false then
			self.nestView:starCountUpdated()
			self.boughtAccessories[meta.accessory:getType()] = true
			self:setVisibilities()
			meta.returnValue = nil
		else
			self.nestView:setEggAccessorySprites()
			self.nestView:openBuyMoreStarsConfirm()
		end
	
	end
	
	return result, meta
end

function EggAccessoryDialog:getCurrentGender()
	return self.currentGender
end

function EggAccessoryDialog:setVisibilities()
	for k, v in _G.pairs(self.accessories) do 
		local accessoryBg = self:getChild("accessoryBg" .. v:getGender() .. v:getType())
		local accessoryButton = self:getChild(v:getGender() .. v:getType())
		local accessoryImage = self:getChild("image" .. v:getGender() .. v:getType())
		local starImage = self:getChild("star_" .. v:getGender() .. v:getType())
		local starText = self:getChild("starText_" .. v:getGender() .. v:getType())	

		if v:getGender() == self.currentGender then
			accessoryBg.visible = true
			accessoryButton.visible = true
			starImage.visible = true
			starText.visible = true
			
			if self.boughtAccessories[v:getType()] == true then
				accessoryImage.visible = true
				accessoryButton.alpha = 0.3
				accessoryButton.selectable = false
				accessoryBg.selectable = false
				starImage.alpha = 0.3
				starText.alpha = 0.3
			else
				accessoryImage.visible = false
			end

		else
			accessoryBg.visible = false
			accessoryImage.visible = false
			accessoryButton.visible = false
			starImage.visible = false
			starText.visible = false
		end	
	end
end



filename="EggAccessoryDialog.lua"
