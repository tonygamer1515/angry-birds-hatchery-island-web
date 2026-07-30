EggPainter = ui.Frame:new()
Frame = ui.Frame

function EggPainter:init()
	Frame.init(self)	
	
	self.shading = 0.8
	
	local close = ui.ScallableButton:new()
	close.name = "closeButton"
	close:setImage("H_BTN_OK")
	close.returnValue = hatcheryEvents.EID_HATCHERY_CLOSE_EGGPAINTER
	close.sound = getHatcherySound("ok")
	self:addChild(close)
	close.activateOnRelease = true
	
	
	local egg = ui.EggCanvas:new()
	egg.name = "paintEgg"
	egg:initializeCanvas("H_EGG_PAINTABLE_BASE")
	egg:setOverlay("H_EGG_PAINTABLE_OVERLAY")
	--TODO: fix this hack
	if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4" then
		-- egg.scaleX = 0.5
		-- egg.scaleY = 0.5
	end
	self:addChild(egg)
	
	--relative to the first bubble
	self.bubblesPositions = {{39, -29}, {77, -142}}
	
	local bubble1 = ui.Image:new()
	bubble1.name = "bubble1"
	bubble1.visible = false
	bubble1:setImage("H_THINK_BUBBLE_1")
	bubble1.attach = "fixed"
	self:addChild(bubble1)	
	bubble1.floorCoordinates = false
	
	local bubble2 = ui.Image:new()
	bubble2.name = "bubble2"
	bubble2.visible = false
	bubble2:setImage("H_THINK_BUBBLE_2")
	bubble2.attach = "fixed"
	self:addChild(bubble2)	
	bubble2.floorCoordinates = false
	
	local bubble3 = ui.Image:new()
	bubble3.name = "bubble3"
	bubble3.visible = false
	bubble3:setImage("H_THINK_BUBBLE_3")
	bubble3.attach = "fixed"
	self:addChild(bubble3)	
	bubble3.floorCoordinates = false
	
	local bubbleBird = ui.Image:new()
	bubbleBird.name = "bubbleBird"
	bubbleBird.visible = false
	bubbleBird:setImage("H_THINK_BUBBLE_SILHOUETTE_RED")
	bubbleBird.attach = "fixed"
	self:addChild(bubbleBird)	
	bubbleBird.floorCoordinates = false
	
	self.bucketDistance = 170
	--TODO: fix this hack
	if gamelua.deviceModel == "iphone"  or gamelua.deviceModel == "iphone4" then
		self.bucketDistance = 100
	end
	self.minBucketScale = 0.6
	self.minBucketAlpha = 0.25
	
	-- self.COLORS = {"RED", "BLUE", "YELLOW", "WHITE",  "BLACK", "GREEN", "BIGBROTHER", "ORANGE"}
	self.COLORS = {"RED", "BLUE", "YELLOW", "BLACK", "WHITE", "GREEN", "BIGBROTHER", "ORANGE"}
	
	self.colorWheelAngle = 0
	
	for i =  1, #self.COLORS do
		-- local colorbutton = ui.ToggleButton:new()
		local colorbutton = ui.ScallableButton:new()
		colorbutton.name = self.COLORS[i] .. "_Bucket"
		colorbutton.paintColor = self.COLORS[i]
		-- colorbutton:setImage({ "H_PAINT_BUCKET_OFF_" .. self.COLORS[i],"H_PAINT_BUCKET_ON_" .. self.COLORS[i]}, "H_PAINT_BUCKET_OFF_" .. self.COLORS[i])
		colorbutton:setImage("H_PAINT_BUCKET_OFF_" .. self.COLORS[i])
		colorbutton.paintOffSprite = "H_PAINT_BUCKET_OFF_" .. self.COLORS[i]
		colorbutton.paintOnSprite = "H_PAINT_BUCKET_ON_" .. self.COLORS[i]
		colorbutton.returnValue = hatcheryEvents.EID_HATCHERY_EGGPAINTER_CHANGE_COLOR
		self:addChild(colorbutton)
	end
	
	self.selectedColor = nil
	--select first
	self:changeColor(self.COLORS[1])
	-- self:getChild(self.COLORS[1] .. "_Bucket"):setState(2)
	
	self.particles = EggPainterParticles:new()
	
	self.totalDragged = 0
	
	self.currentBirdColor = ""
	
	self.selectedPaint = nil
	
	
	
	self.fadeAlpha = 1
	
end

function EggPainter:showOrHideBubbles(show)
	for i = 1, 3 do
		local bubble = self:getChild("bubble" .. i)
		bubble.visible = show
	end
	
	local bubbleBird = self:getChild("bubbleBird")
	bubbleBird.visible = show
end

function EggPainter:changeColor(color)
	-- if self.selectedColor ~= nil  then
		-- local button = self:getChild(self.selectedColor .. "_Bucket")
		
		-- if self.selectedColor == color then
			-- button:setState(2)
		-- else
			-- button:setState(1)
		-- end
	-- end

	
	self.selectedColor = color

	local egg = self:getChild("paintEgg")
	egg:setBrush("H_PAINT_BRUSH_" .. color)
end

function EggPainter:onEntry()
	ui.Frame.onEntry(self)
	self:scrollClosestItem()
end

function EggPainter:onExit()
	ui.Frame.onExit(self)
end


function EggPainter:layout()
	Frame.layout(self)	
	
	local close = self:getChild("closeButton")
	close.x = 0
	close.y = gamelua.screenHeight*0.4
	
	local egg = self:getChild("paintEgg")
	local w,h = egg:getCanvasBounds()
	egg.x = 0
	egg.y = h*0.4
	
	local offsetX,offsetY = gamelua.screenWidth*0.2,0
	local radiusX = gamelua.screenWidth * 0.2
	local radiusY = gamelua.screenHeight * 0.22
	local angle = 0
	local addition = (1/(#self.COLORS+2)) * _G.math.pi*2
	angle = angle+ addition
	for i = 1, #self.COLORS do
		local offsetY =  0
		local dir = 0
		if angle > _G.math.pi then
			dir = -1
			offsetY =(i-(#self.COLORS*0.5))*radiusY - self.x + gamelua.screenHeight * 0.1
		else
			dir = 1
			offsetY =  i*radiusY - self.x + gamelua.screenHeight * 0.1
		end
		
		-- local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
		-- colorbutton.x = _G.math.sin(angle) * radiusX + offsetX*dir
		-- colorbutton.y = offsetY
		
		local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
		colorbutton.x = -gamelua.screenWidth * 0.5 + gamelua.screenWidth * (100/1024)
		colorbutton.y = offsetY
		
		colorbutton.activateOnRelease = true
		
		local totalHeight = self.bucketDistance * (#self.COLORS - 1)
		colorbutton.y = -totalHeight * 0.5 + (i-1) * self.bucketDistance
		
		
		angle = angle + addition
		if angle == _G.math.pi then
			angle = angle + addition
		end
	end
	
	
	local diffX = 230
	local diffY = -320
	
	local bubble1 = self:getChild("bubble1")
	local bubble2 = self:getChild("bubble2")
	local bubble3 = self:getChild("bubble3")
	
	bubble1.x = egg.x + diffX
	bubble1.y = egg.y + diffY
	
	bubble2.x = bubble1.x + self.bubblesPositions[1][1]
	bubble2.y = bubble1.y + self.bubblesPositions[1][2]
	
	bubble3.x = bubble1.x + self.bubblesPositions[2][1]
	bubble3.y = bubble1.y + self.bubblesPositions[2][2]
	
	
	self.originalBubblePositions = {{bubble1.x, bubble1.y},{bubble2.x, bubble2.y},{bubble3.x, bubble3.y},}
	
	-- local diffX = 706 - egg
	-- local ratioY = 135/728
	-- bubble1.x = ratioX * gamelua.screen
	
	-- local minAndMaxRotationSpeeds = {0.1, 0.5}
	-- local minAndMaxFrequenciesX = {0, 0}
	-- local minAndMaxFrequenciesY = {1, 2}
	-- local minAndMaxAmplitudesX = {0, 5}
	-- local minAndMaxAmplitudesY = {5, 8}
	
	local minAndMaxRotationSpeeds = {0.5, 1}
	local minAndMaxFrequenciesX = {1, 1}
	local minAndMaxFrequenciesY = {1, 2}
	local minAndMaxAmplitudesX = {1, 1}
	local minAndMaxAmplitudesY = {5, 10}
	
	for i = 1, 2 do
		local bubble = self:getChild("bubble" .. i)
		
		local randomNumber = _G.math.random()
		
		bubble.rotationSpeed = minAndMaxRotationSpeeds[1] + (minAndMaxRotationSpeeds[2] - minAndMaxRotationSpeeds[1]) * randomNumber
		bubble.angle = 0
		
		randomNumber = _G.math.random()
		bubble.waveFrequencyX = minAndMaxFrequenciesX[1] + (minAndMaxFrequenciesX[2] - minAndMaxFrequenciesX[1]) * randomNumber
		bubble.waveAngleX = 0
		
		randomNumber = _G.math.random()
		bubble.waveFrequencyY = minAndMaxFrequenciesY[1] + (minAndMaxFrequenciesY[2] - minAndMaxFrequenciesY[1]) * randomNumber
		bubble.waveAngleY = 0
		
		bubble.originalX = bubble.x
		bubble.originalY = bubble.y
		
		randomNumber = _G.math.random()
		bubble.waveAmplitudeX = minAndMaxAmplitudesX[1] + (minAndMaxAmplitudesX[2] - minAndMaxAmplitudesX[1]) * randomNumber
		
		randomNumber = _G.math.random()
		bubble.waveAmplitudeY = minAndMaxAmplitudesY[1] + (minAndMaxAmplitudesY[2] - minAndMaxAmplitudesY[1]) * randomNumber
		
		
	end
	
	local minAndMaxRotationSpeeds = {0, 0}
	local minAndMaxFrequenciesX = {0, 0}
	local minAndMaxFrequenciesY = {2, 2}
	local minAndMaxAmplitudesX = {0, 0}
	local minAndMaxAmplitudesY = {8, 8}
	
	local i = 3
	local bubble = self:getChild("bubble" .. i)
	
	local randomNumber = _G.math.random()
	
	bubble.rotationSpeed = minAndMaxRotationSpeeds[1] + (minAndMaxRotationSpeeds[2] - minAndMaxRotationSpeeds[1]) * randomNumber
	bubble.angle = 0
	
	randomNumber = _G.math.random()
	bubble.waveFrequencyX = minAndMaxFrequenciesX[1] + (minAndMaxFrequenciesX[2] - minAndMaxFrequenciesX[1]) * randomNumber
	bubble.waveAngleX = 0
	
	randomNumber = _G.math.random()
	bubble.waveFrequencyY = minAndMaxFrequenciesY[1] + (minAndMaxFrequenciesY[2] - minAndMaxFrequenciesY[1]) * randomNumber
	bubble.waveAngleY = 0
	
	bubble.originalX = bubble.x
	bubble.originalY = bubble.y
	
	randomNumber = _G.math.random()
	bubble.waveAmplitudeX = minAndMaxAmplitudesX[1] + (minAndMaxAmplitudesX[2] - minAndMaxAmplitudesX[1]) * randomNumber
	
	randomNumber = _G.math.random()
	bubble.waveAmplitudeY = minAndMaxAmplitudesY[1] + (minAndMaxAmplitudesY[2] - minAndMaxAmplitudesY[1]) * randomNumber
	
	
	self.particles:setSource(self.x + bubble2.x, self.y + bubble2.y, "DISAPPEAR_SMALL_BUBBLE")
	self.particles:setSource(self.x + bubble3.x, self.y + bubble3.y, "DISAPPEAR_BIG_BUBBLE")
	self.particles:setSource(self.x + bubble3.x, self.y + bubble3.y, "NEW_BIRD")
	
	bubble3.rotationSpeed = 0
	
end

function EggPainter:reset()
	gamelua.clearCanvas(0.847,0.890,0.909,1)
	
	self:showOrHideBubbles(false)
	
	self.currentBirdColor = ""
end

function EggPainter:update(dt, time) 

	ui.Frame.update(self,dt, time)
	
	if gamelua.keyReleased["F"] then
		-- self.particles:startDisappearBigBubbleParticles()
		self.scrollVelocity = 50
		-- self:scrollClosestItem()
	end
	if gamelua.keyReleased["D"] then
		-- self.particles:startDisappearBigBubbleParticles()
		self.scrollVelocity = -50
		-- self:scrollClosestItem()
	end
	
	
	local color1, color2 = gamelua.getDominantCanvasColors()
	
	--gamelua.print("\n dominan t" .. color1 .. " " .. color2)
	
	if self.currentBirdColor ~= color1 then
		self.currentBirdColor = color1
		
		if color1 == "" then
			-- self:showOrHideBubbles(false)
			-- gamelua.print("\n hiding")
			-- self:hideCurrentBubble()
			newBirdOnBubble(nil)
		else
			-- self:showOrHideBubbles(true)
			self:newBirdOnBubble(self.currentBirdColor)
			-- gamelua.print("\n shoing " .. self.currentBirdColor)
		end
	end
	
	if self.bubbleDisappearingTime ~= nil then
		--play sound
		if self.bubbleDisappearingTime == 0 then
			_G.res.playAudio(getHatcherySound("bubbleDisappearing"), 1, false)
		end
		self.bubbleDisappearingTime = self.bubbleDisappearingTime + dt
		
		if self.bubbleDisappearingTime >= self.bubbleDisappearingTotalTime then
			if self.bubbleNewBirdColor ~= nil then
				self:showNewBubble(self.bubbleNewBirdColor)
			end
		
			self.bubbleDisappearingTime = nil
		end
		
		
	end
	
	if self.bubbleAppearingTime ~= nil then
		local bubble1 = self:getChild("bubble1")
		local bubble2 = self:getChild("bubble2")
		local bubble3 = self:getChild("bubble3")
		
		self.bubbleAppearingTime = self.bubbleAppearingTime + dt
		
		if bubble1.visible == false then
			bubble1.visible = true
			--play sound
			_G.res.playAudio(getHatcherySound("bubbleAppearing"), 1, false)
		end
		
		if self.bubbleAppearingTime >= (self.bubbleAppearingTotalTime * 0.5) and bubble2.visible == false then
			bubble2.visible = true
			--play sound
			_G.res.playAudio(getHatcherySound("bubbleAppearing"), 1, false)
		end
		
		if self.bubbleAppearingTime >= self.bubbleAppearingTotalTime then
			self.bubbleAppearingTime = nil
			bubble3.visible = true
			--play sound
			_G.res.playAudio(getHatcherySound("bubbleAppearing"), 1, false)
			
			
			self:showOrHideBubbles(true)
	
			local bubbleBird = self:getChild("bubbleBird")
			local images = {	"H_THINK_BUBBLE_SILHOUETTE_RED", "H_THINK_BUBBLE_SILHOUETTE_BLUE", "H_THINK_BUBBLE_SILHOUETTE_YELLOW", "H_THINK_BUBBLE_SILHOUETTE_BLACK",  
								"H_THINK_BUBBLE_SILHOUETTE_WHITE", "H_THINK_BUBBLE_SILHOUETTE_BOOMERANG", "H_THINK_BUBBLE_SILHOUETTE_BIGBROTHER", "H_THINK_BUBBLE_SILHOUETTE_ORANGE"}
			bubbleBird:setImage(images[self:getIndexInTable(self.COLORS, self.bubbleNewBirdColor)])	

			self.particles:setSource(self.x + bubbleBird.x, self.y + bubbleBird.y, "NEW_BIRD")
			self.particles:startNewBirdParticles()
			
			_G.res.playAudio(getHatcherySound("newBirdAppearing"), 1, false)
			
		end
		
		
	end
	
	
	
	local bubble3 = self:getChild("bubble3")
	
	if bubble3.visible == true then
		for i = 1, 3 do
			local bubble = self:getChild("bubble" .. i)
			
			bubble.angle = bubble.angle + bubble.rotationSpeed * dt
			bubble.waveAngleX = bubble.waveAngleX + bubble.waveFrequencyX * dt
			bubble.waveAngleX = _G.math.fmod(bubble.waveAngleX, _G.math.pi * 2)
			
			bubble.waveAngleY = bubble.waveAngleY + bubble.waveFrequencyY * dt
			bubble.waveAngleY = _G.math.fmod(bubble.waveAngleY, _G.math.pi * 2)
			
			bubble.x = bubble.originalX + _G.math.sin(bubble.waveAngleX) * bubble.waveAmplitudeX
			bubble.y = bubble.originalY + _G.math.sin(bubble.waveAngleY) * bubble.waveAmplitudeY
		end
		
		
	end
	
	if self.particles ~= nil then
		self.particles:update(dt, time)
	end
	
	local bubbleBird = self:getChild("bubbleBird")
	bubbleBird.x = bubble3.x
	bubbleBird.y = bubble3.y
	
	local bucketSpriteW, bucketSpriteH = _G.res.getSpriteBounds("", "H_PAINT_BUCKET_ON_GREEN")	
	local bucketSpritePX, bucketSpritePY = _G.res.getSpritePivot("", "H_PAINT_BUCKET_ON_GREEN")	
	local bucketX = gamelua.screenWidth * (100/1024)
	local cursorLimit = bucketX + bucketSpriteW - bucketSpritePX
	
	-- gamelua.print("\n limit " .. cursorLimit .. " " .. gamelua.cursor.x)
	-- gamelua.print(nil)
	
	for i = 1, #self.COLORS do			
		local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
		
		if gamelua.keyHold["LBUTTON"] and gamelua.cursor.x < cursorLimit and self.lastCursorY ~= nil then									
			colorbutton.y = colorbutton.y + (gamelua.cursor.y - self.lastCursorY)									
		end
		
		local scale = 1 - (1 - self.minBucketScale) * (_G.math.abs(colorbutton.y) / (gamelua.screenHeight * 0.5))
		scale = _G.math.max(scale, self.minBucketScale)
		scale = _G.math.min(scale, 1)	

		local alpha = 1 - (1 - self.minBucketAlpha) * (_G.math.abs(colorbutton.y) / (gamelua.screenHeight * 0.5))
		alpha = _G.math.max(alpha, self.minBucketAlpha)
		alpha = _G.math.min(alpha, 1)	
		
		-- scale = 1
		colorbutton.scaleX = scale
		colorbutton.scaleY = scale
		colorbutton.alpha = alpha
		
		
	end
	
	
	
	if gamelua.keyHold["LBUTTON"] and gamelua.cursor.x < cursorLimit and self.lastCursorY ~= nil and _G.math.abs(gamelua.cursor.y - self.lastCursorY) > 0 then
		self.totalDragged = self.totalDragged + _G.math.abs(gamelua.cursor.y - self.lastCursorY)	
		self:repositionButtons(gamelua.cursor.y > self.lastCursorY)
		self.scrollTime = nil
		self.selectedPaint = nil
		
		for i = 1, #self.COLORS do
			local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
			colorbutton:setImage(colorbutton.paintOffSprite)
		end		

		if self.scrollVelocity == nil then
			self.scrollVelocity = gamelua.cursor.y - self.lastCursorY
		else
			self.scrollVelocity = self.scrollVelocity + (gamelua.cursor.y - self.lastCursorY)
		end
		
		self.scrollVelocity = self.scrollVelocity - self.scrollVelocity * 0.3
		
		if self.scrollVelocity < -50 then
			self.scrollVelocity = -50
		elseif self.scrollVelocity > 50 then
			self.scrollVelocity = 50
		end
		-- if self.scrollVelocity == nil then
			-- self.scrollVelocity = 0
			-- self.scrollVelocityLastDeltas = {}			
			-- self.scrollVelocityLastIndex = 0
		-- end
		
		-- if self.scrollVelocityLastIndex == 3 then
		
		-- else
			-- _G.table.insert(self.scrollVelocityLastDeltas, gamelua.cursor.y - self.lastCursorY)
			-- self.scrollVelocityLastIndex = self.scrollVelocityLastIndex + 1
		-- end
			
	end
	
	if self.scrollVelocity ~= nil and not gamelua.keyHold["LBUTTON"] then
		self.scrollVelocity = self.scrollVelocity - self.scrollVelocity * 0.03
		
		for i = 1, #self.COLORS do
			local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
			colorbutton.y = colorbutton.y + self.scrollVelocity
		end		
		
		self:repositionButtons(self.scrollVelocity > 0)
		
		if _G.math.abs(self.scrollVelocity) < 5 then
			
			self:scrollClosestItem(self.scrollVelocity > 0)
			
			self.scrollVelocity = nil
		end
	end
	
	if gamelua.keyReleased["LBUTTON"] and self.totalDragged >= 10 and (self.scrollVelocity == nil or _G.math.abs(self.scrollVelocity) < 5) then
		self:scrollClosestItem()
	end
	
	if self.scrollTime ~= nil then
	
		self.scrollTime = self.scrollTime + dt
		
		self.scrollTime = _G.math.min(self.scrollTime, self.totalScrollTime)
		
		local newY = gamelua.tweenEaseCubicInOut(self.scrollTime, self.scrollStart, -self.scrollStart, self.totalScrollTime)
		
		local diff = newY - self.selectedPaint.y
		
		for i = 1, #self.COLORS do			
			local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
			colorbutton.y = colorbutton.y + diff
		end
		
		if self.scrollTime == self.totalScrollTime then
			self.scrollTime = nil
		end
		
		self:repositionButtons(diff > 0)
	end
	
	
	if self.clearTotalDragged == true then	
		self.totalDragged = 0
		self.clearTotalDragged = false
	end
	
	if gamelua.keyReleased["LBUTTON"] then
		--we need an extra update so that the onPointerEvent is called before the totalDragged variable is cleared
		self.clearTotalDragged = true		
	end		
	
	if gamelua.keyHold["LBUTTON"] then
		self.lastCursorY = gamelua.cursor.y
	else
		self.lastCursorY = nil
	end
end


function EggPainter:getAvailableColors()
	return self.COLORS
end


function EggPainter:repositionButtons(direction)
	local firstVisible = nil
	local lastVisible = nil
	local minY = 10000
	local maxY = -10000
	
	local firstIndex = 1
	local lastIndex = 1
	
	
	
	for i = 1, #self.COLORS do			
		local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
		local screenY = self.y + colorbutton.y
		
		local px, py = _G.res.getSpritePivot("", colorbutton.image)
		local w, h = _G.res.getSpriteBounds("", colorbutton.image)
		local bottom = screenY - (py * colorbutton.scaleY) + (h * colorbutton.scaleY)
		local top = screenY - (py * colorbutton.scaleY)
		
		colorbutton.visible = false
		
		colorbutton.visible = bottom >= 0 and top <= gamelua.screenHeight				
		
		if bottom >= 0 and bottom < minY then
			minY = bottom
			firstVisible = colorbutton		
			firstIndex = i			
		end
		
		if top <= gamelua.screenHeight and top > maxY then
			maxY = top
			lastVisible = colorbutton		
			lastIndex = i
			
		end
	end			
	
	self.firstVisible = firstVisible
	self.lastVisible = lastVisible		
	
	local firstButton = self:getChild(self.COLORS[1] .. "_Bucket")
	local lastButton = self:getChild(self.COLORS[#self.COLORS] .. "_Bucket")			
	
	if firstIndex == 1 then
		local button = self:getChild(self.COLORS[#self.COLORS] .. "_Bucket")
		button.y = firstVisible.y - self.bucketDistance
		button.visible = true
	else
		local button = self:getChild(self.COLORS[firstIndex-1] .. "_Bucket")
		button.y = firstVisible.y - self.bucketDistance 
		button.visible = true		
	end
	
	if lastIndex == #self.COLORS then
		local button = self:getChild(self.COLORS[1] .. "_Bucket")
		button.y = lastVisible.y + self.bucketDistance
		button.visible = true
	else
		local button = self:getChild(self.COLORS[lastIndex+1] .. "_Bucket")
		button.y = lastVisible.y + self.bucketDistance
		button.visible = true
	end
	
	
	
end

function EggPainter:drawEgg(x,y, scaleX, scaleY, angle)
	local egg = self:getChild("paintEgg")
	egg:draw(x-egg.x,y-egg.y,scaleX,scaleY,angle)
end

function EggPainter:getEggCanvas()
	return self:getChild("paintEgg")
	
end

function EggPainter:newBirdOnBubble(color)
	local bubbleBird = self:getChild("bubbleBird")
	
	if bubbleBird.visible == true then
		self.bubbleDisappearingTime = 0
		self.bubbleDisappearingTotalTime = 0.2
		self.bubbleNewBirdColor = color
		
		self:hideCurrentBubble()
	else		
		self:showNewBubble(color)
	end
	


	-- self:showOrHideBubbles(true)
	
	-- local bubbleBird = self:getChild("bubbleBird")
	-- local images = {	"H_THINK_BUBBLE_SILHOUETTE_RED", "H_THINK_BUBBLE_SILHOUETTE_BLUE", "H_THINK_BUBBLE_SILHOUETTE_YELLOW", "H_THINK_BUBBLE_SILHOUETTE_WHITE",  
						-- "H_THINK_BUBBLE_SILHOUETTE_BLACK", "H_THINK_BUBBLE_SILHOUETTE_BOOMERANG", "H_THINK_BUBBLE_SILHOUETTE_BIGBROTHER", "H_THINK_BUBBLE_SILHOUETTE_ORANGE"}
	-- bubbleBird:setImage(images[self:getIndexInTable(self.COLORS, color)])	
	
	-- self.particles:setSource(self.x + bubbleBird.x, self.y + bubbleBird.y, "NEW_BIRD")
	-- self.particles:startNewBirdParticles()
	
	
end

function EggPainter:hideCurrentBubble()
	self:showOrHideBubbles(false)
	self.particles:startDisappearBigBubbleParticles()
	self.particles:startDisappearSmallBubbleParticles()
end

function EggPainter:showNewBubble(color)
	self.bubbleAppearingTime = 0
	self.bubbleAppearingTotalTime = 0.25
	self.bubbleNewBirdColor = color
end

function EggPainter:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

function EggPainter:draw(x,y, scaleX, scaleY, angle) 
	
	--draw background
	gamelua.drawRect( 0, 0, 0, self.fadeAlpha, 0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
	
	
	if self.particles ~= nil then
		self.particles:drawSpecificParticles({"DISAPPEAR_SMALL_BUBBLE","DISAPPEAR_BIG_BUBBLE"})	
	end
	ui.Frame.draw(self,x,y, scaleX, scaleY, angle)
	
	if self.particles ~= nil then
		self.particles:drawAllParticlesExcept({"DISAPPEAR_SMALL_BUBBLE","DISAPPEAR_BIG_BUBBLE"})		
	end
	
	-- if self.firstVisible ~= nil then
		-- gamelua.drawRect(1, 0, 0, 0.5, self.x + self.firstVisible.x, self.y + self.firstVisible.y, self.x + self.firstVisible.x + 10, self.y + self.firstVisible.y + 10, false)
	-- end
	
	-- if self.lastVisible ~= nil then
		-- gamelua.drawRect(0, 1, 0, 0.5, self.x + self.lastVisible.x, self.y + self.lastVisible.y, self.x + self.lastVisible.x + 10, self.y + self.lastVisible.y + 10, false)
	-- end
	
	-- gamelua.drawLine(255,0,0,255,0,gamelua.screenHeight * 0.5,gamelua.screenWidth,gamelua.screenHeight * 0.5,false, 2)
end

function EggPainter:onPointerEvent(eventType,x,y)
	local result,meta, item = Frame.onPointerEvent(self, eventType,x, y)	
	
	if result == hatcheryEvents.EID_HATCHERY_EGGPAINTER_CHANGE_COLOR and self.totalDragged < 10 then
		
		if item and item.paintColor ~= nil and item ~= self.selectedPaint then
			
			
			
			self:scrollItem(item)
			
			
		end
	end
	
	return result, meta, item
end

function EggPainter:scrollClosestItem(direction)
	
	local closest = nil
	
	local minDist = 10000		
	
	for i = 1, #self.COLORS do			
		local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
		local screenY = self.y + colorbutton.y
		
		local px, py = _G.res.getSpritePivot("", colorbutton.image)
		local w, h = _G.res.getSpriteBounds("", colorbutton.image)
		local bottom = screenY - (py * colorbutton.scaleY) + (h * colorbutton.scaleY)
		local top = screenY - (py * colorbutton.scaleY)
		
		colorbutton.visible = bottom >= 0 and top <= gamelua.screenHeight

		if direction == nil	then
		
			if colorbutton.visible == true and _G.math.abs(colorbutton.y) < minDist then
				closest = colorbutton
				minDist = _G.math.abs(colorbutton.y)
			end		
		elseif direction == true then
			if colorbutton.visible == true and _G.math.abs(colorbutton.y) < minDist and colorbutton.y < 0 then
				closest = colorbutton
				minDist = _G.math.abs(colorbutton.y)
			end		
		elseif direction == false then
			if colorbutton.visible == true and _G.math.abs(colorbutton.y) < minDist and colorbutton.y > 0 then
				closest = colorbutton
				minDist = _G.math.abs(colorbutton.y)
			end		
		end
		
	end			
	
	if closest ~= nil then			
		self:scrollItem(closest)
		
	end
end

function EggPainter:scrollItem(item)

	local maxScrollTime = 0.5
	local ratio = (_G.math.abs(item.y) / (gamelua.screenHeight * 0.5))
	ratio = _G.math.max(ratio, 0)
	ratio = _G.math.min(ratio, 1)	
	
	self.totalScrollTime = maxScrollTime * ratio
	
	if self.totalScrollTime < 0.001 then
		self.totalScrollTime = nil
		self.scrollTime = nil 
		return
	end
	
	self.scrollTime = 0
	self.totalScrollTime = maxScrollTime * ratio
	self.scrollStart = item.y
	self.scrollEnd = 0
	
	self.selectedPaint = item
		
	
	_G.res.playAudio(getHatcherySound("canSelect"), 1, false)
	self:changeColor(item.paintColor)						
	for i = 1, #self.COLORS do
		local colorbutton = self:getChild(self.COLORS[i] .. "_Bucket")
		colorbutton:setImage(colorbutton.paintOffSprite)
	end	
	item:setImage(item.paintOnSprite)
end
filename="EggPainter.lua"
