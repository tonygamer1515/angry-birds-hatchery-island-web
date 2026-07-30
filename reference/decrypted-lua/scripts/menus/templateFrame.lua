----------------------------------------------------------------
-- This is a template you can use as basis for your own frame --
----------------------------------------------------------------

TemplateFrame = ui.Frame:new()


function TemplateFrame:init()
	ui.Frame.init(self)
end


function TemplateFrame:onEntry()
	ui.Frame.onEntry(self)
end


function TemplateFrame:layout()
	ui.Frame.layout(self)
end

function TemplateFrame:onPointerEvent(eventType,x,y)
	return ui.Frame.onPointerEvent(self,eventType,x,y)
end

function TemplateFrame:update(dt,time)
	ui.Frame.update(self,dt,time)
end


function TemplateFrame:draw(x,y)
	ui.Frame.draw(self,x,y)		
end

function TemplateFrame:onExit()
	ui.Frame.onExit(self)		
end
filename="templateFrame.lua"
