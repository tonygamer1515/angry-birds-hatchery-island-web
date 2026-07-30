BirdButton = ScallableButton:new()


function BirdButton:setBird(bird)
	self.bird = bird
end

--disable
function BirdButton:setEnabled(enabled)
	
	
end	


function BirdButton:drawSelf(x, y, scaleX, scaleY, angle)
	local x = x or 0
	local y = y or 0
	local scaleX = scaleX or 1
	local scaleY = scaleY or 1
	local angle = angle or 0
	
	local accScaleX = scaleX * self.scaleX
	local accScaleY = scaleY * self.scaleY
	
	local accX = x + self.x 
	local accY = y + self.y
	
	local accAngle = angle + self.angle	
	
	if((self.image ~= nil and not self.bird) and self.visible == true) then
		px, py = self.pivotX or px, self.pivotY or py
		local rotatePivotX, rotatePivotY = self.rotatePivotX or px, self.rotatePivotY or py
		if self.floorCoordinates then 
			accX = _G.math.floor(accX)	
			accY = _G.math.floor(accY)
		end
	
	
		if self.alpha == nil then
			gamelua.setRenderState(accX / accScaleX, accY / accScaleY, accScaleX, accScaleY, accAngle, rotatePivotX, rotatePivotY)
		else
			gamelua.setRenderState(accX / accScaleX, accY / accScaleY, accScaleX, accScaleY, accAngle, rotatePivotX, rotatePivotY, self.alpha)						
		end
		
		
		
		-- _G.res.drawSprite("", self.image, 0, 0,"HPIVOT","VPIVOT", _G.math.floor(self.w * scaleX) , _G.math.floor(self.h * scaleY) )
		_G.res.drawSprite("", self.image, 0, 0,"HPIVOT","VPIVOT", _G.math.floor(self.w) , _G.math.floor(self.h) )
		-- _G.res.drawSprite(self.image, 0, 0)
	elseif self.bird and self.visible == true then
		local extraScale =  0.6
		local hBird  =self.bird:getHatcheryBird()
		local pivotX,pivotY =  _G.res.getSpritePivot("",hBird.sprites[hBird.bodyIndex].sprite)
		local boundsX, boundsY =  _G.res.getSpriteBounds("",hBird.sprites[hBird.bodyIndex].sprite)
		local offsetY = (boundsY-pivotY) * extraScale *  hBird.sprites[hBird.bodyIndex].scale * accScaleY

		for i = 1, #hBird.sprites do
			local sprite = hBird.sprites[i]
		
		
			local finalX, finalY = accX /(accScaleX*extraScale*sprite.scale), accY /(accScaleY*extraScale*sprite.scale)
			finalX = finalX + sprite.x / sprite.scale
			finalY = finalY - offsetY / sprite.scale + sprite.y  / sprite.scale
			local finalScaleX, finalScaleY = accScaleX * extraScale * sprite.scale, accScaleY * extraScale * sprite.scale
			local finalAngle = accAngle + sprite.angle
			local pivotX,pivotY =  _G.res.getSpritePivot("",sprite.sprite)
			
			
			if self.floorCoordinates then 
				finalX = _G.math.floor(finalX)	
				finalY = _G.math.floor(finalY)
			end
			
			if self.alpha == nil then
				gamelua.setRenderState(finalX, finalY, finalScaleX, finalScaleY, finalAngle,pivotX, pivotY)
			else
				gamelua.setRenderState(finalX, finalY, finalScaleX, finalScaleY, finalAngle,pivotX, pivotY, self.alpha)						
			end
			
			
			
			-- _G.res.drawSprite("", self.image, 0, 0,"HPIVOT","VPIVOT", _G.math.floor(self.w * scaleX) , _G.math.floor(self.h * scaleY) )
			_G.res.drawSprite("", sprite.sprite, 0, 0,"HPIVOT","VPIVOT" )
		end
	end
	
	if self.alpha ~= nil then
		gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0, 1)	
	else
		gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
	end
end


function BirdButton:draw(x,y, scaleX, scaleY, angle)
	self:drawSelf(x, y, scaleX, scaleY, angle)
	
	Frame.draw(self,x,y, scaleX, scaleY, angle)	
end

filename="BirdButton.lua"
