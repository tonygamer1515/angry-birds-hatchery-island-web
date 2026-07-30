-------------------

Prompt = gamelua.ui.Frame:new()

function Prompt:init()
	
	local bg = gamelua.ui.BGBox:new()
	bg.name = "bg"
	--bg:setSize(gamelua.screenWidth * 0.8, gamelua.screenHeight * 0.8)
	bg.hanchor = "LEFT"
	bg.vanchor = "TOP"	
	self:addChild(bg)
	
	local title = gamelua.ui.Text:new({name = "title", text = self.title})
	title.vanchor = "TOP"
	title.hanchor = "HCENTER"
	bg:addChild(title)	
	
	local content = gamelua.ui.Text:new({name = "content", text = self.content})
	content.vanchor = "VCENTER"
	content.hanchor = "HCENTER"
	bg:addChild(content)
	
	local close = gamelua.ui.ImageButton:new({name = "close"})
	close:setImage("MENU_YES")
	close.returnValue = "CLOSE"
	bg:addChild(close)
	
end

function Prompt:onEntry()
	self.appearCounter = 0
	gamelua.ui.Frame.onEntry(self)
end	

function Prompt:layout()
	
	local title = self:getChild("title")
	title.textBoxSize = gamelua.screenWidth * 0.8
	title:clip()
	
	local close = self:getChild("close")
	
	local content = self:getChild("content")
	--content.y = title.y + _G.res.getFontLeading(title.font) * 2

	local bg = self:getChild("bg")
	bg:setSize(gamelua.screenWidth * 0.7, _G.math.min(gamelua.screenHeight * 0.80, _G.math.max(gamelua.screenHeight * 0.1, content:getHeight() * 3 +  title:getHeight() + close.h)))
	bg.x = (gamelua.screenWidth - bg.width) * 0.5
	bg.y = (gamelua.screenHeight - bg.height) * 0.5

	content.textBoxSize =  bg.width * 0.7
	content:clip()
		
	close.y = bg.height 
	close.x = bg.width - close.w 
	
	title.y = 0 -- -bg.height * 0.5 
	title.x = bg.width * 0.5
	
	content.x = title.x
	content.y = bg.height * 0.5
	
	gamelua.ui.Frame.layout(self)
end

function Prompt:onPointerEvent(eventType,x,y)


	local result, meta = gamelua.ui.Frame.onPointerEvent(self,eventType,x,y)
	if result == "CLOSE" then
		gamelua.eventManager:notify({id = gamelua.events.EID_POP_FRAME})		
	end
	-- blocking
	return -1
end
	
function Prompt:update(dt,time)
	

	self.appearCounter = _G.math.min(self.appearCounter + dt * 2, 0.7)	
end
	
function Prompt:draw(x,y)
	gamelua.drawRect(0, 0, 0,  self.appearCounter, 0,0,gamelua.screenWidth, gamelua.screenHeight,false)
	gamelua.ui.Frame.draw(self,x,y)	
end
	

filename="Prompt.lua"
