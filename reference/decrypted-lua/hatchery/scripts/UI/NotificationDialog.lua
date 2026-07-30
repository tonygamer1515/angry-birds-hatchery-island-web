NotificationDialog = ui.Frame:new()

function NotificationDialog:draw(x, y, scaleX, scaleY, angle)
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	ui.Frame.draw(self, x, y, scaleX, scaleY, angle)
end

function NotificationDialog:update(dt, time)	
	ui.Frame.update(self, dt, time) 
end


function NotificationDialog:setup(backgroundImage, okButtonImage, text, font)
	local background = self:getChild("background")
	background:setImage(backgroundImage)	
	
	local okButton = self:getChild("okButton")
	okButton:setImage(okButtonImage)
	
	
	local message = self:getChild("message")	
	message.font = font
	message.text = text
	message.textBoxSize = background.w * 0.8
	message.scaleX = 0.7
	message.scaleY = 0.7
	message:clip()
	
end

function NotificationDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	self:addChild(background)
	
	local okButton = ui.ScallableButton:new()
	okButton.name = "okButton"
	okButton.returnValue = "CONFIRMATION_YES"
	self:addChild(okButton)
	okButton.activateOnRelease = true
	
	local message = ui.Text:new()
	message.name = "message"
	message.hanchor = "HCENTER"
	message.vanchor = "VCENTER"
	
	
	self:addChild(message)			
	
end

function NotificationDialog:setEvents(eventok)
	local okButton = self:getChild("okButton")	
	okButton.returnValue = eventok

end

function NotificationDialog:setText(text)
	local message = self:getChild("message")	
	message.text = text
	message:clip()
end

function NotificationDialog:layout()
	
	local background = self:getChild("background")
	background.x = 0
	background.y = 0
	
	--hardcoded values found by experimenting
	local okButton = self:getChild("okButton")

	okButton.x = 0
	okButton.y = 137
	
	--the background center is not exactly in the sprite half, there is some shadow, so we found this offset by experimenting
	local message = self:getChild("message")
	message.y = -10
	
	Frame.layout(self)	
	
	
	
end

filename="NotificationDialog.lua"
