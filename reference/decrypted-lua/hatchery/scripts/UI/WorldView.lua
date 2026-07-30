WorldView = ui.Frame:new()
Frame = ui.Frame

function WorldView:init()
	Frame.init(self)	

	--when we draw the nestview to menus, we don't want it to interact with io
	self.interactive = true
	
	self.fontScaleSmall = 0.5								
	
	
	self.worldSelectionPanel = WorldSelectionPanel:new()
	self:addChild(self.worldSelectionPanel)
	

	self.dynamicObjects = {}
	self.dynamicDecorations = {}
	
	
	self.birdSelectionPanel = BirdSelectionPanel:new()
	self:addChild(self.birdSelectionPanel)
	self.birdSelectionPanel.visible = false

	
	local backButton = ui.ScallableButton:new()
	backButton.name = "backButton"
	backButton:setImage("H_BTN_SHUT_DOWN")
	backButton.returnValue = hatcheryEvents.EID_HATCHERY_BACK_BUTTON	
	self:addChild(backButton)
	backButton.sound = getHatcherySound("ok")
	backButton.activateOnRelease = true
	backButton:setupDefaultAnimationValues()		
	
	--POP UPS
	
	local genericConfirm = ConfirmationDialog:new()
	genericConfirm.name = "genericConfirm"
	genericConfirm:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", "H_BTN_NO", "You don't have enough stars, would you like to get some more?", "FONT_HATCHERY")
	genericConfirm.visible = false
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_BUY_MORE_STARS_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_BUY_MORE_STARS_CONFIRMATION_NO)
	self:addChild(genericConfirm)
	local yesButton = genericConfirm:getChild("yesButton")
	yesButton.sound = getHatcherySound("ok")
	local noButton = genericConfirm:getChild("noButton")
	noButton.sound = getHatcherySound("cancel")	

	local buyStars = BuyStarsDialog:new()
	buyStars.name = "buyStars"
	buyStars.visible = false
	buyStars:setEvents(hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY)
	self:addChild(buyStars)
	local cancelButton = buyStars:getChild("cancelButton")
	cancelButton.sound = getHatcherySound("cancel")	
	
	local hatchedDialog = HatchedDialog:new()
	hatchedDialog.name = "hatchedDialog"
	hatchedDialog.visible = false
	hatchedDialog:setWorldView(self)
	self:addChild(hatchedDialog)
	
	self.contextMenu = HatcheryContextMenu:new()
	self.contextMenu:setWorldView(self)
	self:addChild(self.contextMenu)
	self.contextMenu.visible = false

	
	--top bar stuff
	
	self.currStarCoins = gamelua.settingsWrapper:getAvailableStarCoins()
	self.currStars = gamelua.settingsWrapper:getAvailableStars()
	

	local starButton = ui.StarCoinButton:new()
	starButton.name = "starButton"
	starButton:setupImages("H_BANK_ICON_STAR","H_BUTTON_BUY_STARS")
	--starButton:setReturnValue(hatcheryEvents.EID_HATCHERY_BUY_STARS)
	starButton:setText(self.currStars)
	self:addChild(starButton)
	starButton:setReturnValue(hatcheryEvents.EID_HATCHERY_BUY_STARS)

	local starCoinButton = ui.StarCoinButton:new()
	starCoinButton.name = "starCoinButton"
	starCoinButton:setupImages("H_BANK_ICON_COIN","H_BUTTON_BUY_STARS")
	--starCoinButton:setReturnValue(hatcheryEvents.EID_HATCHERY_BUY_STARS)
	starCoinButton:setText(self.currStarCoins)
	-- starCoinButton.scaleX = 0.5
	-- starCoinButton.scaleY = starCoinButton.scaleX
	self:addChild(starCoinButton)
	starCoinButton:setReturnValue(hatcheryEvents.EID_HATCHERY_BUY_STARCOINS)
	
	local starSpendConfirm = SpendStarConfirmationDialog:new()
	starSpendConfirm.name = "starSpendConfirm"
	starSpendConfirm:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", "H_BTN_NO", "Are you sure you want to immediately finish the construction?", "FONT_HATCHERY")
	starSpendConfirm.visible = false
	starSpendConfirm:setEvents(-1, -1)
	self:addChild(starSpendConfirm)		
	local yesButton = starSpendConfirm:getChild("yesButton")
	yesButton.sound = getHatcherySound("ok")
	local noButton = starSpendConfirm:getChild("noButton")
	noButton.sound = getHatcherySound("cancel")
	
	local NotificationDialog = NotificationDialog:new()
	NotificationDialog.name = "NotificationDialog"
	NotificationDialog.visible = false
	self:addChild(NotificationDialog)
	
	--[[local starCoinButton = ui.ScallableButton:new()
	starCoinButton.name = "starCoinButton"
	starCoinButton:setImage("H_BTN_SHUT_DOWN")
	starCoinButton.returnValue = hatcheryEvents.EID_HATCHERY_BACK_BUTTON	
	self:addChild(starCoinButton)
	starCoinButton.sound = getHatcherySound("ok")
	starCoinButton.activateOnRelease = true
	starCoinButton:setupDefaultAnimationValues()
]]
	
	
	self.protoRankTexts = {
		"Bird Collector",
		"Avian Gatherer",
		"Professional Bird Accumulator"
	}
	
	
	
	--world selection view 
	self.worldSelectionView = WorldSelectionView:new()
	self.worldSelectionView:setWorldView(self)
	
	

	-- gamelua.createHatcheryMap(gamelua.settings.hatcheryMap, hatcheryObjects)
	-- self.tileMapScale = 1
	
	
	-- gamelua.setTileMapScale(self.tileMapScale)
	
	-- variables to activate object moving when user presses the block long enough
	self.holdPos = {}
	self.holdTime = 0
	self.holdToMoveTime = 0.45
	self.holding = false
	
	self.lastCursorPos = {}
	
	self.selectTime = 0.4
	
	--"frameskipping"
	self.updateTimer =0
	self.updateTime = 0.1
	
	local eggPainter = EggPainter:new()
	eggPainter.name = "eggPainter"
	eggPainter.visible = false
	self:addChild(eggPainter)
	
	self.dynamicObjectsFile = "tileMapSave.lua"
	self.eggSpritesFile = "savedEggSprites.lua"
	
	self.drawWorld = true
	
	self.previousSelectedObject = nil
	
end

function WorldView:canAfford(stars, starCoins)
	local retVal = true
	
	if stars and stars > self.currStars then
		retVal = false
	end
	
	if starCoins and starCoins > self.currStarCoins then
		retVal = false
	end
	
	return retVal
	
end




function WorldView:createNewDynamicObject(param)

	--create proper instance
	local obj = nil
	if param.class == "egg" then
		obj = HatcheryEggObject:new()
	elseif param.class == "construct" then
		obj = HatcheryConstructionObject:new()
	elseif param.class == "nest" then
		obj = HatcheryNestObject:new()
	elseif param.class == "bird" then
		obj = HatcheryBirdObject:new()
	else
		obj = HatcheryDynamicObject:new()
	end

	obj:setServiceInterface(self)
	obj:initialize(param)
	
	self.dynamicObjects[obj:getID()] = obj
	return obj
end


function WorldView:createNewDynamicDecoration(param)
	local obj = nil
	obj = HatcheryDynamicObject:new()
	obj:setServiceInterface(self)
	obj:initialize(param)
	
	self.dynamicDecorations[obj:getID()] = obj
	return obj
end



--removes object from list, DOES NOT DESTROY THE NATIVE PART
function WorldView:removeObjectWithID(id)
	self.dynamicObjects[id] = nil
end

function WorldView:removeAndDestroyObjectWithID(id)

	self.dynamicObjects[id]:uninitialize()
	self.dynamicObjects[id] = nil
end

function WorldView:getObjectWithID(id)
	return self.dynamicObjects[id]
end


function WorldView:modifyStarCoins(delta, total)

	if total then
		self.currStarCoins = total
	else
		self.currStarCoins = self.currStarCoins + delta
	end

	local starCoins = self:getChild("starCoinButton")
	starCoins:setText(self.currStarCoins)
	gamelua.settingsWrapper:setAvailableStarCoins(self.currStarCoins)
end

function WorldView:modifyStars(delta, total)
	if total then
		self.currStars = total
	else
		self.currStars = self.currStars + delta
	end
	
	local star = self:getChild("starButton")
	star:setText(self.currStars)
	gamelua.settingsWrapper:setAvailableStars(self.currStars)
end

function WorldView:setInteractive(val)
	self.interactive = val
end

function WorldView:openEggPainter(listener)
	self.eggPainterListener = listener
	local eggPainter = self:getChild("eggPainter")
	self:openPopUp(eggPainter)
	self.drawWorld = false
end

function WorldView:getEggPainter()
	local eggPainter = self:getChild("eggPainter")
	return eggPainter
end

function WorldView:layout()	
	
	local backButton = self:getChild("backButton")
	local backOffsetX = 20
	local backOffsetY = 15
	local backPivotX, backPivotY = _G.res.getSpritePivot("", backButton.image)
	backButton.x = gamelua.screenWidth - backOffsetX - backPivotX
	backButton.y = backOffsetY + backPivotY	
	

	local eggPainter = self:getChild("eggPainter")
	eggPainter.x = gamelua.screenWidth*0.5
	eggPainter.y = gamelua.screenHeight*0.5
	

	
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm.x = gamelua.screenWidth * 0.5
	genericConfirm.y = gamelua.screenHeight * 0.5						
	
	local NotificationDialog = self:getChild("NotificationDialog")
	NotificationDialog.x = gamelua.screenWidth * 0.5
	NotificationDialog.y = gamelua.screenHeight * 0.5			
	
	
	local buyStars = self:getChild("buyStars")
	buyStars.x = gamelua.screenWidth * 0.5
	buyStars.y = gamelua.screenHeight * 0.5				
	
	
	local offset = 10
	
	local starButton = self:getChild("starButton")
	local bgElement = starButton:getChild("background")
	local bgSprite = bgElement.image
	
	
	
	local w,h = _G.res.getSpriteBounds("", bgSprite)
	local px, py = _G.res.getSpritePivot("", bgSprite)
	
	--the spacing is 30 pixels on the ipad profile
	local spacing = (30 / 149) * w
	-- starButton.x = 40
	-- starButton.y = 25
	starButton.x = offset + px
	starButton.y = offset + py
	
	
	
	
	
	local starCoinButton = self:getChild("starCoinButton")
	-- starCoinButton.x = 130
	-- starCoinButton.y = 25
	starCoinButton.x = starButton.x - px + w + px + spacing
	starCoinButton.y = starButton.y
	
	
	
	
	local starSpendConfirm = self:getChild("starSpendConfirm")
	starSpendConfirm.x = gamelua.screenWidth * 0.5
	starSpendConfirm.y = gamelua.screenHeight * 0.5
	
	
	local hatchdialog = self:getChild("hatchedDialog")
	hatchdialog.x = gamelua.screenWidth*0.5
	hatchdialog.y =	gamelua.screenHeight*0.5
	
	Frame.layout(self)	
	
	self.worldSelectionView:layout()
	self.worldSelectionPanel:layout()
	
end

function WorldView:openCostConfirmationDialog(cost, text, eventOK, eventCANCEL, logo)
	local starSpendConfirm = self:getChild("starSpendConfirm")
	starSpendConfirm:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", "H_BTN_NO", text, "FONT_HATCHERY")
	starSpendConfirm.visible = true
	starSpendConfirm:setEvents(eventOK, eventCANCEL)
	starSpendConfirm:setTotalStarCost(cost)
	starSpendConfirm:setStarImage(logo)
	self:openPopUp(starSpendConfirm)
end

function WorldView:openNotificationDialog( text, eventOK)
	local notification = self:getChild("NotificationDialog")
	notification:setEvents(eventOK)
	notification:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", text, "FONT_HATCHERY")
	self:openPopUp(notification)
end

function WorldView:updateClocksPosition()
	
	

	
end

function WorldView:loadEggCanvasSprites()
	if self.eggSprites then
		for i,v in _G.pairs(self.eggSprites) do
			gamelua.loadCanvasSprite(v,v .. ".png",64,142)
		end
	end
end

function WorldView:releaseEggCanvasSprites()
	if self.eggSprites then
		for i,v in _G.pairs(self.eggSprites) do
			gamelua.print("TRYING TO RELEASE EGG SPRITES BUT NO IMPLEMENTATION DONE. IMPLEMENT ME, PLS!\n")
		end
	end
end

function WorldView:loadEggCanvasSpriteList()
	
	
	if gamelua.checkForPersistentFile(self.eggSpritesFile) == true then
		local fileContents = gamelua.loadPersistentFileWrapper(self.eggSpritesFile)
		self.eggCanvasSpriteIdentifier = fileContents.eggCanvasSpriteIdentifier
		self.eggSprites = fileContents.eggSprites
	else
		self.eggCanvasSpriteIdentifier = 0
		self.eggSprites = {}
	end
end

function WorldView:saveEggCanvasSpriteList()
	gamelua.eggSpriteFile = {}
	gamelua.eggSpriteFile.eggCanvasSpriteIdentifier = self.eggCanvasSpriteIdentifier
	gamelua.eggSpriteFile.eggSprites = self.eggSprites
	gamelua.saveLuaFile(self.eggSpritesFile,"eggSpriteFile", true)
	
	gamelua.eggSpriteFile = nil
end

function WorldView:createSpriteFromEggPainter()
	
	local spriteName = ""
	if not self.eggCanvasSpriteIdentifier then
		gamelua.print("Warning: no egg canvas identifier set, thus can't assign a name for the sprite, ignoring save \n")
	else
		spriteName = "EGG_PAINTED_" .. self.eggCanvasSpriteIdentifier
		gamelua.createSpriteFromCanvas(spriteName ,128,128,64,142, true, spriteName .. ".png")
		
		self.eggCanvasSpriteIdentifier = self.eggCanvasSpriteIdentifier +1
		_G.table.insert(self.eggSprites,spriteName)
	end

	return spriteName
end


function WorldView:setHatchery(hatchery)
	self.hatchery = hatchery	
end

function WorldView:getHatchery()
	return self.hatchery

end

function WorldView:starCountUpdated()
	_G.res.playAudio(getHatcherySound("moneySpent"), 1, false)
	self:layout()
end

function WorldView:openExitConfirm()
	self:closeCurrentPopUp()
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm:setText("Are you sure you want to leave the Hatchery?")
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_NO)	
	self:openPopUp(genericConfirm)
end

function WorldView:openNotEnoughStarCoins()
	self:closeCurrentPopUp()
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm:setText("You don't have enough starcoins to complete the action. Want to buy more?")
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_BUY_STARCOINS, hatcheryEvents.EID_HATCHERY_GENERAL_CLOSE_POPUP)	
	self:openPopUp(genericConfirm)
end

function WorldView:openNotEnoughStars()
	self:closeCurrentPopUp()
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm:setText("You don't have enough stars to complete the action. Want to buy more?")
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_BUY_STARS, hatcheryEvents.EID_HATCHERY_GENERAL_CLOSE_POPUP)	
	self:openPopUp(genericConfirm)
end

function WorldView:openPopUp(popUpFrame)
	self.currentVisiblePopUp = popUpFrame
	popUpFrame.visible = true
	self.popUpAlpha = 0
	if self.currentVisiblePopUp ~= nil and self.currentVisiblePopUp.onEntry then
		self.currentVisiblePopUp:onEntry()
	end	
	
	for k, v in _G.pairs(self.children) do
		if v ~= popUpFrame then
			v.active = false
		end
	end
end

function WorldView:onExit()
	Frame.onExit(self)
	
	
end

function WorldView:closeCurrentPopUp()
	if self.currentVisiblePopUp ~= nil then
		if self.currentVisiblePopUp.onExit then
			self.currentVisiblePopUp:onExit()
		end
		self.currentVisiblePopUp.visible = false
		self.currentVisiblePopUp = nil
		self.popUpAlpha = 0
	end
	
	for k, v in _G.pairs(self.children) do
		v.active = true
	end
end

function WorldView:onPointerEvent(eventType,x,y)

	local result,meta, element = nil, nil, nil

	
	
	
	if self.worldSelectionView:isActive() == true and not self.currentVisiblePopUp then
		result,meta, element = self.worldSelectionView:onPointerEvent(eventType,x,y)
		return result, meta, element
	end

	
	-- if self.worldSelectionPanel:isActive() == true then
		-- result, meta = self.worldSelectionPanel:onPointerEvent(eventType,x,y)
		-- return result, meta
	-- end
	
	if self.currentVisiblePopUp then
		result,meta, element = self.currentVisiblePopUp:onPointerEvent(eventType,x, y)
	else
		result,meta, element = Frame.onPointerEvent(self, eventType,x, y)
	end	
	
	
	if result == nil then
		if eventType == "LPRESS" then
			self.PressReceived = true
			self.holdPos.x = gamelua.cursor.x
			self.holdPos.y = gamelua.cursor.y 
			
		end
	

		if eventType == "LRELEASE" then
			self.PressReceived = false
			if self.previousSelectedObject and self.dynamicObjects[self.previousSelectedObject] then
				self.dynamicObjects[self.previousSelectedObject]:deselected()
				self.previousSelectedObject = nil
			end
			if self.holding == true  then
				if self.holdTime < self.selectTime then
					--select object

					self.birdSelectionPanel:hide()

					local id, worldX, worldY = gamelua.selectObjectVisibleAtPixel(gamelua.cursor.x, gamelua.cursor.y)
					if id ~= -1 then
						if self.dynamicObjects[id] then
							self.dynamicObjects[id]:selected()
							self.previousSelectedObject = id
						end
					end
					
				end
			
			end
		end
	end
	
	if result == hatcheryEvents.EID_HATCHERY_BACK_BUTTON then
		if self.currentVisiblePopUp == nil then
			self:openExitConfirm()
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARS then
		self:closeCurrentPopUp()
		local buyStars = self:getChild("buyStars")
		buyStars:setEvents(hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY)
		self:openPopUp(buyStars)
		
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARCOINS then
		self:closeCurrentPopUp()
		local buyStars = self:getChild("buyStars")
		buyStars:setEvents(hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_STARCOINS_BUY)
		self:openPopUp(buyStars)
		
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARCOINS_BUY then
		local buyStars = self:getChild("buyStars")
		local bought = buyStars:getClickedButtonAmount()
		self:modifyStarCoins(bought)
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY then
		local buyStars = self:getChild("buyStars")
		local bought = buyStars:getClickedButtonAmount()
		self:modifyStars(bought)
		self:closeCurrentPopUp()
		
	elseif result == hatcheryEvents.EID_HATCHERY_OBJECT_SELECTED then
		if element and element.item then
			
			local obj = self:createNewDynamicObject(element.item)
			local worldX, worldY = gamelua.screenToTileWorld(gamelua.cursor.x, gamelua.cursor.y)
			self.worldSelectionView:setSelectionViewActive(obj, worldX, worldY, true )
			self.worldSelectionPanel.visible = false
			self.panelsHidden = true
			self:hideContextMenu(nil, true)

		end
	elseif result == hatcheryEvents.EID_HATCHERY_HURRY then
		self:closeCurrentPopUp()	
		self.contextMenu:handleEvent(result, meta, element)
		
	elseif result == hatcheryEvents.EID_HATCHERY_REMOVE_OBJECT then
		self:closeCurrentPopUp()
		self.contextMenu:handleEvent(result, meta, element)
		
	elseif result == hatcheryEvents.EID_HATCHERY_GENERAL_CLOSE_POPUP then
		self:closeCurrentPopUp()
		
	elseif result ==  "CLOSE_BIRD_SELECTOR" then
		self:hideBirdSelector()


	elseif result == hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_YES then
		hatcheryEventManager:notify({id = hatcheryEvents.EID_HATCHERY_GOTO_EPISODE_SELECTION})
		self:closeCurrentPopUp()
	
	elseif result == hatcheryEvents.EID_HATCHERY_MOVE_BUTTON then
		local owner = self.contextMenu:getCurrentOwner()
		local worldX, worldY = owner:getWorldPosition()
		local id = gamelua.selectTileObjectAtLocation(worldX, worldY)
		
		if id ~= -1 then
			if self.dynamicObjects[id].movable == true then
				self.dynamicObjects[id]:detachFromGrid()
				self.worldSelectionView:setSelectionViewActive(self.dynamicObjects[id], worldX, worldY, nil, true)
				self.worldSelectionPanel.visible = false
				self:hideContextMenu(nil, true)
				self.panelsHidden = true
			end
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_NO then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_EGGPAINTER then
		if self.eggPainterListener then
			self.eggPainterListener:eggPaintingDone()
		end
		self:closeCurrentPopUp()
		self.drawWorld = true
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_HATCHEDDIALOG then
		self:closeCurrentPopUp()		
	end
	
	
	return result, meta
end

function WorldView:onEntry()	
	
	self:initializeHatcheryFromMap(self.hatchery.scriptPath .. "hatcheryDefaultMap.lua" ,hatcheryObjects)
	
	
	self:loadEggCanvasSpriteList()
	self:loadEggCanvasSprites()
	
	if gamelua.checkForPersistentFile(self.dynamicObjectsFile) == true then
		gamelua.print("WORLD SAVE FOUND. LOADING THE SAVED STATE...\n")
		self:loadDynamicObjects(self.dynamicObjectsFile)
	else
		self:loadDefaultDynamicObjects(self.hatchery.scriptPath .. "hatcheryDefaultMap.lua" ,hatcheryObjects)
	end

	self.tileMapScale = 1


	
	if gamelua.deviceModel == "iphone" or gamelua.deviceModel == "iphone4" then
		self.tileMapScale = 0.5
	end
	
	gamelua.setTileMapScale(self.tileMapScale)
	
	self.worldSelectionPanel:onEntry()
	
	self:layout()
end

function WorldView:reset()
	self.dynamicObjects = {}
end

function WorldView:saveWorld()
	self:saveDynamicObjects(self.dynamicObjectsFile)
	self:saveEggCanvasSpriteList()
	gamelua.settingsWrapper:setHatcheryLocalTime(gamelua.getCurrentTime())
	
	
end



function WorldView:saveDynamicObjects(file)
	local saves = {}
	for k,v in _G.pairs(self.dynamicObjects) do
		local data = v:getSerializeTable(self)
		_G.table.insert(saves, data)
	end
	
	
	gamelua.hatcheryDynamicObjects = {}
	gamelua.hatcheryDynamicObjects.objects= saves
	gamelua.saveLuaFile(file,"hatcheryDynamicObjects", true)
	gamelua.hatcheryDynamicObjects = nil
end


function WorldView:loadDynamicObjects(file)
	local loadedObjects = gamelua.loadPersistentFileWrapper(file)
	for k,v in _G.pairs(loadedObjects.objects) do
		local object = self:createNewDynamicObject(v)

		object:attachToGrid()
	end
end

function WorldView:loadDefaultDynamicObjects(defaultsFile, templates)
	local loadedTileMap = {}
	gamelua.loadLuaFileToObject(defaultsFile, loadedTileMap, "")
	
	self.hatcheryMap = {}
	self.hatcheryMap.width =  loadedTileMap.hatcheryMap.width
	self.hatcheryMap.height =  loadedTileMap.hatcheryMap.height
	self.hatcheryMap.tileWidth = loadedTileMap.hatcheryMap.tilewidth
	self.hatcheryMap.tileHeight =  loadedTileMap.hatcheryMap.tileheight
	local iter = 0
	for k, v in _G.pairs( loadedTileMap.hatcheryMap.layers) do
		if v.name == "Dynamic" then
			for kk,vv in _G.ipairs(v.data) do
				if vv ~= 0 then
					if templates[""..vv] ~= nil then
						local object = self:createNewDynamicObject(templates[""..vv])
						local indX, indY = iter % v.width,iter / v.width
						local worldX, worldY = gamelua.getWorldCoordinatesForTileMapIndexes(indX, indY)
						object:attachToGrid(worldX, worldY)
					end
				end
				iter = iter + 1
			end
		end
		
	end
	self.hatcheryMap  = nil
	loadedTileMap = nil
end

function WorldView:loadDynamicDecorations(decorations, objectDefinitions)
	for k,v in _G.pairs(decorations) do

		--if objectDefinitions[""..v.gid] then
			local objDef = objectDefinitions[""..v.gid]
			local obj = self:createNewDynamicDecoration(objDef)
			local worldX, worldY = gamelua.convertFromTILEDCoordinates(v.x, v.y)
			obj:attachToGrid(worldX, worldY, false)
		--end	
	end
end

function WorldView:loadAnimations(animationIDs, animationFrames)

	for k,v in _G.pairs(animationIDs) do
		gamelua.createAnimation(v, animationFrames[k])
	end
end

function WorldView:initializeHatcheryFromMap(filePath, objectDefinitions)

	
	
	local loadedTileMap = {}
	gamelua.loadLuaFileToObject(filePath, loadedTileMap, "")
	
	

	self.hatcheryMap = {}
	self.hatcheryMap.width =  loadedTileMap.hatcheryMap.width
	self.hatcheryMap.height =  loadedTileMap.hatcheryMap.height
	self.hatcheryMap.tileWidth = loadedTileMap.hatcheryMap.tilewidth
	self.hatcheryMap.tileHeight =  loadedTileMap.hatcheryMap.tileheight
	
	self.hatcheryMap.layers = {}
	
	for k, v in _G.pairs( loadedTileMap.hatcheryMap.layers) do
		if v.name == "Base" then
			self.hatcheryMap.layers[v.name] = {}
			self.hatcheryMap.layers[v.name].data = v.data

		elseif v.name == "Decoration" then
			self.hatcheryMap.layers[v.name] = {}
			self.hatcheryMap.layers[v.name].objects = v.objects
		elseif v.name == "DynamicDecoration" then
			self.hatcheryMap.layers[v.name] = {}
			self.hatcheryMap.layers[v.name].objects = v.objects
		end
	end
	gamelua.initializeTileManager(self.hatcheryMap.width, self.hatcheryMap.height, (self.hatcheryMap.tileWidth - 3) * _G.math.sin(_G.math.pi * 0.25));
	self:loadAnimations(hatcheryAnimationID, hatcheryAnimations)
	gamelua.createHatcheryMap(self.hatcheryMap,objectDefinitions )
	
	self:loadDynamicDecorations(self.hatcheryMap.layers["DynamicDecoration"].objects, objectDefinitions)
	
	
	self.hatcheryMap = nil
	loadedTileMap = nil
	
end


function WorldView:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

function WorldView:setPanelsEnabled(val)
	self.worldSelectionPanel.visible = val
end

function WorldView:showContextMenu(obj)
	self.contextMenu:show()
end


function WorldView:hideContextMenu(obj, force)
	if force == true or  obj == self.contextMenu:getCurrentOwner() then
		self.contextMenu:hide()

	end
end

function WorldView:getContextMenu()
	return self.contextMenu
end

function WorldView:showHatchedDialog(bird)
	local dialog = self:getChild("hatchedDialog")
	dialog:layout()
	dialog:setCurrentBird(bird)
	self:openPopUp(dialog)
end

function WorldView:showBirdSelector()
	--self:getChild("starCoinButton").visible = false
	--self:getChild("starButton").visible = false
	self.birdSelectionPanel:show()
end

function WorldView:hideBirdSelector()
	--self:getChild("starCoinButton").visible = true
	--self:getChild("starButton").visible = true
	self.birdSelectionPanel:hide()
end	

function WorldView:getBirdSelector()
	return self.birdSelectionPanel
end

function WorldView:update(dt, time)
	gamelua.updateHatcheryMap(dt)
	
	Frame.update(self,dt,time)
	
	
	
	
	if self.worldSelectionView:isActive() == true then
		self.worldSelectionView:update(dt, time)
	-- elseif self.worldSelectionPanel:isActive() == true then
		-- self.worldSelectionPanel:update(dt, time)
	--inject events to world only if no popup is active
	elseif not self.currentVisiblePopUp then
		self:handleInput(dt,time)
	else 
		self.currentVisiblePopUp:update(dt,time)
		
		--hack to change the money to be used for hurry
		local starSpendConfirm = self:getChild("starSpendConfirm")
		if self.currentVisiblePopUp == starSpendConfirm then
			self:updateCost()
		end
		
	end
	

	

	
	
	
	
	
	--update all the dynamic world items. We don't need to update the objects on every frame.
	self.updateTimer = self.updateTimer + dt
	if self.updateTimer > self.updateTime then
		for k,v in _G.pairs(self.dynamicObjects) do
			v:update(self.updateTimer, time)
		end
		self.updateTimer = 0

	end
	
	if self.camMoveTimer and self.camMoveTimer > 0 then
	
		local t  = (self.camMoveTimer/self.camCenterTime)
		
		local cx, cy = (1-t)*self.camEndingPos.x + t*self.camStartingPos.x, (1-t)*self.camEndingPos.y + t*self.camStartingPos.y
		gamelua.setTileCameraPosition(cx,cy)
		self.camMoveTimer = self.camMoveTimer-dt
	end

	
end

function WorldView:moveCameraTo(posX, posY, transitionTime)
	self.camCenterTime = transitionTime or 0.3
	self.camMoveTimer = self.camCenterTime
	self.camStartingPos = {}
	self.camEndingPos = {}
	
	self.camStartingPos.x, self.camStartingPos.y = gamelua.getTileCameraPosition()
	
	self.camEndingPos.x = posX
	self.camEndingPos.y = posY
end

function WorldView:updateCost()

	local owner = self.contextMenu:getCurrentOwner()
	if owner then
		if owner.removing or owner.constructing then
			local cost = _G.math.floor(self.contextMenu:getCurrentOwner():getHurryCost())
			local starSpendConfirm = self:getChild("starSpendConfirm")
			starSpendConfirm:setTotalStarCost(cost)
		end
	end
end	

--allow cursor to have a small delta without breaking the "holding"
function WorldView:checkHoldingStatus()
	
	if not self.holdPos.x or not self.holdPos.y then
		return false
	end
	local deltaX = _G.math.abs(gamelua.cursor.x - self.holdPos.x)
	local deltaY = _G.math.abs(gamelua.cursor.y - self.holdPos.y)

	if (deltaX + deltaY) < 10 then
		return true
	else
		return false
	end
	
end


function WorldView:selectObject(id)
	if self.previousSelectedObject and self.dynamicObjects[self.previousSelectedObject] then
		self.dynamicObjects[self.previousSelectedObject]:deselected()
		self.previousSelectedObject = nil
	end
	
	if 	self.dynamicObjects[id] then
		self.dynamicObjects[id]:selected()
		self.previousSelectedObject = id
	end
	
end


function WorldView:handleInput(dt, time)

	

	--activate moving?
	

	
	if gamelua.keyHold["LBUTTON"] then
		--holding? if so, user might want to initiate moving the object
		if self:checkHoldingStatus()==true and self.PressReceived == true then
			self.holding = true
		else
			self.holding = false
		end
	
		if self.holding == true then
			self.holdTime = self.holdTime + dt
		else
			self.holdTime = 0
		end
		
		if self.holdTime > self.holdToMoveTime then
			local id, worldX, worldY = gamelua.selectObjectVisibleAtPixel(gamelua.cursor.x, gamelua.cursor.y)
			if id ~= -1 then
				if self.dynamicObjects[id].movable == true then
					self.holdTime = 0
					--set selection view active
					self.dynamicObjects[id]:detachFromGrid()
					self.worldSelectionView:setSelectionViewActive(self.dynamicObjects[id], worldX, worldY)
					
					self.worldSelectionPanel.visible = false
					self.panelsHidden = true
					self:hideContextMenu(nil,true)
				end
			end
		end
		
		if gamelua.keyHold["D"] then
			
			local worldX, worldY = gamelua.screenToTileWorld(gamelua.cursor.x, gamelua.cursor.y, 0)
			
			local tileIndex = gamelua.getStaticObjectID(worldX, worldY, 0)

			
			gamelua.print("TileIndex: " ..  tileIndex .."\n")
			
		end
	else
		self.holdPos.x = nil
		self.holdPos.y = nil
	end
	

	

	if self.worldSelectionView:isActive() == false and gamelua.keyHold["LBUTTON"] and self.PressReceived == true then
		if self.lastCursorPos.x and self.lastCursorPos.y then
			local deltaX = gamelua.cursor.x - self.lastCursorPos.x  
			local deltaY = gamelua.cursor.y - self.lastCursorPos.y
			gamelua.moveTileCameraPosition(deltaX, deltaY)
		end
		self.lastCursorPos.x = gamelua.cursor.x
		self.lastCursorPos.y = gamelua.cursor.y
	else
		self.lastCursorPos  = {}
	end
	
	
		--move around in tilemanager
	--[[if gamelua.keyHold["LBUTTON"] then
		if not self.prevCursor then
			self.prevCursor = {}
			self.prevCursor.x = gamelua.cursor.x
			self.prevCursor.y = gamelua.cursor.y
		else
			local deltaX = gamelua.cursor.x - self.prevCursor.x  
			local deltaY = gamelua.cursor.y - self.prevCursor.y
			gamelua.moveTileCameraPosition(deltaX, deltaY)
			self.prevCursor.x = gamelua.cursor.x
			self.prevCursor.y = gamelua.cursor.y
		end

	else
		self.prevCursor = nil
	end
	]]--

	--for PC debug only
	if gamelua.keyPressed["N"] then
		self.tileMapScale = self.tileMapScale * 1.1
		gamelua.setTileMapScale(self.tileMapScale)
	end
	if gamelua.keyPressed["M"] then
		self.tileMapScale = self.tileMapScale * 0.9
		gamelua.setTileMapScale(self.tileMapScale)
	end
	--/pc debug
end

function WorldView:draw(x, y)
	
	--for some heavy popups like painting, we do not want to draw the world to get more drawing power
	if self.drawWorld == true then
		self:drawBackground()
		
		gamelua.drawHatcheryMap()
		

		
		
		
		
		-- if self.worldSelectionPanel:isActive() == true then
			-- self.worldSelectionPanel:draw(x,y)
		-- end	
		
		for k,v in _G.pairs(self.dynamicObjects) do
			v:drawAfterWorld()
		end
		
		if self.worldSelectionView:isActive() == true then
			self.worldSelectionView:draw(x,y)
		end	
		
	end
	ui.Frame.draw(self, x, y)		
	
end

function WorldView:drawBackground()
	gamelua.setBGColor(0, 119, 238)
	
end

function WorldView:newObjectPlaced(object)
	if object:getType() == HatcheryObjectTypes["UNFINISHEDNEST"] then
		object:startConstructing()
	end
	
	if object.price and object.price > 0 then
		self:modifyStars(-object:getPrice())
		_G.res.playAudio(getHatcherySound("starSpent"), 1, false)
	end
	
end

function WorldView:setClockString(seconds)
	local days = _G.math.floor(seconds / 86400)
	local remainingSeconds = seconds - (days * 86400)
	local hours = _G.math.floor(remainingSeconds / 3600)
	remainingSeconds = remainingSeconds - (hours * 3600)
	local minutes = _G.math.floor(remainingSeconds / 60)
	remainingSeconds = remainingSeconds - (minutes * 60)
	
	remainingSeconds = _G.math.floor(remainingSeconds)
	
	local clockText = self:getChild("clockText")
	
	local hoursNormalized = "" .. hours
	if hours < 10 then
		hoursNormalized = "0" .. hours
	end
	
	local minutesNormalized = "" .. minutes
	if minutes < 10 then
		minutesNormalized = "0" .. minutes
	end
	
	local secondsNormalized = "" .. remainingSeconds
	if remainingSeconds < 10 then
		secondsNormalized = "0" .. remainingSeconds
	end
	
	if days == 0 then
		if hours == 0 then
			if minutes == 0 then
				clockText.text = remainingSeconds .. "s"
			else
				clockText.text = minutes .. "m " .. secondsNormalized .. "s"
			end
		else
			clockText.text = hours .. "h " .. minutesNormalized .. "m " .. remainingSecondsNormalized .. "s"
		end
	else
		clockText.text = "" .. days .. "d " .. hoursNormalized .. "h " .. minutesNormalized .. "m " .. secondsNormalized .. "s"
	end		
	
	self:updateClocksPosition()
end



function WorldView:getRandom(minValue, maxValue)
	local randomNormalized = _G.math.random()
	return minValue + (maxValue - minValue) * randomNormalized
end


function WorldView:tweenLinear (currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	return c*t/d + b;
end


filename="WorldView.lua"
