NestAccessory = {}

NestAccessory.TYPE = { 	SLOT2_EMPTY = "",
						SLOT2_FLOWER = "NEST_ACC_LOWER_FLOWER_1", 
						SLOT2_FAN = "NEST_ACC_LOWER_WOODEN_FAN_1", 
						SLOT3_EMPTY = "",
						SLOT3_TOYS = "NEST_ACC_UPPER_TOYS_1", 
						SLOT3_UMBRELLA = "NEST_ACC_UPPER_UMBRELLA_1" }

NestAccessory.ACCESSORY_SLOT2_AMOUNT = 3
NestAccessory.ACCESSORY_SLOT3_AMOUNT = 3

function NestAccessory:new(o)
	
	object = {}
	object.type = o.type
	object.id = o.id
	object.price = o.price
	object.sprite = o.type
	object.spriteFan = o.spriteFan
	object.slot = o.slot
	
	_G.setmetatable(object, self)
	self.__index = self
	
	return object
end

function NestAccessory:getType()
	return self.type
end

function NestAccessory:getPrice()
	return self.price
end

function NestAccessory:getSlot()
	return self.slot
end	

function NestAccessory:getId()
	return self.id
end	

function NestAccessory:getSprite()
	return self.sprite
end

function NestAccessory:getAdditionalSprite()
	return self.spriteFan
end

function NestAccessory:update(dt, time)

end

filename="nestAccessory.lua"
