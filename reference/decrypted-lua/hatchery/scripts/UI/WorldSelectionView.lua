WorldSelectionView = ui.Frame:new()
Frame = ui.Frame



function WorldSelectionView:init() 
	self.active = false
	self.obj = nil
	self.parameters = {}
	
	self.lastDragPos = {}
	self.dragging = false
	self.coordinatesValid = false
	self.lastCursorPos = {}
	self.cursorOffset = {}
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_NO")
	cancelButton.returnValue = hatcheryEvents.EID_HATCHERY_TILE_MOVE_CANCEL	
	self:addChild(cancelButton)
	-- cancelButton.sound = getHatcherySound("ok")
	cancelButton.sound = getHatcherySound("contextMenuCancel")
	cancelButton.activateOnRelease = true
	cancelButton:setupDefaultAnimationValues()


	local okButton = ui.ScallableButton:new()
	okButton.name = "okButton"
	okButton:setImage("H_BTN_OK")
	okButton.returnValue = hatcheryEvents.EID_HATCHERY_TILE_MOVE_OK
	self:addChild(okButton)
	-- okButton.sound = getHatcherySound("ok")
	okButton.sound = getHatcherySound("contextMenuOK")
	okButton.activateOnRelease = true
	okButton:setupDefaultAnimationValues()			

	self.indicatorSprite =  "H_TILE_INDICATOR_GREEN"
end

function WorldSelectionView:isActive()
	return self.active
end

function WorldSelectionView:setWorldView(world)
	self.world = world
end



function WorldSelectionView:setSelectionViewActive(object, originalX, originalY, newObject, notDragging)
	
	self.parameters = {}
	
	self.parameters.originalX =originalX
	self.parameters.originalY =originalY
	self.parameters.newObject = newObject
	
	self.obj = object
	
	if not self.parameters.newObject then
		self.obj:detachFromGrid()
	end
	
	
	self.obj:setWorldPosition(originalX, originalY)

	

	
	self.coordinatesValid = true
	self.active  = true
	self.dragging = true
	
	if notDragging == true  then
		self.dragging = false
		--self.coordinatesValid = false
		--gamelua.print("ASDF\n")

	end

	local x,y = gamelua.tileWorldToScreen(originalX, originalY)
	
	
	self.cursorOffset.x = x - gamelua.cursor.x
	self.cursorOffset.y = y - gamelua.cursor.y
	

	
end

function WorldSelectionView:layout()
	local spacingX = 10
	local cancel = self:getChild("cancelButton")
	local ok = self:getChild("okButton")
	
	local spriteCancel = cancel.image
	local cancelW, cancelH = _G.res.getSpriteBounds("", spriteCancel)
	local cancelPX, cancelPY = _G.res.getSpritePivot("", spriteCancel)
	
	local spriteOk = ok.image
	local okW, okH = _G.res.getSpriteBounds("", spriteOk)
	local okPX, okPY = _G.res.getSpritePivot("", spriteOk)
	
	cancel.x = gamelua.screenWidth*0.9
	cancel.y = gamelua.screenHeight*0.9
	
	
	
	ok.x = cancel.x - cancelPX - spacingX - okW + okPX
	ok.y = cancel.y
end

function WorldSelectionView:setSelectionInactive()
	self.obj = nil
	self.parameters = nil
	self.coordinatesValid = false
	self.active  = false
end

function WorldSelectionView:handleInput(dt, time)


	--if gamelua.keyPressed["RBUTTON"] then
	--end


	
	if gamelua.keyPressed["LBUTTON"] then
		local wx, wy = self.obj:getWorldPosition()
		if gamelua.doesCursorIntersectTileObject(self.obj:getID(),wx,wy, gamelua.cursor.x, gamelua.cursor.y) then
			self.dragging = true
			local wx, wy  = self.obj:getWorldPosition()
			local x,y = gamelua.tileWorldToScreen(wx,wy)
			self.cursorOffset.x = x - gamelua.cursor.x
			self.cursorOffset.y = y - gamelua.cursor.y
		end
	end	
	
	if gamelua.keyHold["LBUTTON"] then
		
		--panning?
		if not self.dragging == true then
			if self.lastCursorPos.x and self.lastCursorPos.y then
				local deltaX = gamelua.cursor.x - self.lastCursorPos.x  
				local deltaY = gamelua.cursor.y - self.lastCursorPos.y
				gamelua.moveTileCameraPosition(deltaX, deltaY)
			end
		end	
		
		if self.dragging == true and (self.lastCursorPos.x ~= gamelua.cursor.x or self.lastCursorPos.y ~= gamelua.cursor.y) then
			self.coordinatesValid = false
		end
	
		
		
		self.lastCursorPos.x = gamelua.cursor.x
		self.lastCursorPos.y = gamelua.cursor.y
	end
	

	
	
	
	
	if gamelua.keyReleased["LBUTTON"] then
		if self.dragging == true then
			_G.res.playAudio(getHatcherySound("inventoryObjectWorldRelease"), 1, false)			
		end
		self.dragging = false
		self.lastCursorPos.x = nil
		self.lastCursorPos.y = nil
	end
	
	
	

	

	

end

function WorldSelectionView:onPointerEvent(eventType,x,y)


	

	local result,meta = nil, nil

	result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == hatcheryEvents.EID_HATCHERY_TILE_MOVE_CANCEL	 then
		if self.obj:isDetached() == true then
			--if the object was going to be repositioned, put it back to some position. Otherwise Remove the object since it wasnt placed anywhere
			if not self.parameters.newObject  then
				self.obj:setWorldPosition(self.parameters.originalX, self.parameters.originalY)
				self.obj:attachToGrid()
			else
				self.world:removeAndDestroyObjectWithID(self.obj:getID())
			end
			self.active = false
			self.obj = nil
		end
		self.world:setPanelsEnabled(true)
	elseif result == hatcheryEvents.EID_HATCHERY_TILE_MOVE_OK then
		
		if self.obj:isDetached() == true  then
			if (self.world:canAfford(self.obj:getPrice()) == true) or (not self.parameters.newObject)  then
				self:handleObjectPlacement()
				self.active = false
				self.obj = nil
				
			else
				self.world:removeAndDestroyObjectWithID(self.obj:getID())
				self.active = false
				self.obj = nil
				self.world:openNotEnoughStars()
			end
		end
		self.world:setPanelsEnabled(true)
	end
	
	
	return result, meta
end



function WorldSelectionView:update(dt, time) 
	

	self:handleInput(dt, time)
	
	
	


	for i,v in _G.ipairs(self.children) do
		if v.active == true then		
			v:update(dt,time)
		end
	end
end


function WorldSelectionView:draw(x,y, scaleX, scaleY, angle) 

	if self.obj ~= nil and self.obj:isDetached() == true then
		if self.coordinatesValid == false then
			local canBeDropped = false
			--check if the position of the tile is free. If not, hide the ok button
			local okbutton = self:getChild("okButton")
			
			if not self.obj:getRequirement() then
				local posX, posY = self.obj:getWorldPosition()
				canBeDropped = gamelua.isObjectAreaFree(self.obj:getID(),posX, posY)
			else
				--check if the area contains type that the object can be dropped to
				canBeDropped = self.obj:canAttachToCurrentPosition()
			end
			
			if canBeDropped == true then
				okbutton.visible = true
			else
				okbutton.visible = false
			end
			
			local snap = 0
			if canBeDropped == true then
				snap = 1
			end
			
			
			local wx, wy = gamelua.screenToTileWorld(self.lastCursorPos.x + self.cursorOffset.x, self.lastCursorPos.y + self.cursorOffset.y, snap)
			self.obj:setWorldPosition( wx,wy)
			self.coordinatesValid = true
			
			if canBeDropped == true then
				self.indicatorSprite =  "H_TILE_INDICATOR_GREEN"
			else
				self.indicatorSprite =  "H_TILE_INDICATOR_RED"
			end
		end
		
		local wx, wy = self.obj:getWorldPosition()
		--draw the selected object
		if self.indicatorSprite then
			gamelua.drawIndicatorForObject(self.obj:getID(),wx,wy, self.indicatorSprite)
		end
		self.obj:drawExplicitly()
		
	end



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


function WorldSelectionView:handleObjectPlacement()
	if not self.obj:getRequirement() then
		self.obj:attachToGrid()
		
	else
		
		-- add egg to nest
		if self.obj:getType() == HatcheryObjectTypes["EGG"] then
			local wx, wy = self.obj:getWorldPosition()
			local nestID = gamelua.getObjectOfType(wx,wy,self.obj:getRequirement())
			local nest = self.world:getObjectWithID(nestID)
			nest:setType(HatcheryObjectTypes["HATCHINGNEST"])
			nest:addEgg(self.obj)
		end
	end		
	
	
	if self.parameters.newObject then
		self.world:newObjectPlaced(self.obj)
	end
	
	self.world:selectObject(self.obj:getID())

end
filename="WorldSelectionView.lua"
