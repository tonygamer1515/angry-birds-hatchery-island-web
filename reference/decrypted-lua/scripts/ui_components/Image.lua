
------------------------------
--------- Image --------------
------------------------------
Image = Frame:new()
function Image:init()
	self.visible = true
	self.angle = 0
	self.alpha = nil
	self.floorCoordinates = true
	self.scaleX = 1
	self.scaleY = 1
	self.rotatePivotX = 0
	self.rotatePivotY = 0	
end

function Image:setVisible(visible)
	self.visible = visible
end

function Image:setImage(image)
	self.image = image
	self.w, self.h = _G.res.getSpriteBounds(image)
	self.px, self.py = _G.res.getSpritePivot(self.image)
	self.rotatePivotX = self.px
	self.rotatePivotY = self.py
end

function Image:setSize(w,h)
	if w ~= nil then
		self.w = w	
	end
	
	if h ~= nil then
		self.h = h	
	end
end

function Image:drawSelf(x, y, scaleX, scaleY, angle)
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
	
	if(self.image ~= nil and self.visible == true) then
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
		
		
		
		-- _G.res.drawSprite("", self.image, 0, 0,"HPIVOT","VPIVOT", _G.math.floor(self.w * scaleX) , _G.math.floor(self.h * scaleY) )
		_G.res.drawSprite("", self.image, 0, 0,"HPIVOT","VPIVOT", _G.math.floor(self.w) , _G.math.floor(self.h) )
		-- _G.res.drawSprite(self.image, 0, 0)
	end
	
	if self.alpha ~= nil then
		gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0, 1)	
	else
		gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
	end
end

function Image:drawFast(x, y)
	_G.res.drawSprite(self.image, _G.math.floor(self.x + x), _G.math.floor(self.y + y))
end

function Image:draw(x,y, scaleX, scaleY, angle)
	self:drawSelf(x, y, scaleX, scaleY, angle)
	
	Frame.draw(self,x,y, scaleX, scaleY, angle)	
end

function Image:setAngle(angle)
	self.angle = angle
end

filename="Image.lua"
