g_challenges = {
	------------------------------
	-- Challenge 1. --------------
	------------------------------
	{
		id = "CHALLENGE_BIRD_FLOCK_1",
		type = "BIRD_FLOCK",
		name = "Join the Flock!",
		calculateScore = false,
		reward = 25,
		description = "Finish these levels with pre-set selection of birds",		
		levels = {{name = "Level53"}, {name = "Level3"}, {name = "Level6"}}, 
		unlockCondition = {date = {d = 10, m = 10, y = 2011}},
		
		shotsQueue = {
			{YellowBird = 1 },
			{RedBird = 2},
			{YellowBird = 1 },			
		},
	},
	
	------------------------------
	-- Challenge 2. --------------
	------------------------------
	{
		id = "CHALLENGE_BIRD_FLOCK_2",
		type = "BIRD_FLOCK",
		name = "Bomb It Up",
		calculateScore = false,
		reward = 25,
		description = "Finish these levels with pre-set selection of birds",		
		levels = {{name = "Level2"}, {name = "Level4"}, {name = "Level5"}}, 
		unlockCondition = {date = {d = 10, m = 10, y = 2011}},
		
		shotsQueue = {
			{BasicBird2 = 1 },
			{YellowBird = 1},
			{RedBird = 1},
			{BasicBird2 = 1 },			
		},
	},
	
	------------------------------
	-- Challenge 3. --------------
	------------------------------
	{
		id = "CHALLENGE_BIRD_FLOCK_3",
		type = "BIRD_FLOCK",
		name = "Instant Gratification",
		calculateScore = false,
		reward = 25,
		description = "Finish these levels with pre-set selection of birds",		
		levels = {{name = "Level7"}, {name = "Level8"}, {name = "Level9"}}, 
		unlockCondition = {date = {d = 10, m = 10, y = 2011}},
		
		shotsQueue = {
			{RedBird = 1 },
			{BoomerangBird = 2 },
			{RedBird = 1 },
				
		},
	},

	------------------------------
	-- Challenge 3. --------------
	------------------------------
	{
		id = "CHALLENGE_BIRD_FLOCK_5",
		type = "BIRD_FLOCK",
		name = "Instant Gratification",
		calculateScore = false,
		reward = 25,
		description = "Finish these levels with pre-set selection of birds",		
		levels = {{name = "Level7"}, {name = "Level8"}, {name = "Level9"}}, 
		unlockCondition = {date = {d = 13, m = 11, y = 2011}},
		
		shotsQueue = {
			{RedBird = 1 },
			{BoomerangBird = 2 },
			{RedBird = 1 },
				
		},
	},

}


filename="challenges.lua"
