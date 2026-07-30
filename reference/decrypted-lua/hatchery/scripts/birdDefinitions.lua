Bird = {}

--this is the default "ordering" of the keys in the different bird tables. Can be used to iterate over keys in other tables. Written here because it is used in so many places
Bird.DefaultIndexes = {"RED", "BLUE","YELLOW", "BLACK", "WHITE", "GREEN", "BIGBROTHER", "ORANGE" }

Bird.SHAPE = { 	RED = "RED", 
				BLUE = "BLUE", 
				YELLOW = "YELLOW",
				BLACK = "BLACK",
				WHITE = "WHITE",
				GREEN = "GREEN",
				BIGBROTHER = "BIGBROTHER",
				ORANGE = "ORANGE"
				}
				
Bird.COLOR = {
		RED = "RED", 
		BLUE = "BLUE", 
		YELLOW = "YELLOW",
		BLACK = "BLACK",
		WHITE = "WHITE",
		GREEN = "GREEN",
		BIGBROTHER = "BIGBROTHER",
		ORANGE = "ORANGE"
		}
		
Bird.BEAK = {
		RED = "RED", 
		BLUE = "BLUE", 
		YELLOW = "YELLOW",
		BLACK = "BLACK",
		WHITE = "WHITE",
		GREEN = "GREEN",
		BIGBROTHER = "BIGBROTHER",
		ORANGE = "ORANGE"
		}
		
Bird.EYES = {
		RED = "RED", 
		BLUE = "BLUE", 
		YELLOW = "YELLOW",
		BLACK = "BLACK",
		WHITE = "WHITE",
		GREEN = "GREEN",
		BIGBROTHER = "BIGBROTHER",
		ORANGE = "ORANGE"
		}

Bird.Sprites = {}		

--create the actual spritenames for the bird. Naming convention is BIRD_BODY_<bodyshape>_<bodycolor>
Bird.Sprites.Body = {}
for k,v in _G.pairs(Bird.SHAPE) do
	Bird.Sprites.Body[v] = {}
	for kk,vv in _G.pairs(Bird.COLOR) do
		Bird.Sprites.Body[v][vv] = "BIRD_BODY_" .. v .. "_" .. vv
	end
end

--create rest of the birdsprites.

Bird.Sprites.Eyes = {}
for k,v in _G.pairs(Bird.EYES) do
	Bird.Sprites.Eyes[v] = "BIRD_EYES_" .. v .. "_NORMAL"
end

Bird.Sprites.Blink =  {}
for k,v in _G.pairs(Bird.EYES) do
	Bird.Sprites.Blink[v] = "BIRD_EYES_" .. v .. "_BLINK"
end

Bird.Sprites.Beaks ={}
for k,v in _G.pairs(Bird.BEAK) do
	Bird.Sprites.Beaks[v] = "BIRD_BEAK_" .. v .. "_NORMAL"
end

Bird.Sprites.BeaksYell = {}
for k,v in _G.pairs(Bird.BEAK) do
	Bird.Sprites.BeaksYell[v] = "BIRD_BEAK_" .. v .. "_OPEN"
end

--hacks (proper not yet present
Bird.Sprites.Blink["ORANGE"] = "BIRD_EYES_ORANGE_NORMAL"
Bird.Sprites.BeaksYell["ORANGE"] = "BIRD_BEAK_ORANGE_NORMAL"
--/hacks


-- hatcheryBirdItems["BODIES_VARIATIONS"] = { BIRD_BODY_BLACK = {"BIRD_BODY_BLACK_EXPL_1", "BIRD_BODY_BLACK_EXPL_2", "BIRD_BODY_BLACK_EXPL_3"}, BIRD_BODY_WHITE={"BIRD_BODY_WHITE_RELEASED"}}

Bird.Sprites.AccessoryTop = {"H_BIRD_ACCESSORY_TOP_HAT_1", "H_BIRD_ACCESSORY_TOP_HAT_2", "H_BIRD_ACCESSORY_TOP_INDIAN_1", "H_BIRD_ACCESSORY_TOP_SHERIFF_HAT", "H_BIRD_ACCESSORY_TOP_GRANDMA_HAT", "H_BIRD_ACCESSORY_TOP_TIEBOW_1", "H_TEMP_BIRD_BLUE_BLACK", "H_TEMP_BIRD_BLACK_YELLOW", "H_TEMP_BIRD_YELLOW_BLUE", "H_TEMP_BIRD_BLUE_YELLOW", "H_TEMP_BIRD_WHITE_BLACK"}
Bird.Sprites.AccessoryMiddle = {"H_BIRD_ACCESSORY_MIDDLE_GLASSES_1", "H_BIRD_ACCESSORY_MIDDLE_EYE_PATCH_1", "H_BIRD_ACCESSORY_MIDDLE_HEART_GLASSES", "H_BIRD_ACCESSORY_MIDDLE_SUN_GLASSES_1"}
Bird.Sprites.AccessoryBottom = {"H_BIRD_ACCESSORY_BOTTOM_MOUSTACHE_1", "H_BIRD_ACCESSORY_BOTTOM_DRESS_1"}

Bird.definitionsMapping = {RED="RedBird", BLUE="SmallBlueBird", YELLOW = "YellowBird", BLACK="BlackBird", WHITE="BasicBird2", GREEN="BoomerangBird", BIGBROTHER="RedBigBird", ORANGE="globeBird"}
Bird.ingameScaling = {RED=0.35, BLUE=0.35, YELLOW = 0.35, BLACK=0.35, WHITE=0.35, GREEN=0.35, BIGBROTHER=0.35}

Bird.BIRD_AMOUNT = 8

Bird.specialtySounds = 
{
	EXPLOSION = "h_specialty_explosion",
	DUMB_EXPLOSION = "h_specialty_explosion2",
	SPEED = "h_specialty_boost",
	EGG = "h_specialty_egg",
	DIVIDE = "h_specialty_divide",
	DUMB_YELL = { "h_specialty_yell", "h_specialty_yell2" }
}

filename="birdDefinitions.lua"
