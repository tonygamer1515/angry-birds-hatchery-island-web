BirdDesigner2SelectionFrame = ui.Frame:new()
Frame = ui.Frame

function BirdDesigner2SelectionFrame:init()
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
	
	local allNestsButton = ui.ScallableButton:new()
	allNestsButton.name = "allNestsButton"
	allNestsButton:setImage("H_BTN_ACCESSORIES")
	allNestsButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_2_ALL_NESTS_BUTTON
	allNestsButton.sound = getHatcherySound("cancel")
	self:addChild(allNestsButton)
	allNestsButton.activateOnRelease = true
	
	self.lastClickedButton = nil
	
	
	
	
	
end

function BirdDesigner2SelectionFrame:reset()

	local okButton = self:getChild("okButton")
	okButton.visible = false
	self.currentNestIndex = nil
	
	for i = 1, 4 do 
		local recipeButton = self:getChild("recipeButton" .. i)	
		recipeButton.visible = false
	end
	
	
end

function BirdDesigner2SelectionFrame:setup(eventOk, eventCancel, hatcheryNests, hatcheryEggs, hatcheryAccessories)
	
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
	
	for nestIndex = 1, #self.nestSprites do
		for eggIndex = 1, #self.eggSprites do
			for accessoryUpIndex = 1, #self.accessorySlot3Sprites do
				for accessoryDownIndex = 1, #self.accessorySlot2Sprites do
				
					local id = self:getId(nestIndex, eggIndex, accessoryUpIndex, accessoryDownIndex)
					local existingItemButton = self:getChild("itemButton" .. itemCounter)
			
					if existingItemButton ~= nil then
						self:removeChild(existingItemButton)
					end	
					
					itemCounter = itemCounter + 1
					
				end
			end
		end
	end
	
	self.lastClickedButton = nil	
	
	itemCounter = 1
		
	for nestIndex = 1, #self.nestSprites do
		for eggIndex = 1, #self.eggSprites do
			for accessoryUpIndex = 1, #self.accessorySlot3Sprites do
				for accessoryDownIndex = 1, #self.accessorySlot2Sprites do
				
					local id = self:getId(nestIndex, eggIndex, accessoryUpIndex, accessoryDownIndex)
					local itemButton = ui.ScallableButton:new()
					itemButton.name = "itemButton" .. itemCounter
					itemButton:setImage("H_BTN_PLAZA")
					itemButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_ITEM_SELECTED	
					itemButton.combinationId = id
					itemButton.objectId = itemCounter
					itemButton.nestIndex = nestIndex
					itemButton.eggIndex = eggIndex
					itemButton.accessoryUpIndex = accessoryUpIndex
					itemButton.accessoryDownIndex = accessoryDownIndex
					self:addChild(itemButton)	
					itemButton.activateOnRelease = true

					itemCounter = itemCounter + 1
					
				end
			end
		end
	end
	
	local totalItems = #self.nestSprites * #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
		
	for i = 1, totalItems do 
		local itemButton = self:getChild("itemButton" .. i)	
		itemButton.visible = false
	end
	
	for nestIndex = 1, #self.nestSprites do
		local nestButton = ui.ScallableButton:new()
		nestButton.name = "nestButton" .. nestIndex
		nestButton:setImage(self.nestSprites[nestIndex])
		nestButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_2_NEST_BUTTON			
		nestButton.index = nestIndex
		self:addChild(nestButton)	
		nestButton.activateOnRelease = true
	end
	
	for recipeIndex = 1, 4 do
		local recipeButton = ui.ScallableButton:new()
		recipeButton.name = "recipeButton" .. recipeIndex
		recipeButton:setImage(self.nestSprites[1])
		recipeButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_2_NEST_BUTTON			
		recipeButton.index = nestIndex
		recipeButton.visible = false
		self:addChild(recipeButton)
		recipeButton.activateOnRelease = true
	end
	
	self:layout()
	
	self:setupVisibleItems()
	
	
end

function BirdDesigner2SelectionFrame:getClickedButtonItem()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton			
	end
	
	return nil
end


function BirdDesigner2SelectionFrame:layout()
	Frame.layout(self)	
	
	local buttonsY = gamelua.screenHeight - 50
	local buttonX = 100
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.y = buttonsY
	cancelButton.x = gamelua.screenWidth * 0.5 - buttonX
	local okButton = self:getChild("okButton")	
	okButton.y = buttonsY
	okButton.x = gamelua.screenWidth * 0.5 + buttonX		
	
	local allNestsButton = self:getChild("allNestsButton")	
	allNestsButton.y = 60
	allNestsButton.x = gamelua.screenWidth  - 100
	
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
		local totalItems = #self.nestSprites * #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
		
		for i = 1, totalItems do 
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
	
	self:layoutNestButtons()
end


function BirdDesigner2SelectionFrame:layoutNestButtons()
	Frame.layout(self)	
	
	
	local index = 0
	
	
	self.cellMaxWidth = 100
	self.cellMaxHeight = 100
	
	local gridWidthRatio = 0.8
	local gridHeightRatio = 0.4
	
	local totalCols = (gamelua.screenWidth * gridWidthRatio) / self.cellMaxWidth
	-- local totalRows = (gamelua.screenHeight * gridHeightRatio) / cellMaxHeight
	
	local startX = gamelua.screenWidth * 0.5 - (gamelua.screenWidth * gridWidthRatio) * 0.5
	local startY = gamelua.screenHeight * 0.5 - (gamelua.screenHeight * gridHeightRatio) * 0.5
	
	startY = 10
	
	
	
	totalCols = _G.math.floor(totalCols)
	

	local totalNests = #self.nestSprites
	
	for i = 1, totalNests do 
		local nestButton = self:getChild("nestButton" .. i)	
		local nestButtonPivotX, nestButtonPivotY = _G.res.getSpritePivot("", nestButton.image)	

		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)			

		local celPosX = startX + colIndex * self.cellMaxWidth + self.cellMaxWidth * 0.5
		local celPosY = startY + rowIndex * self.cellMaxHeight + self.cellMaxHeight * 0.5
		
		local scaleX = self.cellMaxWidth / nestButton.w
		local scaleY = self.cellMaxHeight / nestButton.h
		
		local scale = _G.math.min(scaleX, scaleY)
		scale = _G.math.min(scale, 1)
		
		nestButton.scaleX = scale
		nestButton.scaleY = scale
		
		nestButton.x = celPosX + nestButtonPivotX - nestButton.w * 0.5
		nestButton.y = celPosY + nestButtonPivotY - nestButton.h * 0.5	

		nestButton.x = celPosX + nestButtonPivotX * scale - nestButton.w * scale * 0.5
		nestButton.y = celPosY + nestButtonPivotY * scale - nestButton.h * scale * 0.5				
		
		index = index + 1
	end
	
	
end

function BirdDesigner2SelectionFrame:setupRecipeButtons()
	Frame.layout(self)	
	
	if self.lastClickedButton ~= nil then
		
		local index = 0
		
		
		
		self.recipeMaxWidth = 70
		self.recipeMaxHeight = 70
		
		local gridWidthRatio = 0.8
		local gridHeightRatio = 0.4
		
		local totalCols = 4
		
		local startX = gamelua.screenWidth * 0.5 - (totalCols * self.recipeMaxWidth) * 0.5
		local startY = gamelua.screenHeight * 0.5 - (gamelua.screenHeight * gridHeightRatio) * 0.5
		
		startY = gamelua.screenHeight - 170
		
		
		
		totalCols = _G.math.floor(totalCols)	
		
		local items = {self.nestSprites, self.eggSprites, self.accessorySlot3Sprites, self.accessorySlot2Sprites}
		local indices = {self.lastClickedButton.nestIndex, self.lastClickedButton.eggIndex, self.lastClickedButton.accessoryUpIndex, self.lastClickedButton.accessoryDownIndex}
		
		for i = 1, 4 do 
			local recipeButton = self:getChild("recipeButton" .. i)	
			recipeButton:setImage(items[i][ indices[i] ])
			local nestButtonPivotX, nestButtonPivotY = _G.res.getSpritePivot("", recipeButton.image)	

			local rowIndex = _G.math.floor(index / totalCols)
			local colIndex = _G.math.fmod(index, totalCols)			

			local celPosX = startX + colIndex * self.recipeMaxWidth + self.recipeMaxWidth * 0.5
			local celPosY = startY + rowIndex * self.recipeMaxHeight + self.recipeMaxHeight * 0.5
			
			local scaleX = self.recipeMaxWidth / recipeButton.w
			local scaleY = self.recipeMaxHeight / recipeButton.h
			
			local scale = _G.math.min(scaleX, scaleY)
			scale = _G.math.min(scale, 1)
			
			recipeButton.scaleX = scale
			recipeButton.scaleY = scale
			
			recipeButton.x = celPosX + nestButtonPivotX - recipeButton.w * 0.5
			recipeButton.y = celPosY + nestButtonPivotY - recipeButton.h * 0.5	

			recipeButton.x = celPosX + nestButtonPivotX * scale - recipeButton.w * scale * 0.5
			recipeButton.y = celPosY + nestButtonPivotY * scale - recipeButton.h * scale * 0.5				
			recipeButton.visible = true
			
			index = index + 1
		end
		
	else
		for i = 1, 4 do 
			local recipeButton = self:getChild("recipeButton" .. i)																
			recipeButton.visible = false			
		end
	end
end

function BirdDesigner2SelectionFrame:draw(x, y)
	
	ui.Frame.draw(self, x, y)	
	
	if self.currentNestIndex ~= nil then
	
		
		-- for k,v in _G.pairs(self.items) do 
		local totalItemsPerNest = #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
		local startIndex = (self.currentNestIndex - 1) * totalItemsPerNest + 1
		
		local totalItems = #self.nestSprites * #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
		local birdIndex = 1
		for i = startIndex, (startIndex + totalItemsPerNest - 1) do 
			local itemButton = self:getChild("itemButton" .. i)	
			
			
			
			
			
			--self:drawBird(itemButton.nestIndex, itemButton.eggIndex, itemButton.accessoryUpIndex, itemButton.accessoryDownIndex, itemButton.x, itemButton.y, 0, itemButton.objectId)
			self:drawBird(itemButton.nestIndex, itemButton.eggIndex, itemButton.accessoryUpIndex, itemButton.accessoryDownIndex, itemButton.x, itemButton.y, 0, i)
			birdIndex = birdIndex + 1
		end
		
		
	else
		
		local totalItems = #self.nestSprites * #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
		local birdIndex = 1
		for i = 1, totalItems do 
			local itemButton = self:getChild("itemButton" .. i)																
			-- self:drawBird(itemButton.nestIndex, itemButton.eggIndex, itemButton.accessoryUpIndex, itemButton.accessoryDownIndex, itemButton.x, itemButton.y, 0, itemButton.objectId)
			self:drawBird(itemButton.nestIndex, itemButton.eggIndex, itemButton.accessoryUpIndex, itemButton.accessoryDownIndex, itemButton.x, itemButton.y, 0, birdIndex)
			birdIndex = birdIndex + 1
		end
	end
end

function BirdDesigner2SelectionFrame:setupVisibleItems()
	if self.currentNestIndex ~= nil then			
		
		local index = 0
		
		self.cellMaxWidth = 50
		self.cellMaxHeight = 50
		
		local gridWidthRatio = 0.8
		local gridHeightRatio = 0.4
		
		local totalCols = (gamelua.screenWidth * gridWidthRatio) / self.cellMaxWidth
		
		local startX = gamelua.screenWidth * 0.5 - (gamelua.screenWidth * gridWidthRatio) * 0.5
		local startY = gamelua.screenHeight * 0.5 - (gamelua.screenHeight * gridHeightRatio) * 0.5
		
		
		
		totalCols = _G.math.floor(totalCols)
		
		local itemCounter = 1
		if self.items ~= nil then
			-- for k,v in _G.pairs(self.items) do 
			local totalItemsPerNest = #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
			local startIndex = (self.currentNestIndex - 1) * totalItemsPerNest + 1
			
			local totalItems = #self.nestSprites * #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
			
			for i = 1, totalItems do 
				local itemButton = self:getChild("itemButton" .. i)	
				local itemButtonPivotX, itemButtonPivotY = _G.res.getSpritePivot("", itemButton.image)	
				
				itemButton.visible = i >= startIndex and i <= (startIndex + totalItemsPerNest - 1)

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
		
	else
		local totalItems = #self.nestSprites * #self.eggSprites * #self.accessorySlot3Sprites * #self.accessorySlot2Sprites
		
		for i = 1, totalItems do 
			local itemButton = self:getChild("itemButton" .. i)		
			itemButton.visible = true
		end
	end
	
	self:layout()
end

function BirdDesigner2SelectionFrame:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == hatcheryEvents.EID_BIRD_DESIGNER_ITEM_SELECTED then		
		self.lastClickedButton = meta
		local okButton = self:getChild("okButton")
		okButton.visible = true
		self:setupRecipeButtons()
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_2_NEST_BUTTON then		
		self.currentNestIndex = meta.index
		self:setupVisibleItems()
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_2_ALL_NESTS_BUTTON then
		self.lastClickedButton = nil
		self.currentNestIndex = nil
		local okButton = self:getChild("okButton")
		okButton.visible = false
		self:setupRecipeButtons()
		self:setupVisibleItems()
	end
	
	return result, meta
end

function BirdDesigner2SelectionFrame:drawBird(nestIndex, eggIndex, accessoryUpIndex, accessoryDownIndex, x, y, angle, objectId, scale)
	
	-- if self.prefabsTableToUse[objectId] == nil then
		-- if scale == nil then
			-- self.cellMaxWidth = 50
			-- self.cellMaxHeight = 50
			-- local bodyW, bodyH = _G.res.getSpriteBounds("", gamelua.hatcheryBirds["BODIES"][nestIndex])
			-- local scaleX = self.cellMaxWidth / bodyW
			-- local scaleY = self.cellMaxHeight / bodyH
			
			-- scale = _G.math.min(scaleX, scaleY)
		-- end
		
		-- local birdTable = 	{	{	sprite=gamelua.hatcheryBirds["BODIES"][nestIndex], x=0, y=0, scale=1, angle = 0} ,
								-- { 	sprite=gamelua.hatcheryBirds["BEAKS"][nestIndex], x = 0, y=0, scale=1, angle=0}, 
								-- {	sprite=gamelua.hatcheryBirds["EYES"][nestIndex], x=0, y=0, scale=1, angle = 0} } 
		-- gamelua.drawCompoObjectLua(x,y ,angle, scale, birdTable)

	-- else
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
	-- end

end

function BirdDesigner2SelectionFrame:getBiggestSpriteInList(list)
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



function BirdDesigner2SelectionFrame:getId(nestIndex, eggIndex, accessoryUpIndex, accessoryDownIndex)
	return ("N" .. nestIndex .. "_E" .. eggIndex .. "_AU" .. accessoryUpIndex .. "_AD" .. accessoryDownIndex)
end


filename="BirdDesigner2SelectionFrame.lua"
