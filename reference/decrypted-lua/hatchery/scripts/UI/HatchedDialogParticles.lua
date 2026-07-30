HatchedDialogParticles = {}

function HatchedDialogParticles:new(o)

	
	object = {}

	
	
	
	_G.setmetatable(object, self)
	self.__index = self
	return object
end


function HatchedDialogParticles:update(dt, time) 
	if self.particles ~= nil then
		for k, holder in _G.pairs(self.particles) do
			holder:update(dt, time)
		end
	end
end


function HatchedDialogParticles:draw() 
	local world = 20
	if self.particles ~= nil then
		for kk, holder in _G.pairs(self.particles) do
			
			for k, v in _G.pairs(holder.particles) do
				local x = v.x *world
				local y = v.y *world
				local angle = v.angle
				local scale = v.scale
				local image = v.image
				
				local px, py = _G.res.getSpritePivot("", image)
				
				gamelua.setRenderState(0, 0, scale, scale, angle, px, py)
				_G.res.drawSprite("", image, x/scale, y/scale)
			end
		end
	end
	gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
end


function HatchedDialogParticles:setSource(sourceX, sourceY, particleSystemID)
	if self.particlesSources == nil then
		self.particlesSources = {}
		
	end
	
	self.particlesSources[particleSystemID] = {x= sourceX, y = sourceY}
end

function HatchedDialogParticles:clearParticles()
	self.particles = nil
end

function HatchedDialogParticles:spawnHatchedParticles()
	if self.particles == nil then
		-- self.particles = ParticleHolder:new()
		self.particles = {}
		
	end
	
	if self.particles["HATCH_EXPLOSION"] == nil then
		self.particles["HATCH_EXPLOSION"] = ParticleHolder:new()
	end
		
	
	local totalSmoke = 10
	
	local totalStars = 30
	
	local totalFeathers = 10
	
	local world = 20
	
	
	for i = 1, totalSmoke do
		local x = self.particlesSources["HATCH_EXPLOSION"].x / world
		local y = self.particlesSources["HATCH_EXPLOSION"].y / world
		local velX = _G.math.random(-20, 20) 
		local velY = _G.math.random(-20, 5) 
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = _G.math.random(1, 2)
		local endScale = 0
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = (endScale-startScale) / lifetime
		
		local accX = velX * _G.math.random() * 0.1
		local accY = velX * _G.math.random() * 0.1
		
		local images = { "H_P_SMOKE_1", "H_P_SMOKE_2"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["HATCH_EXPLOSION"]:addParticle(x, y, velX, velY, accX, accY, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
	for i = 1, totalFeathers do
		local x = self.particlesSources["HATCH_EXPLOSION"].x / world
		local y = self.particlesSources["HATCH_EXPLOSION"].y / world
		local velX = _G.math.random(-20, 20) 
		local velY = _G.math.random(-20, 5) 
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = _G.math.random(1, 2)
		local endScale = 0
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = (endScale-startScale) / lifetime
		
		local accX = velX * _G.math.random() * 0.1
		local accY = velX * _G.math.random() * 0.1
		
		local images = { "H_P_LEVEL_FEATHER_1", "H_P_LEVEL_FEATHER_2"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["HATCH_EXPLOSION"]:addParticle(x, y, velX, velY, accX, accY, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
	for i = 1, totalStars do
		local x = self.particlesSources["HATCH_EXPLOSION"].x / world
		local y = self.particlesSources["HATCH_EXPLOSION"].y / world
		local velX = _G.math.random(-40, 40) 
		local velY = _G.math.random(-30, 30) 
		local angleSpeed = _G.math.random(-3, 3)
		local startAngle = _G.math.random() * _G.math.pi
		
		local startScale = _G.math.random(1, 2)
		local endScale = 0
		local lifetime = _G.math.random(4, 6)
		local scaleSpeed = (endScale-startScale) / lifetime
		
		local accX = velX * _G.math.random() * 0.2
		local accY = velY * _G.math.random() * 0.2
		
		local images = { "H_STAR_MEDIUM", "H_STAR_SMALL", "H_P_LEVEL_UP_STAR_1", "H_P_LEVEL_UP_STAR_2", "H_P_LEVEL_UP_STAR_3"}
		
		local index = self:roundNumber(_G.math.random() * (#images - 1))
		local image = images[index+1]
		
		self.particles["HATCH_EXPLOSION"]:addParticle(x, y, velX, velY, accX, accY, startAngle, angleSpeed, 0, startScale, scaleSpeed, 0, 1, 0, 0, image, lifetime)
	end
	
end

function HatchedDialogParticles:roundNumber(number)
	return _G.math.floor(number + 0.5)
end

filename="HatchedDialogParticles.lua"
