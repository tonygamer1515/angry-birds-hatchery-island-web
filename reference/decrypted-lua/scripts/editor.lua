g_editLevelPacks = 50
g_levelsPerFolder = 21
g_levelsPerFolderRow = 7

Editor = {}

function Editor:new(o)
	local o = o or {}
	self.__index = self
	_G.setmetatable(o, self)
	return o
end

function Editor:eventTriggered(event)
	if event.id == events.EID_LEVEL_ENDED then
		if startedFromEditor then
			returnToEditor()
		end
	end
end

EditorPage = ui.Frame:new()

function EditorPage:init()

	self.backgroundColour = { r = 0, g = 0, b = 0, a = 1 }

	local bw, bh = _G.res.getSpriteBounds("LS_LEVEL_BG_NORMAL_OPEN_1")

	local epsCaption = ui.Text:new()
	epsCaption.font = fontBasic
	epsCaption.text = "Worlds"
	epsCaption.x = bw * 0.3
	epsCaption.y = bh * 0.3
	epsCaption.hanchor = "LEFT"
	self:addChild(epsCaption)
	
	local offs = 0
	for i = 1, #g_episodeIds do
		for j = 1, #g_episodes[g_episodeIds[i]].pages do
			offs = offs + 1
			local ep = ui.ImageButton:new()
			ep.name = "ep" .. i .. "_" .. j
			ep.scaleX = 0.35
			ep.scaleY = 0.35
			ep.x = bw * offs * 0.4
			ep.y = bh * 0.8
			ep:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
			ep.returnValue = "EDITOR_MENU_WORLD"
			ep.meta = { ep = g_episodeIds[i], page = j }
			local epNumber = ui.Text:new()
			epNumber.font = "FONT_BIG_NUMBERS"
			epNumber.text = "" .. g_episodes[g_episodeIds[i]].pages[j].display_number
			ep:addChild(epNumber)
			self:addChild(ep)
		end
	end
	
	local foldersCaption = ui.Text:new()
	foldersCaption.font = fontBasic
	foldersCaption.text = "Folders"
	foldersCaption.x = bw * 0.3
	foldersCaption.y = bh * 1.2
	foldersCaption.hanchor = "LEFT"
	self:addChild(foldersCaption)
	
	for i = 1, g_editLevelPacks do
		local col = (i - 1) % 20
		local row = (i - 1 - col) / 20
		
		local folder = ui.ImageButton:new()
		folder.scaleX = 0.35
		folder.scaleY = 0.35
		folder.x = bw * (col + 1) * 0.4
		folder.y = bh * (1.2 + (row + 1) * 0.4)
		folder:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
		folder.returnValue = "EDITOR_MENU_FOLDER"
		folder.meta = i
		local epNumber = ui.Text:new()
		epNumber.font = "FONT_BIG_NUMBERS"
		epNumber.text = "" .. i
		folder:addChild(epNumber)
		self:addChild(folder)
	end
	
	local exitButton = ui.ImageButton:new()
	exitButton:setImage("LS_BACK_BUTTON")
	exitButton.x = 0
	exitButton.y = screenHeight
	exitButton.returnValue = "EDITOR_EXIT"
	self:addChild(exitButton)
	
	local nextPage = ui.ImageButton:new()
	nextPage:setImage("LS_BACK_BUTTON")
	nextPage.scaleX = -1
	local w, _ = _G.res.getSpriteBounds("LS_BACK_BUTTON")
	nextPage.x = screenWidth
	nextPage.y = screenHeight
	nextPage.returnValue = "EDITOR_MENU_WORLD"
	nextPage.meta = { ep = g_episodeIds[1], page = 1 }
	self:addChild(nextPage)
end

EditorEpPage = ui.Frame:new()

function EditorEpPage:new(e, p)
	local o = {}
	o.ep = e
	o.page = p
	return ui.Frame.new(self, o)
end

function EditorEpPage:init()

	self.backgroundColour = { r = 0, g = 0, b = 0, a = 1 }
	
	local world = -1
	
	local world_index = 1
	for i = 1, #g_episodeIds do
		for j = 1, #g_episodes[g_episodeIds[i]].pages do
			if i == self.ep and j == self.page then
				world = world_index
			end
			world_index = world_index + 1
		end
	end

	local exitButton = ui.ImageButton:new()
	exitButton:setImage("LS_BACK_BUTTON")
	exitButton.x = 0
	exitButton.y = screenHeight
	exitButton.returnValue = "EDITOR_MENU"
	self:addChild(exitButton)
	
	local nextPage = ui.ImageButton:new()
	nextPage:setImage("LS_BACK_BUTTON")
	nextPage.scaleX = -1
	local w, _ = _G.res.getSpriteBounds("LS_BACK_BUTTON")
	nextPage.x = screenWidth
	nextPage.y = screenHeight
	local e = self.ep
	local p = self.page
	p = p + 1
	if p > #g_episodes[e].pages then
		p = 1
		for i = 1, #g_episodeIds do
			if e == g_episodeIds[i] then
				if i < #g_episodeIds then
					e = g_episodeIds[i + 1]
					break
				else
					e = nil
				end
			end
		end
	end

	if e ~= nil then
		nextPage.returnValue = "EDITOR_MENU_WORLD"
		nextPage.meta = { ep = e, page = p }
	else
		nextPage.returnValue = "EDITOR_MENU_FOLDER"
		nextPage.meta = 1
	end
	self:addChild(nextPage)
	
	local bw, bh = _G.res.getSpriteBounds("LS_LEVEL_BG_NORMAL_OPEN_1")
	
	local epsCaption = ui.Text:new()
	epsCaption.font = fontBasic
	epsCaption.text = "World"
	epsCaption.x = bw * 0.3
	epsCaption.y = bh * 0.3
	epsCaption.hanchor = "LEFT"
	self:addChild(epsCaption)
	
	local epsCaption2 = ui.Text:new()
	epsCaption2.font = "FONT_BIG_NUMBERS"
	epsCaption2.text = "" .. g_episodes[self.ep].pages[self.page].display_number or "0"
	epsCaption2.x = screenWidth * 0.11
	epsCaption2.y = bh * 0.3
	epsCaption2.hanchor = "LEFT"
	self:addChild(epsCaption2)
	
	local ln = 1
	local pg = g_episodes[self.ep].pages[self.page]
	local folder = pg.folder_name
	if pg.layout == "grid" or pg.layout == "facebook" then
		local rows
		local cols
		if pg.layout == "grid" then
			cols = pg.layout_params.cols
			rows = pg.layout_params.rows
		else
			cols = 3
			rows = 1
		end
		local idx = 1
		for i = 1, rows do
			for j = 1, cols do
				local lvl = ui.ImageButton:new()
				lvl.scaleX = 1
				lvl.scaleY = 1
				lvl.x = bw * j * 1.1
				lvl.y = bh * i * 1.1
				lvl:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
				local epNumber = ui.Text:new()
				epNumber.font = "FONT_BIG_NUMBERS"
				local level_index = getLevelIndexInEpisode(pg.levels[ln].name)
				if g_episodes[self.ep].per_page_level_numbering then
					epNumber.text = "" .. ln
				else
					epNumber.text = "" .. level_index
				end
				
				lvl.returnValue = "EDITOR_GOTO_LEVEL"
				lvl.meta =
				{
					index = ln,
					index_in_theme = level_index,
					theme = self.ep,
					world = world,
					page = self.page,
					level_name = pg.levels[ln].name,
					level_folder = levelPath .. "/" .. folder .. "/",
					editor_page = "pack",
				}
				
				lvl:addChild(epNumber)
				self:addChild(lvl)
				ln = ln + 1
			end
		end
	elseif pg.layout == "goldeneggs" then
		for k, v in _G.ipairs(pg.levels) do
			local lvl = ui.ImageButton:new()
			lvl.scaleX = 1
			lvl.scaleY = 1
			lvl.x = bw + v.x * bw * 1.1 * 7
			lvl.y = bh + v.y * bh * 1.1 * 3
			lvl:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
			local epNumber = ui.Text:new()
			epNumber.font = "FONT_BIG_NUMBERS"
			local level_index = getLevelIndexInEpisode(v.name)
			if g_episodes[self.ep].per_page_level_numbering then
				epNumber.text = "" .. ln
			else
				epNumber.text = "" .. level_index
			end
			
			lvl.returnValue = "EDITOR_GOTO_LEVEL"
			lvl.meta =
			{
				index = k,
				index_in_theme = level_index,
				theme = self.ep,
				world = world,
				page = self.page,
				level_name = v.name,
				level_folder = levelPath .. "/" .. folder .. "/",
				editor_page = "pack",
			}
			
			lvl:addChild(epNumber)
			self:addChild(lvl)
			ln = ln + 1
		end
	end
end

EditorFolderPage = ui.Frame:new()

function EditorFolderPage:new(f)
	local o = {}
	o.folder = f
	return ui.Frame.new(self, o)
end

function EditorFolderPage:init()

	self.backgroundColour = { r = 0, g = 0, b = 0, a = 1 }

	local exitButton = ui.ImageButton:new()
	exitButton:setImage("LS_BACK_BUTTON")
	exitButton.x = 0
	exitButton.y = screenHeight
	exitButton.returnValue = "EDITOR_MENU"
	self:addChild(exitButton)
	
	local nextPage = ui.ImageButton:new()
	nextPage:setImage("LS_BACK_BUTTON")
	nextPage.scaleX = -1
	local w, _ = _G.res.getSpriteBounds("LS_BACK_BUTTON")
	nextPage.x = screenWidth
	nextPage.y = screenHeight
	if self.folder < g_editLevelPacks then
		nextPage.returnValue = "EDITOR_MENU_FOLDER"
		nextPage.meta = self.folder + 1
	else
		nextPage.visible = false
	end
	self:addChild(nextPage)
	
	local bw, bh = _G.res.getSpriteBounds("LS_LEVEL_BG_NORMAL_OPEN_1")
	
	local epsCaption = ui.Text:new()
	epsCaption.font = fontBasic
	epsCaption.text = "folder \"pack" .. self.folder .. "\""
	epsCaption.x = bw * 0.3
	epsCaption.y = bh * 0.3
	epsCaption.hanchor = "LEFT"
	self:addChild(epsCaption)
	
	local ln = (self.folder - 1) * g_levelsPerFolder + 1
	local idx = 1
	local rows = g_levelsPerFolder / g_levelsPerFolderRow
	local cols = g_levelsPerFolderRow
	for i = 1, rows do
		for j = 1, cols do
			local lvl = ui.ImageButton:new()
			lvl.scaleX = 1
			lvl.scaleY = 1
			lvl.x = bw * j * 1.1
			lvl.y = bh * i * 1.1
			lvl:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
			local epNumber = ui.Text:new()
			epNumber.font = "FONT_BIG_NUMBERS"
			epNumber.text = "" .. ln
			lvl:addChild(epNumber)
			self:addChild(lvl)
			if ln >= 1000 then
				epNumber.scaleX = 0.5
				epNumber.scaleY = 0.5
			elseif ln >= 100 then
				epNumber.scaleX = 0.67
				epNumber.scaleY = 0.67
			end
			
			if checkForLuaFile(levelPath .. "/pack" .. self.folder .. "/Level" .. ln .. ".lua") then
				--lvl:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
			else
				--lvl:setImage("LS_LEVEL_BG_NORMAL_OPEN_1")
				lvl.alpha = 0.3
			end
			
			lvl.returnValue = "EDITOR_GOTO_LEVEL"
			lvl.meta =
			{
				index = idx,
				index_in_theme = idx,
				theme = 1,
				world = -1,
				page = self.folder,
				level_name = "Level" .. ln,
				level_folder = levelPath .. "/pack" .. self.folder .. "/",
				editor_page = "folder",
			}
			
			ln = ln + 1
			idx = idx + 1
		end
	end
end

function editor_pointer_event(o, eventType, x, y)
	local result, meta = ui.Frame.onPointerEvent(o, eventType, x, y)
	
	if result == "EDITOR_MENU_WORLD" then
		menuManager:changeRoot(EditorEpPage:new(meta.ep, meta.page))
	elseif result == "EDITOR_EXIT" then
		startedFromEditor = false
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU", from = "EPISODE_SELECTION" })
	elseif result == "EDITOR_MENU" then
		menuManager:changeRoot(EditorPage:new())
	elseif result == "EDITOR_MENU_FOLDER" then
		menuManager:changeRoot(EditorFolderPage:new(meta))
	elseif result == "EDITOR_GOTO_LEVEL" then
		editLevel(meta.level_folder, meta.level_name, meta.index, meta.index_in_theme, meta.theme, meta.world, meta.page, meta.editor_page)
	end
	
	if eventType == "BACK" then
		if o.init == EditorPage.init then
			startedFromEditor = false
			eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU", from = "EPISODE_SELECTION" })
		else
			menuManager:changeRoot(EditorPage:new())
		end
	end
end

EditorPage.onPointerEvent = editor_pointer_event
EditorEpPage.onPointerEvent = editor_pointer_event
EditorFolderPage.onPointerEvent = editor_pointer_event

function editLevel(folder, level, index, index_in_theme, theme, world, page, editor_page)
	startedFromEditor = true
	_G.res.stopAudio(currentMainMenuSong)
	levelName = level
	levelFolder = folder
	setEditing(true)
	setPhysicsEnabled(physicsEnabled)
	currentLevelNumberInTheme = index
	currentLevelNumber = index_in_theme
	currentThemeNumber = theme
	currentWorldNumber = world
	currentPageNumber = page
	loadLevelInternal(folder .. level)
	currentGameMode = updateEditor

	--local hud = ui.GameHud:new()
	--menuManager:changeRoot(hud)
	--hud.visible = false
	menuManager:changeRoot(nil)
	
	g_editorPage = editor_page
end

-------------------
--OverlayPage-class
-------------------

OverlayPage = Page:new()

function OverlayPage:init()
	self:insertItem("shade", RectItem:new({alpha = 0.0}))
	self:insertItem("kingText", TextItem:new({default = "Pigs popped: ", text = "Pigs popped: ", x = screenWidth / 2, y = screenHeight / 2, visible = false}))
	self:insertItem("trainText", TextItem:new({default = "Carts wrecked: ", text = "Carts Wrecked: ", x = screenWidth / 2, y = screenHeight / 2, visible = false}))
	self:insertItem("again", TextItem:new({text = "Try again", x = screenWidth / 2, y = (screenHeight / 2) + (50 / 320) * screenHeight, visible = false,
										   action = {[function(x) sm:changeScene(x) end] = "kingOfTheHill"}}))
	self:insertItem("quit", TextItem:new({text = "Quit", x = screenWidth / 2, y = (screenHeight / 2) + (80 / 320) * screenHeight, visible = false,
										   action = {[function(x) sm:changeScene(x) end] = "mainMenu"}}))
end

function OverlayPage:onEntry()
	--print("\noverlay on entry")
	self.items.shade.x1 = 0
	self.items.shade.x2 = screenWidth
	self.items.shade.y1 = 0
	self.items.shade.y2 = screenHeight
	
end

function OverlayPage:update(dt, time)
	if self.fadeIn == true then
		self.fadeTime = self.fadeTime - dt
		self.items.shade.alpha = self.items.shade.alpha + dt * self.fadeIncrement
		if self.fadeTime < 0 then
			self.fadeIn = false
			self.items.shade.alpha = self.fadeTo
			self.fadeTime = 0
		end
	elseif self.fadeOut == true then
		self.fadeTime = self.fadeTime - dt
		self.items.shade.alpha = self.items.shade.alpha - dt * self.fadeIncrement
		if self.fadeTime < 0 then
			self.fadeOut = false
			self.items.shade.alpha = self.fadeTo
			self.fadeTime = 0
		end
	end
end

function OverlayPage:initTexts(score)
	self.visible = true
	self.items.kingText.text = self.items.kingText.default .. score
	self.items.kingText.visible = true
	self.items.again.visible = true
	self.items.quit.visible = true
	self:fade(0, 0.3, 1)
end


function OverlayPage:initTrainTexts(score)
	self.visible = true
	self.items.trainText.text = self.items.trainText.default .. score
	self.items.trainText.visible = true
	self.items.again.visible = true
	self.items.quit.visible = true
	self:fade(0, 0.3, 1)
end

function OverlayPage:updatePositions()
	self.items.shade.x2 = screenWidth
	self.items.shade.y2 = screenHeight
	self.items.kingText.x = screenWidth / 2
	self.items.kingText.y = screenHeight / 2
	self.items.trainText.x = screenWidth / 2
	self.items.trainText.y = screenHeight / 2
	self.items.again.x = screenWidth / 2
	self.items.again.y = screenHeight / 2 + (50 / 320) * screenHeight
	self.items.quit.x = screenWidth / 2
	self.items.quit.y = screenHeight / 2 + (80 / 320) * screenHeight
end

function OverlayPage:fade(from, to, time)
	if from < to then
		self.items.shade.alpha = from
		self.fadeTo = to
		self.fadeIncrement = (to - from)/ time
		self.fadeTime = time
		self.fadeIn = true
	else 
		self.items.shade.alpha = from
		self.fadeTo = to
		self.fadeIncrement = (from - to)/ time
		self.fadeTime = time
		self.fadeOut = true
	end
end

EditorJointPage = Page:new()

function EditorJointPage:init()
	self.m_selectedAnchor = nil
end

function EditorJointPage:onEntry()
	
	self:insertItem("shade", RectItem:new({alpha = 0.0, renderState = true}))
	
	self.jointTexts = { "Distance Joint", "Weld Joint", "Revolute Joint", "Prismatic Joint", "\"Destroy-attached\" -joint" }
	self.motorTexts = { "Motor: disabled", "Motor: enabled" }
	self.limitTexts = { "Limits: disabled", "Limits: enabled" }
	self.backAndForthTexts = { "Back-and-forth: disabled", "Back-and-forth: enabled"}
	self.xTexts = { "x: 0", "x: 1" }
	self.yTexts = { "y: 0", "y: 1" }
	self.collideTexts = { "Collide connected: disabled", "Collide connected: enabled" }
	
	setFont("FONT_BASIC")
	local fl = _G.res.getFontLeading()
	fl = fl * 1.5
	self:insertItem("name", TextItem:new({name = "name", text = "", visible = false, font = "FONT_BASIC", x = 0, y = (80 / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("type", TextItem:new({name = "type", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("motor", TextItem:new({name = "motor", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 2) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("motorSpeed", TextItem:new({name = "motorSpeed", text = "", visible = false, font = "FONT_BASIC", x = (20 / 480) * screenWidth, y = ((80 + fl * 3) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("maxTorque", TextItem:new({name = "maxTorque", text = "", visible = false, font = "FONT_BASIC", x = (20 / 480) * screenWidth, y = ((80 + fl * 4) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("limit", TextItem:new({name = "limit", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 5) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("lowerLimit", TextItem:new({name = "lowerLimit", text = "", visible = false, font = "FONT_BASIC", x = (20 / 480) * screenWidth, y = ((80 + fl * 6) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("upperLimit", TextItem:new({name = "upperLimit", text = "", visible = false, font = "FONT_BASIC", x = (20 / 480) * screenWidth, y = ((80 + fl * 7) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("backAndForth", TextItem:new({name = "backAndForth", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 8) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("ok", TextItem:new({name = "ok", text = "OK", visible = false, font = "FONT_BASIC", x = (40 / 480) * screenWidth, y = ((80 + fl * 4) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("x", TextItem:new({name = "x", text = "", visible = false, font = "FONT_BASIC", x = (10 / 480) * screenWidth, y = ((80 + fl * 3) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("y", TextItem:new({name = "y", text = "", visible = false, font = "FONT_BASIC", x = (60 / 480) * screenWidth, y = ((80 + fl * 3) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("frequency", TextItem:new({name = "frequency", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 2) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("damping", TextItem:new({name = "damping", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 3) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("collide", TextItem:new({name = "collide", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 2) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("destroyTimer", TextItem:new({name = "destroyTimer", text = "", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 2) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	
	self:insertItem("anchor1", TextItem:new({name = "anchors1", text = "Anchors 1", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 9) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("anchor2", TextItem:new({name = "anchors1", text = "Anchors 2", visible = false, font = "FONT_BASIC", x = 0, y = ((80 + fl * 10) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	
	self:insertItem("anchorX1", TextItem:new({name = "anchorX1", text = "x:", visible = false, font = "FONT_BASIC", x = 100, y = ((80 + fl * 9) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("anchorY1", TextItem:new({name = "anchorY1", text = "y:", visible = false, font = "FONT_BASIC", x = 200, y = ((80 + fl * 9) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	
	self:insertItem("anchorX2", TextItem:new({name = "anchorX2", text = "x:", visible = false, font = "FONT_BASIC", x = 100, y = ((80 + fl * 10) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	self:insertItem("anchorY2", TextItem:new({name = "anchorY2", text = "y:", visible = false, font = "FONT_BASIC", x = 200, y = ((80 + fl * 10) / 480) * screenHeight, hanchor = "LEFT", vanchor = "TOP"}))
	
	
	self.selectedJoint = nil
	for k, v in _G.pairs(objects.joints) do
		self:addJoint(v.name)
	end
	self:updatePositions()
	self:prepareTexts()
end	

function EditorJointPage:hideAllNonCommonItems()
	
	self.items.motor.visible = false
	self.items.motorSpeed.visible = false
	self.items.maxTorque.visible = false
	self.items.limit.visible = false
	self.items.lowerLimit.visible = false
	self.items.upperLimit.visible = false
	self.items.backAndForth.visible = false
	
	self.items.x.visible = false
	self.items.y.visible = false
	self.items.frequency.visible = false
	self.items.damping.visible = false
	self.items.collide.visible = false
	self.items.destroyTimer.visible = false
	
	
end

function EditorJointPage:onExit()
	for i = 1, #self.items do
		self:removeItem(self.items[i])
	end
end

function EditorJointPage:addJoint(joint)

	self:insertItem(joint, SpriteItem:new({ sprite = "TRAIL_FLOWER_1",spriteIdle = "TRAIL_FLOWER_1", spriteClick="TRAIL_FLOWER_3", inWorld = true }))
	self:insertItem(joint .. "_ANCHOR_1", SpriteItem:new({ sprite = "TRAIL_WHITE_1",spriteIdle = "TRAIL_WHITE_1", spriteClick="TRAIL_FLOWER_3", inWorld = true }))
	self:insertItem(joint .. "_ANCHOR_2", SpriteItem:new({ sprite = "TRAIL_WHITE_1",spriteIdle = "TRAIL_WHITE_1", spriteClick="TRAIL_FLOWER_3", inWorld = true }))
	
end

function EditorJointPage:create_joint()
	if editor.newJoint.type == 4 then
		if self.items.x.text == self.xTexts[1] then
			editor.newJoint.worldAxisX = 0
		else
			editor.newJoint.worldAxisX = 1
		end
		if self.items.y.text == self.yTexts[1] then
			editor.newJoint.worldAxisY = 0
		else
			editor.newJoint.worldAxisY = 1
		end
		self.items.x.visible = false
		self.items.y.visible = false
	end
	
	--makes all anchors coordinates in object's local space
	editor.newJoint.coordType = 2

	createJoint(editor.newJoint)
	self:addJoint(editor.newJoint.name)
	selectedObjects = {}
	self.selectedJoint = objects.joints[editor.newJoint.name]
	--self.items[self.selectedJoint.name].sprite = "TRAIL_FLOWER_3"
	self.items[self.selectedJoint.name].sprite = self.items[self.selectedJoint.name].spriteClick
	editor.newJoint = nil
	levelSaved = false
	self.items.ok.visible = false
	self:prepareTexts()
end

function EditorJointPage:update(dt, time) 
	
	self:updatePositions()
	
	if self.newJoint then
		if not self.fadeIn and self.items.shade.alpha <= 0 then 
			OverlayPage.fade(self, 0, 0.5, 0.2)
			self.fadeIn = true
		end
	--	self.items.ok.visible = true
		self:prepareTexts()
		self.newJoint = false
	end
	
	local itm = self:checkClicks()
	if itm and (self.selectedJoint or editor.newJoint) then
		local joint = self.selectedJoint
		-- toggle motor for revolute and prismatic joints
		if itm.name == "motor" then
			if joint.motor ~= nil then
				setJointParameters({name = joint.name, motor = not joint.motor})
				if not joint.motor then
					joint.backAndForth = false
				end	
				self:prepareTexts()
				levelSaved = false
			end
		-- toggle limits
		elseif itm.name == "limit" then
			if joint.limit ~= nil then
				setJointParameters({name = joint.name, limit = not joint.limit})
				if not joint.limit then
					joint.backAndForth = false
				end
				self:prepareTexts()
				levelSaved = false
			end
		-- toggle back-and-forth
		elseif itm.name == "backAndForth" then
			if joint.motor ~= nil and joint.limit ~= nil then
				joint.backAndForth = not joint.backAndForth
				if joint.backAndForth then
					self.items.backAndForth.text = self.backAndForthTexts[2]
				else
					self.items.backAndForth.text = self.backAndForthTexts[1]
				end
				levelSaved = false
			end
		elseif itm.name == "x" then
			if itm.text == self.xTexts[1] then
				itm.text = self.xTexts[2]
			else
				itm.text = self.xTexts[1]
			end
		elseif itm.name == "y" then
			if itm.text == self.yTexts[1] then
				itm.text = self.yTexts[2]
			else
				itm.text = self.yTexts[1]
			end
		elseif not joint and itm.name == "collide" then
			editor.newJoint.collideConnected = not editor.newJoint.collideConnected
			if itm.text == self.collideTexts[1] then
				itm.text = self.collideTexts[2]
			else
				itm.text = self.collideTexts[1]
			end
		elseif itm.name == "type" and not joint and editor.newJoint then
			editor.newJoint.type = editor.newJoint.type + 1
			if editor.newJoint.type == 6 then
				editor.newJoint.type = 1
			end
			if editor.newJoint.type == 4 then
				self.items.x.visible = true
				self.items.y.visible = true
				self.items.x.text = self.xTexts[1]
				self.items.y.text = self.yTexts[1]
			else
				self.items.x.visible = false
				self.items.y.visible = false
			end
			if editor.newJoint.type == 5 then 
				self.items.collide.visible = false
			else
				self.items.collide.visible = true
			end
			self.items.type.text = self.jointTexts[editor.newJoint.type]
		-- create new joint
		elseif not joint and editor.newJoint and itm.name == "ok" then
			self:create_joint()
		end
	end
	
	if keyPressed["RETURN"] then
		if not self.selectedJoint and editor.newJoint then
			self:create_joint()
		elseif self.selectedJoint ~= nil then
			self.disableSelectedJoint = true
		end
	end

	-- change joint parameters
	if (keyHold["LBUTTON"] or keyHold["RBUTTON"] or (keyHold["CONTROL"] and cursor.wheel and cursor.wheelTriggered and (cursor.wheel == -1 or cursor.wheel == 1)))
		and (self.selectedJoint or editor.newJoint) then
		
		local itms = self:getHoveredItems()
		local offset = 1
		if keyHold["RBUTTON"] then
			offset = -1
		end
		if keyHold["CONTROL"] and cursor.wheel and (cursor.wheel == -1 or cursor.wheel == 1) and cursor.wheelTriggered then
			offset = cursor.wheel
		end
		if itms then 
			if keyHold["SHIFT"] then 
				offset = offset * 10
			end
			for k, v in _G.pairs(itms) do
				if v == "motorSpeed" then
					setJointParameters({name = self.selectedJoint.name, motorSpeed = self.selectedJoint.motorSpeed + offset / 10 })--+ cursor.wheel / 10})
					self.items.motorSpeed.text = "Speed: " .. self.selectedJoint.motorSpeed
					levelSaved = false
				elseif v == "maxTorque" then
					setJointParameters({name = self.selectedJoint.name, maxTorque = self.selectedJoint.maxTorque + offset * 100})--cursor.wheel * 100})
					self.items.maxTorque.text = "MaxTorque: " .. self.selectedJoint.maxTorque
					levelSaved = false
				elseif v == "lowerLimit" then
					local newLowLimit = _G.math.min(self.selectedJoint.lowerLimit + (offset / 360) * (_G.math.pi * 2), 0)
					setJointParameters({name = self.selectedJoint.name, lowerLimit = newLowLimit })
					if self.selectedJoint.type == 3 then
						self.items.lowerLimit.text = "Lower: " .. (self.selectedJoint.lowerLimit / (2 * _G.math.pi)) * 360
					elseif self.selectedJoint.type == 4 then
						self.items.lowerLimit.text = "Lower: " .. self.selectedJoint.lowerLimit
					end
					levelSaved = false
				elseif v == "upperLimit" then
					local newHighLimit = _G.math.max(0, self.selectedJoint.upperLimit + (offset / 360) * (_G.math.pi * 2))
					setJointParameters({name = self.selectedJoint.name, upperLimit = newHighLimit})
					if self.selectedJoint.type == 3 then
						self.items.upperLimit.text = "Upper: " .. (self.selectedJoint.upperLimit / (2 * _G.math.pi)) * 360
					elseif self.selectedJoint.type == 4 then
						self.items.upperLimit.text = "Upper: " .. self.selectedJoint.upperLimit
					end
					levelSaved = false
				elseif v == "frequency" then
					setJointParameters({name = self.selectedJoint.name, frequency = self.selectedJoint.frequency + offset / 10 })
					self.items.frequency.text = "Frequency: " .. self.selectedJoint.frequency
					levelSaved = false
				elseif v == "damping" then
					local newDamping = _G.math.max(0, _G.math.min(self.selectedJoint.dampingRatio + offset / 100, 1))
					setJointParameters({name = self.selectedJoint.name, dampingRatio = newDamping })
					self.items.damping.text = "Damping: " .. self.selectedJoint.dampingRatio
					levelSaved = false
				elseif v == "destroyTimer" then
					self.selectedJoint.destroyTimer = _G.math.max(0, self.selectedJoint.destroyTimer + offset / 100)
					self.items.destroyTimer.text = "Annihilation(!) timer: " .. self.selectedJoint.destroyTimer
					levelSaved = false				
				elseif v == "anchorX1" then
					self.selectedJoint.x1 = self.selectedJoint.x1 + (offset / 100)
					self.items.anchorX1.text = "x: " .. roundNumber(self.selectedJoint.x1, 2)
					levelSaved = false				
				elseif v == "anchorY1" then
					self.selectedJoint.y1 = self.selectedJoint.y1 + (offset / 100)
					self.items.anchorY1.text = "y: " .. roundNumber(self.selectedJoint.y1,2)
					levelSaved = false
				elseif v == "anchorX2" then
					self.selectedJoint.x2 = self.selectedJoint.x2 + (offset / 100)
					self.items.anchorX2.text = "x: " .. roundNumber(self.selectedJoint.x2,2)
					levelSaved = false				
				elseif v == "anchorY2" then
					self.selectedJoint.y2 = self.selectedJoint.y2 + (offset / 100)
					self.items.anchorY2.text = "y: " .. roundNumber(self.selectedJoint.y2,2)
					levelSaved = false
				end
			end
		end
	end
	
	if keyPressed["RBUTTON"] then
		local t_clickedOnAJointElement = false
		local t_clickedOnAnEditorItem = false
		local t_jointSelectedBefore = self.selectedJoint ~= nil
		
		local t_items = self:getHoveredItems()
		
		if not t_items then
			t_clickedOnAnEditorItem = false
		else
			t_clickedOnAnEditorItem = true
		end		
		
		--checks if the user has clicked any joint elements
		for k, v in _G.pairs(objects.joints) do							
					
			if 	(self.items[v.name] and self.items[v.name]:checkBounds(cursor.x, cursor.y)) or 
				(self.items[v.name .. "_ANCHOR_1"] and self.items[v.name  .. "_ANCHOR_1"]:checkBounds(cursor.x, cursor.y)) or
				(self.items[v.name .. "_ANCHOR_2"] and self.items[v.name  .. "_ANCHOR_2"]:checkBounds(cursor.x, cursor.y)) then
				
				--brings the selected joint to the idle state
				if self.selectedJoint then
					self.items[self.selectedJoint.name  .. "_ANCHOR_1"].sprite = self.items[self.selectedJoint.name  .. "_ANCHOR_1"].spriteIdle
					self.items[self.selectedJoint.name  .. "_ANCHOR_2"].sprite = self.items[self.selectedJoint.name  .. "_ANCHOR_2"].spriteIdle
					self.items[self.selectedJoint.name].sprite = self.items[self.selectedJoint.name].spriteIdle
				end		
				
				selectedObjects = {}
				
				self.selectedJoint = v
				
				editor.newJoint = false
				
				t_clickedOnAJointElement = true								
				
				--sets clicked joint with the click sprite
				self.items[v.name].sprite = self.items[v.name].spriteClick
					
				--if an anchor was clicked, put also the click sprite
				if self.items[v.name  .. "_ANCHOR_1"]:checkBounds(cursor.x, cursor.y) then
					self.items[v.name  .. "_ANCHOR_1"].sprite = self.items[v.name  .. "_ANCHOR_1"].spriteClick
					self.items[v.name  .. "_ANCHOR_2"].sprite = self.items[v.name  .. "_ANCHOR_1"].spriteIdle
					self.m_selectedAnchor = self.items[v.name  .. "_ANCHOR_1"]
				elseif self.items[v.name  .. "_ANCHOR_2"]:checkBounds(cursor.x, cursor.y) then
					self.items[v.name  .. "_ANCHOR_2"].sprite = self.items[v.name  .. "_ANCHOR_2"].spriteClick
					self.items[v.name  .. "_ANCHOR_1"].sprite = self.items[v.name  .. "_ANCHOR_2"].spriteIdle
					self.m_selectedAnchor = self.items[v.name  .. "_ANCHOR_2"]
				end		

			
				self:hideAllNonCommonItems()
				self:prepareTexts()
				
				break
			end
		end
		
		if not editor.newJoint then
		
			--user has clicked outside the editing buttons or joints
			if (not t_clickedOnAnEditorItem) and (not t_clickedOnAJointElement) then
				--print("\nclick outside")
				--there was a joint selected, wil disable this joint
				if self.selectedJoint ~= nil then
					self.disableSelectedJoint = true
				end
			end
			
			--new joint has been selected outside the editing page
			if (t_clickedOnAJointElement) and not t_jointSelectedBefore then
				OverlayPage.fade(self, 0, 0.5, 0.2)
				self.fadeIn = true
			end
			
		end
		
	end	
	
	--moving joint anchors
	if self.selectedJoint and self.m_selectedAnchor and keyHold["LBUTTON"] then
		if self.items[self.selectedJoint.name .. "_ANCHOR_1"]:checkBounds(cursor.x, cursor.y) then
			
			local t_worldPosX = 0
			local t_worldPosY = 0
			
			local t_localPosX = 0
			local t_localPosY = 0						
			
			t_worldPosX, t_worldPosY = screenToPhysicsTransform(cursor.x, cursor.y)												
			t_localPosX , t_localPosY = getLocalPoint(objects.joints[self.selectedJoint.name].end1, t_worldPosX, t_worldPosY);						
			
			objects.joints[self.selectedJoint.name].x1 = t_localPosX
			objects.joints[self.selectedJoint.name].y1 = t_localPosY
			
			self.items.anchorX1.text = "x: " .. roundNumber(t_localPosX, 2)
			self.items.anchorY1.text = "y: " .. roundNumber(t_localPosY, 2)
			
			self:updatePositions()
			
			levelSaved = false
			
		elseif self.items[self.selectedJoint.name .. "_ANCHOR_2"]:checkBounds(cursor.x, cursor.y) then
			local t_worldPosX = 0
			local t_worldPosY = 0
			
			local t_localPosX = 0
			local t_localPosY = 0						
			
			t_worldPosX, t_worldPosY = screenToPhysicsTransform(cursor.x, cursor.y)												
			t_localPosX , t_localPosY = getLocalPoint(objects.joints[self.selectedJoint.name].end2, t_worldPosX, t_worldPosY);						
			
			objects.joints[self.selectedJoint.name].x2 = t_localPosX
			objects.joints[self.selectedJoint.name].y2 = t_localPosY
			
			self.items.anchorX2.text = "x: " .. roundNumber(t_localPosX, 2)
			self.items.anchorY2.text = "y: " .. roundNumber(t_localPosY, 2)
			
			self:updatePositions()
			
			levelSaved = false
		end
	
	end
	
	if keyPressed["DELETE"] and self.selectedJoint and not physicsEnabled then
		self:removeItem(self.selectedJoint.name)
		self:removeItem(self.selectedJoint.name .. "_ANCHOR_1")
		self:removeItem(self.selectedJoint.name .. "_ANCHOR_2")
		destroyJoint(self.selectedJoint.name)
		self.selectedJoint = nil
		self.disableSelectedJoint = true
	end
	
	if self.disableSelectedJoint then
		if self.selectedJoint then
			--self.items[self.selectedJoint.name].sprite = "TRAIL_FLOWER_1"
			self.items[self.selectedJoint.name].sprite = self.items[self.selectedJoint.name].spriteIdle
			
			
			self.items[self.selectedJoint.name .. "_ANCHOR_1"].sprite = self.items[self.selectedJoint.name .. "_ANCHOR_1"].spriteIdle
			self.items[self.selectedJoint.name .. "_ANCHOR_2"].sprite = self.items[self.selectedJoint.name .. "_ANCHOR_2"].spriteIdle
			
			self.m_selectedAnchor = nil			
			self.selectedJoint = nil
		end
		if not self.fadeOut and self.items.shade.alpha >= 0.5 then
			self.fadeOut = true
			OverlayPage.fade(self, 0.5, 0, 0.2)
		end
		editor.newJoint = nil
		self:prepareTexts()
		self.disableSelectedJoint = false
	end


	if self.fadeIn then
		OverlayPage.update(self, dt)
		if self.items.shade.alpha >= 0.5 then
			self.fadeIn = false
		end
	elseif self.fadeOut then
		OverlayPage.update(self, dt)
		if self.items.shade.alpha <= 0 then
			self.fadeOut = false
		end 
	end
	
end

function EditorJointPage:setJointSelection()
	

end

function EditorJointPage:prepareTexts()
	
	local joint = self.selectedJoint or editor.newJoint
	
	if joint then
		self.items.name.text = "Name: " .. joint.name		
		self.items.type.text = self.jointTexts[joint.type]
		if joint.collideConnected then
			self.items.collide.text = self.collideTexts[2]
		else
			self.items.collide.text = self.collideTexts[1]
		end
		self.items.type.visible = true
		self.items.name.visible = true
		
		if self.selectedJoint then
			self.items.anchor1.visible = true
			self.items.anchor2.visible = true
			self.items.anchorX1.visible = true
			self.items.anchorY1.visible = true
			self.items.anchorX2.visible = true
			self.items.anchorY2.visible = true
			
			
		
			self.items.anchorX1.text = "x: " .. roundNumber(joint.x1,2)
			self.items.anchorY1.text = "y: " .. roundNumber(joint.y1, 2)
			self.items.anchorX2.text = "x: " .. roundNumber(joint.x2,2)
			self.items.anchorY2.text = "y: " .. roundNumber(joint.y2,2)
		end
	
		
		
		if editor.newJoint and not self.selectedJoint then
			self.items.ok.visible = true
			if editor.newJoint.type ~= 5 then
				self.items.collide.visible = true
			end
			return
		else
			self.items.ok.visible = false	
			self.items.collide.visible = false
		end
		if joint.type == 3 or joint.type == 4 then -- revolute and prismatic joint
			
			if joint.motor then
				self.items.motor.text = self.motorTexts[2]
			else
				self.items.motor.text = self.motorTexts[1]
			end
			if joint.limit then
				self.items.limit.text = self.limitTexts[2]
			else
				self.items.limit.text = self.limitTexts[1]
			end
			
			if joint.backAndForth then
				self.items.backAndForth.text = self.backAndForthTexts[2]
			else
				self.items.backAndForth.text = self.backAndForthTexts[1]
			end
			
			self.items.motorSpeed.text = "Speed: " .. joint.motorSpeed
			self.items.maxTorque.text = "MaxTorque: " .. joint.maxTorque
			if joint.type == 3 then
				self.items.lowerLimit.text = "Lower: " .. (joint.lowerLimit / (2 * _G.math.pi)) * 360
				self.items.upperLimit.text = "Upper: " .. (joint.upperLimit / (2 * _G.math.pi)) * 360
			else
				self.items.lowerLimit.text = "Lower: " .. joint.lowerLimit
				self.items.upperLimit.text = "Upper: " .. joint.upperLimit
			end
			
			self.items.motor.visible = true
			self.items.limit.visible = true
			if joint.motor then
				self.items.motorSpeed.visible = true
				self.items.maxTorque.visible = true
			else
				self.items.motorSpeed.visible = false
				self.items.maxTorque.visible = false
			end
			if joint.limit then
				self.items.lowerLimit.visible = true
				self.items.upperLimit.visible = true
			else
				self.items.lowerLimit.visible = false
				self.items.upperLimit.visible = false
			end
			
			if joint.motor and joint.limit then
				self.items.backAndForth.visible = true	
			else
				self.items.backAndForth.visible = false
			end
		elseif joint.type == 1 then
			self.items.frequency.text = "Frequency: " .. joint.frequency
			self.items.damping.text = "Damping: " .. joint.dampingRatio
			self.items.frequency.visible = true
			self.items.damping.visible = true
		elseif joint.type == 5 then
			self.items.destroyTimer.text = "Annihilation(!) timer: " .. joint.destroyTimer
			self.items.destroyTimer.visible = true
			self.items.collide.visible = false
		end
	elseif not joint then
		self.items.name.visible = false
		self.items.type.visible = false
		self.items.motor.visible = false	
		self.items.motorSpeed.visible = false
		self.items.maxTorque.visible = false
		self.items.limit.visible = false
		self.items.lowerLimit.visible = false
		self.items.upperLimit.visible = false
		self.items.backAndForth.visible = false
		self.items.x.visible = false
		self.items.y.visible = false
		self.items.damping.visible = false
		self.items.frequency.visible = false
		self.items.ok.visible = false
		self.items.collide.visible = false
		self.items.destroyTimer.visible = false
		
		self.items.anchor1.visible = false
		self.items.anchor2.visible = false
		self.items.anchorX1.visible = false
		self.items.anchorY1.visible = false
		self.items.anchorX2.visible = false
		self.items.anchorY2.visible = false
	end

end


function EditorJointPage:draw()
	if editor.drawOneLayer then
		return
	end
	
	self.items["shade"]:draw()	
	
	if self.selectedJoint or editor.newJoint then 
		local joint = self.selectedJoint or editor.newJoint
		local obj1 = objects.world[joint.end1]
		local obj2 = objects.world[joint.end2]
		local xCoord, yCoord = physicsToWorldTransform(obj1.x, obj1.y)
		setRenderState(-screen.left, -screen.top, worldScale, worldScale, obj1.angle, _G.res.getSpritePivot("", obj1.sprite))
		_G.res.drawSprite("", obj1.sprite, xCoord, yCoord)
		setRenderState(-screen.left, -screen.top, worldScale, worldScale, obj2.angle, _G.res.getSpritePivot("", obj2.sprite))
		xCoord, yCoord = physicsToWorldTransform(obj2.x, obj2.y)
		_G.res.drawSprite("", obj2.sprite, xCoord, yCoord)
		setRenderState(0, 0, 1, 1, 0, 0, 0)
		if self.selectedJoint then
			drawJoint(editor, objects.joints[self.selectedJoint.name], "EDITOR_JOINT")
		end
	end
	
	for k, v in _G.pairs(self.order) do
		if v ~= "shade" and self.items[v].sprite then
			--self.items[v]:draw()
			local xCoord, yCoord = self.items[v].x, self.items[v].y
			local xs, ys = self.items[v].xs or 1, self.items[v].ys or 1
			local angle = self.items[v].angle or 0
			local px, py = self.items[v].pivotX or 0, self.items[v].pivotY or 0
		
			setRenderState(-screen.left, -screen.top, worldScale, worldScale, 0, 0, 0)
			xCoord, yCoord = physicsToWorldTransform(xCoord, yCoord)
			
			_G.res.drawSprite(self.items[v].sheet, self.items[v].sprite, xCoord, yCoord)
			setRenderState(0, 0, 1, 1, 0, 0, 0)
		else
			self.items[v]:draw()
		end
	end
	
	

end

function EditorJointPage:updatePositions()
	
	for k, v in _G.pairs(objects.joints) do
		local joint = v
		local jointWorldX1 = joint.x1
		local jointWorldY1 = joint.y1
		local jointWorldX2 = joint.x2
		local jointWorldY2 = joint.y2
	
		if joint.coordType == 2 then
			jointWorldX1, jointWorldY1 = getWorldPoint(joint.end1, jointWorldX1, jointWorldY1);
			jointWorldX2, jointWorldY2 = getWorldPoint(joint.end2, jointWorldX2, jointWorldY2);
		end
		local xdif = jointWorldX2 - jointWorldX1
		local ydif = jointWorldY2 - jointWorldY1
		local xCoord, yCoord = jointWorldX1 + (xdif / 2), jointWorldY1 + (ydif / 2)
		self.items[joint.name].x = xCoord
		self.items[joint.name].y = yCoord
		
		
		self.items[joint.name .. "_ANCHOR_1"].x = jointWorldX1
		self.items[joint.name .. "_ANCHOR_1"].y = jointWorldY1
		
		self.items[joint.name .. "_ANCHOR_2"].x = jointWorldX2
		self.items[joint.name .. "_ANCHOR_2"].y = jointWorldY2
		
		
	end
	self.items.shade.x2 = screenWidth
	self.items.shade.y2 = screenHeight
	
end

filename="editor.lua"
