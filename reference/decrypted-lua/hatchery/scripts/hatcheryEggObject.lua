HatcheryEggObject = HatcheryConstructionObject:new()

function HatcheryEggObject:update(dt, time)
	HatcheryConstructionObject.update(self,dt,time)
end


function HatcheryEggObject:drawAfterWorld()
	HatcheryConstructionObject.drawAfterWorld(self)
end

function HatcheryEggObject:startHatching(nest)
	self.service:openEggPainter(self)
	self:setHomeNest(nest)
end

function HatcheryEggObject:setHomeNest(nest)
	self.nest = nest
end

function HatcheryEggObject:initialize(params)
	
	self.primaryColor = params.primaryColor
	self.secondaryColor = params.secondaryColor
	self.clicksToHatch = params.clicksToHatch
	self.painted = params.painted or false
	self.eggScale = 0.75		
	
	--I moved the base class initialization because the constructionReady can be called there, 
	--and those variables need to be set beforehand
	HatcheryConstructionObject.initialize(self,params)
	
	if not self.animation then
		self.animation = {}
	end
	
	--egg has painted canvas, scale it down
	if self.painted == true then
		gamelua.setSpriteParameters(self:getID(),0, 0, 0, self.eggScale, self.eggScale)
	end	
	
	if self.clicksToHatch then
		gamelua.addSpriteToTileObject(self:getID(),"H_ANIM_EGG_CRACK_1_FRAME_" .. self.clicksToHatch)
		gamelua.setSpriteParameters(self:getID(),1, 0, -10, self.eggScale, self.eggScale)
	end
	
	
	
end


function HatcheryEggObject:getSerializeTable(caller)
	
	if caller == self.nest then 
		local data = HatcheryConstructionObject.getSerializeTable(self)
		data.primaryColor = self.primaryColor
		data.secondaryColor = self.secondaryColor
		data.painted = self.painted
		data.clicksToHatch = self.clicksToHatch
	
		return data
	end
end

function HatcheryEggObject:eggPaintingDone()
	self.primaryColor, self.secondaryColor = gamelua.getDominantCanvasColors()
	local spriteName = self.service:createSpriteFromEggPainter()
	self.sprites = {spriteName}

	
	local painter = self.service:getEggPainter()
	local colors = painter:getAvailableColors()
	--no primary color, randomize
	if self.primaryColor == "" then
		self.primaryColor = colors[_G.math.random(1,#colors)]
	end
	
	if self.secondaryColor == ""	then
		self.secondaryColor = colors[_G.math.random(1,#colors)]
	end
	
	self.painted = true
	
	painter:reset()
	self:startConstructing()
	

	gamelua.setSpriteParameters(self:getID(),0, 0, 0, self.eggScale, self.eggScale)
end

function HatcheryEggObject:selected(params)
	HatcheryConstructionObject.selected(self,params)
	if self.constructing == false and self.painted == true then
		if self.clicksToHatch then
			self.clicksToHatch = self.clicksToHatch+1
			if self.clicksToHatch >  9 then
				self.clicksToHatch = nil
			else
				gamelua.removeSpriteFromTileObject(self:getID(), 1)
				gamelua.addSpriteToTileObject(self:getID(),"H_ANIM_EGG_CRACK_1_FRAME_" .. self.clicksToHatch)
				gamelua.setSpriteParameters(self:getID(),1, 0, -10, self.eggScale, self.eggScale)
			end
			
			_G.res.playAudio(getHatcherySound("eggCrackingTap"), 1, false)

		else
			self:hatch()
			gamelua.removeAllAnimationsFromTileObject(self:getID())
		end
	end
end

function HatcheryEggObject:hatch()
		-- this is a quick hack to create a bird. This should be better designed later, as the whole bird creation is a mess
	local birdDef = {}
	for k,v in _G.pairs(hatcheryDynamicTemplates["BIRD"] ) do
		birdDef[k] = v
	end

	birdDef.primaryColor = self.primaryColor
	birdDef.secondaryColor = self.secondaryColor
	
	local bird = self.service:createNewDynamicObject(birdDef)
	bird:setWorldPosition(self.worldX, self.worldY)
	

	self.service:showHatchedDialog(bird:getHatcheryBird())
	self.nest:eggHatched(bird)
end

function HatcheryEggObject:startConstructing()
	HatcheryConstructionObject.startConstructing(self)
	
	gamelua.removeAllAnimationsFromTileObject(self:getID())
	local animName = "H_EGG_INPROGRESS_1"
	
	
	
	self.animation.loop = true
	self.animation.speed = 1
	self.animation.animations = {{id = hatcheryAnimationID[animName]}}
	
	gamelua.addAnimationToTileObject(self:getID(), {id = hatcheryAnimationID[animName], loop = true, speed = 1})
	
	_G.res.playAudio(getHatcherySound("eggBuilding"), 1, true)
end



--will destroy this egg and spawn a bird
function HatcheryEggObject:constructionReady()
	gamelua.print("\n egg construction ready")
	-- gamelua.print(nil)
	HatcheryConstructionObject.constructionReady(self)
	gamelua.setSpriteParameters(self:getID(),0, 0, 0, self.eggScale, self.eggScale)
	gamelua.removeAllAnimationsFromTileObject(self:getID())
	--start random egg animation
	
	self.animation.loop = true
	
	

	local animNum = _G.math.random(1,2)
	if animNum == 2 then
		gamelua.addAnimationToTileObject(self:getID(), {id = hatcheryAnimationID["HATCHERY_ANIMATION_JUMP"], loop = true, speed = 1})
		self.animation.animations = {{id = hatcheryAnimationID["HATCHERY_ANIMATION_JUMP"]}}
	else
		gamelua.addAnimationToTileObject(self:getID(), {id = hatcheryAnimationID["H_EGG_IDLE_1"], loop = true, speed = 1})
		self.animation.animations = {{id = hatcheryAnimationID["H_EGG_IDLE_1"]}}
	end
	
	
	_G.res.playAudio(getHatcherySound("worldEggReady"), 1, false)
	_G.res.stopAudio(getHatcherySound("eggBuilding"))

	self.clicksToHatch = 0
end
filename="hatcheryEggObject.lua"
