TileObjectinstanceTypes ={}


RENDERQUEUE0 = 0
RENDERQUEUE1 = 1
RENDERQUEUE2 = 2
RENDERQUEUE3 = 3

TileObjectinstanceTypes["DEFAULT"] = 0
TileObjectinstanceTypes["COMPOSITE"] = 1

HatcheryObjectTypes ={}

HatcheryObjectTypes["EGG"]  = 1


HatcheryObjectTypes["EMPTYNEST"]  = 2
HatcheryObjectTypes["HATCHINGNEST"]  = 3
HatcheryObjectTypes["UNFINISHEDNEST"]  = 4
HatcheryObjectTypes["BIRD"]  = 5
hatcheryDynamicTemplates = {}

hatcheryDynamicTemplates["NEW_EGG"] = {

									price = 35,
	
									inventorySprite = "H_UI_OBJECT_EGG_1",
									sprites = {"H_GAME_OBJECT_EGG_1"},
									width=1,
									height=1,
									constructTime = 30,
									selectable = true,
									class = "egg",
									price = 20,
									--selectable = true,
									type = HatcheryObjectTypes["EGG"] ,
									requirement = HatcheryObjectTypes["EMPTYNEST"],
									renderQueue = RENDERQUEUE3
							}	

hatcheryDynamicTemplates["NEST"] = {

									price = 35,

									inventorySprite = "H_UI_OBJECT_NEST_1",
									sprites = {"H_GAME_OBJECT_NEST_1_TOP", "H_GAME_OBJECT_NEST_1_BOTTOM"},
									decorations = {"H_EXTRA_OBJECT_CONSTRUCTION_YARD_1", "H_EXTRA_OBJECT_CONSTRUCTION_YARD_2", "H_EXTRA_OBJECT_CONSTRUCTION_YARD_3", "H_EXTRA_OBJECT_CONSTRUCTION_YARD_4"},
									width=1,
									height=1,									
									selectable = true,
									collision = true,
									class = "nest",
									constructTime = 30,
									type = HatcheryObjectTypes["UNFINISHEDNEST"] ,
									readyType = HatcheryObjectTypes["EMPTYNEST"],
									instanceType=TileObjectinstanceTypes["COMPOSITE"],
									renderQueue = RENDERQUEUE3					
							}	
							
hatcheryDynamicTemplates["FLOWERPOT_1"] = {
									
									price = 10,
									removePrice = 5,
									removeTime = 2,
									
									inventorySprite = "H_UI_OBJECT_FLOWER_POT_1",
									sprites = {"H_GAME_OBJECT_FLOWER_POT_1"},
									width=1,
									height=1,
									selectable = true,
									removable = true,
									collision = true,
									movable = true,
									--type = HatcheryObjectTypes["EMPTYNEST"] ,
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],		
									renderQueue = RENDERQUEUE3,
									animation = {
										loop = true,
										speedMin = 0.5,
										speedMax = 1,
										animations = {
											{
												id = 26,--hatcheryAnimationID["H_WOBBLE_GENERIC_1"],
											},
										}
									}		
								}	
							
hatcheryDynamicTemplates["BIRD"] = {
									width=1,
									height=1,
									selectable = true,
									collision = true,
									
									type = HatcheryObjectTypes["BIRD"] ,
									class = "bird",
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],		
									renderQueue = RENDERQUEUE3
							}	
							
hatcheryDynamicTemplates["BEACHBALL_1"] = {
									
									price = 10,
									removePrice = 5,
									removeTime = 2,
									
									inventorySprite = "H_UI_OBJECT_BEACHBALL_1",
									sprites = {"H_GAME_OBJECT_BEACHBALL_1"},
									width=1,
									height=1,
									selectable = true,
									collision = true,
									removable = true,
									movable = true,
									--type = HatcheryObjectTypes["EMPTYNEST"] ,
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],		
									renderQueue = RENDERQUEUE3,
									animation = {
										loop = true,
										speedMin = 0.5,
										speedMax = 1,
										animations = {
											{
												id = 26,--hatcheryAnimationID["H_WOBBLE_GENERIC_1"],
											},
										}
									}
								}

hatcheryDynamicTemplates["FOOTBALL_1"] = {
									
									price = 10,
									removePrice = 5,
									removeTime = 2,
									
									inventorySprite = "H_UI_OBJECT_FOOTBALL_1",
									sprites = {"H_GAME_OBJECT_FOOTBALL_1"},
									width=1,
									height=1,
									selectable = true,
									collision = true,
									removable = true,
									movable = true,
									--type = HatcheryObjectTypes["EMPTYNEST"] ,
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],
									renderQueue = RENDERQUEUE3,
									animation = {
										loop = true,
										speedMin = 0.5,
										speedMax = 1,
										animations = {
											{
												id = 26,--hatcheryAnimationID["H_WOBBLE_GENERIC_1"],
											},
										}
									}
								}								

hatcheryDynamicTemplates["SWIMRING_1"] = {
									
									price = 10,
									removePrice = 5,
									removeTime = 2,
									
									inventorySprite = "H_UI_OBJECT_SWIMMING_RING_1",
									sprites = {"H_GAME_OBJECT_SWIMMING_RING_1"},
									width=1,
									height=1,
									selectable = true,
									collision = true,
									removable = true,
									movable = true,
									--type = HatcheryObjectTypes["EMPTYNEST"] ,
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],
									renderQueue = RENDERQUEUE3,
									animation = {
										loop = true,
										speedMin = 0.5,
										speedMax = 1,
										animations = {
											{
												id = 26,--hatcheryAnimationID["H_WOBBLE_GENERIC_1"],
											},
										}
									}
								}

hatcheryDynamicTemplates["YARN_1"] = {
									
									price = 10,
									removePrice = 5,
									removeTime = 2,
									
									inventorySprite = "H_UI_OBJECT_YARN_1",
									sprites = {"H_GAME_OBJECT_YARN_1"},
									width=1,
									height=1,
									selectable = true,
									collision = true,
									removable = true,
									movable = true,
									--type = HatcheryObjectTypes["EMPTYNEST"] ,
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],
									renderQueue = RENDERQUEUE3,
									animation = {
										loop = true,
										speedMin = 0.5,
										speedMax = 1,
										animations = {
											{
												id = 26,--hatcheryAnimationID["H_WOBBLE_GENERIC_1"],
											},
										}
									}
								}								
															
hatcheryDynamicTemplates["WATERINGCAN_1"] = {
									
									price = 10,
									removePrice = 5,
									removeTime = 2,
									
									inventorySprite = "H_UI_OBJECT_WATERING_CAN_1",
									sprites = {"H_GAME_OBJECT_WATERING_CAN_1"},
									width=1,
									height=1,
									selectable = true,
									collision = true,
									removable = true,
									movable = true,
									--type = HatcheryObjectTypes["EMPTYNEST"] ,
									--instanceType=TileObjectinstanceTypes["COMPOSITE"],
									renderQueue = RENDERQUEUE3,
									animation = {
										loop = true,
										speedMin = 0.5,
										speedMax = 1,
										animations = {
											{
												id = 26,--hatcheryAnimationID["H_WOBBLE_GENERIC_1"],
											},
										}
									}
								}	
filename="hatcheryDynamicTemplateObjects.lua"
