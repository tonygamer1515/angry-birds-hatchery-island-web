LevelSelectionRoot = ui.Frame:new()

function LevelSelectionRoot:draw(x, y)
	drawLevelSelectionBackground()	
	ui.Frame.draw(self, x, y)
end

function LevelSelectionRoot:init()

	ui.Frame.init(self)
	self.name = "LevelSelectionRoot"
	if deviceModel == "s60" then
		local closeButton = ui.ImageButton:new()
		closeButton.name = "closeButton"
		closeButton:setImage("BUTTON_CLOSE")
		closeButton.returnValue = "EXIT"
		self:addChild(closeButton)
	end
end


function LevelSelectionRoot:layout()
	ui.Frame.layout(self)
	
	if deviceModel == "s60" then
		local closeButton = self:getChild("closeButton")
		closeButton.x = screenWidth
		closeButton.y = 0
	end
end

function LevelSelectionRoot:update(dt, time)
	if _G.res.isAudioPlaying(currentMainMenuSong) == false and currentMainMenuSong ~= nil then
		_G.res.playAudio(currentMainMenuSong, 0.8, true, 7)
	end
	
	ui.Frame.update(self, dt, time)
end

function LevelSelectionRoot:onKeyEvent(eventType, key)
	if key == "BACK" then
		eventManager:notify({id = events.EID_CHANGE_SCENE, target = "EPISODE_SELECTION", from = "LEVEL_SELECTION" })
	end	
end

function LevelSelectionRoot:onPointerEvent(eventType,x,y)
	local result, meta = ui.Frame.onPointerEvent(self, eventType,x, y)
	
	
	if result == "EPISODE_SELECTION" then
		eventManager:notify({id = events.EID_CHANGE_SCENE, target = "EPISODE_SELECTION", from = "LEVEL_SELECTION"})
	elseif result == "GOTO_LEVEL" then
				
		if not meta.intro_cutscene then
			eventManager:notify({id = events.EID_CHANGE_LEVEL, data = meta})
		else
			eventManager:notify({ id = events.EID_LOAD_INTRO_CUTSCENE, cutscene = meta.intro_cutscene, data = meta })
		end
	elseif result == "DISABLED_LEVEL" then
		if g_episodes[meta.episode].pages[meta.page].levels[meta.level].hint then
			eventManager:notify({ id = events.EID_PUSH_FRAME, target = GoldenEggHintPopup:new(g_episodes[meta.episode].pages[meta.page].levels[meta.level].hint), })
		end
	elseif result == "GOTO_FACEBOOK_CONNECT" then
		eventManager:notify( { id = events.EID_GOTO_FACEBOOK_CONNECT })
	elseif result == "EXIT" then
		eventManager:notify( { id = events.EID_EXIT_GAME } )
	elseif result == "SHOW_FACEBOOK_PROMPT" then
		eventManager:notify({id = events.EID_PUSH_FRAME, target = ui.Prompt:new({title = "TEXT_FB_LEVELS_HINT_TITLE", content = "TEXT_FB_LEVELS_HINT"})})
	end	
	
	return result, meta
end

	
LevelSelection = LevelSelectionRoot:new()

function LevelSelection:new(o, episode)
	local o = o or {}
	o.episode = episode
	return LevelSelectionRoot.new(self, o)
end


function LevelSelection:init()

	self:createDecorationSprites()
	
	local levelButtons = LevelScrollFrame:new(nil, self.episode)
	levelButtons.name = "levelButtons"
	self:addChild(levelButtons)
	
	--return to episode selection button
	local backButton = ui.ImageButton:new()
	backButton.name = "backButton"
	backButton:setImage("LS_BACK_BUTTON")
	backButton.returnValue = "EPISODE_SELECTION"
	backButton.attach = "fixed"
	backButton.activateOnRelease = true
	backButton.clickSound = "menu_back"
	self:addChild(backButton)
	
	self.currentSelection = settingsWrapper:getCurrentLevelSelectionPage(self.episode)
	if self.currentSelection > #g_episodes[self.episode].pages then
		self.currentSelection = #g_episodes[self.episode].pages
		settingsWrapper:setCurrentLevelSelectionPage(self.episode, self.currentSelection)
	end
	levelButtons.currentSelection = self.currentSelection
	
	local left = self:getChild("left")
	if g_episodes[self.episode].decor_left ~= nil then
		left:setVisible(true)
		left:setImage(g_episodes[self.episode].decor_left)
	else
		left:setVisible(false)
	end
	
	local right = self:getChild("right")
	if g_episodes[self.episode].decor_right ~= nil then
		right:setVisible(true)
		right:setImage(g_episodes[self.episode].decor_right)
	else
		right:setVisible(false)
	end
	
	--page specific stuff
	for i = 1, #g_episodes[self.episode].pages do
	
		local page = g_episodes[self.episode].pages[i]
	
		--page indicator dots
		local dot = ui.Image:new()
		dot.name = "dot" .. i
		dot:setImage("LS_DOT_BLACK")
		dot.attach = "fixed"
		self:addChild(dot)
		
		--page numbers by the dots
		local pageNumber = ui.Text:new()
		pageNumber.name = "pageNumber" .. i
		if page.display_dot_numbers ~= false then
			pageNumber.text = page.display_number or ""
		else
			pageNumber.text = ""
		end
		pageNumber.font = "FONT_LS_SMALL"
		pageNumber.visible = false
		pageNumber.attach = "fixed"
		self:addChild(pageNumber)
	end
	
	eventManager:addEventListener(events.EID_SCROLL_TO_NEXT_WORLD, self)
	
	LevelSelectionRoot.init(self)
end


--create decorative sprites in the bottom corners of the screen
function LevelSelection:createDecorationSprites()
	--left side decoration image
	local left = ui.Image:new()
	left.name = "left"
	left:setImage("LS_MAIN_LEFT")
	left.attach = "fixed"
	self:addChild(left)
	
	--right side decoration image
	local right = ui.Image:new()
	right.name = "right"
	right:setImage("LS_MAIN_RIGHT")
	right.attach = "fixed"
	self:addChild(right)
end

function LevelSelection:onEntry()

	eventManager:addEventListener(events.EID_FACEBOOK_LIKE_CLICKED, self)
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_AVAILABLE, self)
	loginfo("added EID_MIGHTY_EAGLE_AVAILABLE for levelSelection")
	
	
	self:shadeBackground(self.currentSelection)
	self:updateSelection(true)
	
	--causes camera to reset to default when a level is entered
	levelRestartedFrom = nil

	LevelSelectionRoot.onEntry(self)
end

function LevelSelection:onExit()
	loginfo("removing EID_MIGHTY_EAGLE_AVAILABLE for levelSelection")
	eventManager:removeEventListener(events.EID_FACEBOOK_LIKE_CLICKED, self)
	eventManager:removeEventListener(events.EID_MIGHTY_EAGLE_AVAILABLE, self)
	LevelSelectionRoot.onExit(self)
end

function LevelSelection:layout()
	
	--decor sprites
	local left = self:getChild("left")
	left.y = screenHeight
	local right = self:getChild("right")
	right.x = screenWidth
	right.y = screenHeight
	
	local backButton = self:getChild("backButton")
	backButton.y = screenHeight
	
	--page specific stuff
	
	--dot & text coordinate stuff
	local pages = g_episodes[self.episode].pages
	local dot_y = 10
	local dot_spacing = 15
	local first_dot_x = screenWidth * 0.5 - (#pages - 1) * 0.5 * dot_spacing
	local text_y = 0.03 * screenHeight + 12
	
	for i = 1, #pages do
	
		local dot = self:getChild("dot" .. i)
		dot.x = first_dot_x + dot_spacing * (i - 1)
		dot.y = screenHeight - dot_y
		
		local pageNumber = self:getChild("pageNumber" .. i)
		pageNumber.x = dot.x
		pageNumber.y = screenHeight - text_y
		
	end
	
	LevelSelectionRoot.layout(self)
end

function LevelSelection:setEpisode(id)
	self.episode = id
end

------------ Ep3 level selection has golden egg ---
-----------  Returns true if golden egg is found and is being animated
function LevelSelection:checkGoldenEgg(dt,time)
	local egg = self:getChild("GoldenEggEP3")

	-- Episode 3 only! and if egg is actully in place
	if(self.episode ~= 3 or egg == nil) then
		return
	end
	
	-- Timer for locking screen while golden egg is being revealed
	if(self.revealTimer ~= nil and self.revealTimer > 0) then
		self.revealTimer = self.revealTimer - dt
		if(self.revealTimer < 0) then
			self.revealTimer = nil
		end
		return true
	end
	
	if(egg ~= nil) then
		local x = -self:getChild("levelButtons").scrollX
		local GEx = egg.x			
		if x >= GEx - screenWidth * 0.5 then			
			self:getChild("levelButtons"):removeChild(egg)
			-- TODO: level name from table
			eventManager:notify({id = events.EID_GOLDEN_EGG_FROM_MENU, levelName = "LevelGE_6"})
			self.revealTimer = 3
		end
	end
end

function LevelSelection:update(dt, time)
	self:shadeBackground(-self:getChild("levelButtons").scrollX / screenWidth + 1)
	if(self:checkGoldenEgg(dt,time)) then
		return
	end
	
	if g_episodes[self.episode].extra then
		for i = 1, #g_episodes[self.episode].pages do
			for j = 1, #g_episodes[self.episode].pages[i].levels do
				local star_effect = self:getChild("starEffect" .. i .. "-" .. j)
				star_effect.angle = star_effect.angle + dt * 0.6
			end
		end
	end
	
	--deferred scroll to next page
	if self.scroll_to_next_page then
		local scroll = self:getChild("levelButtons")
		scroll:scrollToAnchor(scroll:getCurrentAnchor() + 1)
		self.scroll_to_next_page = false
	end
	
	LevelSelectionRoot.update(self, dt, time)
	
	self:updateSelection()
end

--set background colour to a page's colour, and interpolate between
--adjacent pages' colours when in between them
function LevelSelection:shadeBackground(page)
	local leftSide = _G.math.floor(page)
	local rightSide = leftSide + 1
	local colour = { r = 0, g = 0, b = 0, a = 255 }
	local ep = g_episodes[self.episode]
	
	if page <= 1 then
		--beyond the leftmostpage, use the leftmost colour as is
		colour.r = ep.pages[1].colour.r
		colour.g = ep.pages[1].colour.g
		colour.b = ep.pages[1].colour.b
	elseif page >= #ep.pages then
		--beyond the rightmost page, use the rightmost colour as is
		colour.r = ep.pages[#ep.pages].colour.r
		colour.g = ep.pages[#ep.pages].colour.g
		colour.b = ep.pages[#ep.pages].colour.b
	else
		--somewhere in between the edges, interpolate between colours
		local ml = page - leftSide
		colour.r = ep.pages[leftSide].colour.r + ml * (ep.pages[rightSide].colour.r - ep.pages[leftSide].colour.r)
		colour.g = ep.pages[leftSide].colour.g + ml * (ep.pages[rightSide].colour.g - ep.pages[leftSide].colour.g)
		colour.b = ep.pages[leftSide].colour.b + ml * (ep.pages[rightSide].colour.b - ep.pages[leftSide].colour.b)
	end
	
	self.backgroundColour = colour
end

function LevelSelection:updateSelection(initial_selection)
	local new_index = self.currentSelection
	if not initial_selection then
		new_index = self:getChild("levelButtons"):getCurrentAnchor()
	end
	if self.currentSelection ~= new_index or initial_selection then
		
		settingsWrapper:setCurrentLevelSelectionPage(self.episode, new_index)
		
		local new_dot = self:getChild("dot" .. new_index)
		if new_dot ~= nil then
			self:getChild("dot" .. self.currentSelection):setImage("LS_DOT_BLACK")
			self:getChild("pageNumber" .. self.currentSelection).visible = false
			new_dot:setImage("LS_DOT_WHITE")
			self:getChild("pageNumber" .. new_index).visible = true
			self.currentSelection = new_index
		end
		self:getChild("levelButtons").currentSelection = new_index
	end
end

function LevelSelection:eventTriggered(event)
	
	if event.id == events.EID_SCROLL_TO_NEXT_WORLD and event.episode == self.episode then
		self.scroll_to_next_page = true
	end
	
	if event.id == events.EID_FACEBOOK_LIKE_CLICKED then
		local pages = g_episodes[self.episode].pages
		if self.episode ~= nil then
			for i = 1, #g_episodes[self.episode].pages do
				local page = pages[i]
				
				for j = 1, #page.levels do			
					local button = self:getChild("level" .. i .. "-" .. j)
					if button ~= nil and button.type == "facebook" then
						
						button:setImage(page.level_button, page.level_button)		
						button.returnValue = "GOTO_LEVEL"
						button:getChild("number").visible = true
					end				
				end
			end	
		end
		
	end
	
	-- hide mighty eagle icon from level button if it gets available again
	if event.id == events.EID_MIGHTY_EAGLE_AVAILABLE then
		local pages = g_episodes[self.episode].pages
		if self.episode ~= nil then
			for i = 1, #g_episodes[self.episode].pages do
				local page = pages[i]
				
				for j = 1, #page.levels do			
					local button = self:getChild("level" .. i .. "-" .. j)
					if button ~= nil then
						local eagle = button:getChild("eagle")
						-- set level number visible
						if eagle ~= nil and eagle.visible then
							eagle.visible = false							
							
							local number = button:getChild("number")
							
							if number ~= nil then
								number.visible = true
							end							
						end	
					end				
				end
			end	
		end
	end	
end

LevelScrollFrame = ui.ScrollFrame:new()

function LevelScrollFrame:new(o, episode)
	local o = o or {}
	o.episode = episode
	--if #g_episodes[episode].pages > 1 then
		--o.single_page = false
		return ui.ScrollFrame.new(self, o)
	--else
		--o.single_page = true
		--return ui.Frame.new(self, o)
	--end
end

function LevelScrollFrame:init()

	self.visible_children = {}

	local pages = g_episodes[self.episode].pages

	--page specific stuff
	for i = 1, #g_episodes[self.episode].pages do
	
		local page = pages[i]
	
		if page.layout == "goldeneggs" then
			for j = 1, #page.levels do
				local starEffect = ui.Image:new()
				starEffect.name = "starEffect" .. i .. "-" .. j
				starEffect:setImage("GOLDEN_EGG_STAR_EFFECT")
				self:addChild(starEffect)
			end
		end
		
		for j = 1, #page.levels do			
			self:createLevelButton(i, j, page, page.levels[j])							
		end
		
		if page.layout == "facebook" then
			--add facebook button
			
			local fb_button = ui.ImageButton:new()
			fb_button.name = "fbButton" .. i
			fb_button:setImage("FB_LIKE_BUTTON")
			fb_button.returnValue = "GOTO_FACEBOOK_CONNECT"
			fb_button.activateOnRelease = true
			self:addChild(fb_button)
		end
		
		-- Adds Golden Egg to scroll frame for Episode 3.
		-- TODO: level name used here, get from list index instead.
		if(self.episode == 3 and i == 1 and not settingsWrapper:isGoldenEggUnlocked("LevelGE_6")) then
			local egg = ui.ImageButton:new()
			egg.name = "GoldenEggEP3"
			egg:setImage("GOLDEN_EGG_5")
			self:addChild(egg)
		end
	end
	
	--if not self.single_page then
		ui.ScrollFrame.init(self)
	--else
	--	ui.Frame.init(self)
	--end
	
end

function LevelScrollFrame:createLevelButton(i,j,page,button)
	local levelName = button.name
	local level_button = ui.ImageButton:new()
	
	level_button.name = "level" .. i .. "-" .. j
	level_button.activateOnRelease = true
	
	level_button.onPointerEvent = ui.ScrollFrame.handlePointerEvent
	
	local enabled_button = page.levels[j].level_button_override or page.level_button
	local disabled_button = page.levels[j].disabled_button_override or "LS_LEVEL_BG_NORMAL_CLOSED"
	level_button:setImage(enabled_button, disabled_button)

	local level, _, _, _ = getLevelById(levelName)

	level_button.returnValue = "GOTO_LEVEL"
	level_button.disabledReturnValue = "DISABLED_LEVEL"
	self:addChild(level_button)
	
	
	if page.layout == "grid" or page.layout == "facebook" then
		local level_number = ui.Text:new()
		level_number.name = "number"
		level_number.font = fontBasic
		level_number.text = "" .. j
		level_button:addChild(level_number)

		if page.layout == "facebook" then
			level_button.type = "facebook"
		end

		local eagle = ui.Image:new()
		eagle.name = "eagle"
		eagle:setVisible(false)
		eagle:setImage("LS_EAGLE_BUTTON")
		level_button:addChild(eagle)
		
		local stars = ui.Image:new()
		stars.name = "stars"
		stars:setVisible(false)
		level_button:addChild(stars)
		
		local feather = ui.Image:new()
		feather.name = "feather"
		feather:setVisible(false)
		feather:setImage("LS_EAGLE_FEATHER")
		level_button:addChild(feather)
		
		--<hatchery>
		--[[
		if g_hatcheryCurrencyEnabled then
		
			level_button.hatcheryProgress = 0
		
			local hatcheryProgress = ui.ProgressBar:new()
			hatcheryProgress.name = "hatcheryProgress"
			hatcheryProgress:setImages("STAR_METER_LS_EMPTY", "STAR_METER_LS_FULL")
			hatcheryProgress.visible = false
			level_button:addChild(hatcheryProgress)
		end
		]]--
		--</hatchery>
		
	elseif page.layout == "goldeneggs" then

		local star = ui.Image:new()
		star.name = "star"
		star:setImage(level.completed_sprite_override or page.layout_params.completed_sprite)
		star:setVisible(false)
		level_button:addChild(star)

	end
	
	level_button.meta =
	{
		episode = self.episode,
		page = i,
		level = j,
		levelName = levelName,
		intro_cutscene = level.intro_cutscene,
		flurryId = button.flurryId
	}
	
	
end

function LevelScrollFrame:onEntry()

	refreshEpisodeHatcheryStars(self.episode)

	--if not self.single_page then
		ui.ScrollFrame.onEntry(self)
	--else
	--	ui.Frame.onEntry(self)
	--end
	
	local levels = 0
	for i = 1, #g_episodes[self.episode].pages do
		local page = g_episodes[self.episode].pages[i]
		for j = 1, #page.levels do
			local level_button = self:getChild("level" .. i .. "-" .. j)
			local level = page.levels[j]
			
			if not g_episodes[self.episode].extra then
			
				local level_open
				
				if page.layout == "grid" then
					level_open = settingsWrapper:getLastOpenLevel(self.episode) >= levels + j
				elseif page.layout == "facebook" then
					level_open = settingsWrapper:isFbPageLiked()
				end
			
				if level_open or highscores[level.name] then
					level_button:setEnabled(true)
					level_button:getChild("number").visible = true
					
					if page.layout == "facebook" then
						level_button:setImage(page.level_button, page.level_button)		
						level_button.returnValue = "GOTO_LEVEL"
					end
					
					local score = highscores[level.name]
					local limits = starTable[level.name]
					local level_number = level_button:getChild("number")
					local stars = level_button:getChild("stars")
					local feather = level_button:getChild("feather")
					local eagle = level_button:getChild("eagle")
					
					level_number.visible = true
					eagle.visible = false
					
					--<hatchery>
					--[[
					if g_hatcheryCurrencyEnabled then
						if highscores[level.name] and highscores[level.name].completed then
							local hatcheryProgress = level_button:getChild("hatcheryProgress")

							local hatcheryScore = highscores[level.name].hatcheryStars or 0
							hatcheryProgress.visible = true
							hatcheryProgress:setValue(getHatcheryStarMaximum(level.name) - hatcheryScore)
							hatcheryProgress:setMax(getHatcheryStarMaximum(level.name))
						end
					end
					]]--
					--</hatchery>
					
					if highscores[level.name] and highscores[level.name].score and highscores[level.name].score > 0 and highscores[level.name].completed then
					
						local score = highscores[level.name]
						local limits = starTable[level.name]
						stars.visible = true
						
						if score.score >= limits.goldScore then
							stars:setImage("LS_STARS_3")
						elseif score.score >= limits.silverScore then
							stars:setImage("LS_STARS_2")
						else
							stars:setImage("LS_STARS_1")
						end
					
					elseif highscores[level.name] and (not highscores[level.name].score or (highscores[level.name].score and highscores[level.name].score == 0)) and highscores[level.name].completed then
					
						if settings.eaglesUsedIn then
							for i = 1, #settings.eaglesUsedIn do
								if settings.eaglesUsedIn[i].level == level.name then
									loginfo("eagle used in "..level.name)
									level_number.visible = false
									stars.visible = false
									eagle.visible = true
								end
							end
						end						
					end
					
					if highscores[level.name] and highscores[level.name].eagleScore and highscores[level.name].eagleScore >= 100 then
						feather.visible = true
					end
				else
					if page.layout == "facebook" then 
						level_button:setEnabled(true)
						level_button.returnValue = "SHOW_FACEBOOK_PROMPT"						
						
						level_button:setImage("LS_LEVEL_BG_NORMAL_CLOSED", "LS_LEVEL_BG_NORMAL_CLOSED")	
					else
						level_button:setEnabled(false)
					end
					level_button:getChild("number").visible = false
					level_button:getChild("stars").visible = false
					level_button:getChild("eagle").visible = false
					level_button:getChild("feather").visible = false					
				end
			else
			
				local star_effect = self:getChild("starEffect" .. i .. "-" .. j)
				if settingsWrapper:isGoldenEggUnlocked(level.name) then
					level_button:setEnabled(true)
					level_button:setVisible(true)
					
					star_effect:setVisible(not settingsWrapper:isGoldenEggPlayed(level.name))
					
					local star = level_button:getChild("star")
					if highscores[level.name] and highscores[level.name].completed then
						star:setVisible(true)
					else
						star:setVisible(false)
					end
				else
					level_button:setEnabled(false)
					if level.disabled_button_override == nil then
						level_button:setVisible(false)
					else
						level_button:setVisible(true)
					end
					star_effect.visible = false
				end
			
			end
			
		end
		
		levels = levels + #page.levels
	end
	
	self:refreshVisibleChildren()
end

function LevelScrollFrame:layout()

	--create anchors for scrolling pages
	self.anchors = {}
	local anchorAmount = #g_episodes[self.episode].pages
	
	--HACK
	if self.episode == "G" then
		local have_page_2_egg = false
		for _, v in _G.ipairs(g_episodes[self.episode].pages[2].levels) do
			if settingsWrapper:isGoldenEggUnlocked(v.name) then
				have_page_2_egg = true
			end
		end
		if not have_page_2_egg then
			anchorAmount = 1
		end
	end

	for i = 1, anchorAmount do
		_G.table.insert(self.anchors, i, { (i - 1) * -screenWidth, 0 })
	end
	
	--if not self.single_page then
		ui.ScrollFrame.layout(self)
	--else
	--	ui.Frame.layout(self)
	--end
	
	if(self.episode == 3) then
		local egg = self:getChild("GoldenEggEP3")		
		if(egg ~= nil) then
			local w, h =_G.res.getSpriteBounds(egg.image)
			egg.y = screenHeight * 0.5 - h / 2		
			egg.x = anchorAmount * screenWidth + w * 2		
		end
	end
	
	--if not self.single_page then
		self:setCurrentAnchor(self.currentSelection)
	--end

	for i = 1, #g_episodes[self.episode].pages do
	
		local page = g_episodes[self.episode].pages[i]
	
		--level buttons
		if page.layout == "grid" then
			
			--level positioning
			local y_begin = -0.08 * screenHeight
			local y_line_gap_multiplier = 1.16
			local content_width = 0.83
			local levels_per_page = page.layout_params.cols * page.layout_params.rows
			local x_begin = (i - 1) * screenWidth + 0.5 * screenWidth * (1 - content_width)
			local x_gap = (content_width * screenWidth) / (page.layout_params.cols - 1)
			
			for j = 1, page.layout_params.rows do
				local row_y = screenHeight * (j / (page.layout_params.rows + 2) * y_line_gap_multiplier)
				for k = 1, page.layout_params.cols do
					local level_button = self:getChild("level" .. i .. "-" .. (j - 1) * page.layout_params.cols + k)
					level_button.x = x_begin + x_gap * (k - 1)
					level_button.y = y_begin + row_y
					
					local level_button_width, level_button_height = _G.res.getSpriteBounds(level_button.image)
					
					local stars = level_button:getChild("stars")
					stars.y = level_button_height * 0.5
					
					--<hatchery>
					--[[
					if g_hatcheryCurrencyEnabled then
						local hatcheryProgress = level_button:getChild("hatcheryProgress")
						hatcheryProgress.y = level_button_height * 0.25
					end
					]]--
					--</hatchery>
				end
			end
			
		elseif page.layout == "facebook" then
		
			local fb_button = self:getChild("fbButton" .. i)
			local _, fbh = _G.res.getSpriteBounds(fb_button.image)
			local page_x = (i - 1) * screenWidth + 0.5 * screenWidth
			fb_button.x = page_x
			fb_button.y = screenHeight / 2.75
			
			--level positioning
			
			local lbw, lbh = _G.res.getSpriteBounds(page.level_button)
			
			for j = 1, page.layout_params.levels do
				local level_button = self:getChild("level" .. i .. "-" .. j)
				level_button.x = page_x - ((page.layout_params.levels - 1) * 0.5) * 1.5 * lbw + (j - 1) * 1.5 * lbw
				level_button.y = fb_button.y + fbh / 2.28 + lbh * 0.5
				
				local stars = level_button:getChild("stars")
				stars.y = lbh * 0.5
			end

		elseif page.layout == "goldeneggs" then
		
			for j = 1, #page.levels do
				local level_button = self:getChild("level" .. i .. "-" .. j)
				level_button.x = (i - 1) * screenWidth + (page.levels[j].x or 0.5) * screenWidth
				level_button.y = (page.levels[j].y or 0.5) * screenHeight
				local star_effect = self:getChild("starEffect" .. i .. "-" .. j)
				star_effect.x = level_button.x
				star_effect.y = level_button.y
			end
		
		end
	end
	
	self:refreshVisibleChildren()
end

function LevelScrollFrame:update(dt, time)
	if self.doUpdate ~= nil then
		local sx = self.scrollX
		self:doUpdate(dt, time)
		if sx ~= self.scrollX then
			self:refreshVisibleChildren()
		end
	end
end

--custom draw function for performance reasons
function LevelScrollFrame:draw(x, y, scaleX, scaleY, angle)
	x = x or 0
	y = y or 0
	x = x + self.scrollX
	y = y + self.scrollY
	angle = angle or 0
	x = _G.math.floor(x)
	y = _G.math.floor(y)
	
	for k, v in _G.ipairs(self.visible_images) do
		--local vx = v.x + x
		--local vy = v.y + y
		--local ui_Image_draw = ui.Image.draw
		--if v.visible == true and v.x + x >= -v.w and v.x + x <= screenWidth + 0.5 * v.w then
		local image = v.image
			if image.angle == 0 then
				self:drawImage(image, v.x + x, v.y + y)
			else
				self:drawImageWithAngle(image, v.x + x, v.y + y)
			end
			--for _, v2 in _G.ipairs(v.children) do
				--if v2.draw == ui_Image_draw then
					--image
					--self:drawImage(v2, vx, vy)
				--elseif v2.draw == ui.ProgressBar.draw then
				--	--progress bar
				--	v2:draw(vx, vy, 1, 1, 0)
				--end
			--end
		--end
	end
	
	local current_font = ""
	setRenderState(0,0,1,1,0,0,0)
	for k, v in _G.ipairs(self.visible_text) do
		--local vx = v.x + x
		--local vy = v.y + y
		--if v.visible == true and v.x + x >= -v.w and v.x + x <= screenWidth + 0.5 * v.w then
			--for _, v2 in _G.ipairs(v.children) do
				--if v2.text then
					--if v2.visible then
						local text = v.text
						if current_font ~= text.font then
							setFont(text.font)
							current_font = text.font
						end
						_G.res.drawString("TEXTS_BASIC", text.text, v.x + text.x + x, v.y + text.y + y, text.hanchor, text.vanchor)						
					--end
					--v2:draw(v.x + x, v.y + y, 1, 1, angle + self.angle)
				--end
			--end
		--end
	end
end


function LevelScrollFrame:drawImage(item, x, y)
	if item.visible == true then
		_G.res.drawSprite(item.image, _G.math.floor(item.x + x), _G.math.floor(item.y + y))
	end
end

function LevelScrollFrame:drawImageWithAngle(item, x, y)
	if item.visible == true then
		setRenderState(_G.math.floor(item.x + x), _G.math.floor(item.y + y), 1, 1, item.angle, item.px, item.py)
		_G.res.drawSprite(item.image, 0, 0)
		setRenderState(0, 0, 1, 1, 0, 0, 0)
	end
end

function LevelScrollFrame:refreshVisibleChildren()
	self.visible_images = {}
	self.visible_text = {}
	local x = self.scrollX or 0
	local y = self.scrollY or 0
	local image_index = 1
	local text_index = 1
	for _, v in _G.ipairs(self.children) do
		if v.visible == true and v.x + x >= -v.w and v.x + x <= screenWidth + 0.5 * v.w then
			self.visible_images[image_index] = { x = 0, y = 0, image = v }
			image_index = image_index + 1
			for _, v2 in _G.ipairs(v.children) do
				if v2.text == nil and v2.visible then
					self.visible_images[image_index] = { x = v.x, y = v.y, image = v2 }
					image_index = image_index + 1
				elseif v2.text ~= nil and v2.visible then
					self.visible_text[text_index] = { x = v.x, y = v.y, text = v2 }
					text_index = text_index + 1
				end
			end
		end
	end
end

function LevelScrollFrame:onPointerEvent(eventType, x, y)
	--if not self.single_page then
		return ui.ScrollFrame.onPointerEvent(self, eventType, x, y)
	--else
	--	return ui.Frame.onPointerEvent(self, eventType, x, y)
	--end
end

filename="level_selection.lua"
