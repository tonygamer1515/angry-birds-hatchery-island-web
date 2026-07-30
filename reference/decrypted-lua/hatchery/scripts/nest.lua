Nest = {}
Nest.TYPE = {	RED = "H_NEST_RED", 
				BLUE = "H_NEST_BLUE", 
				YELLOW = "H_NEST_YELLOW", 
				BLACK = "H_NEST_BLACK", 
				WHITE = "H_NEST_WHITE", 
				GREEN = "H_NEST_GREEN", 
				BIGBROTHER = "H_NEST_BIGBROTHER"}
					
Nest.NEST_AMOUNT = 7

function Nest:new(o)

	_G.assert(o.type, "Error while creating new nest: Type not defined.")
	_G.assert(o.price, "Error while creating new nest: Price not defined.")
	_G.assert(o.sprites, "Error while creating new nest: Sprites not defined.")
	_G.assert(o.completeTimer, "Error while creating new nest: Timer not defined.")
	
	object = {}
	_G.setmetatable(object, self)
	self.__index = self
	
	object.accessories = {}
	object.type = o.type
	object.price = o.price
	object.priceToSpeedBuild = o.priceToSpeedBuild
	object.completeTimer = o.completeTimer
	object.sprites = o.sprites
	object.hatchery = o.hatchery
	object.egg = o.egg
	
	return object
end

function Nest:getType()
	return self.type
end

function Nest:getPrice()
	return self.price
end

function Nest:getPriceToSpeedBuild()
	return self.priceToSpeedBuild
end

function Nest:getEgg()
	if self.egg then
		return self.egg
	else
		return false
	end
end

function Nest:getSprites()
	return self.sprites
end

function Nest:getElapsedBuildTime()
	return self.completeTimer - self.timer
end

function Nest:getTotalBuildTime()
	return self.completeTimer
end

function Nest:getHatchery()
	if self.hatchery then
		return self.hatchery
	else
		return false
	end
end

function Nest:isCompleted()
	return self.completed
end

function Nest:speedBuild()
	self.timer = 0
	self.completed = true
end

function Nest:addEgg(egg)
	egg.nest = self
	self.egg = Egg:new(egg)
end

function Nest:addAccessory(accessory)
	_G.table.insert(self.accessories, NestAccessory:new(accessory))
end

function Nest:getAccessoryOnSlot(slot)
	
	for k, v in _G.pairs(self.accessories) do
		if v:getSlot() == slot then
			return v
		end
	end
	
	return nil
	
end


function Nest:canHatchEgg()
	return self.egg and self.egg:isCompleted()
end

function Nest:hatchEgg()
	if self.egg and self.egg:isCompleted() then
		-- spawn a bird
		local newBird = self.egg:hatch()
		self.egg = nil
		return newBird
	end
end

function Nest:update(dt, time)
	
	if not self.completed then
		self.timer = self.timer and self.timer - dt or self.completeTimer
		if self.timer <= 0 then
			self.completed = true
		end
	end
	
	if self.egg then
		self.egg:update(dt, time)
	end
	
	if self.accessories then
		for k, v in _G.pairs(self.accessories) do
			v:update(dt, time)
		end
	end
	
end





filename="nest.lua"
