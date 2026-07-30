-----------------------------
------- ImageButton ---------
-----------------------------
RectangleButton = Frame:new()

function RectangleButton:init()
	self.enabled = true
	self.pivotX = self.pivotX or 0
	self.pivotY = self.pivotY or 0
	
	self.w = self.w or 0
	self.h = self.h or 0
	
	self.r = self.r or 0
	self.g = self.g or 0
	self.b = self.b or 0
	self.a = self.a or 0
end

function RectangleButton:onEntry()
	self.clickStarted = false
end

function RectangleButton:setEnabled(enabled)
	self.enabled = enabled	
end	

function RectangleButton:draw(x,y, scaleX, scaleY, angle)
	if self.visible == true then
	
		local x = x or 0
		local y = y or 0
		local scaleX = scaleX or 1
		local scaleY = scaleY or 1
		local angle = angle or 0
		
		local finalScaleX = scaleX * self.scaleX
		local finalScaleY = scaleY * self.scaleY
		
		local finalX = x + (self.x * scaleX)
		local finalY = y + (self.y * scaleY)
		
		local finalAngle = angle + self.angle			
		
		px, py = self.pivotX or px, self.pivotY or py
		local rotatePivotX, rotatePivotY = self.rotatePivotX or px, self.rotatePivotY or py
		if self.floorCoordinates then 
			finalX = _G.math.floor(finalX)	
			finalY = _G.math.floor(finalY)
		end	
	
		gamelua.setRenderState(finalX / finalScaleX, finalY / finalScaleY, finalScaleX, finalScaleY, finalAngle, rotatePivotX, rotatePivotY)
		
		gamelua.drawRect(self.r, self.g, self.b, self.a, 0,0, self.w, self.h, true)
		
		-- _G.res.drawSprite("", self.image, 0, 0,"HPIVOT","VPIVOT", _G.math.floor(self.w) , _G.math.floor(self.h) )
		
		Frame.draw(self,x,y, scaleX, scaleY, angle)	
	end
end

function RectangleButton:hitTest(x, y)

	local self_x = self.x
	local self_y = self.y
	local self_h = self.h
	local self_w = self.w

	local self_px = self.px
	local self_py = self.py
	
	local self_sx = self.scaleX

	local xcond = false
	
	if self.scaleX >= 0 then
		xcond = x >= self_x - self_px * self_sx and x <= self_x + (self_w - self_px) * self_sx
	else
		xcond = x >= self_x - (self_w - self_px) * -self_sx and x <= self_x + self_px * -self_sx
	end
	
	if xcond and y >= self_y - self_py * self.scaleY and y <= self_y + (self_h - self_py) * self.scaleY then
		return true
	end
	
	return false
end

function RectangleButton:onPointerEvent(eventType,x,y)


	if ((not self.activateOnRelease and eventType == "LPRESS") or (self.activateOnRelease and eventType == "LRELEASE")) and self.enabled ~= false then
		local w,h = self.w, self.h
		local px, py = self.pivotX, self.pivotY
		--if(x >= self.x and x <= self.x + w and y > self.y and y <= self.y + h) then
		worldScale = 1
		local scaleX = self.scaleX or 1
		local scaleY = self.scaleY or 1
		
		-- if x >= self.x - px * scaleX and x <= self.x + (w - px) * scaleX and y >= self.y - py * scaleY and y <= self.y + (h - py) * scaleY then
		if self:checkCollision(x,y) then
			if self.sound ~= nil then				
				_G.res.playAudio(self.sound, 1, false)				
			elseif self.soundTable ~= nil then
				_G.res.playAudio(self.soundTable[_G.math.random(1, #self.soundTable)])
			end
			return self.returnValue, self.meta, self
		end		
	end
	
	return Frame.onPointerEvent(self, eventType,x,y)
	
end

function RectangleButton:checkCollision(x,y)
	
	-- if self.image ~= nil then
		local w,h = self.w, self.h
		local px, py = self.pivotX, self.pivotY
		local scaleX = self.scaleX or 1
		local scaleY = self.scaleY or 1
		return x >= self.x - px * scaleX and x <= self.x + (w - px) * scaleX and y >= self.y - py * scaleY and y <= self.y + (h - py) * scaleY 
	-- end
	
	-- return false
end

filename="RectangleButton.lua"
