HatcheryConstructionObject = HatcheryDynamicObject:new()

--for now a global array so no need to calculate for each of the objects
g_decoPositions = {
	{x = -140, y = -25},
	{x = -50, y = -75},
	{x = 50, y = -75},
	{x = 140, y = -25}
}

-- for i=0,3 do
	-- local x = -120 + i*60
	-- local y = 	-_G.math.sin(_G.math.pi*0.25*(i)) * 40
	-- _G.table.insert(g_decoPositions,{x = x, y = y})
-- end


function HatcheryConstructionObject:init()
	HatcheryDynamicObject.init(self)

end

function HatcheryConstructionObject:startConstructing()

	-- self.constructTimer = self.constructTime * self.readyRatio
	
	

	
	
	--set remove times and positions to decorations
	self.removeTimes = {}
	local indexes = {}
	-- local iteratorStart = _G.math.floor(self.readyRatio * (#self.decorations-1))+1
	local readyRatio = self.constructTimer / self.constructTime
	local iteratorStart = _G.math.floor(readyRatio * (#self.decorations-1))+1

	
	
	--add construct sprites
	local allSprites = {}
	for k,v in _G.pairs(self.sprites) do
		_G.table.insert(allSprites,v)
	end
	if self.decorations and #self.decorations > 0 then
		for i = iteratorStart, #self.decorations do
			_G.table.insert(allSprites,1,self.decorations[i])
		end
	end
	
	
	self:setObjectSprites(allSprites)
	
	if self.decorations and #self.decorations > 0 then
		for i=1,#self.decorations do
			_G.table.insert(indexes, i)
		end
		local nativeIndex = 0
		for i=iteratorStart, #self.decorations  do
			_G.table.insert(self.removeTimes, (self.constructTime/(#self.decorations+1))*(i+1))
			
			--random position from list
			local rand = _G.math.random(1,#indexes)
			local ind = indexes[rand]
			_G.table.remove(indexes, rand)
			gamelua.setSpriteParameters(self.RID,nativeIndex, g_decoPositions[ind].x, g_decoPositions[ind].y)
			nativeIndex = nativeIndex + 1
		end
	
	end
	
	self.constructing = true
end

function HatcheryConstructionObject:getHurryCost()
	local cost = HatcheryDynamicObject.getHurryCost(self)
	if self.constructing == true then
		cost = self.constructTime - self.constructTimer
	end
	cost = _G.math.ceil(cost/(60*60))
	return cost 
end

function HatcheryConstructionObject:getSerializeTable(caller)
	local saveData = HatcheryDynamicObject.getSerializeTable(self)
	saveData.decorations = self.decorations
	saveData.decorationsCount = self.decorationsCount
	-- saveData.readyRatio = self.readyRatio
	saveData.constructTimer = self.constructTimer
	saveData.constructing = self.constructing
	saveData.readyType = self.readyType
	saveData.constructTime = self.constructTime
	return saveData
end

function HatcheryConstructionObject:initialize(params)
	
	

	self.decorations = params.decorations or {}
	self.decorationsCount = #self.decorations

	HatcheryDynamicObject.initialize(self,params)
	
	self.readyType = params.readyType or params.type
	self.constructTime = params.constructTime
	
	-- self.readyRatio = params.readyRatio or 0
	self.constructTimer = params.constructTimer or 0
	self.constructing = params.constructing or false
	
	if self.constructing == true and gamelua.settings.hatcheryLocalTime ~= nil and gamelua.g_hatcheryTimeBackwardsDetected ~= true and gamelua.g_hatcheryTimeForwardDetected ~= true then
		self:updateOfflineTime()
	end		
	
	if self.constructing == true then
		self:startConstructing()
	end
	
	
end

function HatcheryConstructionObject:update(dt, time)
	HatcheryDynamicObject.update(self,dt,time)
	if self.constructing == true then
		self.constructTimer = self.constructTimer + dt
		-- self.readyRatio = _G.math.min(self.constructTimer/self.constructTime,1)
		
		
		
		
		if (self.decorationsCount > 0) and (self.removeTimes[1] < self.constructTimer) then
			_G.table.remove(self.removeTimes, 1)
			gamelua.removeSpriteFromTileObject(self.RID, 0)
			self.decorationsCount = self.decorationsCount -1
		end
		
		--ready
		-- if self.readyRatio >= 1 then
		if self.constructTimer >= self.constructTime then
			self:constructionReady()
		end
		
	end
end

function HatcheryConstructionObject:constructionReady()
	
	self.constructing = false
	-- self.readyRatio = 1
	self.constructTimer = self.constructTime
	self:setType(self.readyType)
	--make sure no construction sprites are visible 
	self:setObjectSprites(self.sprites)
	self.service:hideContextMenu(self)
end

function HatcheryConstructionObject:hurry()
	HatcheryDynamicObject.hurry(self)
	if self.constructing then
		self:constructionReady()
	end
	self:setupContextMenu()
end

function HatcheryConstructionObject:selected(params)
	HatcheryDynamicObject.selected(self,params)
	self:setupContextMenu()
	self.service:showContextMenu()
	
end

function HatcheryConstructionObject:setupContextMenu()
	local state = {}
	if self.constructing == true or self.removing == true then
		state.hurry = true
	end
	if self.movable == true then
		state.move = true
	end
	if self.removable == true then
		state.remove = true
	end
	
	
	local context = self.service:getContextMenu()
	context:setState(self,state)
end


function HatcheryConstructionObject:drawAfterWorld()
	
	HatcheryDynamicObject.drawAfterWorld(self)
	
	--for now the hud offset is constant from world center. Later on could be parametrized at object definition. coordinates are _WORLD COORDINATES_
	local offsetX = 60
	local offsetY = 60
	
	
	if self.constructing == true then
		local x, y = gamelua.tileWorldToScreen(self.worldX, self.worldY)
		
		if x > 0 and x < gamelua.screenWidth and y > 0 and y < gamelua.screenHeight then
			
			x,y = gamelua.screenToTileWorld(x,y)
			
			x = x + offsetX
			y = y + offsetY
			
			gamelua.drawHUDSpriteToTileWorldLocation(x,y,"H_PROGRESS_BAR_BG")
			local readyRatio = self.constructTimer / self.constructTime
			-- gamelua.drawHUDSpriteToTileWorldLocation(x,y,"H_PROGRESS_BAR_FILL_GREEN", self.readyRatio, 1)
			gamelua.drawHUDSpriteToTileWorldLocation(x,y,"H_PROGRESS_BAR_FILL_GREEN", readyRatio, 1)

		end

	end
end

--there is no safety check in this method, those are done in initialize. 
--I didnt place this method on the base class
--because every object can decide to handle time differently, 
--otherwise we would have to make several calls to
--the update method with big numbers as delta times
function HatcheryConstructionObject:updateOfflineTime()
	local currentTime = gamelua.getCurrentTime()
	
	local difference = gamelua.getTimeDifference(currentTime, gamelua.settings.hatcheryLocalTime)		
	
	--if we just multiply the days by seconds, it can get really high values which might not fit into the number type
	for i = 0, difference.days -1 do		
		self.constructTimer = self.constructTimer + 86400
		
		if self.constructTimer >= self.constructTime then
			
			self:constructionReady()
			
			return
		end
	end
	
	self.constructTimer = self.constructTimer + (difference.minutes * 60)
		
	if self.constructTimer >= self.constructTime then
		
		self:constructionReady()
		
		return
	end			
	
	self.constructTimer = self.constructTimer + difference.seconds
		
	if self.constructTimer >= self.constructTime then
		
		self:constructionReady()
		
		return
	end
	
	
	
end

filename="hatcheryConstructionObject.lua"
