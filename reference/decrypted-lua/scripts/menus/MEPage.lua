MEPage = ui.Frame:new()



function MEPage:init()
	ui.Frame.init(self)
	self.shade = self.shade or 0
	
	local bg = ui.Image:new({name = "bg"})
	bg:setImage("CHALLENGE_LIST_SHADOW_MIDDLE")
	self:addChild(bg)	
	
	local title = ui.Image:new({name = "title"})
	title:setImage("UPSELL_EAGLE_LOGO")
	bg:addChild(title)
	
	local eagle = ui.Image:new({name = "eagle"})
	eagle:setImage("MIGHTY_EAGLE_SILHOUETTE")
	bg:addChild(eagle)
	
	
	local closeButton = ui.ImageButton:new({name = "closeButton"})	
	closeButton.returnValue = "CLOSE"
	closeButton:setImage("BUTTON_UPSELL_NO")	
	closeButton.clickSound = "menu_back"
	bg:addChild(closeButton)
	
	local trailerButton = ui.ImageButton:new({name = "trailerButton"})	
	trailerButton.returnValue = "SHOW_TRAILER_CLICKED"
	trailerButton:setImage("BUTTON_UPSELL_TRAILER")	
	bg:addChild(trailerButton)
	
	local buyButton = ui.ImageButton:new({name = "buyButton"})	
	buyButton.returnValue = "EAGLE_PURCHASE_CLICKED"
	buyButton:setImage("EAGLE_SHOPPING_CART_BUTTON")	
	bg:addChild(buyButton)
	
	
	local ti = ui.Text:new()
	ti.hanchor = "HCENTER"
	ti.vanchor = "TOP"
	ti.text = "TEXT_EAGLE_UPSELL"
	ti.name = "sellText"
	bg:addChild(ti)
	
	local ti2 = ui.Text:new()
	ti2.hanchor = "HCENTER"
	ti2.vanchor = "HCENTER"
	ti2.text = "TEXT_EAGLE_UPSELL2"
	ti2.name = "sellText2"
	bg:addChild(ti2)
	
end



function MEPage:onEntry()
	ui.Frame.onEntry(self)
	self.visible = true
	--self.shade = 0	
	settingsWrapper:setMightyEagleUpsellPageViewed()
end


function MEPage:layout()
	local bg = self:getChild("bg")
	
	local sx = 1
	local sy = 1

	if isRetinaGraphicsEnabled() then
		sx = 2
		sy = 2
	end
	
	for _, v in _G.ipairs(bg.children) do
		v.scaleX = sx
		v.scaleY = sy
	end
	
	if deviceModel ~= "ipad" then
		bg:setSize(screenWidth, screenHeight)	
	else
		bg:setSize(screenWidth * 0.40, screenHeight)	
	end
	
	bg.x = screenWidth * 0.5 - bg.w * 0.5
	bg.y = 0

	local title = bg:getChild("title")
	title.x = bg.w * 0.5 - title.w * 0.5 * sx
	title.y = screenHeight * 0.02 * sy

	local ti = self:getChild("sellText")
	ti.textBoxSize = bg.w * 0.8
	ti:clip()
	--print("clipping to width " .. bg.w * 0.8 .. "\n")
	ti.y = title.y + title.h * 1.2 * sy
	ti.x = bg.w * 0.5
	
	local diff = bg.h * 0.90 - (ti.y + ti.textBlockHeight)
	
	local ti2 = self:getChild("sellText2")
	ti2.textBoxSize = bg.w * 0.8
	ti2.x = bg.w * 0.5
	ti2:clip()

	local eagle = bg:getChild("eagle")
	eagle.x = bg.w * 0.5
	eagle.y = ti.y + ti.textBlockHeight + diff * 0.5 - ti2.textBlockHeight

	local diff2 =  bg.h * 0.90 -(eagle.y + eagle.h * 0.5 * sy) 
	--------------------------------
	ti2.y = eagle.y + diff2 * 0.5
	--------------------------------
	
	local buyButton = bg:getChild("buyButton")
	local close = bg:getChild("closeButton")
	
	buyButton.x = bg.w - close.w * sx
	buyButton.y = screenHeight - buyButton.h * 0.55 * sy
	
	close.x = close.w * sx
	close.y = buyButton.y
	
	local trailerButton = bg:getChild("trailerButton")
	trailerButton.x = bg.w * 0.5
	trailerButton.y = buyButton.y
	
	ui.Frame.layout(self)
end

function MEPage:onPointerEvent(eventType, x, y)
	local result, meta, item = ui.Frame.onPointerEvent(self, eventType, x, y)
	
	if result == "SHOW_TRAILER_CLICKED" then
		eventManager:queueEvent({id = events.EID_MIGHTY_EAGLE_TRAILER_CLICKED})
	end
	
	return result, meta, item
end

--[[
function MEPage:onPointerEvent(eventType,x,y)
	local result, meta =  ui.Frame.onPointerEvent(self,eventType,x,y)
	if result == "CLOSE" then
		eventManager:queueEvent({id = events.EID_MIGHTY_EAGLE_PURCHASE_CLOSE_CLICKED, from = self.from})
	elseif result == "SHOW_TRAILER_CLICKED" then
		eventManager:queueEvent({id = events.EID_MIGHTY_EAGLE_TRAILER_CLICKED})		
	elseif result == "EAGLE_PURCHASE_CLICKED" then
		eventManager:queueEvent({id = events.EID_MIGHTY_EAGLE_PURCHASE_CLICKED})	
	end	
	return -1
end
]]--

function MEPage:update(dt,time)
	self.shade =  _G.math.min(self.shade + dt * 2,0.65)
	ui.Frame.update(self,dt,time)
end

function MEPage:onExit()
	self.visible = false
	ui.Frame.onExit(self)		
end

EaglePurchasePage = ui.Frame:new()

function EaglePurchasePage:init()
	ui.Frame.init(self)
	local spinner = ui.Image:new()
	spinner.name = "spinner"
	spinner:setImage("IN_APP_LOADING")
	self:addChild(spinner)
end

function EaglePurchasePage:layout()
	ui.Frame.layout(self)
	local spinner = self:getChild("spinner")
	spinner.x = screenWidth * 0.5
	spinner.y = screenHeight * 0.5
	
	if isRetinaGraphicsEnabled() then
		spinner.scaleX = 2
		spinner.scaleY = 2
	else
		spinner.scaleY = 1
		spinner.scaleY = 1
	end
end

function EaglePurchasePage:update(dt, time)
	ui.Frame.update(self, dt, time)
	local spinner = self:getChild("spinner")
	spinner.angle = spinner.angle + dt * 10
end

function EaglePurchasePage:draw(x, y, scaleX, scaleY, angle)
	setRenderState(0, 0, 1, 1, 0, 0, 0)
	drawRect(0, 0, 0, 0.65, 0, 0, screenWidth, screenHeight, true)
	ui.Frame.draw(self, x, y, scaleX, scaleY, angle)
end

IngameEaglePage = ui.Frame:new()

function IngameEaglePage:init()
	local eagle_frame = MEPage:new()
	self:addChild(eagle_frame)
end

function IngameEaglePage:onEntry()
	ui.Frame.onEntry(self)
end

function IngameEaglePage:onPointerEvent(eventType, x, y)
	local result, meta, item = ui.Frame.onPointerEvent(self, eventType, x, y)
	
	if result == "CLOSE" then
		eventManager:notify({ id = events.EID_MIGHTY_EAGLE_PURCHASE_CLOSE_CLICKED, from = "INGAME", })
	elseif result == "EAGLE_PURCHASE_CLICKED" then
		goToMightyEaglePaymentPage()
	end
	
	return result, meta, item
end

function IngameEaglePage:draw(x, y)
	drawGame()
	ui.Frame.draw(self, x, y)
end

IngameEaglePurchasePage = ui.Frame:new()

function IngameEaglePurchasePage:init()
	local purchase_frame = EaglePurchasePage:new()
	self:addChild(purchase_frame)
end

function IngameEaglePurchasePage:draw(x, y)
	drawGame()
	ui.Frame.draw(self, x, y)
end

filename="MEPage.lua"
