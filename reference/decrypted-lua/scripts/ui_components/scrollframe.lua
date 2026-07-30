ScrollFrame = Frame:new()

function ScrollFrame:init()
	self.scrollX = 0
	self.scrollY = 0
	self.anchors = { { 0, 0 }, { 0, 0 } }
	
	self.currentAnchor = 1
	self.scrollingToAnchor = nil
	self.scrollDirection = "x"
	
	self.state = "RELEASED"
	
	Frame.init(self)
end

function ScrollFrame:onEntry()

	self.scrollingToAnchor = nil
	self.state = "RELEASED"
	self.dragStartX = nil
	self.dragStartY = nil

	Frame.onEntry(self)
end

function ScrollFrame:setAnchors(anchors)
	self.anchors = {}
	for i = 1, anchors do
		self.anchors[i] = { anchors[i][1], anchors[i][2] }
	end
end

function ScrollFrame:setCurrentAnchor(anchor)
	self.currentAnchor = anchor
	self.scrollX = self.anchors[anchor][1]
	self.scrollY = self.anchors[anchor][2]
	self.state = "RELEASED"
	self.dragStartX = nil
	self.dragStartY = nil
end

function ScrollFrame:scrollToAnchor(anchor)
	self.state = "AUTOSCROLLING"
	self.scrollingToAnchor = anchor
end

function ScrollFrame:getCurrentAnchor(anchor)
	return self.currentAnchor
end

function ScrollFrame:getCurrentX()
	return self.scrollX
end

function ScrollFrame:getCurrentY()
	return self.scrollY
end

function ScrollFrame:doUpdate(dt, time)
	local nearestAnchor = 0
	local nearestDistance = _G.math.huge
	local anchors = self.anchors
	local scrollX = self.scrollX
	local scrollY = self.scrollY
	local state = self.state
	
	for i = 1, #anchors do
		local distance
		if self.scrollDirection == "x" then
			distance = _G.math.abs(anchors[i][1] - scrollX)
		elseif self.scrollDirection == "y" then
			distance = _G.math.abs(anchors[i][2] - scrollY)
		end
		if distance < nearestDistance then
			nearestAnchor = i
			nearestDistance = distance
		end
	end
	
	--print("x: " .. self.scrollX .. " nearest: " .. nearestAnchor .. " @ " .. self.anchors[nearestAnchor][1] .. " dist: " .. nearestDistance .. "\n")

	if state == "RELEASED" or state == "FLICKED" or state == "AUTOSCROLLING" then
		local target_anchor = nearestAnchor
		if state == "FLICKED" or state == "AUTOSCROLLING" then
			target_anchor = self.scrollingToAnchor
		end
		if self.scrollDirection == "x" then
			local dx = (anchors[target_anchor][1] - scrollX) * 8 * dt
			scrollX = scrollX + dx
			if _G.math.abs(anchors[target_anchor][1] - scrollX) < 0.5 then
				scrollX = anchors[target_anchor][1]
			end
		elseif self.scrollDirection == "y" then
			local dy = (anchors[target_anchor][2] - scrollY) * 8 * dt
			scrollY = scrollY + dy
			if _G.math.abs(anchors[target_anchor][2] - scrollY) < 0.5 then
				scrollY = anchors[target_anchor][2]
			end
		end
	elseif state == "DRAGGING" then
		if self.scrollDirection == "x" then
			if scrollX <= anchors[1][1] and scrollX >= anchors[#anchors][1] then
				scrollX = scrollX + (gamelua.cursor.x - self.dragLastX)
			elseif scrollX > anchors[1][1] then
				local slowdown = 1 + (_G.math.abs(scrollX - anchors[1][1]) / (gamelua.screenWidth * 0.2))
				scrollX = scrollX + (gamelua.cursor.x - self.dragLastX) / slowdown
			elseif scrollX < anchors[#anchors][1] then
				local slowdown = 1 + (_G.math.abs(scrollX - anchors[#anchors][1]) / (gamelua.screenWidth * 0.2))
				scrollX = scrollX + (gamelua.cursor.x - self.dragLastX) / slowdown
			end
		elseif self.scrollDirection == "y" then
			scrollY = scrollY + (gamelua.cursor.y - self.dragLastY)
		end
	end
	
	if self.scrollDirection == "x" then
		if _G.math.abs(anchors[nearestAnchor][1] - scrollX) < 0.05 * gamelua.screenWidth then
			self.currentAnchor = nearestAnchor
			if self.scrollingToAnchor == self.currentAnchor then
				self.scrollingToAnchor = nil
				state = "RELEASED"
			end
		end
	elseif self.scrollDirection == "y" then
		if _G.math.abs(anchors[nearestAnchor][2] - scrollY) < 0.05 * gamelua.screenHeight then
			self.currentAnchor = nearestAnchor
			if self.scrollingToAnchor == self.currentAnchor then
				self.scrollingToAnchor = nil
				state = "RELEASED"
			end
		end
	end
	
	self.anchors = anchors
	self.scrollX = scrollX
	self.scrollY = scrollY
	self.state = state
end

function ScrollFrame:update(dt, time)
	self:doUpdate(dt, time)

	Frame.update(self, dt, time)
end

function ScrollFrame:draw(x, y)
	local clip = self.clip
	
	if(clip ~= nil) then
		_G.res.setClipRect(x, y, clip.clipW, clip.clipH)
	end
	Frame.draw(self, _G.math.floor(self.scrollX + x), _G.math.floor(self.scrollY + y))
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
end

function ScrollFrame:onPointerEvent(eventType, x, y)
	local result, meta, element = Frame.onPointerEvent(self, eventType, x - self.scrollX, y - self.scrollY)
	
	if self.scrollingToAnchor == nil then
		if eventType == "LPRESS" then
			self.state = "DRAGGING"
			self.dragStartX = gamelua.cursor.x
			self.dragStartY = gamelua.cursor.y
			self.dragLastX = gamelua.cursor.x
			self.dragLastY = gamelua.cursor.y
		elseif eventType == "LHOLD" then
			self.state = "DRAGGING"
			if self.dragStartX == nil or self.dragStartY == nil then
				self.dragStartX = gamelua.cursor.x
				self.dragStartY = gamelua.cursor.y
			end
			self.dragLastX = gamelua.cursor.x
			self.dragLastY = gamelua.cursor.y
		elseif eventType == "LRELEASE" then
			self.state = "RELEASED"
			local tap_radius = gamelua.screenWidth * 0.03125
			if self.scrollDirection == "x" and self.dragStartX ~= nil then
				if _G.math.abs(gamelua.cursor.x - self.dragStartX) > tap_radius then
					result = nil
					meta = nil
					self:flick()
				end
			elseif self.scrollDirection == "y" then
			
			end
			self.dragStartX = nil
			self.dragStartY = nil
		end
	end
	
	return result, meta, element
end

function ScrollFrame:flick()

	local nearestAnchor = 0
	local nearestDistance = _G.math.huge
	for i = 1, #self.anchors do
		local distance
		if self.scrollDirection == "x" then
			distance = _G.math.abs(self.anchors[i][1] - self.scrollX)
		elseif self.scrollDirection == "y" then
			distance = _G.math.abs(self.anchors[i][2] - self.scrollY)
		end
		
		local shortest_distance = false
		local correct_direction = false
		
		shortest_distance = distance < nearestDistance and i ~= self.currentAnchor
		if self.scrollDirection == "x" then
			if gamelua.cursor.x > self.dragStartX then
				--print("left  flick test... " .. self.anchors[i][1] .. " > " .. self.dragStartX + self.scrollX - screenWidth * 0.5 .. "\n")
				correct_direction = self.anchors[i][1] > self.dragStartX + self.scrollX - gamelua.screenWidth * 0.5
			elseif gamelua.cursor.x < self.dragStartX then
				--print("right flick test... " .. self.anchors[i][1] .. " < " .. self.dragStartX + self.scrollX - screenWidth * 0.5 .. "\n")
				correct_direction = self.anchors[i][1] < self.dragStartX + self.scrollX - gamelua.screenWidth * 0.5
			end
		elseif self.scrollDirection == "y" then
		
		end
		
		if shortest_distance and correct_direction then
			nearestAnchor = i
			nearestDistance = distance
		end
	end

	if nearestAnchor ~= 0 then
		self.scrollingToAnchor = nearestAnchor
		self.state = "FLICKED"
	end
end

filename="scrollframe.lua"
