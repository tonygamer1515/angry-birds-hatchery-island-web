NestFillBar = ui.Frame:new()
Frame = ui.Frame

function NestFillBar:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_PROGRESS_BAR_BG")
	self:addChild(background)
	
	local fill = ui.Image:new()
	fill.name = "fill"
	fill.attach = "fixed"
	fill:setImage("H_PROGRESS_BAR")
	self:addChild(fill)
	
	self.percentage = 0
	
	
	
end

function NestFillBar:draw(x, y)
	
	local fill = self:getChild("fill")		
	fill.visible = false
	
	ui.Frame.draw(self, x, y)

	fill.visible = true
	
	local fillPivotX, fillPivotY = _G.res.getSpritePivot("", fill.image)
	
	local newX = x + self.x
	local newY = y + self.y
	_G.res.setClipRect(newX - fillPivotX, 0, self.percentage * fill.w, gamelua.screenHeight)
	fill:draw(newX, newY)

	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
end


function NestFillBar:setPercentage(percentage)
	self.percentage = percentage
end

function NestFillBar:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	background.x = 0
	background.y = 0
	
	local fill = self:getChild("fill")	
	fill.x = 0
	fill.y = 0
	
	
	
end

filename="NestFillBar.lua"
