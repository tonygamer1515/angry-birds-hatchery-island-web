MenuManager = {}
function MenuManager:new(o)
	o = o or {}
	_G.setmetatable(o, self)
	self.__index = self
	self.links = {}
	self.currentRoot = nil
	self.screenWidth = screenWidth
	self.screenHeight = screenHeight
	self.queudRoot = nil
	self.allowInput = true
	self.updateEnabled = true
	-- on Android when fullscreen ad is shown, back clicks should be disabled
	self.delegateBackClicks = true

	return o
end

function MenuManager:eventTriggered(event)
	_G.assert (event ~= nil, "event was nil in eventTriggered")
	if(event.id == gamelua.events.EID_CHANGE_SCENE) then
		_G.assert(event.target ~= nil, "no target for event")
		self.delegateBackClicks = true

		if _G.type(event.target) == "table" then
			self:changeRoot(event.target)
		else
			self:handleResult(event.target)
		end
	end
	

	
	if event.id == gamelua.events.EID_PUSH_FRAME then
		local frame
		local targetRoot = self.queudRoot or self.currentRoot
		
		if _G.type(event.target) == "string" then
			frame = self.links[event.target].instance
		else
			frame = event.target
		end
		
		gamelua.eventManager:notify({id = gamelua.events.EID_FRAME_PUSHED, frame = frame})
		targetRoot:addChild(frame)
		
		-- if root is queued, then it will onEntry and layout at start of next update
		-- if not, do it here.
		if(targetRoot ~= self.queudRoot) then
			
			frame:onEntry()
			frame:layout()		
		end
	end
	
	if event.id == gamelua.events.EID_POP_FRAME then
		self:popFrame()
	end	
end

function MenuManager:popFrame()
	local targetRoot = self.currentRoot or self.queudRoot
	local popped_frame = targetRoot:popChild()
	popped_frame:onExit()
	return popped_frame
end

function MenuManager:addLink(action, menu, ...)
	self.links[action] = { type = "link", instance = menu, }
end

function MenuManager:getLink(action)
	if self.links[action] then
		return self.links[action].instance
	end
	return nil
end

function MenuManager:handleResult(result, meta)
	local link = self.links[result]

	if link.type == "link" then
		self:changeRoot(link.instance)
	end	
end

function MenuManager:setRootVisible(visible)
	local root = self.currentRoot or self.queudRoot
	_G.assert(root ~= nil, "no root to set visible")
	
	
	root.visible = true
end

function MenuManager:deactivate()
	self:changeRoot(nil)
end

function MenuManager:getRoot()	
	local root =  self.currentRoot or self.queudRoot
	_G.assert(root ~= nil, " Root is nil ")
	return root
end

-- private --
function MenuManager:setRoot(root)
	self.currentRoot = root
	if root ~= nil then
		-- This check is done to ensure that API is used correctly.
		-- We might register / unregister listeners in onEntry / onExit functions, 
		-- and we need to be sure all onEntry / onExit pairs are invoked. ( counter should be 0 )
		--[[if gamelua.ui.Frame.entryCounts ~= nil then
			_G.assert(gamelua.ui.Frame.entryCounts == 0, " Mismatch in onEntry / onExit counts upon changing scene ")		
		end]]		
		self.currentRoot:onEntry()
		self.currentRoot:layout()
		gamelua.eventManager:notify({id = gamelua.events.EID_MENUMANAGER_ROOT_CHANGED, root = root})
	end
end

function MenuManager:changeRoot(root)
	if(root == nil) then
		if(self.currentRoot ~= nil) then
			self.currentRoot:onExit()
		end
		self.currentRoot = nil
	end
	
	self.queudRoot = root
end

function MenuManager:isMenuActive()
	return self.currentRoot ~= nil
end

function MenuManager:gameResumed()
	if self.currentRoot ~= nil then
		self.currentRoot:layout()
	end
end

function MenuManager:update(dt, time)
	if not self.updateEnabled then 
		return 
	end

	local sceneChanged = false
	
	if(self.queudRoot ~= nil) then
		if(self.currentRoot ~= nil) then
			self.currentRoot:onExit()
			self.currentRoot = nil
		end
	
		self:setRoot(self.queudRoot)
		self.queudRoot = nil
		sceneChanged = true
	end

	
	if self.currentRoot ~= nil then
	
		if self.screenWidth ~= gamelua.screenWidth or self.screenHeight ~= gamelua.screenHeight then
			self.currentRoot:layout()
			self.screenWidth = gamelua.screenWidth
			self.screenHeight = gamelua.screenHeight
		end
		
		self.currentRoot:update(dt, time)
	
		if not sceneChanged then
			self:delegateClicks()
			self:delegateKeyEvents()
		end
		
		-- TODO: this is a hack and should be removed
		if self.currentRoot ~= nil then		
			local bg = self.currentRoot.backgroundColour
			if bg then
				if sceneChanged then
					gamelua.drawRect(bg.r / 255, bg.g / 255, bg.b / 255, bg.a / 255, 0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
				end				
			end			
		end
	end	
end

function MenuManager:draw()	
	
	if self.currentRoot ~= nil then
	
		local bg = self.currentRoot.backgroundColour
		if bg then			
			gamelua.setBGColor(bg.r, bg.g, bg.b)
		end
		
		self.currentRoot:draw(0, 0)
	end			
end

function MenuManager:setAllowInput(allowInput)
	self.allowInput = allowInput
end
-- this is used at least in facebook connect to gain performance
function MenuManager:setUpdateEnabled(enabled)
	self.updateEnabled = enabled
end

function MenuManager:delegateKeyEvents()
	if self.allowInput and self.delegateBackClicks then
		if self.currentRoot ~= nil then

			if gamelua.keyReleased["KEY_BACK"] then
				self.currentRoot:onKeyEvent("RELEASE", "BACK")
			end
			
			if gamelua.keyReleased["RETURN"] then
				self.currentRoot:onKeyEvent("RELEASE", "RETURN")
			end
			
			
			if gamelua.keyReleased["ESCAPE"] then
				self.currentRoot:onKeyEvent("RELEASE", "ESCAPE")
			end		
		end
	end
end	

function MenuManager:delegateClicks()
	if self.allowInput then
		if gamelua.keyPressed["LBUTTON"] and self.currentRoot ~= nil then
			local result, meta = self.currentRoot:onPointerEvent("LPRESS", gamelua.cursor.x, gamelua.cursor.y)
		end
		
		if gamelua.keyHold["LBUTTON"] and self.currentRoot ~= nil then 
			local result, meta = self.currentRoot:onPointerEvent("LHOLD", gamelua.cursor.x, gamelua.cursor.y)
		end
		
		if gamelua.keyReleased["LBUTTON"] and self.currentRoot ~= nil then
			local result, meta = self.currentRoot:onPointerEvent("LRELEASE", gamelua.cursor.x, gamelua.cursor.y)
		end
		
		--[[	
		if gamelua.keyReleased["KEY_BACK"] or gamelua.keyReleased["ESCAPE"] and self.currentRoot ~= nil then
			local result, meta = self.currentRoot:onPointerEvent("BACK", -1, -1)
		end
		]]
		
	end
end

filename="MenuManager.lua"
