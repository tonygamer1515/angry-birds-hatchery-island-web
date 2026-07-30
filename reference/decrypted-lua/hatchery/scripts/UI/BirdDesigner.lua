BirdDesigner = ui.Frame:new()
Frame = ui.Frame

function BirdDesigner:init()
	Frame.init(self)	
	
	-- self.prefabsTableToUse = gamelua.hatcheryBirdsSaves
	self.prefabsTableToUse = gamelua.Hatchery.getBirds()

	
	self.worldScale = 1
	-- self.prefabsTableToUse = gamelua.hatcheryBirdsPrefabs
	-- self.worldScale = 20
	
	self.fontScaleSmall = 0.5		
	
	
	local backButton = ui.ScallableButton:new()
	backButton.name = "backButton"
	backButton:setImage("H_BTN_SHUT_DOWN")
	backButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_BACK	
	self:addChild(backButton)
	backButton.sound = getHatcherySound("ok")
	backButton.activateOnRelease = true
	
	local slotsButton = ui.ScallableButton:new()
	slotsButton.name = "slotsButton"
	slotsButton:setImage("H_BTN_PLAZA")
	slotsButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_2_OPEN_SLOTS	
	self:addChild(slotsButton)
	slotsButton.sound = getHatcherySound("ok")
	slotsButton.activateOnRelease = true
	
	-- local itemNameText = ui.Text:new()
	-- itemNameText.name = "itemNameText"
	-- itemNameText.font = "FONT_HATCHERY"
	-- itemNameText.text = "Level " .. hatchery:getPlayerRank()	
	-- self:addChild(itemNameText)	
	
	self.bodyX, self.bodyY = gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.5
	
	for recipeIndex = 1, 4 do
		local recipeButton = ui.ScallableButton:new()
		recipeButton.name = "recipeButton" .. recipeIndex
		recipeButton:setImage("H_BTN_PLAZA")
		recipeButton.returnValue = hatcheryEvents.EID_BIRD_DESIGNER_2_NEST_BUTTON			
		recipeButton.index = nestIndex
		recipeButton.visible = false
		self:addChild(recipeButton)	
		recipeButton.activateOnRelease = true
	end
	
	
	--POP UPS
	
	local itemSelectionFrame = BirdDesignerSelectionFrame:new()
	itemSelectionFrame.name = "itemSelectionFrame"
	itemSelectionFrame.visible = false
	self:addChild(itemSelectionFrame)
	local okButton = itemSelectionFrame:getChild("okButton")
	okButton.sound = getHatcherySound("ok")
	local cancelButton = itemSelectionFrame:getChild("cancelButton")
	cancelButton.sound = getHatcherySound("cancel")
	-- itemSelectionFrame:setup(hatcheryEvents.EID_BIRD_DESIGNER_ITEMS_OK, hatcheryEvents.EID_BIRD_DESIGNER_ITEMS_CANCEL, self.hatchery:getNests(), nil, nil, nil)
	
	
	
	self.currentFrame = nil
	
	
end


function BirdDesigner:layout()

	local backButton = self:getChild("backButton")
	local backOffsetX = 20
	local backOffsetY = 15
	local backPivotX, backPivotY = _G.res.getSpritePivot("", backButton.image)
	backButton.x = backOffsetX + backPivotX
	backButton.y = gamelua.screenHeight - (backButton.w - backPivotY) - backOffsetY 
	
	
	local slotsButton = self:getChild("slotsButton")
	local slotsPivotX, slotsPivotY = _G.res.getSpritePivot("", slotsButton.image)
	slotsButton.x = gamelua.screenWidth - (slotsButton.w - slotsPivotX) - backOffsetX
	slotsButton.y = backButton.y
	
	
	-- local itemNameText = self:getChild("itemNameText")
	-- itemNameText.x, itemNameText.y = gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.04
	-- playerRankText.scaleX, playerRankText.scaleY = 0.4, 0.4
	
	
	
	
	Frame.layout(self)	
	
end

function BirdDesigner:setupRecipeButtons()
	
	if self.selectedItem ~= nil then
		
		local index = 0		
			
		local cellMaxWidth = 100
		local cellMaxHeight = 100	
		
		local totalCols = 1
		
		local startX = 50
		local startY = 200
		
		-- local items = {gamelua.hatcheryItems["NESTS"], gamelua.hatcheryItems["EGGS"], gamelua.hatcheryItems["ACCESSORY_UP"], gamelua.hatcheryItems["ACCESSORY_DOWN"]}
		local indices = {self.selectedItem.nestIndex, self.selectedItem.eggIndex, self.selectedItem.accessoryUpIndex, self.selectedItem.accessoryDownIndex}
			
		local buttons = {}
		
	else
		for i = 1, 4 do 
			local recipeButton = self:getChild("recipeButton" .. i)	
			recipeButton.visible = false
			
		end
	end
end



function BirdDesigner:setHatchery(hatchery)
	self.hatchery = hatchery
	
	
	
end
		
function BirdDesigner:openFrame(frame)
	self.currentFrame = frame
	frame.visible = true
	
end

function BirdDesigner:closeCurrentFrame()
	if self.currentFrame ~= nil then
		self.currentFrame.visible = false
	end
	
	
end

function BirdDesigner:setSelection(nestIndex, eggIndex, accessoryUpIndex, accessoryDownIndex, accessoryMiddleIndex,  objectId)
	self.nestIndex = nestIndex
	self.eggIndex = eggIndex
	self.accessoryUpIndex = accessoryUpIndex
	self.accessoryDownIndex = accessoryDownIndex 
	self.accessoryMiddleIndex = accessoryMiddleIndex 
	self.objectId = objectId
end

function BirdDesigner:showUnderView()
	if self.selectedItem ~= nil then
		for i = 1, 4 do 
			local recipeButton = self:getChild("recipeButton" .. i)	
			recipeButton.visible = true
		end
	end
end

function BirdDesigner:hideUnderView()
	for i = 1, 4 do 
		local recipeButton = self:getChild("recipeButton" .. i)	
		recipeButton.visible = false
	end
end


function BirdDesigner:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	local itemSelectionFrame = self:getChild("itemSelectionFrame")
	
	local itemNameText = self:getChild("itemNameText")
	
	if result == hatcheryEvents.EID_BIRD_DESIGNER_BACK then
		hatcheryEventManager:notify({id = hatcheryEvents.EID_HATCHERY_GOTO_EPISODE_SELECTION})
	
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_ITEMS_CANCEL then
		self:closeCurrentFrame()
		self:setSelection()
		self:showUnderView()
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_ITEM_SELECTED then
		
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_ITEMS_OK then
		self.selectedItem = itemSelectionFrame:getClickedButtonItem()
		if self.selectedItem ~= nil then
			self:closeCurrentFrame()
			self:setSelection(self.selectedItem.nestIndex, self.selectedItem.eggIndex, self.selectedItem.accessoryUpIndex, self.selectedItem.accessoryDownIndex, self.selectedItem.objectId)
		end
		self:setupRecipeButtons()
		self:setupBirdForEditing()
		self:showUnderView()
	elseif result == hatcheryEvents.EID_BIRD_DESIGNER_2_OPEN_SLOTS	then
		-- self.selectedItem = nil
		-- self:setupRecipeButtons()
		-- self:setupBirdForEditing()
		itemSelectionFrame:reset()
		self:openFrame(itemSelectionFrame)
		self:hideUnderView()
	
	end		
	
	return result, meta
end

function BirdDesigner:update(dt, time) 
	ui.Frame.update(self, dt, time) 
	
	if self.lastCursor == nil then
		self.lastCursor = {x = gamelua.cursor.x, y = gamelua.cursor.y}
	end
	
	if gamelua.keyPressed["RETURN"] then
		-- self.hatchery:addBirdToSelectedBirds(self.selectedItem.objectId)
		self.hatchery:addBirdToSelectedBirds(self.hatchery:getBirds()[self.selectedItem.objectId])
	end
	
	if gamelua.keyPressed["D"] then
		if self.debugDrawing == true then
			self.debugDrawing = nil
		else
			self.debugDrawing = true
		end
	end
	
	local keyAddPressed = nil
	local keyAddDirection = nil
	for k,v in _G.pairs(gamelua.hatcheryBirdsKeys) do
		for kk, vv in _G.pairs(v) do
			local keyPressed = gamelua.keyPressed[vv]
			
			if keyPressed then
				keyAddPressed = k
				keyAddDirection = kk
				break
			end
		end
	end
	
	if keyAddPressed ~= nil then
		
		local index = 0
		
		if keyAddPressed == "ACCESSORY_UP" then
			if self.accessoryUp ~= nil then
				index = self:getIndexInTable(Bird.Sprites.AccessoryTop, self.accessoryUp.sprite)
				local entryIndex = self:getIndexInTable(self.birdPieces, self.accessoryUp)
				_G.table.remove(self.birdPieces, entryIndex)
			end
			
			if keyAddDirection == "up" then
				index = index + 1
			else
				index = index - 1
			end
			
			if index < 1 then
				index = #Bird.Sprites.AccessoryTop
			elseif index > #Bird.Sprites.AccessoryTop then
				index = 1
			end
			
			local accessorySprite = Bird.Sprites.AccessoryTop[index]
			self.accessoryUp = {sprite = accessorySprite, x = 0, y = 0, scale = 1, angle = 0}
			_G.table.insert(self.birdPieces, self.accessoryUp)
			self:recalculateBirdPiecesIndices()
		elseif keyAddPressed == "ACCESSORY_DOWN" then
			
			if self.accessoryDown ~= nil then
				index = self:getIndexInTable(Bird.Sprites.AccessoryBottom, self.accessoryDown.sprite)
				local entryIndex = self:getIndexInTable(self.birdPieces, self.accessoryDown)
				_G.table.remove(self.birdPieces, entryIndex)
			end
			
			if keyAddDirection == "up" then
				index = index + 1
			else
				index = index - 1
			end
			
			if index < 1 then
				index = #Bird.Sprites.AccessoryBottom
			elseif index > #Bird.Sprites.AccessoryBottom then
				index = 1
			end
			
			local accessorySprite = Bird.Sprites.AccessoryBottom[index]
			self.accessoryDown = {sprite = accessorySprite, x = 0, y = 0, scale = 1, angle = 0}
			_G.table.insert(self.birdPieces, self.accessoryDown)
			self:recalculateBirdPiecesIndices()
		else
		--middle
			if self.accessoryMiddle ~= nil then
				index = self:getIndexInTable(Bird.Sprites.AccessoryMiddle, self.accessoryMiddle.sprite)
				local entryIndex = self:getIndexInTable(self.birdPieces, self.accessoryMiddle)
				_G.table.remove(self.birdPieces, entryIndex)
			end
			
			if keyAddDirection == "up" then
				index = index + 1
			else
				index = index - 1
			end
			
			if index < 1 then
				index = #Bird.Sprites.AccessoryMiddle
			elseif index > #Bird.Sprites.AccessoryMiddle then
				index = 1
			end
			
			local accessorySprite = Bird.Sprites.AccessoryMiddle[index]
			self.accessoryMiddle = {sprite = accessorySprite, x = 0, y = 0, scale = 1, angle = 0}
			_G.table.insert(self.birdPieces, self.accessoryMiddle)
			self:recalculateBirdPiecesIndices()
		end
		
		
	end
	
	if gamelua.keyPressed["SPACE"] and gamelua.keyHold["CONTROL"] and self.selectedObject ~= nil then
		self.selectedObject.x = 0
		self.selectedObject.y = 0
		self.selectedObject.angle = 0
		self.selectedObject.scale = 1
	end
	
	if gamelua.keyPressed["X"] and gamelua.keyHold["SHIFT"] and self.selectedItem ~= nil then
		self:nextBirdShape()
	end
	
	if gamelua.keyPressed["C"] and gamelua.keyHold["SHIFT"] and self.selectedItem ~= nil then
		self:nextBirdColor()
	end
	
	if gamelua.keyPressed["V"] and gamelua.keyHold["SHIFT"] and self.selectedItem ~= nil then
		self:nextBirdEyes()
	end
	
	if gamelua.keyPressed["B"] and gamelua.keyHold["SHIFT"] and self.selectedItem ~= nil then
		self:nextBirdBeak()
	end
	
	if gamelua.keyPressed["TAB"] then
		
		if self.selectedObject == nil then
			
			if self.birdPieces ~= nil then
				self.selectedObject = self.birdPieces[1]
				
			end
		else
			local index = self:getIndexInTable(self.birdPieces, self.selectedObject)
			
			self.selectedObject = self.birdPieces[_G.math.fmod(index, #self.birdPieces) + 1]
		end
	end
	
	if gamelua.keyPressed["S"] and gamelua.keyHold["CONTROL"] then
		self:save()
		self:recalculateDefaultBirds()
	end
	
	if (gamelua.keyPressed["SUBTRACT"] or gamelua.keyPressed["ADD"] )then
		
		local offset = 0
		
		if gamelua.keyPressed["SUBTRACT"] then
			offset = -1
		elseif gamelua.keyPressed["ADD"] then
			offset = 1
		end
		
		if self.selectedObject ~= nil then
			local index = self:getIndexInTable(self.birdPieces, self.selectedObject)
			local newIndex = index + offset
			newIndex = _G.math.min(newIndex, #self.birdPieces)
			newIndex = _G.math.max(newIndex, 1)
			
			if index ~= newIndex then
				local tableToRemove = self.birdPieces[index]
				_G.table.remove(self.birdPieces, index)
				_G.table.insert(self.birdPieces, newIndex, tableToRemove)
			end
			self:recalculateBirdPiecesIndices()
			
			
		end
			
	end
	
	local transformingItem = false
	
	-- local isBody = self.selectedObject ~= nil and self:getIndexInTable(gamelua.hatcheryBirdItems["BODIES"], self.selectedObject.sprite) > 0
	local isBody = self.selectedObject ~= nil and self:isBodySprite( self.selectedObject.sprite) 
	
	if gamelua.keyHold["CONTROL"] and gamelua.keyHold["LBUTTON"] and self.selectedObject ~= nil --[[and not isBody]] then		
		
		local factor = 0.01
		
		if gamelua.keyHold["SHIFT"] then
			factor = factor * 0.1
		end
		
		self.selectedObject.angle = self.selectedObject.angle + ( (gamelua.cursor.x - self.lastCursor.x) * factor)
		
		transformingItem = true
	end
	
	
	
	if gamelua.keyHold["CONTROL"] and gamelua.keyHold["RBUTTON"] and self.selectedObject ~= nil --[[and not isBody]] then		
		
		local factor = 0.01
		
		if gamelua.keyHold["SHIFT"] then
			factor = factor * 0.1
		end
		
		self.selectedObject.scale = self.selectedObject.scale + ( (gamelua.cursor.x - self.lastCursor.x) * factor)
		
		transformingItem = true
	end
	
	if gamelua.keyPressed["DELETE"] and self.selectedObject ~= nil and (self.selectedObject == self.accessoryUp or self.selectedObject == self.accessoryDown or self.selectedObject == self.accessoryMiddle) then
		
		local index = self:getIndexInTable(self.birdPieces, self.selectedObject)
		
		local tableToRemove = self.birdPieces[index]
		_G.table.remove(self.birdPieces, index)
		
	end
	
	if gamelua.keyHold["LBUTTON"] and self.selectedObject ~= nil and not transformingItem and not isBody then
	
		if self.movingObject == nil then
			if self:checkObjectBounds(self.selectedObject) then
				self.movingObject = self.selectedObject
			end
		end
		
		if self.movingObject ~= nil then
		
			self.selectedObject.x = self.selectedObject.x + ( (gamelua.cursor.x - self.lastCursor.x))
			self.selectedObject.y = self.selectedObject.y + ( (gamelua.cursor.y - self.lastCursor.y))
		end
		
	else
		self.movingObject = nil
	end
	
	
	
	if self.selectedObject ~= nil and not isBody then
		local movingKeys = { {key = "LEFT", x=-1, y= 0}, {key = "RIGHT", x=1, y= 0}, {key = "UP", x=0, y= -1},{key = "DOWN", x=0, y= 1}}
		for k, v in _G.pairs(movingKeys) do
			if gamelua.keyPressed[v.key] then
				local factor = 1
				
				if gamelua.keyHold["SHIFT"] then
					factor = 10
				end
				
				self.selectedObject.x = self.selectedObject.x + v.x * factor
				self.selectedObject.y = self.selectedObject.y + v.y * factor
			end
		end
	end
	
	
	if gamelua.keyPressed["RBUTTON"] and not transformingItem then
	
		if self.birdPieces ~= nil then
			local candidates = {}
			for k, v in _G.pairs(self.birdPieces) do	
				
				if self:checkObjectBounds(v) then
					_G.table.insert(candidates, v)
				end	
			end
			
			local maxLayer = -1
			self.selectedObject = nil 
			for k, v in _G.pairs(candidates) do
				local index = self:getIndexInTable(self.birdPieces, v)
				
				if index > maxLayer then
					maxLayer = index
					self.selectedObject = v
				end
			end
			
		end
	end
	
	self.lastCursor = {x = gamelua.cursor.x, y = gamelua.cursor.y}
end

function BirdDesigner:isBodySprite(sprite)
	for k,v in _G.pairs(Bird.Sprites.Body) do
		for kk, vv in _G.pairs(v) do
			if sprite == vv then
				return true
			end
		end
	end
	
	return false
	
end

function BirdDesigner:checkObjectBounds(object)
	local px, py = _G.res.getSpritePivot("", object.sprite)
	local scale = object.scale
	
	local w, h = _G.res.getSpriteBounds("", object.sprite)				
	local px, py = _G.res.getSpritePivot("", object.sprite)
	
	--local space
	local ul = {x = -px*scale, y = -py *scale}
	local ur = {x = -px*scale + w * scale, y = -py *scale}
	local bl = {x = -px*scale , y = -py *scale + h *scale}
	local br = {x = -px*scale + w *scale, y = -py *scale + h *scale}
	
	local ulTransformed = self:transformCoordinates(object.angle, ul.x, ul.y)
	local urTransformed = self:transformCoordinates(object.angle, ur.x, ur.y)
	local blTransformed = self:transformCoordinates(object.angle, bl.x, bl.y)
	local brTransformed = self:transformCoordinates(object.angle, br.x, br.y)								
	
	ul.x = self.bodyX + ulTransformed.x + object.x
	ul.y = self.bodyY + ulTransformed.y + object.y
	
	ur.x = self.bodyX + urTransformed.x + object.x
	ur.y = self.bodyY + urTransformed.y + object.y
	
	bl.x = self.bodyX + blTransformed.x + object.x
	bl.y = self.bodyY + blTransformed.y + object.y
	
	br.x = self.bodyX + brTransformed.x + object.x
	br.y = self.bodyY + brTransformed.y + object.y
	
	
	local vector = {x = br.x - ul.x, y = br.y - ul.y}
	local vectorNormalize = self:normalize(vector.x, vector.y)
	size = self:getDistance(br.x, br.y, ul.x, ul.y)
	
	local x = ul.x + vectorNormalize.x * size * 0.5
	local y = ul.y + vectorNormalize.y * size * 0.5
	
	return gamelua.checkObjectBounds(x, y, w * scale, h * scale, object.angle, gamelua.cursor.x, gamelua.cursor.y)
end

function BirdDesigner:getDistance(x1,y1,x2,y2)
	return _G.math.sqrt( (x2-x1) * (x2-x1) + (y2-y1) * (y2-y1))
end

function BirdDesigner:normalize(x,y)
	local size = self:getDistance(x,y,0,0)
	return {x = x / size, y = y / size}
end

function BirdDesigner:transformCoordinates(angle, x, y)
	local c = _G.math.cos(angle)
	local s = _G.math.sin(angle)
	
	return {x = c * x + (-s) * y, y = s * x + c * y}
	
end

function BirdDesigner:onEntry()	
	
	
	
	local itemSelectionFrame = self:getChild("itemSelectionFrame")
	itemSelectionFrame:setup(hatcheryEvents.EID_BIRD_DESIGNER_ITEMS_OK, hatcheryEvents.EID_BIRD_DESIGNER_ITEMS_CANCEL, self.hatchery:getNests(), self.hatchery:getEggs(), self.hatchery:getNestAccessories())
	
	if self.selectedItem == nil then
		local itemSelectionFrame = self:getChild("itemSelectionFrame")
		itemSelectionFrame:reset()
		self:openFrame(itemSelectionFrame)
		self:hideUnderView()
	end
	
	self.nestSprites = {}
	self.eggSprites = {}
	
	--remember the empty slots
	self.accessorySlot2Sprites = {""}
	self.accessorySlot3Sprites = {""}		
	
	local hatcheryNests = self.hatchery:getNests()
	local hatcheryEggs = self.hatchery:getEggs()
	local hatcheryAccessories = self.hatchery:getNestAccessories()
	
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
	-- self:layout()
end

function BirdDesigner:recalculateBirdPiecesIndices()
			--recalculates the basic items indices, only changes if the layering order has changed
		local basicBodySprite = Bird.Sprites.Body[self.prefabsTableToUse[self.selectedItem.objectId].shape][self.prefabsTableToUse[self.selectedItem.objectId].color]
		local basicBeakSprite = Bird.Sprites.Beaks[self.prefabsTableToUse[self.selectedItem.objectId].beak]
		local basicEyesSprite = Bird.Sprites.Eyes[self.prefabsTableToUse[self.selectedItem.objectId].eyes]
		
		self.prefabsTableToUse[self.selectedItem.objectId].bodyIndex = self:getSpriteIndexInList(self.birdPieces, basicBodySprite)
		self.prefabsTableToUse[self.selectedItem.objectId].beakIndex = self:getSpriteIndexInList(self.birdPieces, basicBeakSprite)
		self.prefabsTableToUse[self.selectedItem.objectId].eyesIndex = self:getSpriteIndexInList(self.birdPieces, basicEyesSprite)
		
		local finalTable = {}
		for k, v in _G.pairs(self.birdPieces) do
			-- _G.table.insert(finalTable, {sprite = v.sprite, x = (v.x)  / self.worldScale, y = (v.y) / self.worldScale, scale = v.scale, angle = v.angle})
			_G.table.insert(finalTable, { sprite = v.sprite, x = (v.x)  / self.worldScale, y = (v.y) / self.worldScale, scale = v.scale, angle = v.angle})
		end
		self.prefabsTableToUse[self.selectedItem.objectId].sprites = finalTable
		
		self:setBirdSprites(self.prefabsTableToUse[self.selectedItem.objectId])
end

function BirdDesigner:setupBirdForEditing()

	self.selectedObject = nil
	
	if self.selectedItem ~= nil then
		-- if self.prefabsTableToUse[self.selectedItem.objectId] ~= nil then
			self.birdPieces = {}
			
			self.accessoryUp = nil
			self.accessoryDown = nil
			self.accessoryMiddle = nil
			
			for k, v in _G.pairs(self.prefabsTableToUse[self.selectedItem.objectId].sprites) do
				local entryTable = {combinationId = v.combinationId, sprite = v.sprite, x = v.x * self.worldScale, y = v.y * self.worldScale, scale = v.scale, angle = v.angle}
				_G.table.insert(self.birdPieces, entryTable)
				
				local index = self:getIndexInTable(Bird.Sprites.AccessoryTop, entryTable.sprite)
				if index > 0 then		
					gamelua.print("\n setting up "  .. entryTable.sprite)
					self.accessoryUp = entryTable				
				end 
				
				index = self:getIndexInTable(Bird.Sprites.AccessoryBottom, entryTable.sprite)
				if index > 0 then
					gamelua.print("\n setting down "  .. entryTable.sprite)
					self.accessoryDown = entryTable				
				end 
				
				index = self:getIndexInTable(Bird.Sprites.AccessoryMiddle, entryTable.sprite)
				if index > 0 then
					gamelua.print("\n setting middle "  .. entryTable.sprite)
					self.accessoryMiddle = entryTable				
				end 
			end
		-- else
			-- self.birdPieces = {}
			
			-- local bodySprite = gamelua.hatcheryBirdItems["BODIES"][self.selectedItem.nestIndex]
			-- _G.table.insert(self.birdPieces, {sprite = bodySprite, x = 0, y = 0, scale = 1, angle = 0})
			
			-- local bodySprite = gamelua.hatcheryBirdItems["EYES"][self.selectedItem.nestIndex]
			-- _G.table.insert(self.birdPieces, {sprite = bodySprite, x = 0, y = 0, scale = 1, angle = 0})
			
			-- local bodySprite = gamelua.hatcheryBirdItems["BEAKS"][self.selectedItem.nestIndex]
			-- _G.table.insert(self.birdPieces, {sprite = bodySprite, x = 0, y = 0, scale = 1, angle = 0})
			
			-- self.accessoryUp = nil
			-- self.accessoryDown = nil
		-- end
	else
		self.birdPieces = {}
	end
end

function BirdDesigner:save()
	
	
	if self.selectedItem ~= nil then
		local finalTable = {}
		for k, v in _G.pairs(self.birdPieces) do
			-- _G.table.insert(finalTable, {sprite = v.sprite, x = (v.x)  / self.worldScale, y = (v.y) / self.worldScale, scale = v.scale, angle = v.angle})
			_G.table.insert(finalTable, { sprite = v.sprite, x = (v.x)  / self.worldScale, y = (v.y) / self.worldScale, scale = v.scale, angle = v.angle})
		end
		self.prefabsTableToUse[self.selectedItem.objectId].sprites = finalTable
		
		--recalculates the basic items indices, only changes if the layering order has changed
		local basicBodySprite = Bird.Sprites.Body[self.prefabsTableToUse[self.selectedItem.objectId].shape][self.prefabsTableToUse[self.selectedItem.objectId].color]
		local basicBeakSprite = Bird.Sprites.Beaks[self.prefabsTableToUse[self.selectedItem.objectId].beak]
		local basicEyesSprite = Bird.Sprites.Eyes[self.prefabsTableToUse[self.selectedItem.objectId].eyes]
		
		self.prefabsTableToUse[self.selectedItem.objectId].bodyIndex = self:getSpriteIndexInList(self.prefabsTableToUse[self.selectedItem.objectId].sprites, basicBodySprite)
		self.prefabsTableToUse[self.selectedItem.objectId].beakIndex = self:getSpriteIndexInList(self.prefabsTableToUse[self.selectedItem.objectId].sprites, basicBeakSprite)
		self.prefabsTableToUse[self.selectedItem.objectId].eyesIndex = self:getSpriteIndexInList(self.prefabsTableToUse[self.selectedItem.objectId].sprites, basicEyesSprite)
		

		gamelua.hatcheryBirds = {}
		gamelua.hatcheryBirds.hatcheryBirds = self.prefabsTableToUse
		gamelua.saveLuaFile("./data_src/hatchery/scripts/hatcheryBirdsSaves.lua", "hatcheryBirds", true)
	end
	
end

function BirdDesigner:getSpriteIndexInList(list, sprite)
	local index = 1
	for k, v in _G.pairs(list) do
		if v.sprite == sprite then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

function BirdDesigner:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end


function BirdDesigner:draw(x, y)
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	self:drawBackground()	
	-- local compoBirdTable = gamelua.setupCompoBirdTable("BIRD_BODY_RED", {"BIRD_EYES_RED_NORMAL", "BIRD_BEAK_RED_NORMAL", "H_BIRD_ACCESSORY_TOP_HAT_2"})		
	-- gamelua.drawCompoObjectLua(gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.5, 3.14, 2, compoBirdTable)
	
	local itemSelectionFrame = self:getChild("itemSelectionFrame")
	
	
	if self.birdPieces ~= nil and itemSelectionFrame ~= nil and itemSelectionFrame.visible == false then
		for k, v in _G.pairs(self.birdPieces) do
			local px, py = _G.res.getSpritePivot("", v.sprite)
			local scale = v.scale
			gamelua.setRenderState((self.bodyX + v.x) / scale,(self.bodyY + v.y) / scale,v.scale,v.scale,v.angle, px, py)
			
			_G.res.drawSprite(v.sprite, 0, 0)
			
			
			
			if self.debugDrawing == true then																
				local w, h = _G.res.getSpriteBounds("", v.sprite)
				local px, py = _G.res.getSpritePivot("", v.sprite)
				gamelua.setRenderState((self.bodyX + v.x) / scale,(self.bodyY + v.y) / scale,v.scale,v.scale,v.angle, px, py)
				gamelua.drawRect(1,0,0,0.5, -px, -py, -px+w, -py+h, true)												
			end
			
			if self.selectedObject ~= nil and v == self.selectedObject then
				local w, h = _G.res.getSpriteBounds("", v.sprite)
				local px, py = _G.res.getSpritePivot("", v.sprite)
				gamelua.setRenderState((self.bodyX + v.x) / scale,(self.bodyY + v.y) / scale,v.scale,v.scale,v.angle, px, py)
				gamelua.drawRect(0,1,0,0.5, -px, -py, -px+w, -py+h, true)											
				
				--local space
				-- local ul = {x = -px*scale, y = -py *scale}
				-- local ur = {x = -px*scale + w * scale, y = -py *scale}
				-- local bl = {x = -px*scale , y = -py *scale + h *scale}
				-- local br = {x = -px*scale + w *scale, y = -py *scale + h *scale}
				
				-- local ulTransformed = self:transformCoordinates(v.angle, ul.x, ul.y)
				-- local urTransformed = self:transformCoordinates(v.angle, ur.x, ur.y)
				-- local blTransformed = self:transformCoordinates(v.angle, bl.x, bl.y)
				-- local brTransformed = self:transformCoordinates(v.angle, br.x, br.y)								
				
				-- ul.x = self.bodyX + ulTransformed.x + v.x
				-- ul.y = self.bodyY + ulTransformed.y + v.y
				
				-- ur.x = self.bodyX + urTransformed.x + v.x
				-- ur.y = self.bodyY + urTransformed.y + v.y
				
				-- bl.x = self.bodyX + blTransformed.x + v.x
				-- bl.y = self.bodyY + blTransformed.y + v.y
				
				-- br.x = self.bodyX + brTransformed.x + v.x
				-- br.y = self.bodyY + brTransformed.y + v.y
				
				-- local size = 5
				
				-- gamelua.drawRect(1,0,0,1, ul.x - size, ul.y - size, ul.x + size, ul.y + size, false)
				-- gamelua.drawRect(1,0,0,1, ur.x - size, ur.y - size, ur.x + size, ur.y + size, false)
				-- gamelua.drawRect(1,0,0,1, bl.x - size, bl.y - size, bl.x + size, bl.y + size, false)
				-- gamelua.drawRect(1,0,0,1, br.x - size, br.y - size, br.x + size, br.y + size, false)
				
				-- local vector = {x = br.x - ul.x, y = br.y - ul.y}
				-- local vectorNormalize = self:normalize(vector.x, vector.y)
				-- size = self:getDistance(br.x, br.y, ul.x, ul.y)
				
				-- local x = ul.x + vectorNormalize.x * size * 0.5
				-- local y = ul.y + vectorNormalize.y * size * 0.5
				
				-- size = 5
				
				-- gamelua.drawRect(1,1,1,1, x - size, y - size, x + size, y + size, false)
			end
		end
	end
	ui.Frame.draw(self, x, y)		
	
end

	


function BirdDesigner:drawBackground()
	gamelua.drawRect(43 / 255, 130/255, 175/255,  1,0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
	-- gamelua.drawRect(1, 0, 0,  1,0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
end

function BirdDesigner:recalculateDefaultBirds()

	if not self.selectedItem then
		return
		
	end

	for k, v in _G.pairs(self.prefabsTableToUse) do
		if #v.sprites == 3 then
			
			-- gamelua.print("\n found a three spriter")
			
			local isDefault = false
			for spriteKey, sprite in _G.pairs(v.sprites) do
				isDefault = sprite.angle == 0 and sprite.x == 0 and sprite.y == 0 and sprite.scale == 1
				
				if isDefault == false then 
					break
				end
			end
			
			if isDefault == true then
				self.prefabsTableToUse[self.selectedItem.objectId].bodyIndex = 1				
				self.prefabsTableToUse[self.selectedItem.objectId].eyesIndex = 2
				self.prefabsTableToUse[self.selectedItem.objectId].beakIndex = 3
				
				v.sprites = {	{sprite = Bird.Sprites.Body[v.shape][v.color], x = 0, y = 0, scale = 1, angle = 0},										
								{sprite = Bird.Sprites.Eyes[v.eyes], x = 0, y = 0, scale = 1, angle = 0},
								{sprite = Bird.Sprites.Beaks[v.beak], x = 0, y = 0, scale = 1, angle = 0},
							}
			end								
		
		end
		
		local basicBodySprite = Bird.Sprites.Body[v.shape][v.color]
		local basicBeakSprite = Bird.Sprites.Beaks[v.beak]
		local basicEyesSprite = Bird.Sprites.Eyes[v.eyes]
		
		v.bodyIndex = self:getSpriteIndexInList(v.sprites, basicBodySprite)
		v.beakIndex = self:getSpriteIndexInList(v.sprites, basicBeakSprite)
		v.eyesIndex = self:getSpriteIndexInList(v.sprites, basicEyesSprite)
	end



	gamelua.hatcheryBirds = {}
	gamelua.hatcheryBirds.hatcheryBirds = self.prefabsTableToUse
	gamelua.saveLuaFile("./data_src/hatchery/scripts/hatcheryBirdsSaves.lua", "hatcheryBirds", true)


	
end

function BirdDesigner:nextBirdColor()
	local birdTable = self.prefabsTableToUse[self.selectedItem.objectId]
	local birdColorsList = Bird.DefaultIndexes
	
	local index = self:getIndexInTable(birdColorsList, birdTable.color) + 1
	
	if index > #birdColorsList then
		index = 1	
	end
	
	local birdColor = Bird.COLOR[ birdColorsList[index] ]
	
	gamelua.print("\n Color changed to " .. birdColor .. "\n")
	
	birdTable.color = birdColor
	self:setBirdSprites(birdTable)
end

function BirdDesigner:nextBirdBeak()
	local birdTable = self.prefabsTableToUse[self.selectedItem.objectId]
	local birdBeakList =Bird.DefaultIndexes
	
	local index = self:getIndexInTable(birdBeakList, birdTable.beak) + 1
	
	if index > #birdBeakList then
		index = 1	
	end
	
	local birdBeak = Bird.BEAK[ birdBeakList[index] ]
	
	birdTable.beak = birdBeak
	self:setBirdSprites(birdTable)
end

function BirdDesigner:nextBirdEyes()
	local birdTable = self.prefabsTableToUse[self.selectedItem.objectId]
	local birdEyeList = Bird.DefaultIndexes
	
	local index = self:getIndexInTable(birdEyeList, birdTable.eyes) + 1
	
	if index > #birdEyeList then
		index = 1	
	end
	
	local birdEyes = Bird.EYES[ birdEyeList[index] ]
	
	birdTable.eyes = birdEyes
	self:setBirdSprites(birdTable)
end


function BirdDesigner:nextBirdShape()
	
	local birdTable = self.prefabsTableToUse[self.selectedItem.objectId]
	-- self.prefabsTableToUse[self.selectedItem.objectId].bodyIndex = 1				
	-- self.prefabsTableToUse[self.selectedItem.objectId].eyesIndex = 2
	-- self.prefabsTableToUse[self.selectedItem.objectId].beakIndex = 3
	
	
	
	local birdTypesList = Bird.DefaultIndexes
	
	local index = self:getIndexInTable(birdTypesList, birdTable.shape) + 1
	
	if index > #birdTypesList then
		index = 1	
	end
	
	local birdType = Bird.SHAPE[ birdTypesList[index] ]
	
	gamelua.print("\n next bird type is " .. birdType)
	
	
	birdTable.shape = birdType
	
	self:setBirdSprites(birdTable)

end

function BirdDesigner:setBirdSprites(birdTable)
	birdTable.sprites[birdTable.bodyIndex].sprite = Bird.Sprites.Body[birdTable.shape][birdTable.color]
	birdTable.sprites[birdTable.eyesIndex].sprite = Bird.Sprites.Eyes[birdTable.eyes]
	birdTable.sprites[birdTable.beakIndex].sprite = Bird.Sprites.Beaks[birdTable.beak]
	
	self.birdPieces[birdTable.bodyIndex].sprite = birdTable.sprites[birdTable.bodyIndex].sprite
	self.birdPieces[birdTable.eyesIndex].sprite = birdTable.sprites[birdTable.eyesIndex].sprite
	self.birdPieces[birdTable.beakIndex].sprite = birdTable.sprites[birdTable.beakIndex].sprite
	
	birdTable.sprite = Bird.Sprites.Body[birdTable.shape][birdTable.color]
	birdTable.spriteBlink = Bird.Sprites.Body[birdTable.shape][birdTable.color]
end

filename="BirdDesigner.lua"
