Frame = gamelua.ui.Frame

MightyEagleButton = gamelua.ui.ImageButton:new()
EAGLE_BUTTON_SCALE_TIME = 4
--[[
elseif showEagleUIElements() and not self.previously_cleared and g_episodes[episode].mighty_eagle_disabled ~= true then
		if self.eagleAvailable then
			self:setEaglebuttonAvailable()
		else
			buttonRight:setImage("BUTTON_EAGLE_LOST", "BUTTON_EAGLE_LOST")
			local timerText = ui.Text:new({text = "", name = "timerText"})
			buttonRight:addChild(timerText)			
			buttonRight.returnValue = "MIGHTY_EAGLE_DISABLED"
		end
]]


function MightyEagleButton:init()
	Frame.init(self)	
	self:setImage("BUTTON_USE_EAGLE", "BUTTON_USE_EAGLE_DISABLED")
	
	local timerText = gamelua.ui.Text:new({text = "", name = "timerText"})
	self:addChild(timerText)
	self.timerText = timerText	
	
	self.timerText.hcenter = "HCENTER"
	self.timerText.vcenter = "VCENTER"
	
	self.result = "ME_BUTTON_CLICKED"
	self.from = self.from or "INGAME"
	self.disabledReturnValue = "ME_BUTTON_CLICKED_DISABLED"
	self.returnValue = "ME_BUTTON_CLICKED"
	self.eagleButtonState = nil
	
end

function MightyEagleButton:onEntry()

	if not gamelua.startedFromEditor then
		gamelua.eventManager:addEventListener(gamelua.events.EID_MIGHTY_EAGLE_AVAILABLE, self)
		gamelua.eventManager:addEventListener(gamelua.events.EID_LEVEL_GOALS_CLEARED, self)
		gamelua.eventManager:addEventListener(gamelua.events.EID_LEVEL_COMPLETE_INIT, self)
		--was this the first time this level was completed/has it been cleared previously?
		local first_time = true
			
		if gamelua.highscores[gamelua.levelName] and gamelua.highscores[gamelua.levelName].completed then
			first_time = false
		end
		
		self:setEnabled(not gamelua.isEagleUnavailableForShot() or not first_time)
		self:setVisible(true)
		
	else
		self:setEnabled(true)
		self:setVisible(true)
	end
	
	gamelua.ui.ImageButton.onEntry(self)

end

function MightyEagleButton:layout()
	local sx = 1
	local sy = 1
	
	if gamelua.isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end

	local w,h = _G.res.getSpriteBounds(self.image)
	self.timerText.x = 0
	self.timerText.y = h * 0.55 * sy
end

function MightyEagleButton:eventTriggered(event)
	if event.id == gamelua.events.EID_MIGHTY_EAGLE_AVAILABLE then
		self:setEnabled(true)
	elseif event.id == gamelua.events.EID_LEVEL_GOALS_CLEARED then
		self.inGameEagleButtonScalingTimer = 0
		self.eagleButtonState = "BOUNCE"
		if not gamelua.subsystemsapi.isEagleEnabled() then
			self:setVisible(false)
		end
		
	elseif event.id == gamelua.events.EID_LEVEL_COMPLETE_INIT then
		self.eagleButtonState = "DISAPPEAR"
		self.inGameEagleButtonScalingTimer = 1

		if not gamelua.subsystemsapi.isEagleEnabled() then
			self:setVisible(false)
		end
	end
end
----- 
function MightyEagleButton:onPointerEvent(eventType,x,y)
	local result, meta = gamelua.ui.ImageButton.onPointerEvent(self,eventType,x,y)
	
	if result == "ME_BUTTON_CLICKED_DISABLED" then
		self.showEagleTimeLeftTimer = 3		
		return -1
	end
	
	return result, meta
end

function MightyEagleButton:draw(x,y)
	if self.visible then
		gamelua.ui.ImageButton.draw(self,x,y)
		
		if self.timerText.visible == true then
			--self.timerText:draw(x + self.x,y + self.y)	
		end	
	end
end

function MightyEagleButton:setVisible(visible)
	local canBeVisible = gamelua.showEagleUIElements() == true and not gamelua.isEagleDisabled(gamelua.levelName) and not gamelua.eagleBaitLaunched
	
	if canBeVisible == true and visible == true then
		self.visible = true	
	else
		self.visible = false
	end
end

-----
function MightyEagleButton:update(dt,time)
	
	if not self.visible then
		return
	end
	
	
	if self.showEagleTimeLeftTimer ~= nil and gamelua.eagleLockedTime ~= nil and gamelua.settingsWrapper:getEagleUsedTime() ~= nil then
		self.timerText.visible = true
		
		local timeLeft = gamelua.eagleLockedTime - gamelua.timeDiff(gamelua.currentTime(), gamelua.settingsWrapper:getEagleUsedTime())		
		timeLeft = gamelua.formatTime(timeLeft)
		
		if self.timerText.text ~= timeLeft then
			self.timerText.text = timeLeft
			self.timerText:clip()
		end
		
		self.showEagleTimeLeftTimer = self.showEagleTimeLeftTimer - dt
		if self.showEagleTimeLeftTimer < 0 then
			self.showEagleTimeLeftTimer = nil
		end
	else
		self.timerText.visible = false	
	end

	if self.eagleButtonState ~= nil and self.inGameEagleButtonScalingTimer ~= nil then

		local scaleMultiplier = 1
		
		if gamelua.isRetinaGraphicsEnabled() then
			scaleMultiplier = 2			
		end
		
		if self.eagleButtonState == "BOUNCE" then
			self.inGameEagleButtonScalingTimer = self.inGameEagleButtonScalingTimer + dt			
			
			local scale = 0.75 + _G.math.cos(_G.math.pi * (self.inGameEagleButtonScalingTimer) * 2) * 0.25
			self.scaleX = scale * scaleMultiplier
			self.scaleY = scale * scaleMultiplier		
		else
			self.inGameEagleButtonScalingTimer = self.inGameEagleButtonScalingTimer - dt * 3
			self.scaleX = _G.math.max(self.inGameEagleButtonScalingTimer * scaleMultiplier, 0)
			self.scaleY = _G.math.max(self.inGameEagleButtonScalingTimer * scaleMultiplier, 0)
			
			if self.inGameEagleButtonScalingTimer < 0 then
				-- Done scaling!
				self.inGameEagleButtonScalingTimer = nil
				self.eagleButtonState = nil
				self:setVisible(false)
			end
		end
		
	end
end



function MightyEagleButton:onExit()
	if not gamelua.startedFromEditor then
		gamelua.eventManager:removeEventListener(gamelua.events.EID_MIGHTY_EAGLE_AVAILABLE, self)
		gamelua.eventManager:removeEventListener(gamelua.events.EID_LEVEL_GOALS_CLEARED, self)
		gamelua.eventManager:removeEventListener(gamelua.events.EID_LEVEL_COMPLETE_INIT, self)
	end	
	
	gamelua.ui.ImageButton.onExit(self)
	
end

filename="MightyEagleButton.lua"
