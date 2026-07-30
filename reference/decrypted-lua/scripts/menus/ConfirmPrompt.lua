-------------------

ConfirmPrompt = gamelua.ui.Frame:new()

function ConfirmPrompt:init()
	
	local bg = gamelua.ui.BGBox:new()
	
	bg.name = "bg"
	--bg:setSize(gamelua.screenWidth * 0.8, gamelua.screenHeight * 0.8)
	bg.hanchor = "LEFT"
	bg.vanchor = "TOP"	
	self:addChild(bg)
	
	self.confirmOnLeft = self.confirmOnLeft or false
	
	
	local title = gamelua.ui.Text:new({name = "title", text = self.title})
	title.vanchor = "TOP"
	title.hanchor = "HCENTER"
	bg:addChild(title)	
	
	if self.content ~= nil then
		local content = gamelua.ui.Text:new({name = "content", text = self.content})
		content.vanchor = "VCENTER"
		content.hanchor = "HCENTER"
		bg:addChild(content)	
	end
	
	local close = gamelua.ui.ImageButton:new({name = "close"})
	close:setImage("MENU_NO")
	close.returnValue = "CLOSE"
	bg:addChild(close)
	
	local confirm = gamelua.ui.ImageButton:new({name = "confirm"})
	confirm:setImage("MENU_YES")
	confirm.returnValue = self.returnValue
	bg:addChild(confirm)
	
end

function ConfirmPrompt:onEntry()
	self.appearCounter = 0
end	

function ConfirmPrompt:layout()
	
	local title = self:getChild("title")
	title.textBoxSize = gamelua.screenWidth * 0.8
	title:clip()
	
	local close = self:getChild("close")
	
	local content = self:getChild("content")
	--content.y = title.y + _G.res.getFontLeading(title.font) * 2

	local bg = self:getChild("bg")
	if content ~= nil then
		bg:setSize(gamelua.screenWidth * 0.7, _G.math.min(gamelua.screenHeight * 0.80, _G.math.max(gamelua.screenHeight * 0.1, content:getHeight() * 3 +  title:getHeight() + close.h)))	
	else
		bg:setSize(_G.math.min(gamelua.screenWidth * 0.7, title:getWidth()), _G.math.min(gamelua.screenHeight * 0.80, _G.math.max(0, title:getHeight() + close.h * 0.5)))	
	end
	
	bg.x = (gamelua.screenWidth - bg.width) * 0.5
	bg.y = (gamelua.screenHeight - bg.height) * 0.5

	if content ~= nil then
		content.textBoxSize =  bg.width * 0.7
		content:clip()		
	end
		
	close.y = bg.height + bg:getBottomBlockH() * 0.5
	--close.x = bg.width - close.w 
	close.x = close.w
	title.y = 0 -- -bg.height * 0.5 
	title.x = bg.width * 0.5
	
	if content ~= nil then
		content.x = title.x
		content.y = bg.height * 0.5		
	end
	
	local confirm = self:getChild("confirm")
	confirm.y = bg.height + bg:getBottomBlockH() * 0.5
	confirm.x = bg.width - close.w
	
	if self.confirmOnLeft == true then
		local temp = close.x
		close.x = confirm.x
		confirm.x = temp
	end
	
	gamelua.ui.Frame.layout(self)
end

function ConfirmPrompt:onPointerEvent(eventType,x,y)


	local result, meta = gamelua.ui.Frame.onPointerEvent(self,eventType,x,y)
	if result == "CLOSE" then
		gamelua.eventManager:notify({id = gamelua.events.EID_POP_FRAME})		
	elseif result == self.returnValue then
		gamelua.eventManager:notify({id = self.returnValue})				
	end
	-- blocking
	return -1
end
	
function ConfirmPrompt:update(dt,time)
	self.appearCounter = _G.math.min(self.appearCounter + dt * 2, 0.7)	
end
	
function ConfirmPrompt:draw(x,y)
	gamelua.drawRect(0, 0, 0,  self.appearCounter, 0,0,gamelua.screenWidth, gamelua.screenHeight,false)
	gamelua.ui.Frame.draw(self,x,y)	
end
	

filename="ConfirmPrompt.lua"
