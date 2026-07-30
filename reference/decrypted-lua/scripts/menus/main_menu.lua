MainMenuRoot = ui.Frame:new()
g_bird_animations = {}
g_bird_sprites = {}

function MainMenuRoot:onEntry()
	ui.Frame.onEntry(self)
	
	self:buildBirdList()
end

function MainMenuRoot:buildBirdList()
	g_bird_sprites = {}
	
	--sprites for birds and ME sardine tin
	local tutorials = settingsWrapper:getTutorials()
	for k, v in _G.pairs(tutorials) do
		if k == "BAIT_SARDINE" then
			_G.table.insert(g_bird_sprites, { sprite = k , reward = 1 })
		else
			_G.table.insert(g_bird_sprites, { sprite = k , reward = 0 })
		end
	end
	
	--if no sprites, add the red bird
	if #g_bird_sprites == 0 then
		_G.table.insert(g_bird_sprites, { sprite = "BIRD_RED", reward = 0 })
	end
	
	--sprites for completing worlds and three starring episodes
	local total_worlds = 0
	for i = 1, #g_episodes do
		for j = 1, #g_episodes[i].pages do
			if not g_episodes[i].pages[j].extra then
				total_worlds = total_worlds + 1
			end
		end
		
		if settingsWrapper:isEpisodeThreeStarred(i) then
			_G.table.insert(g_bird_sprites, { sprite = "REWARD_" .. i .. "_STAR", reward = 1 })
			_G.table.insert(g_bird_sprites, { sprite = "REWARD_" .. i .. "_STAR", reward = 1 })
		elseif settingsWrapper:isThemeCompleted(total_worlds) then
			_G.table.insert(g_bird_sprites, { sprite = "REWARD_" .. i, reward = 1 })
			_G.table.insert(g_bird_sprites, { sprite = "REWARD_" .. i, reward = 1 })
		end
	end
	
	local feathers, max_feathers = calculateAllFeathers()
	-- same amount of feathers that is required for Feather Gatherer achievement
	if feathers >= 200 then
		_G.table.insert(g_bird_sprites, { sprite = "REWARD_EAGLE", reward = 1 })
		_G.table.insert(g_bird_sprites, { sprite = "REWARD_EAGLE", reward = 1 })
	end
	
end

function MainMenuRoot:layout()
	--calculate stuff for drawing the scrolling ingame backgorund graphics
	self.current_zoom_level = settingsWrapper:getCurrentZoomLevelMainMenu()
	self.current_theme = settingsWrapper:getCurrentMainMenuTheme()

	local bW, bH = _G.res.getSpriteBounds("BUTTON_EMPTY")
	local topCamera = (-2 * screenHeight) / (screenHeight / (450 * self.current_zoom_level * 0.605)) + ((bH * 2.15) / (screenHeight / (450 * self.current_zoom_level * 0.5)))
	local worldScale = (0.5 * screenHeight / 400) / (self.current_zoom_level * 0.66)
	self.camera_top = topCamera
	
	setWorldScale(worldScale)
	setTheme(self.current_theme)
	
	ui.Frame.layout(self)
end

function MainMenuRoot:draw(x, y, scaleX, scaleY, angle)
	self:drawSelf()
	
	ui.Frame.draw(self, x, y, scaleX, scaleY, angle)
end

function MainMenuRoot:drawSelf()
	if not settingsWrapper:isGfxLowQuality() then
		drawBackgroundNative()
	end
	
	self:drawBirds()
	
	--draw foreground (ground, cranes)
	drawForegroundNative()
end

function MainMenuRoot:drawBirds()
	for k, v in _G.pairs(g_bird_animations) do
		if v.layer == 3 then
			local scale = v.scale * 0.45
			setRenderState(0, 0, scale, scale, v.angle, _G.res.getSpritePivot(v.sheet, v.sprite))
			_G.res.drawSprite(v.sheet, v.sprite, _G.math.floor(v.x/scale), _G.math.floor(v.y/scale - screenHeight * 0.2 / v.scale))
		end
	end	

	for k, v in _G.pairs(g_bird_animations) do
		if v.layer == 4 then
			local scale = v.scale * 0.6
			setRenderState(0, 0, scale, scale, v.angle, _G.res.getSpritePivot(v.sheet, v.sprite))
			_G.res.drawSprite(v.sheet, v.sprite, _G.math.floor(v.x/scale), _G.math.floor(v.y/scale - screenHeight * 0.125 / v.scale))
		end
	end		
	
	for k, v in _G.pairs(g_bird_animations) do
		if v.layer == 5 then
			local scale = v.scale * 0.75
			setRenderState(0, 0,scale, scale, v.angle, _G.res.getSpritePivot(v.sheet, v.sprite))
			_G.res.drawSprite(v.sheet, v.sprite, _G.math.floor(v.x/scale), _G.math.floor(v.y/scale))
		end
	end
end

function MainMenuRoot:update(dt, time)
    ui.Frame.update(self, dt, time)
	setTopLeft(50 * time, self.camera_top)
	self:animateBirds(dt)
	
	if _G.res.isAudioPlaying(currentMainMenuSong) == false and currentMainMenuSong ~= nil then
		_G.res.playAudio(currentMainMenuSong, 0.8, true, 7)
	end
end

function MainMenuRoot:animateBirds(dt)
	local itemsPerCategory = 0.75
	local itemsInTotal = #g_bird_sprites * itemsPerCategory
	
	if #g_bird_animations < itemsInTotal and _G.math.random(1,5) == 1 then
		local layer = _G.math.random(3, 5)
		local tx = _G.math.random(-screenWidth * 0.75, screenWidth * 0.75)
		local ty = screenHeight + 30*screenHeight / 320
		
		local scale = layer * 0.2
		local txVel = _G.math.random(100, 350) * scale * (screenWidth / 480 + 1) / 2
		local tyVel = _G.math.random(-400, -150) * scale * (screenHeight / 320 + 1) / 2
		
		if layer == 1 then
			tyVel = tyVel * 1.75 
			txVel = txVel * 1.75 
		end		
		
		local tempBirdSprite = g_bird_sprites[_G.math.random(#g_bird_sprites)]
		local sprite = tempBirdSprite.sprite
		local reward = tempBirdSprite.reward
		local angleSpeed = 0
		
		local _, spriteHeight = _G.res.getSpriteBounds("", sprite)
		if reward == 1 then
			angleSpeed = _G.math.random() * _G.math.pi * 1.5
		elseif reward == 2 then
			tx = _G.math.random(screenWidth * 0.1, screenWidth * 0.9)
			tyVel = _G.math.random(-250, -150) * scale * (screenHeight / 320 + 1) * 0.175
			txVel = 0
		end

		_G.table.insert(g_bird_animations, { sprite = sprite, angle = 0, angleSpeed = angleSpeed, x = tx, y = ty, xVel = txVel, yVel = tyVel, scale = scale, layer = layer, spriteHeight = spriteHeight, reward = reward} )
	end

	for i = #g_bird_animations, 1, -1 do
		local v = g_bird_animations[i]
		if v.reward == 2 then -- balloon movement
			v.angle = _G.math.sin(v.angleSpeed) * 0.15
			v.angleSpeed = (v.angleSpeed + dt * 2) % (_G.math.pi * 2)
			v.x = v.x - v.angle * v.layer / 2
		else
			v.yVel = v.yVel + 150*dt
			v.angle = v.angle + v.angleSpeed * dt
		end
		v.x = v.x + v.xVel * dt
		v.y = v.y + v.yVel * dt
		
		if v.y > screenHeight + 50 * screenHeight / 320 or ((v.reward == 2 or v.reward == 2) and v.y < -v.spriteHeight) then
			_G.table.remove(g_bird_animations, i)
		end 
		
	end
end

MainMenuSlider = BackgroundBox:new()

function MainMenuSlider:init()
	BackgroundBox.init(self)
	self.state = "CLOSED"
	self.slide_amount = 0
	self.components =
	{
		topLeft = "MENU_SLIDER_BG_TOP_LEFT",
		left = "MENU_SLIDER_BG_LEFT",
		bottomLeft = "MENU_SLIDER_BG_BOTTOM_LEFT",
		bottomMiddle = "MENU_SLIDER_BG_BOTTOM_MIDDLE",
		bottomRight = "MENU_SLIDER_BG_BOTTOM_RIGHT",
		right = "MENU_SLIDER_BG_RIGHT",
		topRight = "MENU_SLIDER_BG_TOP_RIGHT",
		topMiddle = "MENU_SLIDER_BG_TOP_MIDDLE",
		center = "MENU_SLIDER_BG_CENTER",
	}
	self.hanchor = "HCENTER"
	self.vanchor = "BOTTOM"
	self.element_width = 0
	self.element_height = 0
	self.element_gap = 0
	self.bottom_margin = 0
	self.width = 0
	self.height = 0
end

function MainMenuSlider:onEntry()
	BackgroundBox.onEntry(self)
	self.height = 0
	self.state = "CLOSED"
end

function MainMenuSlider:toggle()
	if self.state == "OPEN" or self.state == "OPENING" then
		self.state = "CLOSING"
	elseif self.state == "CLOSED" or self.state == "CLOSING" then
		self.state = "OPENING"
	end
end

function MainMenuSlider:update(dt, time)

	local total_height = #self.children * self.element_height + (#self.children - 1) * self.element_gap + self.bottom_margin

	if self.state == "OPENING" then
		self.height = self.height + dt * screenHeight * 0.8
		if self.height >= total_height then
			self.height = total_height
			self.state = "OPEN"
		end
	elseif self.state == "CLOSING" then
		self.height = self.height - dt * screenHeight * 0.8
		if self.height < 0 then
			self.height = 0
			self.state = "CLOSED"	
		end
	end
	
	if self.state == "OPEN" or self.state == "CLOSING" or self.state == "CLOSED" then
		for i = 1, #self.children do
			self.children[i].y = -self.height + (i - 1) * (self.element_gap + self.element_height) + self.element_height * 0.5
			if self.children[i].y >= 0 then
				self.children[i].y = 0
			end
		end
	elseif self.state == "OPENING" then
		for i = 1, #self.children do
			self.children[i].y = -total_height + (i - 1) * (self.element_gap + self.element_height) + self.element_height * 0.5
			if -self.children[i].y > self.height then
				self.children[i].y = 0
			end
		end
	end

	BackgroundBox.update(self, dt, time)
end

function MainMenuSlider:onPointerEvent(eventType, x, y)
	local result, meta, item = BackgroundBox.onPointerEvent(self, eventType, x, y)
	
	if self.state == "OPEN" then
		return result, meta, item
	end
	
	return nil, nil, nil
end

ToggleIndicator = ui.Image:new()

function ToggleIndicator:init()
	ui.Image.init(self)
	self.state = "CLOSED"
end

function ToggleIndicator:onEntry()
	ui.Image.onEntry(self)
	self.state = "CLOSED"
end

function ToggleIndicator:toggle()
	if self.state == "OPEN" or self.state == "OPENING" then
		self.state = "CLOSING"
	elseif self.state == "CLOSED" or self.state == "CLOSING" then
		self.state = "OPENING"
	end
end

function ToggleIndicator:update(dt, time)
	if self.state == "OPENING" then
		self.angle = self.angle + dt * 16
		if self.angle >= 3.14159 then
			self.angle = 3.14159
			self.state = "OPEN"
		end
	elseif self.state == "CLOSING" then
		self.angle = self.angle - dt * 16
		if self.angle < 0 then
			self.angle = 0
			self.state = "CLOSED"	
		end
	end
end

MainMenu = MainMenuRoot:new()

function MainMenu:init()

    MainMenuRoot.init(self)

	local play_button = BackgroundBox:new()
	play_button.name = "playButton"
	play_button.components = { left = "PLAY_BUTTON_BG_LEFT", center = "PLAY_BUTTON_BG_MIDDLE", right = "PLAY_BUTTON_BG_RIGHT", }
	play_button.hanchor = "HCENTER"
	play_button.vanchor = "VCENTER"
	play_button.onPointerEvent = function(self, eventType, x, y)
		if eventType == "LRELEASE" and
		   x >= self.x - self.width * 0.5 and
		   x <= self.x + self.width * 0.5 and
		   y >= self.y - self.height * 0.5 and
		   y <= self.y + self.height * 0.5 then
			_G.res.playAudio("menu_confirm", 1, false)
			return "PLAY", nil, self
		end
	end
	self:addChild(play_button)
	
	local play_text = ui.ImageButton:new()
	play_text.name = "playText"
	play_text.returnValue = "GOTO_EPISODE_SELECTION"
	play_text.clickSound = "menu_confirm"
	play_button:addChild(play_text)
	
	local game_logo = ui.Image:new()
	game_logo.name = "gameLogo"
	game_logo:setImage("MENU_LOGO")
	self:addChild(game_logo)
	
	local options_slider = MainMenuSlider:new()
	options_slider.name = "optionsSlider"
	self:addChild(options_slider)

	local options_button = ui.ImageButton:new()
	options_button.name = "optionsButton"
	options_button:setImage("BUTTON_EMPTY")
	options_button.returnValue = "TOGGLE_OPTIONS"
	self:addChild(options_button)
	
	local options_image = ToggleIndicator:new()
	options_image.name = "optionsImage"
	options_image:setImage("BUTTON_OPTIONS")
	options_button:addChild(options_image)
	
	self:createOptionsSliderButtons(options_slider)
	
	local external_slider = MainMenuSlider:new()
	external_slider.name = "externalSlider"
	self:addChild(external_slider)
	
	local external_button = ui.ImageButton:new()
	external_button.name = "externalButton"
	external_button:setImage("BUTTON_EMPTY")
	external_button.returnValue = "TOGGLE_EXTERNAL"
	self:addChild(external_button)
	
	local external_image = ToggleIndicator:new()
	external_image.name = "externalImage"
	external_image:setImage("BUTTON_SLIDER")
	external_button:addChild(external_image)
	
	self:createExternalSliderButtons(external_slider)
	
	self.mid_buttons = {}

	local eagle_button = ui.ImageButton:new()
	eagle_button.name = "eagleButton"
	eagle_button:setImage("BUTTON_EAGLE_BUY")
	eagle_button.returnValue = "GOTO_EAGLE_PAGE"
	eagle_button.visible = false
	eagle_button.clickSound = "menu_confirm"
	self:addChild(eagle_button)
	
	if not releaseBuild and showEditor then
		local editor_button = ui.ImageButton:new()
		editor_button.name = "editorButton"
		editor_button:setImage("BUTTON_EMPTY")
		editor_button.returnValue = "GOTO_EDITOR"
		self:addChild(editor_button)
		
		local editor_text = ui.Text:new()
		editor_text.name = "editorText"
		editor_text.text = "EDITOR"
		editor_text.font = fontBasic
		editor_text.scaleX = 0.75
		editor_text.scaleY = 0.75
		editor_button:addChild(editor_text)
	end
	
	--<gamecenter>
	if gameCenterSupported or (not releaseBuild and iOS) then
		self:initGameCenter()
	end
	--</gamecenter>
	if ABIDEnabled then
		local ABID_button = ui.ImageButton:new({name = "ABID_button", returnValue = "ABID_CLICKED"})
		ABID_button:setImage("BUTTON_EMPTY")
		self:addChild(ABID_button)	
		
		local ABID_text = ui.Text:new({name = "ABID_text" , font = "FONT_BASIC", text = "ABID"})
		ABID_text:clip()
		
		ABID_button:addChild(ABID_text)
	end
	
	
end

function MainMenu:createOptionsSliderButtons(slider)
	if g_allowLowQualityGraphics then
		local quality_button = ui.ToggleButton:new()
		quality_button.name = "qualityButton"
		quality_button:setImage({ "BUTTON_LQ", "BUTTON_LOW_QUALITY" })
		quality_button.returnValue = "TOGGLE_QUALITY"
		slider:addChild(quality_button)
	end

	local credits_button = ui.ImageButton:new()
	credits_button.name = "creditsButton"
	credits_button:setImage("BUTTON_ABOUT_SMALL")
	credits_button.returnValue = "GOTO_CREDITS"
	credits_button.clickSound = "menu_confirm"
	slider:addChild(credits_button)
	
	local sound_button = ui.ToggleButton:new()
	sound_button.name = "soundButton"
	sound_button:setImage({ "BUTTON_SOUNDS_SMALL", "BUTTON_MAINMENU_SFX_OFF" })
	sound_button.returnValue = "TOGGLE_SOUND"
	slider:addChild(sound_button)
end

function MainMenu:createExternalSliderButtons(slider)

	if not applyChinaRestictions then
		local youtube_button = ui.ImageButton:new()
		youtube_button.name = "youtubeButton"
		youtube_button:setImage("BUTTON_TRAILER_SMALL")
		youtube_button.returnValue = "GOTO_TRAILER"
		slider:addChild(youtube_button)
	end
	
	if isEagleEnabled() then
		local eagle_trailer_button = ui.ImageButton:new()
		eagle_trailer_button.name = "eagleTrailerButton"
		eagle_trailer_button:setImage("BUTTON_MEVIDEO")
		eagle_trailer_button.returnValue = "GOTO_EAGLE_TRAILER"
		slider:addChild(eagle_trailer_button)
	end
	
	if not applyChinaRestictions then
		local facebook_button = ui.ImageButton:new()
		facebook_button.name = "facebookButton"
		facebook_button:setImage("BUTTON_FACEBOOK_SMALL")
		facebook_button.returnValue = "GOTO_FACEBOOK"
		slider:addChild(facebook_button)
		
		local twitter_button = ui.ImageButton:new()
		twitter_button.name = "twitterButton"
		twitter_button:setImage("BUTTON_TWITTER_SMALL")
		twitter_button.returnValue = "GOTO_TWITTER"
		slider:addChild(twitter_button)
	end
	
	if g_crystalEnabled then
		local crystal_button = ui.ImageButton:new()
		crystal_button.name = "crystalButton"
		crystal_button:setImage("BUTTON_CRYSTAL_SMALL")
		crystal_button.returnValue = "GOTO_CRYSTAL"
		slider:addChild(crystal_button)
	end
end

function MainMenu:onEntry()
    MainMenuRoot.onEntry(self)
    
    eventManager:notify({ id = events.EID_MAIN_MENU_ENTERED, })
	
	--change the play button sprite depending on the localte
	local play_button = self:getChild("playButton")
	local play_text = play_button:getChild("playText")
	
	local play_sprite = _G.res.getString("TEXTS_BASIC", "TEXT_PLAY_SPRITE")
	play_text:setImage(play_sprite)
	
	self:refreshMiddleButtons()
	
	local audio_button = self:getChild("optionsSlider"):getChild("soundButton")
	if settingsWrapper:isAudioEnabled() then
		audio_button:setState(1)
	else
		audio_button:setState(2)
	end

end

function MainMenu:refreshMiddleButtons()
	--reset list of middle buttons
	self.mid_buttons = {}
	
	--eagle is enabled but not bought
	if isIapEnabled() and not settingsWrapper:isMightyEagleEnabled() then
		_G.table.insert(self.mid_buttons, "eagleButton")
		self:getChild("eagleButton").visible = true
	else
		self:getChild("eagleButton").visible = false
	end
	
	--<gamecenter>
	if gameCenterSupported or (not releaseBuild and iOS) then
		self:refreshGameCenterButtons()
	end
	--</gamecenter>
	
	self:layout()
end

function MainMenu:layout()
    MainMenuRoot.layout(self)

	local play_button = self:getChild("playButton")
	play_button.x = screenWidth * 0.5
	play_button.y = screenHeight * 0.555
	
	local play_sprite = _G.res.getString("TEXTS_BASIC", "TEXT_PLAY_SPRITE")
	local sw, sh = _G.res.getSpriteBounds(play_sprite)
	play_button.width = sw
	play_button.height = sh * 1.7
	
	local game_logo = self:getChild("gameLogo")
	game_logo.x = screenWidth * 0.5
	game_logo.y = screenHeight * 0.021875
	
	local button_w, button_h = _G.res.getSpriteBounds("BUTTON_EMPTY")
	
	local slider_button_w, slider_button_h = _G.res.getSpriteBounds("BUTTON_ABOUT_SMALL")
	
	--left slider
	local options_slider = self:getChild("optionsSlider")
	options_slider.x = button_w * 0.55
	options_slider.y = screenHeight - button_h * 0.55
	options_slider.width = button_w * 0.5
	options_slider.bottom_margin = button_h * 0.5
	options_slider.element_height = slider_button_h
	
	local options_button = self:getChild("optionsButton")
	options_button.x = button_w * 0.55
	options_button.y = screenHeight - button_h * 0.55
	
	--right slider
	local external_slider = self:getChild("externalSlider")
	external_slider.x = screenWidth - button_w * 0.55
	external_slider.y = screenHeight - button_h * 0.55
	external_slider.width = button_w * 0.5
	external_slider.bottom_margin = button_h * 0.5
	external_slider.element_height = slider_button_h
	
	local external_button = self:getChild("externalButton")
	external_button.x = screenWidth - button_w * 0.55
	external_button.y = screenHeight - button_h * 0.55
	
	--middle buttons
	local x_spacing = sw * 0.55
	local x_first = screenWidth * 0.5 - (#self.mid_buttons - 1) * 0.5 * x_spacing
	
	for i, button_name in _G.ipairs(self.mid_buttons) do
		local button = self:getChild(button_name)
		button.x = x_first + x_spacing * (i - 1)
		button.y = screenHeight - button_h * 0.55
	end
	
	if not releaseBuild and showEditor then
		local editor_button = self:getChild("editorButton")
		editor_button.x = screenWidth * 0.75
		editor_button.y = screenHeight * 0.7
	end
	
	if ABIDEnabled then
		local ABID_button = self:getChild("ABID_button")
		ABID_button.x = options_slider.x + options_slider.width * 2
		ABID_button.y = options_slider.y 
		
		local ABID_text = self:getChild("ABID_text")
		ABID_text:clip()
		ABID_text.x = 0		
		ABID_text.y = 0
		
	end
	
end

function MainMenu:update(dt, time)
	MainMenuRoot.update(self, dt, time)
	
	--<gamecenter>
	if gameCenterSupported or (not releaseBuild and iOS) then
		self:updateGameCenter(dt, time)
	end
	--</gamecenter>
end

function MainMenu:onKeyEvent(eventType, key)
	if key == "BACK" then
		eventManager:notify({id = events.EID_EXIT_GAME})
	end
end

function MainMenu:onPointerEvent(eventType, x, y)
	local result, meta, item = MainMenuRoot.onPointerEvent(self, eventType, x, y)
	
	if result == "PLAY" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "EPISODE_SELECTION", from = "MAIN_MENU", })
	elseif result == "GOTO_CREDITS" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "CREDITS", from = "MAIN_MENU", })
	elseif result == "GOTO_EAGLE_PAGE" then
		eventManager:notify({ id = events.EID_MIGHTY_EAGLE_BUTTON_CLICKED, from = "MAIN_MENU", })
	elseif result == "GOTO_EDITOR" then
		menuManager:changeRoot(EditorPage:new())
	elseif result == "GOTO_ACHIEVEMENTS" then
		self:gotoAchievements()
	elseif result == "GOTO_LEADERBOARDS" then
		self:gotoLeaderboards()
	elseif result == "TOGGLE_OPTIONS" then
		self:getChild("optionsSlider"):toggle()
		self:getChild("optionsButton"):getChild("optionsImage"):toggle()
	elseif result == "TOGGLE_EXTERNAL" then
		self:getChild("externalSlider"):toggle()
		self:getChild("externalButton"):getChild("externalImage"):toggle()
	elseif result == "TOGGLE_SOUND" then
		changeAudio()
	elseif result == "TOGGLE_QUALITY" then
		changeGFXQuality()
	elseif result == "GOTO_TRAILER" then
		gotoAngryBirdsTrailer()
	elseif result == "GOTO_EAGLE_TRAILER" then
		gotoMightyEagleTrailer()
	elseif result == "GOTO_FACEBOOK" then
		gotoFacebook()
	elseif result == "GOTO_TWITTER" then
		gotoTwitter()
	elseif result == "ABID_CLICKED" then
		eventManager:notify({id = events.EID_ABID_CLICKED})	
	elseif result == "GOTO_CRYSTAL" then
		startCrystal()
	else
		for i = 1, #g_bird_animations do
			if g_bird_animations[i].layer == 5 then
				g_bird_animations[i].renderState = true
				if self:checkBirdBounds(g_bird_animations[i], cursor.x, cursor.y) 
				   and g_bird_animations[i].yelling ~= true 
				   and _G.string.sub(g_bird_animations[i].sprite, 1, 4) == "BIRD" then
					local bird_sprite_sound_mapping =
					{
						BIRD_RED = "bird_01_flying",
						BIRD_BLUE = "bird_02_flying",
						BIRD_YELLOW = "bird_03_flying",
						BIRD_GREY = "bird_04_flying",
						BIRD_GREEN = "bird_05_flying",
						BIRD_BIG_BROTHER = "big_brother_flying",
						BIRD_BOOMERANG = "bird_06_flying",
						BIRD_PUFFER_1 = "Globe_Bird_Launch_3",
					}
					g_bird_animations[i].yelling = true
					_G.res.playAudio(bird_sprite_sound_mapping[g_bird_animations[i].sprite], 1.0, false, 0)
					g_bird_animations[i].sprite = g_bird_animations[i].sprite .. "_YELL"
				end
			end
		end
	end
	
	return nil, nil, nil
end

function MainMenu:checkBirdBounds(bird, x, y)
	local width, height = _G.res.getSpriteBounds(bird.sprite)
	local pivotX, pivotY = _G.res.getSpritePivot(bird.sprite)
	
	local scaleCorrectionX, scaleCorrectionY = 0, 0
	local xs, ys = bird.xs or 1, bird.ys or 1
	if bird.scale ~= nil then
		xs, ys = bird.scale, bird.scale
	end
	
	if xs ~= 1 then
		scaleCorrectionX = ((width * xs) - width) / 2
	end
	
	if ys ~= 1 then
		scaleCorrectionY = ((height * ys) - height) / 2
	end

	return y >= (bird.y - pivotY - scaleCorrectionY) and y <= (bird.y - pivotY + height + scaleCorrectionY) and
	       x >= (bird.x - pivotX - scaleCorrectionX) and x <= (bird.x - pivotX + width + scaleCorrectionX)
end

MainMenuEaglePage = MainMenuRoot:new()

function MainMenuEaglePage:init()
	local eagle_frame = MEPage:new()
	self:addChild(eagle_frame)
end

function MainMenuEaglePage:onEntry()
	ui.Frame.onEntry(self)
end

function MainMenuEaglePage:onPointerEvent(eventType, x, y)
	local result, meta, item = ui.Frame.onPointerEvent(self, eventType, x, y)
	
	if result == "CLOSE" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "MAIN_MENU", })
	elseif result == "EAGLE_PURCHASE_CLICKED" then
		goToMightyEaglePaymentPage()
	end
	
	return result, meta, item
end

MainMenuEaglePurchasePage = MainMenuRoot:new()

function MainMenuEaglePurchasePage:init()
	local purchase_frame = EaglePurchasePage:new()
	self:addChild(purchase_frame)
end

filename="main_menu.lua"
