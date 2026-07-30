TaskEntryButton = ui.ScallableButton:new()
ScallableButton = ui.ScallableButton

function TaskEntryButton:init()
	ScallableButton.init(self)	
	
	
	self:setImage("H_TASK_BG")
	self.sound = getHatcherySound("cancel")	
	self.activateOnRelease = true
	
	local tick = ui.Image:new()
	tick.name = "tick"
	tick:setImage("H_TASK_CHECK")
	self:addChild(tick)
	tick.x = -145
	tick.visible = false
	
	local label = ui.Text:new()
	label.name = "label"
	label.font = "FONT_HATCHERY"
	label.text = ""
	label.hanchor = "LEFT"
	label.vanchor = self.vanchor or "VCENTER"
	self:addChild(label)
	label.scaleX = 0.5
	label.scaleY = 0.5
	label.x = - 100
	
	-- self:setupDefaultAnimationValues()
	
	
	
end


function TaskEntryButton:setAsAchieved(achieved)
	local tick = self:getChild("tick")
	local label = self:getChild("label")
	
	if achieved == true then
		-- self:setImage("H_TASK_ACHIEVED_BG")
		-- self.image = "H_TASK_ACHIEVED_BG"
		-- tick.y = -10
		-- label.y = -10
		tick.visible = true
	else
		-- self:setImage("H_TASK_BG")
		-- self.image = "H_TASK_BG"

		-- tick.y = 0
		-- label.y = 0
		tick.visible = false
	end
	
	-- self.w,self.h = _G.res.getSpriteBounds(self.image)
end

function TaskEntryButton:isMarkedAsAchieved()
	local tick = self:getChild("tick")
	return tick.visible
end

function TaskEntryButton:setText(text)
	local label = self:getChild("label")
	label.text = text
end


function TaskEntryButton:setEvent(event)
	self.returnValue = event		
end


filename="TaskEntryButton.lua"
