HatcheryContextMenu = ui.Frame:new()
	
function HatcheryContextMenu:init()
	
	ui.Frame.init(self)
	
	self.buttonsOffsetY = 100
	--TODO: fix this hack
	if gamelua.deviceModel == "ipad" then
		self.buttonsOffsetY = 220
	elseif gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
		self.buttonsOffsetY = 100
	end
	
	local hurryButton = ui.ScallableButton:new()
	hurryButton.name = "hurry"
	hurryButton:setImage("H_BUTTON_HURRY")
	hurryButton.returnValue = hatcheryEvents.EID_HATCHERY_HURRY_BUTTON	
	self:addChild(hurryButton)
	hurryButton.visible = false
	-- hurryButton.sound = getHatcherySound("ok")
	hurryButton.sound = getHatcherySound("quickActionButton")
	hurryButton.activateOnRelease = true
	hurryButton:setupDefaultAnimationValues()		
	
	local select = ui.ScallableButton:new()
	select.name = "select"
	select:setImage("H_BUTTON_SLINGSHOT")
	select.returnValue = hatcheryEvents.EID_HATCHERY_BIRD_SELECTED_TO_INGAME	
	self:addChild(select)
	select.visible = false
	-- select.sound = getHatcherySound("ok")
	select.sound = getHatcherySound("quickActionButton")
	select.activateOnRelease = true
	select:setupDefaultAnimationValues()	

	local moveButton = ui.ScallableButton:new()
	moveButton.name = "move"
	moveButton:setImage("H_BUTTON_MOVE")
	moveButton.returnValue = hatcheryEvents.EID_HATCHERY_MOVE_BUTTON	
	self:addChild(moveButton)
	moveButton.visible = false
	-- moveButton.sound = getHatcherySound("ok")
	moveButton.sound = getHatcherySound("contextMenuMove")
	moveButton.activateOnRelease = true
	moveButton:setupDefaultAnimationValues()	
	
	local removeButton = ui.ScallableButton:new()
	removeButton.name = "remove"
	removeButton:setImage("H_BUTTON_DELETE")
	removeButton.returnValue = hatcheryEvents.EID_HATCHERY_REMOVE_BUTTON	
	self:addChild(removeButton)
	removeButton.visible = false
	-- moveButton.sound = getHatcherySound("ok")
	removeButton.sound = getHatcherySound("contextMenuMove")
	removeButton.activateOnRelease = true
	removeButton:setupDefaultAnimationValues()	
	
end

function HatcheryContextMenu:setWorldView(world)
	self.world = world
end

function HatcheryContextMenu:show()
	
	self.visible = true
end

function HatcheryContextMenu:hide()
	self.visible = false
end

--for now just static layouts. This should be later made so, that when state is set, all the visible buttons are layout to proper places etc.
function HatcheryContextMenu:layout()
	ui.Frame.layout(self)
	
	self.x = gamelua.screenWidth*0.93
	-- self.y = gamelua.screenHeight*0.82
	self.y = gamelua.screenHeight - self.buttonsOffsetY
	
	local w,h = _G.res.getSpriteBounds("H_BUTTON_MOVE")
	
	local hurryB = self:getChild("hurry")
	hurryB.x = 0--gamelua.screenWidth*0.9
	hurryB.y = 0--gamelua.screenHeight*0.78
	
	local select = self:getChild("select")
	select.x = 0
	select.y = 0
	
	
	local move = self:getChild("move")
	move.x = - w
	move.y = 0
	
	local remove = self:getChild("remove")
	remove.x = - 2*w
	remove.y = 0
end

function HatcheryContextMenu:setState(owner, params)
	self.owner = owner
	
	local lastElement = nil
	local w,h = _G.res.getSpriteBounds("H_BUTTON_MOVE")
	local px,py = _G.res.getSpritePivot("H_BUTTON_MOVE")
	
	local spacing = w * 0.1
	
	if params["selectBird"] == true then
		self:getChild("select").visible = true
		lastElement = self:getChild("select")
		lastElement.x = 0
	else
		self:getChild("select").visible = false
	end
	
	if params["hurry"] == true then
		local button = self:getChild("hurry")
		button.visible = true		
		
		if lastElement == nil then			
			button.x = 0
		else
			button.x = (lastElement.x - px) - spacing - w + px
		end
		
		lastElement = button
		
	else
		self:getChild("hurry").visible = false
	end
	
	if params["move"] == true then
		local button = self:getChild("move")
		button.visible = true		
		
		if lastElement == nil then			
			button.x = 0
			
		else
			button.x = (lastElement.x - px) - spacing - w + px
		end
		
		lastElement = button
	else
		self:getChild("move").visible = false
	end		
	
	if params["remove"] == true then
		local button = self:getChild("remove")
		button.visible = true		
		
		if lastElement == nil then									
			button.x = 0	
		else
			button.x = (lastElement.x - px) - spacing - w + px
		end
		
		lastElement = button
	else
		self:getChild("remove").visible = false
	end
	
	
	
	
end

function HatcheryContextMenu:getIndexInTable(list, element)
	local index = 1
	for k, v in _G.pairs(list) do 
		if element == v then
			return index
		end
		
		index = index + 1
	end
	
	return 0
end

function HatcheryContextMenu:getCurrentOwner()
	return self.owner
end

function HatcheryContextMenu:handleEvent(event, meta, element)
	if event == hatcheryEvents.EID_HATCHERY_HURRY then
		if self.owner then
			local cost = _G.math.floor(self.owner:getHurryCost())
			if self.world:canAfford(0,cost) == true then
				self.world:modifyStarCoins(-cost)
				self.owner:hurry()
				_G.res.playAudio(getHatcherySound("starCoinSpent"), 1, false)
			else
				self.world:openNotEnoughStarCoins()
			end
		end
	elseif event == hatcheryEvents.EID_HATCHERY_REMOVE_OBJECT then
		if self.owner then
			local cost = self.owner.removePrice or 0
			if self.world:canAfford(cost,0) == true then
				self.world:modifyStars(-cost)
				self.owner:startRemoving()
				_G.res.playAudio(getHatcherySound("starSpent"), 1, false)
			else
				self.world:openNotEnoughStars()
			end
		end
	
	end	
end


function HatcheryContextMenu:onPointerEvent(eventType,x,y)


	local result,meta, element = Frame.onPointerEvent(self, eventType,x, y)

	if result == hatcheryEvents.EID_HATCHERY_HURRY_BUTTON then
		if self.owner then
			local remainingtime = self.owner:getHurryCost()
			self.world:openCostConfirmationDialog(remainingtime, "Are you sure you want to hurry the process?", hatcheryEvents.EID_HATCHERY_HURRY, hatcheryEvents.EID_HATCHERY_GENERAL_CLOSE_POPUP, "H_BANK_ICON_COIN")
			
		end
	elseif result == hatcheryEvents.EID_HATCHERY_REMOVE_BUTTON then
		if self.owner then
			self.world:openCostConfirmationDialog(self.owner.removePrice, "Are you sure you want to remove the object?", hatcheryEvents.EID_HATCHERY_REMOVE_OBJECT, hatcheryEvents.EID_HATCHERY_GENERAL_CLOSE_POPUP, "H_BANK_ICON_STAR")
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BIRD_SELECTED_TO_INGAME	 then
		if self.owner then
			self.owner:selectedIngame()
		end
	end
	return result,meta,element
end
filename="hatcheryContextMenu.lua"
