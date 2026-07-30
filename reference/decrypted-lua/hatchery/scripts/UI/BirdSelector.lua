BirdSelector = ui.Frame:new()
Frame = ui.Frame

function BirdSelector:init()
	Frame.init(self)	
	
	self.buttonResumeHiddenY = 260
	self.buttonResumeVisibleY = 220
	
	
	self.nextBirdRestartNumber = 1
	
	local background = ui.CompoImage:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_BIRD_SWING")
	self:addChild(background)
	
	local button = ui.ScallableButton:new()
	button.name = "button"
	button:setImage("MENU_BUTTON_HATCHERY")
	button.returnValue = "RESUME"
	button.sound = getHatcherySound("cancel")	
	button.activateOnRelease = true
	button:setupDefaultAnimationValues()
	button.x = 0
	button.y = self.buttonResumeHiddenY
	self:addChild(button)		
	
	
	local mightyEagleButton = ui.ScallableButton:new()
	mightyEagleButton.name = "mightyEagleButton"
	mightyEagleButton:setImage("H_BUTTON_ME")
	mightyEagleButton.returnValue = "MIGHTY_EAGLE"
	mightyEagleButton.sound = getHatcherySound("cancel")	
	mightyEagleButton.activateOnRelease = true
	mightyEagleButton:setupDefaultAnimationValues()
	mightyEagleButton.x = -330
	mightyEagleButton.y = 90
	self:addChild(mightyEagleButton)
	
	--TODO: fix this hack
	if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
		-- mightyEagleButton.scaleX = 0.1
		-- mightyEagleButton.scaleY = mightyEagleButton.scaleX
		mightyEagleButton:setup(0.5, 0.6, 0.1, ScallableButton.TWEEN_TYPE.LINEAR)
		mightyEagleButton.x = -150
		mightyEagleButton.y = 35
	end
	
	local plazaButton = ui.ScallableButton:new()
	plazaButton.name = "plazaButton"
	plazaButton:setImage("H_BTN_PLAZA")
	plazaButton.returnValue = "PLAZA"
	plazaButton.sound = getHatcherySound("cancel")	
	plazaButton.activateOnRelease = true
	plazaButton.x = 410
	plazaButton.y = 140
	plazaButton.visible = false
	self:addChild(plazaButton)
	
	
	self.birdStartX = -190
	self.birdStartY = 80
	self.birdOfffsetX = 100
	self.gridWidth = 100
	self.gridHeight = 100
	
	
	
	--TODO: EXTREME HACK, FIX THIS SHIT WHEN NOT IN PROTO MODE
	self.birdOffsets = {-1,-1,0,0,1}
	
	--TODO:fix this hack	
	if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
		self.birdStartX = -120
		self.birdStartY = 25
		self.birdOfffsetX = 50
		self.gridWidth = 90
		self.gridHeight = 50
		self.birdOffsets = {10,2,3,7,1}
	end
	
	--those  are temporary, for demo only
	-- self.birdIndices = {19, 21, 22, 23, 24, 25, 26, 27, 28 ,29}
	self.birdIndices = {73,74,75,76,77}
	-- self.birdNames = {"USE ME", " Tranny Redshank", "Lemon Chicken", "Lady Grant", "Headshot", "Missy Golocrest", "Reporter", "Sir Pale Ale" ,"Green Broadbill" , "Sgt. Whitey"}
	self.birdNames = {"Senor Redshank", "Missy Golocrest", "Lady Grant", "Headshot", "Reporter"}
	
	self.visibleBirds = {true, true, true, true, true}
	self:createTexts()
	self:randomizeBirds()
	
	self:createBirdsButtons()		
	
	
	self.hiddenYPos = -233
	self.visibleYPos = 0
	self.totalAnimationTime = 0.5
	
	
	self.state = "HIDDEN"
	self.y = self.hiddenYPos
	
end

function BirdSelector:createBirdsButtons()
	for i = 0, 4 do
		local birdButton = ui.RectangleButton:new()
		birdButton.name = "birdButton" .. i
		birdButton.returnValue = "BIRD_SELECTED"..i
		birdButton.sound = getHatcherySound("cancel")	
		birdButton.activateOnRelease = true	
		birdButton.x = self.birdStartX + i * self.birdOfffsetX
		birdButton.y = self.birdStartY
		birdButton.w = self.gridWidth
		birdButton.h = self.gridHeight
		birdButton.bird = self.birds[i+1]
		birdButton.index = i
		birdButton.r = 1
		birdButton.g = 0
		birdButton.b = 0
		birdButton.a = 0		
		
		self:addChild(birdButton)
	end
	
end

function BirdSelector:createTexts()		
	for i = 0, 4 do
		
		local birdText = ui.TextButton:new()
		birdText.name = "birdText"..i
		birdText.hanchor = "HCENTER"
		birdText.vanchor = "VCENTER"
		birdText.font = "FONT_HATCHERY"
		birdText.scaleX = 0.3
		birdText.scaleY = 0.3
		birdText.x = self.birdStartX + i * self.birdOfffsetX + self.gridWidth * 0.5
		birdText.y = 200
		
		--TODO:fix this hack
		if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
			birdText.y = 85
			
		end
			
		birdText.textBoxSize = self.gridWidth
		-- birdText:clip()
		self:addChild(birdText)
	end
end

function BirdSelector:layout()
		

	self.x = gamelua.screenWidth * 0.5		
	
	if self.state == "HIDDEN" then
		self.y = self.hiddenYPos
	elseif self.state == "VISIBLE" then
		self.y = self.visibleYPos
	end

	local button = self:getChild("button")
	local w,h = _G.res.getSpriteBounds(button.image)
	button.x =  - self.x
	button.y = -self.y --+ h*0.55
	
	Frame.layout(self)	
end

function BirdSelector:update(dt, time) 
	Frame.update(self, dt, time) 	
	

	
	
	
	
	if self.state == "HIDDEN" then
		self.y = self.hiddenYPos

	elseif self.state == "VISIBLE" then
		self.y = self.visibleYPos

		--TODO: fix this hack
		local limit = 250
		if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
			limit = 80
		end
		
		if gamelua.keyReleased["LBUTTON"] and gamelua.cursor.y > limit then
			self:hide()
		end
		
	elseif self.state == "SHOWING" then
		self.animationTime = self.animationTime + dt
		self.animationTime = _G.math.min(self.animationTime, self.totalAnimationTime)
		
		self.y = self:tweenEaseCubicOut(self.animationTime, self.animationStartY, self.animationEndY - self.animationStartY, self.totalAnimationTime)
		
		if self.animationTime == self.totalAnimationTime then
			self.state = "VISIBLE"
			
		end
		
	elseif self.state == "HIDING" then
		self.animationTime = self.animationTime + dt
		self.animationTime = _G.math.min(self.animationTime, self.totalAnimationTime)
		self.y = self:tweenEaseCubicIn(self.animationTime, self.animationStartY, self.animationEndY - self.animationStartY, self.totalAnimationTime)		
		
		if self.animationTime == self.totalAnimationTime then
			self.state = "HIDDEN"
			self:getChild("button").visible = true
			-- self:reset()
		end
		
	end 
	
end



function BirdSelector:show()
	self.animationTime = 0
	self.animationEndY = self.visibleYPos
	self.animationStartY = self.hiddenYPos
	self.state = "SHOWING"
	gamelua.pauseGame(true)
	self:getChild("button").visible = false
end

function BirdSelector:hide()
	self.animationTime = 0
	self.animationEndY = self.hiddenYPos
	self.animationStartY = self.visibleYPos
	self.state = "HIDING"
	gamelua.pauseGame(false)
end

function BirdSelector:setHatchery(hatchery)
	self.hatchery = hatchery
end

function BirdSelector:randomizeBirds()
	self.birds = {}
	
	local indicesToRandomize = {}
	local birdsIndicesToUse = {}
	
	for k, v in _G.pairs(self.birdIndices) do
		_G.table.insert(indicesToRandomize, v)
	end
	
	local count = 0
	for i = 1, 5 do
		local indexToUse = _G.math.random(1, #indicesToRandomize)
		indexToUse = 1
		_G.table.insert(birdsIndicesToUse, indicesToRandomize[indexToUse])
		
		
		local birdIndex = self:getIndexInTable(self.birdIndices, indicesToRandomize[indexToUse])
		local birdText = self:getChild("birdText" .. count)
		birdText.text = self.birdNames[birdIndex]
		count = count + 1
		
		_G.table.remove(indicesToRandomize, indexToUse)
	end
	
	
	for k, v in _G.pairs(birdsIndicesToUse) do
		_G.table.insert(self.birds, hatcheryBirds[v])
		
		-- gamelua.print("\n id " .. v .. " eyes " .. hatcheryBirds[v].eyes)
	end
	

end

function BirdSelector:setBirds(birds)

end

function BirdSelector:reset()
	self:randomizeBirds()
	
	self.nextBirdRestartNumber = 1
	
	for i = 0, 4 do
		local birdButton = self:getChild("birdButton"..i)
		birdButton.visible = true
		local birdText = self:getChild("birdText"..i)
		birdText.visible = true
		self.visibleBirds[i+1] = true
	end
end

function BirdSelector:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == "RESUME" then
		if self.state == "HIDDEN" then
			
			self:show()
		elseif self.state == "VISIBLE" then
			
			self:hide()
		elseif self.state == "SHOWING" then
			-- self:hide()			
		elseif self.state == "HIDING" then
			-- self:show()
		end 
	else
		
		for i = 0, 4 do
			if result == ("BIRD_SELECTED" .. i) then	
				
				local button = self:getChild("birdButton" .. i)
				
				local nextNumber = gamelua.replaceNextAvailableBird(button.bird, self.nextBirdRestartNumber)
				if nextNumber ~= -1 then
					self.nextBirdRestartNumber = nextNumber
					
					local text = self:getChild("birdText" .. i)				
					button.visible = false
					text.visible = false
					self.visibleBirds[i+1] = false
				end
				
				break
			end
		end
		
		if result == "MIGHTY_EAGLE" then	
			self:hide()
			gamelua.startMightyEagleFromHatchery()
		end
	end
	
	return self.closeEvent, meta
end

function BirdSelector:drawBird(x, y, scale, bird)
	local _, radius = _G.res.getSpriteBounds(bird.sprite) * 0.5
	local itms = {}
	for i = 1, #bird.sprites do				
		_G.table.insert(itms, bird.sprites[i])		
	end

	
	gamelua.drawCompoObjectLua(x, y, 0, scale, itms)
end

function BirdSelector:draw(x, y)
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	
	-- gamelua.drawGame()
	
	
	local maxAlpha = 0.5
	if self.state == "VISIBLE" then
		gamelua.drawRect(0,0,0,0.5, 0,0, gamelua.screenWidth, gamelua.screenHeight, false)
	elseif self.state == "SHOWING" then		
		local alpha = self:tweenEaseCubicOut(self.animationTime, 0, maxAlpha, self.totalAnimationTime)
		gamelua.drawRect(0,0,0,alpha, 0,0, gamelua.screenWidth, gamelua.screenHeight, false)				
	elseif self.state == "HIDING" then		
		local alpha = self:tweenEaseCubicIn(self.animationTime, maxAlpha, -maxAlpha, self.totalAnimationTime)
		gamelua.drawRect(0,0,0,alpha, 0,0, gamelua.screenWidth, gamelua.screenHeight, false)							
	end 
	
	ui.Frame.draw(self, x, y)
	
	for i = 0, (#self.birds -1) do
		if self.visibleBirds[i+1] == true then
			local birdBounds = self:getBirdBounds(self.birds[i+1])
			local scale = self.gridWidth / birdBounds.width
			scale = _G.math.min(scale, self.gridHeight / birdBounds.height)
			scale = _G.math.min(scale, 1)
			-- scale = 1
			local x = self.x + self.birdStartX + i * self.birdOfffsetX + self.gridWidth * 0.5
			-- local y = self.y + self.birdStartY + self.gridHeight * 0.5
			
			local bottomMostEntry = self:getBottomMostEntry(self.birds[i+1])
			local bottomMostSprite = bottomMostEntry.sprite
			local bottomMostSpriteW, bottomMostSpriteH = _G.res.getSpriteBounds("", bottomMostSprite)
			local bottomMostSpritePX, bottomMostSpritePY = _G.res.getSpritePivot("", bottomMostSprite)
			local diff = (bottomMostSpriteH - bottomMostSpritePY) * scale
			-- local diffPivot = bottomMostEntry.y
			
			-- local bottomPieceY = self.y + self.birdStartY + self.gridHeight - diff
			-- local y = bottomPieceY - bottomMostEntry.y * scale
			local y = self.y + self.birdStartY + self.gridHeight - diff + bottomMostEntry.y + self.birdOffsets[i+1]
			
			
			--TODO:fix this hack
			local shadowScale = 1
			if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
				shadowScale = 0.3	
				gamelua.setRenderState(x / shadowScale,(self.y + self.birdStartY + self.gridHeight) / shadowScale,shadowScale,shadowScale,0)
			else 
				gamelua.setRenderState(x,self.y + self.birdStartY + self.gridHeight,1,1,0)
			end
			_G.res.drawSprite("", "H_SHADOW_1", 0, 0)
			-- self:drawBird(x, y , scale, self.birds[i+1], bottomMostEntry)
			
			--TODO:fix this hack
			local birdScale = scale
			if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
				birdScale = 0.2		
			end
			
			self:drawBird(x, y , birdScale, self.birds[i+1])
			
			-- local x0 = x - 10
			-- local x1 = x + 10
			-- local y0 = self.y + self.birdStartY + self.gridHeight - birdBounds.height * scale
			-- local y1 = self.y + self.birdStartY + self.gridHeight
			-- gamelua.drawRect(0,1,0,0.5, x0,y0, x1, y1, false)	
		end
	end
	
end

function BirdSelector:getBirdBounds(bird)
	
	local list = bird.sprites
	local minX = 1000
	local minY = 1000
	
	local maxX = -1000
	local maxY = -1000
	
	for k, v in _G.pairs(list) do
		local spriteW, spriteH = _G.res.getSpriteBounds("", v.sprite)
		local spritePX, spritePY = _G.res.getSpritePivot("", v.sprite)
		
		-- v.angle = 0
		local spriteMinX = v.x - spritePX * v.scale
		local spriteMinY = v.y - spritePY * v.scale
		
		local spriteMaxX = spriteMinX + spriteW * v.scale
		local spriteMaxY = spriteMinY + spriteH * v.scale
		
		minX = _G.math.min(minX, spriteMinX)
		minY = _G.math.min(minY, spriteMinY)
		
		maxX = _G.math.max(maxX, spriteMaxX)
		maxY = _G.math.max(maxY, spriteMaxY)
	end	
	
	return {width = maxX - minX, height = maxY - minY}
	
end

function BirdSelector:getBottomMostEntry(bird)
	
	local list = bird.sprites		
	local maxY = -1000
	local item = nil
	
	for k, v in _G.pairs(list) do
		local spriteW, spriteH = _G.res.getSpriteBounds("", v.sprite)
		local spritePX, spritePY = _G.res.getSpritePivot("", v.sprite)		
		
		local spriteMinY = v.y - spritePY * v.scale				
		local spriteMaxY = spriteMinY + spriteH * v.scale
		
		if spriteMaxY > maxY then
			item = v
			maxY = spriteMaxY
		end
	end	
	
	return item
	
end

function BirdSelector:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

function BirdSelector:tweenEaseCubicIn(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d
	return c*(t)*t*t + b;
end

function BirdSelector:tweenEaseCubicOut(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d-1
	return c*((t)*t*t + 1) + b;
end

filename="BirdSelector.lua"
