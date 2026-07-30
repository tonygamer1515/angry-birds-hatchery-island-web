NestDesigner = ui.Frame:new()
Frame = ui.Frame

function NestDesigner:init()
	Frame.init(self)
	
	self.currentNest = nil

	self.selectedItems = {}		
	
	self.fontScaleSmall = 0.5		
	
	local behindEggNestLayer = ui.Frame:new()
	behindEggNestLayer.name = "behindEggNestLayer"
	self:addChild(behindEggNestLayer)
	
	local egg = ui.Image:new()
	egg.name = "egg"
	egg:setImage("H_EGG_DEFAULT")
	self:addChild(egg)
	
	local aboveEggNestLayer = ui.Frame:new()
	aboveEggNestLayer.name = "aboveEggNestLayer"
	self:addChild(aboveEggNestLayer)
	
	local backButton = ui.ScallableButton:new()
	backButton.name = "backButton"
	backButton:setImage("H_BTN_SHUT_DOWN")
	backButton.returnValue = hatcheryEvents.EID_NEST_DESIGNER_BACK	
	self:addChild(backButton)
	backButton.sound = getHatcherySound("ok")
	backButton.activateOnRelease = true
	
	local slotsButton = ui.ScallableButton:new()
	slotsButton.name = "slotsButton"
	slotsButton:setImage("H_BTN_PLAZA")
	slotsButton.returnValue = hatcheryEvents.EID_NEST_DESIGNER_OPEN_SLOTS	
	self:addChild(slotsButton)
	slotsButton.sound = getHatcherySound("ok")
	slotsButton.activateOnRelease = true
	slotsButton.visible = true
	
	
	local materialButtonWood = ui.ScallableButton:new()
	materialButtonWood.name = "materialButtonWood"
	materialButtonWood:setImage("H_NEST_MATERIAL_WOOD")
	materialButtonWood.returnValue = hatcheryEvents.EID_NEST_DESIGNER_MATERIAL	
	self:addChild(materialButtonWood)
	materialButtonWood.sound = getHatcherySound("ok")
	materialButtonWood.activateOnRelease = true
	
	local materialButtonIce = ui.ScallableButton:new()
	materialButtonIce.name = "materialButtonIce"
	materialButtonIce:setImage("H_NEST_MATERIAL_ICE")
	materialButtonIce.returnValue = hatcheryEvents.EID_NEST_DESIGNER_MATERIAL	
	self:addChild(materialButtonIce)
	materialButtonIce.sound = getHatcherySound("ok")
	materialButtonIce.activateOnRelease = true
	
	local materialButtonRock = ui.ScallableButton:new()
	materialButtonRock.name = "materialButtonRock"
	materialButtonRock:setImage("H_NEST_MATERIAL_ROCK")
	materialButtonRock.returnValue = hatcheryEvents.EID_NEST_DESIGNER_MATERIAL	
	self:addChild(materialButtonRock)
	materialButtonRock.sound = getHatcherySound("ok")
	materialButtonRock.activateOnRelease = true
	
	local eggLayerText = ui.TextButton:new()
	eggLayerText.name = "eggLayerText"
	eggLayerText.font = "FONT_HATCHERY"
	eggLayerText.text = "Visible layer: both"
	eggLayerText.returnValue = (hatcheryEvents.EID_NEST_DESIGNER_SWITCH_EGG_LAYER)
	eggLayerText.hanchor = "LEFT"
	self:addChild(eggLayerText)
	
	local randomizeText = ui.TextButton:new()
	randomizeText.name = "randomizeText"
	randomizeText.font = "FONT_HATCHERY"
	randomizeText.text = "Randomize"
	randomizeText.returnValue = (hatcheryEvents.EID_NEST_DESIGNER_RANDOMIZE)
	randomizeText.hanchor = "LEFT"
	self:addChild(randomizeText)
	
	local showOrderText = ui.TextButton:new()
	showOrderText.name = "showOrderText"
	showOrderText.font = "FONT_HATCHERY"
	showOrderText.text = "Hide order"
	showOrderText.returnValue = (hatcheryEvents.EID_NEST_DESIGNER_SHOW_ORDER)
	showOrderText.hanchor = "LEFT"
	self:addChild(showOrderText)
	
	self.currentEggLayer = 1
	
	self.currentMaterial = "H_NEST_MATERIAL_WOOD"
	
	self.displayIndex = true
	
	self.itemIndexString = ""
	
	--POP UPS
	
	local itemSelectionFrame = NestDesignerSelectionFrame:new()
	itemSelectionFrame.name = "itemSelectionFrame"
	itemSelectionFrame.visible = false
	self:addChild(itemSelectionFrame)
	
	local cancelButton = itemSelectionFrame:getChild("cancelButton")
	cancelButton.sound = getHatcherySound("cancel")
	itemSelectionFrame:setup(hatcheryEvents.EID_NEST_DESIGNER_ITEM_CANCEL, hatcheryNests)
	
	
	
	self.currentFrame = nil
	
	self.numberKeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
	
	self:setNest(hatcheryNests[1])
end


function NestDesigner:layout()
	local eggLayerText = self:getChild("eggLayerText")
	eggLayerText.x = 50
	eggLayerText.y = 50
	
	local randomizeText = self:getChild("randomizeText")
	randomizeText.x = 50
	randomizeText.y = 100

	
	local showOrderText = self:getChild("showOrderText")
	showOrderText.x = 50
	showOrderText.y = 150
	
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
	
	local buttonsMaterialSpacingY = 100
	local buttonsMaterialStartX = gamelua.screenWidth - 100
	local buttonsMaterialStartY = 100
	
	local materialButtonWood = self:getChild("materialButtonWood")
	materialButtonWood.x = buttonsMaterialStartX
	materialButtonWood.y = buttonsMaterialStartY
	
	local materialButtonIce = self:getChild("materialButtonIce")
	materialButtonIce.x = buttonsMaterialStartX
	materialButtonIce.y = buttonsMaterialStartY + buttonsMaterialSpacingY
	
	local materialButtonRock = self:getChild("materialButtonRock")
	materialButtonRock.x = buttonsMaterialStartX
	materialButtonRock.y = buttonsMaterialStartY + buttonsMaterialSpacingY * 2
	
	local egg = self:getChild("egg")
	egg.x = gamelua.screenWidth * 0.5
	egg.y = gamelua.screenHeight * 0.5
	
	local behindEggNestLayer = self:getChild("behindEggNestLayer")
	behindEggNestLayer.x = egg.x
	behindEggNestLayer.y = egg.y
	
	local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
	aboveEggNestLayer.x = egg.x
	aboveEggNestLayer.y = egg.y
	
	Frame.layout(self)	
	
end


function NestDesigner:setHatchery(hatchery)
	self.hatchery = hatchery
	
	
	
end
		
function NestDesigner:openFrame(frame)
	self.currentFrame = frame
	frame.visible = true
	
end

function NestDesigner:closeCurrentFrame()
	if self.currentFrame ~= nil then
		self.currentFrame.visible = false
	end
	
	
end

function NestDesigner:showUnderView()
	local behindEggNestLayer = self:getChild("behindEggNestLayer")
	local egg = self:getChild("egg")
	local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
	local backButton = self:getChild("backButton")
	local slotsButton = self:getChild("slotsButton")
	local materialButtonWood = self:getChild("materialButtonWood")
	local materialButtonIce = self:getChild("materialButtonIce")
	local materialButtonRock = self:getChild("materialButtonRock")
	local eggLayerText = self:getChild("eggLayerText")
	local randomizeText = self:getChild("randomizeText")
	local showOrderText = self:getChild("showOrderText")
	
	behindEggNestLayer.visible = true
	egg.visible = true
	aboveEggNestLayer.visible = true
	backButton.visible = true
	slotsButton.visible = true
	materialButtonWood.visible = true
	materialButtonIce.visible = true
	materialButtonRock.visible = true
	eggLayerText.visible = true
	randomizeText.visible = true
	showOrderText.visible = true
end

function NestDesigner:hideUnderView()
	local behindEggNestLayer = self:getChild("behindEggNestLayer")
	local egg = self:getChild("egg")
	local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
	local backButton = self:getChild("backButton")
	local slotsButton = self:getChild("slotsButton")
	local materialButtonWood = self:getChild("materialButtonWood")
	local materialButtonIce = self:getChild("materialButtonIce")
	local materialButtonRock = self:getChild("materialButtonRock")
	local eggLayerText = self:getChild("eggLayerText")
	local randomizeText = self:getChild("randomizeText")
	local showOrderText = self:getChild("showOrderText")
	
	behindEggNestLayer.visible = false
	egg.visible = false
	aboveEggNestLayer.visible = false
	backButton.visible = false
	slotsButton.visible = false
	materialButtonWood.visible = false
	materialButtonIce.visible = false
	materialButtonRock.visible = false
	eggLayerText.visible = false
	randomizeText.visible = false
	showOrderText.visible = false
	
	self.selectedItems = {}
end


function NestDesigner:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	local itemSelectionFrame = self:getChild("itemSelectionFrame")
	
	local itemNameText = self:getChild("itemNameText")
	
	if result == hatcheryEvents.EID_NEST_DESIGNER_BACK then
		hatcheryEventManager:notify({id = hatcheryEvents.EID_HATCHERY_GOTO_EPISODE_SELECTION})
	
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_ITEM_CANCEL then
		self:closeCurrentFrame()
		self:showUnderView()
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_ITEM_SELECTED then
		
		self:closeCurrentFrame()
		self:setNest(itemSelectionFrame:getSelectedNest())
	
		self:showUnderView()
	
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_MATERIAL	then
		
		for k, v in _G.pairs(self.selectedItems) do
			v.nestEntry.defaultSprite = meta.image
			v:setImage(meta.image)
		end
		
		self.currentMaterial = meta.image
		
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_SWITCH_EGG_LAYER then
		local eggLayerText = self:getChild("eggLayerText")
		
		local behindEggNestLayer = self:getChild("behindEggNestLayer")
		local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
		
		if eggLayerText.text == "Visible layer: both" then
			eggLayerText.text = "Visible layer: above"
			behindEggNestLayer.visible = false
			aboveEggNestLayer.visible = true
		elseif eggLayerText.text == "Visible layer: above" then
			eggLayerText.text = "Visible layer: below"
			behindEggNestLayer.visible = true
			aboveEggNestLayer.visible = false
		elseif eggLayerText.text == "Visible layer: below" then
			eggLayerText.text = "Visible layer: both"
			behindEggNestLayer.visible = true
			aboveEggNestLayer.visible = true
		end
		
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_RANDOMIZE then
	
		local materials = {"H_NEST_MATERIAL_WOOD", "H_NEST_MATERIAL_ICE", "H_NEST_MATERIAL_ROCK"}
		for k, v in _G.pairs(self.currentNest.spots) do
			v.defaultSprite = materials[_G.math.random(1,3)]
		end
		
		self:setupChildFrames()
		
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_OPEN_SLOTS then
		self:openFrame(itemSelectionFrame)
		self:hideUnderView()
		
	elseif result == hatcheryEvents.EID_NEST_DESIGNER_SHOW_ORDER then
		local showOrderText = self:getChild("showOrderText")
		
		self.displayIndex = not self.displayIndex
		
		if showOrderText.text == "Show order" then
			showOrderText.text = "Hide order"
		else
			showOrderText.text = "Show order"
		end
	end		
	
	return result, meta
end

function NestDesigner:getIndexInTable(list, entry)
	local index = 1
	for k, v in _G.pairs(list) do
		if v == entry then
			return index
		end
		index = index + 1
	end
	
	return 0
end

function NestDesigner:removeItemFromTable(list, entry)
	local index = self:getIndexInTable(list, entry)
	
	if index > 0 then
		_G.table.remove(list, index)
	end
end

function NestDesigner:update(dt, time) 
	ui.Frame.update(self, dt, time) 
	
	if self.lastCursor == nil then
		self.lastCursor = {x = gamelua.cursor.x, y = gamelua.cursor.y}
	end			
	
	if #self.selectedItems == 1 then
		
		for k, v in _G.pairs(self.numberKeys) do
			if gamelua.keyHold["SHIFT"] and gamelua.keyPressed[v] then
				self.itemIndexString = self.itemIndexString .. v
			end
		end
		
		if gamelua.keyReleased["SHIFT"] and self.itemIndexString ~= "" then
			local number = gamelua.getNumberFromString(self.itemIndexString)
			
			self:setOrder(self.selectedItems[1].nestEntry, number)
			self.itemIndexString = ""
		end
	
		
	end
	
	if gamelua.keyPressed["P"] then
		
		local egg = self:getChild("egg")
		local newEntry = {x = gamelua.cursor.x - egg.x, y = gamelua.cursor.y - egg.y, scaleX = 1, scaleY=1, angle = 0, layerIndexFromEgg=self.currentEggLayer, defaultSprite = self.currentMaterial}
		
		_G.table.insert(self.currentNest.spots, newEntry)
		self:setupChildFrames()
		
		
	end
	
	local behindEggNestLayer = self:getChild("behindEggNestLayer")
	local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
	
	if gamelua.keyPressed["RBUTTON"] then
		
		
		local buttonToUse = nil	
	
		for k, v in _G.pairs(behindEggNestLayer.children) do
			if v:checkCollision(gamelua.cursor.x - behindEggNestLayer.x, gamelua.cursor.y - behindEggNestLayer.y) then
				buttonToUse = v				
			end
			
		end				
		
		for k, v in _G.pairs(aboveEggNestLayer.children) do
			if v:checkCollision(gamelua.cursor.x - aboveEggNestLayer.x, gamelua.cursor.y - aboveEggNestLayer.y) then
				buttonToUse = v				
			end
		end
		
		
		if not gamelua.keyHold["CONTROL"] then
			self.selectedItems = {}
		end
		
		_G.table.insert(self.selectedItems, buttonToUse)
	end
	
	if gamelua.keyPressed["DELETE"] then
		for k, v in _G.pairs(self.selectedItems) do
			behindEggNestLayer:removeChild(v)
			aboveEggNestLayer:removeChild(v)			
			self:removeItemFromTable(self.currentNest.spots, v.nestEntry)
		end
		
		self.selectedItems = {}
	end
	
	
	
	if gamelua.keyPressed["SPACE"] and gamelua.keyHold["CONTROL"] then --and self.selectedObject ~= nil then
		
		for k, v in _G.pairs(self.selectedItems) do
			v.x = 0		
			v.y = 0		
			v.angle = 0
			v.scaleX = 1
			v.scaleY = 1
			
			v.nestEntry.x = 0		
			v.nestEntry.y = 0		
			v.nestEntry.angle = 0
			v.nestEntry.scaleX = 1
			v.nestEntry.scaleY = 1
		end
	end		
	
	if gamelua.keyPressed["TAB"] then
		local tempButtons = {}
		for k, v in _G.pairs(behindEggNestLayer.children) do
			_G.table.insert(tempButtons, v)
		end
		for k, v in _G.pairs(aboveEggNestLayer.children) do
			_G.table.insert(tempButtons, v)
		end
		
		if #self.selectedItems > 0 then
			local index = self:getIndexInTable(tempButtons, self.selectedItems[1])
			
			self.selectedItems = {}
			
			
			local newIndex = _G.math.fmod(index, #tempButtons) + 1
			_G.table.insert(self.selectedItems, tempButtons[newIndex])
			
		end
		
	end
	
	if gamelua.keyPressed["S"] and gamelua.keyHold["CONTROL"] then
		self:save()
	end
	
	if (gamelua.keyPressed["SUBTRACT"] or gamelua.keyPressed["ADD"] )then
		
		local offset = 0
		
		if gamelua.keyPressed["SUBTRACT"] then
			offset = -1
		elseif gamelua.keyPressed["ADD"] then
			offset = 1
		end
		
		local selectedEntries = {}
			
		for k, v in _G.pairs(self.selectedItems) do			
			_G.table.insert(selectedEntries, v.nestEntry)
		end
		
		if gamelua.keyHold["CONTROL"] then
			self.currentEggLayer = offset						
			
			for k, v in _G.pairs(self.selectedItems) do
				v.nestEntry.layerIndexFromEgg = offset				
			end
			
			self:setupChildFrames()
			
			self:refreshSelectedItems(selectedEntries)
			
		else
		
			if #self.selectedItems > 0 then
			
				local index = self:getIndexInTable(self.currentNest.spots, self.selectedItems[1].nestEntry)
				local newIndex = index + offset
				newIndex = _G.math.min(newIndex, #self.currentNest.spots)
				newIndex = _G.math.max(newIndex, 1)
				
				if index ~= newIndex then
					
					local behindEggNestLayer = self:getChild("behindEggNestLayer")
					local aboveEggNestLayer = self:getChild("aboveEggNestLayer")				
				
					local tableToRemove = self.currentNest.spots[index]		

					if gamelua.keyHold["CONTROL"] then
						tableToRemove.layerIndexFromEgg = offset
					end
					
					_G.table.remove(self.currentNest.spots, index)
					_G.table.insert(self.currentNest.spots, newIndex, tableToRemove)
					
					
					self:setupChildFrames()
					
					self:refreshSelectedItems(selectedEntries)
					
				end
			end
		end
		
			
	end
	
	local transformingItem = false
	
	
	
	if gamelua.keyHold["CONTROL"] and gamelua.keyHold["LBUTTON"] then		
		
		local factor = 0.01
		
		if gamelua.keyHold["SHIFT"] then
			factor = factor * 0.1
		end
		
		for k,v in _G.pairs(self.selectedItems) do
			v.angle = v.angle + ( (gamelua.cursor.x - self.lastCursor.x) * factor)
			v.nestEntry.angle = v.nestEntry.angle + ( (gamelua.cursor.x - self.lastCursor.x) * factor)
		end
		
		transformingItem = true
	end
	
	
	
	if gamelua.keyHold["CONTROL"] and gamelua.keyHold["RBUTTON"] then		
		
		local factor = 0.01
		
		if gamelua.keyHold["SHIFT"] then
			factor = factor * 0.1
		end
		
		for k,v in _G.pairs(self.selectedItems) do
			v.scaleX = v.scaleX + ( (gamelua.cursor.x - self.lastCursor.x) * factor)
			v.scaleY = v.scaleX
			v.nestEntry.scaleX = v.scaleX
			v.nestEntry.scaleY = v.scaleY
		end
		
		
		transformingItem = true
	end		
	
	if gamelua.keyHold["LBUTTON"] and not transformingItem then
	
		for k,v in _G.pairs(self.selectedItems) do
		
			v.x = v.x + ( (gamelua.cursor.x - self.lastCursor.x))
			v.y = v.y + ( (gamelua.cursor.y - self.lastCursor.y))
			v.nestEntry.x = v.x
			v.nestEntry.y = v.y
		end
		
	else
		self.movingObject = nil
	end
	
	
	
	if #self.selectedItems > 0 then
		local movingKeys = { {key = "LEFT", x=-1, y= 0}, {key = "RIGHT", x=1, y= 0}, {key = "UP", x=0, y= -1},{key = "DOWN", x=0, y= 1}}
		for k, v in _G.pairs(movingKeys) do
			if gamelua.keyPressed[v.key] then
				local factor = 1
				
				if gamelua.keyHold["SHIFT"] then
					factor = 10
				end
				
				for itemKey,item in _G.pairs(self.selectedItems) do
					item.x = item.x + v.x * factor
					item.y = item.y + v.y * factor
					item.nestEntry.x = item.x
					item.nestEntry.y = item.y
				end
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

function NestDesigner:refreshSelectedItems(selectedEntries)
	local behindEggNestLayer = self:getChild("behindEggNestLayer")
	local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
	
	self.selectedItems = {}
	
	for k, v in _G.pairs(behindEggNestLayer.children) do
		if self:getIndexInTable(selectedEntries, v.nestEntry) > 0 then
			_G.table.insert(self.selectedItems, v)
		end
	end
	
	for k, v in _G.pairs(aboveEggNestLayer.children) do
		if self:getIndexInTable(selectedEntries, v.nestEntry) > 0 then
			_G.table.insert(self.selectedItems, v)
		end
	end
	
end

function NestDesigner:getDistance(x1,y1,x2,y2)
	return _G.math.sqrt( (x2-x1) * (x2-x1) + (y2-y1) * (y2-y1))
end

function NestDesigner:normalize(x,y)
	local size = self:getDistance(x,y,0,0)
	return {x = x / size, y = y / size}
end

function NestDesigner:transformCoordinates(angle, x, y)
	local c = _G.math.cos(angle)
	local s = _G.math.sin(angle)
	
	return {x = c * x + (-s) * y, y = s * x + c * y}
	
end

function NestDesigner:onEntry()	
	
	
	
	
end


function NestDesigner:save()
	
	gamelua.hatcheryNests = {}
	gamelua.hatcheryNests.hatcheryNests = hatcheryNests
	gamelua.saveLuaFile("./data_src/hatchery/scripts/hatcheryNests.lua", "hatcheryNests", true)
	
end

function NestDesigner:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end


function NestDesigner:draw(x, y)
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	self:drawBackground()						
	
	ui.Frame.draw(self, x, y)	

	for k, v in _G.pairs(self.selectedItems) do
		local egg = self:getChild("egg")
		local px, py = _G.res.getSpritePivot("", v.image)			
		
		local w, h = _G.res.getSpriteBounds("", v.image)
		local px, py = _G.res.getSpritePivot("", v.image)
		gamelua.setRenderState((egg.x + v.x) / v.scaleX,(egg.y + v.y) / v.scaleY,v.scaleX,v.scaleY,v.angle, px, py)
		gamelua.drawRect(0,1,0,0.5, -px, -py, -px+w, -py+h, true)	

		
	end
	
	
	
	
	if self.displayIndex == true then
	
		local behindEggNestLayer = self:getChild("behindEggNestLayer")
		local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
		local egg = self:getChild("egg")
		
		for k, v in _G.pairs(behindEggNestLayer.children) do
			gamelua.setFont("FONT_HATCHERY")
			
			local index = v.nestEntry.constructionIndex
			local textScale = 0.5
			gamelua.setRenderState((egg.x + v.x) / textScale,(egg.y + v.y) / textScale,textScale,textScale,0, 0, 0)
			_G.res.drawString("", "" .. index, 0, 0, "HCENTER", "VCENTER")
		end
		
		if self.currentFrame == nil or self.currentFrame.visible == false then
			
			for k, v in _G.pairs(aboveEggNestLayer.children) do
				gamelua.setFont("FONT_HATCHERY")
				local index = v.nestEntry.constructionIndex
				local textScale = 0.5
				gamelua.setRenderState((egg.x + v.x) / textScale,(egg.y + v.y) / textScale,textScale,textScale,0, 0, 0)
				_G.res.drawString("", "" .. index, 0, 0, "HCENTER", "VCENTER")
			end
		end
	end
	
end

	
function NestDesigner:setOrder(spot, index)	
	
	if index > #self.currentNest.spots then
		return
	end
	
	spot.constructionIndex = index
	
	
end


function NestDesigner:drawBackground()
	gamelua.drawRect(43 / 255, 130/255, 175/255,  1,0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
	
end


function NestDesigner:setNest(nest)
	self.currentNest = nest
	
	self:setupChildFrames()
	
end



function NestDesigner:setupChildFrames()
	
	local behindEggNestLayer = self:getChild("behindEggNestLayer")
	local aboveEggNestLayer = self:getChild("aboveEggNestLayer")
	
	behindEggNestLayer:removeAllChildren()
	aboveEggNestLayer:removeAllChildren()
	
	local count = 1
	
	for k, v in _G.pairs(self.currentNest.spots) do
		
		local layer = behindEggNestLayer
		
		if v.layerIndexFromEgg == 1 then
			layer = aboveEggNestLayer
		end
		
		if v.constructionIndex == nil then
			v.constructionIndex = count
		end
		
		self:addButton(layer, v, "spotButton" .. count, count)
		
		count = count + 1
		
	end
	
	self.nestFrames = {}
end

function NestDesigner:addButton(layer, nestEntry, name, index)
	local sprite = nestEntry.defaultSprite or "H_NEST_MATERIAL_WOOD"

	local spotButton = ui.ScallableButton:new()
	spotButton.name = name
	spotButton.nestIndex = index
	spotButton.nestEntry = nestEntry
	spotButton:setImage(sprite)
	spotButton.returnValue = hatcheryEvents.EID_NEST_DESIGNER_SPOT_CLICK	
	-- spotButton.w = 10
	-- spotButton.h = 10
	spotButton.r = 1
	spotButton.g = 0
	spotButton.b = 0
	spotButton.a = 1
	
	spotButton.x = nestEntry.x
	spotButton.y = nestEntry.y
	spotButton.scaleX = nestEntry.scaleX
	spotButton.scaleY = nestEntry.scaleY
	spotButton.angle = nestEntry.angle
	layer:addChild(spotButton)
	spotButton.sound = getHatcherySound("ok")
	spotButton.activateOnRelease = true
end
filename="NestDesigner.lua"
