TasksDialog = ui.Frame:new()
Frame = ui.Frame

function TasksDialog:init()
	Frame.init(self)	
	
	self.taskAnimationTotalTime = 0.5
	self.taskAnimationTotalDelayTime = 0.3	
	self.tickDelay = 0.3
	self.lastTickDelay = 0.5
	
	self.animationState = "idle"
	
	self.clippingX = -280
	self.listeners = {}
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_BIG_TEMP")
	self:addChild(background)
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_OK")
	cancelButton.returnValue = "CANCEL"
	cancelButton.sound = getHatcherySound("cancel")	
	cancelButton.activateOnRelease = true
	cancelButton:setupDefaultAnimationValues()
	self:addChild(cancelButton)
	
	local rewardBg = ui.Image:new()
	rewardBg.name = "rewardBg"
	rewardBg:setImage("H_TASK_REWARD_BG")
	self:addChild(rewardBg)
	
	local star = ui.Image:new()
	star.name = "star"
	star:setImage("H_STAR_SMALL")
	self:addChild(star)
	
	local starLabel = ui.Text:new()
	starLabel.name = "starLabel"
	starLabel.hanchor = "RIGHT"
	starLabel.vanchor = "VCENTER"
	starLabel.font = "FONT_HATCHERY"
	starLabel.scaleX = 0.5
	starLabel.scaleY = 0.5
	self:addChild(starLabel)
	
	local rewardImage = ui.Image:new()
	rewardImage.name = "rewardImage"
	rewardImage:setImage("")
	self:addChild(rewardImage)
	
	self.packages = {10, 50, 100, 500}
	self.lastClickedButton = nil
	
	
	-- for k,v in _G.pairs(self.packages) do 
		-- local packageButton = ui.ScallableButton:new()
		-- packageButton.name = "packageButton"..v
		-- packageButton:setImage("H_BTN_STARS_" .. v)
		-- packageButton.returnValue = "BUY"
		-- self:addChild(packageButton)
		-- packageButton.sound = getHatcherySound("starsBought")
		-- packageButton.activateOnRelease = true
	-- end
	
	
end


function TasksDialog:setEvents(eventCancel)
	-- local cancelButton = self:getChild("cancelButton")	
	-- cancelButton.returnValue = eventCancel		
	
	self.closeEvent = eventCancel
end

function TasksDialog:updateButtonsStates()
	
	for k,v in _G.pairs(self.tasks) do 
		local taskButton = self:getChild("taskButton" .. k)
		taskButton.enabled = false
		local isAchieved = v.totalCompleted >= v.amount
		taskButton:setAsAchieved(isAchieved)
		-- if isAchieved == true then
			-- taskButton.image = "H_TASK_ACHIEVED_BG"
		-- else
			-- taskButton.image = "H_TASK_BG"
		-- end
	end
	
end

function TasksDialog:setReward(reward)
	local starLabel = self:getChild("starLabel")
	starLabel.text = "+" .. reward
end

function TasksDialog:setUnlockable(unlockable)
	local rewardImage = self:getChild("rewardImage")
	rewardImage:setImage(unlockable)
end

function TasksDialog:setTasks(tasks)
	
	if self.tasks ~= nil then
		for k,v in _G.pairs(self.tasks) do 
			
			local taskButton = self:getChild("taskButton".. k)	
			
			self:removeChild(taskButton)			
		end
	end
	
	

	self.tasks = tasks
	
	for k,v in _G.pairs(self.tasks) do 
		-- local taskButton = ui.ScallableButton:new()		
		-- taskButton.name = "taskButton".. k
		-- taskButton:setImage("H_BTN_NEXT")		
		-- taskButton.returnValue = "TASK_CLICKED"	
		-- taskButton.sound = getHatcherySound("starsBought")
		-- taskButton.activateOnRelease = true
		-- taskButton.task = v		
		-- self:addChild(taskButton)
		
		local taskButton = TaskEntryButton:new()
		taskButton.name = "taskButton" .. k
		taskButton.enabled = true
		taskButton:setAsAchieved(false)
		taskButton:setText(v.text)
		taskButton.clippable = true
		self:addChild(taskButton)
		
		
		
	end	
	
	self:layout()
	
end

function TasksDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	
	--values found by experimenting
	local cancelButton = self:getChild("cancelButton")	
	
	-- cancelButton.y = (background.h * 0.4)
	cancelButton.y = 194
	
	
	-- local totalRows = 1
	-- local totalCols = 3
	local totalRows = 3
	local totalCols = 1
	--local startX = -(background.w * 0.2)
	local startX = -80
	--local startY = -(background.h * 0.1)
	-- local startY = -65
	local startY = -100
	-- local spacingX = 250
	local spacingX = 242
	-- local spacingY = 100
	local spacingY = 70
	
	local index = 0
	for k,v in _G.pairs(self.tasks) do 
		local taskButton = self:getChild("taskButton".. k)	
		
		local rowIndex = _G.math.floor(index / totalCols)
		local colIndex = _G.math.fmod(index, totalCols)
		
		taskButton.x = startX + (colIndex * spacingX)
		taskButton.y = startY + (rowIndex * spacingY)
		
		index = index +1
	end
	
	
	
	local rewardBg = self:getChild("rewardBg")
	rewardBg.x = 200
	rewardBg.y = -20
	
	local starCountPosY = - 90
	local starCountSpacingX = 10
	
	local starLabel = self:getChild("starLabel")
	local star = self:getChild("star")
	
	gamelua.setFont(starLabel.font)
	local textWidth = _G.res.getStringWidth(starLabel.text) * starLabel.scaleX
	
	local starPX, starPY = _G.res.getSpritePivot("", star.image)
	local totalWidth = textWidth + starCountSpacingX + star.w
	
	star.x = rewardBg.x + totalWidth * 0.5 - (star.w - starPX)
	star.y = starCountPosY
	
	starLabel.x = star.x - starPX - starCountSpacingX
	starLabel.y = star.y
	
	local rewardImage = self:getChild("rewardImage")
	rewardImage.x = rewardBg.x
	rewardImage.y = rewardBg.h * 0.03
	rewardImage.scaleX = 0.25
	rewardImage.scaleY = 0.25
	
end

function TasksDialog:startAllTasksCompletedAnimations(lastCompletedTask)

	self.animationState = "tick"
	self.needsNotifyListeners = true

	-- self.lastTaskButtonToBeCompleted = nil
	self.buttonsAnimationTimes = {}
	self.buttonsAnimationStartX = {}
	self.buttonsAnimationEndX = {}
	
	self.buttonsAnimationTickTimes = {}
	
	local counter = 1
	for k,v in _G.pairs(self.tasks) do 
		local button = self:getChild("taskButton".. k)	
		
		if v == lastCompletedTask then
			-- self.lastTaskButtonToBeCompleted = button	
			button:setAsAchieved(false)
		end		
		
		button:setAsAchieved(false)
		
		
		
		-- -1 indicates we can't animate this button yet
		self.buttonsAnimationTimes[button.name] = -1
		self.buttonsAnimationTickTimes[button.name] = -1
		
		if counter == 1 then
			self.currentAnimatingButton = button.name
			self.buttonsAnimationTimes[button.name] = 0	
			self.buttonsAnimationTickTimes[button.name] = 0
		end
		
		self.buttonsAnimationStartX[button.name] = button.x
		self.buttonsAnimationEndX[button.name] = -gamelua.screenWidth * 0.5  - 200
		
		counter = counter + 1
	end
	
	self.lastTaskTickTime = 0
	self.newTasksBroughtIn = false
			
end

function TasksDialog:bringInNewTasks()
	
	self.buttonsAnimationTimes = {}
	self.buttonsAnimationStartX = {}
	self.buttonsAnimationEndX = {}
	
	self:setReward(self.nextReward)
	self:setUnlockable(self.nextUnlockable)
	
	self:setTasks(self.nextTaskList)
	
	local counter = 1
	for k,v in _G.pairs(self.tasks) do 
		local button = self:getChild("taskButton".. k)					
		
		-- -1 indicates we can't animate this button yet
		self.buttonsAnimationTimes[button.name] = -1
		
		if counter == 1 then
			self.currentAnimatingButton = button.name
			self.buttonsAnimationTimes[button.name] = 0			
		end
		
		local oldButtonX = button.x
		
		self.buttonsAnimationStartX[button.name] = -gamelua.screenWidth * 0.5  - 200
		self.buttonsAnimationEndX[button.name] = oldButtonX
		
		button.x = self.buttonsAnimationStartX[button.name]
		
		-- this only means we still have an animation to do, the button won't be ticked
		-- self.lastTaskButtonToBeCompleted = button
		
		
		counter = counter + 1
	end
	
	--this only means we still have an animation to do, the button won't be ticked
	self.lastTaskTickTime = nil
			
end

function TasksDialog:update(dt, time) 
	Frame.update(self, dt, time) 	

	-- gamelua.print("\n task dialog update")	
	
	if self.animationState == "tick" then
		self:updateTickAnimations(dt, time)
	elseif self.animationState == "slide" then
		self:updateSlideAnimations(dt, time)
	end				
	
end

function TasksDialog:updateTickAnimations(dt, time) 
	-- gamelua.print("\n updateing tick")
	if self.tickRestTime == nil then
	
		local count = 1
	
		for k, v in _G.pairs(self.tasks) do
			local button = self:getChild("taskButton".. k)
			local nextButton = nil
			
			if count < #self.tasks  then
				nextButton = self:getChild("taskButton".. k + 1)
			end
			
			if self.buttonsAnimationTickTimes[button.name] > -1 then
				self.buttonsAnimationTickTimes[button.name] = self.buttonsAnimationTickTimes[button.name] + dt
				
				if self.buttonsAnimationTickTimes[button.name] > self.tickDelay and button:isMarkedAsAchieved() == false then
					button:setAsAchieved(true)
					
					_G.res.playAudio(getHatcherySound("taskNotificationCheck"), 1, false)
					
					if nextButton ~= nil then
						self.buttonsAnimationTickTimes[nextButton.name] = 0
					else
					
						if getTaskManagerInstance():getTotalCompletedTasks() == (#TaskManager.TASKS) then
							self.animationState = "idle"
						else
							self.tickRestTime = 0
							
							self.nextTaskList = getTaskManagerInstance():getNextTaskList()
							
							self.nextReward = getTaskManagerInstance():getNextTaskListReward()
							self.nextUnlockable = getTaskManagerInstance():getNextTaskListUnlockable()
							
							for k, v in _G.pairs(self.listeners) do
								v:taskScreenTickAnimationFinished()
							end
							
							self.needsNotifyListeners = false
						end
						
					end
				end					
					
			end						
			
		end
	else
		self.tickRestTime = self.tickRestTime + dt
		
		if self.tickRestTime >= self.lastTickDelay then
			self.animationState = "slide"
			self.tickRestTime = nil
		end
	end
end

function TasksDialog:updateSlideAnimations(dt, time)
	--animates tasks scrolling in or out of view
	local count = 1
	for k, v in _G.pairs(self.tasks) do
		local button = self:getChild("taskButton".. k)
		local nextButton = nil
		
		if count < #self.tasks  then
			nextButton = self:getChild("taskButton".. k + 1)
		end
		
		if self.buttonsAnimationTimes[button.name] > -1 then
		
			--play the sound only once (when animation has just started)
			if self.buttonsAnimationTimes[button.name] == 0 then
				if self.newTasksBroughtIn == false then
					_G.res.playAudio(getHatcherySound("taskScreenEntryRemoved"), 1, false)
				else
					_G.res.playAudio(getHatcherySound("taskScreenEntryAdded"), 1, false)
				end
			end
			
			self.buttonsAnimationTimes[button.name] = self.buttonsAnimationTimes[button.name] + dt
			
			if self.buttonsAnimationTimes[button.name] > self.taskAnimationTotalDelayTime and nextButton ~= nil and self.buttonsAnimationTimes[nextButton.name] == -1 then
				self.buttonsAnimationTimes[nextButton.name] = 0					
			end
			
			self.buttonsAnimationTimes[button.name] = _G.math.min(self.buttonsAnimationTimes[button.name], self.taskAnimationTotalTime)
			
			
			if self.newTasksBroughtIn == false then
				button.x = self:tweenEaseCubicIn(	self.buttonsAnimationTimes[button.name], 
													self.buttonsAnimationStartX[button.name], 
													self.buttonsAnimationEndX[button.name] - self.buttonsAnimationStartX[button.name],
													self.taskAnimationTotalTime)
			else
				button.x = self:tweenEaseCubicOut(	self.buttonsAnimationTimes[button.name], 
													self.buttonsAnimationStartX[button.name], 
													self.buttonsAnimationEndX[button.name] - self.buttonsAnimationStartX[button.name],
													self.taskAnimationTotalTime)
			end
			
			if self.buttonsAnimationTimes[button.name] == self.taskAnimationTotalTime and count == #self.tasks then
				
				
				
				if self.newTasksBroughtIn == false then
					
					self:bringInNewTasks()
					self.newTasksBroughtIn = true
				else
					self.animationState = "idle"
				end
			end
		end						
		
		count = count  + 1
	end
end

function TasksDialog:updateSlideInAnimations(dt, time)

end

function TasksDialog:draw(x,y, scaleX, scaleY, angle) 
	

	x = x or 0
	y = y or 0
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	
	
	for k,v in _G.pairs(self.children) do
		if v.visible == true then
			if v.clippable == true then
				_G.res.setClipRect(self.x + self.clippingX, 0, gamelua.screenWidth, gamelua.screenHeight)
			end
			v:draw((x + self.x), (y + self.y), scaleX * self.scaleX, scaleY * self.scaleY, angle + self.angle)
			if v.clippable == true then
				_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
			end
		end
	end
	

end

--the listeners wil receive a callback when they are suppose to level up the player and update counters
function TasksDialog:addListener(listener)
	
	_G.table.insert(self.listeners, listener)
end

-- function TasksDialog:tweenLinear (currentTime, startValue, changeOfValue, duration)
	-- local c = changeOfValue
	-- local t = currentTime
	-- local d = duration
	-- local b = startValue
	-- return c*t/d + b;
-- end

function TasksDialog:tweenEaseCubicIn(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d
	return c*(t)*t*t + b;
end

function TasksDialog:tweenEaseCubicOut(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d-1
	return c*((t)*t*t + 1) + b;
end



function TasksDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == "CANCEL" then
		if self.needsNotifyListeners == true then
			for k, v in _G.pairs(self.listeners) do
				v:taskScreenTickAnimationFinished()
			end
			
			self.needsNotifyListeners = false
		end
		return self.closeEvent, meta
	end
end

filename="TasksDialog.lua"
