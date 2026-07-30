BirdMatrixDialog = ui.Frame:new()
Frame = ui.Frame

function BirdMatrixDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_BIG_TEMP")
	self:addChild(background)
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_OK")
	cancelButton.returnValue = "CANCEL"
	cancelButton.sound = getHatcherySound("ok")
	self:addChild(cancelButton)
	cancelButton.activateOnRelease = true
	
	local statusBar = ui.Image:new()
	statusBar.name = "statusBar"
	statusBar.attach = "fixed"
	statusBar:setImage("H_PROGRESS_BAR_BG")
	self:addChild(statusBar)
	
	local collectedText = ui.Text:new()
	collectedText.name = "collectedText"
	collectedText.font = "FONT_HATCHERY"
	collectedText.attach = "fixed"
	collectedText.hanchor = "HCENTER"
	collectedText.vanchor = "VCENTER"
	collectedText.scaleX = 0.5
	collectedText.scaleY = 0.5
	collectedText.text = ""
	self:addChild(collectedText)
	
	
	for i = 1, 21 do
		local bird = ui.ScallableButton:new()
		bird.name = "bird" .. i
		bird:setImage("H_MATRIX_SILHOUETTE_RED")
		bird.returnValue = "CANCEL"
		bird.collected = false
		self:addChild(bird)
		bird.activateOnRelease = true
		
		local birdText = ui.Text:new()
		birdText.name = "birdText" .. i
		birdText.font = "FONT_HATCHERY"
		birdText.scaleX = 0.4
		birdText.scaleY = 0.4
		birdText.attach = "fixed"
		birdText.hanchor = "HCENTER"
		birdText.vanchor = "TOP"
		birdText.text = "" .. i
		self:addChild(birdText)	
	end
	
	self.lastClickedButton = nil
end

function BirdMatrixDialog:draw()
	ui.Frame.draw(self)
	-- Debug stuff
	-- local w, h = _G.res.getSpriteBounds("BIRD_RED_TEMP")
	-- local px, py = _G.res.getSpritePivot("BIRD_RED_TEMP")
	
	-- for i = 1, 21 do
		-- local birdCard = self:getChild("bird" .. i)
		-- if birdCard.collected then
			-- gamelua.drawRect(1, 1, 1, 0.5, birdCard.x + self.x - px * birdCard.scaleX, self.y + birdCard.y - py * birdCard.scaleY, self.x + birdCard.x + (w - px) * birdCard.scaleX, self.y + birdCard.y + (h - py) * birdCard.scaleY, false)
		-- end	
	-- end
end	

function BirdMatrixDialog:layout()
	Frame.layout(self)	
	
	local background = self:getChild("background")	
	local sw, sh = _G.res.getSpriteBounds(background.image)
	
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.y = (background.h * 0.45)
	
	local statusBar = self:getChild("statusBar")
	statusBar.x, statusBar.y = 0, -sh * 0.5
	
	local collectedText = self:getChild("collectedText")
	collectedText.text = hatchery:getCollectedBirdAmount() .. " / 21 Collected"
	collectedText.x, collectedText.y = 0, statusBar.y + 5
	
	-- ugly positioning code for proto purposes
	
	local startX, startY = -sw * 0.48, -sh * 0.27
	
	local row = 1
	local column = 1
	for i = 1, 21 do
		local bird = self:getChild("bird" .. i)
		local sw, sh = _G.res.getSpriteBounds("H_MATRIX_SILHOUETTE_RED")
		bird.x, bird.y = startX + column * sw * 1.1, startY + (row - 1) * sh * 1.5 
		
		local birdText = self:getChild("birdText" .. i)
		birdText.x, birdText.y = bird.x, bird.y + sh * 0.55
		
		if bird.collected then
			bird.y = startY + (row - 1) * sh * 1.5 + sh * 0.45
		end
		
		column = column + 1
		if i % 7 == 0 then
			row = row + 1
			column = 1
		end
	end
	
end

function BirdMatrixDialog:prepareBirds()

	for i = 1, 21 do
		local birdCard = self:getChild("bird" .. i)
		if hatchery:hasBirdWithId(i) then
			birdCard.collected = true
			birdCard:setImage(hatchery:getBirdWithId(i).sprite)
			birdCard.scaleX, birdCard.scaleY = 0.25, 0.25
			birdCard.sound = "h_no_1"
			birdCard.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_STATCARD
		else
			birdCard.collected = false
			birdCard:setImage("H_MATRIX_SILHOUETTE_RED")
			birdCard.scaleX, birdCard.scaleY = nil, nil
			birdCard.sound = nil
			birdCard.returnValue = nil
		end
	end
	self:layout()
end

function BirdMatrixDialog:setEvents(eventCancel, openStats)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
end

function BirdMatrixDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)	
	
	if result == hatcheryEvents.EID_HATCHERY_OPEN_STATCARD then		
		self.lastClickedButton = meta
	end	
	
	return result, meta
end


function BirdMatrixDialog:getLastClickedBird()
	if self.lastClickedButton then
		return hatchery:getBirdWithId(_G.tonumber(_G.string.sub(self.lastClickedButton.name, 5)))
	end
	return false
end

filename="BirdMatrixDialog.lua"
