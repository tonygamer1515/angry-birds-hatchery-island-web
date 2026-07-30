------------------------------------------
------  Dynamic size background box ------
------------------------------------------
BGBox = Frame:new()
function BGBox:init()
	self.x = 0
	self.y = 0
	self.width = 500
	self.height = 500
	-- Image components that create the visuals of this box
	self.components = { topLeft = "POPUP_TOP_LEFT", topMiddle = "POPUP_TOP_MIDDLE", topRight = "POPUP_TOP_RIGHT",
						left = "POPUP_LEFT", center = "POPUP_CENTER", right = "POPUP_RIGHT", 
     				    bottomLeft = "POPUP_BOTTOM_LEFT", bottomMiddle = "POPUP_BOTTOM_MIDDLE", bottomRight = "POPUP_BOTTOM_RIGHT" }
end



function BGBox:getTopBlockH()
	local w,h = _G.res.getSpriteBounds(self.components.topMiddle)
	return h
end

function BGBox:getBottomBlockH()
	local w,h = _G.res.getSpriteBounds(self.components.bottomMiddle)
	return h
end
	
function BGBox:getRightBlockW()
	local w,h = _G.res.getSpriteBounds(self.components.right)
	return w
end

function BGBox:getLeftBlockW()
	local w,h = _G.res.getSpriteBounds(self.components.left)
	return w
end


function BGBox:setSize(width,height)
	self.width = width
	self.height = height	
end



function BGBox:draw(x,y)
	gamelua.drawBox(
		self.components,
		nil,
		_G.math.floor(self.x + x),
		_G.math.floor(self.y + y),
		_G.math.floor(self.width),
		_G.math.floor(self.height),
		self.hanchor,
		self.vanchor,
		nil
	)
	
	gamelua.ui.Frame.draw(self, x, y)
end

filename="BGBox.lua"
