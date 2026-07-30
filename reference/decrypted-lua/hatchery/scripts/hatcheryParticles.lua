-- variables for particles
scaleFactor = 2
featherSizeLarge = 1.35 * scaleFactor
featherSizeMedium = 0.5 * scaleFactor
featherSizeSmall = 0.1 * scaleFactor
lifeTimeRandom = 1
featherSpinSpeed = 5

particles = {
	birdHatchedPopup1 = {
		sprites = { "H_P_LEVEL_STAR_1", "H_P_LEVEL_STAR_2", "H_P_LEVEL_STAR_3"  },
		--animation = "lifeTime",
		sheet = "HATCHERY_ELEMENTS_2",
		minVel = -800,
		maxVel = 800,
		minAngleVel = -10,
		maxAngleVel = 10,
		minScaleBegin = 0.5,
		maxScaleBegin = 1,
		minScaleEnd = 1,
		maxScaleEnd = 2,
		lifeTime = 5,
		gravityX = 0,
		gravityY = 300,
	},
		birdHatchedPopup2 = {
		sprites = { "H_P_LEVEL_SMOKE_1", "H_P_LEVEL_SMOKE_2",},
		--animation = "lifeTime",
		sheet = "HATCHERY_ELEMENTS_2",
		minVel = -600,
		maxVel = 600,
		minAngleVel = -1,
		maxAngleVel = 1,
		minScaleBegin = 0.5,
		maxScaleBegin = 1.5,
		minScaleEnd = 0,
		maxScaleEnd = 0.2,
		lifeTime = 5,
		gravityX = 0,
		gravityY = 10,
	},
		birdHatchedPopup3 = {
		sprites = { "H_P_LEVEL_FEATHER_1", "H_P_LEVEL_FEATHER_2", "H_P_LEVEL_FEATHER_3", "H_P_LEVEL_FEATHER_4", "H_P_LEVEL_FEATHER_5" },
		--animation = "lifeTime",
		sheet = "HATCHERY_ELEMENTS_2",
		minVel = -400,
		maxVel = 400,
		minAngleVel = -7,
		maxAngleVel = 7,
		minScaleBegin = 1,
		maxScaleBegin = 1,
		minScaleEnd = 0.3,
		maxScaleEnd = 0.4,
		lifeTime = 5,
		gravityX = 0,
		gravityY = 60,
	},
}

filename="hatcheryParticles.lua"
