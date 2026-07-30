EggAccessory = {}

EggAccessory.TYPE = { 	TOP = "TOP",
						MIDDLE = "MIDDLE",
						BOTTOM = "BOTTOM"
					}
EggAccessory.Sprites = {}
EggAccessory.Sprites.female = 	{ 	TOP = "H_EGG_ACC_ICON_FEMALE_TOP",
									MIDDLE = "H_EGG_ACC_ICON_FEMALE_MIDDLE",
									BOTTOM = "H_EGG_ACC_ICON_FEMALE_BOTTOM",
									TOP_ITEM = "H_EGG_ACC_ITEM_FEMALE_TOP",
									MIDDLE_ITEM = "H_EGG_ACC_ITEM_FEMALE_MIDDLE",
									BOTTOM_ITEM = "H_EGG_ACC_ITEM_FEMALE_BOTTOM"
								}
EggAccessory.Sprites.male = 	{ 	TOP = "H_EGG_ACC_ICON_MALE_TOP",
									MIDDLE = "H_EGG_ACC_ICON_MALE_MIDDLE",
									BOTTOM = "H_EGG_ACC_ICON_MALE_BOTTOM",
									TOP_ITEM = "H_EGG_ACC_ITEM_MALE_TOP",
									MIDDLE_ITEM = "H_EGG_ACC_ITEM_MALE_MIDDLE",
									BOTTOM_ITEM = "H_EGG_ACC_ITEM_MALE_BOTTOM"
								}
								
EggAccessory.AMOUNT = 3

function EggAccessory:new(o)
	object = {}
	object.type = o.type
	object.id = o.id
	object.price = o.price
	object.gender = o.gender
	
	object.sprite = EggAccessory.Sprites[o.gender][o.type]

	_G.setmetatable(object, self)
	self.__index = self
	
	return object
end

function EggAccessory:getType()
	return self.type
end

function EggAccessory:getGender()
	return self.gender
end

function EggAccessory:changeGender()
	if self.gender == "male" then
		self.gender = "female"
	else
		self.gender = "male"
	end
	self.sprite = EggAccessory.Sprites[self.gender][self.type]
end

function EggAccessory:getPrice()
	return self.price
end

function EggAccessory:getId()
	return self.id
end	

function EggAccessory:getSprite()
	return self.sprite
end

function EggAccessory:getItemSprite()
	return EggAccessory.Sprites[self.gender][self.type .. "_ITEM"]
end

function EggAccessory:update(dt, time)

end

filename="eggAccessory.lua"
