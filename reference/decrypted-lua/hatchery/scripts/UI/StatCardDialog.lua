StatCardDialog = ui.Frame:new()
Frame = ui.Frame

function StatCardDialog:init()
	Frame.init(self)	
	
	local background = ui.Image:new()
	background.name = "background"
	background.attach = "fixed"
	background:setImage("H_DIALOG_BG_BIG_TEMP")
	self:addChild(background)
	
	local changeNameButton = ui.ScallableButton:new()
	changeNameButton.name = "changeNameButton"
	changeNameButton:setImage("H_BTN_STAT_CARD_NAME")
	self:addChild(changeNameButton)
	changeNameButton.activateOnRelease = true
	
	local sendToFacebookButton = ui.ScallableButton:new()
	sendToFacebookButton.name = "sendToFacebookButton"
	sendToFacebookButton:setImage("H_BTN_STAT_CARD_FACEBOOK")
	self:addChild(sendToFacebookButton)
	sendToFacebookButton.activateOnRelease = true
	
	local setAvatarButton = ui.ScallableButton:new()
	setAvatarButton.name = "setAvatarButton"
	setAvatarButton:setImage("H_BTN_STAT_CARD_AVATAR")
	self:addChild(setAvatarButton)
	setAvatarButton.activateOnRelease = true
	
	local selectButton = ui.ScallableButton:new()
	selectButton.name = "selectButton"
	selectButton:setImage("H_BTN_STAT_CARD_SELECT")
	selectButton.returnValue = hatcheryEvents.EID_HATCHERY_SELECT_BIRD_STATCARD
	self:addChild(selectButton)
	selectButton.activateOnRelease = true
	
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_OK")
	cancelButton.returnValue = "CANCEL"
	cancelButton.sound = "h_no_1"
	self:addChild(cancelButton)
	cancelButton.activateOnRelease = true
	
	local bird = ui.Image:new()
	bird.name = "bird"
	bird:setImage("")
	bird.sound = "h_bird_idle_1"
	self:addChild(bird)
	
	local birdName = ui.Text:new()
	birdName.name = "birdName"
	birdName.font = "FONT_HATCHERY"
	birdName.text = "Jorma"
	birdName.attach = "fixed"
	birdName.hanchor = "HCENTER"
	birdName.vanchor = "VCENTER"
	birdName.scaleX = 0.7
	birdName.scaleY = 0.7
	self:addChild(birdName)
	
end


function StatCardDialog:layout()
	Frame.layout(self)
	
	local background = self:getChild("background")	
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.y = (background.h * 0.45)
	
	local changeNameButton = self:getChild("changeNameButton")
	changeNameButton.x, changeNameButton.y = background.w * 0.15, -background.h * 0.18
	
	local sendToFacebookButton = self:getChild("sendToFacebookButton")
	sendToFacebookButton.x, sendToFacebookButton.y = changeNameButton.x, 0
	
	local setAvatarButton = self:getChild("setAvatarButton")
	setAvatarButton.x, setAvatarButton.y = changeNameButton.x, background.h * 0.18
	
	local bird = self:getChild("bird")
	 
	local maxHeight = 225
	local maxWidth = 175
	

	
	local sw, sh = _G.res.getSpriteBounds(bird.image)
	local px, py = _G.res.getSpritePivot(bird.image)
	local biggestW, biggestH = sw, sh
	if self.currentBird ~= nil then
		for k, v in _G.pairs(self.currentBird.sprites) do
			local sw, sh = _G.res.getSpriteBounds(v.sprite)
			-- local px, py = _G.res.getSpritePivot(v.sprite)
			local scale = v.scale
			if sw * scale > biggestW then
				biggestW = sw * scale
			end
			if sh * scale > biggestH then
				biggestH = sh * scale
			end
		end
	end
	if biggestW > maxWidth or biggestH > maxHeight then
		local scale = _G.math.min(maxWidth / biggestW, maxHeight / biggestH)		
		bird.scaleX, bird.scaleY = scale, scale
	end
	bird.x, bird.y = -background.w * 0.28, 0
	
	local birdName = self:getChild("birdName")
	birdName.x, birdName.y = bird.x, -background.h * 0.35
	
	local selectButton = self:getChild("selectButton")
	selectButton.x, selectButton.y = bird.x, background.h * 0.27

end

function StatCardDialog:prepareForBird(b)
	local bird = self:getChild("bird")
	self.currentBird = b
	bird:setImage(b.sprite)
	self:layout()
	self:setupBirdSelectionState()
end

function StatCardDialog:setEvents(eventCancel)
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
end

function StatCardDialog:draw(x, y)
	Frame.draw(self)
	
	if self.currentBird then
		local bird = self:getChild("bird")
		local itms = {}
		for i = 2, #self.currentBird.sprites do
			_G.table.insert(itms, self.currentBird.sprites[i])
		end

		gamelua.drawCompoObjectLua(self.x + bird.x, self.y + bird.y, bird.angle, bird.scaleY, itms)
	end	
	
end


function StatCardDialog:selectCurrentBird()
		
		if hatchery:getNumSelectedBirds() >= hatchery:getMaxNumSelectedBirds() then
			return
		end
		hatchery:addBirdToSelectedBirds(self.currentBird)
		self.currentBird.selected = true
		hatcheryEventManager:notify({id = hatcheryEvents.EID_HATCHERY_SELECT_BIRD_STATCARD, bird = self.currentBird })	
		self:setupBirdSelectionState()
end

function StatCardDialog:deselectCurrentBird()
	hatchery:removeBirdFromSelectedBirds(self.currentBird)
	self.currentBird.selected = nil	
	hatcheryEventManager:notify({id = hatcheryEvents.EID_HATCHERY_DESELECT_BIRD_STATCARD, bird = self.currentBird})	
	self:setupBirdSelectionState()
end


function StatCardDialog:setupBirdSelectionState()
	if not self.currentBird then
		return
	end
	local selectButton = self:getChild("selectButton")
	if self.currentBird.selected == true then
		selectButton.returnValue = hatcheryEvents.EID_HATCHERY_DESELECT_BIRD_STATCARD
		selectButton:setImage("H_BTN_STAT_CARD_DESELECT")
	else
		selectButton.returnValue = hatcheryEvents.EID_HATCHERY_SELECT_BIRD_STATCARD
		selectButton:setImage("H_BTN_STAT_CARD_SELECT")
	end
	
	
end


function StatCardDialog:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == hatcheryEvents.EID_HATCHERY_SELECT_BIRD_STATCARD then
		self:selectCurrentBird()
	elseif result == hatcheryEvents.EID_HATCHERY_DESELECT_BIRD_STATCARD then
		self:deselectCurrentBird()
	end
	
	return result, meta
end


filename="StatCardDialog.lua"
