gamelua.loadLuaFileToObject("hatchery/scripts/birdDefinitions.lua", this, "")

				

	
function Bird:new(o)

	_G.assert(o.id, "Error while creating new bird: Id not defined.")
	_G.assert(o.shape, "Error while creating new bird: Shape not defined.")
	-- _G.assert(o.sprite, "Error while creating new bird: Sprite not defined.")
	-- _G.assert(o.spriteBlink, "Error while creating new bird: SpriteBlink not defined.")
	
	object = {}
	object.shape = o.shape
	object.id = o.id
	--for now use some defaults. later on these should always be specified
	object.color = o.color or Bird.COLOR.RED
	object.beak = o.beak or Bird.BEAK.RED
	object.eyes = o.eyes or Bird.EYES.RED
	
	-- object.sprite = o.sprite
	-- object.spriteBlink = o.spriteBlink
	object.sprite = Bird.Sprites.Body[object.shape][object.color]
	object.sprites = o.sprites or 	{
										{sprite = Bird.Sprites.Body[object.shape][object.color], x = 0, y = 0, scale = 1, angle = 0},										
										{sprite = Bird.Sprites.Eyes[object.eyes], x = 0, y = 0, scale = 1, angle = 0},
										{sprite = Bird.Sprites.Beaks[object.beak], x = 0, y = 0, scale = 1, angle = 0},
									}
	object.recipe = o.recipe
	object.spriteBlink = Bird.Sprites.Body[object.shape][object.color]
	object.accessories = {}
	
	--for items that change like body (black bird becomes orange), beaks (shouting) and eyes, we need to store their indices from the sprites table
	-- so that we can switch those sprites dynamically, those values are changed during editing, when the user changes the layering order of items
	object.bodyIndex = o.bodyIndex
	object.beakIndex = o.beakIndex
	object.eyesIndex = o.eyesIndex

	
	_G.setmetatable(object, self)
	self.__index = self

	--check if this bird has particle mappings and save the reference
	for k,v in _G.pairs(gamelua.hatcheryParticleTable.flightParticleMappings) do
		for kk, vv in _G.pairs(v) do
			if object.id == vv then
				object.flightParticle = k
				break
			end
		end
	end

	return object
end

function Bird:calculateDefaultItemsIndices()
	if self.bodyIndex == nil or self.beakIndex == nil or self.eyesIndex == nil then
	
		--recalculates the basic items indices, only changes if the layering order has changed
		local basicBodySprite = Bird.Sprites.Body[self.shape][self.color]
		local basicBeakSprite = Bird.Sprites.Beaks[self.beak]
		local basicEyesSprite = Bird.Sprites.Eyes[self.eyes]
		
		self.bodyIndex = self:getSpriteIndexInList(self.sprites, basicBodySprite)
		self.beakIndex = self:getSpriteIndexInList(self.sprites, basicBeakSprite)
		self.eyesIndex = self:getSpriteIndexInList(self.sprites, basicEyesSprite)
	end
end


function Bird:getSpriteIndexInList(list, sprite)
	
	local index = 1
	for k, v in _G.pairs(list) do
		if v.sprite == sprite then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end


function Bird:getId()
	return self.id
end

function Bird:getShape()
	return self.shape
end

function Bird:getColor()
	return self.color
end

function Bird:getBeak()
	return self.beak
end

function Bird:getEyes()
	return self.eyes
end

function Bird:isCollected()
	return self.collected
end

function Bird:animationEyes(obj)
	gamelua.changeHatcheryBirdEyesSprite(obj.name, obj.hatcheryBird, Bird.Sprites.Blink[obj.hatcheryBird.eyes])
end

function Bird:animationBeak(obj)
	gamelua.changeHatcheryBirdBeakSprite(obj.name, obj.hatcheryBird, Bird.Sprites.BeaksYell[obj.hatcheryBird.beak])
end

function Bird:animationReset(obj)
	gamelua.setupCompoObject(obj.name, obj.hatcheryBird.sprites, Bird.ingameScaling[obj.hatcheryBird.shape])
end

function Bird:getIngameSize(radius)
	local scale = 1--self.sprites[self.bodyIndex].scale*radius
	return scale
end

--trail

function Bird:getTrajectorySprites()
	return "H_P_TRAIL_"..self.color.."_1", "H_P_TRAIL_"..self.color.."_2", "H_P_TRAIL_"..self.color.."_3", "BIRD_SPECIAL"
end

-- this is called when the ingame bird is set as hatchery bird. This can be used to manipulate for example the particles of the bird
function Bird:setupBird(bird)
	bird.definition = Bird.definitionsMapping[self.color]
	bird.damageFactors = gamelua.blockTable.blocks[Bird.definitionsMapping[self.color]].damageFactors
	self.ingameBird = bird
end
--collision handling
function Bird:collided(obj1, obj2)
	if obj1.hasCollided == false then
		obj1.hasCollided = true
	end
	
	--blueblack bomblings
	if (obj1.bombling or (self.shape == Bird.SHAPE.BLUE and self.color == Bird.COLOR.BLACK)) and not obj2.bombling then
		--gamelua.makeClickExplosion(obj1.x, obj1.y, 20, 20, 30, 30, gamelua.getAudioName(gamelua.blockTable.blocks[obj1.definition].specialSound))
		self:makeExplosion(obj1, 20000, 10,200, 3,Bird.specialtySounds.EXPLOSION)
		self:addParticles(obj1.name, "explosion", 1, true,false)
		self:addParticles(obj1.name, "explosionBuff", 1, true,false)
		obj1.frozen = true
	
	
	elseif self.shape == Bird.SHAPE.BLACK and (self.color == Bird.COLOR.BLUE or self.color == Bird.COLOR.YELLOW) then
		if not self.bombTimer or not self.bombObject then
			self.bombTimer = 1
			self.bombObject = obj1
		end
	elseif (self.shape == Bird.SHAPE.WHITE and self.color == Bird.COLOR.BLACK) and obj2.bombling ~= true then
		self:makeExplosion(obj1, 20000, 10,200, 3,Bird.specialtySounds.EXPLOSION)
		self:addParticles(obj1.name, "explosion", 1, true,false)
		self:addParticles(obj1.name, "explosionBuff", 1, true,false)
		obj1.frozen = true
		
	elseif self.shape == Bird.SHAPE.BLACK and  self.color == Bird.COLOR.WHITE then
		if not self.bombTimer or not self.bombObject then
			self.bombTimer = 1
			self.bombObject = obj1
		end
	end
end

function Bird:triggerSpecialty(obj)
	if gamelua.birdSpecialtyAvailable then
		gamelua.birdSpecialtyAvailable = false
		
		--check the proper specialty function and call it.
		if self.shape == Bird.SHAPE.BLUE then
			if self.color == Bird.COLOR.BLACK then
				self:specialtyBlueBlack(obj)
			elseif self.color == Bird.COLOR.YELLOW then
				if not obj.hasCollided then
					self:specialtyBlueYellow(obj)
				end
			end
		elseif self.shape == Bird.SHAPE.YELLOW then
			if self.color == Bird.COLOR.BLACK then
				self:specialtyYellowBlack(obj)
			elseif self.color == Bird.COLOR.BLUE then
				if not obj.hasCollided then
					self:specialtyYellowBlue(obj) 
				end
			end
		elseif self.shape == Bird.SHAPE.BLACK then
			if self.color == Bird.COLOR.BLUE then
				self:specialtyBlackBlue(obj)
			elseif self.color == Bird.COLOR.YELLOW then
				self:specialtyBlackYellow(obj)
			elseif self.color == Bird.COLOR.WHITE then
				self:specialtyBlackWhite(obj)
			end
		elseif self.shape == Bird.SHAPE.WHITE then
			if self.color == Bird.COLOR.BLACK then
				self:specialtyWhiteBlack(obj)
			end
		end
		
	end
end


function Bird:birdLaunched(obj)
	if self.shape == Bird.SHAPE.BLACK and self.color == Bird.COLOR.YELLOW then
		local audioIndex = _G.math.random(1,#Bird.specialtySounds.DUMB_YELL)
		_G.res.playAudio(Bird.specialtySounds.DUMB_YELL[audioIndex], 1, false)
	end
end

--update

function Bird:update(dt, time)
	-- ticking bomb
	if self.bombTimer then
		self.bombTimer = self.bombTimer - dt
		if self.bombTimer < 0 then
			self.bombTimer = nil
			self:triggerSpecialty(self.bombObject)
			self.bombObject = nil
		end
	end
	
	self:spawnFlyingParticles(dt)
	
	--if the bird is "crap", make it fly incoherent
	if self.shape == Bird.SHAPE.BLACK and self.color == Bird.COLOR.YELLOW and self.ingameBird.shot == true and self.ingameBird.hasCollided ~= true then
	
		local mass, forceMultiplier, frequency = self.ingameBird.mass, 3,  1000*_G.math.pi
		
		
		if not self.crapBirdImpulseTimer or self.crapBirdImpulseTimer < 0 then
			self.crapBirdImpulseTimer = 0.02 +  _G.math.random()*0.06
			local forcex, forcey = _G.math.cos(time*frequency)*forceMultiplier*mass, _G.math.cos(time*frequency)*forceMultiplier*mass
			gamelua.setAngularVelocity(self.ingameBird.name, 0)
			gamelua.applyImpulse( self.ingameBird.name,
								forcex,
								forcey,
								self.ingameBird.x,
								self.ingameBird.y )
		end
		self.crapBirdImpulseTimer = self.crapBirdImpulseTimer - dt
		
	end
	
end


function Bird:spawnFlyingParticles(dt)
	
	if not self.flightParticle or not self.ingameBird or not self.ingameBird.shot or self.ingameBird.hasCollided then
		return
	end
	
	
	if not self.flyingParticlesTimer or self.flyingParticlesTimer < 0 then
		self.flyingParticlesTimer = 0.05
		local x,y = self.ingameBird.x, self.ingameBird.y
		local velY, velX = gamelua.vNormalize(self.ingameBird.yVel, self.ingameBird.xVel)
		x,y = x - velX * 3, y - velY*3
		
		self:addParticles(self.ingameBird.name,self.flightParticle , 2, false, false,x,y)	
	end
	
	self.flyingParticlesTimer = self.flyingParticlesTimer - dt
	
end

-- addparticles function, where you can optionally override the particle spawn position 
function Bird:addParticles(object, particle, amount, ignoreLimits, menu, x, y)
	
	local obj = gamelua.objects.world[object]
	if obj == nil then
		return
	end
	
	x = x or obj.x
	y = y or obj.y
	
	x,y = gamelua.physicsToWorldTransform(x, y)
	
	local w, h = 1, 1
	if obj.radius == nil then
		w, h = gamelua.physicsToWorldTransform(obj.width, obj.height)
	else
		w, h = gamelua.physicsToWorldTransform(obj.radius*2, obj.radius*2)
	end

	if particle[1] then
		for i = 1, #particle do
			
			if gamelua.particleTable.particles[particle[i] ].amount then
				amount = gamelua.particleTable.particles[particle[i] ].amount
			end
			
			gamelua.newParticles(particle[i], amount, x, y, w, h, gamelua.getAngle(obj.name), ignoreLimits, menu)
			
			--addParticles(k, particle[i], particleAmount, false, false)
			--_G.particles.addParticles(type, amount, x, y, w, h, angle, ignoreLimits, menu)
		end
	else
		if particle and gamelua.particleTable.particles[particle] and gamelua.particleTable.particles[particle].amount then
			particleAmount = gamelua.particleTable.particles[particle].amount
		end
		gamelua.newParticles(particle, amount, x, y, w, h, gamelua.getAngle(obj.name), ignoreLimits, menu)
		
		--_G.particles.addParticles(type, particle, particleAmount, false, false)
        --_G.particles.addParticles(type, amount, x, y, w, h, angle, ignoreLimits, menu)
	end	
	
	--newParticles(particle, amount, x, y, w, h, getAngle(obj.name), ignoreLimits, menu)
end


-------Specialties

function Bird:specialtyBlueBlack(obj)
	local lx, ly = gamelua.physicsToWorldTransform(obj.x, obj.y)
	gamelua.addPuffToTrajectory(1, lx, ly)
	
	local definition = Bird.definitionsMapping[self.color]
				
	local x, y = gamelua.vNormalize(obj.yVel, -obj.xVel)
	local newName = obj.name .. "a"
	gamelua.createCircle(newName, self.sprite, obj.x - x, obj.y - y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = obj.xVel - x*7
	gamelua.objects.world[newName].yVel = obj.yVel - y*7
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.objects.world[newName].bombling = true
	gamelua.setSprite(newName, obj.damageSprite)
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, obj.xVel - x*7, obj.yVel - y*7)
	--_G.table.insert(extraObjects, newName)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	
	
	newName = obj.name .. "b"
	gamelua.createCircle(newName, self.sprite, obj.x, obj.y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite				
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = obj.xVel
	gamelua.objects.world[newName].yVel = obj.yVel
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.objects.world[newName].bombling = true
	gamelua.setSprite(newName, obj.damageSprite)				
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, obj.xVel, obj.yVel)
	--_G.table.insert(extraObjects, newName)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	newName = obj.name .. "c"
	gamelua.createCircle(newName, self.sprite, obj.x + x, obj.y + y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite				
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = obj.xVel + x*7
	gamelua.objects.world[newName].yVel = obj.yVel + y*7
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.objects.world[newName].bombling = true
	gamelua.setSprite(newName, obj.damageSprite)				
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, obj.xVel + x*7, obj.yVel + y*7)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	gamelua.otherBirds = { obj.name .. "a", obj.name .. "b" }
	self:removeHatcheryBird(obj)
	--objects.world[obj.name] = nil
	obj = gamelua.objects.world[newName]
	gamelua.cameraTargetObject = obj
	gamelua.flyingBird = obj
	
	
	_G.res.playAudio(Bird.specialtySounds.DIVIDE, 1, false)	
end


function Bird:specialtyBlackBlue(obj)
		local lx, ly = gamelua.physicsToWorldTransform(obj.x, obj.y)
	gamelua.addPuffToTrajectory(1, lx, ly)
	
	local definition = Bird.definitionsMapping[self.color]
				
	local newName = obj.name .. "a"
	gamelua.createCircle(newName, self.sprite, obj.x  - 1, obj.y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = -20
	gamelua.objects.world[newName].yVel = -20
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.setSprite(newName, obj.damageSprite)
	gamelua.setVelocity(newName, -20, -20)
	--_G.table.insert(extraObjects, newName)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	
	
	newName = obj.name .. "b"
	gamelua.createCircle(newName, self.sprite, obj.x, obj.y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite				
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = 0
	gamelua.objects.world[newName].yVel = -20
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.setSprite(newName, obj.damageSprite)				
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, 0, -20)
	--_G.table.insert(extraObjects, newName)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	newName = obj.name .. "c"
	gamelua.createCircle(newName, self.sprite, obj.x + 1, obj.y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite				
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = 20
	gamelua.objects.world[newName].yVel = -20
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.setSprite(newName, obj.damageSprite)				
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName,20, -20)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	gamelua.otherBirds = { obj.name .. "a", obj.name .. "b" }

	self:makeExplosion(obj, 40000, 20,400, 5,Bird.specialtySounds.EXPLOSION)
	self:addParticles(obj.name, "explosion", 1, true,false)
	self:addParticles(obj.name, "explosionBuff", 1, true,false)
	self:removeHatcheryBird(obj)
	
	--objects.world[obj.name] = nil
	obj = gamelua.objects.world[newName]
	gamelua.cameraTargetObject = obj
	gamelua.flyingBird = obj
	
	_G.res.playAudio(Bird.specialtySounds.DIVIDE, 1, false)	
end

function Bird:specialtyBlueYellow(obj)
	local lx, ly = gamelua.physicsToWorldTransform(obj.x, obj.y)
	gamelua.addPuffToTrajectory(1, lx, ly)
	
	local definition = Bird.definitionsMapping[self.color]
	local boost = -gamelua.boostForce * gamelua.physicsScale * obj.mass/4
				
	local x, y = gamelua.vNormalize(obj.yVel, -obj.xVel)
	local newName = obj.name .. "a"
	gamelua.createCircle(newName, self.sprite, obj.x - x*2, obj.y - y*2, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = obj.xVel*boost 
	gamelua.objects.world[newName].yVel = (obj.yVel+2)*boost 
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.setSprite(newName, obj.damageSprite)
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, gamelua.objects.world[newName].xVel, gamelua.objects.world[newName].yVel)
	--_G.table.insert(extraObjects, newName)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	
	
	newName = obj.name .. "b"
	gamelua.createCircle(newName, self.sprite, obj.x, obj.y, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite				
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = obj.xVel*boost
	gamelua.objects.world[newName].yVel = obj.yVel*boost
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.setSprite(newName, obj.damageSprite)				
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, gamelua.objects.world[newName].xVel, gamelua.objects.world[newName].yVel)
	--_G.table.insert(extraObjects, newName)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	newName = obj.name .. "c"
	gamelua.createCircle(newName, self.sprite, obj.x + x*2, obj.y + y*2, obj.radius, obj.density, obj.friction, obj.restitution, obj.controllable, obj.z_order)
	gamelua.objects.world[newName].definition = definition
	gamelua.objects.world[newName].controllable = obj.controllable
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].levelGoal = obj.levelGoal
	gamelua.objects.world[newName].damageFactors = obj.damageFactors
	gamelua.objects.world[newName].spritePivotX = obj.spritePivotX
	gamelua.objects.world[newName].spritePivotY = obj.spritePivotY
	gamelua.objects.world[newName].damageSprite = obj.damageSprite				
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].shot = true
	gamelua.objects.world[newName].sleeping = false
	gamelua.objects.world[newName].hasCollided = false
	gamelua.objects.world[newName].parentName = obj.name
	gamelua.objects.world[newName].xVel = obj.xVel*boost 
	gamelua.objects.world[newName].yVel = (obj.yVel-2)*boost 
	gamelua.objects.world[newName].hatcheryBird = self
	gamelua.setSprite(newName, obj.damageSprite)				
	gamelua.setRotation(newName, obj.angle)
	gamelua.setVelocity(newName, gamelua.objects.world[newName].xVel, gamelua.objects.world[newName].yVel)
	gamelua.birds[newName] = gamelua.objects.world[newName]
	gamelua.setupCompoObject(newName, self.sprites, Bird.ingameScaling[self.shape])
	
	gamelua.otherBirds = { obj.name .. "a", obj.name .. "b" }
	self:removeHatcheryBird(obj)
	--objects.world[obj.name] = nil
	obj = gamelua.objects.world[newName]
	gamelua.cameraTargetObject = obj
	gamelua.flyingBird = obj
	
	_G.res.playAudio(Bird.specialtySounds.DIVIDE, 1, false)
	_G.res.playAudio(Bird.specialtySounds.SPEED, 1, false)		
end

function Bird:specialtyBlackWhite(obj)



	for i=1,5 do

		local x, y = _G.math.cos((i/5)*_G.math.pi*2), _G.math.sin((i/5)*_G.math.pi*2)
		local newName = obj.name .. "eggBomb" .. i
		
		gamelua.createCircle(newName, "DROPPABLE_EGG", obj.x + x*3, obj.y +y*3 , obj.radius, obj.density, obj.friction, obj.restitution, true, obj.z_order)
		gamelua.objects.world[newName].definition = "EggGranade"
		gamelua.objects.world[newName].controllable = true
		gamelua.objects.world[newName].strength = obj.strength
		gamelua.objects.world[newName].defence = obj.defence
		gamelua.objects.world[newName].material = obj.material
		gamelua.objects.world[newName].damageFactors = gamelua.blockTable.blocks[gamelua.objects.world[newName].definition].damageFactors
		gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
		gamelua.objects.world[newName].levelGoal = false
		local xp, yp = _G.res.getSpritePivot("INGAME_BIRDS_1","DROPPABLE_EGG")
		gamelua.objects.world[newName].spritePivotX = xp
		gamelua.objects.world[newName].bombling = true 
		gamelua.objects.world[newName].spritePivotY = yp
		gamelua.objects.world[newName].damageSprite = "DROPPABLE_EGG"
		gamelua.objects.world[newName].xVel = _G.math.cos((i/5)*_G.math.pi*2)*40
		gamelua.objects.world[newName].yVel = _G.math.sin((i/5)*_G.math.pi*2) *40
		gamelua.setSprite(newName, gamelua.objects.world[newName].damageSprite)
		gamelua.setRotation(newName, obj.angle)

		gamelua.setVelocity(newName, gamelua.objects.world[newName].xVel, gamelua.objects.world[newName].yVel)

		_G.table.insert(gamelua.flyingGrenades, { name = newName, timer = 5 })

	end
	local lx, ly = gamelua.physicsToWorldTransform(obj.x, obj.y)	
	gamelua.addPuffToTrajectory(1, lx, ly)
	
	self:makeExplosion(obj, 20000, 15,200, 5,Bird.specialtySounds.EXPLOSION)
	self:removeHatcheryBird(obj, 30)
	
	_G.res.playAudio(Bird.specialtySounds.EGG, 1, false)	
	
end

function Bird:specialtyWhiteBlack(obj)

	local x, y = gamelua.vNormalize(obj.yVel, -obj.xVel)
	local newName = obj.name .. "a"
	
	gamelua.createCircle(newName, "DROPPABLE_EGG", obj.x, obj.y + obj.radius*2, obj.radius, obj.density, obj.friction, obj.restitution, true, obj.z_order)
	gamelua.objects.world[newName].definition = "EggGranade"
	gamelua.objects.world[newName].controllable = true
	gamelua.objects.world[newName].strength = obj.strength
	gamelua.objects.world[newName].defence = obj.defence
	gamelua.objects.world[newName].material = obj.material
	gamelua.objects.world[newName].damageFactors = gamelua.blockTable.blocks[gamelua.objects.world[newName].definition].damageFactors
	gamelua.objects.world[newName].useLegacyCollisionPath = obj.useLegacyCollisionPath
	gamelua.objects.world[newName].levelGoal = false
	local xp, yp = _G.res.getSpritePivot("INGAME_BIRDS_1","DROPPABLE_EGG")
	gamelua.objects.world[newName].spritePivotX = xp
	gamelua.objects.world[newName].bombling = true 
	gamelua.objects.world[newName].spritePivotY = yp
	gamelua.objects.world[newName].damageSprite = "DROPPABLE_EGG"
	gamelua.objects.world[newName].xVel = 0 --flyingBird.xVel * 0.5
	gamelua.objects.world[newName].yVel = 100 --flyingBird.yVel * 0.5
	gamelua.setSprite(newName, gamelua.objects.world[newName].damageSprite)
	gamelua.setRotation(newName, obj.angle)

	gamelua.setVelocity(newName, gamelua.objects.world[newName].xVel, gamelua.objects.world[newName].yVel)

	_G.table.insert(gamelua.flyingGrenades, { name = newName, timer = 5 })

	_G.res.playAudio(gamelua.getAudioName(gamelua.blockTable.blocks[obj.definition].specialSound), 1, false)
	
	gamelua.cameraTargetObject = gamelua.objects.world[newName]
	
	gamelua.applyImpulse( obj.name,
							-0.04*gamelua.defaultForce * obj.mass,
							0.08*gamelua.defaultForce * obj.mass,
							obj.x-0.5,
							obj.y )
	
	local lx, ly = gamelua.physicsToWorldTransform(obj.x, obj.y)
	gamelua.addPuffToTrajectory(1, lx, ly)
	
	_G.res.playAudio(Bird.specialtySounds.EGG, 1, false)	
	
end

function Bird:specialtyYellowBlue(obj)
	obj.xVel = -obj.xVel*gamelua.boostForce * gamelua.physicsScale * obj.mass
	obj.yVel = -obj.yVel*gamelua.boostForce * gamelua.physicsScale * obj.mass
	gamelua.setVelocity(obj.name,obj.xVel, obj.yVel)
	_G.res.playAudio(Bird.specialtySounds.SPEED, 1, false)	
end

function Bird:specialtyBlackYellow(obj)
	self:makeExplosion(obj, 10000, 10,100, 5, Bird.specialtySounds.DUMB_EXPLOSION)
	self:removeHatcheryBird(obj, 30)
end

function Bird:specialtyYellowBlack(obj)
	obj.bombling = true
	obj.xVel = -obj.xVel*gamelua.boostForce * gamelua.physicsScale * obj.mass
	obj.yVel = -obj.yVel*gamelua.boostForce * gamelua.physicsScale * obj.mass
	gamelua.setVelocity(obj.name,obj.xVel, obj.yVel)
	_G.res.playAudio(Bird.specialtySounds.SPEED, 1, false)	
end

function Bird:makeExplosion(obj, strength, radius, explosionDamage, damageRadius, audio)

	for k, v in _G.pairs(gamelua.objects.world) do
		if v.controllable or obj == v then
			--do nothing
		else
			local dist = gamelua.vLength(v.x - obj.x, v.y - obj.y)
			if dist < radius then
				local x, y = gamelua.vNormalize(v.x - obj.x, v.y - obj.y)
				local force = gamelua.physicsScale * strength / dist
				gamelua.applyImpulse( k,
							x * force,
							y * force,
							v.x,
							v.y )
			end
			if dist < damageRadius then
				if v.defence < explosionDamage/dist then
					v.strength = v.strength - explosionDamage/dist
					local sprites = gamelua.getDamageSprite(v, gamelua.blockTable.blocks)
					v.damageSprite = sprites.sprite
					v.blinkSprite = sprites.blink
					v.smileSprite = sprites.smile
					if v.strength <= 0 then
						gamelua.deadBlocks[k] = v
					end
					--print("st: " .. v.strength .. "\n")
				end
			end
		end
	
	
	end
	if audio ~= nil then
		_G.res.playAudio(audio, 1, false)	
	end
end

function Bird:removeHatcheryBird(object, particleAmount)
	local k = object.name
	local particleCount = particleAmount or 10
	self:addParticles(k, gamelua.blockTable.blocks[object.definition].particles , particleCount, false, false)	
	
	
	
	
	if gamelua.cameraTargetObject == object then
		--print("--------------   Remove bird: setting camera target object to nil\n")
		gamelua.cameraTargetObject = nil
	end
	
	if gamelua.currentBirdName == k then
		gamelua.currentBirdName = nil
	end
	if gamelua.flyingBird == object then
		gamelua.flyingBird = nil
		gamelua.birdSpecialtyAvailable = false
	end
	
	gamelua.removeObject(k)
	gamelua.objects.world[k] = nil
	gamelua.birds[k] = nil
	gamelua.otherBirds[k] = nil

	_G.res.playAudio(gamelua.getAudioName("bird_destroyed"), 1, false)	
end


filename="bird.lua"
