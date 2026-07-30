BirdDesignerSelectionFrame = ui.Frame:new()
Frame = ui.Frame

function BirdDesignerSelectionFrame:init()
	Frame.init(self)	
	
	self.prefabsTableToUse = gamelua.Hatchery.getBirds()

	self.worldScale = 1
	-- self.prefabsTableToUse = gamelua.hatcheryBirdsPrefabs
	-- self.worldScale = 20
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_NO")
	cancelButton.returnValue = "CANCEL"
	cancelButton.sound = getHatcherySound("cancel")
	self:addChild(cancelButton)
	cancelButton.activateOnRelease = true
	
	
	local okButton = ui.ScallableButton:new()
	okButton.name = "okButton"
	okButton:setImage("H_BTN_OK")
	okButton.returnValue = "OK"
	okButton.sound = getHatcherySound("cancel")
	self:addChild(okButton)
	okButton.activateOnRelease = true
	
	
	
	self.lastClickedButton = nil
	
	local indexText = ui.Text:new()
	indexText.name = "indexText"
	indexText.visible = true
	indexText.text = "0"
	indexText.font = "FONT_HATCHERY"
	self:addChild(indexText)
	
	
	
	
	
end

function BirdDesignerSelectionFrame:reset()

	local okButton = self:getChild("okButton")
	okButton.visible = false
	self.currentNestIndex = nil
	
	
	
	
end

function BirdDesignerSelectionFrame:setup(eventOk, eventCancel, hatcheryNests, hatcheryEggs, hatcheryAccessories)
	
	self.itemTypeToInsert = itemTypeToInsert
	
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
	local okButton = self:getChild("okButton")	
	okButton.returnValue = eventOk
	
	self.items = {}
	
	self.nestSprites = {}
	self.eggSprites = {}
	
	--remember the empty slots
	self.accessorySlot2Sprites = {""}
	self.accessorySlot3Sprites = {""}		
	
	for k, v in _G.pairs(hatcheryNests) do 
		_G.table.insert(self.nestSprites, v.sprites.shop)
	end
	
	for k, v in _G.pairs(hatcheryEggs) do 
		_G.table.insert(self.eggSprites, v.sprites.shop)
	end
	
	for k,v in _G.pairs(hatcheryAccessories) do
		if v.slot == 3 then
			_G.table.insert(self.accessorySlot3Sprites, v:getSprite())
		elseif v.slot == 2 then
			_G.table.insert(self.accessorySlot2Sprites, v:getSprite())
		end
	end
	
	
	local itemCounter = 1
	
	-- for nestIndex = 1, #self.nestSprites do
		-- for eggIndex = 1, #self.eggSprites do
			-- for accessoryUpIndex = 1, #self.accessorySlot3Sprites do
				-- for accessoryDownIndex = 1, #self.accessorySlot2Sprites do
	
	for i = 1, #self.prefabsTableToUse do
		
		local existingItemButton = self:getChild("itemButton" .. i)

		if existingItemButton ~= nil then
			self:removeChild(existingItemButton)
		end	
	end
	
	self.lastClickedButton = nil	
	
	
	for i = 1, #self.prefabsTableToUse do
				
		
		local itemButton = ui.ScallableButton:new()
		itemButton.name = "itemButton" .. i
		itemButton:setImage("H_BTN_ACCESSORIES")
		itemButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_ITEM_SELECTED	
		
		itemButton.objectId = i
		
		self:addChild(itemButton)	
		itemButton.activateOnRelease = true
		itemButton.visible = true

				
				
	end
	
	self:layout()
	
	
	
end

function BirdDesignerSelectionFrame:getClickedButtonItem()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton			
	end
	
	return nil
end


function BirdDesignerSelectionFrame:layout()
	Frame.layout(self)	
	
	local indexText = self:getChild("indexText")
	indexText.x = gamelua.screenWidth * 0.5
	indexText.y = gamelua.screenHeight - 100
	
	local buttonsY = gamelua.screenHeight - 50
	local buttonX = 100
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.y = buttonsY
	cancelButton.x = gamelua.screenWidth * 0.5 - buttonX
	local okButton = self:getChild("okButton")	
	okButton.y = buttonsY
	okButton.x = gamelua.screenWidth * 0.5 + buttonX		
	
	
	
	local index = 0
	local maxItems = 6
	
	self.cellMaxWidth = 50
	self.cellMaxHeight = 50
	
	local gridWidthRatio = 0.95
	local gridHeightRatio = 0.4
	
	local totalCols = (gamelua.screenWidth * gridWidthRatio) / self.cellMaxWidth
	-- local totalRows = (gamelua.screenHeight * gridHeightRatio) / cellMaxHeight
	
	local startX = gamelua.screenWidth * 0.5 - (gamelua.screenWidth * gridWidthRatio) * 0.5
	local startY = gamelua.screenHeight * 0.5 - (gamelua.screenHeight * gridHeightRatio) * 0.5
	
	startY = 100
	
	
	
	totalCols = _G.math.floor(totalCols)
	
	local itemCounter = 1
	if self.items ~= nil then
		-- for k,v in _G.pairs(self.items) do 
		
		for i = 1, #self.prefabsTableToUse  do 
			local itemButton = self:getChild("itemButton" .. i)	
			local itemButtonPivotX, itemButtonPivotY = _G.res.getSpritePivot("", itemButton.image)	

			local rowIndex = _G.math.floor(index / totalCols)
			local colIndex = _G.math.fmod(index, totalCols)			

			local celPosX = startX + colIndex * self.cellMaxWidth + self.cellMaxWidth * 0.5
			local celPosY = startY + rowIndex * self.cellMaxHeight + self.cellMaxHeight * 0.5
			
			local scaleX = self.cellMaxWidth / itemButton.w
			local scaleY = self.cellMaxHeight / itemButton.h
			
			local scale = _G.math.min(scaleX, scaleY)
			scale = _G.math.min(scale, 1)
			
			itemButton.scaleX = scale
			itemButton.scaleY = scale
			
			itemButton.x = celPosX + itemButtonPivotX - itemButton.w * 0.5
			itemButton.y = celPosY + itemButtonPivotY - itemButton.h * 0.5	

			itemButton.x = celPosX + itemButtonPivotX * scale - itemButton.w * scale * 0.5
			itemButton.y = celPosY + itemButtonPivotY * scale - itemButton.h * scale * 0.5		

			
			
			itemCounter = itemCounter + 1
			index = index + 1
		end
	end
	
	
end




function BirdDesignerSelectionFrame:draw(x, y)
	
	ui.Frame.draw(self, x, y)	
	
	
	for i = 1, #self.prefabsTableToUse do 
		local itemButton = self:getChild("itemButton" .. i)																
		-- self:drawBird(itemButton.nestIndex, itemButton.eggIndex, itemButton.accessoryUpIndex, itemButton.accessoryDownIndex, itemButton.x, itemButton.y, 0, itemButton.objectId)
		self:drawBird(itemButton.x, itemButton.y, 0, i)
		
	end
end


function BirdDesignerSelectionFrame:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == hatcheryEvents.EID_BIRD_DESIGNER_ITEM_SELECTED then		
		self.lastClickedButton = meta
		local okButton = self:getChild("okButton")
		okButton.visible = true
		-- self:setupRecipeButtons()
		local indexText = self:getChild("indexText")
		indexText.text = "" .. meta.objectId
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_2_NEST_BUTTON then		
		-- self.currentNestIndex = meta.index
		-- self:setupVisibleItems()
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_2_ALL_NESTS_BUTTON then
		self.lastClickedButton = nil
		self.currentNestIndex = nil
		local okButton = self:getChild("okButton")
		okButton.visible = false
		-- self:setupRecipeButtons()
		-- self:setupVisibleItems()
	end
	
	return result, meta
end

function BirdDesignerSelectionFrame:drawBird(x, y, angle, objectId, scale)
	
	
	if scale == nil then
		self.cellMaxWidth = 50
		self.cellMaxHeight = 50
		local bodyW, bodyH = _G.res.getSpriteBounds("", self:getBiggestSpriteInList(self.prefabsTableToUse[objectId].sprites))
		-- local bodyW, bodyH = _G.res.getSpriteBounds("", gamelua.hatcheryBirds["BODIES"][nestIndex])
		local scaleX = self.cellMaxWidth / bodyW
		local scaleY = self.cellMaxHeight / bodyH
		
		scale = _G.math.min(scaleX, scaleY)
	end
	gamelua.drawCompoObjectLua(x,y, angle, scale, self.prefabsTableToUse[objectId].sprites)


end

function BirdDesignerSelectionFrame:getBiggestSpriteInList(list)
	local maxH = 0
	
	local maxName = nil
	
	for k, v in _G.pairs(list) do
		local sprite = v.sprite
		local w, h = _G.res.getSpriteBounds("", sprite)
		
		if h > maxH then
			maxH = h
			maxName = sprite
		end
	end
	
	return maxName
end


filename="BirdDesignerSelectionFrame.lua"
