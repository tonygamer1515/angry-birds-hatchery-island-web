WorldSelectionPanel = ui.Frame:new()
Frame = ui.Frame



function WorldSelectionPanel:init() 

	
	local inventoryBar = ui.ScallableButton:new()
	inventoryBar.name = "InventoryBar"
	inventoryBar:setImage("H_BOTTOM_MENU_BG")
	inventoryBar.attach = "fixed"
	inventoryBar.returnValue = -1
	inventoryBar:setup(1, 1, 0)
	self:addChild(inventoryBar)
	
	local purchaseButton = ui.ScallableButton:new()
	purchaseButton.name = "purchaseButton"
	purchaseButton:setImage("H_BOTTOM_MENU_BUTTON_PURCHASE")
	purchaseButton.attach = "fixed"
	purchaseButton:setup(1, 1, 0)
	purchaseButton.returnValue = -1
	self:addChild(purchaseButton)
	
	


	self.objectButtons = {}
	
	--relative to the center
	self.itemsMinX = -350
	self.itemMaxX = self.itemsMinX + 500
	

	
	self.totalDragged = 0
	
	self.currentBirdColor = ""
	
	
	self:loadHatcheryObjects(hatcheryDynamicTemplates)
	
end

function WorldSelectionPanel:loadHatcheryObjects(objects)
	count = 1
	for k, v in _G.pairs(objects) do
		if v.inventorySprite then
			local itemButton = ui.InventoryButton:new()
			itemButton.name = "itemButton" .. count
			itemButton.item = v
			itemButton:setPrice(v.price)
			itemButton:setImage(v.inventorySprite)
			itemButton.returnValue = hatcheryEvents.EID_HATCHERY_OBJECT_SELECTED
			
			--TODO: remove this hack
			if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
				itemButton:setTextFontScale(0.7)
			end
			
			itemButton:layout()
			itemButton.clickSound = getHatcherySound("inventoryObjectMouseDown")						
			
			self:addChild(itemButton)
			_G.table.insert(self.objectButtons, itemButton)
			count = count +1
		end
	end
end



function WorldSelectionPanel:onEntry()
	ui.Frame.onEntry(self)
	-- self:scrollClosestItem()
	
	local it = 4
	local spacing = 100
	local y = gamelua.screenHeight -25
	for k, v in _G.pairs(self.objectButtons) do
		--hack, nest and egg first
		if v.item.class == "nest" then
			v.x = gamelua.screenWidth * 0.5 + self.itemsMinX + 2*spacing
			v.y = y
		elseif v.item.class == "egg" then
			v.x = gamelua.screenWidth * 0.5 + self.itemsMinX + 3*spacing
			v.y = y
		else
			v.x = gamelua.screenWidth * 0.5 + self.itemsMinX + it * spacing
			v.y = y
			it = it + 1
		end
	end
	
	
	
end

 




function WorldSelectionPanel:layout()

	
	
	
	local topBar = self:getChild("InventoryBar")
	
	local barW, barH = _G.res.getSpriteBounds("", topBar.image)
	local barPX, barPY = _G.res.getSpritePivot("", topBar.image)
	local offsetY = - barH * (30/167)
	-- topBar.y = gamelua.screenHeight
	topBar.y = gamelua.screenHeight - barH + barPY - offsetY
	topBar.x = gamelua.screenWidth * 0.5

	local barW, barH = _G.res.getSpriteBounds(topBar.image)
	
	local purchaseButton = self:getChild("purchaseButton")
	-- purchaseButton.y = gamelua.screenHeight - barH
	-- purchaseButton.y = topBar.y - barH
	purchaseButton.y = topBar.y - barH + barPY
	purchaseButton.x = 0.08*gamelua.screenWidth
	
	self:relocateItemButtons()
	
	
end

function WorldSelectionPanel:relocateItemButtons()
	local it = 0
	
	local priceTagSprite = "H_ITEM_PRICE_TAG"
	local priceTagImageW, priceTagImageH = _G.res.getSpriteBounds("", priceTagSprite)
	local priceTagImagePX, priceTagImagePY = _G.res.getSpritePivot("", priceTagSprite)
	
	--TODO: fix this hack spacing. The relative spacing is good, but since we dont have scrolling yet, we have to make it tighter for iphone
	local spacing = priceTagImageW * 0.5
	
	if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
		spacing = priceTagImageW * 0.2
	end
	
	local outlineX = 10
	
	--TODO: fix this hack outlineY
	local outlineY = 0
	
	if gamelua.deviceModel == "ipad" then
		outlineY = 20
	elseif gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
		outlineY = 10
	end
	
	local lastItem = nil	
	
	--first non-egg/nest objects
	for k, v in _G.pairs(self.objectButtons) do
		if v.item.class ~= "nest" and v.item.class ~= "egg" then
			-- local priceTag = v:getChild("priceTag")												
			if lastItem == nil then
				v.x = gamelua.screenWidth - outlineX - priceTagImageW + priceTagImagePX
			else
				v.x = (lastItem.x - priceTagImagePX) - spacing - priceTagImageW + priceTagImagePX
			end
			
			v.y = gamelua.screenHeight - priceTagImageH + priceTagImagePY - outlineY
			
			lastItem = v
		end
	end
	
	--egg objects
	for k, v in _G.pairs(self.objectButtons) do
		if v.item.class == "egg" then
			-- local priceTag = v:getChild("priceTag")												
			if lastItem == nil then
				v.x = gamelua.screenWidth - outlineX - priceTagImageW + priceTagImagePX
			else
				v.x = (lastItem.x - priceTagImagePX) - spacing - priceTagImageW + priceTagImagePX
			end
			
			v.y = gamelua.screenHeight - priceTagImageH + priceTagImagePY - outlineY
			
			lastItem = v
		end
	end
	
	--nest objects
	for k, v in _G.pairs(self.objectButtons) do
		if v.item.class == "nest" then
			-- local priceTag = v:getChild("priceTag")												
			if lastItem == nil then
				v.x = gamelua.screenWidth - outlineX - priceTagImageW + priceTagImagePX
			else
				v.x = (lastItem.x - priceTagImagePX) - spacing - priceTagImageW + priceTagImagePX
			end
			
			v.y = gamelua.screenHeight - priceTagImageH + priceTagImagePY - outlineY
			
			lastItem = v
		end
	end
	
	
	
	
end



function WorldSelectionPanel:onPointerEvent(eventType,x,y)

	local result,meta, element = nil, nil

	result,meta, element = Frame.onPointerEvent(self, eventType,x, y)
		

	return result, meta, element
end



function WorldSelectionPanel:update(dt, time) 

	for i,v in _G.ipairs(self.children) do
		if v.active == true then		
			v:update(dt,time)
		end
	end
	
	
	
	
end


function WorldSelectionPanel:draw(x,y, scaleX, scaleY, angle) 

	


	x = x or 0
	y = y or 0
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	
	for i,v in _G.ipairs(self.children) do
		if v.visible == true then
			v:draw((x + self.x), (y + self.y), scaleX * self.scaleX, scaleY * self.scaleY, angle + self.angle)
		end
	end
end


function WorldSelectionPanel:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end




filename="WorldSelectionPanel.lua"
