ConfirmationDialog = ui.Frame:new()
Frame = ui.Frame

function ConfirmationDialog:draw(x, y, scaleX, scaleY, angle)
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	ui.Frame.draw(self, x, y, scaleX, scaleY, angle)
end

function ConfirmationDialog:update(dt, time)	
	ui.Frame.update(self, dt, time) 
end

function ConfirmationDialog:starCountUpdated()
	self:layout()
end

function ConfirmationDialog:setup(backgroundImage, yesButtonImage, noButtonImage, text, font)
	local background = self:getChild("background")
	background:setImage(backgroundImage)	
	
	local yesButton = self:getChild("yesButton")
	yesButton:setImage(yesButtonImage)
	
	
	local noButton = self:getChild("noButton")
	noButton:setImage(noButtonImage)
	
	local message = self:getChild("message")	
	message.font = font
	message.text = text
	message.textBoxSize = background.w * 0.8
	message.scaleX = 1
	message.scaleY = 1
	message:clip()
	
end

function ConfirmationDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	self:addChild(background)
	
	local yesButton = ui.ScallableButton:new()
	yesButton.name = "yesButton"
	yesButton.returnValue = "CONFIRMATION_YES"
	self:addChild(yesButton)
	yesButton.activateOnRelease = true
	
	local noButton = ui.ScallableButton:new()
	noButton.name = "noButton"
	noButton.returnValue = "CONFIRMATION_NO"
	self:addChild(noButton)		
	noButton.activateOnRelease = true
	
	local message = ui.Text:new()
	message.name = "message"
	message.hanchor = "HCENTER"
	message.vanchor = "VCENTER"
	
	
	self:addChild(message)			
	
end

function ConfirmationDialog:setEvents(eventYes, eventNo)
	local yesButton = self:getChild("yesButton")	
	yesButton.returnValue = eventYes
	
	local noButton = self:getChild("noButton")	
	noButton.returnValue = eventNo
end

function ConfirmationDialog:setText(text)
	local message = self:getChild("message")	
	message.text = text
	message:clip()
end

function ConfirmationDialog:layout()
	
	local background = self:getChild("background")
	background.x = 0
	background.y = 0
	
	--hardcoded values found by experimenting
	local yesButton = self:getChild("yesButton")
	yesButton.x = -background.w * (69/485)
	-- yesButton.y = background.h * 0.4
	yesButton.y = background.h * (137/344)
	-- yesButton.x = -69
	-- yesButton.y = 137
	
	local noButton = self:getChild("noButton")
	noButton.x = background.w * (104/485)	
	noButton.y = yesButton.y
	-- noButton.x = 104
	-- noButton.y = 137
	
	--the background center is not exactly in the sprite half, there is some shadow, so we found this offset by experimenting
	local message = self:getChild("message")
	message.y = -10
	
	Frame.layout(self)	
	
	
	
end

filename="ConfirmationDialog.lua"
