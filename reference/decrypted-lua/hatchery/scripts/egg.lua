Egg = {}
Egg.TYPE = {	NORMAL = "H_SELECTABLE_EGG_SMALL", 
				GOOFY = "H_SELECTABLE_EGG_MEDIUM", 
				HEAVY = "H_SELECTABLE_EGG_BIG" }
					
Egg.EGG_AMOUNT = 3
	
function Egg:new(o)

	_G.assert(o.type, "Error while creating new egg: Type not defined.")
	_G.assert(o.name, "Error while creating new egg: Name not defined.")
	_G.assert(o.speedName, "Error while creating new egg: SpeedName not defined.")
	_G.assert(o.price, "Error while creating new egg: Price not defined.")
	_G.assert(o.priceToSpeedBuild, "Error while creating new egg: priceToSpeedBuild not defined.")
	_G.assert(o.completeTimer, "Errori while creating new egg: Timer not defined.")
	_G.assert(o.sprites, "Error while creating new bird: Sprites not defined.")
	
	object = {}
	_G.setmetatable(object, self)
	self.__index = self
	
	object.type = o.type
	object.name = o.name
	object.speedName = o.speedName
	object.price = o.price 
	object.priceToSpeedBuild = o.priceToSpeedBuild
	object.completeTimer = o.completeTimer
	object.sprites = o.sprites
	object.nest = o.nest
	object.accessories = {}
	return object
end

function Egg:addAccessory(accessory)
	_G.table.insert(self.accessories, EggAccessory:new(accessory))
end

function Egg:getAccessoryOnSlot(slot)
	for k, v in _G.pairs(self.accessories) do
		if v:getType() == slot then
			return v
		end
	end
	
	return nil
end

function Egg:getAccessories()
	return self.accessories
end

function Egg:changeAccessoryGender()
	for k, v in _G.pairs(self.accessories) do
		v:changeGender()
	end
end

function Egg:getType()
	return self.type
end

function Egg:getPrice()
	return self.price

end

function Egg:getPriceToSpeedBuild()
	return self.priceToSpeedBuild
end


function Egg:getSprites()
	return self.sprites
end

function Egg:getName()
	return self.name
end

function Egg:getSpeedName()
	return self.speedName
end

function Egg:isCompleted()
	return self.completed
end

function Egg:speedBuild()
	self.timer = 0
	self.completed = true
end

function Egg:hatch()

	if self.nest then
		-- Hatch in random in proto.
		local birdId = _G.math.random(1, 32)--_G.math.random(1, 2) + _G.math.random(0, 6) * 27
		local birdTemplate = self.nest:getHatchery():getBirdWithId(birdId)
		if birdTemplate then
			return Bird:new(birdTemplate)
		else
			return false
		end
	else
		return false
	end
	
end


function Egg:update(dt, time)
	if not self.completed then
		self.timer = self.timer and self.timer - dt or self.completeTimer
		if self.timer <= 0 then
			-- Egg complete	
			self.completed = true
		end
	end
	
	if self.accessories then
		for k, v in _G.pairs(self.accessories) do
			v:update(dt, time)
		end
	end
	
end





filename="egg.lua"
