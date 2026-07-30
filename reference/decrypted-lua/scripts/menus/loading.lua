LoadingPage = ui.Frame:new()

function LoadingPage:draw(x, y)
	drawRect(0, 0, 0, 172, 0, 0, screenWidth, screenHeight, false)
	ui.Frame.draw(self, x, y)
end

LevelLoadingPage = LoadingPage:new()

function LevelLoadingPage:new(o)
	local o = o or {}
	--o.level_name = level_name
	return LoadingPage.new(self, o)
end

function LevelLoadingPage:init()
	--self.frame = 0
	LoadingPage.init(self)
	
	local loading_text = ui.Text:new()
	loading_text.name = "loadingText"
	loading_text.font = fontBasic
	loading_text.text = "MI_LOADING"
	loading_text.hanchor = "HCENTER"
	loading_text.vanchor = "VCENTER"
	self:addChild(loading_text)
end

function LevelLoadingPage:update(dt)
	LoadingPage.update(self, dt)
end


function LevelLoadingPage:layout()
	LoadingPage.layout(self)
	local loading_text = self:getChild("loadingText")
	loading_text.x = screenWidth * 0.5
	loading_text.y = screenHeight * 0.5	
	
end

filename="loading.lua"
