InfoFrame = gamelua.ui.Frame:new()



function InfoFrame:init()
	local bgbox = gamelua.ui.BGBox:new()
	bgbox.name = "bgbox"
	bgbox.components = {topLeft = "SCORE_TOP_LEFT", left = "SCORE_LEFT", bottomLeft = "SCORE_BOTTOM_LEFT", bottomMiddle = "SCORE_BOTTOM_MIDDLE",
				  bottomRight = "SCORE_BOTTOM_RIGHT", right = "SCORE_RIGHT", topRight = "SCORE_TOP_RIGHT", topMiddle = "SCORE_TOP_MIDDLE",
				  center = "SCORE_CENTER"}
	
	local backButton = gamelua.ui.ImageButton:new()
	backButton.name = "backButton"
	backButton:setImage("LS_BACK_BUTTON")
	backButton.returnValue = "CLOSE"
	
	local txt = gamelua.ui.Text:new({text = "THIS IS A FRAME FOR TESTING..CLOSE"})
	txt.name = "text"
	txt:clip()
	self:addChild(bgbox)
	self:addChild(backButton)
	self:addChild(txt)
end


function InfoFrame:onPointerEvent(eventType,x,y)
	local result,meta = gamelua.ui.Frame.onPointerEvent(self,eventType,x,y)
	gamelua.print(_G.tostring(result))
	if(result == "CLOSE") then
		gamelua.eventManager:notify({id = gamelua.events.EID_POP_FRAME, target = "INFO_FRAME"})
	end
	return -1
end


function InfoFrame:layout()
	local backButton = self:getChild("backButton")
	backButton.x = gamelua.screenWidth / 2
	backButton.y = gamelua.screenWidth / 2
	
	local bgbox = self:getChild("bgbox")	
	bgbox.x = 20
	bgbox.y = 20
	bgbox.width = gamelua.screenWidth
	bgbox.height = gamelua.screenHeight

	local txt = self:getChild("text")
	txt.x = gamelua.screenWidth / 2
	txt.y = gamelua.screenHeight * 0.20
	gamelua.ui.Frame.layout(self)
	
	
end


filename="infoFrame.lua"
