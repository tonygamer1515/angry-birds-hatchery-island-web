HatcheryNestObject = HatcheryConstructionObject:new()

--this function can be called only for types, that have native implementation of composite object. Otherwise this will fail
function HatcheryNestObject:addEgg(egg)
	self.contained = egg
	egg:startHatching(self)
	gamelua.addObjectToContainerObject(egg:getID(),self.RID)
	
end

function HatcheryNestObject:initialize(params)
	HatcheryConstructionObject.initialize(self,params)
	if params.contained then
		self.contained = self.service:createNewDynamicObject(params.contained)
		gamelua.addObjectToContainerObject(self.contained:getID(),self.RID)
		self.contained:setHomeNest(self)
	end
end

function HatcheryNestObject:eggHatched(bird)
	self.contained = bird
	bird:setHomeNest(self)
	gamelua.addObjectToContainerObject(bird:getID(),self.RID)
end

function HatcheryNestObject:selected(params)
	if self.contained then
		 self.contained:selected(params)
	else
		HatcheryConstructionObject.selected(self,params)
	end
end

function HatcheryNestObject:deselected(params)
	if self.contained then
		 self.contained:deselected(params)
	else
		HatcheryConstructionObject.deselected(self,params)
	end
	
	if self.isSelected == true then
		HatcheryConstructionObject.deselected(self,params)
	end
	
end

function HatcheryNestObject:getSerializeTable(caller)
	local data = HatcheryConstructionObject.getSerializeTable(self)
	if self.contained then
		local childdata = self.contained:getSerializeTable(self)
		data.contained = childdata
	end
	return data
end



function HatcheryNestObject:setWorldPosition(x,y)
	self.worldX = x
	self.worldY = y
	
	if self.contained then
		self.contained:setWorldPosition(x,y)
	end
end


function HatcheryNestObject:startConstructing()
	HatcheryConstructionObject.startConstructing(self)
	local animName = "H_NEST_INPROGRESS_1"
	gamelua.addAnimationToTileObject(self:getID(), {id = hatcheryAnimationID[animName], loop = true, speed = 1})
	
	_G.res.playAudio(getHatcherySound("nestBuilding"), 1, true)	
end

function HatcheryNestObject:constructionReady()
	HatcheryConstructionObject.constructionReady(self)
	gamelua.removeAllAnimationsFromTileObject(self:getID())
	
	_G.res.playAudio(getHatcherySound("worldNestReady"), 1, false)	
	
	_G.res.stopAudio(getHatcherySound("nestBuilding"))
end
filename="hatcheryNestObject.lua"
