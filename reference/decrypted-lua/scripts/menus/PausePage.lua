Frame = gamelua.ui.Frame
PausePage = gamelua.ui.Frame:new()
g_pausePageW = 0.20




-- "static" methods used for webview size calculations
PausePage.getTotalW = function()
	local w,h = _G.res.getSpriteBounds("BUTTON_RESUME")
	return  gamelua.screenWidth * g_pausePageW + w / 1.5
end

function PausePage:init()
	self.show = false
	self.extendState = self.extendState or 0
	self.extendSpeed = 5
	self.visible = false
	-- dummyFrame is a frame where to hang other UI components.
	-- this way they will move along dummy frame's x and y coordinates.
	local dummyFrame = gamelua.ui.Frame:new({name = "dummyFrame"})
	self:addChild(dummyFrame)
	
	local buttonBackToMenu = gamelua.ui.ImageButton:new({name = "buttonBackToMenu", returnValue = "BACK_TO_LEVEL_SELECTION"})
	buttonBackToMenu:setImage("BUTTON_MENU")
	dummyFrame:addChild(buttonBackToMenu)
	
	local buttonResume = gamelua.ui.ImageButton:new({name = "buttonResume", returnValue = "BACK_TO_GAME", activateOnRelease = true})
	buttonResume:setImage("BUTTON_RESUME")
	dummyFrame:addChild(buttonResume)
	
	local buttonTutorials = gamelua.ui.ImageButton:new({name = "buttonTutorials", returnValue = "SHOW_TUTORIALS"})
	buttonTutorials:setImage("MENU_TUTORIALS")
	dummyFrame:addChild(buttonTutorials)

	local buttonSounds = gamelua.ui.ToggleButton:new({name = "buttonSounds", returnValue = "TOGGLE_SOUNDS"})
	buttonSounds:setImage({"BUTTON_SFX", "BUTTON_SFX_OFF"})
	dummyFrame:addChild(buttonSounds)
	
	local buttonRestart = gamelua.ui.ImageButton:new({name = "buttonRestart", returnValue = "RESTART_LEVEL"})
	buttonRestart:setImage("BUTTON_RESTART")
	dummyFrame:addChild(buttonRestart)
	
	local levelNumberText = gamelua.ui.Text:new({name = "levelNumberText", font = "FONT_MENU"})
	levelNumberText.textBoxSize = gamelua.screenWidth
	levelNumberText.vanchor = "TOP"
	levelNumberText.hanchor = "HCENTER"
	dummyFrame:addChild(levelNumberText)
	
	-- cached for faster retrieval
	self.dummyFrame = dummyFrame
	
	
	if gamelua.webViewIsSupported then
		local rovioNewsNotLoadedYet = RovioNewsNotLoadedYet:new({name = "rovioNewsNotLoadedYet"})
		self:addChild(rovioNewsNotLoadedYet)	
	end
end

function PausePage:onEntry()	

	local levelNumberText = self:getChild("levelNumberText")
	levelNumberText.text = gamelua.g_currentLevelString or "1"
	levelNumberText:clip()
	Frame.onEntry(self)	
end



function PausePage:layout()

	local sx = 1
	local sy = 1
	
	if gamelua.isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end
	
	self.dummyFrame.x = 0
	self.dummyFrame.y = 0

	local buttonResume = self:getChild("buttonResume")
	buttonResume.x, buttonResume.y  = -buttonResume.w * 0.52, gamelua.screenHeight * 0.5
	
	gamelua.print("positioned resume button @ " .. buttonResume.x .. ";" .. buttonResume.y .. "\n")
	gamelua.print("screen = " .. gamelua.screenWidth .. "x" .. gamelua.screenHeight .. "\n")

	local buttonRestart = self:getChild("buttonRestart")
	buttonRestart.x, buttonRestart.y  =  -PausePage.getTotalW() * 0.5, gamelua.screenHeight * 0.5 - buttonRestart.h * 0.65	* sy

	local buttonBackToMenu = self:getChild("buttonBackToMenu") 
	buttonBackToMenu.x, buttonBackToMenu.y = -PausePage.getTotalW() * 0.5, gamelua.screenHeight * 0.5 + buttonBackToMenu.h * 0.65 * sy
	
	local buttonTutorials = self:getChild("buttonTutorials")
	buttonTutorials.x, buttonTutorials.y = -PausePage.getTotalW() * 0.5 - buttonTutorials.w * 0.5 * sx, gamelua.screenHeight - buttonTutorials.h * sy
	
	local buttonSounds = self:getChild("buttonSounds")
	buttonSounds.x, buttonSounds.y =-PausePage.getTotalW() * 0.5 + buttonSounds.w * 0.5 * sx, buttonTutorials.y
	
	local levelNumberText = self:getChild("levelNumberText")
	levelNumberText.x, levelNumberText.y = -PausePage.getTotalW() * 0.5, _G.res.getFontLeading(levelNumberText.font) * sy
	
	if gamelua.webViewIsSupported then
		local rovioNewsNotLoadedYet = self:getChild("rovioNewsNotLoadedYet")
		rovioNewsNotLoadedYet.x = 0
		rovioNewsNotLoadedYet.y = 0	
	end
	
	
	for _, v in _G.ipairs(self.dummyFrame.children) do
		v.scaleX = sx
		v.scaleY = sy
	end
	
	Frame.layout(self)	
	
end


function PausePage:update(dt,time)

	if self.extendState == 0 and not self.show then	
		return
	end

	if self.extendState < 1 and self.show then
		self.extendState = _G.math.min(self.extendState + (self.extendSpeed * dt), 1.0)
	elseif self.extendState > 0 and not self.show then
		self.extendState = _G.math.max(self.extendState - (self.extendSpeed * dt), 0.0)		
		if self.extendState <= 0 then
			self.visible = false
		end
	end
	
	if self.visible and self.show and self.extendState == 1 then
		if _G.res.isAudioPlaying(gamelua.currentMusic) == false and gamelua.currentMusic ~= nil then
			_G.res.playAudio(gamelua.currentMusic, 1, true,7)
		end
		
	end
	
	--gamelua.print("update..")
	--self.dummyFrame.x = self.extendState * gamelua.screenWidth * g_pausePageW
	self.dummyFrame.x = self.extendState * PausePage.getTotalW()
	Frame.update(self)
end

function PausePage:draw(x, y, scaleX, scaleY)

	
	
	if self.visible == true and gamelua.g_tutorialActive == nil then
		-- background 
		gamelua.drawRect(0,0,0,self.extendState * 0.75,0,0, gamelua.screenWidth, gamelua.screenHeight, false)
		-- 
		gamelua.drawRect(0,0,0,0.75,0,0, PausePage.getTotalW() * self.extendState, gamelua.screenHeight, false)	

		Frame.draw(self, x, y, scaleX, scaleY)
	end
end

function PausePage:showPage()
	self.show = true
	self.visible = true
	if gamelua.webViewIsSupported then
		local rovioNewsNotLoadedYet = self:getChild("rovioNewsNotLoadedYet")
		
		if RovioNewsNotLoadedYet.rovioNewsWasLoaded == true then
			rovioNewsNotLoadedYet.visible = false
		else
			rovioNewsNotLoadedYet.visible = true		
		end		
	end
	
	gamelua.showPauseMenu(dt)
end

function PausePage:hidePage()
	self.show = false	
	gamelua.loginfo("Closing pause page from hide page()")
	
	
	if gamelua.webViewIsSupported then
		local rovioNewsNotLoadedYet = self:getChild("rovioNewsNotLoadedYet")
		rovioNewsNotLoadedYet.visible = false		
	end
	
	gamelua.eventManager:notify({id = gamelua.events.EID_PAUSE_PAGE_CLOSED})
end

function PausePage:onExit()
	gamelua.ui.Frame.onExit(self)
	gamelua.loginfo("Closing pause page from onExit()")
	gamelua.eventManager:notify({id = gamelua.events.EID_PAUSE_PAGE_CLOSED})
end


RovioNewsNotLoadedYet = Frame:new()

function RovioNewsNotLoadedYet:onEntry()
	gamelua.eventManager:addEventListener(gamelua.events.EID_ROVIO_NEWS_SHOWN, self)
	gamelua.ui.Frame.onEntry(self)
end

function RovioNewsNotLoadedYet:eventTriggered(event)
	if event.id == gamelua.events.EID_ROVIO_NEWS_SHOWN then
		RovioNewsNotLoadedYet.rovioNewsWasLoaded = true
	end
end	

function RovioNewsNotLoadedYet:init()

	local image = gamelua.ui.Image:new({name = "image"})
	image:setImage("ROVIO_NET_CONNECTING")
	self:addChild(image)
end

function RovioNewsNotLoadedYet:layout()

	local sx = 1
	local sy = 1
	
	if gamelua.isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end
	
	if RovioNewsNotLoadedYet.rovioNewsWasLoaded == true then
		self.visible = false
	end
	
	local image = self:getChild("image")
	image.x = PausePage.getTotalW() + (gamelua.screenWidth - PausePage.getTotalW()) / 2
	image.y = gamelua.screenHeight / 2
	image.scaleX = sx
	image.scaleY = sy
end

function RovioNewsNotLoadedYet:onExit()	
	gamelua.ui.Frame.onExit(self)
	gamelua.eventManager:removeEventListener(gamelua.events.EID_ROVIO_NEWS_SHOWN, self)
end




filename="PausePage.lua"
