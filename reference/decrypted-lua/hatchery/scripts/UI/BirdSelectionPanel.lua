BirdSelectionPanel = ui.Frame:new()
Frame = ui.Frame



function BirdSelectionPanel:init() 

	
	local inventoryBar = ui.CompoImage:new()
	inventoryBar.name = "InventoryBar"
	inventoryBar:setImage("H_BIRD_SWING")
	self:addChild(inventoryBar)
	
	for i=1,5 do
		local birdButton = ui.BirdButton:new()
		birdButton.name = "birdButton" .. i
		birdButton:setImage("")
		-- itemButton:setImage("H_PAINT_BUCKET_OFF_RED")
		birdButton.returnValue = -1
		birdButton:setup(1, 1, 0, ui.ScallableButton.TWEEN_TYPE.LINEAR)
		self:addChild(birdButton)
	end
	

	
	self.addedBirds = 0
	
	self.hiddenYPos = -300
	self.visibleYPos = 0
	self.totalAnimationTime = 0.5
	self.state = "HIDDEN"
	self.y = self.hiddenYPos
	
	

	
end




function BirdSelectionPanel:onEntry()
	ui.Frame.onEntry(self)
	-- self:scrollClosestItem()
	
	
end

 function BirdSelectionPanel:addBird(bird)
	if self.addedBirds > 4 then
		self.addedBirds = 0
	end
	
	
	
	local b = self:getChild("birdButton" .. (self.addedBirds+1))
	b:setBird(bird)
	self.addedBirds = self.addedBirds +1
 end




function BirdSelectionPanel:layout()


	--[[if self.state == "HIDDEN" then
		self.y = self.hiddenYPos
	elseif self.state == "VISIBLE" then
		self.y = self.visibleYPos
	end]]

	
	local swingY = 160
	
	local topBar = self:getChild("InventoryBar")
	topBar.x = gamelua.screenWidth*0.5
	topBar.y = 0
	local barW, barH, barPivX, barPivY = _G.res.getCompoSpriteBounds(topBar.image)
	--local swingX, swingY = _G.res.getSpritePivot("H_BIRD_SELECTOR_SWING")
	--local swingW, swingH = _G.res.getSpriteBounds("H_BIRD_SELECTOR_SWING")
	for i=1,5 do
		local birdButton = self:getChild("birdButton"..i)
		birdButton.x = topBar.x -450 + i*150
		birdButton.y = swingY
		
		--TODO: fix this hack
		if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4"  then
			local startX = topBar.x - 150
			birdButton.x = startX + (i - 1)*50
			birdButton.y = swingY - 95
			birdButton.scaleX = 0.5
			birdButton.scaleY = 0.5
		end
		
	end
	

	
end



function BirdSelectionPanel:onPointerEvent(eventType,x,y)

	local result,meta, element = nil, nil

	result,meta, element = Frame.onPointerEvent(self, eventType,x, y)
	


	return result, meta, element
end



function BirdSelectionPanel:update(dt, time) 
	
	
	

	for i,v in _G.ipairs(self.children) do
		if v.active == true then		
			v:update(dt,time)
		end
	end

	if self.state == "HIDDEN" then
		self.y = self.hiddenYPos

	elseif self.state == "VISIBLE" then
		self.y = self.visibleYPos

		
		--if gamelua.keyReleased["LBUTTON"] and gamelua.cursor.y > 250 then
	--		self:hide()
		--end
		
	elseif self.state == "SHOWING" then
		self.animationTime = self.animationTime + dt
		self.animationTime = _G.math.min(self.animationTime, self.totalAnimationTime)
		
		self.y = self:tweenEaseCubicOut(self.animationTime, self.animationStartY, self.animationEndY - self.animationStartY, self.totalAnimationTime)
		
		if self.animationTime == self.totalAnimationTime then
			self.state = "VISIBLE"
			
		end
		
	elseif self.state == "HIDING" then
		self.animationTime = self.animationTime + dt
		self.animationTime = _G.math.min(self.animationTime, self.totalAnimationTime)
		self.y = self:tweenEaseCubicIn(self.animationTime, self.animationStartY, self.animationEndY - self.animationStartY, self.totalAnimationTime)		
		
		if self.animationTime == self.totalAnimationTime then
			self.state = "HIDDEN"
			self.visible = false
			-- self:reset()
		end
		
	end
	
	
	
end


function BirdSelectionPanel:show()
	
	if self.state == "HIDDEN" then
		self.animationTime = 0
		self.animationEndY = self.visibleYPos
		self.animationStartY = self.hiddenYPos
		self.state = "SHOWING"
		self.visible = true
	elseif self.state == "HIDING" then
		self.animationTime = 0
		self.animationEndY = self.visibleYPos
		self.animationStartY = self.y
		self.state = "SHOWING"
	end
end

function BirdSelectionPanel:hide()
	if self.state == "VISIBLE" then
		self.animationTime = 0
		self.animationEndY = self.hiddenYPos
		self.animationStartY = self.visibleYPos
		self.state = "HIDING"
	elseif self.state == "SHOWING" then
		self.animationTime = 0
		self.animationEndY = self.hiddenYPos
		self.animationStartY = self.y
		self.state = "HIDING"
	end
	
end

function BirdSelectionPanel:isVisible()
	if self.state == "HIDDEN" or self.state == "HIDING" then
		return false
	else
		return true
	end	
end


function BirdSelectionPanel:draw(x,y, scaleX, scaleY, angle) 

	


	x = x or 0
	y = y or 0
	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	
	for i,v in _G.ipairs(self.children) do
		if v.visible == true then
			v:draw((x + self.x), (y + self.y), scaleX * self.scaleX, scaleY * self.scaleY, angle + self.angle)
		end
	end
end


function BirdSelectionPanel:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end


function BirdSelectionPanel:tweenEaseCubicIn(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d
	return c*(t)*t*t + b;
end

function BirdSelectionPanel:tweenEaseCubicOut(currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	t = t/d-1
	return c*((t)*t*t + 1) + b;
end


filename="BirdSelectionPanel.lua"
