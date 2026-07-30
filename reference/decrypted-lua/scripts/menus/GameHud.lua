Frame = gamelua.ui.Frame
GameHud = gamelua.ui.Frame:new()

--
--[[
------ draws ME - specific HUD - elements (after eagle bait has been lanched)
function drawMEHud(bannerOffset)
	setHudRenderState()
	local tempEagleScore = 0
	if highscores[levelName] ~= nil and highscores[levelName].eagleScore ~= nil and highscores[levelName].eagleScore > 0 then
		tempEagleScore = highscores[levelName].eagleScore
	end
	local highScoreLen = _G.res.getStringWidth(tempEagleScore .. "%")
		
	local highscoreStr = _G.res.getString("TEXTS_BASIC", "TEXT_EAGLE_HIGHSCORE")
	_G.res.drawString("TEXTS_BASIC", highscoreStr .. " ", screenWidth - 3 - highScoreLen, bannerOffset, "TOP", "RIGHT")
	
	_G.res.drawString("TEXTS_BASIC", _G.string.format("%d", tempEagleScore) .. "%", screenWidth - 3, bannerOffset, "TOP", "RIGHT")	
end
]]

function GameHud:init()
	self.name = "gameHud"

	local pausePage = gamelua.ui.PausePage:new({name = "pausePage"})
	self:addChild(pausePage)

	local eagleButton = gamelua.ui.MightyEagleButton:new({name = "eagleButton", returnValue = "ME_BUTTON_CLICKED"})
	self:addChild(eagleButton)
	
	local pauseButton = gamelua.ui.ImageButton:new({name = "pauseButton", returnValue = "PAUSE_GAME"})
	pauseButton:setImage("MENU_BUTTON")
	self:addChild(pauseButton)
	
	--[[
	if gamelua.deviceModel == "iphone4" then
		eagleButton.scaleX = 2
		eagleButton.scaleY = 2
		pauseButton.scaleX = 2
		pauseButton.scaleY = 2
	end
	]]--
	
	self.frame = 0
	
end

-----------------------------

function GameHud:onEntry()
	if not gamelua.startedFromEditor then
		gamelua.eventManager:addEventListener(gamelua.events.EID_LEVEL_LOADING_DONE, self)
		gamelua.eventManager:addEventListener(gamelua.events.EID_GAME_PAUSED, self)
		gamelua.eventManager:addEventListener(gamelua.events.EID_PAUSE_CLICKED, self)
		gamelua.eventManager:addEventListener(gamelua.events.EID_GAME_RESUMED, self)
	end
	
	gamelua.eventManager:addEventListener(gamelua.events.EID_EAGLE_BAIT_LAUNCHED, self)
	
	local audioButton = self:getChild("buttonSounds");		
	
	if gamelua.settingsWrapper:isAudioEnabled() then
		audioButton:setState(1)
	else
		audioButton:setState(2)
	end

	Frame.onEntry(self)
end

-----------------------------
function GameHud:layout()

	local sx = 1
	local sy = 1
	
	if gamelua.isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end
	
	local pauseButton = self:getChild("pauseButton")
	pauseButton.x = 0 
	pauseButton.y = 0
	pauseButton.scaleX = sx
	pauseButton.scaleY = sy
	
	--TODO: fix this hack
	if gamelua.deviceModel == "iphone" then
		pauseButton.x = 30
		pauseButton.y = 32
	elseif gamelua.deviceModel == "iphone4" then
		pauseButton.scaleX = 1
		pauseButton.scaleY = pauseButton.scaleX
		pauseButton.x = 30
		pauseButton.y = 32
	end
	
	 
	
	local eagleButton = self:getChild("eagleButton")
	eagleButton.x = eagleButton.w * sx + eagleButton.px * sx
	eagleButton.y = eagleButton.py * sy
	eagleButton.scaleX = sx
	eagleButton.scaleY = sy
		
	Frame.layout(self)	
end

function GameHud:update(dt,time)

	self:updateTutorials()
	
	gamelua.ui.Frame.update(self,dt,time)
	
	self.frame = self.frame + 1
	
	--TODO:fix this hack
	self:getChild("eagleButton"):setVisible(false)
end

function GameHud:updateTutorials()
	if self.frame > 1 and #gamelua.birdTutorialPopups > 0 and (gamelua.g_tutorialActive == nil or gamelua.g_tutorialActive.ready_for_next_tutorial) then
		--[[
		if gamelua.deviceModel == "iphone4" and gamelua.wantedResolution == "FULL" then
			gamelua.changeResolution = true
			gamelua.wantedResolution = "HALF"
			return
		end
		]]--
		local from
		if self:getChild("pausePage").visible then
			from = "PAUSE_PAGE"
		else
			from = "INGAME"
			self:getChild("pauseButton").visible = false
			self:getChild("eagleButton"):setVisible(false)
			self.tutorials_shown = true
		end
		gamelua.eventManager:notify({ id = gamelua.events.EID_SHOW_TUTORIAL, tutorial = gamelua.birdTutorialPopups[1], from = from })
	elseif self.tutorials_shown and #gamelua.birdTutorialPopups == 0 and gamelua.g_tutorialActive == nil then
		self:getChild("pauseButton").visible = true
		self:getChild("eagleButton"):setVisible(true)
		self.tutorials_shown = nil
	end
end

function GameHud:showPauseMenu()
	self:getChild("pauseButton").visible = false
	self:getChild("eagleButton"):setVisible(false)
	self:getChild("pausePage"):showPage()
end


function GameHud:onKeyEvent(eventType, key)
	if key == "BACK" then
		if gamelua.g_currentChallenge == nil then
			gamelua.eventManager:queueEvent({id = gamelua.events.EID_CHANGE_SCENE, from = "INGAME", target = "LEVEL_SELECTION_"..gamelua.currentThemeNumber})
		else
			gamelua.eventManager:queueEvent({ id = gamelua.events.EID_CHANGE_SCENE, target = "CHALLENGE_PAGE" })			
		end
	end	
end

function GameHud:onPointerEvent(eventType,x,y)
	result, meta = Frame.onPointerEvent(self,eventType,x,y)
	
	if gamelua.g_tutorialActive == nil then
	
		if result == "ME_BUTTON_CLICKED" and gamelua.g_tutorialActive == nil then
			
			self:getChild("eagleButton"):setVisible(false)
			gamelua.eventManager:notify({id = gamelua.events.EID_MIGHTY_EAGLE_BUTTON_CLICKED, from = "INGAME", })		
				
		elseif result == "PAUSE_GAME" and gamelua.g_tutorialActive == nil then
			--[[
			if gamelua.deviceModel == "iphone4" then
				gamelua.wantedResolution = "HALF" 
				gamelua.changeResolution = true
			end
			]]--
			if not gamelua.startedFromEditor then
				--gamelua.eventManager:queueEvent({id = gamelua.events.EID_PAUSE_CLICKED})
				gamelua.goToMenu()
			else
				gamelua.returnToEditor()
			end
		elseif result == "BACK_TO_GAME" then
			
			self:getChild("pauseButton").visible = true
			self:getChild("eagleButton"):setVisible(true)
			self:getChild("pausePage"):hidePage()	
			gamelua.eventManager:queueEvent({id = gamelua.events.EID_BACK_TO_GAME_CLICKED})
			
			
		elseif result == "BACK_TO_LEVEL_SELECTION" then
			
			gamelua.eventManager:notify({ id = gamelua.events.EID_LEAVE_GAME, reason = "PAUSE_MENU_BUTTON", })
			
			if gamelua.g_currentChallenge == nil then
				gamelua.eventManager:queueEvent({id = gamelua.events.EID_CHANGE_SCENE, from = "INGAME", target = "LEVEL_SELECTION_"..gamelua.currentThemeNumber})
			else
				gamelua.eventManager:queueEvent({ id = gamelua.events.EID_CHANGE_SCENE, target = "CHALLENGE_PAGE" })			
			end
			
		elseif result == "RESTART_LEVEL" then
			gamelua.eventManager:queueEvent({id = gamelua.events.EID_LEVEL_RESTART_CLICKED})
		elseif result == "TOGGLE_SOUNDS" then
		
			-- this will get audio button from pausePage
			local audioButton = self:getChild("buttonSounds");		
			gamelua.changeAudio()
			
			if gamelua.settingsWrapper:isAudioEnabled() then
				audioButton:setState(1)
			else
				audioButton:setState(2)
			end
		elseif result == "SHOW_TUTORIALS" then
			gamelua.eventManager:notify({ id = gamelua.events.EID_SHOW_TUTORIALS, from = "PAUSE_PAGE", })
		end
	
	end
	
	return nil, nil, nil
	
end

function GameHud:setTextRenderState()
	--[[
	if gamelua.deviceModel == "iphone4" and ((gamelua.changeResolution ~= true and gamelua.wantedResolution == "FULL") or (gamelua.changeResolution == true and gamelua.wantedResolution == "HALF")) then
		gamelua.setRenderState(-gamelua.screenWidth / 2, 0, 2, 2)
	else
		gamelua.setRenderState(0, 0, 1, 1)
	end
	]]--	
	
	if gamelua.isRetinaGraphicsEnabled() then
		gamelua.setRenderState(-gamelua.screenWidth / 2, 0, 2, 2)
	else
		gamelua.setRenderState(0, 0, 1, 1)
	end
end

function GameHud:draw(x, y, scaleX, scaleY, angle)
	local setFont = gamelua.setFont
	local fontBasic = gamelua.fontBasic
	setFont(fontBasic)
	
	if gamelua.currentGameMode ~= gamelua.updateGame then
		gamelua.drawGame()
	end
	
	self:setTextRenderState()
	
	local sx = 1
	local sy = 1
	
	if gamelua.isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end
	
	local scoreString = _G.string.format("%d", gamelua.score)
	local scoreLen = _G.res.getStringWidth(scoreString) * sx
	local screenWidth = gamelua.screenWidth
	local screenHeight = gamelua.screenHeight
	local scoreLen = _G.res.getStringWidth(scoreString) * sx
	local highscoreStr = _G.res.getString("TEXTS_BASIC", "MI_HIGH_SCORE")
	local scoreStr = _G.res.getString("TEXTS_BASIC", "MI_SCORE")
	local yAdd = 0
	local levelName = gamelua.levelName 
	
	local highscores = gamelua.highscores
	
	if oldScoreLen == nil then 
		oldScoreLen = scoreLen
	end
	
	scoreLen = _G.math.max( scoreLen, oldScoreLen)
	oldScoreLen = scoreLen
	local bannerOffset = 0
	
	if gamelua.adSystem ~= nil and gamelua.adSystem.scoreAdOffsetY ~= nil then
		--bannerOffset = gamelua.adSystem.bannerOffset or 0	
		bannerOffset = _G.math.min(_G.math.max(gamelua.adSystem.scoreAdOffsetY, 0), gamelua.adSystem.bannerHeight) * sy
		--gamelua.print("bannerOffset = "..bannerOffset)
	end
	
	local flyingBird = gamelua.flyingBird
	local isEagleBaitLaunched = gamelua.subsystemsapi.isEagleBaitLaunched()
	----------------------
	--	finger tutorial --
	----------------------
	if flyingBird ~= nil and flyingBird.name ~= nil then
		local bDef = gamelua.getObjectDefinition(flyingBird.name)
		gamelua.drawExtraTutorial(bDef.sprite)
	end
	------------------------------------
	--  Draws scores in normal gameplay
	------------------------------------
	if not isEagleBaitLaunched then		
		if highscores[levelName] ~= nil and highscores[levelName].score > 0 then
			local highScoreLen = _G.res.getStringWidth("" .. highscores[levelName].score)
			yAdd = _G.res.getFontLeading() + 1
			if scoreLen < highScoreLen then
				scoreLen = highScoreLen
			end
			_G.res.drawString("TEXTS_BASIC", highscoreStr .. " ", screenWidth - 3 - scoreLen, bannerOffset, "TOP", "RIGHT")
			_G.res.drawString("TEXTS_BASIC", _G.string.format("%d", highscores[levelName].score), screenWidth - 3, bannerOffset, "TOP", "RIGHT")
		end	
		_G.res.drawString("TEXTS_BASIC", scoreStr .. " ", screenWidth - 3 - scoreLen, yAdd + bannerOffset, "TOP", "RIGHT")
		_G.res.drawString("TEXTS_BASIC", scoreString, screenWidth - 3, yAdd + bannerOffset, "TOP", "RIGHT")
	
		------------------------------------------------
		-- Renders floating scores from game elements --
		------------------------------------------------
		local floatingScores = gamelua.floatingScores
		setFont("FONT_SCORE")			
		for i = 1, #floatingScores do
			local fs = floatingScores[i]
			local fx, fy = gamelua.physicsToWorldTransform(fs.x, fs.y)
			local wScale = gamelua.worldScale
			-- tempWorldScale is temporary scaling that is only used when iphone4 goes to 480x320 resolution to display in-game menu etc.
			if gamelua.tempWorldScale ~= nil then
				wScale = gamelua.tempWorldScale
			end
			fx = (fx - gamelua.screen.left) * wScale
			fy = (fy - gamelua.screen.top) * wScale
			local xs = fs.xs
			
			gamelua.setRenderState(0, 0, xs * sx, xs * sy)
			if fs.text ~= nil then
				_G.res.drawString("TEXTS_BASIC", fs.text, fx/(xs * sx), fy/ (xs * sy), "BOTTOM", "HCENTER")
			end
			if fs.sprite ~= nil then 
				_G.res.drawSprite("MENU_ELEMENTS_1", fs.sprite, _G.math.floor(fx/(xs * sx)), _G.math.floor(fy/(xs * sy)), "BOTTOM", "HCENTER")
			end
		end		
	end

	-----------------------------	
	-- Draws Mighty Eagle HUD ---
	-----------------------------
	self:setTextRenderState()
	setFont(fontBasic)
	if isEagleBaitLaunched then	
		local tempEagleScore = 0
		if highscores[levelName] ~= nil and highscores[levelName].eagleScore ~= nil and highscores[levelName].eagleScore > 0 then
			tempEagleScore = highscores[levelName].eagleScore
		end
		local highScoreLen = _G.res.getStringWidth(tempEagleScore .. "%")
			
		local highscoreStr = _G.res.getString("TEXTS_BASIC", "TEXT_EAGLE_HIGHSCORE")
		_G.res.drawString("TEXTS_BASIC", highscoreStr .. " ", screenWidth - 3 - highScoreLen, bannerOffset, "TOP", "RIGHT")	
		_G.res.drawString("TEXTS_BASIC", _G.string.format("%d", tempEagleScore) .. "%", screenWidth - 3, bannerOffset, "TOP", "RIGHT")		
		
	end
	
	Frame.draw(self, x, y, scaleX, scaleY)	
end


function GameHud:eventTriggered(event)

--	if event.id == gamelua.events.EID_MIGHTY_EAGLE_AVAILABLE then
--		self:getChild("eagleButton").enabled = true
--	end
	if gamelua.g_tutorialActive == nil and event.id == gamelua.events.EID_GAME_PAUSED or event.id == gamelua.events.EID_PAUSE_CLICKED then
		self:showPauseMenu()
		gamelua.loginfo("showing pause menu")
	end
	
	if event.id == gamelua.events.EID_GAME_RESUMED and event.mode == "INGAME" then
		--self:showPauseMenu()
	end
	
	if event.id == gamelua.events.EID_LEVEL_LOADING_DONE then
	end
	
	if event.id == gamelua.events.EID_EAGLE_BAIT_LAUNCHED then
		self:getChild("eagleButton"):setVisible(false)
	end
end


function GameHud:onExit()
	if not gamelua.startedFromEditor then
		gamelua.eventManager:removeEventListener(gamelua.events.EID_LEVEL_LOADING_DONE, self)
		gamelua.eventManager:removeEventListener(gamelua.events.EID_GAME_PAUSED, self)
		gamelua.eventManager:removeEventListener(gamelua.events.EID_PAUSE_CLICKED, self)
		gamelua.eventManager:removeEventListener(gamelua.events.EID_GAME_RESUMED, self)
	end
	
	gamelua.eventManager:removeEventListener(gamelua.events.EID_EAGLE_BAIT_LAUNCHED, self)
	
--	gamelua.eventManager:removeEventListener(gamelua.events.EID_MIGHTY_EAGLE_AVAILABLE, self)
	Frame.onExit(self)
end

filename="GameHud.lua"
