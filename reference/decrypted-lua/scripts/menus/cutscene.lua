CutScene = ui.Frame:new()

function CutScene:new(cutscene, end_event, o)
	local o = o or {}
	o.cutscene = cutscene
	o.data = cutscenes[cutscene]
	o.end_event = end_event
	return ui.Frame.new(self, o)
end

function CutScene:onEntry()
	self.scroll_x = 0
	self.scroll_y = 0
	self.scale = 1
	self.offset_x = 0
	self.offset_y = 0
	self.x_multiplier = 1
	self.y_multiplier = 1
	self.dataPosition = 1
	self.timeElapsed = 0
	self.sprites = {}
	self.fit = "none"
	self.result = nil
	ui.Frame.onEntry(self)
	
	loadImages( {"CUTSCENES"} )
	loadCompoSprites( {"CUTSCENES_COMPOSPRITES"} )
	
	_G.res.stopAllAudio()
	
	if keyHold["LBUTTON"] then
		self.ldown = true
	end
end

function CutScene:update(dt, time)
	self.timeElapsed = self.timeElapsed + dt
	
	self.timeElapsed = 1000
	
	while self.data[self.dataPosition] and self.data[self.dataPosition].time <= self.timeElapsed do
		self:processCommand(self.data[self.dataPosition])
		self.dataPosition = self.dataPosition + 1
	end
	
	if self.scroll then
		local scroll = self.scroll
		local scroll_progress
		if scroll.type == "linear" then
			scroll_progress = (self.timeElapsed - scroll.begin_time) / (scroll.end_time - scroll.begin_time)
		elseif scroll.type == "cubic_in_out" then
			scroll_progress = tweenEaseCubicInOut(self.timeElapsed - scroll.begin_time, 0, 1, scroll.end_time - scroll.begin_time)
		end
		if scroll_progress >= 1 then
			self.scroll = nil
			self.scroll_x = scroll.end_x
			self.scroll_y = scroll.end_y
		else
			self.scroll_x = scroll.begin_x + scroll_progress * (scroll.end_x - scroll.begin_x)
			self.scroll_y = scroll.begin_y + scroll_progress * (scroll.end_y - scroll.begin_y)
		end
	end
	
	ui.Frame.update(self, dt, time)
end

function CutScene:processCommand(command)
	if command.action == "playsound" then
		_G.res.playAudio(command.sound, command.volume or 1, command.loop or false, command.track)
	elseif command.action == "createsprite" then
		local sprite =
		{
			image = command.image,
			layer = command.layer or 0,
			x = command.x * self.x_multiplier,
			y = command.y * self.y_multiplier,
			z = command.z or 0,
			flip_x = command.flip_x or false,
			flip_y = command.flip_y or false,
			scale_x = command.scale_x or 1,
			scale_y = command.scale_y or 1,
			angle = command.angle or 0
		}
		self.sprites[command.name] = sprite
	elseif command.action == "deletesprite" then
		self.sprites[command.name] = nil
	elseif command.action == "set_bg_colour" then
		setBGColor(command.r, command.g, command.b)
		self.backgroundColour = { r = command.r, g = command.g, b = command.b, a = 1.0 }
	elseif command.action == "fitheight" then
		local image = command.image or self.sprites[command.sprite].image
		local _, sh = self:getCompoSpriteBounds(image)
		self.fit = "height"
		self.ref_height = sh
		self:layout()
		print("fitting cutscene to h=" .. self.ref_height .. " scale=" .. self.scale .. "\n")
	elseif command.action == "fitwidth" then
		local image = command.image or self.sprites[command.sprite].image
		local sw, _ = self:getCompoSpriteBounds(image)
		self.fit = "width"
		self.ref_width = sw
		self:layout()
		print("fitting cutscene to w=" .. self.ref_width .. " scale=" .. self.scale .. "\n")
	elseif command.action == "setreferencesize" then
		local sw, sh = self:getCompoSpriteBounds(command.image)
		self.x_multiplier = sw / command.width
		self.y_multiplier = sh / command.height
	elseif command.action == "set_scroll_position" then
		local target = self.sprites[command.scroll_target.sprite]
		local sw, sh = self:getCompoSpriteBounds(target.image)
		self.scroll_x = target.x + command.scroll_target.x * sw - command.scroll_cursor.x * (screenWidth / self.scale - self.offset_x * 2)
		self.scroll_y = target.y + command.scroll_target.y * sh - command.scroll_cursor.y * (screenHeight / self.scale - self.offset_y * 2)
		print("setting scroll position to [" .. self.scroll_x .. ";" .. self.scroll_y .. "]\n")
		--print("offset = [" .. self.offset_x .. ";" .. self.offset_y .. "]\n")
		--print("scroll target = [" .. command.scroll_target.x * sw * self.scale .. ";" .. command.scroll_target.y * sh * self.scale .. "]\n")
		--print("s = [" .. sw .. "x" .. sh .. "]\n")
	elseif command.action == "scroll" then
		local scroll = {}
		local target = self.sprites[command.scroll_target.sprite]
		local sw, sh = self:getCompoSpriteBounds(target.image)
		local px, py = _G.res.getSpritePivot(target.image)
		local cursor_x = self.scroll_x + command.scroll_cursor.x * (screenWidth / self.scale - self.offset_x * 2)
		local cursor_y = self.scroll_y + command.scroll_cursor.y * (screenHeight / self.scale - self.offset_y * 2)
		local target_x = target.x + command.scroll_target.x * sw
		local target_y = target.y + command.scroll_target.y * sh
		print("CURSOR: " .. cursor_x .. "; TARGET: " .. target_x .. "\n")
		scroll.begin_x = self.scroll_x
		scroll.end_x = self.scroll_x + (target_x - cursor_x)
		scroll.begin_y = self.scroll_y
		scroll.end_y = self.scroll_y + (target_y - cursor_y)
		scroll.begin_time = command.time
		scroll.end_time = command.time + command.duration
		scroll.type = command.type or "linear"
		self.scroll = scroll
	elseif command.action == "end" then
		settingsWrapper:setCutsceneWatched(self.cutscene)
		saveLuaFileWrapper("settings.lua", "settings", true)
		if self.end_event then
			eventManager:notify(self.end_event)
		end
	end
	
end

function CutScene:getCompoSpriteBounds(sprite)
	local _, _, w, h = _G.res.getCompoSpriteBounds(sprite)
	return w, h
end

function CutScene:layout()
	if self.fit == "height" then
		if self.ref_height > screenHeight then
			self.scale = screenHeight / self.ref_height
			self.offset_y = 0
		else
			self.scale = 1
			self.offset_y = (screenHeight - self.ref_height) * 0.5
		end
	elseif self.fit == "width" then
		if self.ref_width > screenWidth then
			self.scale = screenWidth / self.ref_width
			self.offset_x = 0
		else
			self.scale = 1
			self.offset_x = (screenWidth - self.ref_width) * 0.5
		end
	end

	ui.Frame.layout(self)
end

function CutScene:onExit()
	_G.res.stopAllAudio()
	ui.Frame.onExit(self)
end

function CutScene:draw(x, y)
	local drawlist = {}
	for _, v in _G.pairs(self.sprites) do
		_G.table.insert(drawlist, v)
	end
	_G.table.sort(drawlist, function(a, b)
		return a.z < b.z
	end)
	
	local scale_x = self.scale
	local scale_y = self.scale
	local offset_x = _G.math.floor(-self.scroll_x)
	local offset_y = _G.math.floor(-self.scroll_y)
	offset_y = offset_y + self.offset_y
	
	if self.offset_y > 0 then
		drawRect(0, 0, 0, 1, 0, 0, screenWidth, _G.math.ceil(self.offset_y), false)
		drawRect(0, 0, 0, 1, 0, _G.math.floor(screenHeight - self.offset_y), screenWidth, screenHeight, false)
		_G.res.setClipRect(0, self.offset_y, screenWidth, screenHeight - 2 * self.offset_y)
	end
	
	for i = 1, #drawlist do
		local sprite = drawlist[i]
		local flip_x = 1
		local flip_y = 1
		if sprite.flip_x then flip_x = -1 end
		if sprite.flip_y then flip_y = -1 end
		local px, py = _G.res.getSpritePivot(sprite.image)
		local xs = scale_x * flip_x
		local ys = scale_y * flip_y
		setRenderState(offset_x + (sprite.x * scale_x) / xs, offset_y + (sprite.y * scale_y) / ys, xs, ys, sprite.angle, px, py)
		_G.res.drawSprite(sprite.image, 0, 0)
	end
	
	setRenderState(0, 0, 1, 1, 0, 0, 0)
	_G.res.setClipRect(0, 0, screenWidth, screenHeight)
	
	ui.Frame.draw(self, x, y)
end

function CutScene:onPointerEvent(eventType, x, y)
	
	if eventType == "LRELEASE" and settingsWrapper:canSkipCutscene(self.cutscene) then
		if self.ldown then
			--ignore first lrelease if click was held when the cutscene began
			self.ldown = nil
		else
			_G.res.stopAllAudio()
			eventManager:notify(self.end_event)
		end
	end
	
	ui.Frame.onPointerEvent(self, eventType, x, y)
end

filename="cutscene.lua"
