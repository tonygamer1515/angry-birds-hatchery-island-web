StaticButton =  ScallableButton:new()

function StaticButton:init()
	ImageButton.init(self)
end


function StaticButton:onPointerEvent(eventType,x,y)
	--even if we are not concerned about some of these events (they wont trigger the button), we eat them away anyway if the mouse cursor is upon us.
	if ( eventType == "LPRESS") or ( eventType == "LRELEASE") or ( eventType == "LHOLD") and self.enabled ~= false then
		local w,h = _G.res.getSpriteBounds(self.image)
		local px, py = _G.res.getSpritePivot(self.image)
		--if(x >= self.x and x <= self.x + w and y > self.y and y <= self.y + h) then
		worldScale = 1
		local scaleX = self.scaleX or 1
		local scaleY = self.scaleY or 1
		
		-- if x >= self.x - px * scaleX and x <= self.x + (w - px) * scaleX and y >= self.y - py * scaleY and y <= self.y + (h - py) * scaleY then
		if self:checkCollision(x,y) then
			if  ((not self.activateOnRelease and eventType == "LPRESS") or (self.activateOnRelease and eventType == "LRELEASE")) then
				if self.sound ~= nil then				
					_G.res.playAudio(self.sound, 1, false)				
				elseif self.soundTable ~= nil then
					_G.res.playAudio(self.soundTable[_G.math.random(1, #self.soundTable)])
				end
				return self.returnValue, self.meta, self
			else
				--eat the event anyway so underlying stuff wont bug
				return -1
			end
		end
	end
	
	return Frame.onPointerEvent(self, eventType,x,y)
	
end


filename="StaticButton.lua"
