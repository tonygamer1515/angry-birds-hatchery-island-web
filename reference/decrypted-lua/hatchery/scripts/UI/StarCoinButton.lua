StarCoinButton = Frame:new()

function StarCoinButton:init()
	Frame.init(self)
	local background = ImageButton:new()
	background.name = "background"
	background:setImage("H_BANK_BG")
	self:addChild(background)
	--background.sound = getHatcherySound("ok")
	background.activateOnRelease = true	
	

	local text = Text:new()
	text.name = "text"
	self:addChild(text)
	
	local logo = Image:new()
	logo.name = "logo"
	self:addChild(logo)
	
	local buy = Image:new()
	buy.name = "buy"
	self:addChild(buy)

end


function StarCoinButton:setupImages(img1, img2)
	self:getChild("logo"):setImage(img1)
	self:getChild("buy"):setImage(img2)
end

function StarCoinButton:setReturnValue(val)
	self:getChild("background").returnValue = val
	
end

function StarCoinButton:setText(text)
	self:getChild("text").text = text
end

function StarCoinButton:layout()
	local background = self:getChild("background")
	local text = self:getChild("text")
	local logo = self:getChild("logo")
	local buy = self:getChild("buy")
	local w,h = _G.res.getSpriteBounds(background.image)
	
	-- background.x = self.x
	-- background.y = self.y
	
	-- text.x = self.x + w * 0.1
	-- text.y = self.y - h * 0.07
	
	-- logo.x = self.x - w * 0.3 
	-- logo.y = self.y - h * 0.05
	
	-- buy.x = self.x + w * 0.52
	-- buy.y = self.y - h * 0.05
	
	background.x = 0
	background.y = 0
	
	text.x = w * 0.1
	text.y = - h * 0.07
	
	logo.x = - w * 0.3 
	logo.y = - h * 0.05
	
	buy.x = w * 0.52
	buy.y = - h * 0.05
end
filename="StarCoinButton.lua"
