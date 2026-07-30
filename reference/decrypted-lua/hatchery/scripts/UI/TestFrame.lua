TestFrame = ui.Frame:new()
Frame = ui.Frame

function TestFrame:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_MEDIUM_TEMP")
	self:addChild(background)
	
	local dot = ui.Image:new()
	dot.name = "dot"
	dot.attach = "fixed"
	dot:setImage("BIRD_BEAK_RED_NORMAL")
	self:addChild(dot)
	
	
end

function TestFrame:layout()
	
	local background = self:getChild("background")
	background.x = 0
	background.y = 0
	
	local dot = self:getChild("dot")
	dot.x = 20
	dot.y = 20
	
	Frame.layout(self)	
	
end


filename="TestFrame.lua"
