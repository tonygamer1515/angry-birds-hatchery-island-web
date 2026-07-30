------------
--Hatchery-class
------------

-- TODO: Move the menu system to be self inside the hatchery code.
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/MenuManager.lua", this, "")
-- gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/menus/subsystems.lua", this, "subsystems")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/EventManager.lua", this, "subsystems")
gamelua.loadLuaFileToObject("hatchery/hatcheryEvents.lua", this, "hatcheryEvents")
gamelua.loadLuaFileToObject("hatchery/scripts/SoundTable.lua", this, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/events.lua", this, "events")

--basic ui stuff comes here
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/Frame.lua", this, "ui")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/Image.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/CompoImage.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/Text.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/TextButton.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/BGBox.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/ImageButton.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/ScallableButton.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/RectangleButton.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/StaticButton.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/InvisibleButton.lua", this.ui, "")
gamelua.loadLuaFileToObject(gamelua.scriptPath .. "/ui_components/ToggleButton.lua", this.ui, "")

gamelua.loadLuaFileToObject("hatchery/scripts/UI/StarCoinButton.lua", this.ui, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdButton.lua", this.ui, "")

gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryDynamicTemplateObjects.lua", this, "")

--animation definitions
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryAnimations.lua",this,"")

--native object wrappers
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryDynamicObject.lua",this,"")
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryConstructionObject.lua",this,"")
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryEggObject.lua",this,"")
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryNestObject.lua",this,"")
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryBirdObject.lua",this,"")

--hatchery ui stuff comes here

gamelua.loadLuaFileToObject("hatchery/scripts/UI/WorldView.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/WorldSelectionView.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/WorldSelectionPanel.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/hatcheryContextMenu.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdSelectionPanel.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestView.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestViewParticles.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/ConfirmationDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NotificationDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/SpendStarConfirmationDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BuyStarsDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestSelectionDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestFillBar.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/EggSelectionDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdMatrixDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/StatCardDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/Particle.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/ParticleHolder.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestAccessoryDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/EggAccessoryDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/MatrixView.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/TestFrame.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/TasksDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/TaskEntryButton.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/HatchedDialog.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdSelector.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/EggPainter.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/EggPainterParticles.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/EggCanvas.lua", this.ui, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/InventoryButton.lua", this.ui, "")

gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdDesigner2.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdDesigner2SelectionFrame.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdDesigner.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/BirdDesignerSelectionFrame.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestDesigner.lua", this, "")
gamelua.loadLuaFileToObject("hatchery/scripts/UI/NestDesignerSelectionFrame.lua", this, "")


-- extra particles for ingame birds. 
gamelua.loadLuaFileToObject("hatchery/scripts/hatcheryBirdParticles.lua", gamelua, "hatcheryParticleTable")

hatcheryEventManager = subsystems.EventManager:new()
Hatchery = MenuManager:new()

g_returnEvent = ""
    
function Hatchery:new(o)
	o = o or {}
	_G.setmetatable(o, self)
	self.__index = self
	
	--THIS IS A HACK, the UI.frame keeps track of how many onEntry calls have been performed, but for hatchery we created another instance of the menu manager to help
	-- integrate it into other projects. TODO: Move the entry count to the menu manager instead of the ui.Frame 
	self.gameEntryCounts = 0

	self.useNestAccessories = false
	
	self.scriptPath = "hatchery/scripts/"
	self.imagePath = "hatchery/images/"
	self.audioPath = "hatchery/audio/"
	self.fontPath = "hatchery/fonts/"
	self.fontProfile = o.fontProfile or "1024x768"
	self.imageProfile = o.imageProfile or "1024x768"
	
	self:loadScripts()
	-- self:loadAssets()
	
	self.birds = {}
	self.nests = {}
	self.eggs = {}
	self.nestAccessories = {}
	self.eggAccessories = {}
	
	
	self.myBirds = {}
	self.myNests = {}
	self.selectedBirds = {}
	
	-- Create template objects
	--<PROTO-STUFF>
	self.nests[1] = Nest:new({type = Nest.TYPE.RED, price = 20, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_RED", top = "H_NEST_RED_TOP", shop = "H_NEST_RED"}})
	self.nests[2] = Nest:new({type = Nest.TYPE.BLUE, price = 30, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_BLUE", top = "H_NEST_BLUE_TOP", shop = "H_NEST_BLUE"}})
	self.nests[3] = Nest:new({type = Nest.TYPE.YELLOW, price = 40, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_YELLOW", top = "H_NEST_YELLOW_TOP", shop = "H_NEST_YELLOW"}})
	self.nests[4] = Nest:new({type = Nest.TYPE.BLACK, price = 50, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_BLACK", top = "H_NEST_BLACK_TOP", shop = "H_NEST_BLACK"}})
	self.nests[5] = Nest:new({type = Nest.TYPE.WHITE, price = 60, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_WHITE", top = "H_NEST_WHITE_TOP", shop = "H_NEST_WHITE"}})	
	self.nests[6] = Nest:new({type = Nest.TYPE.BIGBROTHER, price = 80, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_BIGBROTHER", top = "H_NEST_BIGBROTHER_TOP", shop = "H_NEST_BIGBROTHER"}})
	self.nests[7] = Nest:new({type = Nest.TYPE.GREEN, price = 70, priceToSpeedBuild = 20, completeTimer = 60, sprites = {bottom = "H_NEST_GREEN", top = "H_NEST_GREEN_TOP", shop = "H_NEST_BOOMERANG"}})

	self.eggs[1] = Egg:new({type = Egg.TYPE.NORMAL, name = "Normal", speedName = "Fast", price = 20, priceToSpeedBuild = 20, completeTimer = 60, sprites = {nest = "H_EGG_DEFAULT", shop = "H_SELECTABLE_EGG_SMALL"}})
	self.eggs[2] = Egg:new({type = Egg.TYPE.GOOFY, name = "Goofy", speedName = "Slow", price = 30, priceToSpeedBuild = 20, completeTimer = 60, sprites = {nest = "H_EGG_DEFAULT", shop = "H_SELECTABLE_EGG_MEDIUM"}})
	self.eggs[3] = Egg:new({type = Egg.TYPE.HEAVY, name = "Heavy", speedName = "Turtle", price = 40, priceToSpeedBuild = 20, completeTimer = 60, sprites = {nest = "H_EGG_DEFAULT", shop = "H_SELECTABLE_EGG_BIG"}})
	
	--view to show on menus. This is managed by hatchery 
	
	-- self.birds[1] = Bird:new({type = Bird.TYPE.RED, id = 1, sprite = "BIRD_RED_TEMP", spriteBlink = "BIRD_RED_BLINK_TEMP"})
	-- self.birds[2] = Bird:new({type = Bird.TYPE.BLUE, id = 2, sprite = "BIRD_BLUE_TEMP", spriteBlink = "BIRD_BLUE_BLINK_TEMP"})
	-- self.birds[3] = Bird:new({type = Bird.TYPE.YELLOW, id = 3, sprite = "BIRD_YELLOW_TEMP", spriteBlink = "BIRD_YELLOW_BLINK_TEMP"})
	-- self.birds[4] = Bird:new({type = Bird.TYPE.BLACK, id = 4, sprite = "BIRD_BLACK_TEMP", spriteBlink = "BIRD_BLACK_BLINK_TEMP"})
	-- self.birds[5] = Bird:new({type = Bird.TYPE.WHITE, id = 5, sprite = "BIRD_WHITE_TEMP", spriteBlink = "BIRD_WHITE_BLINK_TEMP"})
	-- self.birds[6] = Bird:new({type = Bird.TYPE.WHITE, id = 6, sprite = "BIRD_RED_TEMP_1", spriteBlink = "BIRD_RED_BLINK_TEMP_1"})
	-- self.birds[7] = Bird:new({type = Bird.TYPE.WHITE, id = 7, sprite = "BIRD_BLUE_TEMP_1", spriteBlink = "BIRD_BLUE_BLINK_TEMP_1"})
	-- self.birds[8] = Bird:new({type = Bird.TYPE.WHITE, id = 8, sprite = "BIRD_YELLOW_TEMP_1", spriteBlink = "BIRD_YELLOW_BLINK_TEMP_1"})
	-- self.birds[9] = Bird:new({type = Bird.TYPE.WHITE, id = 9, sprite = "BIRD_BLACK_TEMP_1", spriteBlink = "BIRD_BLACK_BLINK_TEMP_1"})
	-- self.birds[10] = Bird:new({type = Bird.TYPE.WHITE, id = 10, sprite = "BIRD_WHITE_TEMP_1", spriteBlink = "BIRD_WHITE_BLINK_TEMP_1"})
	
	if self.useNestAccessories then
		self.nestAccessories[1] = NestAccessory:new({type = NestAccessory.TYPE.SLOT3_TOYS, slot = 3, id = 1, price = 60})
		self.nestAccessories[2] = NestAccessory:new({type = NestAccessory.TYPE.SLOT3_UMBRELLA, slot = 3, id = 2, price = 60})
		self.nestAccessories[3] = NestAccessory:new({type = NestAccessory.TYPE.SLOT2_FLOWER, slot = 2, id = 1, price = 60 })
		self.nestAccessories[4] = NestAccessory:new({type = NestAccessory.TYPE.SLOT2_FAN, slot = 2, id = 2, price = 60, spriteFan = "H_NEST_ACC_LOWER_1"})
	end
	
	self.eggAccessories[1] = EggAccessory:new({ type = EggAccessory.TYPE.TOP, gender = "male", id = 1, price = 20 })
	self.eggAccessories[2] = EggAccessory:new({ type = EggAccessory.TYPE.MIDDLE, gender = "male", id = 2, price = 20 })
	self.eggAccessories[3] = EggAccessory:new({ type = EggAccessory.TYPE.BOTTOM, gender = "male", id = 3, price = 20 })
	self.eggAccessories[4] = EggAccessory:new({ type = EggAccessory.TYPE.TOP, gender = "female", id = 4, price = 20 })
	self.eggAccessories[5] = EggAccessory:new({ type = EggAccessory.TYPE.MIDDLE, gender = "female", id = 5, price = 20 })
	self.eggAccessories[6] = EggAccessory:new({ type = EggAccessory.TYPE.BOTTOM, gender = "female", id = 6, price = 20 })
	
	self.stars = o.stars or 60
	self.quadClickTimer = 0
	self.quadClickCounter = 0
	--</PROTO-STUFF>
	
	-- <NON-PROTO STUFF>
	
	hatcheryBirds = hatcheryBirds or {}
	local birdId = 1
	for i = 1, Bird.BIRD_AMOUNT do
		for l = 1, Egg.EGG_AMOUNT do
			for j = 1, NestAccessory.ACCESSORY_SLOT3_AMOUNT do
				for k = 1, NestAccessory.ACCESSORY_SLOT2_AMOUNT do					
					if hatcheryBirds[birdId] then
						self.birds[birdId] = Bird:new(hatcheryBirds[birdId])
						self.birds[birdId]:calculateDefaultItemsIndices()
					else
						local birdTable = 	{	id = birdId,
												shape = Bird.SHAPE[Bird.DefaultIndexes[i]],
												recipe = {nest = i, egg = l, nestAccSlot2 = k, nestAccSlot3 = j},
												bodyIndex = 1,
												eyesIndex = 2,
												beakIndex = 3
												
											} 
						self.birds[birdId] = Bird:new(birdTable)
						self.birds[birdId]:calculateDefaultItemsIndices()
					end
					birdId = birdId + 1
				end
			end
		end
	end
	
	self.maxSelectedBirds = 5
	

	--</NON-PROTO STUFF>	
	
	

	
	

	return o
end



function Hatchery:getNestView()
	return hatchery:getLink("NEST_VIEW")
end


function Hatchery:getSelectedBirds()
	return self.selectedBirds
end

function getIndexInTable(tableObj, element)
	local index = 1
	for k, v in _G.pairs(tableObj) do
		if v == element then
			return index
		end
		
		index = index + 1
		
	end
	
	return 0
end

function Hatchery:addBirdToSelectedBirds(bird)
	if getIndexInTable(self.selectedBirds, bird) == 0 then
		_G.table.insert(self.selectedBirds, bird)
	end	
end

function Hatchery:removeBirdFromSelectedBirds(bird)

	local ind = getIndexInTable(self.selectedBirds, bird)
	if ind ~= 0 then
		_G.table.remove(self.selectedBirds, ind)
	end
end	

function Hatchery:getNumSelectedBirds()
	return #self.selectedBirds
end

function Hatchery:getMaxNumSelectedBirds()
	return self.maxSelectedBirds
end

function Hatchery:getBirds()
	return self.birds
end

function Hatchery:getCollectedBirds()
	return self.myBirds
end
function Hatchery:getBirdWithId(id)

	if self.birds[id] then
		return self.birds[id]
	else
		return false
	end
end

function Hatchery:getCollectedBirdAmount()
	return #self.myBirds
end

--right now, the relation between the tasks and rank system is redundant, because the task manager know how many tasks it has completed
--I will keep this method because we might have other factors determining what is the current player rank
function Hatchery:getPlayerRank()
	return getTaskManagerInstance():getTotalCompletedTasks() + 1
	-- return _G.math.min(1 + _G.math.floor(hatchery:getCollectedBirdAmount() / 3), 3)
end

function Hatchery:hasBirdWithId(id)

	for i = 1, #self.myBirds do
		if self.myBirds[i]:getId() == id then
			return true
		end
	end	
	return false
end

function Hatchery:getNests()
	return self.nests
end

function Hatchery:getNestTemplateByType(nestType)
	for k, v in _G.pairs(self.nests) do
		if v.type == nestType then
			return v
		end
	end
	
	return nil
end

function Hatchery:getEggs()
	return self.eggs
end

function Hatchery:getEggTemplateByType(eggType)
	for k, v in _G.pairs(self.eggs) do
		if v.type == eggType then
			return v
		end
	end
	
	return nil
end

function Hatchery:getEggAccessories()
	return self.eggAccessories
end

function Hatchery:getStars()
	return self.stars
end

function Hatchery:getNestAccessories()
	return self.nestAccessories
end

function Hatchery:setStars(stars)
	self.stars = stars
end

function Hatchery:purchaseStars(amount)
	self.stars = self.stars + amount
end

function Hatchery:purchaseNest(nest)
	if nest:getPrice() <= self.stars then
		self.stars = self.stars - nest:getPrice()
		nest.hatchery = self
		_G.table.insert(self.myNests, Nest:new(nest))
	else
		return false
	end
end

function Hatchery:addNest(nest)
	_G.table.insert(self.myNests, Nest:new(nest))
end

function Hatchery:speedBuildNest(nest)
	if nest:getPriceToSpeedBuild() <= self.stars then
		self.stars = self.stars - nest:getPriceToSpeedBuild()
		nest:speedBuild()
		return true
	else
		return false
	end
end

function Hatchery:speedBuildEgg(nest)
	
	local egg = nest:getEgg()

	if egg ~= false and egg:getPriceToSpeedBuild() <= self.stars then
		self.stars = self.stars - egg:getPriceToSpeedBuild()
		egg:speedBuild()
		return true
	else
		return false
	end
end

function Hatchery:purchaseEggToNest(nest, egg)
	if egg:getPrice() <= self.stars then
		self.stars = self.stars - egg:getPrice()
		nest:addEgg(egg)
	else
		return false 
	end
end

function Hatchery:addEggToNest(nest, egg)
	nest:addEgg(egg)
end

function Hatchery:purchaseNestAccessory(nest, accessory)
	if accessory:getPrice() <= self.stars then
		self.stars = self.stars - accessory:getPrice()
		nest:addAccessory(accessory)
	else
		return false
	end
end

function Hatchery:purchaseEggAccessory(nest, accessory)
	if accessory:getPrice() <= self.stars then
		self.stars = self.stars - accessory:getPrice()
		nest:getEgg():addAccessory(accessory)
	else
		return false
	end
end

--TODO: This is an extreme hack (passing the accessories) change later
function Hatchery:hatchEgg(nest, gender, isRare, bodyType, bodyColor)
	if nest:canHatchEgg() then
		local egg = nest:getEgg()
		local nestTopAccessory = nest:getAccessoryOnSlot(3)
		local nestBottomAccessory = nest:getAccessoryOnSlot(2)
		
		local newBird = nest:hatchEgg()
		local newBirdId = newBird:getId()
		
		local nestTypes =	{"H_NEST_RED", "H_NEST_BLUE", "H_NEST_YELLOW", "H_NEST_BLACK", "H_NEST_WHITE", "H_NEST_GREEN", "H_NEST_BIGBROTHER"}
		local eggTypes =	{"H_SELECTABLE_EGG_SMALL", "H_SELECTABLE_EGG_MEDIUM", "H_SELECTABLE_EGG_BIG" }
				
		--TODO: WEIRD BUG, AT THIS POINT THE Nest.TYPE IS ALL SCREWED UP, FIGURE OUT WHO'S CHANGING THE VALUES
		-- local nestIndex = getIndexInTable(Nest.TYPE, nest:getType())
		-- local eggIndex =  getIndexInTable(Egg.TYPE, egg:getType())
		local nestIndex = getIndexInTable(nestTypes, nest:getType())
		local eggIndex =  getIndexInTable(eggTypes, egg:getType())
		local nestTopAccessoryIndex = nil
		local nestBottomAccessoryIndex = nil
		
		--we add 1 because of the empty slot
		if nestTopAccessory ~= nil then
			nestTopAccessoryIndex = nestTopAccessory:getId() + 1
		else
			nestTopAccessoryIndex = 1
		end
		
		if nestBottomAccessory ~= nil then
			nestBottomAccessoryIndex = nestBottomAccessory:getId() + 1
		else
			nestBottomAccessoryIndex = 1
		end
		
		local totalBirdsCombinationsPerNest = Egg.EGG_AMOUNT * NestAccessory.ACCESSORY_SLOT3_AMOUNT * NestAccessory.ACCESSORY_SLOT2_AMOUNT
		local totalBirdsCombinationsPerEgg = NestAccessory.ACCESSORY_SLOT3_AMOUNT * NestAccessory.ACCESSORY_SLOT2_AMOUNT
		local totalBirdsCombinationsPerAccessoryTop = NestAccessory.ACCESSORY_SLOT2_AMOUNT
		newBirdId = totalBirdsCombinationsPerNest * (nestIndex-1) + totalBirdsCombinationsPerEgg * (eggIndex -1) + totalBirdsCombinationsPerAccessoryTop * (nestTopAccessoryIndex-1) + (nestBottomAccessoryIndex -1)
		newBirdId = newBirdId + 1
		
		local accessoryUp = 0
		local accessoryMiddle = 0
		local accessoryDown = 0
		
		
		local accessories = egg:getAccessories()
		for k, v in _G.pairs(accessories) do
			if v:getType() == "TOP" then
				accessoryUp = 1
			elseif v:getType() == "MIDDLE" then
				accessoryMiddle = 1
			elseif v:getType() == "BOTTOM" then
				accessoryDown = 1
			end
		end
		
		local identifierString = "g" .. gender .. "_t" .. accessoryUp .. "_m" .. accessoryMiddle .. "_b" .. accessoryDown
		
		local poolToUse = hatcheryBirdPools
		
		if isRare == true then
			poolToUse = hatcheryRareBirdPools
		end
		
		poolToUse = hatcheryBirdPools
		
		if bodyType ~= nil and bodyColor ~= nil then
			identifierString = "body_" .. bodyType .. "_color_" .. bodyColor
			poolToUse = hatcheryColorPaintBirdPools
		end
		
		gamelua.print("\n identifier " .. identifierString)
		local possibleIds = poolToUse[identifierString]
		local index =  _G.math.random(1,#possibleIds)
		
		newBirdId = possibleIds[index]
		
		gamelua.print("\n hatching " .. identifierString .. " " .. index .. " " .. newBirdId)
		
		
		local birdTemplate = self:getBirdWithId(newBirdId)
		if birdTemplate then
			newBird =  Bird:new(birdTemplate)
		end
		
		local foundId = false
		
		for i = 1, #self.myBirds do
			if newBirdId == self.myBirds[i]:getId() then
				foundId = true				
			end
		end
		if not foundId then
			_G.table.insert(self.myBirds, newBird)
		end
		return newBird, not foundId
	else
		return false
	end
end

--this one is used when loading the saved hatchery states
function Hatchery:hatchEggFromID(nest, birdID)		
		
	local birdTemplate = self:getBirdWithId(birdID)
	if birdTemplate then
		newBird =  Bird:new(birdTemplate)
	end
	
	local foundId = false
	
	for i = 1, #self.myBirds do
		if birdID == self.myBirds[i]:getId() then
			foundId = true				
		end
	end
	if not foundId then
		_G.table.insert(self.myBirds, newBird)
	end
	return newBird
	
end


function Hatchery:loadScripts()
	gamelua.loadLuaFileToObject(self.scriptPath .. "bird.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "egg.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "nest.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "nestAccessory.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "eggAccessory.lua", this, "")
	gamelua.loadLuaFile(self.scriptPath .. "hatcheryBirds.lua", "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "hatcheryNests.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "hatcheryBirdsSaves.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "hatcheryBirdPools.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "hatcheryObjects.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "hatcheryDefaultMap.lua", this, "")
	gamelua.loadLuaFileToObject(self.scriptPath .. "TaskManager.lua", this, "")
end

function Hatchery:loadAssets() 
	gamelua.print("\n loading hatchery assets")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_ACCESSORIES_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BUTTONS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_1.dat")
	
	
	if gamelua.deviceModel == "ipad" then
		_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_3.dat")
		_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_4.dat")
		_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_5.dat")
	else
		_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_2.dat")
	end
	
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_PARTICLES_1.dat")
	
	-- These should be moved to INGAME after challenges -update!
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRDS_1.dat")
	
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_2.dat")	
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_3.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_4.dat")
	
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_TEMP_UNIQUE_BIRDS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_MAP_TILES_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_MAP_TILES_2.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_MAP_TILES_3.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_MAP_OBJECTS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_DECO_OBJECTS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_DYNAMIC_OBJECTS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_UI_OBJECTS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ANIM_OBJECTS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_EFFECT_OBJECTS_1.dat")
	_G.res.createSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_FOG_OF_WAR_1.dat")
	
	_G.res.createCompoSpriteSet(self.imagePath .. self.imageProfile .. "/HATCHERY_composprites.dat")
	
	
	_G.res.createBitmapFont(self.fontPath .. self.fontProfile .. "/FONT_HATCHERY.dat")
	_G.res.createBitmapFont(self.fontPath .. self.fontProfile .. "/FONT_HATCHERY_NUMBERS.dat")
	
	-- BIRD SPECIALTIES
	_G.res.createAudio(self.audioPath .. "h_specialty_boost.mp3", "h_specialty_boost", true)
	_G.res.createAudio(self.audioPath .. "h_specialty_divide.mp3", "h_specialty_divide", true)
	_G.res.createAudio(self.audioPath .. "h_specialty_egg.mp3", "h_specialty_egg", true)
	_G.res.createAudio(self.audioPath .. "h_specialty_explosion.mp3", "h_specialty_explosion", true)
	_G.res.createAudio(self.audioPath .. "h_specialty_explosion2.mp3", "h_specialty_explosion2", true)
	_G.res.createAudio(self.audioPath .. "h_specialty_yell.mp3", "h_specialty_yell", true)
	_G.res.createAudio(self.audioPath .. "h_specialty_yell2.mp3", "h_specialty_yell2", true)
	-- END OF BIRD SPECIALTIES
	
	-- NEW ABI SOUNDS
	
	_G.res.createAudio(self.audioPath .. "abi_hurry.mp3", "abi_hurry", true)
	_G.res.createAudio(self.audioPath .. "abi_inventory_move.mp3", "abi_inventory_move", true)
	_G.res.createAudio(self.audioPath .. "abi_inventory_place.mp3", "abi_inventory_place", true)
	_G.res.createAudio(self.audioPath .. "abi_nest_ready.mp3", "abi_nest_ready", true)
	_G.res.createAudio(self.audioPath .. "abi_ambience.mp3", "abi_ambience", true)
	_G.res.createAudio(self.audioPath .. "abi_ambience_2.mp3", "abi_ambience_2", true)
	_G.res.createAudio(self.audioPath .. "abi_remove_item.mp3", "abi_remove_item", true)

	
	-- PAINTING
		for i = 1, 3 do
		_G.res.createAudio(self.audioPath .. "h_can_select_" .. i .. ".mp3", "h_can_select_" .. i, false)
	end
	_G.res.createAudio(self.audioPath .. "h_painting_loop.mp3", "h_painting_loop", true)
	
	_G.res.createAudio(self.audioPath .. "h_bubble_bird.mp3", "h_bubble_bird", true)
	_G.res.createAudio(self.audioPath .. "h_bubble_disappears.mp3", "h_bubble_disappears", true)
	_G.res.createAudio(self.audioPath .. "h_bubble_appears.mp3", "h_bubble_appears", true)
	
	
	
	_G.res.createAudio(self.audioPath .. "h_bird_jumps_in_1.mp3", "h_bird_jumps_in_1", true)
	_G.res.createAudio(self.audioPath .. "h_levelup_1.mp3", "h_levelup_1", true)
	_G.res.createAudio(self.audioPath .. "h_task_check.mp3", "h_task_check", true)
	_G.res.createAudio(self.audioPath .. "h_notification_1.mp3", "h_notification_1", true)
	_G.res.createAudio(self.audioPath .. "h_bird_hatched_popup.mp3", "h_bird_hatched_popup", true)
	_G.res.createAudio(self.audioPath .. "h_egg_timer.wav", "h_egg_timer", true)
	_G.res.createAudio(self.audioPath .. "h_egg_shaking_1.wav", "h_egg_shaking_1", true)
	_G.res.createAudio(self.audioPath .. "h_egg_shaking_2.wav", "h_egg_shaking_2", true)
	_G.res.createAudio(self.audioPath .. "hatchery_ambient.wav", "hatchery_ambient", true)
	_G.res.createAudio(self.audioPath .. "h_nest_building.wav", "h_nest_building", true)
	_G.res.createAudio(self.audioPath .. "h_egg_selected.wav", "h_egg_selected", true)
	_G.res.createAudio(self.audioPath .. "h_nest_selected.wav", "h_nest_selected", true)
	_G.res.createAudio(self.audioPath .. "h_background_music_1.wav", "h_background_music_1", false)
	_G.res.createAudio(self.audioPath .. "h_grind_star_1.wav", "h_grind_star_1", false)
	_G.res.createAudio(self.audioPath .. "h_grind_star_2.wav", "h_grind_star_2", false)
	_G.res.createAudio(self.audioPath .. "h_purchase.wav", "h_purchase", false)
	for i = 1, 13 do
		_G.res.createAudio(self.audioPath .. "h_bird_idle_" .. i .. ".wav", "h_bird_idle_" .. i, false)
	end
	for i = 1, 10 do
		_G.res.createAudio(self.audioPath .. "h_fanfare_" .. i .. ".wav", "h_fanfare_" .. i, false)
	end
	for i = 1, 4 do
		_G.res.createAudio(self.audioPath .. "h_no_" .. i .. ".wav", "h_no_" .. i, false)
	end
	for i = 1, 4 do
		_G.res.createAudio(self.audioPath .. "h_OK_" .. i .. ".wav", "h_OK_" .. i, false)
	end
	for i = 1, 4 do
		_G.res.createAudio(self.audioPath .. "h_marker_" .. i .. ".mp3", "h_marker_" .. i, false)
	end
	for i = 1, 4 do
		_G.res.createAudio(self.audioPath .. "h_egg_crack_" .. i .. ".mp3", "h_egg_crack_" .. i, false)
	end
	
	
end

function Hatchery:releaseAssets()
	gamelua.print("\n releasing hatchery assets")
	
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_ACCESSORIES_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BG_DEFAULT_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BUTTONS_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_2.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_3.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_4.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_ELEMENTS_5.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_PARTICLES_1.dat")
	
	-- These should be moved to INGAME after challenges -update!
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRDS_1.dat")
	
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_2.dat")	
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_3.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_BIRD_BODIES_4.dat")
	
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_TEMP_UNIQUE_BIRDS_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_MAP_TILES_1.dat")
	_G.res.releaseSpriteSheet(self.imagePath .. self.imageProfile .. "/HATCHERY_MAP_OBJECTS_1.dat")
	
	_G.res.releaseCompoSpriteSet(self.imagePath .. self.imageProfile .. "/HATCHERY_composprites.dat")
	
	
	-- _G.res.createBitmapFont(self.fontPath .. self.fontProfile .. "/FONT_HATCHERY.dat")
	-- _G.res.createBitmapFont(self.fontPath .. self.fontProfile .. "/FONT_HATCHERY_NUMBERS.dat")
	
	-- BIRD SPECIALTIES
	-- _G.res.createAudio(self.audioPath .. "h_specialty_boost.mp3", "h_specialty_boost", true)
	-- _G.res.createAudio(self.audioPath .. "h_specialty_divide.mp3", "h_specialty_divide", true)
	-- _G.res.createAudio(self.audioPath .. "h_specialty_egg.mp3", "h_specialty_egg", true)
	-- _G.res.createAudio(self.audioPath .. "h_specialty_explosion.mp3", "h_specialty_explosion", true)
	-- _G.res.createAudio(self.audioPath .. "h_specialty_explosion2.mp3", "h_specialty_explosion2", true)
	-- _G.res.createAudio(self.audioPath .. "h_specialty_yell.mp3", "h_specialty_yell", true)
	-- _G.res.createAudio(self.audioPath .. "h_specialty_yell2.mp3", "h_specialty_yell2", true)
	-- END OF BIRD SPECIALTIES
	
	-- PAINTING
	-- for i = 1, 3 do
		-- _G.res.createAudio(self.audioPath .. "h_can_select_" .. i .. ".mp3", "h_can_select_" .. i, false)
	-- end
	-- _G.res.createAudio(self.audioPath .. "h_painting_loop.mp3", "h_painting_loop", true)	
	-- _G.res.createAudio(self.audioPath .. "h_bubble_bird.mp3", "h_bubble_bird", true)
	-- _G.res.createAudio(self.audioPath .. "h_bubble_disappears.mp3", "h_bubble_disappears", true)
	-- _G.res.createAudio(self.audioPath .. "h_bubble_appears.mp3", "h_bubble_appears", true)			
	-- _G.res.createAudio(self.audioPath .. "h_bird_jumps_in_1.mp3", "h_bird_jumps_in_1", true)
	-- _G.res.createAudio(self.audioPath .. "h_levelup_1.mp3", "h_levelup_1", true)
	-- _G.res.createAudio(self.audioPath .. "h_task_check.mp3", "h_task_check", true)
	-- _G.res.createAudio(self.audioPath .. "h_notification_1.mp3", "h_notification_1", true)
	-- _G.res.createAudio(self.audioPath .. "h_bird_hatched_popup.mp3", "h_bird_hatched_popup", true)
	-- _G.res.createAudio(self.audioPath .. "h_egg_timer.wav", "h_egg_timer", true)
	-- _G.res.createAudio(self.audioPath .. "h_egg_shaking_1.wav", "h_egg_shaking_1", true)
	-- _G.res.createAudio(self.audioPath .. "h_egg_shaking_2.wav", "h_egg_shaking_2", true)
	-- _G.res.createAudio(self.audioPath .. "hatchery_ambient.wav", "hatchery_ambient", true)
	-- _G.res.createAudio(self.audioPath .. "h_nest_building.wav", "h_nest_building", true)
	-- _G.res.createAudio(self.audioPath .. "h_egg_selected.wav", "h_egg_selected", true)
	-- _G.res.createAudio(self.audioPath .. "h_nest_selected.wav", "h_nest_selected", true)
	-- _G.res.createAudio(self.audioPath .. "h_background_music_1.wav", "h_background_music_1", false)
	-- _G.res.createAudio(self.audioPath .. "h_grind_star_1.wav", "h_grind_star_1", false)
	-- _G.res.createAudio(self.audioPath .. "h_grind_star_2.wav", "h_grind_star_2", false)
	-- _G.res.createAudio(self.audioPath .. "h_purchase.wav", "h_purchase", false)
	-- for i = 1, 13 do
		-- _G.res.createAudio(self.audioPath .. "h_bird_idle_" .. i .. ".wav", "h_bird_idle_" .. i, false)
	-- end
	-- for i = 1, 10 do
		-- _G.res.createAudio(self.audioPath .. "h_fanfare_" .. i .. ".wav", "h_fanfare_" .. i, false)
	-- end
	-- for i = 1, 4 do
		-- _G.res.createAudio(self.audioPath .. "h_no_" .. i .. ".wav", "h_no_" .. i, false)
	-- end
	-- for i = 1, 4 do
		-- _G.res.createAudio(self.audioPath .. "h_OK_" .. i .. ".wav", "h_OK_" .. i, false)
	-- end
	-- for i = 1, 4 do
		-- _G.res.createAudio(self.audioPath .. "h_marker_" .. i .. ".mp3", "h_marker_" .. i, false)
	-- end
	-- for i = 1, 4 do
		-- _G.res.createAudio(self.audioPath .. "h_egg_crack_" .. i .. ".mp3", "h_egg_crack_" .. i, false)
	-- end

end

function Hatchery:showIngameHatcheryMenu()
	if gamelua.g_hatcheryEnableBirdSelector ~= true then 
		return 
	end
	
	self.hatcheryVisible = true
	hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "BIRD_SELECTOR", from = "MAIN_MENU"})
	-- if self.currentRoot ~= nil then
		-- self.currentRoot:onEntry()		
	-- end
end

function Hatchery:openHatcheryIngameMenu()
	if self.currentRoot ~= nil then
		self.currentRoot:show()	
	end
end

function Hatchery:hideIngameHatcheryMenu()
	self.hatcheryVisible = false
end


function Hatchery:enter()
	gamelua.print("\n hatchery enter")
	--gamelua.releaseMenuAssets()
	-- gamelua.print(nil)
	
	
	
	
	self.hatcheryViewVisible = true
	self.hatcheryVisible = true
	
	self.stars = gamelua.settingsWrapper:getHatcheryStars()
	
	
	
	-- for debugging only
	-- if gamelua.keyHold["SHIFT"] then
		-- hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "BIRD_DESIGNER2", from = "MAIN_MENU"})
		-- hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "BIRD_DESIGNER", from = "MAIN_MENU"})
	if gamelua.keyHold["CONTROL"] then
		hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "BIRD_DESIGNER", from = "MAIN_MENU"})
	-- elseif gamelua.keyHold["CONTROL"] then
		-- hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "BIRD_SELECTOR", from = "MAIN_MENU"})
	elseif gamelua.keyHold["SHIFT"] then
		-- hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "NEST_DESIGNER", from = "MAIN_MENU"})
		hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "WORLD_VIEW", from = "MAIN_MENU"})
	else
		hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "WORLD_VIEW", from = "MAIN_MENU"})
		
	end
	
	self:getNestView():setInteractive(true)
	
	gamelua.print("\n nest view show \n")
	
	-- self:setRoot(hatchery.links["NEST_VIEW"].action)
	-- hatchery.links["NEST_VIEW"].action:onEntry()
	-- if self.currentRoot ~= nil then
		-- self.currentRoot:onEntry()
		
	-- end
	
	--TODO, this is classic specific code, find a way to keep it universal
	if gamelua.settingsWrapper:isAudioEnabled() then
		_G.res.stopAllAudio()
		-- _G.res.playAudio(gamelua.getAudioName("level_start_military"), 1, false)
		-- _G.res.playAudio("hatchery_ambient", 0.8, true, 7)
		-- _G.res.playAudio("h_background_music_1", 1, false)
		
		
		_G.res.playAudio(getHatcherySound("ambientMusic"), 1, true, 7)
		_G.res.playAudio(getHatcherySound("hatcheryLaunched"), 1, false)
		
		
	end
	
	
	gamelua.loadLuaFile("hatchery/scripts/hatcheryParticles.lua", "particleTable")
	
	
end

function Hatchery:quit()
	self.hatcheryVisible = false
	self.hatcheryViewVisible = false
	
	--temporary, just for testing sake
	-- self.mys = {}
	-- self.myNests = {}
	
	local currentStars = gamelua.settingsWrapper:getHatcheryStars()
	local addedStars = self.stars - currentStars
	gamelua.settingsWrapper:addHatcheryStars(addedStars)
	
	
	--TODO, this is classic specific code, find a way to keep it universal
	if gamelua.settingsWrapper:isAudioEnabled() then
		_G.res.stopAllAudio()
		_G.res.playAudio("title_theme", 0.8, true, 7)
	end
	
	gamelua.print("\n nest view out\n")
	--gamelua.saveLuaFileWrapper("settings.lua", "settings", true)
	
	--self:releaseAssets()
	--gamelua.loadMenuAssets()
	hatchery:getLink("WORLD_VIEW"):saveWorld()
	hatchery:getLink("WORLD_VIEW"):reset()
	gamelua.deinitializeTileManager()
end


function Hatchery:update(dt, time)
	if self.hatcheryVisible then
		MenuManager.update(self, dt, time) 	
	end
	-- Update nests even when Hatchery is not visible.
	for i = 1, #self.myNests do
		self.myNests[i]:update(dt, time)
	end
	
	
	-- Cheat all birds
	if gamelua.keyPressed["C"] then
		self.myBirds = {}
		for i = 1, #self.birds do
			_G.table.insert(self.myBirds, Bird:new(self.birds[i]))
		end
	end
	-- Reset all birds
	self.quadClickTimer = self.quadClickTimer - dt	

	if gamelua.keyPressed["LBUTTON"] then
		if self.quadClickTimer > 0 and gamelua.cursor.x < 60 and gamelua.cursor.y < 60 then
			self.quadClickCounter = self.quadClickCounter + 1
			self.quadClickTimer = 0.5
			if self.quadClickCounter >= 4 then
				self.quadClick = true
			end
		else
			self.quadClick = false
			self.quadClickTimer = 0.5
			self.quadClickCounter = 1
		end
	end
	
	if self.quadClick or gamelua.keyPressed["R"] then
		self.myBirds = {}
	end
	
end


-----------------------------
-- <Hatchery API-functions>
-----------------------------

function init(imageProfile, fontProfile, stars)
	
	hatchery = Hatchery:new({imageProfile = imageProfile, fontProfile = fontProfile, stars = stars})
	hatchery.hatcheryVisible = false
	
	--------- hatchery events Listener -----------
	hatcheryEventManager:addEventListener(hatcheryEvents.EID_HATCHERY_GOTO_EPISODE_SELECTION, hatcheryMenuListener)
	
	--------- Menu Manager -------	
	hatcheryEventManager:addEventListener(events.EID_CHANGE_SCENE, hatchery)
	hatcheryEventManager:addEventListener(events.EID_POP_FRAME, hatchery)
	hatcheryEventManager:addEventListener(events.EID_PUSH_FRAME, hatchery)
	hatcheryEventManager:addEventListener(events.EID_SET_MENU, hatchery)

	hatchery:loadAssets()
	
	hatchery.viewsInitialized = true
		
	hatchery:addLink("NEST_VIEW", NestView:new())
	hatchery:getLink("NEST_VIEW"):setHatchery(hatchery)
		
	hatchery:addLink("BIRD_DESIGNER2", BirdDesigner2:new())
	hatchery:getLink("BIRD_DESIGNER2"):setHatchery(hatchery)
		
	hatchery:addLink("BIRD_DESIGNER", BirdDesigner:new())
	hatchery:getLink("BIRD_DESIGNER"):setHatchery(hatchery)
		
	hatchery:addLink("NEST_DESIGNER", NestDesigner:new())
	hatchery:getLink("NEST_DESIGNER"):setHatchery(hatchery)
		
	hatchery:addLink("MATRIX_VIEW", MatrixView:new())
	hatchery:getLink("MATRIX_VIEW"):setHatchery(hatchery)
		
	if gamelua.g_hatcheryEnableBirdSelector == true then 
		hatchery:addLink("BIRD_SELECTOR", BirdSelector:new())
		hatchery:getLink("BIRD_SELECTOR"):setHatchery(hatchery)
	end
		
	hatchery:addLink("WORLD_VIEW", WorldView:new())
	hatchery:getLink("WORLD_VIEW"):setHatchery(hatchery)
	
	-- hatcheryEventManager:notify({id = events.EID_CHANGE_SCENE, target = "NEST_VIEW", from = "MAIN_MENU"})
	
	--initializes the task manager
	getTaskManagerInstance():setHatchery(hatchery)	
	getTaskManagerInstance():setupTaskBasedOnPlayerLevel()
	
end

-- Return all the needed information about active birds in a table.
function getSelectedBirds()
	return hatchery:getSelectedBirds()
end

function getBirds()
	return hatchery:getBirds()
end

function addStars(starAmount)
	hatchery:setStars(hatchery:getStars() + starAmount)
end

function getStars()
	return hatchery:getStars()
end


function update(dt, time)

	hatchery:update(dt, time)
	
	if gamelua.keyPressed["ESCAPE"] then
		g_returnEvent = "HATCHERY_RETURN"
	end	
	
	local returnEvent = g_returnEvent
	g_returnEvent = ""
	return returnEvent
	
end

function draw()
	if hatchery.hatcheryVisible then
		hatchery:draw()
	end
end

function enter()
	--THIS IS A HACK, UI.frame keeps track of how many onEntry calls have been performed, but for hatchery we created another instance of the menu manager to help
	-- integrate it into other projects. TODO: Move the entry count to the menu manager instead of the ui.Frame 

	hatchery.gameEntryCounts = gamelua.ui.Frame.entryCounts
	gamelua.ui.Frame.entryCounts = 0
	hatchery:enter()
end

function showIngameHatcheryMenu()
	hatchery:showIngameHatcheryMenu()
	
end

function hideIngameHatcheryMenu()
	hatchery:hideIngameHatcheryMenu()
	
end

function isHatcheryVisible()
	return hatchery.hatcheryVisible
	
end

function isHatcheryViewVisible()
	return hatchery.hatcheryViewVisible
end

function openHatcheryIngameMenu()
	hatchery:openHatcheryIngameMenu()
end

function getHatcheryInstance()
	return hatchery
end

function resetIngameBirdSelector()
	if hatchery.currentRoot ~= nil and hatchery.currentRoot.reset then
		hatchery.currentRoot:reset()		
	end
end



------------------------------
-- </Hatchery API-functions>
------------------------------



hatcheryMenuListener = {
	
	eventTriggered = function(o,event)
				
		if event.id == hatcheryEvents.EID_HATCHERY_GOTO_EPISODE_SELECTION then
			g_returnEvent = "HATCHERY_RETURN"
			--THIS IS A HACK, the ui.Frame keeps track of how many onEntry calls have been performed, but for hatchery we created another instance of the menu manager to help
			-- integrate it into other projects. TODO: Move the entry count to the menu manager instead of the ui.Frame 
	
			gamelua.ui.Frame.entryCounts = hatchery.gameEntryCounts
			hatchery:quit()
		end
		
	end
}

filename="hatchery.lua"
