-----------------------------------------------------------------------------------------------------------------------
-- Golden egg
-----------------------------------------------------------------------------------------------------------------------

GoldenEgg = ui.ImageButton:new()

function GoldenEgg:init()
	self:setImage("GOLDEN_EGG_STAR_EFFECT")
	egg = ui.Image:new()
	egg.name = "egg"
	egg:setImage("GOLDEN_EGG_5")

	self:addChild(egg)
	egg.x = 0
	egg.y = 0
	self.clicks = 0
	self.visible = false
	self:getChild("egg").visible = false
	self.found = false
	self.rate = 0
	self.GEClicks = 0
end

function GoldenEgg:checkClick(event,x,y)
	local egg = self:getChild("egg")
	if(event == "LPRESS" and self.enabled ~= false) then
		local w,h = _G.res.getSpriteBounds(egg.image)
		local scale = 0.5
		w = w  * scale
		h = h * scale
		local px, py = _G.res.getSpritePivot(egg.image)
		px = px * scale
		py = py * scale
		worldScale = 1
		if x >= self.x - px and x <= self.x + (w - px) and y >= self.y - py and y <= self.y + (h - py) then
			return self.returnValue, self.meta
		end
	end
end

function GoldenEgg:draw()
	setRenderState(0,0,1,1,0,0)
	drawRect(0,0,0,self.rate * 0.5, 0,0,screenWidth, screenHeight,false)
	ui.ImageButton.draw(self)
	setRenderState(0,0,1,1,0,0)
end

-----------------------------------------------------------------------------------------------------------------------
-- Boomerang bird
-----------------------------------------------------------------------------------------------------------------------

BoomerangBirdPopup = ui.ImageButton:new()

function BoomerangBirdPopup:init()
	self:setImage("GOLDEN_EGG_STAR_EFFECT")
	egg = ui.Image:new()
	egg.name = "egg"
	egg:setImage("BIRD_BOOMERANG_STILL")

	self:addChild(egg)
	egg.x = 0
	egg.y = 0
	self.clicks = 0
	self.visible = false
	self:getChild("egg").visible = false
	self.found = false
	self.rate = 0
	self.GEClicks = 0
end

function BoomerangBirdPopup:checkClick(event,x,y)
	local egg = self:getChild("egg")
	if(event == "LPRESS" and self.enabled ~= false) then
		local w,h = _G.res.getSpriteBounds(egg.image)
		local scale = 0.5
		w = w  * scale
		h = h * scale
		local px, py = _G.res.getSpritePivot(egg.image)
		px = px * scale
		py = py * scale
		worldScale = 1
		if x >= self.x - px and x <= self.x + (w - px) and y >= self.y - py and y <= self.y + (h - py) then
			return self.returnValue, self.meta
		end
	end
end

function BoomerangBirdPopup:draw()
	setRenderState(0,0,1,1,0,0)
	drawRect(0,0,0,self.rate * 0.5, 0,0,screenWidth, screenHeight,false)
	ui.ImageButton.draw(self)
	setRenderState(0,0,1,1,0,0)
end

-----------------------------------------------------------------------------------------------------------------------
-- (soundboard) star gained
-----------------------------------------------------------------------------------------------------------------------

StarPopup = ui.ImageButton:new()

function StarPopup:new(first_time, o)
	local o = o or {}
	o.first_time = first_time
	return ui.ImageButton.new(self, o)
end

function StarPopup:init()
	if self.first_time then
		self:setImage("GOLDEN_EGG_STAR_EFFECT")
	end
	egg = ui.Image:new()
	egg.name = "egg"
	egg:setImage("BIG_STAR_2")

	self:addChild(egg)
	egg.x = 0
	egg.y = 0
	if not self.first_time then
		egg.alpha = 0.5
	end
	self.clicks = 0
	self.visible = false
	self:getChild("egg").visible = false
	self.found = false
	self.rate = 0
	self.GEClicks = 0
end

function StarPopup:checkClick(event,x,y)
	local egg = self:getChild("egg")
	if(event == "LPRESS" and self.enabled ~= false) then
		local w,h = _G.res.getSpriteBounds(egg.image)
		local scale = 0.5
		w = w  * scale
		h = h * scale
		local px, py = _G.res.getSpritePivot(egg.image)
		px = px * scale
		py = py * scale
		worldScale = 1
		if x >= self.x - px and x <= self.x + (w - px) and y >= self.y - py and y <= self.y + (h - py) then
			return self.returnValue, self.meta
		end
	end
end

function StarPopup:draw()
	setRenderState(0,0,1,1,0,0)
	drawRect(0,0,0,self.rate * 0.5, 0,0,screenWidth, screenHeight,false)
	ui.ImageButton.draw(self)
	setRenderState(0,0,1,1,0,0)
end

-----------------------------------------------------------------------------------------------------------------------
-- generic reward
-----------------------------------------------------------------------------------------------------------------------

RewardPopup = ui.Image:new()

function RewardPopup:new(sprite, o)
	local o = o or {}
	o.sprite = sprite
	return ui.Image.new(self, o)
end

function RewardPopup:init()
	self:setImage("GOLDEN_EGG_STAR_EFFECT")
	egg = ui.Image:new()
	egg.name = "egg"
	egg:setImage(self.sprite)

	self:addChild(egg)
	egg.x = 0
	egg.y = 0
	--if not self.first_time then
	--	egg.alpha = 0.5
	--end
	self.clicks = 0
	self.visible = false
	self:getChild("egg").visible = false
	self.found = false
	self.rate = 0
	self.GEClicks = 0
end

function RewardPopup:draw()
	setRenderState(0,0,1,1,0,0)
	drawRect(0,0,0,self.rate * 0.5, 0,0,screenWidth, screenHeight,false)
	ui.Image.draw(self)
	setRenderState(0,0,1,1,0,0)
end


filename="reward_popups.lua"
