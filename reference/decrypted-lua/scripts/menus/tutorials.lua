g_tutorialSprites =
{
	TUTORIAL_1 = "TUTORIAL_RED",
	TUTORIAL_2 = "TUTORIAL_BLUE",
	TUTORIAL_3 = "TUTORIAL_YELLOW",
	TUTORIAL_4 = "TUTORIAL_BLACK",
	TUTORIAL_5 = "TUTORIAL_WHITE",
	TUTORIAL_6 = "TUTORIAL_BOOMERANG",
	TUTORIAL_7 = "TUTORIAL_BIG_BROTHER",
	TUTORIAL_8 = "TUTORIAL_MIGHTYEAGLE",
	TUTORIAL_9 = "TUTORIAL_PUFFER",
}

Tutorial = BackgroundBox:new()

function Tutorial:new(tutorial, o)
	local o = o or {}
	o.tutorial = tutorial
	return BackgroundBox.new(self, o)
end

function Tutorial:init()
	BackgroundBox.init(self)
	
	self.hanchor = "HCENTER"
	self.vanchor = "VCENTER"

	self.components =
	{
		left = "TUTORIAL_LEFT",
		bottomLeft = "TUTORIAL_BOTTOM_LEFT",
		bottomMiddle = "TUTORIAL_BOTTOM_MIDDLE",
		bottomRight = "TUTORIAL_BOTTOM_RIGHT",
		right = "TUTORIAL_RIGHT",
		topRight = "TUTORIAL_TOP_RIGHT",
		topMiddle = "TUTORIAL_TOP_MIDDLE",
		topLeft = "TUTORIAL_TOP_LEFT", 
		center = "TUTORIAL_CENTER",
	}
	
	local tutorial = ui.Image:new()
	tutorial.name = "tutorial"
	tutorial:setImage(g_tutorialSprites[self.tutorial])
	self:addChild(tutorial)
	
	if self.tutorial == "TUTORIAL_5" and not settingsWrapper:isGoldenEggUnlocked("LevelGE_4") and g_tutorialActive and g_tutorialActive.from == "PAUSE_PAGE" then
		local golden_egg = ui.ImageButton:new()
		golden_egg.name = "goldenEgg"
		golden_egg:setImage("GOLDEN_EGG_1")
		golden_egg.scaleX = 0.4
		golden_egg.scaleY = 0.4
		golden_egg.returnValue = "COLLECT_GOLDEN_EGG"
		self:addChild(golden_egg)
	end
	
	local close = ui.ImageButton:new()
	close.name = "close"
	close:setImage("TUTORIAL_OK")
	close.returnValue = "CLOSE_TUTORIAL"
	self:addChild(close)
end

function Tutorial:layout()
	BackgroundBox.layout(self)
	
	local sx = 1
	local sy = 1
	if isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end

	self.x = screenWidth * 0.5
	self.y = screenHeight * 0.5

	local max_w = 0
	local max_h = 0
	
	for _, v in _G.pairs(g_tutorialSprites) do
		local x1, y1, x2, y2 = _G.res.getCompoSpriteBounds(v)
		local w = x2 - x1
		local h = y2 - y1
		if w > max_w then
			max_w = w
		end
		if h > max_h then
			max_h = h
		end
	end
	
	self.width = max_w * sx
	self.height = max_h * sy
	
	local x1, y1, x2, y2 = _G.res.getCompoSpriteBounds(self:getChild("tutorial").image)
	local sw = x2 - x1
	local sh = y2 - y1
	
	local golden_egg = self:getChild("goldenEgg")
	if golden_egg then
		golden_egg.x = sw * 0.18 * sx
		golden_egg.y = sh * -0.1 * sy
	end
	
	local close = self:getChild("close")
	close.x = max_w * 0.35 * sx
	close.y = max_h * 0.6 * sy
	
	for _, v in _G.ipairs(self.children) do
		v.scaleX = sx
		v.scaleY = sy
	end
end

function Tutorial:onPointerEvent(eventType, x, y)
	local result, meta, item = BackgroundBox.onPointerEvent(self, eventType, x, y)
	
	if result == "COLLECT_GOLDEN_EGG" then
		self:getChild("goldenEgg").visible = false
		eventManager:notify({ id = events.EID_GOLDEN_EGG_FROM_MENU, levelName = "LevelGE_4", })
	elseif result == "CLOSE_TUTORIAL" then
		eventManager:notify({ id = events.EID_CLOSE_TUTORIAL, })
	end

	return result, meta, item
end

function Tutorial:draw(x, y)
	drawRect(0, 0, 0, 0.65, 0, 0, screenWidth, screenHeight, false)
	--if isRetinaGraphicsEnabled() then
	--	BackgroundBox.draw(self, x, y, 2, 2)
	--else
		BackgroundBox.draw(self, x, y)
	--end
end

filename="tutorials.lua"
