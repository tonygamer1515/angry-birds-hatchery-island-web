
----- Frame -----

-- Frame is the root class and common api of all components

Frame = {}    
function Frame:new(o)
	o = o or {}
	o.children = {}
	o.x = o.x or 0
	o.y = o.y or 0
	o.scaleX = o.scaleX or 1
	o.scaleY = o.scaleY or 1
	o.angle = o.angle or 0
	o.name = o.name or "UNDEFINED"
	o.w = o.w or 0
	o.h = o.h or 0
	
	self.visible = self.visible or true
	self.active = self.active or true
	_G.setmetatable(o, self)
	self.__index = self
	o:init()
	return o
end

function Frame:addChild(child)
	_G.table.insert(self.children, child)
end

function Frame:removeAllChildren()
	self.children = {}
end

function Frame:removeChild(child)
	local removeIndex = nil
	local removedItem = nil
	for i,v in _G.ipairs(self.children) do
		if(self.children[i] == child) then
			removeIndex = i
		end
	end
	if(removeIndex ~= nil) then
		removedItem = self.children[removeIndex]
		_G.table.remove(self.children,removeIndex)	
	end
	return removedItem
end

function Frame:popChild()
	local removed_item = self.children[#self.children]
	_G.table.remove(self.children, #self.children)
	return removed_item
end


function Frame:init() 
end

function Frame:onEntry() 
	Frame.entryCounts = Frame.entryCounts or 0
	Frame.entryCounts = Frame.entryCounts + 1
	
	--gamelua.print("On Entry for : ".. _G.tostring(self.name))
	
	
	for k,v in _G.ipairs(self.children) do
		v:onEntry()
	end
end

function Frame:layout() 
	for k,v in _G.ipairs(self.children) do
		v:layout()
	end
end

-- TODO: this does not take x or y in account. just finds out biggest w and h
--[[
function Frame:getContentBounds()
	local maxW = self.w
	local maxH = self.h
	
	for i,v in _G.ipairs(self.children) do
		local cW, cH = v:getContentBounds()
		maxW,maxH = _G.math.max(maxW,cW), _G.math.max(maxH, cH)
	end
	
	return maxW,maxH	
end]]

function Frame:getChild(name)
	for  k,v in _G.ipairs(self.children) do
		if(v.name ~= nil and v.name == name) then
			return v
		end
	end

	for  k,v in _G.ipairs(self.children) do
		result = v:getChild(name)
		if(result ~= nil and result.name == name) then
			return result
		end
	end
	
	return nil
end

function Frame:onKeyEvent(eventType, key)
	for i = #self.children, 1,-1 do
		local child = self.children[i]		
		if child.visible == true and child.active == true then
			local result, meta, element = child:onKeyEvent(eventType, key)			
			if(result ~= nil) then 
				return result, meta, element
			end			
		end		
	end	
end


function Frame:onPointerEvent(eventType,x,y)
	for i = #self.children, 1,-1 do
		local child = self.children[i]
		
		if child.visible == true and child.active == true then			
			
			local result, meta, element = child:onPointerEvent(eventType,  x - self.x, y - self.y)
			
			if(result ~= nil) then 
				return result, meta, element
			end			
		end		
	end	
	return nil, nil, nil
end



function Frame:update(dt, time) 
	for i,v in _G.ipairs(self.children) do
		if v.active == true then		
			v:update(dt,time)
		end
	end
end


function Frame:draw(x,y, scaleX, scaleY, angle) 

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

function Frame:onExit() 
	Frame.entryCounts = Frame.entryCounts or 0
	Frame.entryCounts = Frame.entryCounts - 1
	
	for i,v in _G.ipairs(self.children) do
		v:onExit()
	end
end

filename="Frame.lua"
