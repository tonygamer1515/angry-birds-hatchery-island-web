HatcheryDynamicObject = {}

function HatcheryDynamicObject:new(o)
	o = o or {}
	_G.setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

--this init is for stuff that can be done without actual initialization to the native side
function HatcheryDynamicObject:init()
	self.detached = true
	self.camCenterTime = 1
end

--this function initializes the native side object. HatcheryDynamicObject is pretty much nonfunctional without this function call
function HatcheryDynamicObject:initialize(params)
	self.RID = gamelua.createNewTileObject(params)
	self.sprites = params.sprites
	self.worldWidth=params.width
	self.worldHeight=params.height
	self.type = params.type
	self.class = params.class
	self.requirement = params.requirement
	self.hitPolygon = params.hitPolygon
	self.instanceType = params.instanceType
	self.renderQueue = params.renderQueue
	self.price = params.price
	self.detached = true
	self.animation = params.animation
	self.worldX = params.worldX
	self.worldY = params.worldY
	self.selectable = params.selectable
	self.collision = params.collision
	self.static = params.static
	self.movable = params.movable
	self.removable = params.removable
	self.removePrice = params.removePrice or 0
	self.removeTime = params.removeTime or 0
	self.removeTimer = params.removeTimer or 0
	self.removing = params.removing
	-- self.removeRatio = params.removeRatio or 0
	
	if self.removing == true and gamelua.settings.hatcheryLocalTime ~= nil and gamelua.g_hatcheryTimeBackwardsDetected ~= true and gamelua.g_hatcheryTimeForwardDetected ~= true then
		self:updateOfflineRemoveTime()
	end		
	
	if self.removing == true then
		self:startRemoving()
	end
	
	
	if self.animation and self.animation.animations then
		local spd = 1
		local rep = false
		
		if self.animation.speedMin and self.animation.speedMax then
			spd = self.animation.speedMin + _G.math.random()* (self.animation.speedMax - self.animation.speedMin)
		end
		
		if self.animation.speed then
			spd = self.animation.speed
		end
		if self.animation.loop then
			rep = self.animation.loop 
		end
		
		for k,v in _G.pairs(self.animation.animations) do
			gamelua.addAnimationToTileObject(self:getID(), {id = v.id, loop = rep, speed = spd})
		end
	end
	
	
	self.isSelected = false
end

--called when this object is selected. Objects themselves are responsible of acting upon this event, otherwise nothing will happen
function HatcheryDynamicObject:selected(params)
	self.service:moveCameraTo(self.worldX, self.worldY)
	self:setupContextMenu()
	self.service:showContextMenu()
	
	_G.res.playAudio(getHatcherySound("objectClick"), 1, false)
	self.isSelected = true
	gamelua.setObjectSelected(self:getID(),self.isSelected)
end

function HatcheryDynamicObject:setupContextMenu()
	local context = self.service:getContextMenu()
	state = {}
	if self.movable == true then
		state.move = true
	end
	if self.removable == true and self.removing ~= true then
		state.remove = true
	end
	if self.removing == true then
		state.hurry = true
	end
	context:setState(self,state)
end

function HatcheryDynamicObject:deselected(params)
	self.isSelected = false
	self.service:hideContextMenu(self)
	gamelua.setObjectSelected(self:getID(),self.isSelected)
end

function HatcheryDynamicObject:getHurryCost()
	local cost = 0
	if self.removing == true then
		cost =  self.removeTime - self.removeTimer
	end
	cost = _G.math.ceil(cost/(60*60))
	return cost
end

function HatcheryDynamicObject:uninitialize()
	self:detachFromGrid()
	
	
	gamelua.removeTileObject(self.RID)
	self.RID = nil
	self.sprites = nil
	self.worldWidth=nil
	self.worldHeight=nil
	self.type = nil
	self.requirement =nil
	self.hitPolygon = nil
	self.instanceType = nil
	self.class = nil
	self.price = nil
	self.detached = true
end

--this function is called when the game wants to save the object to a file. Different kinds of objects are responsible of saving themselves properly
function HatcheryDynamicObject:getSerializeTable(caller)
	local saveData = {}
	saveData.sprites = self.sprites
	saveData.worldWidth=self.width
	saveData.worldHeight=self.height
	saveData.type = self.type
	saveData.class = self.class
	saveData.requirement = self.requirement
	saveData.hitPolygon = self.hitPolygon
	saveData.instanceType = self.instanceType
	saveData.renderQueue = self.renderQueue
	saveData.price = self.price
	saveData.detached = self.detached
	saveData.animation = self.animation
	saveData.worldX = self.worldX
	saveData.worldY = self.worldY
	saveData.selectable = self.selectable
	saveData.collision = self.collision
	saveData.static = self.static
	saveData.movable = self.movable 
	saveData.removable = self.removable 
	saveData.removePrice = self.removePrice 
	saveData.removeTime = self.removeTime 
	saveData.removeTimer = self.removeTimer
	saveData.removing = self.removing
	-- saveData.removeRatio = self.removeRatio
	
	return saveData
end

function HatcheryDynamicObject:setObjectSprites(sprites)
	gamelua.setTileObjectSprites(self.RID, sprites)
end

function HatcheryDynamicObject:getPrice()
	return self.price
end
function HatcheryDynamicObject:getRequirement()
	return self.requirement
end

function HatcheryDynamicObject:getID()
	return self.RID
end

function HatcheryDynamicObject:setWorldPosition(x,y)
	self.worldX = x
	self.worldY = y
end

function HatcheryDynamicObject:getWorldPosition()
	return self.worldX, self.worldY
end

function HatcheryDynamicObject:isDetached()
	return self.detached
end

function HatcheryDynamicObject:detachFromGrid(worldX, worldY)
	if self.detached == true then
		return
	end
	self.worldX = worldX or self.worldX
	self.worldY = worldY or self.worldY

	gamelua.removeTileObjectFromLocation(self.RID,self.worldX, self.worldY)
	self.detached = true
end

--set "service interface". The object should be able to call shared resources and services through this interface (this can be the world itself etc)
function HatcheryDynamicObject:setServiceInterface(service)
	self.service  = service
end

function HatcheryDynamicObject:attachToGrid(worldX, worldY, snap)
	self.worldX = worldX or self.worldX
	self.worldY = worldY or self.worldY
	
	local snapToGrid = false
	if snap == nil or snap == true then
		snapToGrid = true
	end
	
	gamelua.addTileObjectToLocation(self.RID,self.worldX, self.worldY, snapToGrid)
	self.detached = false
end

function HatcheryDynamicObject:canAttachToCurrentPosition()
	local id = gamelua.getObjectOfType(self.worldX,self.worldY,self.requirement)
	if id == -1 then
		return false
	else
		return true
	end
end

function HatcheryDynamicObject:setType(type)
	self.type = type
	gamelua.setTileObjectType(self.RID,type)
end

function HatcheryDynamicObject:getType(type)
	return self.type
end




function HatcheryDynamicObject:update(dt, time)
	if self.removing == true then
		self.removeTimer = self.removeTimer + dt
		-- self.removeRatio = _G.math.min(self.removeTimer/self.removeTime,1)
		

		--ready
		-- if self.removeRatio >= 1 then
			-- self:removeObject()
		-- end
		if self.removeTimer >= self.removeTime then
			self:removeObject()
		end
		
	end
end

function HatcheryDynamicObject:hurry()
	if self.removing then
		self:removeObject()
	end
	self:setupContextMenu()
	self.service:hideContextMenu(self)
end

function HatcheryDynamicObject:startRemoving()
	-- self.removeTimer = self.removeTime * self.removeRatio
	self.removing = true
	self:setupContextMenu()
end

function HatcheryDynamicObject:removeObject()	
	self.removing = false
	self:deselected()
	self.service:removeAndDestroyObjectWithID(self:getID())
	_G.res.playAudio(getHatcherySound("worldObjectRemoved"), 1, false)
	
end

--this function is called after the world is drawn. Useful to be used for example drawing huds to objects
function HatcheryDynamicObject:drawAfterWorld()
	--for now the hud offset is constant from world center. Later on could be parametrized at object definition. coordinates are _WORLD COORDINATES_
	local offsetX = 60
	local offsetY = 60
	
	
	if self.removing == true then
		local x, y = gamelua.tileWorldToScreen(self.worldX, self.worldY)
		
		if x > 0 and x < gamelua.screenWidth and y > 0 and y < gamelua.screenHeight then
			
			x,y = gamelua.screenToTileWorld(x,y)
			
			x = x + offsetX
			y = y + offsetY
			
			gamelua.drawHUDSpriteToTileWorldLocation(x,y,"H_PROGRESS_BAR_BG")
			local removeRatio = self.removeTimer/self.removeTime
			-- gamelua.drawHUDSpriteToTileWorldLocation(x,y,"H_PROGRESS_BAR_FILL_ORANGE", 1-self.removeRatio, 1)
			gamelua.drawHUDSpriteToTileWorldLocation(x,y,"H_PROGRESS_BAR_FILL_ORANGE", 1-removeRatio, 1)

		end

	end

	

		

	
end

--native side usually draws objects. This function can be used to make the object draw itself "immediately"
function HatcheryDynamicObject:drawExplicitly()
	gamelua.drawTileObjectToWorld(self.RID, self.worldX,self.worldY)
end


--there is no safety check in this method, those are done in initialize. 
--I didnt place this method on the base class
--because every object can decide to handle time differently, 
--otherwise we would have to make several calls to
--the update method with big numbers as delta times
function HatcheryDynamicObject:updateOfflineRemoveTime()
	local currentTime = gamelua.getCurrentTime()
	
	local difference = gamelua.getTimeDifference(currentTime, gamelua.settings.hatcheryLocalTime)

	
	--we don't call the removeObject method here because the worldView needs to have the object id before removing it
	--so we set the time to the max (if reached) and let the object be removed on the first update call after it is
	--initialized and accounted for on worldView
	
	--if we just multiply the days by seconds, it can get really high values which might not fit into the number type
	for i = 0, difference.days -1 do		
		self.removeTimer = self.removeTimer + 86400
		
		if self.removeTimer >= self.removeTime then
			
			self.removeTimer = self.removeTime
			
			return
		end
	end
	
	self.removeTimer = self.removeTimer + (difference.minutes * 60)
		
	if self.removeTimer >= self.removeTime then
		
		self.removeTimer = self.removeTime
		
		return
	end			
	
	self.removeTimer = self.removeTimer + difference.seconds
		
	if self.removeTimer >= self.removeTime then
		
		self.removeTimer = self.removeTime
		
		return
	end
	
	
	
end

filename="hatcheryDynamicObject.lua"
