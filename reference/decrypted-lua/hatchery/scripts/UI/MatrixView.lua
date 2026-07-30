MatrixView = ui.Frame:new()
Frame = ui.Frame

function MatrixView:init()
	Frame.init(self)	
	self.currentVisiblePopUp = nil
	self.fontScaleSmall = 0.5
	self.birdAmount = 32
	self.birdsPerRow = 5
	self.hudItems = {}
	
	--<BG items>
	local bankBg = ui.Image:new()
	bankBg.name = "bankBg"
	bankBg:setImage("H_BANK_BG")
	self:addChild(bankBg)
	_G.table.insert(self.hudItems, bankBg)
	
	local rankBg = ui.Image:new()
	rankBg.name = "rankBg"
	rankBg:setImage("H_MATRIX_BG_RANK")
	self:addChild(rankBg)
	_G.table.insert(self.hudItems, rankBg)
	
	local collectedBg = ui.Image:new()
	collectedBg.name = "collectedBg"
	collectedBg:setImage("H_MATRIX_BG_COLLECTED_BIRDS")
	self:addChild(collectedBg)
	_G.table.insert(self.hudItems, collectedBg)
	
	local selectedBg = ui.Image:new()
	selectedBg.name = "selectedBg"
	selectedBg:setImage("H_MATRIX_BG_SELECTED_BIRDS")
	self:addChild(selectedBg)
	_G.table.insert(self.hudItems, selectedBg)
	--</BG items>
	
	self.selectedBirds = 0
	self.selectedBirdsMax = 5
	
	
	self.birdItems = {}
	--<Birds>
	for i = 1, self.birdAmount do
		local bird = ui.ScallableButton:new()
		bird.name = "bird" .. i
		bird.id = i
		bird:setImage("H_MATRIX_SILHOUETTE_RED")
		self:addChild(bird)
		_G.table.insert(self.birdItems, bird)
		bird.activateOnRelease = true
		
		local birdLabelText = ui.Text:new()
		birdLabelText.name = "birdLabelText" .. i
		birdLabelText.text = "" .. i
		birdLabelText.font = "FONT_HATCHERY_NUMBERS"
		birdLabelText.attach = "fixed"
		birdLabelText.hanchor = "HCENTER"
		birdLabelText.vanchor = "VCENTER"
		self:addChild(birdLabelText)
		_G.table.insert(self.birdItems, birdLabelText)
		
		local birdNewIcon = ui.ScallableButton:new()
		birdNewIcon.name = "birdNewIcon" .. i
		birdNewIcon:setImage("H_MATRIX_INDICATOR_NEW")
		self:addChild(birdNewIcon)
		_G.table.insert(self.birdItems, birdNewIcon)
		birdNewIcon.activateOnRelease = true
		
		local birdSelectedIcon = ui.ScallableButton:new()
		birdSelectedIcon.name = "birdSelectedIcon" .. i
		birdSelectedIcon:setImage("H_MATRIX_INDICATOR_SELECT_SMALL")
		self:addChild(birdSelectedIcon)
		_G.table.insert(self.birdItems, birdSelectedIcon)
		birdSelectedIcon.activateOnRelease = true
	end
	--</Birds>
	
	--<HUD items>
	local starLabel = ui.Text:new()
	starLabel.name = "starLabel"
	starLabel.hanchor = "LEFT"
	starLabel.vanchor = "VCENTER"
	starLabel.font = "FONT_HATCHERY"
	starLabel.scaleX = 0.6--self.fontScaleSmall
	starLabel.scaleY = 0.6--self.fontScaleSmall
	self:addChild(starLabel)
	_G.table.insert(self.hudItems, starLabel)
	
	self.protoRankTexts = {
		"Bird Collector",
		"Avian Gatherer",
		"Professional Bird Accumulator"
	}
	
	local playerRankText = ui.Text:new()
	playerRankText.name = "playerRankText"
	playerRankText.font = "FONT_HATCHERY"
	playerRankText.text = "Level " .. hatchery:getPlayerRank()
	self:addChild(playerRankText)
	_G.table.insert(self.hudItems, playerRankText)
	
	local playerRankDescription = ui.Text:new()
	playerRankDescription.name = "playerRankDescription"
	playerRankDescription.font = "FONT_HATCHERY"
	playerRankDescription.text = self.protoRankTexts[hatchery:getPlayerRank()]
	self:addChild(playerRankDescription)
	_G.table.insert(self.hudItems, playerRankDescription)
	
	local collectedBirdsIcon = ui.Image:new()
	collectedBirdsIcon.name = "collectedBirdsIcon"
	collectedBirdsIcon:setImage("H_MATRIX_SILHOUETTE_RED")
	collectedBirdsIcon.scaleX = 0.6
	collectedBirdsIcon.scaleY = 0.6
	self:addChild(collectedBirdsIcon)
	_G.table.insert(self.hudItems, collectedBirdsIcon)
	
	local collectedText = ui.Text:new()
	collectedText.name = "collectedText"
	collectedText.font = "FONT_HATCHERY"
	collectedText.attach = "fixed"
	collectedText.hanchor = "HCENTER"
	collectedText.vanchor = "VCENTER"
	collectedText.scaleX = 0.5
	collectedText.scaleY = 0.5
	collectedText.text = "/" .. self.birdAmount
	self:addChild(collectedText)
	_G.table.insert(self.hudItems, collectedText)
	
	local selectedBirdsIcon = ui.Image:new()
	selectedBirdsIcon.name = "selectedBirdsIcon"
	selectedBirdsIcon:setImage("H_MATRIX_INDICATOR_SELECT_MEDIUM")
	self:addChild(selectedBirdsIcon)
	_G.table.insert(self.hudItems, selectedBirdsIcon)
	
	local selectedBirdsText = ui.Text:new()
	selectedBirdsText.name = "selectedBirdsText"
	selectedBirdsText.font = "FONT_HATCHERY"
	selectedBirdsText.attach = "fixed"
	selectedBirdsText.hanchor = "HCENTER"
	selectedBirdsText.vanchor = "VCENTER"
	selectedBirdsText.scaleX = 0.5
	selectedBirdsText.scaleY = 0.5
	selectedBirdsText.text = "" .. self.selectedBirds .. "/" .. self.selectedBirdsMax 
	self:addChild(selectedBirdsText)
	_G.table.insert(self.hudItems, selectedBirdsText)
	
	
	local backButton = ui.ScallableButton:new()
	backButton.name = "backButton"
	backButton:setImage("H_BTN_HOME")
	backButton.returnValue = hatcheryEvents.EID_HATCHERY_MATRIX_CANCEL	
	self:addChild(backButton)
	backButton.sound = getHatcherySound("ok")
	_G.table.insert(self.hudItems, backButton)
	backButton.activateOnRelease = true
	--</Hud items>
	
	local _, sh = _G.res.getSpriteBounds("H_MATRIX_BG_TOP")
	local rows = _G.math.ceil(self.birdAmount / self.birdsPerRow)
	local rowWidth, rowHeight = _G.res.getSpriteBounds("H_MATRIX_BG_BLUE_LIGHT")
	
	self.scrollBarTopWidth, self.scrollBarTopHeight = _G.res.getSpriteBounds("H_SCROLL_BAR_TOP")
	self.scrollBarMiddleWidth, self.scrollBarMiddleHeight = _G.res.getSpriteBounds("H_SCROLL_BAR_MIDDLE")
	self.scrollBarHandleWidth, self.scrollBarHandleHeight = _G.res.getSpriteBounds("H_SCROLL_BAR_HANDLE")
	self.rowHeight = rowHeight
	self.rowWidth = rowWidth
	self.totalMatrixHeight = rowHeight * rows -	(gamelua.screenHeight - sh)
	self.topBarHeight = sh
	self.scrollOffset = 0
	self.currentFrame = nil
	self.firstVisibleRow = 1
	
	local statCard = StatCardDialog:new()
	statCard.name = "statCard"
	statCard.visible = false
	statCard:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_STATCARD)
	self:addChild(statCard)
	_G.table.insert(self.hudItems, statCard)
	
	
	--events
	hatcheryEventManager:addEventListener(hatcheryEvents.EID_HATCHERY_SELECT_BIRD_STATCARD,self)
	hatcheryEventManager:addEventListener(hatcheryEvents.EID_HATCHERY_DESELECT_BIRD_STATCARD,self)
	
end

function MatrixView:eventTriggered(event)
	if hatcheryEvents.EID_HATCHERY_SELECT_BIRD_STATCARD == event.id then
		self:updateBirdSelectText()
		self:updateSelectedBirdMarkers(event.bird, true)
	elseif hatcheryEvents.EID_HATCHERY_DESELECT_BIRD_STATCARD == event.id then
		self:updateBirdSelectText()
		self:updateSelectedBirdMarkers(event.bird, false)
	end
end

function MatrixView:updateBirdSelectText()
	 self:getChild("selectedBirdsText").text = "" .. hatchery:getNumSelectedBirds() .. "/" .. hatchery:getMaxNumSelectedBirds()
end

function MatrixView:updateSelectedBirdMarkers(bird, val)
	local birdMarker  = self:getChild("bird" .. bird:getId())
	birdMarker.selected = val
	self:prepareBirds()
end



function MatrixView:layout()
	
	
	
	--<BG items>
	local bankBg = self:getChild("bankBg")
	bankBg.x, bankBg.y = bankBg.w * 0.6, bankBg.h * 0.7
	
	local rankBg = self:getChild("rankBg")
	rankBg.x, rankBg.y = gamelua.screenWidth * 0.5, rankBg.h * 0.6
	
	local collectedBg = self:getChild("collectedBg")
	collectedBg.x, collectedBg.y = rankBg.x - collectedBg.w * 0.43, rankBg.y + collectedBg.h * 1.3
	
	local selectedBg = self:getChild("selectedBg")
	selectedBg.x, selectedBg.y = rankBg.x + selectedBg.w * 0.8 , rankBg.y + selectedBg.h * 1.3
	--</BG items>
	
	local _, sh = _G.res.getSpriteBounds("H_MATRIX_BG_TOP")
	local rows = _G.math.ceil(self.birdAmount / self.birdsPerRow)
	local _, rowHeight = _G.res.getSpriteBounds("H_MATRIX_BG_BLUE_LIGHT")
	local columnWidth, _ = _G.res.getSpriteBounds("H_MATRIX_SILHOUETTE_BIGBROTHER") * 1.5
	local badgeOffset, _ = _G.res.getSpriteBounds("H_MATRIX_SILHOUETTE_RED") * 0.7
	local birdsPerRow = 5
	
	local startY = sh + rowHeight * 0.5
	local startX = (gamelua.screenWidth - (columnWidth * (birdsPerRow - 1))) * 0.5
	
	--<Birds>
	for i = 1, self.birdAmount do
		local bird = self:getChild("bird" .. i)
		bird.x, bird.y = startX + ((i - 1) % birdsPerRow) * columnWidth, startY + _G.math.floor(((i - 1) / birdsPerRow)) * rowHeight
		bird.originalY = bird.y
		bird.row = _G.math.floor(((i - 1) / birdsPerRow))
		
		local birdLabelText = self:getChild("birdLabelText" .. i)
		birdLabelText.x, birdLabelText.y = bird.x, bird.y
		birdLabelText.originalY = bird.y
		birdLabelText.row = _G.math.floor(((i - 1) / birdsPerRow))
		
		local birdNewIcon = self:getChild("birdNewIcon" .. i)
		birdNewIcon.x, birdNewIcon.y = bird.x + badgeOffset * 0.4, bird.y - badgeOffset * 0.5
		birdNewIcon.originalY = birdNewIcon.y
		birdNewIcon.row = _G.math.floor(((i - 1) / birdsPerRow))
		
		local birdSelectedIcon = self:getChild("birdSelectedIcon" .. i)
		birdSelectedIcon.x, birdSelectedIcon.y = bird.x - badgeOffset * 0.4, bird.y + badgeOffset * 0.5
		birdSelectedIcon.originalY = birdSelectedIcon.y
		birdSelectedIcon.row = _G.math.floor(((i - 1) / birdsPerRow))
	end
	--</Birds>
	
	--<HUD items>
	local starLabel = self:getChild("starLabel")
	starLabel.text = "" .. hatchery:getStars()
	starLabel.x, starLabel.y = bankBg.x - 20 * starLabel.scaleX, bankBg.y

	local playerRankText = self:getChild("playerRankText")
	playerRankText.text = "Level " .. hatchery:getPlayerRank()
	playerRankText.scaleX, playerRankText.scaleY = 0.4, 0.4
	playerRankText.x, playerRankText.y = rankBg.x, rankBg.y - playerRankText:getHeight() * 0.65
	
	local playerRankDescription = self:getChild("playerRankDescription")
	playerRankDescription.x, playerRankDescription.y = rankBg.x, rankBg.y + playerRankDescription:getHeight() * 0.5
	playerRankDescription.scaleX, playerRankDescription.scaleY = 0.5, 0.5
	
	local collectedBirdsIcon = self:getChild("collectedBirdsIcon")
	collectedBirdsIcon.x, collectedBirdsIcon.y = collectedBg.x - collectedBirdsIcon.w * collectedBirdsIcon.scaleX * 0.8, collectedBg.y 
	
	local collectedText = self:getChild("collectedText")
	collectedText.text = hatchery:getCollectedBirdAmount() .. "/" .. self.birdAmount
	collectedText.x, collectedText.y = collectedBg.x + collectedBirdsIcon.w * collectedBirdsIcon.scaleX * 0.5, collectedBg.y
	
	local selectedBirdsIcon = self:getChild("selectedBirdsIcon")
	selectedBirdsIcon.x, selectedBirdsIcon.y = selectedBg.x - selectedBirdsIcon.w * 0.8, selectedBg.y
	
	local selectedBirdsText = self:getChild("selectedBirdsText")
	selectedBirdsText.x, selectedBirdsText.y = selectedBg.x + selectedBirdsIcon.w * 0.5, selectedBg.y
	

	local backButton = self:getChild("backButton")
	local backOffsetX = 20
	local backOffsetY = 15
	local backPivotX, backPivotY = _G.res.getSpritePivot("", backButton.image)
	backButton.x = backOffsetX + backPivotX
	backButton.y = gamelua.screenHeight - (backButton.w - backPivotY) - backOffsetY 
	
	local statCard = self:getChild("statCard")
	statCard.x = gamelua.screenWidth * 0.5
	statCard.y = gamelua.screenHeight * 0.5
	
		
	Frame.layout(self)	
	
end

function MatrixView:prepareBirds()

	for i = 1, self.birdAmount do
		local bird = self:getChild("bird" .. i)
		local birdNewIcon = self:getChild("birdNewIcon" .. i)
		local birdSelectedIcon = self:getChild("birdSelectedIcon" .. i)
		local birdLabelText = self:getChild("birdLabelText" .. i)
		if hatchery:hasBirdWithId(i) then
			birdLabelText.visible = false
			if bird.collected ~= true then
				birdNewIcon.visible = true
			else
				birdNewIcon.visible = false
			end
			
			if bird.selected == true then
				birdSelectedIcon.visible = true
			else
				birdSelectedIcon.visible = false
			end
			
			bird.collected = true
			bird:setImage(hatchery:getBirdWithId(i).sprite)
			local sw, sh = _G.res.getSpriteBounds("H_MATRIX_SILHOUETTE_RED")
			if bird.w > sw or bird.h > sh then
				local scale = _G.math.min(sw / bird.w, sh / bird.h)		
				bird.scaleX, bird.scaleY = scale, scale
			end
			
			bird.sound = "h_no_1"
			bird.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_STATCARD
		else
			birdLabelText.visible = true
			bird.collected = false
			bird:setImage("H_MATRIX_SILHOUETTE_RED")
			bird.scaleX, bird.scaleY = nil, nil
			bird.sound = nil
			bird.returnValue = nil
			birdNewIcon.visible = false
			birdSelectedIcon.visible = false
		end
		
	end
	
end


function MatrixView:setHatchery(hatchery)
	self.hatchery = hatchery

end


function MatrixView:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	local itemSelectionFrame = self:getChild("itemSelectionFrame")
	
	local itemNameText = self:getChild("itemNameText")
	
	if result == hatcheryEvents.EID_HATCHERY_MATRIX_CANCEL then
		hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "NEST_VIEW", from = "MATRIX_VIEW"})
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_STATCARD then
		self:closeCurrentPopUp()
		local statCard = self:getChild("statCard")
		statCard:prepareForBird(self.hatchery:getBirdWithId(meta.id))
		self:openPopUp(statCard)
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_STATCARD then
		self:closeCurrentPopUp()
	end		
	
	return result, meta
end


function MatrixView:openPopUp(popUpFrame)
	self.currentVisiblePopUp = popUpFrame
	popUpFrame.visible = true
	self.popUpAlpha = 0
	
	for k, v in _G.pairs(self.children) do
		if v ~= popUpFrame then
			v.active = false
		end
	end
	
end

function MatrixView:closeCurrentPopUp()
	if self.currentVisiblePopUp ~= nil then
		self.currentVisiblePopUp.visible = false
		self.currentVisiblePopUp = nil
		self.popUpAlpha = 0
	end
	
	for k, v in _G.pairs(self.children) do
		v.active = true
	end
end

function MatrixView:update(dt, time) 
	ui.Frame.update(self, dt, time) 
	
	if self.currentVisiblePopUp then
		self.popUpAlpha = self.popUpAlpha and _G.math.min(self.popUpAlpha + dt * 5, 0.3)
	end
	
	if self.lastCursor == nil then
		self.lastCursor = {x = gamelua.cursor.x, y = gamelua.cursor.y}
	end
	
	
	--<Scrolling stuff>
	if self.currentVisiblePopUp == nil then
		if gamelua.keyHold["UP"] then
			self.scrollOffset = _G.math.min(0, self.scrollOffset + 10)
			for k, v in _G.pairs(self.birdItems) do
				v.y = v.originalY + self.scrollOffset
			end
		elseif gamelua.keyHold["DOWN"] then
			self.scrollOffset = _G.math.max(self.scrollOffset - 10, -self.totalMatrixHeight)
			for k, v in _G.pairs(self.birdItems) do
				v.y = v.originalY + self.scrollOffset
			end
		end
		
		if gamelua.keyPressed["LBUTTON"] and gamelua.cursor.y > self.topBarHeight then
			self.dragStart = { x = gamelua.cursor.x, y = gamelua.cursor.y }
		elseif gamelua.keyReleased["LBUTTON"] and self.dragStart ~= nil then
			self.dragStart = nil
		elseif gamelua.keyHold["LBUTTON"] and self.dragStart ~= nil then
			self.dragSpeed = gamelua.cursor.y - self.dragStart.y
			self.dragStart = { x = gamelua.cursor.x, y = gamelua.cursor.y }
		end
		self.dragSpeed = self.dragSpeed and self.dragSpeed * _G.math.pow(0.002, dt) or 0
		self.scrollOffset = _G.math.max(-self.totalMatrixHeight, _G.math.min(0, self.scrollOffset + self.dragSpeed * 1))
		if _G.math.abs(self.dragSpeed) < 0.1 then
			self.dragSpeed = 0
		end

		for k, v in _G.pairs(self.birdItems) do
			v.y = v.originalY + self.scrollOffset
		end
	end
	
	self.firstVisibleRow = _G.math.max(1, _G.math.floor(-self.scrollOffset / self.rowHeight))
	
	--</Scrolling stuff>
			
	
end


function MatrixView:onEntry()	

	self:prepareBirds()
	self:layout()
	ui.Frame.onEntry(self)
end

function MatrixView:onExit()	
	
	ui.Frame.onExit(self)
end



function MatrixView:drawBird(bird)
	local itms = {}
	for i = 2, #self.hatchery:getBirdWithId(bird.id).sprites do
		_G.table.insert(itms, self.hatchery:getBirdWithId(bird.id).sprites[i])
	end

	gamelua.drawCompoObjectLua(bird.x, bird.y, bird.angle, bird.scaleY, itms)
end


function MatrixView:draw(x, y)
	
	self:drawBackground()
	for k, v in _G.pairs(self.birdItems) do
		if v.visible ~= false and v.row >= self.firstVisibleRow - 1 and v.row <= self.firstVisibleRow + 5 then
			v:draw()
			if v.collected then
				_G.res.setClipRect(0, _G.math.max(self.topBarHeight, self.topBarHeight + v.row * self.rowHeight + self.scrollOffset), gamelua.screenWidth, _G.math.max(self.topBarHeight + self.rowHeight, self.topBarHeight  + (v.row + 1) * self.rowHeight + self.scrollOffset))
				self:drawBird(v)
				_G.res.setClipRect(0, self.topBarHeight, gamelua.screenWidth, gamelua.screenHeight)
			end
		end
	end

	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	
	for k, v in _G.pairs(self.hudItems) do
		if v.visible ~= false then
			if self.currentVisiblePopUp and  v == self.currentVisiblePopUp then
				gamelua.drawRect( 0, 0, 0, self.popUpAlpha, 0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
			end
			v:draw(x,y)
		end
	end
	
	self:drawForeGround()
	-- ui.Frame.draw(self, x, y)		

end

	
function MatrixView:drawForeGround()
	gamelua.setRenderState(0, 0, 1, 1, 0)
	local xCoord = gamelua.screenWidth - self.scrollBarTopWidth * 2
	local yCoord = self.topBarHeight + self.scrollBarTopHeight * 2
	local yScale = (gamelua.screenHeight - self.topBarHeight - self.scrollBarTopHeight * 4)  / self.scrollBarMiddleHeight
	_G.res.drawSprite("", "H_SCROLL_BAR_TOP", xCoord, yCoord)
	gamelua.setRenderState(0, 0, 1, yScale)
	_G.res.drawSprite("", "H_SCROLL_BAR_MIDDLE", xCoord, yCoord / yScale)
	gamelua.setRenderState(0, 0, 1, 1)
	_G.res.drawSprite("", "H_SCROLL_BOTTOM", xCoord, gamelua.screenHeight - self.scrollBarTopHeight * 2)
	_G.res.drawSprite("", "H_SCROLL_BAR_HANDLE", xCoord, yCoord + self.scrollBarHandleHeight * 0.5 - (self.scrollOffset / self.totalMatrixHeight) * (yScale * self.scrollBarMiddleHeight - self.scrollBarHandleHeight) )
end

function MatrixView:drawBackground()
	gamelua.setRenderState(0, 0, 1, 1, 0)
	_G.res.drawSprite("", "H_MATRIX_BG_TOP", 0, 0, "LEFT", "TOP", gamelua.screenWidth, self.topBarHeight )
	_G.res.setClipRect(0, self.topBarHeight, gamelua.screenWidth, gamelua.screenHeight)
	local rows = _G.math.ceil(self.birdAmount / self.birdsPerRow)
	local startY = self.topBarHeight
	
	for i = self.firstVisibleRow, self.firstVisibleRow + 6 do
		gamelua.setRenderState(0, 0, gamelua.screenWidth / self.rowWidth, 1, 0)
		if i % 2 == 0 then
			_G.res.drawSprite("", "H_MATRIX_BG_BLUE_DARK", 0, startY + self.rowHeight * (i - 1) + self.scrollOffset)
		else
			_G.res.drawSprite("", "H_MATRIX_BG_BLUE_LIGHT", 0, startY + self.rowHeight * (i - 1) + self.scrollOffset)
		end
	end
end



filename="MatrixView.lua"
