NestView = ui.Frame:new()
Frame = ui.Frame

function NestView:init()
	Frame.init(self)	

	--when we draw the nestview to menus, we don't want it to interact with io
	self.interactive = true
	
	self.fontScaleSmall = 0.5
	
	self.notificationSlidingTime = 0.2
	self.notificationTotalRestTime = 3
	self.notificationCheckTime = 0.3
	self.notificationTotalDelay = 1.2
	
	self.currentNest = nil
	self.currentBird = nil
	if hatchery.useNestAccessories then
		self.currentAccessory1 = nil
		self.currentAccessory2 = nil
		self.currentAccessory3 = nil
	end
	self.currentBirdBlinking = false
	self.tutorialsNeeded = true
	
	
	local emptyNestButton = ui.ScallableButton:new()
	emptyNestButton.name = "emptyNestButton"
	emptyNestButton:setImage("H_INDICATOR_NEST_POS")
	emptyNestButton.returnValue = hatcheryEvents.EID_HATCHERY_EMPTY_NEST
	emptyNestButton.activateOnRelease = true
	self:addChild(emptyNestButton)
	emptyNestButton.sound = getHatcherySound("emptySlotClicked")
	emptyNestButton:setupDefaultAnimationValues()

	if hatchery.useNestAccessories then
		local acc3Button = ui.ScallableButton:new()
		acc3Button.name = "acc3Button"
		acc3Button:setImage("H_NEST_ACC_INDICATOR_1")
		acc3Button.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_ACCESSORY3_DIALOG
		self:addChild(acc3Button)
		acc3Button.sound = getHatcherySound("emptySlotClicked")
		acc3Button.activateOnRelease = true
		acc3Button:setupDefaultAnimationValues()

		local acc3 = ui.ScallableButton:new()
		acc3.name = "acc3"
		acc3.visible = false
		acc3:setImage("")
		self:addChild(acc3)
		acc3.sound = getHatcherySound("accessoryClicked")
		acc3.activateOnRelease = true
		-- acc3:setupDefaultAnimationValues()
	end
	
	local backButton = ui.ScallableButton:new()
	backButton.name = "backButton"
	backButton:setImage("H_BTN_SHUT_DOWN")
	backButton.returnValue = hatcheryEvents.EID_HATCHERY_BACK_BUTTON	
	self:addChild(backButton)
	backButton.sound = getHatcherySound("ok")
	backButton.activateOnRelease = true
	backButton:setupDefaultAnimationValues()
	
	
	
	local placeEggButton = ui.ScallableButton:new()
	placeEggButton.name = "placeEggButton"
	placeEggButton.visible = false
	placeEggButton:setImage("H_NEST_RED")
	placeEggButton.attach = "fixed"
	placeEggButton.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_EGGS_PANEL
	self:addChild(placeEggButton)
	placeEggButton.sound = getHatcherySound("emptyNestClicked")
	placeEggButton.activateOnRelease = true
	-- placeEggButton:setupDefaultAnimationValues()
	
	local nestConstruction3 = ui.Image:new()
	nestConstruction3.name = "nestConstruction3"
	nestConstruction3.visible = false
	nestConstruction3:setImage("H_CONSTRUCTION_ELEMENT_3")
	nestConstruction3.attach = "fixed"
	self:addChild(nestConstruction3)
	
	local nestBack = ui.Image:new()
	nestBack.name = "nestBack"
	nestBack.visible = false
	nestBack:setImage("H_NEST_RED")
	nestBack.attach = "fixed"
	self:addChild(nestBack)
	
	
	local bird = ui.ScallableButton:new()
	bird.name = "bird"
	bird.visible = false
	bird:setImage("BIRD_RED_TEMP")
	bird.soundTable = hatcherySoundTable["birdIdle"]
	bird.returnValue = hatcheryEvents.EID_HATCHERY_BIRD_CLICKED
	bird.floorCoordinates = false
	self:addChild(bird)
	bird.activateOnRelease = true
	-- bird:setupDefaultAnimationValues()
	
	local egg = ui.ScallableButton:new()
	egg.name = "egg"
	egg.visible = false
	egg:setImage("H_EGG_PAINTABLE_BASE")
	egg.returnValue = hatcheryEvents.EID_HATCHERY_HATCH_EGG 
	self:addChild(egg)
	egg.sound = getHatcherySound("unhatchedEggClicked")
	egg.activateOnRelease = true
	-- egg:setupDefaultAnimationValues()
	
	local eggCrack = ui.Image:new()
	eggCrack.name = "eggCrack"
	eggCrack.visible = false
	eggCrack:setImage("")
	self:addChild(eggCrack)
	
	local eggCrackLeft = ui.Image:new()
	eggCrackLeft.name = "eggCrackLeft"
	eggCrackLeft.visible = false
	eggCrackLeft:setImage("")
	self:addChild(eggCrackLeft)
	
	local eggCrackRight = ui.Image:new()
	eggCrackRight.name = "eggCrackRight"
	eggCrackRight.visible = false
	eggCrackRight:setImage("")
	self:addChild(eggCrackRight)
	
	local eggAccTop = ui.Image:new()
	eggAccTop.name = "eggAccTop"
	eggAccTop.visible = false
	eggAccTop:setImage("")
	self:addChild(eggAccTop)
	
	local eggAccMiddle = ui.Image:new()
	eggAccMiddle.name = "eggAccMiddle"
	eggAccMiddle.visible = false
	eggAccMiddle:setImage("")
	self:addChild(eggAccMiddle)
	
	local eggAccBottom = ui.Image:new()
	eggAccBottom.name = "eggAccBottom"
	eggAccBottom.visible = false
	eggAccBottom:setImage("")
	self:addChild(eggAccBottom)
	
	local nestFront = ui.Image:new()
	nestFront.name = "nestFront"
	nestFront.visible = false
	nestFront:setImage("H_NEST_RED")
	nestFront.attach = "fixed"
	self:addChild(nestFront)
	
	local nestConstruction1 = ui.Image:new()
	nestConstruction1.name = "nestConstruction1"
	nestConstruction1.visible = false
	nestConstruction1:setImage("H_CONSTRUCTION_ELEMENT_1")
	nestConstruction1.attach = "fixed"
	self:addChild(nestConstruction1)
	
	local nestConstruction2 = ui.Image:new()
	nestConstruction2.name = "nestConstruction2"
	nestConstruction2.visible = false
	nestConstruction2:setImage("H_CONSTRUCTION_ELEMENT_2")
	nestConstruction2.attach = "fixed"
	self:addChild(nestConstruction2)
	
	if hatchery.useNestAccessories then
		local acc1Button = ui.ScallableButton:new()
		acc1Button.name = "acc1Button"
		acc1Button:setImage("H_NEST_ACC_INDICATOR_2")
		acc1Button.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_ACCESSORY1_DIALOG
		acc1Button.visible = false
		self:addChild(acc1Button)
		acc1Button.sound = getHatcherySound("emptySlotClicked")
		acc1Button.activateOnRelease = true
		acc1Button:setupDefaultAnimationValues()
		
		local acc2Button = ui.ScallableButton:new()
		acc2Button.name = "acc2Button"
		acc2Button:setImage("H_NEST_ACC_INDICATOR_2")
		acc2Button.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_ACCESSORY2_DIALOG
		self:addChild(acc2Button)
		acc2Button.sound = getHatcherySound("emptySlotClicked")
		acc2Button.activateOnRelease = true
		acc2Button:setupDefaultAnimationValues()
		
		local acc1 = ui.ScallableButton:new()
		acc1.name = "acc1"
		acc1.visible = false
		acc1:setImage("")
		self:addChild(acc1)
		acc1.sound = getHatcherySound("accessoryClicked")
		acc1.activateOnRelease = true
		-- acc1:setupDefaultAnimationValues()
		
		local acc2 = ui.ScallableButton:new()
		acc2.name = "acc2"
		acc2.visible = false
		acc2:setImage("")
		self:addChild(acc2)
		acc2.sound = getHatcherySound("accessoryClicked")
		acc2.activateOnRelease = true
		-- acc2:setupDefaultAnimationValues()
		
		local acc2b = ui.ScallableButton:new()
		acc2b.name = "acc2b"
		acc2b.visible = false
		acc2b:setImage("H_NEST_ACC_LOWER_1")
		self:addChild(acc2b)
		acc2b.sound = getHatcherySound("accessoryClicked")
		acc2b.activateOnRelease = true
		-- acc2b:setupDefaultAnimationValues()
	end
	
	local nestFill = NestFillBar:new()
	nestFill.name = "nestFill"
	nestFill.visible = false
	self:addChild(nestFill)
	
	local nestHurry = ui.ScallableButton:new()
	nestHurry.name = "nestHurry"
	nestHurry.visible = false
	nestHurry:setImage("H_BTN_HURRY")
	nestHurry.returnValue = hatcheryEvents.EID_HATCHERY_HURRY	
	self:addChild(nestHurry)
	nestHurry.sound = getHatcherySound("hurryButton")
	nestHurry.activateOnRelease = true
	nestHurry:setupDefaultAnimationValues()
	
	local matrix = ui.ScallableButton:new()
	matrix.name = "matrix"
	matrix.visible = false
	matrix:setImage("H_BTN_PLAZA")
	matrix.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_MATRIX_ASDF -- matrix disabled for now, as it crashes and that's kinda bad in a demo :)
	self:addChild(matrix)
	matrix.sound = getHatcherySound("matrixButton")
	matrix.activateOnRelease = true
	matrix:setupDefaultAnimationValues()

	--[[local matrixNotificationIcon = ui.Image:new()
	matrixNotificationIcon.name = "matrixNotificationIcon"
	matrixNotificationIcon.visible = false
	matrixNotificationIcon:setImage("H_NOTIFICATION_ICON_BG")
	self:addChild(matrixNotificationIcon)
	
	self.notificationCounter = 0
	
	local matrixNotificationText = ui.Text:new()
	matrixNotificationText.name = "matrixNotificationText"
	matrixNotificationText.visible = false
	matrixNotificationText.text = "" .. self.notificationCounter
	matrixNotificationText.font = "FONT_HATCHERY"
	self:addChild(matrixNotificationText)
	]]
	
	
	local emptyNestArrow = ui.Image:new()
		emptyNestArrow.name = "emptyNestArrow"
		emptyNestArrow:setImage("H_ARROW_1")
		emptyNestArrow.attach = "fixed"
		self:addChild(emptyNestArrow)
		
		if hatchery.useNestAccessories then
		local accessoryArrow3 = ui.Image:new()
		accessoryArrow3.name = "accessoryArrow3"
		accessoryArrow3:setImage("H_ARROW_1")
		accessoryArrow3.attach = "fixed"
		self:addChild(accessoryArrow3)
		
		local accessoryArrow2 = ui.Image:new()
		accessoryArrow2.name = "accessoryArrow2"
		accessoryArrow2:setImage("H_ARROW_1")
		accessoryArrow2.attach = "fixed"
		self:addChild(accessoryArrow2)
	end
	
	local emptyNestText = ui.Image:new()
	emptyNestText.name = "emptyNestText"
	emptyNestText:setImage("H_DIALOG_TAP_THE_MARK_TEMP")
	emptyNestText.attach = "fixed"
	
	self:addChild(emptyNestText)
	
	local emptyEggText = ui.Image:new()
	emptyEggText.name = "emptyEggText"
	emptyEggText:setImage("H_DIALOG_TAP_THE_NEST_TEMP")
	emptyEggText.attach = "fixed"
	emptyEggText.visible = false
	self:addChild(emptyEggText)
	
	local hatchEggText = ui.Image:new()
	hatchEggText.name = "hatchEggText"
	hatchEggText:setImage("H_DIALOG_TAP_TO_HATCH_TEMP")
	hatchEggText.attach = "fixed"
	hatchEggText.visible = false
	self:addChild(hatchEggText)
	
	local settingsButton = ui.ScallableButton:new()
	settingsButton.name = "settingsButton"
	settingsButton:setImage("H_BTN_ACCESSORIES")
	settingsButton.returnValue = hatcheryEvents.EID_HATCHERY_ACCESSORIES	
	self:addChild(settingsButton)
	settingsButton.sound = getHatcherySound("accesoriesButton")
	settingsButton.activateOnRelease = true
	settingsButton:setupDefaultAnimationValues()
	
	

	self.bgSprites = {	
		layer1 = {"H_BG_DEFAULT_CLOUD_3", "H_BG_DEFAULT_CLOUD_4"},
		layer2 = {"H_BG_DEFAULT_CLOUD_1", "H_BG_DEFAULT_CLOUD_2"},
		layer3 = {"H_BG_DEFAULT_DECO_3"},
		layer4 = {"H_BG_DEFAULT_DECO_1", "H_BG_DEFAULT_DECO_2"},
		layer5 = {"H_BG_DEFAULT_DECO_6", "H_BG_DEFAULT_DECO_7"},
		layer6 = {"H_BG_DEFAULT_DECO_4", "H_BG_DEFAULT_DECO_5"},
		layer7 = {"H_BG_DEFAULT_DECO_8", "H_BG_DEFAULT_DECO_9", "H_BG_DEFAULT_DECO_10", "H_BG_DEFAULT_DECO_11"}
	}
	
	local speedMultiplier = 1
	
	self.bgElements = {
		layer1 = {maxElements = 2, elements = {}},
		layer2 = {maxElements = 3, elements = {}},
		layer3 = {elements = {
								{sprite = "H_BG_DEFAULT_DECO_3", x = gamelua.screenWidth * 0.1, y = gamelua.screenHeight * 0.52, angle = 0, speed = 0.08 * speedMultiplier, startSpeed = 0.08 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_3", x = gamelua.screenWidth * 0.6, y = gamelua.screenHeight * 0.48, angle = 0, speed = -0.12 * speedMultiplier, startSpeed = -0.12 * speedMultiplier},
								{sprite = "H_BG_DEFAULT_DECO_3", x = gamelua.screenWidth * 0.8, y = gamelua.screenHeight * 0.53, angle = 0, speed = 0.09 * speedMultiplier, startSpeed = 0.09 * speedMultiplier},
				}
		},
		layer4 = {elements = {
								{sprite = "H_BG_DEFAULT_DECO_1", x = gamelua.screenWidth * 0.35, y = gamelua.screenHeight * 0.49, angle = 0, speed = 0.09 * speedMultiplier, startSpeed = 0.09 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_2", x = gamelua.screenWidth * 0.55, y = gamelua.screenHeight * 0.51, angle = 0, speed = 0.05 * speedMultiplier, startSpeed = 0.05 * speedMultiplier  },
				}
		},
		layer5 = {elements = {
								{sprite = "H_BG_DEFAULT_DECO_6", x = gamelua.screenWidth * 0.25, y = gamelua.screenHeight * 0.605, angle = 0, speed = -0.1 * speedMultiplier, startSpeed = -0.1 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_7", x = gamelua.screenWidth * 0.28, y = gamelua.screenHeight * 0.605, angle = 0, speed = -0.12 * speedMultiplier, startSpeed = -0.12 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_6", x = gamelua.screenWidth * 0.64, y = gamelua.screenHeight * 0.58, angle = 0, speed = 0.16 * speedMultiplier, startSpeed = 0.16 * speedMultiplier},
								{sprite = "H_BG_DEFAULT_DECO_7", x = gamelua.screenWidth * 0.67, y = gamelua.screenHeight * 0.58, angle = 0, speed = 0.06 * speedMultiplier, startSpeed = 0.06 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_6", x = gamelua.screenWidth * 0.76, y = gamelua.screenHeight * 0.59, angle = 0, speed = -0.08 * speedMultiplier, startSpeed = -0.08 * speedMultiplier}
				}
		},
		layer6 = {elements = {
								{sprite = "H_BG_DEFAULT_DECO_4", x = gamelua.screenWidth * 0.15, y = gamelua.screenHeight * 0.62, angle = 0, speed = -0.1 * speedMultiplier, startSpeed = -0.1 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_4", x = gamelua.screenWidth * 0.45, y = gamelua.screenHeight * 0.61, angle = 0, speed = 0.11 * speedMultiplier, startSpeed = 0.11 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_5", x = gamelua.screenWidth * 0.57, y = gamelua.screenHeight * 0.61, angle = 0, speed = -0.17 * speedMultiplier, startSpeed = -0.17 * speedMultiplier },
				}
		},
		layer7 = {elements = {
								{sprite = "H_BG_DEFAULT_DECO_8", x = gamelua.screenWidth * 0.15, y = gamelua.screenHeight * 0.7, angle = 0, speed = -0.2 * speedMultiplier, startSpeed = -0.2 * speedMultiplier},
								{sprite = "H_BG_DEFAULT_DECO_9", x = gamelua.screenWidth * 0.21, y = gamelua.screenHeight * 0.74, angle = 0, speed = 0.12 * speedMultiplier, startSpeed = 0.12 * speedMultiplier},
								{sprite = "H_BG_DEFAULT_DECO_11", x = gamelua.screenWidth * 0.23, y = gamelua.screenHeight * 0.95, angle = 0, speed = 0.14 * speedMultiplier, startSpeed = 0.14 * speedMultiplier},
								{sprite = "H_BG_DEFAULT_DECO_8", x = gamelua.screenWidth * 0.66, y = gamelua.screenHeight * 0.75, angle = 0, speed = -0.13 * speedMultiplier, startSpeed = -0.13 * speedMultiplier },
								{sprite = "H_BG_DEFAULT_DECO_8", x = gamelua.screenWidth * 0.80, y = gamelua.screenHeight * 0.74, angle = 0, speed = -0.12 * speedMultiplier, startSpeed = -0.12 * speedMultiplier},
								{sprite = "H_BG_DEFAULT_DECO_9", x = gamelua.screenWidth * 0.90, y = gamelua.screenHeight * 0.78, angle = 0, speed = -0.16 * speedMultiplier, startSpeed = -0.16 * speedMultiplier},
				}
		}
	}
	self.layersPrepared = false
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
	-- genericConfirm.scaleX = 0.5
	-- genericConfirm.scaleY = 0.5
	
	
	local starSpendConfirm = SpendStarConfirmationDialog:new()
	starSpendConfirm.name = "starSpendConfirm"
	starSpendConfirm:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", "H_BTN_NO", "Are you sure you want to immediately hatch this egg?", "FONT_HATCHERY")
	starSpendConfirm.visible = false
	starSpendConfirm:setEvents(hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_NO)
	self:addChild(starSpendConfirm)		
	local yesButton = starSpendConfirm:getChild("yesButton")
	yesButton.sound = getHatcherySound("ok")
	local noButton = starSpendConfirm:getChild("noButton")
	noButton.sound = getHatcherySound("cancel")
	
	local buyStars = BuyStarsDialog:new()
	buyStars.name = "buyStars"
	buyStars.visible = false
	buyStars:setEvents(hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY)
	self:addChild(buyStars)
	local cancelButton = buyStars:getChild("cancelButton")
	cancelButton.sound = getHatcherySound("cancel")
	
	local buyNest = NestSelectionDialog:new()
	buyNest.name = "buyNest"
	buyNest.visible = false
	buyNest:setNests(hatchery:getNests())
	buyNest:setEvents(hatcheryEvents.EID_HATCHERY_BUY_NEST_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_NEST_BUY)
	self:addChild(buyNest)
	
	local buyEgg = EggSelectionDialog:new()
	buyEgg.name = "buyEgg"
	buyEgg.visible = false
	buyEgg:setEggs(hatchery:getEggs())
	buyEgg:setEvents(hatcheryEvents.EID_HATCHERY_BUY_EGG_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_EGG_BUY)
	self:addChild(buyEgg)
	
	local birdMatrix = BirdMatrixDialog:new()
	birdMatrix.name = "birdMatrix"
	birdMatrix.visible = false
	birdMatrix:setEvents(hatcheryEvents.EID_HATCHERY_MATRIX_CANCEL, hatcheryEvents.EID_HATCHERY_OPEN_STATCARD)
	self:addChild(birdMatrix)
	
	local statCard = StatCardDialog:new()
	statCard.name = "statCard"
	statCard.visible = false
	statCard:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_STATCARD)
	self:addChild(statCard)
	
	local testFrame = TestFrame:new()
	testFrame.name = "testFrame"
	testFrame.visible = false
	self:addChild(testFrame)
	
	
	local hatchedDialog = HatchedDialog:new()
	hatchedDialog.name = "hatchedDialog"
	hatchedDialog.visible = false
	self:addChild(hatchedDialog)
	

	

	if hatchery.useNestAccessories then
		-- <Nest Accessory stuff>
		local accDialog1 = NestAccessoryDialog:new()
		accDialog1:setAccessories(hatchery:getNestAccessories(), 1)
		accDialog1:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG, hatcheryEvents.EID_HATCHERY_ACCESSORY1_BUY)
		accDialog1.name = "accDialog1"
		accDialog1.visible = false
		self:addChild(accDialog1)
		
		local accDialog2 = NestAccessoryDialog:new()
		accDialog2:setAccessories(hatchery:getNestAccessories(), 2)
		accDialog2:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG, hatcheryEvents.EID_HATCHERY_ACCESSORY2_BUY)
		accDialog2.name = "accDialog2"
		accDialog2.visible = false
		self:addChild(accDialog2)
		
		local accDialog3 = NestAccessoryDialog:new()
		accDialog3:setAccessories(hatchery:getNestAccessories(), 3)
		accDialog3:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG, hatcheryEvents.EID_HATCHERY_ACCESSORY3_BUY)
		accDialog3.name = "accDialog3"
		accDialog3.visible = false
		self:addChild(accDialog3)
		-- </Nest Accessory stuff>
	end
	
	local eggAccDialog = EggAccessoryDialog:new()
	eggAccDialog:setAccessories(hatchery:getEggAccessories(), self)
	eggAccDialog:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_EGGACCESSORY_DIALOG)
	eggAccDialog.name = "eggAccDialog"
	eggAccDialog.visible = false
	self:addChild(eggAccDialog)

	
	local tasksScreen = TasksDialog:new()
	tasksScreen.name = "tasksScreen"
	tasksScreen.visible = false
	tasksScreen:setEvents(hatcheryEvents.EID_HATCHERY_TASKS_SCREEN_CANCEL)		
	tasksScreen:addListener(self)
	self:addChild(tasksScreen)

	self.currentVisiblePopUp = nil

	
	
	--for debugging only
	local debugPosText = ui.Text:new()
	debugPosText.name = "debugPosText"
	debugPosText.hanchor = "RIGHT"
	debugPosText.vanchor = "VCENTER"
	debugPosText.font = "FONT_HATCHERY"
	debugPosText.text = "x: 0 y: 0"
	debugPosText.visible = false
	self:addChild(debugPosText)
	
	
	
	
	
	--top bar stuff
	local taskCompletedNotification = TaskEntryButton:new()
	taskCompletedNotification.name = "taskCompletedNotification"
	taskCompletedNotification.visible = false
	taskCompletedNotification.returnValue = (hatcheryEvents.EID_HATCHERY_OPEN_TASKS_SCREEN)
	taskCompletedNotification:setImage("H_TASK_ACHIEVED_BG")
	self:addChild(taskCompletedNotification)
	
	local topBar = ui.Image:new()
	topBar.name = "topBar"
	topBar:setImage("H_TOP_BAR")
	topBar.attach = "fixed"
	self:addChild(topBar)
	
	local starIcon = ui.Image:new()
	starIcon.name = "starIcon"
	starIcon:setImage("H_STAR_SMALL")
	starIcon.attach = "fixed"
	
	self:addChild(starIcon)
	
	local starLabel = ui.Text:new()
	starLabel.name = "starLabel"
	starLabel.hanchor = "LEFT"
	starLabel.vanchor = "VCENTER"
	starLabel.font = "FONT_HATCHERY"
	starLabel.scaleX = self.fontScaleSmall
	starLabel.scaleY = self.fontScaleSmall
	self:addChild(starLabel)
	
	local starBuyButton = ui.StaticButton:new()
	starBuyButton.name = "starBuyButton"
	starBuyButton:setImage("H_BTN_BUY_STARS")
	starBuyButton.returnValue = hatcheryEvents.EID_HATCHERY_BUY_STARS
	self:addChild(starBuyButton)
	starBuyButton.sound = getHatcherySound("buyStarsClicked")
	starBuyButton.activateOnRelease = true
	
	self.protoRankTexts = {
		"Bird Collector",
		"Avian Gatherer",
		"Professional Bird Accumulator"
	}
	
	local playerRankDescription = ui.TextButton:new()
	playerRankDescription.name = "playerRankDescription"
	playerRankDescription.font = "FONT_HATCHERY"
	playerRankDescription.text = self.protoRankTexts[hatchery:getPlayerRank()]
	playerRankDescription.returnValue = (hatcheryEvents.EID_HATCHERY_OPEN_TASKS_SCREEN)
	self:addChild(playerRankDescription)
	
	local playerRankText = ui.TextButton:new()
	playerRankText.name = "playerRankText"
	playerRankText.font = "FONT_HATCHERY"
	playerRankText.text = "Level " .. hatchery:getPlayerRank()
	playerRankText.returnValue = (hatcheryEvents.EID_HATCHERY_OPEN_TASKS_SCREEN)
	self:addChild(playerRankText)
	
	local clockIcon = ui.Image:new()
	clockIcon.name = "clockIcon"
	clockIcon:setImage("H_CLOCK_MEDIUM")
	clockIcon.attach = "fixed"
	self:addChild(clockIcon)
	
	local clockText = ui.Text:new()
	clockText.name = "clockText"
	clockText.hanchor = "RIGHT"
	clockText.vanchor = "VCENTER"
	clockText.font = "FONT_HATCHERY"
	clockText.text = "1m54s"
	clockText.scaleX = self.fontScaleSmall
	clockText.scaleY = self.fontScaleSmall
	self:addChild(clockText)
	
	
	local eggPainter = EggPainter:new()
	eggPainter.name = "eggPainter"
	eggPainter.visible = false
	self:addChild(eggPainter)
	
	
	
	self:setupCurrentStateBasedOnHatchery()
	
	self:setupSelectableItems()
	
	self:setupDrawingOrderTables()
	
	--sets up particle system
	self.particles = NestViewParticles:new()
	
	
end

function NestView:setBirdVisibility(val)
	local birdButton = self:getChild("bird")
	birdButton.visible = val
end

function NestView:setInteractive(val)
	self.interactive = val
end


function NestView:setupSelectableItems()
	local emptyNestButton = self:getChild("emptyNestButton")	
	local backButton = self:getChild("backButton")	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	
	if hatchery.useNestAccessories then
		local accessoryArrow2 = self:getChild("accessoryArrow2")
		local accessoryArrow3 = self:getChild("accessoryArrow3")
	end
	
	local emptyNestText = self:getChild("emptyNestText")
	local emptyEggText = self:getChild("emptyEggText")
	local topBar = self:getChild("topBar")
	local starIcon = self:getChild("starIcon")
	local starLabel = self:getChild("starLabel")
	local starBuyButton = self:getChild("starBuyButton")
	local clockIcon = self:getChild("clockIcon")
	local clockText = self:getChild("clockText")
	local placeEggButton = self:getChild("placeEggButton")
	local nestBack = self:getChild("nestBack")
	local bird = self:getChild("bird")
	local egg = self:getChild("egg")
	local nestFront = self:getChild("nestFront")
	local nestFill = self:getChild("nestFill")
	local nestHurry = self:getChild("nestHurry")
	local matrix = self:getChild("matrix")
	
	
	
	self.selectableItems = {}
	
	if self.currentVisiblePopUp ~= nil then
		
		for k,v in _G.pairs(self.currentVisiblePopUp.children) do
			_G.table.insert(self.selectableItems, v)
		end
	else
		
		
		_G.table.insert(self.selectableItems, matrix)
		_G.table.insert(self.selectableItems, emptyNestButton)
		if hatchery.useNestAccessories then
			_G.table.insert(self.selectableItems, accessoryArrow2)
			_G.table.insert(self.selectableItems, accessoryArrow3)
		end
		_G.table.insert(self.selectableItems, backButton)
		_G.table.insert(self.selectableItems, emptyNestArrow)
		_G.table.insert(self.selectableItems, emptyNestText)
		_G.table.insert(self.selectableItems, emptyEggText)
		_G.table.insert(self.selectableItems, topBar)
		_G.table.insert(self.selectableItems, starIcon)
		_G.table.insert(self.selectableItems, starLabel)
		_G.table.insert(self.selectableItems, starBuyButton)
		_G.table.insert(self.selectableItems, clockIcon)
		_G.table.insert(self.selectableItems, clockText)
		_G.table.insert(self.selectableItems, placeEggButton)
		_G.table.insert(self.selectableItems, nestBack)
		_G.table.insert(self.selectableItems, bird)
		_G.table.insert(self.selectableItems, egg)
		_G.table.insert(self.selectableItems, nestFront)
		_G.table.insert(self.selectableItems, nestFill)
		_G.table.insert(self.selectableItems, nestHurry)
		
	end
end

function NestView:layout()

	local taskCompletedNotification = self:getChild("taskCompletedNotification")
	taskCompletedNotification.x = gamelua.screenWidth * 0.5
	

	local debugPosText = self:getChild("debugPosText")
	debugPosText.x = gamelua.screenWidth
	debugPosText.y = gamelua.screenHeight * 0.5
	
	local emptyNestButton = self:getChild("emptyNestButton")
	local emptyNestRatioX, emptyNestRatioY = 0.5, 0.77
	emptyNestButton.x = gamelua.screenWidth * emptyNestRatioX
	emptyNestButton.y = gamelua.screenHeight * emptyNestRatioY
	
	local backButton = self:getChild("backButton")
	local backOffsetX = 20
	local backOffsetY = 15
	local backPivotX, backPivotY = _G.res.getSpritePivot("", backButton.image)
	backButton.x = backOffsetX + backPivotX
	backButton.y = gamelua.screenHeight - (backButton.w - backPivotY) - backOffsetY 
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	local emptyNestArrowOffsetX, emptyNestArrowOffsetY = 130, -100
	emptyNestArrow.x = emptyNestButton.x + emptyNestArrowOffsetX
	emptyNestArrow.y = emptyNestButton.y + emptyNestArrowOffsetY
	emptyNestArrow.angle = -_G.math.pi * 0.70
	

	
	local emptyNestText = self:getChild("emptyNestText")
	local emptyNestTextOffsetX, emptyNestTextOffsetY = 130, 80
	emptyNestText.x = emptyNestArrow.x + emptyNestTextOffsetX
	emptyNestText.y = emptyNestArrow.y + emptyNestTextOffsetY
	
	local emptyEggText = self:getChild("emptyEggText")
	emptyEggText.x = emptyNestText.x
	emptyEggText.y = emptyNestText.y
	
	local hatchEggText = self:getChild("hatchEggText")
	hatchEggText.x, hatchEggText.y = emptyNestText.x, emptyNestText.y
	
	local topBar = self:getChild("topBar")
	local topBarRatioX, topBarRatioY = 0.5, -0.01
	topBar.x = gamelua.screenWidth * topBarRatioX
	topBar.y = gamelua.screenHeight * topBarRatioY
	local topBarPivotX, topBarPivotY = _G.res.getSpritePivot("", topBar.image)
	
	local topBarLeft = topBar.x - topBarPivotX
	local starIcon = self:getChild("starIcon")
	starIcon.x = topBarLeft + 70
	starIcon.y = 40	
	
	local starLabel = self:getChild("starLabel")
	starLabel.x = starIcon.x + 20
	starLabel.y = starIcon.y
	starLabel.text = "" .. self.hatchery:getStars()

	
	
	gamelua.setFont(starLabel.font)
	local t_width = _G.res.getStringWidth("" .. self.hatchery:getStars()) * starLabel.scaleX
	
	local starBuyButton = self:getChild("starBuyButton")
	starBuyButton.x = starLabel.x + t_width + 30
	starBuyButton.y = starLabel.y
	
	self:updateClocksPosition()
	
	local playerRankDescription = self:getChild("playerRankDescription")
	playerRankDescription.x, playerRankDescription.y = gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.075
	playerRankDescription.scaleX, playerRankDescription.scaleY = 0.5, 0.5
	
	local playerRankText = self:getChild("playerRankText")
	playerRankText.x, playerRankText.y = gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.04
	playerRankText.scaleX, playerRankText.scaleY = 0.4, 0.4
	
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm.x = gamelua.screenWidth * 0.5
	genericConfirm.y = gamelua.screenHeight * 0.5
	
	
	
	
	local starSpendConfirm = self:getChild("starSpendConfirm")
	starSpendConfirm.x = gamelua.screenWidth * 0.5
	starSpendConfirm.y = gamelua.screenHeight * 0.5
	
	
	
	local buyStars = self:getChild("buyStars")
	buyStars.x = gamelua.screenWidth * 0.5
	buyStars.y = gamelua.screenHeight * 0.5
	
	local hatchedDialog = self:getChild("hatchedDialog")
	hatchedDialog.x = gamelua.screenWidth * 0.5
	hatchedDialog.y = gamelua.screenHeight * 0.5
	
	local eggPainter = self:getChild("eggPainter")
	eggPainter.x = gamelua.screenWidth*0.5
	eggPainter.y = gamelua.screenHeight*0.5
	
	local buyNest = self:getChild("buyNest")
	buyNest.x = gamelua.screenWidth * 0.5
	buyNest.y = gamelua.screenHeight * 0.5
	
	local buyEgg = self:getChild("buyEgg")
	buyEgg.x = gamelua.screenWidth * 0.5
	buyEgg.y = gamelua.screenHeight * 0.5
	
	local nestConstruction3 = self:getChild("nestConstruction3")
	nestConstruction3.x, nestConstruction3.y = emptyNestButton.x, emptyNestButton.y
	nestConstruction3.visible = self.currentNest ~= nil and not self.currentNest:isCompleted()
	
	local nestBack = self:getChild("nestBack")
	nestBack.x = emptyNestButton.x
	nestBack.y = emptyNestButton.y
	
	local placeEggButton = self:getChild("placeEggButton")
	placeEggButton.x = nestBack.x
	placeEggButton.y = nestBack.y
	
	local bird = self:getChild("bird")
	bird.x = nestBack.x
	bird.y = nestBack.y - 20
	if self.currentBird ~= nil then
		local _, sh = _G.res.getSpriteBounds(self.currentBird.sprite)
		bird.y = nestBack.y - 120 * (sh / 280)
	end
	
	local egg = self:getChild("egg")
	egg.x = emptyNestButton.x
	egg.y = emptyNestButton.y 
	


	
	local eggCrack = self:getChild("eggCrack")
	eggCrack.x = egg.x
	eggCrack.y = egg.y
	
	local eggCrackLeft = self:getChild("eggCrackLeft")
	eggCrackLeft.x = egg.x
	eggCrackLeft.y = egg.y
	
	local eggCrackRight = self:getChild("eggCrackRight")
	eggCrackRight.x = egg.x
	eggCrackRight.y = egg.y
	
	local eggAccTop = self:getChild("eggAccTop")
	eggAccTop.x, eggAccTop.y = egg.x, egg.y
	
	local eggAccMiddle = self:getChild("eggAccMiddle")
	eggAccMiddle.x, eggAccMiddle.y = egg.x, egg.y
	
	local eggAccBottom = self:getChild("eggAccBottom")
	eggAccBottom.x, eggAccBottom.y = egg.x, egg.y
	
	local nestFront = self:getChild("nestFront")
	nestFront.x = nestBack.x
	nestFront.y = nestBack.y
	
	local nestConstruction1 = self:getChild("nestConstruction1")
	nestConstruction1.x, nestConstruction1.y = emptyNestButton.x, emptyNestButton.y
	nestConstruction1.visible = self.currentNest ~= nil and not self.currentNest:isCompleted()
	
	local nestConstruction2 = self:getChild("nestConstruction2")
	nestConstruction2.x, nestConstruction2.y = emptyNestButton.x, emptyNestButton.y
	nestConstruction2.visible = self.currentNest ~= nil and not self.currentNest:isCompleted()
	
	local nestFill = self:getChild("nestFill")
	local nestFillOffsetX, nestFillOffsetY = 0, 130
	nestFill.x = nestBack.x + nestFillOffsetX
	nestFill.y = nestBack.y + nestFillOffsetY
	
	local nestHurry = self:getChild("nestHurry")
	local nestHurryOffsetX, nestHurryOffsetY = 240, 0
	nestHurry.x = nestFill.x + nestHurryOffsetX
	nestHurry.y = nestFill.y + nestHurryOffsetY
	
	local matrix = self:getChild("matrix")
	local matrixPivotX, matrixPivotY = _G.res.getSpritePivot("", matrix.image)
	matrix.x = gamelua.screenWidth - (matrix.w - matrixPivotX) - backOffsetX
	matrix.y = backButton.y
	
	--[[local matrixW, matrixH = _G.res.getSpriteBounds(matrix.image)
	local matrixNotificationIcon = self:getChild("matrixNotificationIcon")
	matrixNotificationIcon.x, matrixNotificationIcon.y = matrix.x + matrixW * 0.39, matrix.y - matrixH * 0.39
	matrixNotificationIcon.visible = self.notificationCounter > 0
	
	local matrixNotificationText = self:getChild("matrixNotificationText")
	matrixNotificationText.text = "" .. self.notificationCounter
	matrixNotificationText.x, matrixNotificationText.y = matrixNotificationIcon.x, matrixNotificationIcon.y
	matrixNotificationText.scaleX, matrixNotificationText.scaleY = 0.3, 0.3
	matrixNotificationText.visible = self.notificationCounter > 0
	]]
	
	local birdMatrix = self:getChild("birdMatrix")
	birdMatrix.x = gamelua.screenWidth * 0.5
	birdMatrix.y = gamelua.screenHeight * 0.5
	
	local statCard = self:getChild("statCard")
	statCard.x = gamelua.screenWidth * 0.5
	statCard.y = gamelua.screenHeight * 0.5
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.x = gamelua.screenWidth * 0.25
		acc1Button.y = gamelua.screenHeight * 0.78
		acc1Button.visible = false

		local acc2Button = self:getChild("acc2Button")
		acc2Button.x = gamelua.screenWidth * 0.75
		acc2Button.y = gamelua.screenHeight * 0.85
		
		local acc3Button = self:getChild("acc3Button")
		acc3Button.x = gamelua.screenWidth * 0.7
		acc3Button.y = gamelua.screenHeight * 0.67
		
		local accessoryArrowOffsetX, accessoryArrowOffsetY = 70, -50
		local accessoryArrow2 = self:getChild("accessoryArrow2")
		accessoryArrow2.x, accessoryArrow2.y = acc2Button.x + accessoryArrowOffsetX, acc2Button.y + accessoryArrowOffsetY
		accessoryArrow2.angle = -_G.math.pi * 0.7
		local accessoryArrow3 = self:getChild("accessoryArrow3")
		accessoryArrow3.x, accessoryArrow3.y = acc3Button.x + accessoryArrowOffsetX, acc3Button.y + accessoryArrowOffsetY
		accessoryArrow3.angle = -_G.math.pi * 0.7
		
		local acc1 = self:getChild("acc1")
		acc1.x = acc1Button.x
		acc1.y = acc1Button.y
		
		local acc2 = self:getChild("acc2")
		acc2.x = acc2Button.x
		acc2.y = acc2Button.y
		
		local acc2b = self:getChild("acc2b")
		acc2b.x = acc2Button.x 
		acc2b.y = acc2Button.y - gamelua.screenHeight * 0.175
		
		local acc3 = self:getChild("acc3")
		acc3.x = acc3Button.x
		acc3.y = acc3Button.y
		
		local accDialog1 = self:getChild("accDialog1")
		accDialog1.x = gamelua.screenWidth * 0.5
		accDialog1.y = gamelua.screenHeight * 0.5

		local accDialog2 = self:getChild("accDialog2")
		accDialog2.x = gamelua.screenWidth * 0.5
		accDialog2.y = gamelua.screenHeight * 0.5
		
		local accDialog3 = self:getChild("accDialog3")
		accDialog3.x = gamelua.screenWidth * 0.5
		accDialog3.y = gamelua.screenHeight * 0.5
	end
	
		
	local eggAccDialog = self:getChild("eggAccDialog")
	eggAccDialog.x, eggAccDialog.y = gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.5
	
	
	local settingsButton = self:getChild("settingsButton")
	settingsButton.x = gamelua.screenWidth * 0.5
	settingsButton.y = nestFill.y
	
	self.particles:setSource(playerRankDescription.x, playerRankDescription.y, "LEVEL_UP")
	self.particles:setSource(emptyNestButton.x, emptyNestButton.y, "HATCH_BIRD")
	self.particles:setSource(emptyNestButton.x, emptyNestButton.y, "NEST_READY")
	
	local testFrame = self:getChild("testFrame")
	testFrame.x = gamelua.screenWidth * 0.5
	testFrame.y = gamelua.screenHeight * 0.5
	
	
	local tasksScreen = self:getChild("tasksScreen")
	tasksScreen.x = gamelua.screenWidth * 0.5
	tasksScreen.y = gamelua.screenHeight * 0.5
	
	
	Frame.layout(self)	
	
end

function NestView:updateClocksPosition()
	local starIcon = self:getChild("starIcon")		
	local starLabel = self:getChild("starLabel")
	local topBar = self:getChild("topBar")
	local topBarPivotX, _ = _G.res.getSpritePivot("", topBar.image)
	
	local clockIcon = self:getChild("clockIcon")		
	local clockText = self:getChild("clockText")
	
	local clockIconOffset = 20
	-- local clockIconOffset = 0
	local clockTextOffset = 50
	
	local topBarRight = topBar.x + (topBar.w - topBarPivotX)
	gamelua.setFont(clockText.font)
	
	-- local totalChars = #clockText.text
	-- local stringWidth = totalChars * _G.res.getStringWidth("W") * clockText.scaleX
	local stringWidth = _G.res.getStringWidth(clockText.text) * clockText.scaleX
	
	
	clockText.x = topBarRight - clockTextOffset
	clockText.y = starLabel.y
	
	clockIcon.x = clockText.x - stringWidth - clockIconOffset
	clockIcon.y = starIcon.y
	
	
	
end

function NestView:nestReady()		
	local settingsButton = self:getChild("settingsButton")
	settingsButton.visible = false

	local clockIcon = self:getChild("clockIcon")
	clockIcon.visible = false
	local clockText = self:getChild("clockText")
	clockText.visible = false
	
	local nestFill = self:getChild("nestFill")
	nestFill.visible = false	
	
	local nestHurry = self:getChild("nestHurry")
	nestHurry.visible = false	
	
	local emptyEggText = self:getChild("emptyEggText")
	emptyEggText.visible = true	
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	emptyNestArrow.visible = self.tutorialsNeeded	
	
	local nestBack = self:getChild("nestBack")
	local nestFront = self:getChild("nestFront")
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.visible = false
		local acc2Button = self:getChild("acc2Button")
		acc2Button.visible = self.currentAccessory2 == nil
		local acc3Button = self:getChild("acc3Button")
		acc3Button.visible = self.currentAccessory3 == nil
	
		local acc1 = self:getChild("acc1")
		if self.currentAccessory1 then
			acc1:setImage(self.currentAccessory1:getSprite())
		end
		acc1.visible = self.currentAccessory1 ~= nil
		
		local acc2 = self:getChild("acc2")
		if self.currentAccessory2 then
			acc2:setImage(self.currentAccessory2:getSprite())
			if self.currentAccessory2:getType() == NestAccessory.TYPE.SLOT2_FAN then -- fan
				local acc2b = self:getChild("acc2b")
				acc2b:setImage(self.currentAccessory2:getAdditionalSprite())
				acc2b.visible = true
			end
		end
		acc2.visible = self.currentAccessory2 ~= nil
		
		local acc3 = self:getChild("acc3")
		if self.currentAccessory3 then
			acc3:setImage(self.currentAccessory3:getSprite())
		end
		acc3.visible = self.currentAccessory3 ~= nil
	end
	
	local placeEggButton = self:getChild("placeEggButton")
	placeEggButton.visible = true
	placeEggButton:setImage(nestBack.image)
	
end


function NestView:eggReady()	
	local settingsButton = self:getChild("settingsButton")
	settingsButton.visible = false
	
	local egg = self:getChild("egg")
	egg.returnValue = hatcheryEvents.EID_HATCHERY_HATCH_EGG 
	
	local clockIcon = self:getChild("clockIcon")
	clockIcon.visible = false
	local clockText = self:getChild("clockText")
	clockText.visible = false
	
	local nestFill = self:getChild("nestFill")
	nestFill.visible = false	
	
	local nestHurry = self:getChild("nestHurry")
	nestHurry.visible = false	
	
	local emptyEggText = self:getChild("emptyEggText")
	emptyEggText.visible = false

	local hatchEggText = self:getChild("hatchEggText")
	hatchEggText.visible = true
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	emptyNestArrow.visible = false			
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.visible = false
		local acc2Button = self:getChild("acc2Button")
		acc2Button.visible = false
		local acc3Button = self:getChild("acc3Button")
		acc3Button.visible = false
		
		local accessoryArrow2 = self:getChild("accessoryArrow2")
		accessoryArrow2.visible = false
		
		local accessoryArrow3 = self:getChild("accessoryArrow3")
		accessoryArrow3.visible = false
	end
	
	self.tutorialsNeeded = false
	self.clicksNeededForHatching = _G.math.random(3, 6)
	local rareRandom = _G.math.random()
	if rareRandom <= 0.2 then
		self.clicksNeededForHatching = 10
	end
	self.currentClickCount = 0
end



function NestView:setHatchery(hatchery)
	self.hatchery = hatchery
	
	-- local buyNest = NestSelectionDialog:new()
	-- buyNest.name = "buyNest"
	-- buyNest.visible = false
	-- buyNest:setNests(self.hatchery:getNests())
	-- buyNest:setEvents(hatcheryEvents.EID_HATCHERY_BUY_NEST_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_NEST_BUY)
	-- self:addChild(buyNest)
	
	self:setupCurrentStateBasedOnHatchery()
	
	-- self.hatchery:setStars(hatchery:getStars() + 1000)
	
	
end



function NestView:starCountUpdated()
	_G.res.playAudio(getHatcherySound("moneySpent"), 1, false)
	self:layout()
end

function NestView:openExitConfirm()
	self:closeCurrentPopUp()
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm:setText("Are you sure you want to leave the Hatchery?")
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_NO)	
	self:openPopUp(genericConfirm)
end

function NestView:openBuyMoreStarsConfirm()
	_G.res.playAudio(getHatcherySound("notEnoughMoney"), 1, false)
	self:closeCurrentPopUp()
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm:setText("You don't have enough stars, would you like to get some more?")
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_BUY_MORE_STARS_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_BUY_MORE_STARS_CONFIRMATION_NO)	
	self:openPopUp(genericConfirm)
end

function NestView:openDeleteBirdConfirm()
	-- _G.res.playAudio(getHatcherySound("notEnoughMoney"), 1, false)
	self:closeCurrentPopUp()
	local genericConfirm = self:getChild("genericConfirm")
	genericConfirm:setText("Start hatching a new bird?")
	genericConfirm:setEvents(hatcheryEvents.EID_HATCHERY_DELETE_BIRD_OK, hatcheryEvents.EID_HATCHERY_DELETE_BIRD_CANCEL)	
	self:openPopUp(genericConfirm)
end

function NestView:openSpeedNestConfirm(cost)
	local starSpendConfirm = self:getChild("starSpendConfirm")
	starSpendConfirm:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", "H_BTN_NO", "Are you sure you want to immediately build this nest?", "FONT_HATCHERY")
	starSpendConfirm.visible = true
	starSpendConfirm:setEvents(hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_NO)
	starSpendConfirm:setTotalStarCost(cost)
	self:openPopUp(starSpendConfirm)
end

function NestView:openSpeedEggConfirm(cost)
	local starSpendConfirm = self:getChild("starSpendConfirm")
	starSpendConfirm:setup("H_DIALOG_BG_MEDIUM_TEMP", "H_BTN_OK", "H_BTN_NO", "Are you sure you want to immediately hatch this egg?", "FONT_HATCHERY")
	starSpendConfirm.visible = true
	starSpendConfirm:setEvents(hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_YES, hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_NO)
	starSpendConfirm:setTotalStarCost(cost)
	self:openPopUp(starSpendConfirm)
end

function NestView:setupEmptyNest()
	local settingsButton = self:getChild("settingsButton")
	settingsButton.visible = false
	
	local clockIcon = self:getChild("clockIcon")
	clockIcon.visible = false
	local clockText = self:getChild("clockText")
	clockText.visible = false
	
	local emptyNestButton = self:getChild("emptyNestButton")
	emptyNestButton.visible = true		
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	emptyNestArrow.visible = self.tutorialsNeeded
	
	local emptyNestText = self:getChild("emptyNestText")
	emptyNestText.visible = true	
	
	local emptyEggText = self:getChild("emptyEggText")
	emptyEggText.visible = false	
	
	local hatchEggText = self:getChild("hatchEggText")
	hatchEggText.visible = false
	
	local placeEggButton = self:getChild("placeEggButton")
	placeEggButton.visible = false	
	
	local nestBack = self:getChild("nestBack")
	nestBack.visible = false	
	
	local bird = self:getChild("bird")
	bird.visible = false	
	
	local egg = self:getChild("egg")
	egg.visible = false	
	
	local eggCrack = self:getChild("eggCrack")
	eggCrack:setImage("")
	eggCrack.visible = false
	
	local eggCrackLeft = self:getChild("eggCrackLeft")
	eggCrackLeft:setImage("")
	eggCrackLeft.visible = false
	
	local eggCrackRight = self:getChild("eggCrackRight")
	eggCrackRight:setImage("")
	eggCrackRight.visible= false
	
	local nestFront = self:getChild("nestFront")
	nestFront.visible = false	
	
	local nestFill = self:getChild("nestFill")
	nestFill.visible = false	
	
	local nestHurry = self:getChild("nestHurry")
	nestHurry.visible = false	
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.visible = false
		local acc2Button = self:getChild("acc2Button")
		acc2Button.visible = false
		local acc3Button = self:getChild("acc3Button")
		acc3Button.visible = false
		
		local acc1 = self:getChild("acc1")
		acc1.visible = false
		local acc2 = self:getChild("acc2")
		acc2.visible = false
		local acc2b = self:getChild("acc2b")
		acc2b.visible = false
		local acc3 = self:getChild("acc3")
		acc3.visible = false
		
		local accessoryArrow2 = self:getChild("accessoryArrow2")
		accessoryArrow2.visible = false
		local accessoryArrow3 = self:getChild("accessoryArrow3")
		accessoryArrow3.visible = false
	end
end

function NestView:setupNest()

	local settingsButton = self:getChild("settingsButton")
	settingsButton.visible = false

	local clockIcon = self:getChild("clockIcon")
	clockIcon.visible = true
	local clockText = self:getChild("clockText")
	clockText.visible = true

	
	local nestBack = self:getChild("nestBack")
	nestBack:setImage(self.currentNest.sprites.bottom)
	nestBack.visible = true
	
	local nestFront = self:getChild("nestFront")
	nestFront:setImage(self.currentNest.sprites.top)
	nestFront.visible = true
	
	
	local egg = self:getChild("egg")
	egg:setImage("H_EGG_PAINTABLE_BASE")	
	egg.visible = false	
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	emptyNestArrow.visible = false	
	
	local emptyNestText = self:getChild("emptyNestText")
	emptyNestText.visible = false
	
	local hatchEggText = self:getChild("hatchEggText")
	hatchEggText.visible = false
	
	local emptyNestButton = self:getChild("emptyNestButton")
	emptyNestButton.visible = false
	
	local nestFill = self:getChild("nestFill")
	nestFill.visible = true
	
	local nestHurry = self:getChild("nestHurry")
	nestHurry.visible = true
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.visible = false
		local acc2Button = self:getChild("acc2Button")
		acc2Button.visible = false
		local acc3Button = self:getChild("acc3Button")
		acc3Button.visible = false
		
		local acc1 = self:getChild("acc1")
		acc1.visible = false
		local acc2 = self:getChild("acc2")
		acc2.visible = false
		local acc2b = self:getChild("acc2b")
		acc2b.visible = false
		local acc3 = self:getChild("acc3")
		acc3.visible = false
	end
	
end

function NestView:setupBird()

	local settingsButton = self:getChild("settingsButton")
	settingsButton.visible = true
	
	local clockIcon = self:getChild("clockIcon")
	clockIcon.visible = false
	local clockText = self:getChild("clockText")
	clockText.visible = false
	
	local egg = self:getChild("egg")
	egg.visible = false	
	
	local eggAccTop = self:getChild("eggAccTop")
	eggAccTop:setImage("")
	eggAccTop.visible = false
	
	local eggAccMiddle = self:getChild("eggAccMiddle")
	eggAccMiddle:setImage("")
	eggAccMiddle.visible = false
	
	local eggAccBottom = self:getChild("eggAccBottom")
	eggAccBottom:setImage("")
	eggAccBottom.visible = false
	
	local eggCrack = self:getChild("eggCrack")
	eggCrack:setImage("")
	eggCrack.visible = false
	
	local eggCrackLeft = self:getChild("eggCrackLeft")
	eggCrackLeft:setImage("")
	eggCrackLeft.visible = false
	
	local eggCrackRight = self:getChild("eggCrackRight")
	eggCrackRight:setImage("")
	eggCrackRight.visible= false
	
	local bird = self:getChild("bird")
	if self.currentBird ~= nil then
		bird:setImage(self.currentBird.sprite)
	end
	
	bird.visible = true	
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	emptyNestArrow.visible = false	
	
	local emptyNestText = self:getChild("emptyNestText")
	emptyNestText.visible = false	
	
	local emptyNestButton = self:getChild("emptyNestButton")
	emptyNestButton.visible = false
	
	local emptyEggText = self:getChild("emptyEggText")
	emptyEggText.visible = false	
	
	local hatchEggText = self:getChild("hatchEggText")
	hatchEggText.visible = false
	
	local nestFill = self:getChild("nestFill")
	nestFill.visible = false
	
	local nestHurry = self:getChild("nestHurry")
	nestHurry.visible = false
	
	local placeEggButton = self:getChild("placeEggButton")
	placeEggButton.visible = false
	
	
	
	local nestBack = self:getChild("nestBack")
	nestBack:setImage(self.currentNest.sprites.bottom)
	nestBack.visible = true
	
	local nestFront = self:getChild("nestFront")
	nestFront:setImage(self.currentNest.sprites.top)
	nestFront.visible = true
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.visible = false
		local acc2Button = self:getChild("acc2Button")
		acc2Button.visible = false
		local acc3Button = self:getChild("acc3Button")
		acc3Button.visible = false
		
		local acc1 = self:getChild("acc1")
		acc1.visible = self.currentAccessory1 ~= nil
		local acc2 = self:getChild("acc2")
		acc2.visible = self.currentAccessory2 ~= nil
		local acc2b = self:getChild("acc2b")
		if self.currentAccessory2 and self.currentAccessory2:getType() == NestAccessory.TYPE.SLOT2_FAN then
			acc2b.visible = true 
		else
			acc2b.visible = false
		end
		local acc3 = self:getChild("acc3")
		acc3.visible = self.currentAccessory3 ~= nil
	end
	
end


function NestView:setupEgg()	

	local settingsButton = self:getChild("settingsButton")
	settingsButton.visible = false

	local clockIcon = self:getChild("clockIcon")
	clockIcon.visible = true
	local clockText = self:getChild("clockText")
	clockText.visible = true
	
	local egg = self:getChild("egg")
	egg:setImage("H_EGG_PAINTABLE_BASE")	
	egg.visible = true	
	--egg.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_EGGACCESSORY_DIALOG
	egg.returnValue = hatcheryEvents.EID_HATCHERY_OPEN_EGGPAINTER
	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	emptyNestArrow.visible = self.tutorialsNeeded	
	
	local emptyNestText = self:getChild("emptyNestText")
	emptyNestText.visible = false
	
	local emptyNestButton = self:getChild("emptyNestButton")
	emptyNestButton.visible = false
	
	local emptyEggText = self:getChild("emptyEggText")
	emptyEggText.visible = false	
	
	local hatchEggText = self:getChild("hatchEggText")
	hatchEggText.visible = false
	
	local nestFill = self:getChild("nestFill")
	nestFill.visible = true
	
	local nestHurry = self:getChild("nestHurry")
	nestHurry.visible = true
	
	local placeEggButton = self:getChild("placeEggButton")
	placeEggButton.visible = false
	
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		acc1Button.visible = false
		local acc2Button = self:getChild("acc2Button")
		acc2Button.visible = self.currentAccessory2 == nil
		local acc3Button = self:getChild("acc3Button")
		acc3Button.visible = self.currentAccessory3 == nil
		
		local acc1 = self:getChild("acc1")
		if self.currentAccessory1 then
			acc1:setImage(self.currentAccessory1:getSprite())
		end
		acc1.visible = self.currentAccessory1 ~= nil
		
		local acc2 = self:getChild("acc2")
		if self.currentAccessory2 then
			acc2:setImage(self.currentAccessory2:getSprite())
			if self.currentAccessory2:getType() == NestAccessory.TYPE.SLOT2_FAN then -- fan
				local acc2b = self:getChild("acc2b")
				acc2b:setImage(self.currentAccessory2:getAdditionalSprite())
				acc2b.visible = true
			end
		end
		acc2.visible = self.currentAccessory2 ~= nil
		
		local acc3 = self:getChild("acc3")
		if self.currentAccessory3 then
			acc3:setImage(self.currentAccessory3:getSprite())
		end
		acc3.visible = self.currentAccessory3 ~= nil
		
		local accessoryArrow2 = self:getChild("accessoryArrow2")
		accessoryArrow2.visible = self.currentAccessory2 == nil and self.currentAccessory3 == nil and self.tutorialsNeeded
		
		local accessoryArrow3 = self:getChild("accessoryArrow3")
		accessoryArrow3.visible = self.currentAccessory2 == nil and self.currentAccessory3 == nil and self.tutorialsNeeded
	end
end

function NestView:openPopUp(popUpFrame)
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

function NestView:onExit()
	Frame.onExit(self)
	-- gamelua.print("\n Nest View exit \n")
end

function NestView:closeCurrentPopUp()
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

function NestView:onPointerEvent(eventType,x,y)

	local result,meta = nil, nil

	if self.currentVisiblePopUp then
		result,meta = self.currentVisiblePopUp:onPointerEvent(eventType,x, y)
	else
		result,meta = Frame.onPointerEvent(self, eventType,x, y)
	end



	
	
	if result == hatcheryEvents.EID_HATCHERY_EMPTY_NEST then
		if self.currentVisiblePopUp == nil then
			local buyNest = self:getChild("buyNest")
			self:openPopUp(buyNest)
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BACK_BUTTON then
		if self.currentVisiblePopUp == nil then
			self:openExitConfirm()
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARS then
		if self.currentVisiblePopUp == nil then
			local buyStars = self:getChild("buyStars")
			self:openPopUp(buyStars)
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARS_CANCEL then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_STARS_BUY then
		self:closeCurrentPopUp()
		
	elseif result == hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_YES then
		hatcheryEventManager:notify({id = hatcheryEvents.EID_HATCHERY_GOTO_EPISODE_SELECTION})
		self:closeCurrentPopUp()
		
	elseif result == hatcheryEvents.EID_HATCHERY_BACK_CONFIRMATION_NO then
		self:closeCurrentPopUp()
	
	elseif result == hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_YES then
		
		self:closeCurrentPopUp()
		
		if self.currentNest ~= nil then
			local egg = self.currentNest:getEgg()
			
			if egg ~= false then
				if self.hatchery:speedBuildEgg(self.currentNest) == true then
					
					self:starCountUpdated()
				else
					self:openBuyMoreStarsConfirm()
				end
			else
				if self.hatchery:speedBuildNest(self.currentNest) == true then
					
					self:starCountUpdated()
				else
					self:openBuyMoreStarsConfirm()
				end
			end
		end														
		
	elseif result == hatcheryEvents.EID_HATCHERY_SPEED_NEST_CONFIRMATION_NO then
		
		self:closeCurrentPopUp()
	
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_NEST_CANCEL then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_NEST_BUY then
		local buyNest = self:getChild("buyNest")
		local nestBought = buyNest:getClickedButtonNest()				
		
		if nestBought:getPrice() > self.hatchery:getStars() then
			self:openBuyMoreStarsConfirm()
			
		else
			
			local nestConstruction1 = self:getChild("nestConstruction1")
			local nestConstruction2 = self:getChild("nestConstruction2")
			local nestConstruction3 = self:getChild("nestConstruction3")
			nestConstruction1.visible = true
			nestConstruction2.visible = true
			nestConstruction3.visible = true
			
			self.hatchery:purchaseNest(nestBought)
			self.currentNest = self.hatchery.myNests[#self.hatchery.myNests]
			self:starCountUpdated()
			self:closeCurrentPopUp()
			self:setupCurrentStateBasedOnHatchery()
			_G.res.playAudio(getHatcherySound("nestAppears"), 1, false)
			_G.res.playAudio(getHatcherySound("buildingNestAmbient"), 1, true, 7)
		end
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_MORE_STARS_CONFIRMATION_YES then	
		self:closeCurrentPopUp()
		local buyStars = self:getChild("buyStars")
		self:openPopUp(buyStars)	
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_MORE_STARS_CONFIRMATION_NO then	
		self:closeCurrentPopUp()
		
	elseif result == hatcheryEvents.EID_HATCHERY_HURRY then	
	
		if self.currentNest ~= nil then
			local egg = self.currentNest:getEgg()
			
			if egg ~= false then
				self:openSpeedEggConfirm(egg:getPriceToSpeedBuild())
			else
				self:openSpeedNestConfirm(self.currentNest:getPriceToSpeedBuild())
			end
		end
		
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_EGGS_PANEL then	
		if self.currentVisiblePopUp == nil then
			local buyEgg = self:getChild("buyEgg")
			self:openPopUp(buyEgg)
		end
		
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_EGG_CANCEL then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_BUY_EGG_BUY then
		local buyEgg = self:getChild("buyEgg")
		local eggBought = buyEgg:getClickedButtonEgg()
		
		if self.hatchery:purchaseEggToNest(self.currentNest, eggBought) ~= false then
			self:setupCurrentStateBasedOnHatchery()
			self:starCountUpdated()
			self:closeCurrentPopUp()
			_G.res.playAudio(getHatcherySound("eggAppears"), 1, false)
			_G.res.playAudio(getHatcherySound("buildingEggAmbient"), 1, true, 7)
		else
			self:openBuyMoreStarsConfirm()
		end
		
	elseif result == hatcheryEvents.EID_HATCHERY_HATCH_EGG  then
		
		if self.currentNest ~= nil then
			self.clicksNeededForHatching = self.clicksNeededForHatching - 1
			self.currentClickCount = self.currentClickCount + 1
			if self.clicksNeededForHatching <= 0 then

				local previousRank = self.hatchery:getPlayerRank()
				
				--TODO, we need a better way to put the gender into the data structs
				local eggAccDialog = self:getChild("eggAccDialog")
				local gender = eggAccDialog:getCurrentGender()
				
				-- local bird, foundNew = self.hatchery:hatchEgg(self.currentNest, self.currentClickCount)
				
				local genderIndex = 0
				if gender ~= "male" then
					genderIndex = 1
				end
				
				local egg = self.currentNest:getEgg()
				local accessories = egg:getAccessories()
				
				
				
				-- local bird, foundNew = self.hatchery:hatchEgg(self.currentNest, genderIndex, self.currentClickCount > 6)
				
				local colors = {"RED", "BLUE", "YELLOW", "BLACK",  "WHITE", "GREEN", "BIGBROTHER", "ORANGE"}
				
				local primaryColor, secondaryColor = gamelua.getDominantCanvasColors()
				
				local bodyIndex = 1
				local bodyColor = 1
				
				if primaryColor ~= "" then									
					if secondaryColor == "" then
						bodyIndex = self:getIndexInTable(colors, primaryColor) - 1
						bodyColor = bodyIndex
					else
						bodyIndex = self:getIndexInTable(colors, primaryColor) - 1
						bodyColor = self:getIndexInTable(colors, secondaryColor) - 1
					end
				end				
				
				local bird, foundNew = self.hatchery:hatchEgg(self.currentNest, genderIndex, false, bodyIndex, bodyColor)
				
				
				
				-- local bird, foundNew = self.hatchery:hatchEgg(self.currentNest, genderIndex, false)
				if bird then
					self.currentBird = bird
					
					_G.res.playAudio(getHatcherySound("eggHatched"), 1, false)
					self:setupCurrentStateBasedOnHatchery()
					self.particles:startHatchParticles()
					self:setBirdVisibility(false)
					local birdButton = self:getChild("bird")
					birdButton.visible = false
					local nestBack = self:getChild("nestBack")
					local _, sh = _G.res.getSpriteBounds(self.currentBird.sprite)
					birdButton.y = nestBack.y - 120 * (sh / 280)
					
					local hatchedDialog = self:getChild("hatchedDialog")
					hatchedDialog:setNestView(self)
					
					self:openPopUp(hatchedDialog)
					
					
					
					
					if foundNew then
						--self.notificationCounter = self.notificationCounter + 1
						--local matrixNotificationText = self:getChild("matrixNotificationText")
						--matrixNotificationText.text = "" .. self.notificationCounter
						--matrixNotificationText.visible = true
						
						--local matrixNotificationIcon = self:getChild("matrixNotificationIcon")
						--matrixNotificationIcon.visible = true
					end
					
					--MOVED this to task completed
					-- local currentRank = self.hatchery:getPlayerRank()
					-- if currentRank > previousRank then
						-- local playerRankDescription = self:getChild("playerRankDescription")
						-- playerRankDescription.text = self.protoRankTexts[self.hatchery:getPlayerRank()]
						
						-- local playerRankText = self:getChild("playerRankText")
						-- playerRankText.text = "Level " .. self.hatchery:getPlayerRank()
						-- self.particles:startLevelUpParticles()
					-- end
					
					-- getTaskManagerInstance():markTaskAsCompleted(TaskManager.TaskManager.TASKS.HATCH_FIRST_BIRD)
					
					
					
					
					
					--TODO, fix this, then gender and accessories should be know to the bird
					getTaskManagerInstance():increaseHatchBirdTaskCounter(bird:getShape(), bird:getId(), gender, accessories)
				end
			else
				
				_G.res.playAudio(getHatcherySound("eggCracking"), 1, false)
				local eggCrack = self:getChild("eggCrack")
				eggCrack:setImage("H_EGG_CRACK_TOP_" .. self.currentClickCount)
				eggCrack.visible = true
				
				local eggCrackLeft = self:getChild("eggCrackLeft")
				eggCrackLeft:setImage("H_EGG_CRACK_LEFT_" .. self.currentClickCount)
				eggCrackLeft.visible = true
				
				local eggCrackRight = self:getChild("eggCrackRight")
				eggCrackRight:setImage("H_EGG_CRACK_RIGHT_" .. self.currentClickCount)
				eggCrackRight.visible= true
				
			end
		end
		
		
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_MATRIX then
		self.notificationCounter = 0
		--local matrixNotificationText = self:getChild("matrixNotificationText")
		--matrixNotificationText.visible = false

		--local matrixNotificationIcon = self:getChild("matrixNotificationIcon")
	--	matrixNotificationIcon.visible = false
		
		hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "MATRIX_VIEW", from = "NEST_VIEW"})
		
	elseif result == hatcheryEvents.EID_HATCHERY_MATRIX_CANCEL then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_STATCARD then
		local birdMatrix = self:getChild("birdMatrix")
		self:closeCurrentPopUp()
		local statCard = self:getChild("statCard")
		statCard:prepareForBird(birdMatrix:getLastClickedBird())
		self:openPopUp(statCard)
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_STATCARD then
		self:closeCurrentPopUp()
		local birdMatrix = self:getChild("birdMatrix")
		self:openPopUp(birdMatrix)
		
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_EGGPAINTER then
		local eggPainter = self:getChild("eggPainter")
		self:openPopUp(eggPainter)
		local emptyNestArrow = self:getChild("emptyNestArrow")
		emptyNestArrow.visible = false
		_G.res.stopAudio(getHatcherySound("buildingNestAmbient"))
		_G.res.stopAudio(getHatcherySound("buildingEggAmbient"))
		
	
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_EGGPAINTER then
		self:closeCurrentPopUp()
	
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_HATCHEDDIALOG then
			
			
			
			--opens notifications that might have arrived while this screen was open
			if self.allTasksCompletedLastTask ~= nil then
				gamelua.print("\n opening task")
				self:closeCurrentPopUp()
				self:openTasksDialog(true, self.allTasksCompletedLastTask)
				self.allTasksCompletedLastTask = nil
			elseif self.taskNotificationToShow ~= nil then
				self.currentNotificationText = self.taskNotificationToShow.text
				self.notificationDelay = 0
				self.taskNotificationToShow = nil
			end
	elseif result == hatcheryEvents.EID_HATCHERY_BIRD_CLICKED then
	
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_EGGACCESSORY_DIALOG then
		local eggAccDialog = self:getChild("eggAccDialog")
		self:openPopUp(eggAccDialog)
		self.tutorialsNeeded = false
		local emptyNestArrow = self:getChild("emptyNestArrow")
		emptyNestArrow.visible = false
	elseif result == hatcheryEvents.EID_HATCHERY_CLOSE_EGGACCESSORY_DIALOG then
		self:closeCurrentPopUp()
		self:setEggAccessorySprites()
		
	elseif result == hatcheryEvents.EID_HATCHERY_DELETE_BIRD_OK then
		self:closeCurrentPopUp()
		self:resetNest()
	elseif result == hatcheryEvents.EID_HATCHERY_DELETE_BIRD_CANCEL then
		self:closeCurrentPopUp()
	elseif result == hatcheryEvents.EID_HATCHERY_ACCESSORIES then
		self:openDeleteBirdConfirm()
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_OPEN_ACCESSORY1_DIALOG then
		local accDialog = self:getChild("accDialog1")
		self:openPopUp(accDialog)
		
		
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_OPEN_ACCESSORY2_DIALOG then
		local accDialog = self:getChild("accDialog2")
		self:openPopUp(accDialog)
		
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_OPEN_ACCESSORY3_DIALOG then
		local accDialog = self:getChild("accDialog3")
		self:openPopUp(accDialog)
		
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG then
		self:closeCurrentPopUp()
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_ACCESSORY1_BUY then
		
		local accDialog1 = self:getChild("accDialog1")
		local accBought = accDialog1:getClickedAccessory()
		
		if self.hatchery:purchaseNestAccessory(self.currentNest, accBought) ~= false then
			self.currentAccessory1 = accBought
			self:setupCurrentStateBasedOnHatchery()
			self:starCountUpdated()
			self:closeCurrentPopUp()
			_G.res.playAudio(getHatcherySound("moneySpent"), 1, false)
		else
			self:openBuyMoreStarsConfirm()
		end
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_ACCESSORY2_BUY then
		
		local accDialog2 = self:getChild("accDialog2")
		local accBought = accDialog2:getClickedAccessory()
		
		if self.hatchery:purchaseNestAccessory(self.currentNest, accBought) ~= false then
			
			local accessoryArrow2 = self:getChild("accessoryArrow2")
			accessoryArrow2.visible = false
			local accessoryArrow3 = self:getChild("accessoryArrow3")
			accessoryArrow3.visible = false
		
			self.currentAccessory2 = accBought
			self:setupCurrentStateBasedOnHatchery()
			self:starCountUpdated()
			self:closeCurrentPopUp()
			_G.res.playAudio(getHatcherySound("moneySpent"), 1, false)
		else
			self:openBuyMoreStarsConfirm()
		end	
	elseif hatchery.useNestAccessories and result == hatcheryEvents.EID_HATCHERY_ACCESSORY3_BUY then
		
		local accDialog3 = self:getChild("accDialog3")
		local accBought = accDialog3:getClickedAccessory()
		
		if self.hatchery:purchaseNestAccessory(self.currentNest, accBought) ~= false then
			local accessoryArrow2 = self:getChild("accessoryArrow2")
			accessoryArrow2.visible = false
			local accessoryArrow3 = self:getChild("accessoryArrow3")
			accessoryArrow3.visible = false
			
			self.currentAccessory3 = accBought
			self:setupCurrentStateBasedOnHatchery()
			self:starCountUpdated()
			self:closeCurrentPopUp()
			_G.res.playAudio(getHatcherySound("moneySpent"), 1, false)
		else
			self:openBuyMoreStarsConfirm()
		end		
	elseif result == hatcheryEvents.EID_HATCHERY_TASKS_SCREEN_CANCEL then
		self:closeCurrentPopUp()
	

	
		--start animations
	elseif result == hatcheryEvents.EID_HATCHERY_OPEN_TASKS_SCREEN then
		self:openTasksDialog(false)
		
	end
	
	
	return result, meta
end

function NestView:update(dt, time) 

	local testFrame = self:getChild("testFrame")
	local genericConfirm = self:getChild("genericConfirm")
	local tasksScreen = self:getChild("tasksScreen")
	
	testFrame = tasksScreen
	local increase = 0.03
	
	
	if self.interactive == true then
		if gamelua.keyPressed["B"] then		
			-- testFrame.visible = not testFrame.visible
			self:openTasksDialog(false)
		elseif gamelua.keyPressed["LEFT"] then
			testFrame.scaleX = testFrame.scaleX + increase
			testFrame.scaleY = testFrame.scaleY + increase
		elseif gamelua.keyPressed["RIGHT"] then
			testFrame.scaleX = testFrame.scaleX - increase
			testFrame.scaleY = testFrame.scaleY - increase
		end
		
		if gamelua.keyPressed["X"] then
			getTaskManagerInstance():cheatCompleteAllTasks()
		end
		
		if gamelua.keyPressed["C"] then
			getTaskManagerInstance():cheatCompleteNextAvailableTask()
		end

		if self.currentVisiblePopUp then
			local maxShade = self.currentVisiblePopUp.shading or 0.3
			self.popUpAlpha = self.popUpAlpha and _G.math.min(self.popUpAlpha + dt * 5, maxShade)
		end
		
		if self.currentBird ~= nil then
			self:animateBird(dt,time)
		end
	end
	
		self:animateEgg(dt, time)

		self:animateBackgroundElements(dt, time)

	if self.interactive == true then
		if self.tutorialsNeeded then
			local emptyNestArrow = self:getChild("emptyNestArrow")
			if emptyNestArrow.visible == true then
				self:animateArrow(dt, time, emptyNestArrow)
			end
			if hatchery.useNestAccessories then
				local accessoryArrow2 = self:getChild("accessoryArrow2")
				if accessoryArrow2.visible == true then
					self:animateArrow(dt, time, accessoryArrow2)
				end
				local accessoryArrow3 = self:getChild("accessoryArrow3")
				if accessoryArrow3.visible == true then
					self:animateArrow(dt, time, accessoryArrow3)
				end
			end
		end
	
		ui.Frame.update(self, dt, time) 
		local nestFill = self:getChild("nestFill")
		
		-- local currentNest = self.hatchery.myNests[1]
		
		if self.currentNest ~= nil then
			if self.currentNest:isCompleted() and self.currentNest.completionNotified == nil then
				self.currentNest.completionNotified = true
				_G.res.stopAudio(getHatcherySound("buildingNestAmbient"))
				_G.res.playAudio(getHatcherySound("nestFinished"), 1, false)
				self:setupCurrentStateBasedOnHatchery()
				self.particles:startNestReadyParticles()
				
				local nestConstruction1 = self:getChild("nestConstruction1")
				local nestConstruction2 = self:getChild("nestConstruction2")
				local nestConstruction3 = self:getChild("nestConstruction3")
				nestConstruction1.visible = false
				nestConstruction2.visible = false
				nestConstruction3.visible = false
				
			elseif not self.currentNest:isCompleted() then
				if self.currentNest.buildingNotified == nil then
					self.currentNest.buildingNotified = true
					self.particles:startNestBuildingParticles()
				end
				self:setClockString(self.currentNest:getTotalBuildTime() - self.currentNest:getElapsedBuildTime())
				nestFill:setPercentage(self.currentNest:getElapsedBuildTime() / self.currentNest:getTotalBuildTime())
			end
			
			local currentEgg = self.currentNest:getEgg()
			
			if currentEgg ~= false then
				if self.currentNest:canHatchEgg() and currentEgg.completionNotified == nil then
					currentEgg.completionNotified = true
					_G.res.stopAudio(getHatcherySound("buildingEggAmbient"))
					_G.res.playAudio(getHatcherySound("eggFinished"), 1, false)
					self:setupCurrentStateBasedOnHatchery()
					-- self:startEggReadyParticles()
					--this is to make sure that the first animation is played
					self.eggHasJustComplete = true
				elseif self.currentNest:canHatchEgg() ~= true then
					if currentEgg.buildingNotified == nil then
						currentEgg.buildingNotified = true
						self.particles:startEggBuildingParticles()
					end
					local elapsedTime = currentEgg.completeTimer - currentEgg.timer
					self:setClockString(currentEgg.completeTimer - elapsedTime)
					nestFill:setPercentage(elapsedTime / currentEgg.completeTimer)
				end
			end
			
			if hatchery.useNestAccessories and self.currentAccessory2 then
				-- animate fan
				if self.currentAccessory2:getType() == NestAccessory.TYPE.SLOT2_FAN then
					local acc2b = self:getChild("acc2b")
					acc2b.angle = acc2b.angle and acc2b.angle - dt or 0
					acc2b.angle = _G.math.mod(acc2b.angle, _G.math.pi * 2)
				end
			end
			
		end		
		
		if gamelua.keyPressed["RBUTTON"] then
			local debugPosText = self:getChild("debugPosText")
			-- self:layout()
			
			if self.debugging == true then
				local closestDistance = 10000000
				for k, v in _G.pairs(self.selectableItems) do
				
					local itemX, itemY = v.x, v.y
					if self.currentVisiblePopUp ~= nil then
						itemX = self.currentVisiblePopUp.x + v.x
						itemY = self.currentVisiblePopUp.y + v.y
					end
					
					local distanceVectorX = gamelua.cursor.x - itemX
					local distanceVectorY = gamelua.cursor.y - itemY
					
					local squaredDistance = (distanceVectorX * distanceVectorX) + (distanceVectorY * distanceVectorY)
					
					if squaredDistance < closestDistance and v.visible == true then
						closestDistance = squaredDistance
						self.selectedItem = v
					end
				end
				
				
			end
		end
		
		if gamelua.keyPressed["D"] then
			self:setupSelectableItems()
			local debugPosText = self:getChild("debugPosText")
			
			if self.debugging == nil then
				self.debugging = true
				debugPosText.visible = true
				self:layout()
			else
				self.debugging = nil
				debugPosText.visible = false
				
				self:setupCurrentStateBasedOnHatchery()
			end
		end
		
		local slowOffset = 1
		local fastOffset = 2
		
		if gamelua.keyPressed["V"] and self.debugging ~= nil and self.selectedItem ~= nil then
			
			self.selectedItem.visible = not self.selectedItem
		end
		
		if gamelua.keyPressed["LEFT"] and self.debugging ~= nil and self.selectedItem ~= nil then
			local offset = slowOffset
			if gamelua.keyHold["SHIFT"] then
				offset = fastOffset
			end
			self.selectedItem.x = self.selectedItem.x - offset
		end
		
		if gamelua.keyPressed["RIGHT"] and self.debugging ~= nil and self.selectedItem ~= nil then
			local offset = slowOffset
			if gamelua.keyHold["SHIFT"] then
				offset = fastOffset
			end
			self.selectedItem.x = self.selectedItem.x + offset
		end
		
		if gamelua.keyPressed["UP"] and self.debugging ~= nil and self.selectedItem ~= nil then
			local offset = slowOffset
			if gamelua.keyHold["SHIFT"] then
				offset = fastOffset
			end
			self.selectedItem.y = self.selectedItem.y - offset
		end
		
		if gamelua.keyPressed["DOWN"] and self.debugging ~= nil and self.selectedItem ~= nil then
			local offset = slowOffset
			if gamelua.keyHold["SHIFT"] then
				offset = fastOffset
			end
			self.selectedItem.y = self.selectedItem.y + offset
		end
		
	end
	
	
	if self.particles ~= nil then
		self.particles:update(dt, time)
	end
	
	self:updateNotification(dt, time) 
	
	self:saveState()
	
end

function NestView:loadSaveState()
	if gamelua.settings.hatcheryLocalTime == nil then
		return
	end
	
	if gamelua.g_hatcheryTimeBackwardsDetected == true or gamelua.g_hatcheryTimeForwardDetected  == true then
		return
	end

		
	
	if self.currentNest == nil then
	
		if gamelua.settings.hatcheryState ~= nil and gamelua.settings.hatcheryState.currentNest ~= nil then			
			
			self.hatchery:addNest(self.hatchery:getNestTemplateByType(gamelua.settings.hatcheryState.currentNest.type))						
			self.currentNest = self.hatchery.myNests[#self.hatchery.myNests]
			self.currentNest.completed = gamelua.settings.hatcheryState.currentNest.isCompleted 
			self.currentNest.timer = gamelua.settings.hatcheryState.currentNest.timer 
			self.currentNest.hatchery = self.hatchery
			self.currentNest.completionNotified = gamelua.settings.hatcheryState.currentNest.completionNotified
			self.currentNest.buildingNotified = true
			
			if self.currentNest.completed ~= true then
				local nestConstruction1 = self:getChild("nestConstruction1")
				local nestConstruction2 = self:getChild("nestConstruction2")
				local nestConstruction3 = self:getChild("nestConstruction3")
				nestConstruction1.visible = true
				nestConstruction2.visible = true
				nestConstruction3.visible = true
			else
				self:setupNest()				
				
				if gamelua.settings.hatcheryState.currentNest.currentEgg ~= nil then
					local eggBought = self.hatchery:getEggTemplateByType(gamelua.settings.hatcheryState.currentNest.currentEgg.type)
					
					if self.hatchery:addEggToNest(self.currentNest, eggBought) ~= false then
						local currentEgg = self.currentNest:getEgg()
						currentEgg.completed = gamelua.settings.hatcheryState.currentNest.currentEgg.isCompleted
						currentEgg.timer = gamelua.settings.hatcheryState.currentNest.currentEgg.timer	
						currentEgg.completionNotified = gamelua.settings.hatcheryState.currentNest.currentEgg.completionNotified
						currentEgg.buildingNotified = true
					end
					
					self:setupEgg()
				end
			end							
			
			if gamelua.settings.hatcheryState.currentBird ~= nil then								
				
				local bird = self.hatchery:hatchEggFromID(self.currentNest, gamelua.settings.hatcheryState.currentBird)				
				
				self.currentBird = bird
				
				self:setBirdVisibility(false)
				local birdButton = self:getChild("bird")
				birdButton.visible = false
				local nestBack = self:getChild("nestBack")
				local _, sh = _G.res.getSpriteBounds(self.currentBird.sprite)
				birdButton.y = nestBack.y - 120 * (sh / 280)								
				
			end
			
			self:setupCurrentStateBasedOnHatchery()
			
		else
			self:setupEmptyNest()
		end
	end
	
	if self.currentNest ~= nil then
		if self.currentNest:isCompleted() == true then
			local currentEgg = self.currentNest:getEgg()
			
			if currentEgg ~= false then
				if currentEgg:isCompleted() == true then
					-- self:eggReady()
				else
					self:updateSavedItem(currentEgg)
				end
			else
				-- self:nestReady()
			end
			
		else
			self:updateSavedItem(self.currentNest)
		end		
	end
end

--there is no safety check in this method, those are done in loadSaveState
function NestView:updateSavedItem(item)
	local currentTime = gamelua.getCurrentTime()
	
	local difference = gamelua.getTimeDifference(currentTime, gamelua.settings.hatcheryLocalTime)		
	
	--if we just multiply the days by seconds, it can get really high values which might not fit into the number type
	for i = 0, difference.days -1 do		
		item:update(86400)
	end
	
	
	item:update(difference.minutes * 60)
	item:update(difference.seconds)
	
end

function NestView:saveState()	
	gamelua.settingsWrapper:setHatcheryLocalTime(gamelua.getCurrentTime())
	
	if self.hatchery == nil then
		return
	end		
	
	local savedState = {}
		
	-- local currentNest = self.hatchery.myNests[1]
	-- local currentBird = self.hatchery.myBirds[1]
	
	if self.currentBird ~= nil then		
		savedState.currentBird = self.currentBird.id
	end
	
	if self.currentNest ~= nil then
		savedState.currentNest = {}
		savedState.currentNest.isCompleted = self.currentNest:isCompleted()
		savedState.currentNest.type = self.currentNest.type
		savedState.currentNest.completionNotified = self.currentNest.completionNotified
		
		
		
		if self.currentNest:isCompleted() == true then
			
			local currentEgg = self.currentNest:getEgg()
			
			if currentEgg ~= false then
				-- for k, v in _G.pairs(currentEgg) do
					-- gamelua.print("\n key is " .. k)
				-- end
				
				-- gfd()
				savedState.currentNest.currentEgg = {}
				savedState.currentNest.currentEgg.isCompleted = currentEgg:isCompleted()
				savedState.currentNest.currentEgg.type = currentEgg.type
				savedState.currentNest.currentEgg.completionNotified = currentEgg.completionNotified
				
				if currentEgg:isCompleted() == true then
					
				else
					savedState.currentNest.currentEgg.timer = currentEgg.timer
				end
			else
				savedState.currentNest.currentEgg = nil
			end
			
		else
			savedState.currentNest.timer = self.currentNest.timer
			
		end			
	
	else
		
		savedState.currentNest = nil
	end
	
	gamelua.settingsWrapper:setHatcheryState(savedState)
end


function NestView:roundNumber(number)
	return _G.math.floor(number + 0.5)
end


function NestView:onEntry()
	-- gamelua.print("\n Nest View entry \n")
	getTaskManagerInstance():addListener(self)
	
	self:loadSaveState()
	
	local tasksScreen = self:getChild("tasksScreen")
	tasksScreen:setTasks(getTaskManagerInstance():getCurrentTaskList())
	tasksScreen:setReward(getTaskManagerInstance():getCurrentTaskReward())
	tasksScreen:setUnlockable(getTaskManagerInstance():getCurrentUnlockable())
	
	self:setupCurrentStateBasedOnHatchery()
	
	local starLabel = self:getChild("starLabel")
	if starLabel ~= nil then
		starLabel.text = "" .. self.hatchery:getStars()
	end
	
	for i = 3, 7 do 
		local elements = self.bgElements["layer" ..i].elements
		for j = 1, #elements do
			local element = elements[j]
			if element.angle ~= nil then
				element.angle = 0
			end
			if element.startSpeed ~= nil then
				element.speed = element.startSpeed
			end
		end
	end
	
	self:layout()
end

function NestView:setupCurrentStateBasedOnHatchery()
	if self.hatchery == nil then
		return
	end

		
	-- local currentNest = self.hatchery.myNests[1]
	-- local currentBird = self.hatchery.myBirds[1]
	
	if self.currentNest ~= nil then
		
		if self.currentNest:isCompleted() == true then
			local currentEgg = self.currentNest:getEgg()
			
			if currentEgg ~= false then
				if currentEgg:isCompleted() == true then
					self:eggReady()
				else
					self:setupEgg()
				end
			else
				self:nestReady()
			end
			
		else
			self:setupNest()
		end			
	
	else
		
		self:setupEmptyNest()
	end
	
	--TODO, check, if its possible to have a nest without a bird
	if self.currentBird ~= nil then
		self:setupBird()
	end
end

function NestView:setupDrawingOrderTables()
	local worldItems = {}
	local hudItems = {}
	
	local emptyNestButton = self:getChild("emptyNestButton")
	if hatchery.useNestAccessories then
		local acc1Button = self:getChild("acc1Button")
		local acc2Button = self:getChild("acc2Button")
		local acc3Button = self:getChild("acc3Button")
		local acc1 = self:getChild("acc1")
		local acc2 = self:getChild("acc2")
		local acc2b = self:getChild("acc2b")
		local acc3 = self:getChild("acc3")
	end
	local backButton = self:getChild("backButton")
	local topBar = self:getChild("topBar")
	local starIcon = self:getChild("starIcon")
	local starLabel = self:getChild("starLabel")
	local starBuyButton = self:getChild("starBuyButton")
	local playerRankDescription = self:getChild("playerRankDescription")
	local playerRankText = self:getChild("playerRankText")
	local clockIcon = self:getChild("clockIcon")
	local clockText = self:getChild("clockText")
	local placeEggButton = self:getChild("placeEggButton")
	local nestConstruction3 = self:getChild("nestConstruction3")
	local nestBack = self:getChild("nestBack")
	local bird = self:getChild("bird")
	local egg = self:getChild("egg")
	local nestFront = self:getChild("nestFront")
	local nestConstruction1 = self:getChild("nestConstruction1")
	local nestConstruction2 = self:getChild("nestConstruction2")	
	local nestFill = self:getChild("nestFill")
	local nestHurry = self:getChild("nestHurry")
	local matrix = self:getChild("matrix")
	--local matrixNotificationIcon = self:getChild("matrixNotificationIcon")
	--local matrixNotificationText = self:getChild("matrixNotificationText")	
	local emptyNestArrow = self:getChild("emptyNestArrow")
	local emptyNestText = self:getChild("emptyNestText")
	local emptyEggText = self:getChild("emptyEggText")
	local settingsButton = self:getChild("settingsButton")
	--POP UPS	
	local genericConfirm = self:getChild("genericConfirm")
	local starSpendConfirm = self:getChild("starSpendConfirm")
	local buyStars = self:getChild("buyStars")
	local buyNest = self:getChild("buyNest")
	local buyEgg = self:getChild("buyEgg")
	local birdMatrix = self:getChild("birdMatrix")
	local statCard = self:getChild("statCard")
	
	_G.table.insert(worldItems, emptyNestButton)
	_G.table.insert(worldItems, placeEggButton)
	_G.table.insert(worldItems, nestConstruction3)
	_G.table.insert(worldItems, nestBack)
	_G.table.insert(worldItems, bird)
	_G.table.insert(worldItems, egg)
	_G.table.insert(worldItems, nestFront)
	_G.table.insert(worldItems, nestConstruction1)
	_G.table.insert(worldItems, nestConstruction2)		
	if hatchery.useNestAccessories then
		_G.table.insert(worldItems, acc1Button)
		_G.table.insert(worldItems, acc2Button)
		_G.table.insert(worldItems, acc3Button)
		_G.table.insert(worldItems, acc1)
		_G.table.insert(worldItems, acc2)
		_G.table.insert(worldItems, acc2b)
		_G.table.insert(worldItems, acc3)
	end
		
	-- _G.table.insert(hudItems, backButton)
	-- _G.table.insert(hudItems, topBar)
	-- _G.table.insert(hudItems, starIcon)
	-- _G.table.insert(hudItems, starLabel)
	-- _G.table.insert(hudItems, starBuyButton)
	-- _G.table.insert(hudItems, playerRankDescription)
	-- _G.table.insert(hudItems, playerRankText)
	-- _G.table.insert(hudItems, clockIcon)
	-- _G.table.insert(hudItems, clockText)
	-- _G.table.insert(hudItems, nestFill)
	-- _G.table.insert(hudItems, nestHurry)
	-- _G.table.insert(hudItems, matrix)
	-- _G.table.insert(hudItems, matrixNotificationIcon)
	-- _G.table.insert(hudItems, matrixNotificationText)
	-- _G.table.insert(hudItems, emptyNestArrow )
	-- _G.table.insert(hudItems, emptyNestText )
	-- _G.table.insert(hudItems, emptyEggText)
	-- _G.table.insert(hudItems, settingsButton)
	-- pop ups
	
	-- _G.table.insert(hudItems, genericConfirm)
	-- _G.table.insert(hudItems, starSpendConfirm)
	-- _G.table.insert(hudItems, buyStars)
	-- _G.table.insert(hudItems, buyNest)
	-- _G.table.insert(hudItems, buyEgg)
	-- _G.table.insert(hudItems, birdMatrix)
	-- _G.table.insert(hudItems, statCard)
	
	self.worldItemsReal = {}
	self.hudItemsReal = {}
	self.topBarHud = {}
	
	for k,v in _G.pairs(self.children) do
		if self:getIndexInTable(worldItems, v) > 0 then
			_G.table.insert(self.worldItemsReal, v)
		else
			_G.table.insert(self.hudItemsReal, v)
		end
	end
	
	--we need to separate topbar so we can easily draw it without other hud components
	_G.table.insert(self.topBarHud, topBar)
	_G.table.insert(self.topBarHud, starIcon)
	_G.table.insert(self.topBarHud, starLabel)
	_G.table.insert(self.topBarHud, starBuyButton)
	_G.table.insert(self.topBarHud, playerRankDescription)
	_G.table.insert(self.topBarHud, playerRankText)
	-- for k, v in _G.pairs(self.worldItemsReal) do 
		-- gamelua.print("\n world Items " .. v.name)
	-- end
	
	-- for k, v in _G.pairs(self.hudItemsReal) do 
		-- gamelua.print("\n hud Items " .. v.name)
	-- end
	
	-- gamelua.print(nil)
	
	
end

function NestView:getTopBar()
	return self.topBarHud
end

function NestView:getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

function NestView:drawMenuNestView(x,y,scaleX, scaleY)

	self:drawBackground()
	
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	
	-- ui.Frame.draw(self, x, y)
	
	for k, v in _G.pairs(self.worldItemsReal) do
		if v.visible ~= false then	
			if v.name == "bird" and v.visible ~= false then
				local nest = self:getChild("nestBack")
				local w,h = _G.res.getSpriteBounds(v.image)
				local offsetY = (h - (h*scaleY))*0.5
				self:drawBird(v,x,y+ offsetY,scaleY)
			elseif v.name == "egg" and v.visible ~=false then
					local painter = self:getChild("eggPainter")
					local canvas = painter:getEggCanvas()
					local w1, h1 = canvas:getCanvasBounds()
					local w2, h2 = _G.res.getSpriteBounds(v.image)
					local finalScaleX, finalScaleY = (w2/w1) * scaleX,  (h2/h1) * scaleY
					self:drawEgg(v.x + x, v.y + y ,finalScaleX,finalScaleY,v.angle)
			else
				v:draw( x,y, scaleX, scaleY)
			end
		end	
	end
end

function NestView:draw(x, y)
	_G.res.setClipRect(0, 0, gamelua.screenWidth, gamelua.screenHeight)
	self:drawBackground()
	
	-- ui.Frame.draw(self, x, y)
	
	for k, v in _G.pairs(self.worldItemsReal) do
		if v.visible ~= false then
			
			if v.name == "bird" and v.visible ~= false then
				self:drawBird(v)
			elseif v.name == "egg" and v.visible ~=false then
					local painter = self:getChild("eggPainter")
					local canvas = painter:getEggCanvas()
					local w1, h1 = canvas:getCanvasBounds()
					local w2, h2 = _G.res.getSpriteBounds(v.image)
					self:drawEgg(v.x, v.y ,v.scaleX * (w2/w1),v.scaleY * (h2/h1),v.angle)
					--v:draw(x,y)
			else
				v:draw(x,y)
			end
			
		end
	end
	
	if self.debugging == true and self.selectedItem ~= nil then
		local w = 10
		local h = 10
		local pivotX = 0
		local pivotY = 0
		
		if self.selectedItem.image ~= nil then
			w, h = _G.res.getSpriteBounds("", self.selectedItem.image)
			pivotX, pivotY = _G.res.getSpritePivot("", self.selectedItem.image)
		end
		
		
		local debugPosText = self:getChild("debugPosText")
		debugPosText.text = "x: " .. self.selectedItem.x .. " y: " .. self.selectedItem.y
	
		local itemX = self.selectedItem.x
		local itemY = self.selectedItem.y
		if self.currentVisiblePopUp ~= nil then
			itemX = self.currentVisiblePopUp.x + itemX
			itemY = self.currentVisiblePopUp.y + itemY
			
		end
		gamelua.drawRect(1, 0, 0, 0.5, itemX - pivotX, itemY - pivotY, itemX - pivotX +w, itemY - pivotY + h, false)
	end
	
	

	--the level up particles must be drawn on top of everything else
	if self.particles ~= nil then
		-- self.particles:draw()
		self.particles:drawAllParticlesExcept({"LEVEL_UP"})
	end
	
	
	
	for k, v in _G.pairs(self.hudItemsReal) do
		if v.visible ~= false then
			if self.currentVisiblePopUp and  v == self.currentVisiblePopUp and not v.disableBackgroundShade then
				gamelua.drawRect( 0, 0, 0, self.popUpAlpha, 0, 0, gamelua.screenWidth, gamelua.screenHeight, false)
			end
			v:draw(x,y)
		end
	end
	
	if self.particles ~= nil then
		self.particles:drawSpecificParticles({"LEVEL_UP"})
	end
	
	
	-- gamelua.drawLine(255,0,0,255,0,gamelua.screenHeight * 0.5,gamelua.screenWidth,gamelua.screenHeight * 0.5,false, 2)
	-- gamelua.drawLine(0,255,0,255,gamelua.screenWidth * 0.5, 0 ,gamelua.screenWidth * 0.5,gamelua.screenHeight,false, 2)
end

function NestView:drawEgg(x,y,scaleX, scaleY,angle)
	local painter = self:getChild("eggPainter")
	painter:drawEgg(x,y,scaleX,scaleY,angle)
end

function NestView:drawBird(bird, x, y, scale)

	local _, radius = _G.res.getSpriteBounds(self.currentBird.sprite) * 0.5
	local itms = {}
	for i = 1, #self.currentBird.sprites do
		local birdId = self.currentBird.id
		local eyeIndex = hatcheryBirds[birdId].eyesIndex
		if i == eyeIndex then
			if self.currentBirdBlinking then
				self.currentBird.sprites[i].sprite = Bird.Sprites.Blink[self.currentBird:getEyes()]
			else
				self.currentBird.sprites[i].sprite = Bird.Sprites.Eyes[self.currentBird:getEyes()]
			end
		end
		_G.table.insert(itms, self.currentBird.sprites[i])
	end
	x = x or 0
	y = y or 0
	scale = scale or 1
	gamelua.drawCompoObjectLua(bird.x + x, bird.y + y, bird.angle, bird.scaleY*scale, itms)
end


function NestView:setClockString(seconds)
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

function NestView:drawBackground()
	local bgW, bgH = _G.res.getSpriteBounds("H_BACKGROUND_GRASS")
	local pos = gamelua.screenHeight - bgH + 20
	gamelua.drawHatcheryBackground(pos)
	-- gamelua.drawHatcheryBackground(gamelua.screenHeight * 0.5)
	gamelua.setRenderState(gamelua.screenWidth * 0.5, gamelua.screenHeight, 1, 1, 0)
	local bgW, bgH = _G.res.drawSprite("", "H_BACKGROUND_GRASS", 0, 0 )	
	
	if true then return end
	
	gamelua.setRenderState(0, 0, 1, 1, 0)	
	
	local _, sh = _G.res.getSpriteBounds("H_BG_DEFAULT_LAYER_1")
	_G.res.drawSprite("", "H_BG_DEFAULT_LAYER_1", 0, 0, "LEFT", "TOP", gamelua.screenWidth, sh )
	
	for i = 1, #self.bgElements.layer1.elements do
		local bgElement = self.bgElements.layer1.elements[i]
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	
	_G.res.drawSprite("", "H_BG_DEFAULT_MOUNTAIN", gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.5)
	
	for i = 1, #self.bgElements.layer2.elements do
		local bgElement = self.bgElements.layer2.elements[i]
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	for i = 1, #self.bgElements.layer3.elements do
		local bgElement = self.bgElements.layer3.elements[i]
		local px, py = _G.res.getSpritePivot(bgElement.sprite)
		gamelua.setRenderState(0, 0, 1, 1, bgElement.angle, px, py)
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
	_G.res.drawSprite("", "H_BG_DEFAULT_LAYER_2", gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.5)
	for i = 1, #self.bgElements.layer4.elements do
		local bgElement = self.bgElements.layer4.elements[i]
		local px, py = _G.res.getSpritePivot(bgElement.sprite)
		gamelua.setRenderState(0, 0, 1, 1, bgElement.angle, px, py)
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	
	for i = 1, #self.bgElements.layer5.elements do
		local bgElement = self.bgElements.layer5.elements[i]
		local px, py = _G.res.getSpritePivot(bgElement.sprite)
		gamelua.setRenderState(0, 0, 1, 1, bgElement.angle, px, py)
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	
	for i = 1, #self.bgElements.layer6.elements do
		local bgElement = self.bgElements.layer6.elements[i]
		local px, py = _G.res.getSpritePivot(bgElement.sprite)
		gamelua.setRenderState(0, 0, 1, 1, bgElement.angle, px, py)
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	
	gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
	
	_G.res.drawSprite("", "H_BG_DEFAULT_LAYER_3", gamelua.screenWidth * 0.5, gamelua.screenHeight * 0.5)
	
	for i = 1, #self.bgElements.layer7.elements do
		local bgElement = self.bgElements.layer7.elements[i]
		local px, py = _G.res.getSpritePivot(bgElement.sprite)
		gamelua.setRenderState(0, 0, 1, 1, bgElement.angle, px, py)
		_G.res.drawSprite(bgElement.sprite, bgElement.x, bgElement.y)
	end
	gamelua.setRenderState(0, 0, 1, 1, 0, 0, 0)
end

function NestView:resetNest()
	
	self.currentNest = nil
	self.currentBird = nil
	self.rareBird = false
	if hatchery.useNestAccessories then
		self.currentAccessory1 = nil
		self.currentAccessory2 = nil
		self.currentAccessory3 = nil
	end
	
	local painter = self:getChild("eggPainter")
	painter:reset()
	
	--this is a temporary hack
	local buyNest = self:getChild("buyNest")
	buyNest:setNests(hatchery:getNests())
	buyNest:layout()
	buyNest:setEvents(hatcheryEvents.EID_HATCHERY_BUY_NEST_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_NEST_BUY)
	
	local buyEgg = self:getChild("buyEgg")
	buyEgg:setEggs(hatchery:getEggs())
	buyEgg:setEvents(hatcheryEvents.EID_HATCHERY_BUY_EGG_CANCEL, hatcheryEvents.EID_HATCHERY_BUY_EGG_BUY)
	
	if hatchery.useNestAccessories then
		local accDialog1 = self:getChild("accDialog1")
		accDialog1:setAccessories(hatchery:getNestAccessories(), 1)
		accDialog1:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG, hatcheryEvents.EID_HATCHERY_ACCESSORY1_BUY)
		
		local accDialog2 = self:getChild("accDialog2")
		accDialog2:setAccessories(hatchery:getNestAccessories(), 2)
		accDialog2:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG, hatcheryEvents.EID_HATCHERY_ACCESSORY2_BUY)
		
		local accDialog3 =  self:getChild("accDialog3")
		accDialog3:setAccessories(hatchery:getNestAccessories(), 3)
		accDialog3:setEvents(hatcheryEvents.EID_HATCHERY_CLOSE_ACCESSORY_DIALOG, hatcheryEvents.EID_HATCHERY_ACCESSORY3_BUY)
	end
	
	local eggAccDialog = self:getChild("eggAccDialog")
	eggAccDialog:setAccessories(hatchery:getEggAccessories(), self)
	
	self:setupCurrentStateBasedOnHatchery()
end

function NestView:getRandom(minValue, maxValue)
	local randomNormalized = _G.math.random()
	return minValue + (maxValue - minValue) * randomNormalized
end

function NestView:animateBackgroundElements(dt, time)
	
	
	-- clouds
	for i = 1, 2 do
		local layer = self.bgElements["layer" .. i]
		while #layer.elements < layer.maxElements do
			local sprite = self.bgSprites["layer" .. i][ _G.math.random(1, #self.bgSprites["layer" .. i])]
			local speed = _G.math.random(5, 10) * i
			local sw, _ = _G.res.getSpriteBounds(sprite)
			local rightEdge = gamelua.screenWidth + sw * 0.5
			if not self.layersPrepared then
				rightEdge = 0
			end
			local x = _G.math.random(rightEdge, rightEdge + gamelua.screenWidth)
			local y = 0
			if i == 1 then
				y = _G.math.random(180, 350)
			else
				y = _G.math.random(120, 200)
			end
			
			_G.table.insert(self.bgElements["layer" .. i].elements, {sprite = sprite, speed = speed, x = x, y = y, sw = sw})
		end
	
		for j = #layer.elements, 1, -1 do
			local element = layer.elements[j]
			element.x = element.x - element.speed * dt
			if element.x + element.sw * 0.5 < 0 then
				_G.table.remove(layer.elements, j)
				layer.maxElements = _G.math.random(3, 5)
			end
		end
	end
	self.layersPrepared = true
	
	local sine = _G.math.sin(time)
	
	-- plants
	for i = 1, #self.bgElements.layer3.elements do
		local element = self.bgElements.layer3.elements[i]
		element.angle = _G.math.mod(element.angle + dt * element.speed * sine, _G.math.pi * 2)
	end
	
	for i = 1, #self.bgElements.layer4.elements do
		local element = self.bgElements.layer4.elements[i]
		element.angle = _G.math.mod(element.angle + dt * element.speed * sine, _G.math.pi * 2)
	end
	
	for i = 1, #self.bgElements.layer5.elements do
		local element = self.bgElements.layer5.elements[i]
		element.angle = _G.math.mod(element.angle + dt * element.speed * sine, _G.math.pi * 2)
	end

	for i = 1, #self.bgElements.layer6.elements do
		local element = self.bgElements.layer6.elements[i]
		element.angle = _G.math.mod(element.angle + dt * element.speed * sine, _G.math.pi * 2)
	end
	
	for i = 1, #self.bgElements.layer7.elements do
		local element = self.bgElements.layer7.elements[i]
		element.angle = _G.math.mod(element.angle + dt * element.speed * sine, _G.math.pi * 2)
	end
end

function NestView:animateEgg(dt, time)
	local egg = self:getChild("egg")
	local eggCrack = self:getChild("eggCrack")
	local eggCrackRight = self:getChild("eggCrackRight")
	local eggCrackLeft = self:getChild("eggCrackLeft")
	local eggAccTop = self:getChild("eggAccTop")
	local eggAccMiddle = self:getChild("eggAccMiddle")
	local eggAccBottom = self:getChild("eggAccBottom")
	local eggCanvas =  self:getChild("eggPainter"):getEggCanvas()


	
	if self.currentNest~= nil and self.currentNest:canHatchEgg() then	
	
		egg.floorCoordinates = false										
		eggCrack.floorCoordinates = false
		eggCrack.floorCoordinates = false
		
		--[[egg.rotatePivotX, egg.rotatePivotY = _G.res.getSpritePivot(eggCanvas.image)
		eggCanvas.rotatePivotX, eggCanvas.rotatePivotY = egg.rotatePivotX, egg.rotatePivotY
		local px, py = _G.res.getSpritePivot(eggCrack.image)
		eggCrack.rotatePivotX, eggCrack.rotatePivotY = px, py + eggCrack.h * 0.5  + egg.rotatePivotY * 0.5
		local px, py = _G.res.getSpritePivot(eggCrackRight.image)
		eggCrackRight.rotatePivotX, eggCrackRight.rotatePivotY = px, py + eggCrackRight.h * 0.5  + egg.rotatePivotY * 0.5
		local px, py = _G.res.getSpritePivot(eggCrackLeft.image) 
		eggCrackLeft.rotatePivotX, eggCrackLeft.rotatePivotY = px, py + eggCrackLeft.h * 0.5  + egg.rotatePivotY * 0.5
		local px, py = _G.res.getSpritePivot(eggAccTop.image)
		eggAccTop.rotatePivotX, eggAccTop.rotatePivotY = px, py + eggAccTop.h * 0.5 + egg.rotatePivotY * 0.5
		local px, py = _G.res.getSpritePivot(eggAccMiddle.image)
		eggAccMiddle.rotatePivotX, eggAccMiddle.rotatePivotY = px, py + eggAccMiddle.h * 0.5 + egg.rotatePivotY * 0.5
		local px, py = _G.res.getSpritePivot(eggAccBottom.image)
		eggAccBottom.rotatePivotX, eggAccBottom.rotatePivotY = px, py + eggAccBottom.h * 0.5 + egg.rotatePivotY * 0.5
		]]
		if self.eggHasJustComplete == true then
			self.eggAnimationShakingTime = nil
			self.eggAnimationRestTime = nil
		end		
		
		self.eggMuffledSoundTimer = self.eggMuffledSoundTimer and self.eggMuffledSoundTimer - dt or 1.5 + _G.math.random() * 0.5
		if self.eggMuffledSoundTimer < 0 then
			self.eggMuffledSoundTimer = 2.5 + _G.math.random() * 2.5
			
			_G.res.playAudio(getHatcherySound("birdIdleMuffled"), 4, false)
		end
		

		if self.eggAnimationShakingTime == nil then
		
			local randomNumber = _G.math.random()
			
			local animationToUse = _G.math.random(1,2)
			
			
		
			if self.eggHasJustComplete == true then
				animationToUse = 1
				self.eggHasJustComplete = nil
			end
			
			if animationToUse == 1 then
				self.eggAnimationTargetShakingTime = 3
				self.eggAnimationShakingTime = 0
				self.eggAnimationShakingFreq = 30			
				self.eggAnimationShakingAmplitude = 0.1	
			else
				self.eggAnimationTargetShakingTime = 1.5
				self.eggAnimationShakingTime = 0
				self.eggAnimationShakingFreq = 30			
				self.eggAnimationShakingAmplitude = 0.04	
			end												
			
			-- self.eggAnimationMinRestTime = 3
			-- self.eggAnimationMaxRestTime = 5
			self.eggAnimationMinRestTime = 0.5
			self.eggAnimationMaxRestTime = 3
			
			
			_G.res.playAudio(getHatcherySound("shakingEgg"), 1, false)
		end
		
		
		
		if self.eggAnimationShakingTime ~= nil and self.eggAnimationShakingTime < self.eggAnimationTargetShakingTime then
			self.eggAnimationShakingTime = self.eggAnimationShakingTime + dt
			local amplitudeSpeed = -0.001			
			
			self.eggAnimationShakingAmplitude = self.eggAnimationShakingAmplitude + amplitudeSpeed
			self.eggAnimationShakingAmplitude = _G.math.max(0, self.eggAnimationShakingAmplitude)
			
			egg.angle = _G.math.sin(self.eggAnimationShakingFreq * self.eggAnimationShakingTime) * self.eggAnimationShakingAmplitude			
			eggCrack.angle = egg.angle
			eggCrackRight.angle = egg.angle
			eggCrackLeft.angle = egg.angle
			eggAccTop.angle = egg.angle
			eggAccMiddle.angle = egg.angle
			eggAccBottom.angle = egg.angle
			if self.eggAnimationShakingAmplitude == 0 then
				self.eggAnimationRestTime = self:getRandom(self.eggAnimationMinRestTime, self.eggAnimationMaxRestTime)
				egg.angle = 0
				eggCrack.angle = 0
				eggCrackRight.angle = 0
				eggCrackLeft.angle = 0
				eggAccTop.angle = 0
				eggAccMiddle.angle = 0
				eggAccBottom.angle = 0
				self.eggAnimationShakingTime = self.eggAnimationTargetShakingTime
			end
			
		elseif self.eggAnimationShakingTime >= self.eggAnimationTargetShakingTime and self.eggAnimationRestTime == nil then
			self.eggAnimationRestTime = self:getRandom(self.eggAnimationMinRestTime, self.eggAnimationMaxRestTime)
			egg.angle = 0
			eggCrack.angle = 0
			eggCrackRight.angle = 0
			eggCrackLeft.angle = 0
			eggAccTop.angle = 0
			eggAccMiddle.angle = 0
			eggAccBottom.angle = 0
		end
		
		if self.eggAnimationRestTime ~= nil then
			self.eggAnimationRestTime = self.eggAnimationRestTime - dt
			
			if self.eggAnimationRestTime <= 0 then
				self.eggAnimationShakingTime = nil
				self.eggAnimationRestTime = nil
			end
		end
		
		
	else
	
	
		egg.floorCoordinates = true
		eggCrack.floorCoordinates = true
		eggAccTop.floorCoordinates = true
		eggAccMiddle.floorCoordinates = true
		eggAccBottom.floorCoordinates = true
		egg.angle = 0
		eggCrack.angle = 0
		eggCrackRight.angle = 0
		eggCrackLeft.angle = 0
		eggAccTop.angle = 0
		eggAccMiddle.angle = 0
		eggAccBottom.angle = 0
	end
	
end


function NestView:animateArrow(dt, time, arrow)
	local amplitude = 0.3
	local speed = 3
	self.arrowAnimationAngle = self.arrowAnimationAngle and self.arrowAnimationAngle + (dt * speed) or 0
	self.arrowAnimationAngle = _G.math.mod(self.arrowAnimationAngle, _G.math.pi * 2)
	arrow.x = arrow.x + _G.math.sin(self.arrowAnimationAngle) * amplitude
	arrow.y = arrow.y - _G.math.sin(self.arrowAnimationAngle)  * amplitude
	arrow.floorCoordinates = false
	local currentEgg = self.currentNest and self.currentNest:getEgg()
	if arrow.name == "emptyNestArrow" then
		if currentEgg ~= nil then
			local eggAmplitude = 0.01
			local egg = self:getChild("egg")
			egg.scaleX = 1 + _G.math.cos(self.arrowAnimationAngle) * eggAmplitude
			egg.scaleY = 1 + _G.math.sin(self.arrowAnimationAngle -_G.math.pi/2) * eggAmplitude
			egg.floorCoordinates = false
		end
		if self.currentNest ~= nil then
			local nestAmplitude = 0.005
			local nestBack = self:getChild("nestBack")
			local nestFront = self:getChild("nestFront")
			local placeEggButton = self:getChild("placeEggButton")
			nestBack.scaleX = 1 + _G.math.cos(self.arrowAnimationAngle) * nestAmplitude
			nestBack.scaleY = 1 + _G.math.sin(self.arrowAnimationAngle -_G.math.pi/2) * nestAmplitude
			nestFront.scaleX = nestBack.scaleX
			nestFront.scaleY = nestBack.scaleY
			placeEggButton.scaleX = nestBack.scaleX
			placeEggButton.scaleY = nestBack.scaleY
			nestBack.floorCoordinates = false
			nestFront.floorCoordinates = false
			placeEggButton.floorCoordinates = false
		else
			local nestAmplitude = 0.013
			local emptyNestButton = self:getChild("emptyNestButton")
			emptyNestButton.scaleX = 1 + _G.math.cos(self.arrowAnimationAngle) * nestAmplitude
			emptyNestButton.scaleY = 1 + _G.math.sin(self.arrowAnimationAngle -_G.math.pi/2) * nestAmplitude
			emptyNestButton.floorCoordinates = false
		end
		
		
	elseif hatchery.useNestAccessories and arrow.name == "accessoryArrow3" then
		local nestAmplitude = 0.013
		local acc3Button = self:getChild("acc3Button")
		acc3Button.scaleX = 1 + _G.math.cos(self.arrowAnimationAngle) * nestAmplitude
		acc3Button.scaleY = 1 + _G.math.sin(self.arrowAnimationAngle -_G.math.pi/2) * nestAmplitude
		acc3Button.floorCoordinates = false
	elseif hatchery.useNestAccessories and arrow.name == "accessoryArrow2" then
		local nestAmplitude = 0.013
		local acc2Button = self:getChild("acc2Button")
		acc2Button.scaleX = 1 + _G.math.cos(self.arrowAnimationAngle) * nestAmplitude
		acc2Button.scaleY = 1 + _G.math.sin(self.arrowAnimationAngle -_G.math.pi/2) * nestAmplitude
		acc2Button.floorCoordinates = false
	end
end

function NestView:animateBird(dt, time) 
	local bird = self:getChild("bird")
	-- bird.visible = true
	
	
	if self.birdAnimationAngle == nil then
		self.birdAnimationAngle = 0						
	end
	
	local amplitude = 0.013
	local speed = 3
	
	self.birdAnimationAngle = self.birdAnimationAngle + (dt * speed)
	
	self.birdAnimationAngle = _G.math.mod(self.birdAnimationAngle, _G.math.pi * 2)
	
	-- bird.scaleX = 1 + _G.math.cos(self.birdAnimationAngle) * amplitude
	-- bird.scaleY = 1 + _G.math.sin(self.birdAnimationAngle -_G.math.pi/2) * amplitude
	
	if self.birdBlinkTime == nil then
		self.birdBlinkTime = 0
	end
	
	self.birdBlinkTime = self.birdBlinkTime + dt
	
	if 	(self.birdBlinkTime >= 1.5 and self.birdBlinkTime <= 1.7) or 
		(self.birdBlinkTime >= 3 and self.birdBlinkTime <= 3.2)	then 
		self.currentBirdBlinking = true
		--bird.image = self.currentBird.spriteBlink
	else
		self.currentBirdBlinking = false
		--bird.image = self.currentBird.sprite
	end
	
	if self.birdBlinkTime > 5 then
		self.birdBlinkTime = 0
	end
	
end

function NestView:allTasksCompleted(allTasks, lastTaskCompleted)
	-- gamelua.print("\n all texts completed")
	
	local hatchedDialog = self:getChild("hatchedDialog")
	
	if hatchedDialog.visible == true then
		self.allTasksCompletedLastTask = lastTaskCompleted
	else
		self:openTasksDialog(true, lastTaskCompleted)
	end
	
	self:taskCompleted(lastTaskCompleted)
	
end

function NestView:taskCompleted(task)
	
	-- self:showNotification(task.text)
	
	local hatchedDialog = self:getChild("hatchedDialog")
	
	self.currentNotificationText = task.text
	self.notificationDelay = 0
end

function NestView:showNotification(text)
	local taskCompletedNotification = self:getChild("taskCompletedNotification")
	taskCompletedNotification.visible = true
	taskCompletedNotification:setAsAchieved(false)
	taskCompletedNotification:setText(text)
	
	self.notificationAnimationTime = 0
	-- self.notificationStartY = gamelua.screenHeight +50
	-- self.notificationEndY = gamelua.screenHeight - 50
	self.notificationStartY = 0
	self.notificationEndY = 150
	
	taskCompletedNotification.y = self.notificationStartY
	
	_G.res.playAudio(getHatcherySound("taskNotificationAppears"), 1, false)
	
	self.hidingNotification = false
end

function NestView:hideNotification()
	local taskCompletedNotification = self:getChild("taskCompletedNotification")
	
	self.notificationAnimationTime = 0
	
	-- self.notificationStartY = gamelua.screenHeight - 50
	-- self.notificationEndY = gamelua.screenHeight + 50
	self.notificationStartY = 150
	self.notificationEndY = 0
	
	taskCompletedNotification.y = self.notificationStartY
	
	self.hidingNotification = true
	
	_G.res.playAudio(getHatcherySound("taskNotificationAppears"), 1, false)
	
end

function NestView:updateNotification(dt, time) 
	if self.notificationDelay ~= nil then
		self.notificationDelay = self.notificationDelay + dt
		
		if self.notificationDelay >= self.notificationTotalDelay then
			self:showNotification(self.currentNotificationText)
			self.notificationDelay = nil
		end
	end

	if self.notificationAnimationTime ~= nil then
	
		local totalAnimationTime = 1 
		self.notificationAnimationTime = self.notificationAnimationTime + dt
		
		self.notificationAnimationTime = _G.math.min(self.notificationAnimationTime, self.notificationSlidingTime)
		
		local taskCompletedNotification = self:getChild("taskCompletedNotification")
		taskCompletedNotification.y = self:tweenLinear(self.notificationAnimationTime,self.notificationStartY , self.notificationEndY - self.notificationStartY, self.notificationSlidingTime)
		
		if self.notificationAnimationTime == self.notificationSlidingTime then
			self.notificationRestTime = 0
			self.notificationAnimationTime = nil
			
			if self.hidingNotification == true  then
				self.notificationRestTime = nil							
			end
		end
	
	elseif self.notificationRestTime ~= nil then
		
		self.notificationRestTime = self.notificationRestTime + dt
		
		local taskCompletedNotification = self:getChild("taskCompletedNotification")
		
		if self.notificationRestTime > self.notificationCheckTime and not taskCompletedNotification:isMarkedAsAchieved() then
			
			taskCompletedNotification:setAsAchieved(true)
			_G.res.playAudio(getHatcherySound("taskNotificationCheck"), 1, false)
			--play sound
		end
	
		
		self.notificationRestTime = _G.math.min(self.notificationRestTime, self.notificationTotalRestTime)
		
		if self.notificationRestTime == self.notificationTotalRestTime then
			self:hideNotification()
			self.notificationRestTime  = nil
		end
		
	end
end

function NestView:openTasksDialog(animateCompletedTick, lastTaskCompleted)
	local tasksScreen = self:getChild("tasksScreen")
	tasksScreen:setTasks(getTaskManagerInstance():getCurrentTaskList())
	tasksScreen:setReward(getTaskManagerInstance():getCurrentTaskReward())
	tasksScreen:setUnlockable(getTaskManagerInstance():getCurrentUnlockable())
	tasksScreen:updateButtonsStates()
	self:openPopUp(tasksScreen)		
	
	if animateCompletedTick == true then
		tasksScreen:startAllTasksCompletedAnimations(lastTaskCompleted)
		-- tasksScreen:setEvents(hatcheryEvents.EID_HATCHERY_TASKS_SCREEN_REWARDED_COLLECTED)		
	else
		tasksScreen:setEvents(hatcheryEvents.EID_HATCHERY_TASKS_SCREEN_CANCEL)		
	end
	
	
end

function NestView:tweenLinear (currentTime, startValue, changeOfValue, duration)
	local c = changeOfValue
	local t = currentTime
	local d = duration
	local b = startValue
	return c*t/d + b;
end

function NestView:taskScreenTickAnimationFinished()
	
	getTaskManagerInstance():collectCurrentTaskReward()
	self:starCountUpdated()	
	getTaskManagerInstance():setupTaskBasedOnPlayerLevel()	
	
	local playerRankDescription = self:getChild("playerRankDescription")
	local index = _G.math.min(self.hatchery:getPlayerRank(), #self.protoRankTexts)
	playerRankDescription.text = self.protoRankTexts[index]
	
	local playerRankText = self:getChild("playerRankText")
	playerRankText.text = "Level " .. self.hatchery:getPlayerRank()
	self.particles:startLevelUpParticles()
	
	_G.res.playAudio(getHatcherySound("levelUp"), 1, false)
	
end

function NestView:setEggAccessorySprites()
	local accessories = self.currentNest:getEgg():getAccessories()
	for k, v in _G.pairs(accessories) do
		if v:getType() == "TOP" then
			local eggAccTop = self:getChild("eggAccTop")
			eggAccTop:setImage(v:getItemSprite())
			eggAccTop.visible = true
		elseif v:getType() == "MIDDLE" then
			local eggAccMiddle = self:getChild("eggAccMiddle")
			eggAccMiddle:setImage(v:getItemSprite())
			eggAccMiddle.visible = true
		elseif v:getType() == "BOTTOM" then
			local eggAccBottom = self:getChild("eggAccBottom")
			eggAccBottom:setImage(v:getItemSprite())
			eggAccBottom.visible = true
		end
	end
end

filename="NestView.lua"
