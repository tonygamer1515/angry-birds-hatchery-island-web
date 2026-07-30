----------------------------------------------------------------
-- This is a template you can use as basis for your own frame --
----------------------------------------------------------------

TemplateFrame = ui.Frame:new()

-- create any child frame of this frame here
function TemplateFrame:init()
	ui.Frame.init(self)
end

-- setup any child frame of this frame here
function TemplateFrame:onEntry()
	ui.Frame.onEntry(self)
end

-- set layout parameters for all children of this frame here
function TemplateFrame:layout()
	ui.Frame.layout(self)
end

-- process any pointer events or results or merely forward those. 
function TemplateFrame:onPointerEvent(eventType,x,y)
	return ui.Frame.onPointerEvent(self,eventType,x,y)
end

function TemplateFrame:update(dt,time)
	ui.Frame.update(self,dt,time)
end


function TemplateFrame:draw(x,y)
	ui.Frame.draw(self,x,y)		
end

-- clean up frame and it's children on exit.
function TemplateFrame:onExit()
	ui.Frame.onExit(self)		
end
filename="templateFrame.lua"
