NestViewParticles = {}

function NestViewParticles:new(o)

	
	object = {}

	
	
	
	_G.setmetatable(object, self)
	self.__index = self
	return object
end

function NestViewParticles:setSource(sourceX, sourceY, particleSystemID)
	if self.particlesSources == nil then
		self.particlesSources = {}
		
	end
	
	self.particlesSources[particleSystemID] = {x= sourceX, y = sourceY}
end

function NestViewParticles:update(dt, time) 
	if self.particles ~= nil then
		for k, holder in _G.pairs(self.particles) do
			holder:update(dt, time)
		end
	end
end

function NestViewParticles:drawAllParticlesExcept(exceptList)
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
					gamelua.setRenderState((x / scale), (y / scale), scale, scale, angle, px, py)
					_G.res.drawSprite("", image, 0, 0)
				end
			end
		end
	end
end

function NestViewParticles:drawSpecificParticles(particlesToDrawList)
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
					gamelua.setRenderState((x / scale), (y / scale), scale, scale, angle, px, py)
					_G.res.drawSprite("", image, 0, 0)
				end
			end
		end
	end
end



function NestViewParticles:draw() 
	if self.particles ~= nil then
		for kk, holder in _G.pairs(self.particles) do
			
			for k, v in _G.pairs(holder.particles) do
				local x = v.x * 20
				local y = v.y * 20
				local angle = v.angle
				local scale = v.scale
				local image = v.image
				
				local px, py = _G.res.getSpritePivot("", image)
				
				gamelua.setRenderState((x / scale), (y / scale), scale, scale, angle, px, py)
				_G.res.drawSprite("", image, 0, 0)
			end
		end
	end
end

function NestViewParticles:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end


function NestViewParticles:startLevelUpParticles()
	if self.particles == nil then		
		self.particles = {}		
	end
	
	if self.particles["LEVEL_UP"] == nil then
		self.particles["LEVEL_UP"] = ParticleHolder:new()
	end
		
	local world = 20
	
	local acc = 15
	
	local total = 20
	
	
	for i = 1, total do
		local x = self.particlesSources["LEVEL_UP"].x / world
		local y = self.particlesSources["LEVEL_UP"].y / world
		local speed = 5 + _G.math.random() * 7
		local velX = _G.math.cos((-_G.math.pi / total)*i) * speed * 1.4
		local velY = _G.math.sin((-_G.math.pi / total)*i) * speed
		local angleSpeed = _G.math.random(-6, 6)
		local startAngle = _G.math.random() * _G.math.pi
				
		local startScale = 1.6 + (_G.math.random() * 0.3)
		local endScale = 0
		local lifetime = _G.math.random(1, 2)
		local scaleSpeed = self.particles["LEVEL_UP"]:getSpeed(startScale, endScale, lifetime)
		
		local images = {"H_P_LEVEL_UP_STAR_1", "H_P_LEVEL_UP_STAR_2", "H_P_LEVEL_UP_STAR_3"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["LEVEL_UP"]:addParticle(x, y, velX, velY, 0, acc, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
end

function NestViewParticles:startHatchParticles()
	if self.particles == nil then
		-- self.particles = ParticleHolder:new()
		self.particles = {}
		
	end
	
	if self.particles["HATCH_BIRD"] == nil then
		self.particles["HATCH_BIRD"] = ParticleHolder:new()
	end
		
	local world = 20
	
	local accSmoke = 6
	
	local accShells = 30
	
	local totalSmoke = 6
	
	local totalShells = 5
	
	
	for i = 1, totalSmoke do
		local x = self.particlesSources["HATCH_BIRD"].x / world
		local y = self.particlesSources["HATCH_BIRD"].y / world
		local velX = _G.math.random(-20, 20)
		local velY = _G.math.random(-15, 7)
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.5 + _G.math.random(0, 1) * 0.5
		local endScale = _G.math.random(2, 3)
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = self.particles["HATCH_BIRD"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_SMOKE_1", "H_P_SMOKE_2"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["HATCH_BIRD"]:addParticle(x, y, velX, velY, 0, accSmoke, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
	for i = 1, totalShells do
		local x = self.particlesSources["HATCH_BIRD"].x / world
		local y = self.particlesSources["HATCH_BIRD"].y / world
		local speed = _G.math.random(10, 20)
		local velX = _G.math.cos((-_G.math.pi / totalShells)*i) * speed * 2
		local velY = _G.math.sin((-_G.math.pi / totalShells)*i) * speed * 2
		local angleSpeed = _G.math.random(-20, 20)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 1 + _G.math.random(0, 1) * 0.4
		local endScale = 0.6
		local lifetime = 3.5
		local scaleSpeed = self.particles["HATCH_BIRD"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_EGG_1", "H_P_EGG_2", "H_P_EGG_3"}
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["HATCH_BIRD"]:addParticle(x, y, velX, velY, 0, accShells, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
end

function NestViewParticles:startNestReadyParticles()
	if self.particles == nil then
		-- self.particles = ParticleHolder:new()
		self.particles = {}
		
	end
	
	if self.particles["NEST_READY"] == nil then
		self.particles["NEST_READY"] = ParticleHolder:new()
	end
		
	local world = 20
	
	local accSmoke = 6
	
	local accNest = 50
	
	local totalSmoke = 7
	
	local totalNest = 25
	
	
	for i = 1, totalSmoke do
		local x = self.particlesSources["NEST_READY"].x / world
		local y = self.particlesSources["NEST_READY"].y / world
		local velX = _G.math.random(-20, 20)
		local velY = _G.math.random(-15, 7)
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.5 + _G.math.random(0, 1) * 0.5
		local endScale = _G.math.random(2, 3)
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = self.particles["NEST_READY"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_SMOKE_1", "H_P_SMOKE_2"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["NEST_READY"]:addParticle(x, y, velX, velY, 0, accSmoke, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
	for i = 1, totalNest do
		local x = self.particlesSources["NEST_READY"].x / world
		local y = self.particlesSources["NEST_READY"].y / world
		local speed = _G.math.random(10, 20)
		local velX = _G.math.cos((-_G.math.pi / totalNest)*i) * speed * 2
		local velY = _G.math.sin((-_G.math.pi / totalNest)*i) * speed * 2
		local angleSpeed = _G.math.random(-20, 20)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.3 + _G.math.random(0, 1) * 0.75
		local endScale = 0
		local lifetime = 3.5
		local scaleSpeed = self.particles["NEST_READY"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_NEST_RED_1", "H_P_NEST_RED_2", "H_P_NEST_RED_3"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["NEST_READY"]:addParticle(x, y, velX, velY, 0, accNest, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
end

function NestViewParticles:startNestBuildingParticles()
	if self.particles == nil then
		-- self.particles = ParticleHolder:new()
		self.particles = {}
		
	end
	
	if self.particles["NEST_READY"] == nil then
		self.particles["NEST_READY"] = ParticleHolder:new()
	end
		
	local world = 20
	
	local accSmoke = 4
	
	local accNest = 35
	
	local totalSmoke = 4
	
	local totalNest = 10
	
	
	for i = 1, totalSmoke do
		local x = self.particlesSources["NEST_READY"].x / world
		local y = self.particlesSources["NEST_READY"].y / world
		local velX = _G.math.random(-7, 7)
		local velY = _G.math.random(-7, 4)
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.5 + _G.math.random(0, 1) * 0.5
		local endScale = _G.math.random(2, 3)
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = self.particles["NEST_READY"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_SMOKE_1", "H_P_SMOKE_2"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["NEST_READY"]:addParticle(x, y, velX, velY, 0, accSmoke, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
	for i = 1, totalNest do
		local x = self.particlesSources["NEST_READY"].x / world
		local y = self.particlesSources["NEST_READY"].y / world
		local speed = _G.math.random(10, 20)
		local velX = _G.math.cos((-_G.math.pi / totalNest)*i) * speed 
		local velY = _G.math.sin((-_G.math.pi / totalNest)*i) * speed 
		local angleSpeed = _G.math.random(-20, 20)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.3 + _G.math.random(0, 1) * 0.75
		local endScale = 0
		local lifetime = 3.5
		local scaleSpeed = self.particles["NEST_READY"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_NEST_RED_1", "H_P_NEST_RED_2", "H_P_NEST_RED_3"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["NEST_READY"]:addParticle(x, y, velX, velY, 0, accNest, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
end

function NestViewParticles:startEggBuildingParticles()
	if self.particles == nil then
		-- self.particles = ParticleHolder:new()
		self.particles = {}
		
	end
	
	if self.particles["NEST_READY"] == nil then
		self.particles["NEST_READY"] = ParticleHolder:new()
	end
		
	local world = 20
	
	local accSmoke = 4
	
	local accNest = 35
	
	local totalSmoke = 4
	
	local totalNest = 10
	
	
	for i = 1, totalSmoke do
		local x = self.particlesSources["NEST_READY"].x / world
		local y = self.particlesSources["NEST_READY"].y / world
		local velX = _G.math.random(-7, 7)
		local velY = _G.math.random(-7, 4)
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.5 + _G.math.random(0, 1) * 0.5
		local endScale = _G.math.random(2, 3)
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = self.particles["NEST_READY"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_SMOKE_1", "H_P_SMOKE_2"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["NEST_READY"]:addParticle(x, y, velX, velY, 0, accSmoke, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
	for i = 1, totalNest do
		local x = self.particlesSources["NEST_READY"].x / world
		local y = self.particlesSources["NEST_READY"].y / world
		local speed = _G.math.random(10, 20)
		local velX = _G.math.cos((-_G.math.pi / totalNest)*i) * speed 
		local velY = _G.math.sin((-_G.math.pi / totalNest)*i) * speed 
		local angleSpeed = _G.math.random(-20, 20)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = 0.3 + _G.math.random(0, 1) * 0.75
		local endScale = 0
		local lifetime = 3.5
		local scaleSpeed = self.particles["NEST_READY"]:getSpeed(startScale, endScale, lifetime)
		
		local images = { "H_P_NEST_RED_1", "H_P_NEST_RED_2", "H_P_NEST_RED_3"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["NEST_READY"]:addParticle(x, y, velX, velY, 0, accNest, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
end


function NestViewParticles:roundNumber(number)
	return _G.math.floor(number + 0.5)
end

filename="NestViewParticles.lua"
