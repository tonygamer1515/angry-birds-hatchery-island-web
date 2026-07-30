TaskManager = {}

TaskManager.REWARD_TYPES = {XP = "XP", STAR="STAR", NEST = "NEST"}

TaskManager.TASK_TYPES = 	{	
							HATCH_ANY_BIRD="HATCH_ANY_KIND_OF_BIRD", 
							HATCH_BIRD_OF_COLOR="HATCH_BIRD_OF_COLOR", 
							HATCH_RARE_BIRD="HATCH_RARE_BIRD", 
							HATCH_SPECIFIC_BIRD="HATCH_SPECIFIC_BIRD", 
							ACCUMMULATE_STARS="ACCUMMULATE_STARS", 
							HATCH_BIRD_OF_GENDER="HATCH_BIRD_OF_GENDER", 
							HATCH_BIRD_WITH_ACCESSORY="HATCH_BIRD_WITH_ACCESSORY"
							}

--indexed by the player's level
TaskManager.TASKS = {	{	rewardType = TaskManager.REWARD_TYPES.STAR, rewardAmount = 50, unlockable = "H_NEST_BLUE",
							tasks = {	
										{text="Hatch a female bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_GENDER, amount=1, identifier="female"}, 
										{text="Hatch a male bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_GENDER, amount=1, identifier="male"}, 
										{text="Hatch a bird with a hat", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_WITH_ACCESSORY, amount=1, identifier=EggAccessory.TYPE.TOP}, 
									}
						},
						{	rewardType = TaskManager.REWARD_TYPES.STAR, rewardAmount = 100, unlockable = "H_NEST_YELLOW",
							tasks = {
										{text="Hatch a red bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.RED}, 
										{text="Hatch a yellow bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.YELLOW}, 
										{text="Hatch a black bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.BLACK}, 
									}
						},
						{	rewardType = TaskManager.REWARD_TYPES.STAR, rewardAmount = 150, unlockable = "H_NEST_BLACK",
							tasks = {
										{text="Hatch the Big Brother", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.BIGBROTHER}, 
										{text="Hatch a bird with glasses", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_WITH_ACCESSORY, amount = 1, identifier=Bird.SHAPE.MIDDLE}, 
										{text="Hatch a yellow bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount = 1, identifier=Bird.SHAPE.YELLOW},
									}
						},
						{	rewardType = TaskManager.REWARD_TYPES.STAR, rewardAmount = 200, unlockable = "H_NEST_WHITE",
							tasks = {
										{text="Hatch a white bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.WHITE}, 
										{text="Hatch a black bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.BLACK}, 
										{text="Hatch a green bird", taskType=TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR, amount=1, identifier=Bird.SHAPE.BIGBROTHER}, 
									}
						},
					}
	
function TaskManager:new(o)
	o = o or {}
	-- o.completedTasks = o.completedTasks or {}
	-- o.collectedTasks = o.collectedTasks or {}
	self.currentTask = 1
	self.listeners = {}
	self.totalCompletedTasks = 0
	_G.setmetatable(o, self)
	self.__index = self

	return o
end


function getTaskManagerInstance()
	if taskManagerInstance == nil then
		taskManagerInstance = TaskManager:new()
	end
	
	return taskManagerInstance
end

function TaskManager:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end 

-- function TaskManager:markTaskAsCompleted(task)
	-- if self:getIndexInTable(self.completedTasks, task) == 0 then
		-- _G.table.insert(self.completedTasks, task)
	-- end
-- end

function TaskManager:setHatchery(hatchery)
	self.hatchery = hatchery
end

-- function TaskManager:isTaskCompleted(task)
	-- return self:getIndexInTable(self.completedTasks, task) > 0
-- end


-- function TaskManager:isTaskCollected(task)
	-- return self:getIndexInTable(self.collectedTasks, task) > 0
-- end

function TaskManager:addListener(listener)
	
	if self:getIndexInTable(self.listeners, listener) == 0 then
		_G.table.insert(self.listeners, listener)
	end
end

--for birds-hatching-related tasks only
function TaskManager:increaseHatchBirdTaskCounter(birdType, birdID, gender, accessories)
	
	--we first checks for the most basic tasks, if their count should be increased we end the method, then we move on to the most specific
	
	
	for k, v in _G.pairs(self.taskCounter) do		
		local foundEntry = true
		if v.taskType == TaskManager.TASK_TYPES.HATCH_ANY_BIRD then
			if v.totalCompleted < v.amount then
				v.totalCompleted = v.totalCompleted + 1
				
				if v.totalCompleted >= v.amount then
					if self:areAllTasksCompleted() == false then
						self:taskCompleted(v)
					else
						self:allTasksCompleted(v)
					end
				end
				
				return
			end		
		end
	end	
	
	for k, v in _G.pairs(self.taskCounter) do		
		
		if v.taskType == TaskManager.TASK_TYPES.HATCH_BIRD_OF_COLOR then
			if v.totalCompleted < v.amount and v.identifier == birdType then
				v.totalCompleted = v.totalCompleted + 1
				
				if v.totalCompleted >= v.amount then
					if self:areAllTasksCompleted() == false then
						self:taskCompleted(v)
					else
						self:allTasksCompleted(v)
					end
				end
				
				return			
			end		
		end
	end	
	
	
	for k, v in _G.pairs(self.taskCounter) do		
		
		if v.taskType == TaskManager.TASK_TYPES.HATCH_RARE_BIRD then
			if v.totalCompleted < v.amount and self:isRareBird(birdID) then
				v.totalCompleted = v.totalCompleted + 1
				
				if v.totalCompleted >= v.amount then
					if self:areAllTasksCompleted() == false then
						self:taskCompleted(v)
					else
						self:allTasksCompleted(v)
					end
				end
				
				return		
				
			end		
		end
	end	
	
	
	for k, v in _G.pairs(self.taskCounter) do		
		
		if v.taskType == TaskManager.TASK_TYPES.HATCH_SPECIFIC_BIRD then
			if v.totalCompleted < v.amount and v.identifier == birdID then
				v.totalCompleted = v.totalCompleted + 1
				
				if v.totalCompleted >= v.amount then
					if self:areAllTasksCompleted() == false then
						self:taskCompleted(v)
					else
						self:allTasksCompleted(v)
					end
				end
				
				return		
				
			end		
		end
	end	
	
	for k, v in _G.pairs(self.taskCounter) do		
		
		if v.taskType == TaskManager.TASK_TYPES.HATCH_BIRD_OF_GENDER then
			if v.totalCompleted < v.amount and v.identifier == gender then
				v.totalCompleted = v.totalCompleted + 1
				
				if v.totalCompleted >= v.amount then
					if self:areAllTasksCompleted() == false then
						self:taskCompleted(v)
					else
						self:allTasksCompleted(v)
					end
				end
				
				return		
				
			end		
		end
	end	
	
	for k, v in _G.pairs(self.taskCounter) do		
		
		if v.taskType == TaskManager.TASK_TYPES.HATCH_BIRD_WITH_ACCESSORY then
		
			local hasAccessoryOfType = false
			for accessoryKey, accessory in _G.pairs(accessories) do
				
				if accessory:getType() == v.identifier then					
					hasAccessoryOfType = true
					break
				end
			end
				
			if v.totalCompleted < v.amount and  hasAccessoryOfType == true then
			
				
				v.totalCompleted = v.totalCompleted + 1
				
				if v.totalCompleted >= v.amount then
					if self:areAllTasksCompleted() == false then
						self:taskCompleted(v)
					else
						self:allTasksCompleted(v)
					end
				end
				
				return		
				
			end		
		end
	end	
	
	
end

function TaskManager:cheatCompleteNextAvailableTask()


	for k, v in _G.pairs(self.taskCounter) do		
		
		
		if v.totalCompleted < v.amount then
			v.totalCompleted = v.amount
			
			if v.totalCompleted >= v.amount then
				if self:areAllTasksCompleted() == false then
					self:taskCompleted(v)
				else
					self:allTasksCompleted(v)
				end
			end
			
			return		
			
		end		
		
	end	
end

function TaskManager:cheatCompleteAllTasks()

	local lastTask = nil
	for k, v in _G.pairs(self.taskCounter) do		
		local foundEntry = true
		
		v.totalCompleted = v.amount
		lastTask = v				
	end	
	
	self:allTasksCompleted(lastTask)
end


function TaskManager:isBirdRare(bird)
	return false
end

function TaskManager:areAllTasksCompleted()
	
	for k, v in _G.pairs(self.taskCounter) do
		if v.taskType == TaskManager.TASK_TYPES.ACCUMMULATE_STARS then
			if v.amount > self.hatchery:getStars() then
				return false
			end
		elseif v.totalCompleted < v.amount then
			return false
		end
	end		
	
	return true
end

function TaskManager:allTasksCompleted(lastTaskCompleted)
	for k,v in _G.pairs(self.listeners) do
		v:allTasksCompleted(TaskManager.TASKS[self.currentTask], lastTaskCompleted)
	end	
	
	self.totalCompletedTasks = self.totalCompletedTasks + 1
	
	self.totalCompletedTasks = _G.math.min(self.totalCompletedTasks, #TaskManager.TASKS)
end

function TaskManager:taskCompleted(task)
	for k,v in _G.pairs(self.listeners) do
		v:taskCompleted(task)
	end	
end

function TaskManager:setupTaskBasedOnPlayerLevel()
	self.currentTask = self.hatchery:getPlayerRank()
	
	if self.currentTask > #TaskManager.TASKS then
		self.currentTask = #TaskManager.TASKS
	else
		self:clearTaskCounter()
	end
end

function TaskManager:getCurrentTaskList()
	return self.taskCounter
end

function TaskManager:getCurrentUnlockable()
	return TaskManager.TASKS[self.currentTask].unlockable
end

function TaskManager:getCurrentTaskReward()
	return TaskManager.TASKS[self.currentTask].rewardAmount
end



function TaskManager:clearTaskCounter()
	self.taskCounter = {}
	
	-- gamelua.print("\n clearing " .. self.currentTask)
	
	for k, v in _G.pairs(TaskManager.TASKS[self.currentTask].tasks) do
		local newEntry = {}
		newEntry.text = v.text
		newEntry.taskType = v.taskType
		newEntry.amount = v.amount
		newEntry.identifier = v.identifier
		newEntry.totalCompleted = 0
		_G.table.insert(self.taskCounter, newEntry)
	end
	
end

function TaskManager:collectCurrentTaskReward()
	local task = TaskManager.TASKS[self.currentTask]
	
	
	if task.rewardType == TaskManager.REWARD_TYPES.XP then
		
		if self.hatchery == nil then
			gamelua.print("\n TaskManager: hatchery not set")
		else
			
		end
	
	elseif task.rewardType == TaskManager.REWARD_TYPES.STAR then
		if self.hatchery == nil then
			gamelua.print("\n TaskManager: hatchery not set")
		else
			self.hatchery:setStars(self.hatchery:getStars() + task.rewardAmount)
		end
	end
	
	-- self:clearTaskCounter()
		
	
end

function TaskManager:getNextTaskList()
	
	if self.currentTask < #TaskManager.TASKS then
		local taskCounter = {}
		
		for k, v in _G.pairs(TaskManager.TASKS[self.currentTask+1].tasks) do
			local newEntry = {}
			newEntry.text = v.text
			newEntry.taskType = v.taskType
			newEntry.amount = v.amount
			newEntry.identifier = v.identifier
			newEntry.totalCompleted = 0
			_G.table.insert(taskCounter, newEntry)
		end
		
		return taskCounter
	else
		return nil
	end
end


function TaskManager:getNextTaskListReward()
	
	if self.currentTask < #TaskManager.TASKS then
		return TaskManager.TASKS[self.currentTask+1].rewardAmount
	else
		return TaskManager.TASKS[self.currentTask].rewardAmount
	end
end

function TaskManager:getNextTaskListUnlockable()
	
	if self.currentTask < #TaskManager.TASKS then
		return TaskManager.TASKS[self.currentTask+1].unlockable
	else
		return TaskManager.TASKS[self.currentTask].unlockable
	end
end

function TaskManager:getTotalCompletedTasks()
	return self.totalCompletedTasks
	
end

filename="TaskManager.lua"
