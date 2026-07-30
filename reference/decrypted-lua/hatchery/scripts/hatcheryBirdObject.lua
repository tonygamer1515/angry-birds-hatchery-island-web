HatcheryBirdObject = HatcheryDynamicObject:new()

function HatcheryBirdObject:initialize(params)

	
	HatcheryDynamicObject.initialize(self,params)
	
	self.primaryColor = params.primaryColor
	self.secondaryColor = params.secondaryColor
	self.birdTemplateID = params.birdTemplateID
	
	local hatchery = self.service:getHatchery()
	
	local colors = {"RED", "BLUE", "YELLOW", "BLACK",  "WHITE", "GREEN", "BIGBROTHER", "ORANGE"}
				
	local bodyIndex = 1
	local bodyColor = 1

	bodyIndex = getIndexInTable(colors, self.primaryColor) - 1
	bodyColor = getIndexInTable(colors, self.secondaryColor) - 1
		

	local identifierString = ("body_" .. bodyIndex .. "_color_" .. bodyColor)
	
	
		

	if not self.birdTemplateID then
		local possibleIds = hatcheryColorPaintBirdPools[identifierString]
		local index =  _G.math.random(1,#possibleIds)
		self.birdTemplateID = possibleIds[index]
	end

	self.hatcheryBird = hatchery:getBirdWithId(self.birdTemplateID)
	
	
	local sprites = {}
	for i = 1, #self.hatcheryBird.sprites do
		_G.table.insert(sprites,self.hatcheryBird.sprites[i].sprite)
	end
	
	gamelua.setTileObjectSprites(self:getID(),sprites)
	
	--scale the bird to be more fit ingame. maybe make a better system here later on, since this is purely done experimenting with the values
	local pivotX,pivotY =  _G.res.getSpritePivot("",sprites[1])
	local boundsX, boundsY =  _G.res.getSpriteBounds("",sprites[1])
	local constantOffset = 15
	local extraScale = 0.4
	local offsetY = (boundsY-pivotY)*extraScale*self.hatcheryBird.sprites[self.hatcheryBird.bodyIndex].scale
	for i = 1, #sprites do
		local sp = self.hatcheryBird.sprites[i]
		
		gamelua.setSpriteParameters(self:getID(), i-1, extraScale*sp.x,extraScale*sp.y -offsetY - constantOffset,extraScale * sp.scale,extraScale * sp.scale, sp.angle)  
	end
	
	self.addedToIngame = false
	
	--add animation
	local hatchAnimName = "H_" .. self.primaryColor .. "_BIRD_IDLE_1"
	gamelua.addAnimationToTileObject(self:getID(), {id = hatcheryAnimationID[hatchAnimName], loop = true, speed = 1})
	
end

function HatcheryBirdObject:setHomeNest(nest)
	self.nest = nest
end

function HatcheryBirdObject:selected(params)
	HatcheryDynamicObject.selected(self,params)
	self.service:showBirdSelector()
	local state = {}
	
	if self.addedToIngame == false then
		state.selectBird = true
	end
	
	if self.movable == true then
		state.move = true
	end
	
	local context = self.service:getContextMenu()
	context:setState(self, state)
	self.service:showContextMenu()
end

function HatcheryBirdObject:getSerializeTable(caller)
	--for now bird can only exist in a nest, later will change
	if caller == self.nest then 
		local data = HatcheryConstructionObject.getSerializeTable(self)
		data.primaryColor = self.primaryColor
		data.secondaryColor = self.secondaryColor
		data.identifierString =self.identifierString
		data.birdTemplateID = self.birdTemplateID
		return data
	end
end


function HatcheryBirdObject:getHatcheryBird()
	return self.hatcheryBird
end

function HatcheryBirdObject:selectedIngame()

	self.service:getBirdSelector():addBird(self)
	self.service:hideContextMenu(self)
	self.addedToIngame = true

end
filename="hatcheryBirdObject.lua"
