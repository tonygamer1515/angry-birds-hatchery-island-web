------------------------------
-- LEVEL END ROOT
------------------------------

LevelEndRoot = ui.Frame:new()

function LevelEndRoot:onEntry()
	ui.Frame.onEntry(self)
end

function LevelEndRoot:update(dt, time)
	ui.Frame.update(self, dt, time)
end

function LevelEndRoot:draw(x, y, scaleX, scaleY)
	drawGame()
	ui.Frame.draw(self, self.x + x, self.y + y, scaleX, scaleY)
end

function LevelEndRoot:onExit()
	_G.res.stopAllAudio()
	ui.Frame.onExit(self)
end

function LevelEndRoot:onPointerEvent(eventType, x, y)
	local result, meta, item = ui.Frame.onPointerEvent(self, eventType, x, y)
	
	if result == "CLOSE" then
		--close eagle page
		eventManager:queueEvent({id = events.EID_MIGHTY_EAGLE_PURCHASE_CLOSE_CLICKED, from = "LEVEL_FAILED", })
	elseif result == "EAGLE_PURCHASE_CLICKED" then
		goToMightyEaglePaymentPage()
	end
	
	return result, meta, item
end

------------------------------
-- PIGGY BANK BOX
------------------------------

PiggyBank = ui.Image:new()

function PiggyBank:new(stars, o)
	local o = o or {}
	o.stars = stars or 0
	return ui.Image.new(self, o)
end

function PiggyBank:init()

	ui.Image.init(self)

	self:setImage("BG_STAR_COUNTER")
	self:addChild(boxRight)
	
	local piggyBank = ui.Image:new()
	piggyBank.name = "piggyBank"
	piggyBank:setImage("PIGGY_STAR_BANK")
	self:addChild(piggyBank)
	
	local star_amount = ui.Text:new()
	star_amount.name = "starAmount"
	star_amount.font = "FONT_MENU"
	star_amount.text = "" .. self.stars
	star_amount.hanchor = "HCENTER"
	star_amount.vanchor = "VCENTER"
	star_amount.scaleX = 0.4
	star_amount.scaleY = 0.4
	self:addChild(star_amount)
	
end

function PiggyBank:setStars(stars)
	self.stars = stars
	self:getChild("starAmount").text = "" .. self.stars
end

function PiggyBank:layout()

	ui.Image.layout(self)
	
	local box_w, box_h = _G.res.getSpriteBounds(self.image)
	
	local piggy_bank = self:getChild("piggyBank")
	piggy_bank.x = -0.275 * box_w
	
	local star_amount = self:getChild("starAmount")
	star_amount.x = 0.175 * box_w

end

------------------------------
-- LEVEL END SCREEN BASECLASS
------------------------------

LevelEnd = ui.Frame:new()

function LevelEnd:init()

	local page_title = ui.Text:new()
	page_title.name = "pageTitle"
	page_title.font = fontBasic
	page_title.hanchor = "HCENTER"
	page_title.vanchor = "VCENTER"
	page_title.text = ""
	self:addChild(page_title)
	self.shade = 0
	self.name = "LevelEnd"
	
	for i = 1, 3 do
		local button = ui.ImageButton:new()
		button.name = "button" .. i
		button:setVisible(false)
		button.activateOnRelease = true
		self:addChild(button)
	end
	
	self.shake_offset_x = 0
	self.shake_offset_y = 0

	ui.Frame.init(self)
end

function LevelEnd:drawBackground()
	setRenderState(0, 0, 1, 1, 0, 0, 0)
	drawRect(0, 0, 0, self.shade, 0, 0, screenWidth, screenHeight, true)
	drawRect(0, 0, 0, self.shade / 0.65, screenWidth * 0.3 + self.shake_offset_x, 0, screenWidth * 0.7 + self.shake_offset_x, screenHeight, true)
end

function LevelEnd:onEntry()
	ui.Frame.onEntry(self)
end



function LevelEnd:layout()
	local page_title = self:getChild("pageTitle")

	page_title.x = screenWidth * 0.5
	page_title.y = screenHeight * (self.title_y or 0.125)
	if page_title.textBoxSize ~= 0.4 * screenWidth - ((0.4 * screenWidth) % 8) then
		page_title.textBoxSize = 0.4 * screenWidth - ((0.4 * screenWidth) % 8)
		page_title:clip()
	end
	
	if self.buttons == 1 or self.buttons == 3 then
		for i = 1, 3 do
			local button = self:getChild("button" .. i)
			button.x = screenWidth * 0.5 + (i - 2) * screenWidth * 0.125
			button.y = screenHeight * (self.button_y or 0.85)
		end
	elseif self.buttons == 2 then
		for i = 1, 2 do
			local button = self:getChild("button" .. i)
			button.x = screenWidth * 0.5 + (i - 1.5) * screenWidth * 0.125
			button.y = screenHeight * (self.button_y or 0.85)
		end
	end

	ui.Frame.layout(self)
end



function LevelEnd:onPointerEvent(eventType, x, y)
	local result, meta = ui.Frame.onPointerEvent(self, eventType, x, y)
	
	if result == "RETURN_TO_LEVEL_SELECTION" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_" .. currentThemeNumber })
	elseif result == "RESTART_LEVEL" then
		local _, episode, page, level = getLevelById(self.level)
		
		if meta and meta.failed then
			levelRestartedFrom = "failed menu"
		elseif meta and meta.completed then
			levelRestartedFrom = "complete menu"		
		end
		-- listened by at least flurry
		if episode ~= "G" then
			eventManager:notify({id = events.EID_LEVEL_RESTARTED, 
								currentWorldNumber = currentWorldNumber, 
								currentLevelNumberInTheme = currentLevelNumberInTheme,
								numberOfAttemptsInLevel = numberOfAttemptsInLevel,
								birdsShot = birdsShot,
								birdsCounter = birdsCounter,
								levelRestartedFrom = levelRestartedFrom										
							})		
							
		elseif episode == "G" then
			eventManager:notify({id = events.EID_GE_LEVEL_RESTARTED, levelName = self.level})	
		end
		
		local data =
		{
			episode = episode,
			page = page,
			level = level,
			levelName = self.level,
		}
		eventManager:notify({ id = events.EID_CHANGE_LEVEL, data = data })
	elseif result == "NEXT_LEVEL" then
		local next_level = getNextLevel(self.level)
		local data, episode, page, level = getLevelById(next_level)
		local meta =
		{
			episode = episode,
			page = page,
			level = level,
			levelName = next_level,
		}
		eventManager:notify({ id = events.EID_CHANGE_LEVEL, data = meta })
	elseif result == "PLAY_CUTSCENE" then
		eventManager:notify({ id = events.EID_LOAD_END_CUTSCENE, cutscene = meta.cutscene, episode = meta.episode, page = meta.page, level_index = meta.level })
	elseif result == "MIGHTY_EAGLE" then
		-- TODO: this is ugly
		--FTFY
		--self.visible = false
		eventManager:notify({id = events.EID_MIGHTY_EAGLE_BUTTON_CLICKED, from = "LEVEL_FAILED"}) 
		
		--eventManager:notify({id = events.EID_PUSH_FRAME, target = MEPage:new({from = "LEVEL_FAILED", shade = 0.65})})
	elseif result == "NEXT_SCREEN" then
		eventManager:notify({ id = events.EID_POP_FRAME })
		eventManager:notify({ id = events.EID_PUSH_FRAME, target = meta.next_screen })
	elseif result == "NEXT_CHALLENGE_LEVEL" then
		eventManager:notify({ id = events.EID_START_NEXT_CHALLENGE_LEVEL, challenge = self.challenge, progress = self.challenge_progress })
	elseif result == "RETURN_TO_CHALLENGE_SELECTION" then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "CHALLENGE_PAGE", from = "CHALLENGE_COMPLETE" })								
	elseif result == "RESTART_CHALLENGE" then
		eventManager:notify({ id = events.EID_CHALLENGE_STARTED, challenge = self.challenge })
	elseif result == "MIGHTY_EAGLE_DISABLED" then
		self:showEagleDisabledTimer()
	end
	
	return result, meta
end

function LevelEnd:onKeyEvent(event, key)
	if key == "BACK" and not self.no_back_key then
		eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "LEVEL_SELECTION_" .. currentThemeNumber })
	end
end


function LevelEnd:update(dt,time)
	self.shade = _G.math.min(self.shade + dt, 0.65)
	
	ui.Frame.update(self,dt,time)
end

function LevelEnd:draw(x, y, scaleX, scaleY)
--	drawRect(0, 0, 0, self.shade, 0, 0, screenWidth, screenHeight, true)
--	drawRect(0, 0, 0, self.shade, screenWidth * 0.3, 0, screenWidth * 0.7, screenHeight, true)
	if self.visible then
		self:drawBackground()
		ui.Frame.draw(self, x + self.shake_offset_x, y + self.shake_offset_y, scaleX, scaleY)
	end
end

------------------------------
-- LEVEL COMPLETE
------------------------------

LevelComplete = LevelEnd:new()

function LevelComplete:new(o, level, first_clear, stars, score, old_score, old_hatchery_stars, new_hatchery_stars, old_level_stars, eagleAvailable)
	local o = o or {}
	o.level = level
	o.first_clear = first_clear
	o.stars = stars
	o.score = score
	o.old_score = old_score
	o.old_hatchery_stars = old_hatchery_stars
	o.new_hatchery_stars = new_hatchery_stars
	o.old_level_stars = old_level_stars
	o.eagleAvailable = eagleAvailable or false
	o.name = "LevelComplete"
	--print("inited levelend with score=" .. score .. " old=" .. old_score .. "\n")
	
	return LevelEnd.new(self, o)
end

function LevelComplete:init()
	LevelEnd.init(self)
	
	local level, episode, page, index = getLevelById(self.level)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "MT_LEVEL_COMPLETE"
	
	for i = 1, 3 do
		local star = ui.Image:new()
		star.name = "star" .. i
		star:setImage("BIG_STAR_EMPTY_" .. i)
		self:addChild(star)
	end
	
	local score_counter = ui.Text:new()
	score_counter.name = "scoreCounter"
	score_counter.font = "FONT_CHALLENGE_SCORE"
	score_counter.text = "0"
	score_counter.hanchor = "HCENTER"
	score_counter.vanchor = "VCENTER"
	self:addChild(score_counter)
	
	local new_highscore = ui.Image:new()
	new_highscore.name = "newHighscore"
	new_highscore:setImage("NEW_HIGHSCORE_BADGE")
	new_highscore:setVisible(false)
	new_highscore.scaleX = 7.0
	new_highscore.scaleY = 7.0
	self:addChild(new_highscore)
	
	local best_score = ui.Text:new()
	best_score.name = "bestScore"
	best_score.font = "FONT_CURRENT_HIGHSCORE"
	best_score.hanchor = "HCENTER"
	best_score.vanchor = "VCENTER"
	best_score.visible = false
	self:addChild(best_score)
	
	local star_limits = { 0, starTable[self.level].silverScore, starTable[self.level].goldScore }
	for i = 1, 3 do
		local best_star = ui.Image:new()
		best_star.name = "bestStar" .. i
		local image = "BEST_STAR_GREY"
		if self.old_score >= star_limits[i] then
			image = "BEST_STAR_YELLOW"
		end
		best_star:setImage(image)
		best_star:setVisible(false)
		self:addChild(best_star)
	end
	
	local eagle_feather = ui.Image:new()
	eagle_feather.name = "eagleFeather"
	local feather_sprite = "RESULT_ME_FEATHER_OFF"
	if highscores[self.level].eagleScore and highscores[self.level].eagleScore >= 100 then
		feather_sprite = "RESULT_ME_FEATHER_ON"
	end
	eagle_feather:setImage(feather_sprite)
	self:addChild(eagle_feather)
	
	if g_hatcheryCurrencyEnabled then
	
		--level treasure chest
		local treasure_chest = ui.Image:new()
		treasure_chest.name = "treasureChest"
		treasure_chest:setImage("TREASUREBOX_CLOSED")
		self:addChild(treasure_chest)
		
		--wallet star amount box
		local boxRight = PiggyBank:new(self.old_hatchery_stars)
		boxRight.name = "boxRight"
		self:addChild(boxRight)
	end
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	local buttonRight = self:getChild("button3")
	
	local disable_next_button = isNextLevelButtonDisabled(self.level)
	
	--if the level has a cutscene and this was the first time it was completed,
	--the user can only view the cutscene rather than restart or return to menu
	if level.clear_cutscene and self.first_clear then
		buttonRight:setVisible(true)
		self.buttons = 1
		self.no_back_key = true
	elseif disable_next_button then
		buttonLeft:setVisible(true)
		buttonMiddle:setVisible(true)
		self.buttons = 2
	else
		buttonLeft:setVisible(true)
		buttonMiddle:setVisible(true)
		buttonRight:setVisible(true)
		self.buttons = 3
	end
	
	--level selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_LEVEL_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_LEVEL"
	buttonMiddle.meta = {completed = true}
	--set rightside button to next level or cutscene button
	if not level.clear_cutscene then
		buttonRight:setImage("BUTTON_NEXTLEVEL")
		buttonRight.returnValue = "NEXT_LEVEL"
	else
		buttonRight:setImage("MENU_CUTSCENE")
		buttonRight.returnValue = "PLAY_CUTSCENE"
		buttonRight.meta = { cutscene = level.clear_cutscene, episode = episode, page = page, level = index }
	end
end

function LevelComplete:onEntry()
	LevelEnd.onEntry(self)
	
	self.timer = 0
	--_G.res.playAudio("level_complete", 1, false, 7)
	_G.res.playAudio("score_count", 0.7, true, 7)
	
	self.hatchery_star_animation = 0
	self.hatchery_counter_animation = 0
	
	self.flying_stars = {}
end

function LevelComplete:layout()

	self.title_y = 0.185
	self.button_y = 0.8

	LevelEnd.layout(self)
	
	for i = 1, 3 do
		local star = self:getChild("star" .. i)
		star.x = screenWidth * 0.5 + (i - 2) * screenWidth * 0.125
		star.y = screenHeight * 0.375
	end
	
	local score_counter = self:getChild("scoreCounter")
	score_counter.x = screenWidth * 0.5
	score_counter.y = screenHeight * 0.555
	
	local new_highscore = self:getChild("newHighscore")
	new_highscore.x = 0.7 * screenWidth
	new_highscore.y = 0.6 * screenHeight
	new_highscore.start_x = 1.0 * screenWidth
	new_highscore.start_y = 0.3 * screenHeight
	new_highscore.end_x = new_highscore.x
	new_highscore.end_y = new_highscore.y
	
	local eagle_feather = self:getChild("eagleFeather")
	local feather_w, _ = _G.res.getSpriteBounds(eagle_feather.image)
	setFont(score_counter.font)
	eagle_feather.x = screenWidth * 0.5 + _G.res.getStringWidth(self.score .. "") * score_counter.scaleX * 0.5 + feather_w
	eagle_feather.y = score_counter.y
	
	if self.score <= self.old_score then
		local best_star_w, _ = _G.res.getSpriteBounds("BEST_STAR_GREY") * 1.1
		local best_score = self:getChild("bestScore")
		setFont(best_score.font)
		best_score.text = _G.res.getString("TEXTS_BASIC", "TEXT_BEST_SCORE") .. self.old_score
		local best_score_w = _G.res.getStringWidth(best_score.text)
		local best_score_left = screenWidth * 0.5 - 0.5 * (best_score_w + 3.25 * best_star_w)
		
		best_score.x = best_score_left + best_score_w * 0.5
		best_score.y = screenHeight * 0.615
		
		for i = 1, 3 do
			local best_star = self:getChild("bestStar" .. i)
			best_star.x = best_score_left + best_score_w + (i - 0.25) * best_star_w
			best_star.y = screenHeight * 0.615
		end
	else
		local best_score = self:getChild("bestScore")
		best_score.x = screenWidth * 0.5
		best_score.y = screenHeight * 0.615
		--best_score.font = "TODO"
		best_score.text = "MI_NEW_HIGHSCORE"
	end
	
	
	local box_w, box_h = _G.res.getSpriteBounds("BG_STAR_COUNTER")
	
	if g_hatcheryCurrencyEnabled then
	
		local treasure_chest = self:getChild("treasureChest")
		treasure_chest.x = 0.4 * screenWidth
		treasure_chest.y = 0.65 * screenHeight
		
		local box_right = self:getChild("boxRight")
		box_right.x = 0.6 * screenWidth
		box_right.y = 0.65 * screenHeight
	
	end
	
end

function LevelComplete:update(dt, time)
	
	self.timer = self.timer + dt
	self.shade = _G.math.min(self.shade + dt, 0.65)
	
	--duration of the score counter roll
	local score_count_time = _G.math.min((self.score / starTable[self.level].silverScore) * 2, 4)
	
	--ocal star_progress = self:getChild("starProgress")
	local treasure_chest = self:getChild("treasureChest")
	local piggy_bank = self:getChild("boxRight")
	
	for i = 0, self.timer do
		for j = 1, _G.math.min(self.stars, i) do
			local star = self:getChild("star" .. j)
			if star.image == "BIG_STAR_EMPTY_" .. j then
				local sw, sh = _G.res.getSpriteBounds(star.image)
				_G.particles.addParticles("levelCompleteStars" .. j, 40, star.x, star.y, sw / 3, sh / 3, 0, true, true)
				_G.res.playAudio("star_" .. j, 0.7, false)
				if self.new_hatchery_stars ~= self.old_hatchery_stars then
					--star_progress:setHighlightThreshold((star_progress:getHighlightThreshold() or star_progress:getValue()) - 1)
				end
			end
			star:setImage("BIG_STAR_" .. j)
		end
	end
	
	local best_score = self:getChild("bestScore")
	local score_counter = self:getChild("scoreCounter")
	score_counter.text = "" .. _G.math.floor(self.score * _G.math.min(self.timer, score_count_time) / score_count_time)
	
	if self.timer >= score_count_time then
		if _G.res.isAudioPlaying("score_count") then
			_G.res.stopAudio("score_count")
		end
	end
	
	if self.timer >= score_count_time + 1 then
		local new_highscore = self:getChild("newHighscore")
		if not new_highscore.visible and self.score > self.old_score then
			new_highscore:setVisible(true)
			local sw, sh = _G.res.getSpriteBounds(new_highscore.image)
			_G.res.playAudio("new_highscore", 1, false)
			_G.particles.addParticles("newHighScoreStars", 20, new_highscore.x, new_highscore.y, sw, sh, 0, true, true)
		elseif self.score <= self.old_score then
			for i = 1, 3 do
				self:getChild("bestStar" .. i):setVisible(true)
			end
		end
		
		if self.score > self.old_score then
		
			-- the duration of the highscore stamp animation
			local stamp_animation_time = 0.2
			
			--duration of screen shake when the new highscore stamp hits the screen
			local shake_time = 0.2
			
			if self.timer < score_count_time + 1 + stamp_animation_time then
				local scale_tween = tweenLinear(self.timer - score_count_time - 1, 7, -6, stamp_animation_time)
				new_highscore.scaleX = scale_tween
				new_highscore.scaleY = scale_tween
				local pos_tween_x = tweenLinear(self.timer - score_count_time - 1, new_highscore.start_x, new_highscore.end_x - new_highscore.start_x, stamp_animation_time)
				local pos_tween_y = tweenLinear(self.timer - score_count_time - 1, new_highscore.start_y, new_highscore.end_y - new_highscore.start_y, stamp_animation_time)
				new_highscore.x = pos_tween_x
				new_highscore.y = pos_tween_y
			else
				new_highscore.scaleX = 1
				new_highscore.scaleY = 1
				new_highscore.x = new_highscore.end_x
				new_highscore.y = new_highscore.end_y
			end
			
			if self.timer > score_count_time + 1 + stamp_animation_time and self.timer < score_count_time + 1 + stamp_animation_time + shake_time then
				self.shake_offset_x = (_G.math.random(0, 100) - 50) * ((score_count_time + 1 + stamp_animation_time + shake_time) - self.timer) * screenHeight / 768
				self.shake_offset_y = (_G.math.random(0, 100) - 50) * ((score_count_time + 1 + stamp_animation_time + shake_time) - self.timer) * screenHeight / 768
				--print("shaking... X=" .. self.shake_offset_x .. " Y=" .. self.shake_offset_y .. "\n")
			elseif self.timer > score_count_time + 1 + stamp_animation_time + shake_time then
				self.shake_offset_x = 0
				self.shake_offset_y = 0
			end
		
		end
		
		best_score.visible = true
	end
	
	if g_hatcheryCurrencyEnabled then
	
		local new_stars = self.new_hatchery_stars - self.old_hatchery_stars
		
		--the time when the star animation starts
		local star_animation_start_time = score_count_time + 2
		
		--time between stars
		local star_animation_star_interval = 0.5
		
		--time it takes for each star to fly from the chest to the wallet
		local star_animation_flight_time = 0.5
		
		if self.timer >= star_animation_start_time then
			if self.hatchery_star_animation < new_stars then
				treasure_chest:setImage("TREASUREBOX_FULL")
			else
				if self.old_level_stars + new_stars >= getHatcheryStarMaximum(self.level) then
					treasure_chest:setImage("TREASUREBOX_EMPTY")
				end
			end
		end
		
		--increment star animation counter, start star animations
		if self.hatchery_star_animation < new_stars and (self.timer - star_animation_start_time) > self.hatchery_star_animation * star_animation_star_interval then
			self.hatchery_star_animation = self.hatchery_star_animation + 1
			self.flying_stars[self.hatchery_star_animation] = { time = 0, }
		end
		
		--animate the stars
		for k, v in _G.pairs(self.flying_stars) do
			v.time = v.time + dt
			
			local target = piggy_bank:getChild("piggyBank")
			
			v.x = treasure_chest.x + (piggy_bank.x + target.x - treasure_chest.x) * (v.time / star_animation_flight_time)
			v.y = treasure_chest.y + (piggy_bank.y + target.y - treasure_chest.y) * (v.time / star_animation_flight_time)
			
			if v.time > star_animation_flight_time then
				self.flying_stars[k] = nil
			end
		end
		
		--increment the star counter
		if self.hatchery_counter_animation < new_stars and (self.timer - star_animation_start_time - star_animation_flight_time) > self.hatchery_counter_animation * star_animation_star_interval then
			self.hatchery_counter_animation = self.hatchery_counter_animation + 1
			self:getChild("boxRight"):setStars(self.old_hatchery_stars + self.hatchery_counter_animation)
		end
	
	end
	
	LevelEnd.update(self, dt, time)
end

function LevelComplete:draw(x, y, scaleX, scaleY)

	if self.visible then
		self:drawBackground()
		LevelEnd.draw(self, x, y, scaleX, scaleY)
		
		for _, v in _G.pairs(self.flying_stars) do
			local sw, sh = _G.res.getSpriteBounds("P_STAR_3")
			local px, py = _G.res.getSpritePivot("P_STAR_3")
			setRenderState(v.x, v.y, 1, 1, v.time, px, py)
			_G.res.drawSprite("P_STAR_3", 0, 0, "HPIVOT", "VPIVOT", sw, sh)
		end
	end
end

function LevelComplete:onExit()
	LevelEnd.onExit(self)
	clearParticles()
end

------------------------------
-- GOLDEN EGG COMPLETE
------------------------------

GoldenEggComplete = LevelEnd:new()

function GoldenEggComplete:new(level, score, old_score, o)
	local o = o or {}
	o.level = level
	o.score = score
	o.old_score = old_score
	
	--print("inited levelend with score=" .. score .. " old=" .. old_score .. "\n")
	
	return LevelEnd.new(self, o)
end

function GoldenEggComplete:init()
	LevelEnd.init(self)
	
	local _, episode, page, index = getLevelById(self.level)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "MT_LEVEL_COMPLETE"
	
	local star = ui.Image:new()
	star.name = "star"
	star:setImage("BIG_STAR_EMPTY_2")
	self:addChild(star)
	
	local score_counter = ui.Text:new()
	score_counter.name = "scoreCounter"
	score_counter.font = "FONT_CHALLENGE_SCORE"
	score_counter.text = "0"
	score_counter.hanchor = "HCENTER"
	score_counter.vanchor = "VCENTER"
	self:addChild(score_counter)
	
	local best_score = ui.Text:new()
	best_score.name = "bestScore"
	best_score.font = "FONT_CURRENT_HIGHSCORE"
	best_score.text = "Best " .. self.old_score
	best_score.hanchor = "HCENTER"
	best_score.vanchor = "VCENTER"
	best_score.visible = false
	self:addChild(best_score)
	
	if self.old_score > 0 and self.score <= self.old_score then
		best_score.text = "Best " .. self.old_score .. " LOCALISE THIS"
	elseif self.score > self.old_score then
		best_score.text = "New highscore localisethis111111111111"
	end
	
	local new_highscore = ui.Image:new()
	new_highscore.name = "newHighscore"
	new_highscore:setImage("NEW_HIGHSCORE_BADGE")
	new_highscore:setVisible(false)
	new_highscore.scaleX = 7.0
	new_highscore.scaleY = 7.0
	self:addChild(new_highscore)
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	
	buttonLeft:setVisible(true)
	buttonMiddle:setVisible(true)
	self.buttons = 2
	
	--level selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_LEVEL_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_LEVEL"
end

function GoldenEggComplete:onEntry()
	LevelEnd.onEntry(self)
	
	self.timer = 0
	--_G.res.playAudio("level_complete", 1, false, 7)
	_G.res.playAudio("score_count", 0.7, true, 7)
end

function GoldenEggComplete:layout()
	
	self.title_y = 0.185
	
	local star = self:getChild("star")
	star.x = screenWidth * 0.5
	star.y = screenHeight * 0.375
	
	local score_counter = self:getChild("scoreCounter")
	score_counter.x = screenWidth * 0.5
	score_counter.y = screenHeight * 0.555
	
	local new_highscore = self:getChild("newHighscore")
	new_highscore.x = 0.7 * screenWidth
	new_highscore.y = 0.6 * screenHeight
	new_highscore.start_x = 1.0 * screenWidth
	new_highscore.start_y = 0.3 * screenHeight
	new_highscore.end_x = new_highscore.x
	new_highscore.end_y = new_highscore.y
	
	local best_score = self:getChild("bestScore")
	best_score.x = screenWidth * 0.5
	best_score.y = screenHeight * 0.615
	
	self.button_y = 0.75
	
	LevelEnd.layout(self)
end

function GoldenEggComplete:update(dt, time)
	
	self.timer = self.timer + dt
	if self.timer >= 3 then
		local star = self:getChild("star")
		if star.image == "BIG_STAR_EMPTY_2" then
			local sw, sh = _G.res.getSpriteBounds(star.image)
			_G.particles.addParticles("levelCompleteStars2", 40, star.x, star.y, sw / 3, sh / 3, 0, true, true)
			_G.res.playAudio("star_3", 0.7, false)
		end
		star:setImage("BIG_STAR_2")
	end
	
	--duration of the score counter roll
	local score_count_time = 4
	
	local best_score = self:getChild("bestScore")
	local score_counter = self:getChild("scoreCounter")
	score_counter.text = "" .. _G.math.floor(self.score * _G.math.min(self.timer, score_count_time) / score_count_time)
	
	if self.timer >= score_count_time then
		if _G.res.isAudioPlaying("score_count") then
			_G.res.stopAudio("score_count")
		end
	end
	
	if self.timer >= score_count_time + 1 then
		local new_highscore = self:getChild("newHighscore")
		if not new_highscore.visible and self.score > self.old_score then
			new_highscore:setVisible(true)
			local sw, sh = _G.res.getSpriteBounds(new_highscore.image)
			_G.res.playAudio("new_highscore", 1, false)
			--_G.particles.addParticles("newHighScoreStars", 20, new_highscore.x, new_highscore.y, sw, sh, 0, true, true)
		end
		
		if self.score > self.old_score then
		
			-- the duration of the highscore stamp animation
			local stamp_animation_time = 0.2
			
			--duration of screen shake when the new highscore stamp hits the screen
			local shake_time = 0.2
			
			if self.timer < score_count_time + 1 + stamp_animation_time then
				local scale_tween = tweenLinear(self.timer - score_count_time - 1, 7, -6, stamp_animation_time)
				new_highscore.scaleX = scale_tween
				new_highscore.scaleY = scale_tween
				local pos_tween_x = tweenLinear(self.timer - score_count_time - 1, new_highscore.start_x, new_highscore.end_x - new_highscore.start_x, stamp_animation_time)
				local pos_tween_y = tweenLinear(self.timer - score_count_time - 1, new_highscore.start_y, new_highscore.end_y - new_highscore.start_y, stamp_animation_time)
				new_highscore.x = pos_tween_x
				new_highscore.y = pos_tween_y
			else
				new_highscore.scaleX = 1
				new_highscore.scaleY = 1
				new_highscore.x = new_highscore.end_x
				new_highscore.y = new_highscore.end_y
			end
			
			if self.timer > score_count_time + 1 + stamp_animation_time and self.timer < score_count_time + 1 + stamp_animation_time + shake_time then
				self.shake_offset_x = (_G.math.random(0, 100) - 50) * ((score_count_time + 1 + stamp_animation_time + shake_time) - self.timer) * screenHeight / 768
				self.shake_offset_y = (_G.math.random(0, 100) - 50) * ((score_count_time + 1 + stamp_animation_time + shake_time) - self.timer) * screenHeight / 768
				--print("shaking... X=" .. self.shake_offset_x .. " Y=" .. self.shake_offset_y .. "\n")
			elseif self.timer > score_count_time + 1 + stamp_animation_time + shake_time then
				self.shake_offset_x = 0
				self.shake_offset_y = 0
			end
		
		end
		
		best_score.visible = true
	end
	
	LevelEnd.update(self, dt, time)
end

------------------------------
-- LEVEL FAILED
------------------------------

LevelFailed = LevelEnd:new()

function LevelFailed:new(level, eagleAvailable, previously_cleared, score, o)
	local o = o or {}
	o.level = level
	o.previously_cleared = previously_cleared
	o.eagleAvailable = eagleAvailable
	o.name = "LevelFailed"
	return LevelEnd.new(self, o)
end

function LevelFailed:init()
	LevelEnd.init(self)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "MT_LEVEL_FAILED"
	
	local pig = ui.Image:new()
	pig.name = "pig"
	pig:setImage("LEVEL_FAILED_PIG")
	self:addChild(pig)
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	local buttonRight = self:getChild("button3")
	
	local disable_next_button = isNextLevelButtonDisabled(self.level)
	local disable_eagle = isEagleDisabled(self.level)
	
	--if the level has a cutscene, cutscene button replaces the next level button if
	--the level has been cleared previously, otherwise there's a mighty eagle button
	--if eagle is available on the platform
	local level, episode, page, index = getLevelById(self.level)
	if (self.previously_cleared and not disable_next_button) or (showEagleUIElements() and not disable_eagle and not self.previously_cleared) or level.clear_cutscene then
		buttonLeft:setVisible(true)
		buttonMiddle:setVisible(true)
		buttonRight:setVisible(true)
		self.buttons = 3
	else
		buttonLeft:setVisible(true)
		buttonMiddle:setVisible(true)
		self.buttons = 2
	end
	
	--level selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_LEVEL_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_LEVEL"
	buttonMiddle.meta = { failed = true }
	
	--set rightside button to next level or cutscene button
	if not level.clear_cutscene and self.previously_cleared then
		buttonRight:setImage("BUTTON_NEXTLEVEL")
		buttonRight.returnValue = "NEXT_LEVEL"
	elseif level.clear_cutscene and self.previously_cleared then
		buttonRight:setImage("MENU_CUTSCENE")
		buttonRight.returnValue = "PLAY_CUTSCENE"
		buttonRight.meta = { cutscene = level.clear_cutscene, episode = episode, page = page, level = index }		
	elseif showEagleUIElements() and not self.previously_cleared and g_episodes[episode].mighty_eagle_disabled ~= true then
		if self.eagleAvailable then
			self:setEaglebuttonAvailable()
		else
			buttonRight:setImage("BUTTON_EAGLE_LOST", "BUTTON_EAGLE_LOST")
			local timerText = ui.Text:new({text = "", name = "timerText"})
			buttonRight:addChild(timerText)			
			buttonRight.returnValue = "MIGHTY_EAGLE_DISABLED"
		end
	end
end

function LevelFailed:setEaglebuttonAvailable()
	local buttonRight = self:getChild("button3")
	buttonRight:setImage("BUTTON_EAGLE", "BUTTON_EAGLE_LOST")
	buttonRight.returnValue = "MIGHTY_EAGLE"
end

function LevelFailed:onEntry()
	loginfo("LevelFailed:onEntry()")
	--print(_G.debug.traceback())
	eventManager:addEventListener(events.EID_MIGHTY_EAGLE_AVAILABLE, self)
	ui.Frame.onEntry(self)
end
---------
function LevelFailed:layout()
	
	self.title_y = 0.25
	
	local pig = self:getChild("pig")
	pig.x = screenWidth * 0.5
	pig.y = screenHeight * 0.5
	
	self.button_y = 0.80
	
	local buttonRight = self:getChild("button3")
	local timerText = self:getChild("timerText")

	if(timerText ~= nil) then
		timerText.x = 0
		timerText.y = buttonRight.h * 0.5
	end
	
	LevelEnd.layout(self)
end

function LevelFailed:update(dt,time)
	local timerText = self:getChild("timerText")
	
	if(timerText ~= nil) then
		timerText.visible = false
		if self.eagleInfoTimer ~= nil and self.timerVisibleTime ~= nil and settingsWrapper:getEagleUsedTime() ~= nil then
			self.timerVisibleTime = self.timerVisibleTime - dt
			timerText.visible = true	
			
			local timeLeft = eagleLockedTime - timeDiff(currentTime(), settingsWrapper:getEagleUsedTime())		
			timeLeft = formatTime(timeLeft)
			
			local text = timerText.text			
			if timeLeft ~= text then
				timerText.text = timeLeft
				timerText:clip()
			end
			
			if self.timerVisibleTime < 0 then
				self.timerVisibleTime = nil
			end
			
		end
	end
	LevelEnd.update(self,dt,time)	
end

function LevelFailed:onExit()
	eventManager:removeEventListener(events.EID_MIGHTY_EAGLE_AVAILABLE, self)
	ui.Frame.onExit(self)	
end


function LevelFailed:eventTriggered(event)
	if event.id == events.EID_MIGHTY_EAGLE_AVAILABLE then
		local _, episode, page, level = getLevelById(self.level)
		if g_episodes[episode].mighty_eagle_disabled ~= true then
			loginfo("levelFailed:eventTriggered(EID_MIGHTY_EAGLE_AVAILABLE)")
			
			_G.res.playAudio("goldenegg", 1, false)
			
			local buttonRight = self:getChild("buttonRight")		
			self:setEaglebuttonAvailable()
			self.eagleInfoTimer = nil		
			local timerText = self:getChild("timerText")
			if timerText ~= nil then
				timerText.visible = false
				self.timerVisibleTime = nil
			end
		end
	end
end

function LevelFailed:showEagleDisabledTimer()
	self.eagleInfoTimer = eagleLockedTime
	self.timerVisibleTime = 3	
end

------------------------------
-- LEVEL COMPLETE w/ EAGLE
------------------------------

EagleScore = LevelEnd:new()

function EagleScore:new(o, level, first_clear, score, old_score)
	local o = o or {}
	o.level = level
	o.first_clear = first_clear
	o.score = score
	o.old_score = old_score
	return LevelEnd.new(self, o)
end

function EagleScore:init()
	LevelEnd.init(self)

	local _, episode, page, index = getLevelById(self.level)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "TEXT_EAGLE_HIGHSCORE"
	
	local meter_effect = ui.Image:new()
	meter_effect.name = "meterEffect"
	meter_effect:setImage("EAGLE_METER_EFFECT")
	meter_effect:setVisible(false)
	meter_effect.rotatePivotX, meter_effect.rotatePivotY = _G.res.getSpritePivot("EAGLE_METER_EFFECT")
	self:addChild(meter_effect)
	
	local feather = ui.ProgressBar:new()
	feather.name = "feather"
	feather:setImages("EAGLE_METER_EMPTY", "EAGLE_METER_FILL")
	feather:setMax(100)
	feather:setValue(self.score)
	self:addChild(feather)
	
	local score_counter = ui.Text:new()
	score_counter.name = "scoreCounter"
	score_counter.font = "FONT_CHALLENGE_SCORE"
	score_counter.text = _G.math.floor(self.old_score) .. "%"
	score_counter.hanchor = "HCENTER"
	score_counter.vanchor = "VCENTER"
	self:addChild(score_counter)
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	local buttonRight = self:getChild("button3")
	
	local disable_next_button = isNextLevelButtonDisabled(self.level)
	
	--if the level has a cutscene and this was the first time it was completed,
	--the user can only view the cutscene rather than restart or return to menu
	local level = getLevelById(self.level)
	if level.clear_cutscene and self.first_clear then
		buttonRight:setVisible(true)
		self.buttons = 1
	elseif disable_next_button then
		buttonLeft:setVisible(true)
		buttonMiddle:setVisible(true)
		self.buttons = 2
	else
		buttonLeft:setVisible(true)
		buttonMiddle:setVisible(true)
		buttonRight:setVisible(true)
		self.buttons = 3
	end
	
	--level selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_LEVEL_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_LEVEL"
	
	--set rightside button to next level or cutscene button
	if not level.clear_cutscene then
		buttonRight:setImage("BUTTON_NEXTLEVEL")
		buttonRight.returnValue = "NEXT_LEVEL"
	else
		buttonRight:setImage("MENU_CUTSCENE")
		buttonRight.returnValue = "PLAY_CUTSCENE"
		buttonRight.meta = { cutscene = level.clear_cutscene, episode = episode, page = page, level = index }
	end
end

function EagleScore:onEntry()
	LevelEnd.onEntry(self)
	
	self.timer = 0
	--_G.res.playAudio("level_complete", 1, false, 7)
end

function EagleScore:layout()

	self.title_y = 0.185
	self.button_y = 0.75

	LevelEnd.layout(self)
	
	local meter_effect = self:getChild("meterEffect")
	meter_effect.x = screenWidth * 0.5
	meter_effect.y = screenHeight * 0.41
	
	local feather = self:getChild("feather")
	feather.x = screenWidth * 0.5
	feather.y = screenHeight * 0.41
	
	local score_counter = self:getChild("scoreCounter")
	score_counter.x = screenWidth * 0.5
	score_counter.y = screenHeight * 0.555
end

function EagleScore:update(dt, time)
	
	self.timer = self.timer + dt
	
	local meter_effect = self:getChild("meterEffect")
	meter_effect.angle = self.timer
	
	local fill = _G.math.floor(self.score * _G.math.min(self.timer, 3) / 3)
	local feather = self:getChild("feather")
	feather:setValue(fill)
	if fill >= 100 then
		feather:setImages("EAGLE_METER_EMPTY", "EAGLE_METER_FULL")
		meter_effect:setVisible(true)
	end
	
	local score_counter = self:getChild("scoreCounter")
	local score = _G.math.floor(self.score * _G.math.min(self.timer, 3) / 3)
	if score > self.old_score then
		score_counter.text = score .. "%"
	end
	
	LevelEnd.update(self, dt, time)
end

------------------------------
-- EPISODE COMPLETE
------------------------------

EpisodeComplete = LevelEnd:new()

function EpisodeComplete:new(o, next_screen, episode)
	local o = o or {}
	o.episode = episode
	o.next_screen = next_screen
	o.name = "EpisodeComplete"
	
	return LevelEnd.new(self, o)
end

function EpisodeComplete:init()
	LevelEnd.init(self)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = g_episodes[self.episode].name
	
	local reward_effect = ui.Image:new()
	reward_effect.name = "rewardEffect"
	reward_effect:setImage("GOLDEN_EGG_STAR_EFFECT")
	reward_effect.rotatePivotX, reward_effect.rotatePivotY = _G.res.getSpritePivot("GOLDEN_EGG_STAR_EFFECT")
	self:addChild(reward_effect)
	
	local reward_sprite = ui.Image:new()
	reward_sprite.name = "rewardSprite"
	reward_sprite:setImage("REWARD_" .. self.episode)
	self:addChild(reward_sprite)
	
	local text = ui.Text:new()
	text.name = "text"
	text.font = fontBasic
	text.text = "TEXT_COMPLETE"
	text.hanchor = "HCENTER"
	text.vanchor = "VCENTER"
	self:addChild(text)
	
	local buttonRight = self:getChild("button3")
	buttonRight:setImage("MENU_YES")
	buttonRight.returnValue = "NEXT_SCREEN"
	buttonRight.meta = { next_screen = self.next_screen }
	buttonRight:setVisible(true)
	self.buttons = 1
end

function EpisodeComplete:onEntry()
	LevelEnd.onEntry(self)
	
	self.timer = 0
end

function EpisodeComplete:layout()
	LevelEnd.layout(self)
	
	local reward_effect = self:getChild("rewardEffect")
	reward_effect.x = screenWidth * 0.5
	reward_effect.y = screenHeight * 0.35
	
	local reward_sprite = self:getChild("rewardSprite")
	reward_sprite.x = screenWidth * 0.5
	reward_sprite.y = screenHeight * 0.35
	
	local text = self:getChild("text")
	text.x = screenWidth * 0.5
	text.y = screenHeight * 0.65
	text.text = "TEXT_COMPLETE"
	if text.textBoxSize ~= 0.4 * screenWidth - ((0.4 * screenWidth) % 8) then
		text.textBoxSize = 0.4 * screenWidth - ((0.4 * screenWidth) % 8)
		text:clip()
	end
end

function EpisodeComplete:update(dt, time)

	self.timer = self.timer + dt

	local reward_effect = self:getChild("rewardEffect")
	reward_effect.angle = self.timer
	
	LevelEnd.update(self, dt, time)
end

------------------------------
-- EPISODE THREE STARRED
------------------------------

EpisodeThreeStars = LevelEnd:new()

function EpisodeThreeStars:new(o, next_screen, episode)
	local o = o or {}
	o.episode = episode
	o.next_screen = next_screen
	o.name = "EpisodeThreeStars"

	return LevelEnd.new(self, o)
end

function EpisodeThreeStars:init()
	LevelEnd.init(self)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = g_episodes[self.episode].name
	
	local reward_effect = ui.Image:new()
	reward_effect.name = "rewardEffect"
	reward_effect:setImage("GOLDEN_EGG_STAR_EFFECT")
	reward_effect.rotatePivotX, reward_effect.rotatePivotY = _G.res.getSpritePivot("GOLDEN_EGG_STAR_EFFECT")
	self:addChild(reward_effect)
	
	local reward_sprite = ui.Image:new()
	reward_sprite.name = "rewardSprite"
	reward_sprite:setImage("REWARD_" .. self.episode .. "_STAR")
	self:addChild(reward_sprite)
	
	local text = ui.Text:new()
	text.name = "text"
	text.font = fontBasic
	text.text = "TEXT_PERFECT"
	text.hanchor = "HCENTER"
	text.vanchor = "VCENTER"
	self:addChild(text)
	
	local buttonRight = self:getChild("button3")
	buttonRight:setImage("MENU_YES")
	buttonRight.returnValue = "NEXT_SCREEN"
	buttonRight.meta = { next_screen = self.next_screen }
	buttonRight:setVisible(true)
	self.buttons = 1
end

function EpisodeThreeStars:onEntry()
	LevelEnd.onEntry(self)
	
	self.timer = 0
end

function EpisodeThreeStars:layout()
	LevelEnd.layout(self)
	
	local reward_effect = self:getChild("rewardEffect")
	reward_effect.x = screenWidth * 0.5
	reward_effect.y = screenHeight * 0.35
	
	local reward_sprite = self:getChild("rewardSprite")
	reward_sprite.x = screenWidth * 0.5
	reward_sprite.y = screenHeight * 0.35
	
	local text = self:getChild("text")
	text.x = screenWidth * 0.5
	text.y = screenHeight * 0.65
	text.text = "TEXT_PERFECT"
	if text.textBoxSize ~= 0.4 * screenWidth - ((0.4 * screenWidth) % 8) then
		text.textBoxSize = 0.4 * screenWidth - ((0.4 * screenWidth) % 8)
		text:clip()
	end
end

function EpisodeThreeStars:update(dt, time)

	self.timer = self.timer + dt

	local reward_effect = self:getChild("rewardEffect")
	reward_effect.angle = self.timer
	
	LevelEnd.update(self, dt, time)
end

------------------------------
-- CHALLENGE MIDWAY
------------------------------

BirdFlockProgress = ui.Frame:new()

function BirdFlockProgress:new(challenge, challenge_progress, o)
	local o = o or {}
	o.challenge = challenge
	o.challenge_progress = challenge_progress
	o.name = "BirdFlockProgress"
	return ui.Frame.new(self, o)
end

function BirdFlockProgress:init()
	ui.Frame.init(self)
	
	local bird_silhouette = ui.Image:new()
	bird_silhouette.name = "birdSilhouette"
	bird_silhouette:setImage("BIRDS_LEFT_SILHOUETTE")
	self:addChild(bird_silhouette)
	
	local bird_count = ui.Text:new()
	bird_count.name = "birdCount"
	bird_count.font = "FONT_BIRDS_LEFT"
	bird_count.text = "" .. #self.challenge_progress.shotsQueue
	bird_count.hanchor = "RIGHT"
	bird_count.vanchor = "VCENTER"
	self:addChild(bird_count)
	
	local birds_left = ui.Text:new()
	birds_left.name = "birdsLeft"
	birds_left.font = fontBasic
	birds_left.text = "birds left localiseme"
	birds_left.hanchor = "HCENTER"
	birds_left.vanchor = "VCENTER"
	self:addChild(birds_left)
	
end

function BirdFlockProgress:layout()
	ui.Frame.layout(self)
	
	local bird_silhouette = self:getChild("birdSilhouette")
	bird_silhouette.x = screenWidth * -0.05
	bird_silhouette.y = screenHeight * -0.05
	
	local bird_count = self:getChild("birdCount")
	bird_count.x = screenWidth * 0.05
	bird_count.y = screenHeight * -0.05
	
	local birds_left = self:getChild("birdsLeft")
	birds_left.y = screenHeight * 0.05

end

g_challengeProgressBoxes =
{
	BIRD_FLOCK = BirdFlockProgress,
}

ChallengeLevelComplete = LevelEnd:new()

function ChallengeLevelComplete:new(challenge, challenge_progress, o)
	local o = o or {}
	print (_G.tostring(challenge).."\n")
	print (_G.tostring(challenge_progress).."\n")
	o.challenge = challenge
	o.challenge_progress = challenge_progress
	return LevelEnd.new(self, o)
end

function ChallengeLevelComplete:init()
	LevelEnd.init(self)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "CHALLENGE LEVEL COMPLETED! localiseme"
	
	local progress = ui.Text:new()
	progress.name = "progress"
	progress.font = fontBasic
	progress.text = "Level " .. self.challenge_progress.levelIndex  .. " / " .. #self.challenge.levels .. "localiseme"
	progress.hanchor = "HCENTER"
	progress.vanchor = "VCENTER"
	self:addChild(progress)
	
	local challenge_box = g_challengeProgressBoxes[self.challenge.type]:new(self.challenge, self.challenge_progress)
	challenge_box.name = "challengeBox"
	self:addChild(challenge_box)
	
	--local piggy_bank = PiggyBank:new(settingsWrapper:getHatcheryStars())
	--piggy_bank.name = "piggyBank"
	--self:addChild(piggy_bank)
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	local buttonRight = self:getChild("button3")
	
	buttonLeft:setVisible(true)
	buttonMiddle:setVisible(true)
	buttonRight:setVisible(true)
	
	--challenge selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_CHALLENGE_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_CHALLENGE"
	
	--set rightside button to next level or cutscene button
	buttonRight:setImage("BUTTON_NEXTLEVEL")
	buttonRight.returnValue = "NEXT_CHALLENGE_LEVEL"
	
	self.buttons = 3
end

function ChallengeLevelComplete:layout()
	LevelEnd.layout(self)
	
	local progress = self:getChild("progress")
	progress.x = screenWidth * 0.5
	progress.y = screenHeight * 0.2
	
	local challenge_box = self:getChild("challengeBox")
	challenge_box.x = screenWidth * 0.5
	challenge_box.y = screenHeight * 0.4

	--local piggy_bank = self:getChild("piggyBank")
	--piggy_bank.x = screenWidth * 0.5
	--piggy_bank.y = screenHeight * 0.65
end

------------------------------
-- CHALLENGE COMPLETE
------------------------------

ChallengeComplete = LevelEnd:new()

function ChallengeComplete:new(challenge, challenge_progress, old_star_amount, reward, o)
	local o = o or {}
	o.challenge = challenge
	o.challenge_progress = challenge_progress
	o.old_star_amount = old_star_amount
	o.reward = reward
	return LevelEnd.new(self, o)
end

function ChallengeComplete:init()
	LevelEnd.init(self)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "CHALLENGE COMPLETED! localiseme"
	
	local star = ui.Image:new()
	star.name = "star"
	star:setImage("BIG_STAR_EMPTY_2")
	self:addChild(star)
	
	local reward = ui.Text:new()
	reward.name = "reward"
	reward.font = fontBasic
	reward.text = "" .. self.challenge.reward
	reward.hanchor = "HCENTER"
	reward.vanchor = "VCENTER"
	reward.visible = false
	self:addChild(reward)
	
	local piggy_bank = PiggyBank:new(self.old_star_amount)
	piggy_bank.name = "piggyBank"
	self:addChild(piggy_bank)
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	
	buttonLeft:setVisible(true)
	buttonMiddle:setVisible(true)
	
	--challenge selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_CHALLENGE_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_CHALLENGE"
	
	self.buttons = 2
	
end

function ChallengeComplete:onEntry()
	LevelEnd.onEntry(self)
	
	self.timer = 0
end

function ChallengeComplete:layout()
	LevelEnd.layout(self)
	
	local star = self:getChild("star")
	star.x = screenWidth * 0.5
	star.y = screenHeight * 0.35
	
	local reward = self:getChild("reward")
	reward.x = screenWidth * 0.5
	reward.y = screenHeight * 0.5
	
	local piggy_bank = self:getChild("piggyBank")
	piggy_bank.x = screenWidth * 0.5
	piggy_bank.y = screenHeight * 0.65
end

function ChallengeComplete:update(dt, time)
	
	self.timer = self.timer + dt
	
	local reward = self:getChild("reward")
	
	if self.timer >= 1.0 then
		local star = self:getChild("star")
		if star.image == "BIG_STAR_EMPTY_2" then
			local sw, sh = _G.res.getSpriteBounds(star.image)
			_G.particles.addParticles("levelCompleteStars2", 40, star.x, star.y, sw / 3, sh / 3, 0, true, true)
			_G.res.playAudio("star_2", 0.7, false)
		end
		star:setImage("BIG_STAR_2")
		if self.reward > 0 then
			reward.visible = true
		end
	end
	
	if self.reward > 0 and self.timer > 2.0 then
		local reward_counter = _G.math.floor(self.reward * _G.math.min(self.timer - 2, 2) / 2)
	
		reward.text = "" .. self.reward - reward_counter
		
		local piggyBank = self:getChild("piggyBank")
		piggyBank:setStars(self.old_star_amount + reward_counter)
	end
	
	LevelEnd.update(self, dt, time)
end

------------------------------
-- CHALLENGE FAILED
------------------------------

ChallengeFailed = LevelEnd:new()

function ChallengeFailed:new(challenge, challenge_progress, o)
	local o = o or {}
	o.challenge = challenge
	o.challenge_progress = self.challenge_progress
	return LevelEnd.new(self, o)
end

function ChallengeFailed:init()
	LevelEnd.init(self)
	
	local page_title = self:getChild("pageTitle")
	page_title.text = "CHALLENGE FAILED! localiseme"
	
	local pig = ui.Image:new()
	pig.name = "pig"
	pig:setImage("LEVEL_FAILED_PIG")
	self:addChild(pig)
	
	local buttonLeft = self:getChild("button1")
	local buttonMiddle = self:getChild("button2")
	local buttonRight = self:getChild("button3")
	
	buttonLeft:setVisible(true)
	buttonMiddle:setVisible(true)
	self.buttons = 2
	
	--level selection return button
	buttonLeft:setImage("BUTTON_MENU")
	buttonLeft.returnValue = "RETURN_TO_CHALLENGE_SELECTION"
	
	--restart button
	buttonMiddle:setImage("BUTTON_RESTART")
	buttonMiddle.returnValue = "RESTART_CHALLENGE"
	buttonMiddle.meta = { failed = true }
	
end

function ChallengeFailed:layout()
	
	self.title_y = 0.25
	
	local pig = self:getChild("pig")
	pig.x = screenWidth * 0.5
	pig.y = screenHeight * 0.5
	
	self.button_y = 0.75
	
	LevelEnd.layout(self)
end

filename="level_end.lua"
