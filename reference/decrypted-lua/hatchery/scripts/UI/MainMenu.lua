HatcheryMainMenu = MainMenu:new()


function HatcheryMainMenu:init()
	MainMenu.init(self)

	self.transAnim = {}
	self.transAnim.state = 0
	self.transAnim.timer = 0
	self.transAnim.time =0 
	self.transAnim.drawOffsetX = 0
	self.transAnim.drawOffsetY = 0
	
	
	local hatcheryButton = ui.InvisibleButton:new()
	hatcheryButton.name = "hatchButton"
	hatcheryButton.returnValue = Hatchery.hatcheryEvents.EID_HATCHERY_GO_TO_HATCHERY_FROM_MAINMENU 
	hatcheryButton.activateOnRelease = true
	self:addChild(hatcheryButton)
	
	
end



function HatcheryMainMenu:update(dt, time)
	MainMenu.update(self,dt, time)
	self:animateTransition(dt,time)
end

function HatcheryMainMenu:onEntry()
	MainMenu.onEntry(self)
	local hatcheryView = Hatchery.Hatchery:getNestView()
	hatcheryView:onEntry()
	
	
	
	self.hatcheryOffsetX, self.hatcheryOffsetY  = screenWidth*0.3, screenHeight*0.15
	self.hatcheryScaleX, self.hatcheryScaleY = 0.7,0.7
end

function HatcheryMainMenu:draw(x,y)
		--hatcheryView
	local hatcheryView = Hatchery.Hatchery:getNestView()	
	
	hatcheryView:drawMenuNestView(x + self.hatcheryOffsetX, y+ self.hatcheryOffsetY,self.hatcheryScaleX,self.hatcheryScaleY)
	
	--need to draw some objects differently because of the offset animation
	-- drawLevelSelectionBackground()

	scaleX = scaleX or 1
	scaleY = scaleY or 1
	angle = angle or 0
	
	for i,v in _G.ipairs(self.children) do
		if v.visible == true then
			local offsetX, offsetY = self.transAnim.drawOffsetX, self.transAnim.drawOffsetY
			local animScaleX, animScaleY = 1,1
			if self.transAnim.interp then
				if v.scrollAnimationX then
					offsetX = v.scrollAnimationX*(1-self.transAnim.interp)
				end
				if v.scrollAnimationY then
					offsetY = v.scrollAnimationY * (1-self.transAnim.interp)
				end
				if v.scrollScaleX then
					animScaleX = (1-self.transAnim.interp) * v.scrollScaleX
					animScaleY = (1-self.transAnim.interp) * v.scrollScaleY
				end
			end
			
			v:draw((x + self.x + offsetX), (y+ self.y + offsetY), scaleX * self.scaleX* animScaleX, scaleY * self.scaleY*animScaleY, angle + self.angle)
		end
	end
end

function HatcheryMainMenu:layout()
	MainMenu.layout(self)
	
	self.hatcheryOffsetX, self.hatcheryOffsetY  = screenWidth*0.3, screenHeight*0.15
	self.hatcheryScaleX, self.hatcheryScaleY = 0.7,0.7
	
	local button_w, button_h = _G.res.getSpriteBounds("BUTTON_EMPTY")
	

	
	local hatchButton = self:getChild("hatchButton")
	hatchButton.height = screenHeight*0.25
	hatchButton.width = screenWidth*0.2
	hatchButton.x = screenWidth*0.5 + self.hatcheryOffsetX
	hatchButton.y = screenHeight*0.87
	
	local play_button = self:getChild("playButton")
	play_button.scrollAnimationX = 0
	play_button.scrollAnimationY = -screenHeight 
	

	
	local game_logo = self:getChild("gameLogo")
	game_logo.scrollAnimationX = 0
	game_logo.scrollAnimationY = -screenHeight 
	
	local button_w, button_h = _G.res.getSpriteBounds("BUTTON_EMPTY")
	
	
	--left slider
	local options_slider = self:getChild("optionsSlider")
	options_slider.scrollAnimationX = 0
	options_slider.scrollAnimationY = screenHeight * 0.3
	
	local options_button = self:getChild("optionsButton")
	options_button.scrollAnimationX = 0
	options_button.scrollAnimationY = screenHeight * 0.3
	
	--right slider
	local external_slider = self:getChild("externalSlider")
	external_slider.x =  button_w + button_w * 0.55
	external_slider.y = screenHeight - button_h * 0.55
	
	external_slider.scrollAnimationX = 0
	external_slider.scrollAnimationY = screenHeight * 0.3

	
	local external_button = self:getChild("externalButton")
	external_button.x =  button_w + button_w * 0.55
	external_button.y = screenHeight - button_h * 0.55
	
	external_button.scrollAnimationX = 0
	external_button.scrollAnimationY = screenHeight * 0.3
	
	
	local achievements_button = self:getChild("gcAchievementButton")
	if achievements_button then
		achievements_button.scrollAnimationX = 0
		achievements_button.scrollAnimationY = screenHeight * 0.3
	end
	
	local leaderboards_button = self:getChild("gcLeaderboardsButton")
	if leaderboards_button then
		leaderboards_button.scrollAnimationX = 0
		leaderboards_button.scrollAnimationY = screenHeight * 0.3
	end
	
	
	if ABIDEnabled then
		local ABID_button = self:getChild("ABID_button")
		ABID_button.scrollAnimationX = 0
		ABID_button.scrollAnimationY = screenHeight * 0.3
		
		local ABID_text = self:getChild("ABID_text")
		ABID_text.scrollAnimationX = 0
		ABID_text.scrollAnimationY = screenHeight * 0.3
		
	end
end



function HatcheryMainMenu:onPointerEvent(eventType,x,y)
	local result, meta = nil, nil
	
	
	-- because not all the ui elements in the scene are children to this scene, we need to do some custom input handling. First we check if popup is pressed, then top bar and if they were not handling the input, we use the normal input handling
	if self.popup then
		result, meta = self.popup:onPointerEvent(eventType,x,y)
	end
	if result == nil then
		result, meta = MainMenuRoot.onPointerEvent(self,eventType,x,y)
	end
	if result == "PLAY" then
		self:initializeGoToEpisodeSelectionAnimation()
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
	elseif result == Hatchery.hatcheryEvents.EID_HATCHERY_GO_TO_HATCHERY_FROM_MAINMENU then
		self:initializeGoToHatcheryAnimation()
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

	
	return result, meta
end


function HatcheryMainMenu:animateTransition(dt, time)
	
	
	if self.transAnim.state == 0 then
		return
	else
		self.transAnim.timer = _G.math.max(self.transAnim.timer -dt,0)
		local interp =  (self.transAnim.timer/self.transAnim.time)
		
		--go to hatchery animation
		if	self.transAnim.state == 2 then

			if self.transAnim.timer == 0 then
				self.transAnim.state = 0

				self:initializeFromHatcheryAnimation()
				eventManager:notify({id = events.EID_HATCHERY_CLICKED})
			else
				self.hatcheryOffsetX = (1- interp) * self.transAnim.targetX +  interp * self.transAnim.sourceX 
				self.hatcheryOffsetY = (1- interp) * self.transAnim.targetY +  interp * self.transAnim.sourceY 
				
				self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
				self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
				
				self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
				self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
				

				
				self.transAnim.interp = interp
			end
		
		
		--enter from hatchery
		elseif self.transAnim.state == 1 then
			self.hatcheryOffsetX = (1- interp) * self.transAnim.targetX +  interp * self.transAnim.sourceX 
			self.hatcheryOffsetY = (1- interp) * self.transAnim.targetY +  interp * self.transAnim.sourceY 
				
			self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
			self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
				
			self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
			self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
		
			self.transAnim.interp = 1 -  interp

			
		
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0
			end
		
		
		--enter episode selection
		elseif self.transAnim.state == 3 then
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0

				self:initializeFromEpisodeSelectionAnimation()
				eventManager:notify({ id = events.EID_CHANGE_SCENE, target = "EPISODE_SELECTION", from = "MAIN_MENU", })
			else
				
				
				self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
				self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
				
				self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
				self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY

				
				self.transAnim.interp = interp
			end
		--return from episode selection
		elseif self.transAnim.state == 4 then
				
			self.hatcheryScaleX =  (interp) *self.transAnim.sourceScaleX + (1-interp) *self.transAnim.targetScaleX
			self.hatcheryScaleY =  (interp) *self.transAnim.sourceScaleY + (1-interp) *self.transAnim.targetScaleY
		
				
			self.transAnim.drawOffsetX = interp * self.transAnim.drawOffsetSourceX + (1-interp) * self.transAnim.drawOffsetTargetX
			self.transAnim.drawOffsetY = interp * self.transAnim.drawOffsetSourceY + (1-interp) * self.transAnim.drawOffsetTargetY
		
			self.transAnim.interp = 1 -  interp

			
		
			if self.transAnim.timer == 0 then
				self.transAnim.state = 0
			end
		end
	end
	
	
	
	
end

--hatchery transition
function HatcheryMainMenu:initializeGoToHatcheryAnimation()
		self.transAnim.state = 2
		
		self.transAnim.sourceX = self.hatcheryOffsetX
		self.transAnim.sourceY = self.hatcheryOffsetY
		
		self.transAnim.targetX = 0
		self.transAnim.targetY = 0
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = self.hatcheryScaleX, self.hatcheryScaleY 
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 1,1
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = screenWidth
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = 0
		self.transAnim.drawOffsetSourceY = 0
end

function HatcheryMainMenu:initializeFromHatcheryAnimation()
		self.transAnim.state = 1
		
		self.transAnim.sourceX = 0
		self.transAnim.sourceY = 0
		
		self.transAnim.targetX, self.transAnim.targetY = screenWidth*0.3, screenHeight*0.15
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = 1, 1
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.7, 0.7
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = 0
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = screenWidth
		self.transAnim.drawOffsetSourceY = 0
end

--episode selection transition
function HatcheryMainMenu:initializeGoToEpisodeSelectionAnimation()
		self.transAnim.state = 3
		
		self.transAnim.sourceX = self.hatcheryOffsetX
		self.transAnim.sourceY = self.hatcheryOffsetY
		
		self.transAnim.targetX = 0
		self.transAnim.targetY = 0
		
		self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = self.hatcheryScaleX, self.hatcheryScaleY 
		self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.6,0.6
		
		
		self.transAnim.time=0.5
		self.transAnim.timer = self.transAnim.time
		
		self.transAnim.drawOffsetTargetX = screenWidth
		self.transAnim.drawOffsetTargetY = 0
		
		self.transAnim.drawOffsetSourceX = 0
		self.transAnim.drawOffsetSourceY = 0

end

function HatcheryMainMenu:initializeFromEpisodeSelectionAnimation()
	self.transAnim.state = 4
		
	self.transAnim.sourceX = 0
	self.transAnim.sourceY = 0
	
	self.transAnim.targetX, self.transAnim.targetY = screenWidth*0.3, screenHeight*0.15
		
	self.transAnim.sourceScaleX, self.transAnim.sourceScaleY = 0.6, 0.6
	self.transAnim.targetScaleX, self.transAnim.targetScaleY = 0.7, 0.7
		
		
	self.transAnim.time=0.5
	self.transAnim.timer = self.transAnim.time
		
	self.transAnim.drawOffsetTargetX = 0
	self.transAnim.drawOffsetTargetY = 0
		
	self.transAnim.drawOffsetSourceX = screenWidth
	self.transAnim.drawOffsetSourceY = 0
end



filename="MainMenu.lua"
