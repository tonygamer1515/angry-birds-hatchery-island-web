
Shade = gamelua.ui.Frame:new()
m_pageW = 0
m_pageH = 0
m_pageX = 0
m_pageY = 0

function Shade:init()
	self.alpha = 0
	self.fadeInTime = 0.5
	self.maxAlpha = 0.70
end
	
function Shade:draw(x,y)
	gamelua.drawRect( 0, 0, 0,self.alpha, 0, 0, gamelua.screenWidth, gamelua.screenHeight, false)			
	gamelua.ui.Frame.draw(self,x,y)
end	
	
function Shade:onEntry()
	self.alpha = 0
	gamelua.ui.Frame.onEntry(self)
end
	
function Shade:update(dt,time)

	gamelua.ui.Frame.update(self,dt,time)
	self.alpha = self.alpha + dt / self.fadeInTime
	if(self.alpha > self.maxAlpha) then self.alpha = self.maxAlpha end
end


MEShopRootPage = gamelua.ui.Frame:new()

function MEShopRootPage:init()
		
		local bgShade = Shade:new()
		local rootPage = gamelua.ui.BGBox:new()
		local shopScroll = gamelua.ui.ScrollFrame:new()		
		
		local exitButton = gamelua.ui.ImageButton:new()
		exitButton.name = "exitButton"
		exitButton:setImage("BUTTON_UPSELL_NO")
		exitButton.returnValue = ""

		shopScroll.name = "shopScroll"		
		rootPage.name = "rootPage"
		bgShade.name = "bgShade"		

		-- Dragging disabled for now
		 shopScroll.draggable = false
		
		self:addChild(bgShade)
		self:addChild(rootPage)
		rootPage:addChild(shopScroll)		
		rootPage:addChild(exitButton)
		

		local page = MEPage:new()
		shopScroll:addChild(page)
	
		local page = AdsShopPage:new()
		shopScroll:addChild(page)
		
		
end

function MEShopRootPage:layout()
	local rootPage = self:getChild("rootPage")
	local shopScroll = self:getChild("shopScroll")
	local exitButton = self:getChild("exitButton")

	local w,h = _G.res.getSpriteBounds("POPUP_TOP_LEFT")
	local wExit,hExit = _G.res.getSpriteBounds(exitButton.image)
	w = w * 1.2
	
	-- Limit maximum width of the page
	local maxWidth = _G.math.min(gamelua.screenWidth * 0.99 - w, 600)
	rootPage.x = w + (gamelua.screenWidth - maxWidth) * 0.5
	rootPage.y = h + hExit * 0.25
	
	rootPage.width = maxWidth - w * 2
	rootPage.height = _G.math.max(gamelua.screenHeight * 0.90 - rootPage.y - h, 150)
	
	m_pageW = rootPage.width
	m_pageH = rootPage.height
	m_pageX = rootPage.x
	m_pageY = rootPage.y
	
	local MEPage = self:getChild("MEPage")
	MEPage.x = 0
	
	local adsPage = self:getChild("AdsShopPage")
	adsPage.x = rootPage.width


	shopScroll.anchors = {{0,0}, {-rootPage.width,0}}
	shopScroll.x = 0
	shopScroll.y = 0
	shopScroll.clip = {}
	shopScroll.clip.clipW = rootPage.width
	shopScroll.clip.clipH = gamelua.screenHeight
	
	exitButton.x = exitButton.w * .56
	exitButton.y = h / 2 + rootPage.height 
	gamelua.ui.Frame.layout(self)
	
end

function MEShopRootPage:setEnterPageIndex(index)
	local scroll = self:getChild("shopScroll")
	local exitButton = self:getChild("exitButton")
	
	scroll:setEnterPageIndex(index)
	if(index == 1) then
		exitButton.returnValue = "ME_PURCHASE_PAGE_CLOSED"
		local buttonTrailer = self:getChild("buttonTrailer")
		buttonTrailer:setEnabled(true)
		self:getChild("buttonBuyEagle"):setEnabled(true)
		
	elseif(index == 2) then
		exitButton.returnValue = "ADS_REMOVE_PAGE_CLOSED"
		local buttonTrailer = self:getChild("buttonTrailer")
		self:getChild("buttonBuyEagle"):setEnabled(false)
		buttonTrailer:setEnabled(false)
	end
end

function MEShopRootPage:onEntry()
	gamelua.hideAd()
	local rootPage = self:getChild("rootPage")
	-- false as default. this is a quick fix on hurry.
	rootPage:getChild("buttonAdsOff"):setEnabled(false)
	rootPage:getChild("buttonBuyEagle"):setEnabled(false)
	rootPage:getChild("buttonTrailer"):setEnabled(false)

	local scroll = self:getChild("shopScroll")

	if(scroll.lockedAnchor == 1) then
		rootPage:getChild("buttonBuyEagle"):setEnabled(not gamelua.settings.mightyEagleEnabled)	
		rootPage:getChild("buttonTrailer"):setEnabled(true)
	end
	
	if(scroll.lockedAnchor == 2) then
		rootPage:getChild("buttonAdsOff"):setEnabled(not gamelua.settings.isPremium)	
	end

	gamelua.ui.Frame.onEntry(self)
end

function MEShopRootPage:draw(x,y)
	gamelua.ui.Frame.draw(self,x,y)
end

function getShopPage()
	return MEShopRootPage:new()
end

MEPage = gamelua.ui.Frame:new()

function MEPage:init()
	self.name = "MEPage"
	
	local eagleBox = gamelua.ui.BGBox:new()
	eagleBox.name = "eagleBox"
	eagleBox.components = {topLeft = "SCORE_TOP_LEFT", left = "SCORE_LEFT", bottomLeft = "SCORE_BOTTOM_LEFT", bottomMiddle = "SCORE_BOTTOM_MIDDLE",
				  bottomRight = "SCORE_BOTTOM_RIGHT", right = "SCORE_RIGHT", topRight = "SCORE_TOP_RIGHT", topMiddle = "SCORE_TOP_MIDDLE",
				  center = "SCORE_CENTER"}
	
	local eagleTitle = gamelua.ui.Image:new()
	eagleTitle.name = "eagleTitle"
	eagleTitle:setImage("UPSELL_EAGLE_LOGO")
	
	local eagleBG = gamelua.ui.Image:new()
	eagleBG:setImage("UPSELL_EAGLE_BG")
	eagleBG.name = "eagleBG"
	
	local buttonTrailer = gamelua.ui.ImageButton:new()
	buttonTrailer:setImage("BUTTON_UPSELL_TRAILER")
	buttonTrailer.name = "buttonTrailer"
	buttonTrailer.returnValue = "ME_TRAILER_CLICKED"
	
	local buttonBuyEagle = gamelua.ui.ImageButton:new()
	buttonBuyEagle:setImage("EAGLE_SHOPPING_CART_BUTTON", "SHOPPING_CART_UNUSABLE")		
	buttonBuyEagle.name = "buttonBuyEagle"
	buttonBuyEagle.returnValue = "ME_PURCHASE_CLICKED"
	
	
	local ti = gamelua.ui.Text:new()
	ti.hanchor = "LEFT"
	ti.vanchor = "TOP"
	ti.text = "TEXT_EAGLE_UPSELL"
	ti.name = "sellText"

	local ti2 = gamelua.ui.Text:new()
	ti2.hanchor = "LEFT"
	ti2.vanchor = "TOP"
	ti2.text = "TEXT_EAGLE_UPSELL2"
	ti2.name = "sellText2"

	
	self:addChild(eagleBG)		
	self:addChild(eagleBox)
	self:addChild(ti)
	self:addChild(ti2)
	self:addChild(eagleTitle)
	self:addChild(buttonTrailer)
	self:addChild(buttonBuyEagle)		
end

function MEPage:layout()	

	local w,h = _G.res.getSpriteBounds("POPUP_BOTTOM_MIDDLE")
	local eagleBox = self:getChild("eagleBox")
	local eagleBG = self:getChild("eagleBG")	
	local eagleTitle = self:getChild("eagleTitle")	
	local ti = self:getChild("sellText")
	local ti2 = self:getChild("sellText2")
	local buttonBuyEagle = self:getChild("buttonBuyEagle")
	local buttonTrailer = self:getChild("buttonTrailer")
	local exitButton = self:getChild("exitButton")
	
	eagleBox.width = _G.math.max(eagleTitle.w * 1.25, 175)
	eagleBox.height = m_pageH * 0.84
	eagleBox.x = m_pageW * 0.04
	eagleBox.y = m_pageH * 0.05
	buttonTrailer.y = m_pageH + h / 2
	buttonBuyEagle.y = m_pageH + h / 2
	
	buttonBuyEagle.x = m_pageW - buttonBuyEagle.w * .56
	buttonTrailer.x = buttonBuyEagle.x - buttonTrailer.w / 2 - buttonBuyEagle.w * .56
	
	eagleTitle.x = eagleBox.x + eagleBox.width / 2 - eagleTitle.w / 2
	eagleTitle.y = eagleBox.y + eagleTitle.h / 2

	eagleBG.x = m_pageW * 0.98
	eagleBG.y = m_pageH
	
	ti.x = eagleBox.x 		
	ti.y = eagleTitle.y + eagleTitle.h * 0.2
	ti.textBoxSize = eagleBox.width * 0.90
	ti:clip()
	
	ti2.x = eagleBox.x 		
	ti2.y = ti.y + ti.textBlockHeight / 2
	ti2.textBoxSize = eagleBox.width 
	ti2:clip()

	gamelua.ui.Frame.layout(self)
end


AdsShopPage = gamelua.ui.Frame:new()

function AdsShopPage:init()
	self.name = "AdsShopPage"
	
	local adsBGBox = gamelua.ui.BGBox:new()
	adsBGBox.name = "adsBGBox"
	adsBGBox.components = {topLeft = "SCORE_TOP_LEFT", left = "SCORE_LEFT", bottomLeft = "SCORE_BOTTOM_LEFT", bottomMiddle = "SCORE_BOTTOM_MIDDLE",
				  bottomRight = "SCORE_BOTTOM_RIGHT", right = "SCORE_RIGHT", topRight = "SCORE_TOP_RIGHT", topMiddle = "SCORE_TOP_MIDDLE",
				  center = "SCORE_CENTER"}
	
	local adsTitle = gamelua.ui.Image:new()
	adsTitle.name = "adsTitle"
	adsTitle:setImage("REMOVE_ADS_TEXT")
	
	local shopBGImage = gamelua.ui.Image:new()
	shopBGImage:setImage("GARBAGE_CAN_BIRD")
	shopBGImage.name = "shopBGImage"
	
	local buttonAdsOff = gamelua.ui.ImageButton:new()
	buttonAdsOff:setImage("EAGLE_SHOPPING_CART_BUTTON", "SHOPPING_CART_UNUSABLE")
	buttonAdsOff.name = "buttonAdsOff"
	buttonAdsOff.returnValue = "ADS_REMOVE_CLICKED"

	local ti = gamelua.ui.Text:new()
	ti.hanchor = "LEFT"
	ti.vanchor = "TOP"
	ti.text = "TEXT_REMOVE_ADS_UPSELL"
	ti.name = "adsText"
	
	self:addChild(shopBGImage)		
	self:addChild(adsBGBox)
	self:addChild(ti)
	self:addChild(adsTitle)
	self:addChild(buttonAdsOff)
	
end

function AdsShopPage:layout()	
	local w,h = _G.res.getSpriteBounds("POPUP_BOTTOM_MIDDLE")
	local adsBGBox = self:getChild("adsBGBox")
	local shopBGImage = self:getChild("shopBGImage")	
	local adsTitle = self:getChild("adsTitle")	
	local ti = self:getChild("adsText")
	local buttonAdsOff = self:getChild("buttonAdsOff")
	
	adsBGBox.width = _G.math.max(adsTitle.w * 1.5, 175)
	adsBGBox.height = m_pageH * 0.80
	adsBGBox.x = m_pageW * 0.05
	adsBGBox.y = m_pageH * 0.05
	
	buttonAdsOff.y = m_pageH + h / 2
	buttonAdsOff.x = m_pageW - buttonAdsOff.w * .56
	
	adsTitle.x = adsBGBox.x + adsBGBox.width / 2 - adsTitle.w / 2
	adsTitle.y = adsBGBox.y + adsTitle.h / 2
	
	ti.x = adsBGBox.x 		
	ti.y = adsTitle.y + adsTitle.h * 0.2
	
	shopBGImage.x = m_pageW * 0.98
	shopBGImage.y = m_pageH
	ti.textBoxSize = adsBGBox.width * 0.90
	ti:clip()
	gamelua.ui.Frame.layout(self)
end


filename="shop.lua"
