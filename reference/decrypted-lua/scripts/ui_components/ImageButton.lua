-----------------------------
------- ImageButton ---------
-----------------------------
ImageButton = Image:new()

function ImageButton:init()
	self.enabled = true
end

function ImageButton:onEntry()
	self.clickStarted = false
	Image.onEntry(self)
end

function ImageButton:setEnabled(enabled)
	self.enabled = enabled
	if(enabled) then
		Image.setImage(self,self.enabledImage)
	else
		Image.setImage(self,self.disabledImage)
		--self.image = self.disabledImage
	end	
end	

function ImageButton:setImage(enabledImage, disabledImage)
	Image.setImage(self,enabledImage)
	self.enabledImage = enabledImage
	self.disabledImage = disabledImage
	self:setEnabled(self.enabled)
end

function ImageButton:hitTest(x, y)

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

function ImageButton:handlePointerEvent(eventType, x, y)
	
	if self.activateOnRelease and eventType == "LPRESS" and self.visible and self.image then
		if self:hitTest(x, y) then
			self.clickStarted = true
		end
	end

	if ((not self.activateOnRelease and eventType == "LPRESS") or (self.activateOnRelease and eventType == "LRELEASE")) and (self.enabled ~= false or self.disabledReturnValue ~= nil) and self.image then
	
		if self:hitTest(x, y) and (self.clickStarted or not self.activateOnRelease) then
			if self.clickSound then
				_G.res.playAudio(self.clickSound, 1, false)
			end
			if self.enabled then
				return self.returnValue, self.meta, self			
			else
				return self.disabledReturnValue, self.meta, self						
			end
		else
			self.clickStarted = false
		end
	end
	return nil, nil, nil
end

function ImageButton:onPointerEvent(eventType,x,y)
	local retval, meta, element = self:handlePointerEvent(eventType, x, y)
	if retval ~= nil then
		return retval, meta, element
	end
	return Frame.onPointerEvent(self, eventType,x,y)
end

filename="ImageButton.lua"
