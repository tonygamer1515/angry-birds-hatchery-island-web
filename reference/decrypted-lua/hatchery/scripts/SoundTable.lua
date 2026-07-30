function getHatcherySound(soundName)
	if hatcherySoundTable[soundName] == nil then
		gamelua.print("\n can't find hatchery sound name: " .. soundName)
		gamelua.print(nil)
		return
	end
	local index = _G.math.random(1,#hatcherySoundTable[soundName])
	local sound = hatcherySoundTable[soundName][index]
	return sound
end

hatcherySoundTable = {}

-- BIRDS
hatcherySoundTable["birdIdle"] = {"h_bird_idle_1", "h_bird_idle_2", "h_bird_idle_3", "h_bird_idle_4", "h_bird_idle_5", "h_bird_idle_6", "h_bird_idle_7", "h_bird_idle_8", "h_bird_idle_9", "h_bird_idle_10", "h_bird_idle_11", "h_bird_idle_12" }
hatcherySoundTable["birdIdleMuffled"] = {"h_egg_mumble_1", "h_egg_mumble_2", "h_egg_mumble_3" }

-- PURCHASES
hatcherySoundTable["starsBought"] = {"h_purchase"}
hatcherySoundTable["moneySpent"] = {"h_purchase"}
hatcherySoundTable["notEnoughMoney"] = {"h_OK_3"}
hatcherySoundTable["buyStarsClicked"] = {"h_OK_3"}

-- MUSIC / AMBIENT
hatcherySoundTable["ambientMusic"] = {"abi_ambience_2"}
hatcherySoundTable["hatcheryLaunched"] = {"h_fanfare_6"}

-- NEST
hatcherySoundTable["emptyNestClicked"] = {"h_OK_3"}
hatcherySoundTable["nestAppears"] = {"h_nest_selected"}
hatcherySoundTable["buildingNestAmbient"] = {"h_nest_building"}
hatcherySoundTable["nestFinished"] = {"h_fanfare_9"}

-- EGG
hatcherySoundTable["buildingEggAmbient"] = {"h_egg_timer"}
hatcherySoundTable["eggAppears"] = {"h_egg_selected"}
hatcherySoundTable["eggFinished"] = {"h_fanfare_9"}
hatcherySoundTable["shakingEgg"] = {"h_egg_shaking_2", "h_egg_shaking_1" }
hatcherySoundTable["eggCracking"] = {"h_egg_crack_1", "h_egg_crack_2", "h_egg_crack_3", "h_egg_crack_4"}
hatcherySoundTable["unhatchedEggClicked"] = {"h_OK_1"}

-- HATCHING
hatcherySoundTable["eggHatched"] = {"h_egg_selected" }
hatcherySoundTable["hatchDialog_BirdReady"] = {"h_bird_jumps_in_1"}
hatcherySoundTable["hatchDialog_close"] = {"h_bird_idle_1"}

-- UI SOUNDS
hatcherySoundTable["emptySlotClicked"] = {"h_OK_3"}
hatcherySoundTable["hurryButton"] = {"h_OK_4"}
hatcherySoundTable["matrixButton"] = {"h_OK_3"}
hatcherySoundTable["accesoriesButton"] = {"h_OK_3"}
hatcherySoundTable["accessoryClicked"] = {"h_OK_1"}
hatcherySoundTable["cancel"] = {"h_no_4"}
hatcherySoundTable["ok"] = {"h_OK_3"}

-- TASKS / LEVEL UP / NOTIFICATIONS
hatcherySoundTable["taskScreenEntryAdded"] = {"h_OK_1"}
hatcherySoundTable["taskScreenEntryRemoved"] = {"h_notification_1"}
hatcherySoundTable["taskNotificationAppears"] = {"h_notification_1"}
hatcherySoundTable["taskNotificationCheck"] = {"h_task_check"}
hatcherySoundTable["levelUp"] = {"h_levelup_1"}

-- PAINTING
hatcherySoundTable["canSelect"] = {"h_can_select_1", "h_can_select_2", "h_can_select_3"}
hatcherySoundTable["paintingLoop"] = {"h_painting_loop"}
hatcherySoundTable["bubbleAppearing"] = {"h_bubble_appears"}
hatcherySoundTable["bubbleDisappearing"] = {"h_bubble_disappears"}
hatcherySoundTable["newBirdAppearing"] = {"h_bubble_bird"}

-- WORLD
hatcherySoundTable["inventoryObjectMouseDown"] = {"abi_inventory_place"}
hatcherySoundTable["inventoryObjectWorldRelease"] = {"abi_inventory_move"}
hatcherySoundTable["contextMenuOK"] = {"h_OK_3"}
hatcherySoundTable["contextMenuCancel"] = {"h_no_4"}
hatcherySoundTable["contextMenuMove"] = {"h_OK_3"}
hatcherySoundTable["objectClick"] = {"h_OK_3"}
hatcherySoundTable["nestBuilding"] = {"h_nest_building"}
hatcherySoundTable["quickActionButton"] = {"abi_hurry"} -- quick build/hatch
hatcherySoundTable["starCoinSpent"] = {"h_purchase"}
hatcherySoundTable["starSpent"] = {"h_purchase"}
hatcherySoundTable["eggBuilding"] = {"h_egg_timer"}
hatcherySoundTable["eggCrackingTap"] = {"h_egg_crack_1", "h_egg_crack_2", "h_egg_crack_3", "h_egg_crack_4"}
hatcherySoundTable["worldNestReady"] = {"abi_nest_ready"}
hatcherySoundTable["worldEggReady"] = {"abi_nest_ready"}
hatcherySoundTable["worldObjectRemoved"] = {"abi_remove_item"}




filename="SoundTable.lua"
