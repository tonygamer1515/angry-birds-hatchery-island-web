SpendStarConfirmationDialog = ConfirmationDialog:new()
Frame = ui.Frame

function SpendStarConfirmationDialog:init()
	ConfirmationDialog.init(self)	
	
	local star = ui.Image:new()
	star.name = "star"
	star.attach = "fixed"
	star:setImage("H_STAR_MEDIUM")
	self:addChild(star)
	
	local starText = ui.Text:new()
	starText.name = "starText"
	starText.attach = "fixed"
	starText.hanchor = "LEFT"
	starText.vanchor = "VCENTER"
	starText.text = "1"
	self:addChild(starText)		
	
end

function SpendStarConfirmationDialog:setStarImage(image)
	local star = self:getChild("star")	
	star:setImage(image)
end

function SpendStarConfirmationDialog:setTotalStarCost(stars)
	local starText = self:getChild("starText")
	starText.text = "" .. stars
	self:layout()
end

function SpendStarConfirmationDialog:layout()
	ConfirmationDialog.layout(self)	
	
	
	local background = self:getChild("background")	
	local star = self:getChild("star")	
	local starText = self:getChild("starText")
	
	local starOffsetY = 40
	local message = self:getChild("message")
	local totalHeight = message:getHeight() + starOffsetY + starText:getHeight()
	local messageTop = -totalHeight*0.5
	
	local messageOffsetY = -10
	message.y = messageTop + message:getHeight()* 0.5 + messageOffsetY
	
	
	
	local stringWidth = 0
	
	if starText.text ~= nil then
		stringWidth = _G.res.getStringWidth(starText.text)
	end
	
	local starPivotX, starPivotY = _G.res.getSpritePivot("", star.image)
	
	local spacing = 10
	
	star.x = -( (spacing + stringWidth + star.w) * 0.5) + starPivotX
	-- star.y = background.h * 0.2
	star.y = message.y + message:getHeight() * 0.5 + starOffsetY
	
	starText.x = ( (spacing + stringWidth + star.w) * 0.5) - stringWidth
	starText.y = star.y
end

filename="SpendStarConfirmationDialog.lua"
