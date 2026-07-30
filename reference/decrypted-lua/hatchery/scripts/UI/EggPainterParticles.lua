EggPainterParticles = {}

function EggPainterParticles:new(o)

	
	object = {}

	
	
	
	_G.setmetatable(object, self)
	self.__index = self
	return object
end

function EggPainterParticles:setSource(sourceX, sourceY, particleSystemID)
	if self.particlesSources == nil then
		self.particlesSources = {}
		
	end
	
	self.particlesSources[particleSystemID] = {x= sourceX, y = sourceY}
end

function EggPainterParticles:update(dt, time) 
	if self.particles ~= nil then
		for k, holder in _G.pairs(self.particles) do
			holder:update(dt, time)
		end
	end
end

function EggPainterParticles:drawAllParticlesExcept(exceptList)
	exceptList = exceptList or {}
	if self.particles ~= nil then
		
		for kk, holder in _G.pairs(self.particles) do
			local index = self:getIndexInTable(exceptList, kk)
			
			if index == 0 then
				for k, v in _G.pairs(holder.particles) do
					local x = v.x * 20
					local y = v.y * 20
					local angle = v.angle
					local scale = v.scale
					local image = v.image
					
					local px, py = _G.res.getSpritePivot("", image)
					gamelua.setRenderState((x / scale), (y / scale), scale, scale, angle, px, py, v.alpha)
					_G.res.drawSprite("", image, 0, 0)
				end
			end
		end
	end
	
	gamelua.setRenderState(0,0, 1, 1, 0, 0, 0, 1)
end

function EggPainterParticles:drawSpecificParticles(particlesToDrawList)
	particlesToDrawList = particlesToDrawList or {}
	if self.particles ~= nil then
		
		for kk, holder in _G.pairs(self.particles) do
			local index = self:getIndexInTable(particlesToDrawList, kk)
			
			if index > 0 then
				for k, v in _G.pairs(holder.particles) do
					local x = v.x * 20
					local y = v.y * 20
					local angle = v.angle
					local scale = v.scale
					local image = v.image
					
					local px, py = _G.res.getSpritePivot("", image)
					gamelua.setRenderState((x / scale), (y / scale), scale, scale, angle, px, py, v.alpha)
					_G.res.drawSprite("", image, 0, 0)
				end
			end
		end
	end
	
	gamelua.setRenderState(0,0, 1, 1, 0, 0, 0, 1)
end



function EggPainterParticles:draw() 
	if self.particles ~= nil then
		for kk, holder in _G.pairs(self.particles) do
			
			for k, v in _G.pairs(holder.particles) do
				local x = v.x * 20
				local y = v.y * 20
				local angle = v.angle
				local scale = v.scale
				local image = v.image
				
				local px, py = _G.res.getSpritePivot("", image)
				
				gamelua.setRenderState((x / scale), (y / scale), scale, scale, angle, px, py, v.alpha)
				_G.res.drawSprite("", image, 0, 0)
			end
		end
	end
	
	gamelua.setRenderState(0,0, 1, 1, 0, 0, 0, 1)
end

function EggPainterParticles:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end


function EggPainterParticles:startNewBirdParticles()
	if true then return end
	if self.particles == nil then		
		self.particles = {}		
	end
	
	if self.particles["NEW_BIRD"] == nil then
		self.particles["NEW_BIRD"] = ParticleHolder:new()
	end
		
	local world = 20
	
	local acc = 15
	
	local total = 20
	
	
	for i = 1, total do
		local x = self.particlesSources["NEW_BIRD"].x / world
		local y = self.particlesSources["NEW_BIRD"].y / world
		local speed = 5 + _G.math.random() * 7
		local velX = _G.math.cos((-_G.math.pi / total)*i) * speed * 1.4
		local velY = _G.math.sin((-_G.math.pi / total)*i) * speed
		local angleSpeed = _G.math.random(-6, 6)
		local startAngle = _G.math.random() * _G.math.pi
				
		local startScale = 1.6 + (_G.math.random() * 0.3)
		local endScale = 0
		local lifetime = _G.math.random(1, 2)
		local scaleSpeed = self.particles["NEW_BIRD"]:getSpeed(startScale, endScale, lifetime)
		
		local images = {"H_THINK_BUBBLE_1", "H_THINK_BUBBLE_2", "H_THINK_BUBBLE_4"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		local alphaSpeed = self.particles["NEW_BIRD"]:getSpeed(1, 0, lifetime)
		
		self.particles["NEW_BIRD"]:addParticle(x, y, velX, velY, 0, acc, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, alphaSpeed, image, lifetime)
	end
end

function EggPainterParticles:startDisappearBigBubbleParticles()
	if self.particles == nil then		
		self.particles = {}		
	end
	
	if self.particles["DISAPPEAR_BIG_BUBBLE"] == nil then
		self.particles["DISAPPEAR_BIG_BUBBLE"] = ParticleHolder:new()
	end
		
	local world = 20
	
	-- local acc = 15
	
	
	local total = 3
	
	local positions = {{x = 10, y = 10}, {x = -10, y = -10}, {x = -10, y = -10}}
	local velocities = {{x = 2, y = 2}, {x = -2, y = -2}, {x = -2, y = 2}}
	
	
	for i = 1, total do
		local x = self.particlesSources["DISAPPEAR_BIG_BUBBLE"].x / world
		local y = self.particlesSources["DISAPPEAR_BIG_BUBBLE"].y / world
		
		x = x + positions[i].x / world
		y = y + positions[i].y / world
		
		local acc = -1
		
		local speed = 1 + _G.math.random() * 0.5
		
		local velX = velocities[i].x * speed 
		local velY = velocities[i].y * speed 
		local angleSpeed = _G.math.random() * 1
		local startAngle = _G.math.random() * _G.math.pi
				
		local startScale = 1
		local endScale = 1.5 + (_G.math.random() * 0.3)
		local lifetime = 0.7
		local scaleSpeed = self.particles["DISAPPEAR_BIG_BUBBLE"]:getSpeed(startScale, endScale, lifetime)
		
		local images = {"H_THINK_BUBBLE_1", "H_THINK_BUBBLE_2", "H_THINK_BUBBLE_4"}
		local image = images[_G.math.random(1, #images)]
		
		
		local alphaSpeed = self.particles["DISAPPEAR_BIG_BUBBLE"]:getSpeed(1, 0, lifetime)
		
		
		self.particles["DISAPPEAR_BIG_BUBBLE"]:addParticle(x, y, velX, velY, 0, acc, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, alphaSpeed, 0, image, lifetime)
	end
end


function EggPainterParticles:startDisappearSmallBubbleParticles()
	if self.particles == nil then		
		self.particles = {}		
	end
	
	if self.particles["DISAPPEAR_SMALL_BUBBLE"] == nil then
		self.particles["DISAPPEAR_SMALL_BUBBLE"] = ParticleHolder:new()
	end
		
	local world = 20
	
	-- local acc = 15
	
	
	local total = 2
	
	local positions = {{x = 5 + (_G.math.random() * 7), y = 5 + (_G.math.random() * 7)}, {x = -13 + (_G.math.random() * 7), y = -13 + (_G.math.random() * 7)}}
	local velocities = {{x = -3 + (_G.math.random() * 6), y = -3 + (_G.math.random() * 6)}, {x = -3 + (_G.math.random() * 6), y = -3 + (_G.math.random() * 6)}}
	
	
	for i = 1, total do
		local x = self.particlesSources["DISAPPEAR_SMALL_BUBBLE"].x / world
		local y = self.particlesSources["DISAPPEAR_SMALL_BUBBLE"].y / world
		
		x = x + positions[i].x / world
		y = y + positions[i].y / world
		
		local acc = -1
		
		local speed = 1 + _G.math.random() * 0.5
		
		local velX = velocities[i].x * speed 
		local velY = velocities[i].y * speed 
		local angleSpeed = _G.math.random() * 1
		local startAngle = _G.math.random() * _G.math.pi
				
		local startScale = 1
		local endScale = 1.5 + (_G.math.random() * 0.3)
		local lifetime = 1
		local scaleSpeed = self.particles["DISAPPEAR_SMALL_BUBBLE"]:getSpeed(startScale, endScale, lifetime)
		
		local image = "H_THINK_BUBBLE_1", "H_THINK_BUBBLE_2"
		
		
		local alphaSpeed = self.particles["DISAPPEAR_SMALL_BUBBLE"]:getSpeed(1, 0, lifetime)
		
		
		self.particles["DISAPPEAR_SMALL_BUBBLE"]:addParticle(x, y, velX, velY, 0, acc, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, alphaSpeed, 0, image, lifetime)
	end
end



function EggPainterParticles:roundNumber(number)
	return _G.math.floor(number + 0.5)
end

filename="EggPainterParticles.lua"
