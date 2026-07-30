
----- Particle -----

-- Frame is the root class and common api of all components

Particle = {}    
function Particle:new(o)
	o = o or {}
	
	o.x = o.x or 0
	o.y = o.y or 0
	
	o.velX = o.velX or 0
	o.velY = o.velY or 0
	
	o.accX = o.accX or 0
	o.accY = o.accY or 0
	
	o.scale = o.scale or 1
	o.scaleSpeed = o.scaleSpeed or 0
	o.scaleAcc = o.scaleAcc or 0
	
	o.angle = o.angle or 0
	
	o.angleSpeed = o.angleSpeed or 0
	
	o.angleAcc = o.angleAcc or 0
	
	o.alpha = o.alpha or 1
	o.alphaSpeed = o.alphaSpeed or 0
	o.alphaAcc = o.alphaAcc or 0
	
	o.image = o.image or ""
	
	
	
	
	o.lifetime = o.lifetime or -1
	
	
	
	
	_G.setmetatable(o, self)
	self.__index = self
	-- o:init()
	return o
end



function Particle:update(dt, time) 
	self.velX = self.velX + dt * self.accX
	self.velY = self.velY + dt * self.accY
	
	self.x = self.x + dt * self.velX
	self.y = self.y + dt * self.velY
	
	self.angleSpeed = self.angleSpeed + dt * self.angleAcc	
	self.angle = self.angle + dt * self.angleSpeed
	
	self.scaleSpeed = self.scaleSpeed + dt * self.scaleAcc	
	self.scale = self.scale + dt * self.scaleSpeed
	
	self.alphaSpeed = self.alphaSpeed + dt * self.alphaAcc	
	self.alpha = self.alpha + dt * self.alphaSpeed
	
	
	self.lifetime = self.lifetime - dt
	
end



filename="Particle.lua"
