
----- ParticleHolder -----

-- Frame is the root class and common api of all components

ParticleHolder = {}    
function ParticleHolder:new(o)
	o = o or {}
	
	
	
	o.particles = {}
	
	
	_G.setmetatable(o, self)
	self.__index = self
	-- o:init()
	return o
end

function ParticleHolder:addParticle(particleX, particleY, particleVelX, particleVelY, particleAccX, particleAccY, particleAngle, particleAngleSpeed, 
									particleAgleAcc, particleScale, particleScaleSpeed, particleScaleAcc,
									particleAlpha, particleAlphaSpeed, particleAlphaAcc,particleImage, particleLifetime)
	local particle = Particle:new({	x = particleX, y = particleY, velX = particleVelX, velY = particleVelY, accX = particleAccX,  accY = particleAccY, 
									angle = particleAngle, angleSpeed = particleAngleSpeed, angleAcc = particleAgleAcc, 
									scale = particleScale, scaleSpeed = particleScaleSpeed, scaleAcc = particleScaleAcc, 
									alpha = particleAlpha, alphaSpeed = particleAlphaSpeed, alphaAcc = particleAlphaAcc, 
									
									image = particleImage, lifetime = particleLifetime})
									
	_G.table.insert(self.particles, particle)
end



function ParticleHolder:update(dt, time) 
	
	local index = 1
	for k, v in _G.pairs(self.particles) do
		v:update(dt, time)
		if v.lifetime <= 0 then
			_G.table.remove(self.particles, index)			
		end
		index = index +1
	end
	
end

function ParticleHolder:getSpeed(startValue, endValue, lifetime)
	return (endValue - startValue) / lifetime
end



filename="ParticleHolder.lua"
