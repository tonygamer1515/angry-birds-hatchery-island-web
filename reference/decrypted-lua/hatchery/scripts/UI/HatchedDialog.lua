HatchedDialog = ui.Frame:new()
Frame = ui.Frame

function HatchedDialog:init()
	Frame.init(self)	
	
	
	local nametag = ui.ScallableButton:new()
	nametag.name = "nametag"
	nametag:setImage("H_TEXT_BOX")
	nametag.visible = false
	self:addChild(nametag)

	local nametagText = ui.Text:new()
	nametagText.name = "nametagText"
	nametagText.visible = false
	
	
	--TODO: remove this hack
	if gamelua.deviceModel == "iphone"  or gamelua.deviceModel == "iphone4" then
		nametagText.scaleX = 0.7
		nametagText.scaleY = 0.7
	end
	
	self:addChild(nametagText)
	
	
	local close = ui.ScallableButton:new()
	close.name = "closeButton"
	close:setImage("H_BTN_OK")
	close.returnValue = hatcheryEvents.EID_HATCHERY_CLOSE_HATCHEDDIALOG
	close.sound = getHatcherySound("ok")
	self:addChild(close)
	nametagText.visible = false
	close.activateOnRelease = true
	
	self.closedEvent = nil
	
	self.nestViewReference = nil
	self.buffTimer = 0
	self.birdTimer = 0
	--dialog closing or opening
	self.state = "open"
	
	--shake
	self.shakeTimer = 0
	self.shakeStrength = 20
	self.shakeSpeed = 10
	
	--bird animation properties
	self.birdAnimation = {}
	self.birdAnimation.duration = 0.5
	self.birdAnimation.angularVel = 1
	self.birdAnimation.controlDelta = -gamelua.screenHeight*0.6
	self.birdAnimation.targetX = 0
	self.birdAnimation.targetY = 0
	self.birdAnimation.startX = 0
	self.birdAnimation.startY = 0
	self.birdAnimation.startScale = 0
	self.birdAnimation.endScale = 1
	self.EndingAction = nil
	
	self.shouldUpdate = false
	--flag to enable/disable  buffs and rays
	self.birdReady = false
	
	--buff
	self.buffTime = 0.3
	self.explosionSprite = "H_EXPLOSION_1"
	self.buffSpinDuration = 40
	
	--rays
	self.raySprite = "H_SUN_RAY"
	self.raySpinDuration = 20

	-- placeholder bird
	self.bird = {x = 0, y = 0, angle = 0, scale = 1}
end

function HatchedDialog:animateBird()
	t = self.birdTimer / self.birdAnimation.duration
	local x = self.birdAnimation.targetX*t + self.birdAnimation.startX*(1-t)
	--bezier interpolation
	local controlY = _G.math.min(self.birdAnimation.targetY, self.birdAnimation.startY) + self.birdAnimation.controlDelta
	local y = (self.birdAnimation.startY*(1-t) + controlY*t)*(1-t) + (controlY*(1-t)  + self.birdAnimation.targetY)*t
	local angle = t * self.birdAnimation.angularVel*(_G.math.pi*2)
	local scale = (t -1)*	self.birdAnimation.startScale + t*	self.birdAnimation.endScale
	
	self.bird.x = x
	self.bird.y = y
	self.bird.angle = angle
	self.bird.scale = scale
	
end


function HatchedDialog:setNametagVisibility(val)
	local nametagText = self:getChild("nametagText")	
	local nametag = self:getChild("nametag")
	local closeButton = self:getChild("closeButton")	
	nametagText.visible = val
	nametag.visible = val
	closeButton.visible  = val
end

function HatchedDialog:onEntry()
	ui.Frame.onEntry(self)
	self.buffTimer = 0
	self.birdTimer = 0
	self:setNametagVisibility(false)
	self.birdReady = false
	self.state = "open"
	self.disableBackgroundShade = nil
	self:randomName()
	self.shouldUpdate = true
	self:layout()
end

function HatchedDialog:onExit()
	self.shouldUpdate  = false
end

function HatchedDialog:randomName()
	local names = {
		"Wild Turkey",
		"Morning Dove", 
		"Swan Goose", 
		"Sooty Albatross", 
		"Great Spoonbill", 
		"King Vulture", 
		"Grey Gull", 
		"Razorbill", 
		"Honeyeater",
		"Red Wattlebird",
		"Striated Pardalote",
		"Pilotbird",
		"Profit Bird",
		"Weebill",
		"Logrunner",
		"Flockbird",
		"Shining Bacon",
		"Apostlebird",
		"Palmchat",
		"Coal Tit",
		"Jacky Winter",
		"Shady Jones",
		"Winter Robin",
		"Sand Martin",
		"Cliff Swallow",
		"Gold Crest",
		"Wallcreeper",
		"Nightingale",
		"Pied Bushcat",
		"American Dipper",
		"Leafbird",
		"Painted Finch",
		"Cape Longclaw",
		"Steve",
		"Chuck Testa",
		"Skipper",
		"Smokey",
		"Snowflake",
		"Snuggles",
		"Speck",
		"Spice",
		"Spike",
		"Spunky",
		"Squeaky",
		"Squiggles",
		"Stevee",
		"Stitches",
		"Sugar",
		"Sundance",
		"Sunshine",
		"Sweet Tater Pied",
		"Sweetheart",
		"Sydney",
		}
	
	local ind = _G.math.random(1,#names)
	local nametagText = self:getChild("nametagText")	
	nametagText.text = names[ind]
end

function HatchedDialog:layout()
	Frame.layout(self)	
	
	local birdScale = 1
	
	if gamelua.screenWidth < 1024 then
		local newW = gamelua.screenWidth * (150/1024)		
		birdScale = newW / 150
	end
	
	local w, h = 150, 150
	if self.bird.sprite then
		w, h = _G.res.getSpriteBounds(self.bird.sprite)
		local tempw, temph = _G.res.getSpritePivot(self.bird.sprite)
		w,h = w - tempw, h - temph
	end
	
	self.birdAnimation.startX = gamelua.screenWidth *0.5
	self.birdAnimation.startY = gamelua.screenHeight*0.5
	self.birdAnimation.targetX = gamelua.screenWidth *0.5
	self.birdAnimation.targetY = gamelua.screenHeight*0.5
	
	self.birdAnimation.startScale = 0
	self.birdAnimation.endScale = 1
	
	local closeButton = self:getChild("closeButton")	
	
	local nametag = self:getChild("nametag")	
	local nametagText = self:getChild("nametagText")	
	
	-- nametag.y =  self.birdAnimation.targetY + h + 50 - self.y
	nametag.y =  self.birdAnimation.targetY + ((h + 50) * birdScale) - self.y
	
	--TODO: remove this hack
	gamelua.setFont(nametagText.font)
	
	if gamelua.deviceModel == "iphone"  or gamelua.deviceModel == "iphone4" then
		nametagText.y = nametag.y - 10
	else
		nametagText.y = nametag.y - 20
	end
	
	closeButton.y = nametag.y + 40
	
	for k,v in _G.ipairs(self.children) do
		v.ox = v.x 
		v.oy = v.y 
	end
	
end


function HatchedDialog:spawnHatchedParticles()
	local x, y = gamelua.screenWidth*0.5, gamelua.screenHeight*0.5
	_G.particles.addParticles("birdHatchedPopup1", 15, x,y,15,15,0,true,true)
	_G.particles.addParticles("birdHatchedPopup2", 15, x,y,15,15,0,true,true)
	_G.particles.addParticles("birdHatchedPopup3", 15, x,y,15,15,0,true,true)
end

function HatchedDialog:update(dt, time) 
	if self.shouldUpdate ~= true then
		return
	end
	ui.Frame.update(self,dt, time)
	
	if self.birdReady == true then
		self.buffTimer = self.buffTimer + dt
	else
		if self.birdTimer == self.birdAnimation.duration then
			if self.state == "open" then
				self.birdReady = true
				self:setNametagVisibility(true)
				self.shakeTimer = 1
				self:spawnHatchedParticles()
				_G.res.playAudio(getHatcherySound("hatchDialog_BirdReady"), 1, false)
			elseif self.state == "close" then
				self.world:closeCurrentPopUp()
			end
		else
			self.birdTimer = _G.math.min(self.birdTimer + dt, self.birdAnimation.duration)
			self:animateBird()
		end
	end
	if self.shakeTimer > 0 then
		self:shakeDialogs()
		self.shakeTimer  = self.shakeTimer - dt
	end	
end

function HatchedDialog:drawBuff()

	local spriteScale = 1
	
	if gamelua.screenWidth < 1024 then
		local w, h = _G.res.getSpriteBounds(self.currentBird.sprite)
		local newW = gamelua.screenWidth * (w/1024)		
		spriteScale = newW / w
	end
	
	local t = _G.math.min(self.buffTimer/self.buffTime,1)
	local w,h = _G.res.getSpriteBounds(self.explosionSprite)
	local scale = (0.8 + (t)*0.2) * spriteScale
	local angle =  (self.buffTimer/self.buffSpinDuration)*_G.math.pi*2
	local alpha  =1 -- _G.math.pow(t,2)
	
	gamelua.setRenderState(0,0,scale, scale, angle, w*0.5 , h*0.5, alpha)
	_G.res.drawSprite("", self.explosionSprite, self.bird.x/scale ,(self.bird.y)/scale )
	gamelua.setRenderState(0,0,1,1,0,0, 0, 1)
end

function HatchedDialog:drawRays(x,y,segments, scale)

	local spriteScale = 1
	
	if gamelua.screenWidth < 1024 then
		local w, h = _G.res.getSpriteBounds(self.currentBird.sprite)
		local newW = gamelua.screenWidth * (w/1024)		
		spriteScale = newW / w
	end
	
	local angle =  (self.buffTimer/self.raySpinDuration) * _G.math.pi * 2
	local angleDelta = (_G.math.pi*2) /segments
	local pivx, pivy = _G.res.getSpritePivot(self.raySprite)
	local scale = _G.math.min((self.buffTimer/self.buffTime), 1) * spriteScale
	for i = 1, segments do
		gamelua.setRenderState(0,0,scale, scale, angle + i*angleDelta,pivx,pivy)
		_G.res.drawSprite("", self.raySprite, self.bird.x/scale, self.bird.y/scale, "VPIVOT", "HPIVOT" )
	end
	gamelua.setRenderState(0,0,1,1,0)
end

function HatchedDialog:shakeDialogs()
	local str = _G.math.min(1, self.shakeTimer)
	local state = self.shakeSpeed * _G.math.pi*2 * self.shakeTimer
	for k,v in _G.ipairs(self.children) do
		self:shake(v, state, str)
	end
end

function HatchedDialog:shake(obj, angle, str)
	local deltaX = _G.math.cos(angle)*str
	local deltaY = _G.math.sin(angle)*str
	if not obj.ox or not obj.oy then
		obj.ox = obj.x --or 0
		obj.oy = obj.y --or 0
	end
	obj.x = obj.ox + deltaX
	obj.y = obj.oy + deltaY

end

function HatchedDialog:draw(x,y, scaleX, scaleY, angle) 
	
	
	if self.birdReady == true then
		self:drawRays(gamelua.screenWidth*0.5, gamelua.screenHeight*0.5, 40, 1)
		self:drawBuff()
	end
	
	gamelua.drawMenuParticlesInAdvance()
	
	local birdScale = 1
	
	if gamelua.screenWidth < 1024 then
		local w, h = _G.res.getSpriteBounds(self.currentBird.sprite)
		local newW = gamelua.screenWidth * (w/1024)		
		birdScale = newW / w
	end
	
	gamelua.setRenderState(0,0,1,1,0,0, 0, 1)
	--we are using the drawBird function to draw the bird. 
	if self.currentBird then
		self:drawBird(self.bird, 0, 0, birdScale, birdScale)
	end
	
	
	ui.Frame.draw(self,x,y, scaleX, scaleY, angle)
	
end

function HatchedDialog:setCurrentBird(bird)
	self.currentBird = bird
end

function HatchedDialog:setWorldView(world)
	self.world =world
end

function HatchedDialog:drawBird(bird, x, y, scale)

	local _, radius = _G.res.getSpriteBounds(self.currentBird.sprite) * 0.5
	local itms = {}
	for i = 1, #self.currentBird.sprites do
		local birdId = self.currentBird.id
		local eyeIndex = hatcheryBirds[birdId].eyesIndex
		if i == eyeIndex then
			if self.currentBirdBlinking then
				self.currentBird.sprites[i].sprite = Bird.Sprites.Blink[self.currentBird:getEyes()]
			else
				self.currentBird.sprites[i].sprite = Bird.Sprites.Eyes[self.currentBird:getEyes()]
			end
		end
		_G.table.insert(itms, self.currentBird.sprites[i])
	end
	x = x or 0
	y = y or 0
	scale = scale or 1
	gamelua.drawCompoObjectLua(bird.x + x, bird.y + y, bird.angle, bird.scale*scale, itms)
end

function HatchedDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)	
	if result == hatcheryEvents.EID_HATCHERY_CLOSE_HATCHEDDIALOG then
		--self.nestViewReference:setBirdVisibility(true)
		self.birdReady = false
		local x, y = self.birdAnimation.targetX, self.birdAnimation.targetY
		self.birdAnimation.targetX, self.birdAnimation.targetY = self.birdAnimation.startX, self.birdAnimation.startY
		self.birdAnimation.startX, self.birdAnimation.startY = x, y
		self.birdAnimation.startScale, 	self.birdAnimation.endScale = 1 ,0
		self.birdTimer = 0
		self:setNametagVisibility(false)
		self.state = "close"
		self.disableBackgroundShade = true
	end
	return result, meta
end

filename="HatchedDialog.lua"
