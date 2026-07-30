EggCanvas = Image:new()


-- the image sprite is used as a "canvas". the canvas size * canvasScale is the size of the canvas, and the image sprite determines the visibility of the canvas (alpha mask).
--later could be changed so that the size of the canvas is explicitly determined


function EggCanvas:init()
	Image.init(self)
	self.overlay = nil
	self.canvasScale = 2.55
	
	--TODO: fix this hack
	if gamelua.deviceModel == "iphone"  or gamelua.deviceModel == "iphone4" then		
		self.canvasScale = 1.55
	end
	
	self.brush = nil
	self.holding = false
	self.lastPos = {}
	self.paintSoundPlaying = false
end

function EggCanvas:initializeCanvas(mask)
	self:setImage(mask)
	local sizeX, sizeY = _G.res.getSpriteBounds(mask)
	
	
	self.areaX = 512
	self.areaY = 512
	
	--TODO: fix this hack
	if gamelua.deviceModel == "iphone"  or gamelua.deviceModel == "iphone4" then	
		self.areaX = 256
		self.areaY = 256
	end
	
	gamelua.initializePainter( gamelua.Hatchery.hatchery.imagePath .. gamelua.Hatchery.hatchery.imageProfile .. "/egg_painting_assets/", self.areaX, self.areaY)
	gamelua.clearCanvas(0.847,0.890,0.909,1)
end


function EggCanvas:onPointerEvent(eventType,x,y)
	if  eventType == "LHOLD" and self.enabled ~= false then
		self.holding = true
		if self:checkCollision(x,y) then
			if eventType == "LHOLD" then
			
				if self.paintSoundPlaying == false then
					_G.res.playAudio(gamelua.Hatchery.getHatcherySound("paintingLoop"), 1, true)
					self.paintSoundPlaying = true
				end
			
				if not self.lastPos.x or not self.lastPos.y then 
					self:paintToEgg(x,y)
				elseif self.lastPos.x ~= gamelua.cursor.x or self.lastPos.y ~= gamelua.cursor.y then
					
					local moveThreshold = 10
					local dirX =  self.lastPos.x - gamelua.cursor.x
					local dirY =  self.lastPos.y - gamelua.cursor.y  
					local len = gamelua.vLength(dirX, dirY)
					dirX, dirY = gamelua.vNormalize(dirX, dirY)
					local paints = _G.math.floor(len / moveThreshold)
					
					for i = 0,paints do
						self:paintToEgg(x + dirX*i*moveThreshold,y + dirY*i*moveThreshold)
					end
					self:paintToEgg(x ,y )
				end

				self.lastPos.x = gamelua.cursor.x
				self.lastPos.y = gamelua.cursor.y
				
			end
		else
			return -1
		end
	elseif eventType == "LRELEASE" then
		 self.lastPos.x, self.lastPos.y = nil, nil
		 if self.paintSoundPlaying == true then
			_G.res.stopAudio(gamelua.Hatchery.getHatcherySound("paintingLoop"))
		 end
		 
		 self.paintSoundPlaying = false
	end
	
	return Frame.onPointerEvent(self, eventType,x,y)
	
end

function EggCanvas:setBrush(brush)
	self.brush = brush
	local sizeX, sizeY = _G.res.getSpriteBounds(brush)

	self.brushWidth, self.brushHeight = sizeX * (gamelua.screenWidth/(self.areaX)), sizeY * (gamelua.screenHeight/(self.areaY))
	
	--TODO: fix this hack
	self.brushWidth = self.brushWidth * 0.5 
	self.brushHeight = self.brushHeight * 0.5
end

function EggCanvas:onEntry()
	Frame.onEntry(self)
	gamelua.startAnalyzingCanvasColors()
end

function EggCanvas:onExit()
	Frame.onExit(self)
	gamelua.stopAnalyzingCanvasColors()
end



function EggCanvas:paintToEgg(x,y)

	if self.brush == nil then
		return
	end
	
	gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0, 1)
	local w,h = self.brushWidth, self.brushHeight
	local brushSprite =self.brush
	if not w or not h then
		w,h = _G.res.getSpriteBounds(brushSprite)
	end
	

	--transform coordinates to proper space
	

	local areaX, areaY = self.areaX, self.areaY
	-- the actual canvas is not the same size and dimensions as the canvas shown to the user (ie. the mask). "pump" the coordinates a bit, so they align with the actual canvas
	local sizeX, sizeY = _G.res.getSpriteBounds(self.image)
	local offsetX, offsetY = sizeX, sizeY
	local greater = _G.math.max(offsetX, offsetY)
	offsetX = 1-(offsetX / greater)
	offsetY = 1-(offsetY / greater)
	

	
	local px, py = _G.res.getSpritePivot(self.image)
	
	x = x - self.x 
	y = y - self.y 

	--local x = (x  + px*self.canvasScale) / (areaX * self.canvasScale)
	--local y = (y  + py*self.canvasScale) / (areaY * self.canvasScale)
	
	
	local x = (x  + px*self.canvasScale ) 
	local y = (y  + py*self.canvasScale ) 
	
	x = x + (areaX - sizeX*self.canvasScale)*0.5
	y = y + (areaY - sizeY*self.canvasScale)*0.5
	
	x = x/(areaX)
	y = y/(areaY)
	
	
	y = (1-y)
	
	gamelua.paintToCanvas(brushSprite,x,y,w,h)
end

function EggCanvas:setOverlay(overlay)
	self.overlay = overlay
end

function EggCanvas:checkCollision(x,y)
	
	
		local w,h = _G.res.getSpriteBounds(self.image)
		local px, py = _G.res.getSpritePivot(self.image)
		--if(x >= self.x and x <= self.x + w and y > self.y and y <= self.y + h) then
		worldScale = 1
		local scaleX = self.scaleX or 1
		local scaleY = self.scaleY or 1
		
		--make the io area a bit bigger than the canvas (so you can draw to the edges so that only small part of the brush is visible)
		scaleX = scaleX * self.canvasScale 
		scaleY = scaleY * self.canvasScale 
		
		-- we want to be able to draw "off" from the canvas, so you can paint only a pixel at the border etc.
		local extendsX, extendsY = 67, 67
		--px = px* self.canvasScale
		--py = py* self.canvasScale
		
		return x >= self.x - px * scaleX - extendsX and x <= self.x + (w - px) * scaleX + extendsX and y >= self.y - py * scaleY - extendsY and y <= self.y + (h - py) * scaleY + extendsY 
end



function EggCanvas:update(dt, time) 
	Image.update(self,dt,time)
end


function EggCanvas:draw(x,y, scaleX, scaleY, angle) 
	-- no need to draw the "background" if we are using the canvas itself as a background
	--Image.draw(self,x,y, self.canvasScale*scaleX, self.canvasScale*scaleY, angle)
	
	
	self:drawCanvas(x,y, scaleX, scaleY,angle)
	
	if self.overlay then
		self:drawOverlay(self.overlay, x,y,scaleX, scaleY, angle)
	end
	
	
	return
end

function EggCanvas:getCanvasBounds()
	local w,h = _G.res.getSpriteBounds(self.image)
	return w*self.canvasScale, h*self.canvasScale
end

function EggCanvas:drawCanvas(x,y,scaleX, scaleY, angle)
	local x = x or 0
	local y = y or 0
	local scaleX = scaleX or 1
	local scaleY = scaleY or 1
	local angle = angle or 0
	
	local finalScaleX = scaleX * self.scaleX * self.canvasScale
	local finalScaleY = scaleY * self.scaleY * self.canvasScale
	
	local finalX = x + self.x 
	local finalY = y + self.y
	
	local finalAngle = angle + self.angle	
	

	px, py = self.pivotX or px, self.pivotY or py
	local rotatePivotX, rotatePivotY = self.rotatePivotX or px, self.rotatePivotY or py
	if self.floorCoordinates then 
		finalX = _G.math.floor(finalX)	
		finalY = _G.math.floor(finalY)
	end
	
	
	if self.alpha == nil then
		gamelua.setRenderState(finalX / finalScaleX, finalY / finalScaleY, finalScaleX, finalScaleY, finalAngle, rotatePivotX, rotatePivotY)
	else
		gamelua.setRenderState(finalX / finalScaleX, finalY / finalScaleY, finalScaleX, finalScaleY, finalAngle, rotatePivotX, rotatePivotY, self.alpha)						
	end
	gamelua.drawCanvasWithMask(0,0,self.image)

end

function EggCanvas:drawOverlay(sprite,x,y,scaleX,scaleY, angle)
	local x = x or 0
	local y = y or 0
	local scaleX = scaleX or 1
	local scaleY = scaleY or 1
	local angle = angle or 0
	
	local finalScaleX = scaleX * self.scaleX
	local finalScaleY = scaleY * self.scaleY
	
	local finalX = x + self.x 
	local finalY = y + self.y
	
	local finalAngle = angle + self.angle	
	
	--TODO: extreme hack here
	if gamelua.deviceModel == "iphone"  or gamelua.deviceModel == "iphone4" then
		finalY = finalY - 85
		-- finalScaleX = 0.625
		finalScaleX = 1.55 / 2.55
		finalScaleY = finalScaleX
	end

	px, py = self.pivotX or px, self.pivotY or py
	local rotatePivotX, rotatePivotY = self.rotatePivotX or px, self.rotatePivotY or py
	if self.floorCoordinates then 
		finalX = _G.math.floor(finalX)	
		finalY = _G.math.floor(finalY)
	end
	

	
	if self.alpha == nil then
		gamelua.setRenderState(finalX / finalScaleX, finalY / finalScaleY, finalScaleX, finalScaleY, finalAngle, rotatePivotX, rotatePivotY)
	else
		gamelua.setRenderState(finalX / finalScaleX, finalY / finalScaleY, finalScaleX, finalScaleY, finalAngle, rotatePivotX, rotatePivotY, self.alpha)						
	end
		
		
		

	_G.res.drawCompoSprite("", sprite, 0, 0)

	
	if self.alpha ~= nil then
		gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0, 1)	
	else
		gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
	end
	
end
filename="EggCanvas.lua"
