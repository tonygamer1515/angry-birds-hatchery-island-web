-- Map IDs to names for better readability
hatcheryAnimationID = {}

hatcheryAnimationID["HATCHERY_ANIMATION_FLIP"] = 1
hatcheryAnimationID["HATCHERY_ANIMATION_JUMP"] = 2
hatcheryAnimationID["HATCHERY_ANIMATION_SCALETEST"] = 3
hatcheryAnimationID["H_SWAYING_SLOW_1"] = 4
hatcheryAnimationID["H_NEST_INPROGRESS_1"] = 17
hatcheryAnimationID["H_WAVE_MOVE_1"] = 18 
hatcheryAnimationID["H_WAVE_SCALE_1"] = 19 
hatcheryAnimationID["H_WAVE_BLINK_1"] = 20 
hatcheryAnimationID["H_WAVE_BLINK_2"] = 21 
hatcheryAnimationID["H_WAVE_BLINK_3"] = 22 
hatcheryAnimationID["H_WAVE_BLINK_ROTATE_1"] = 23
hatcheryAnimationID["H_WAVE_BLINK_ROTATE_2"] = 24
hatcheryAnimationID["H_WAVE_BLINK_ROTATE_3"] = 25
hatcheryAnimationID["H_WOBBLE_GENERIC_1"] = 26 -- Latest. Change this comment always to the latest added animation.

-- Egg Animations
hatcheryAnimationID["H_EGG_INPROGRESS_1"] = 16 
hatcheryAnimationID["H_EGG_IDLE_1"] = 5
hatcheryAnimationID["H_EGG_IDLE_2"] = 6
hatcheryAnimationID["H_EGG_IDLE_3"] = 7


-- Bird Animations
hatcheryAnimationID["H_RED_BIRD_IDLE_1"] = 8
hatcheryAnimationID["H_BLUE_BIRD_IDLE_1"] = 9
hatcheryAnimationID["H_YELLOW_BIRD_IDLE_1"] = 10
hatcheryAnimationID["H_BLACK_BIRD_IDLE_1"] = 11
hatcheryAnimationID["H_WHITE_BIRD_IDLE_1"] = 12
hatcheryAnimationID["H_GREEN_BIRD_IDLE_1"] = 13
hatcheryAnimationID["H_BIGBROTHER_BIRD_IDLE_1"] = 14
hatcheryAnimationID["H_ORANGE_BIRD_IDLE_1"] = 15


-- Formula for converting degrees to radians
gradToRad = 3.14159265 / 180


-- Define frames for animations
hatcheryAnimations = {}
hatcheryAnimations["HATCHERY_ANIMATION_FLIP"] =
{
			anchor = {0.5,0.5},
			frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation=0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation=6.2831853
			},
		}
}


hatcheryAnimations["HATCHERY_ANIMATION_JUMP"] =
{
	frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation=0,
				easing = 1
			},
			{
				time = 0.5,
				x = 0,
				y = 60,
				scaleX = 1,
				scaleY = 1,
				rotation=0,
				easing = -1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation=0,
				easing = 0
			},
		}
}

hatcheryAnimations["HATCHERY_ANIMATION_SCALETEST"] =
{
	anchor = {0.5,0.5},
	frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 0.7,
				rotation=0,
				easing = 1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1.2,
				scaleY = 1.2,
				rotation=0,
				easing = -1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 0.7,
				rotation=0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_SWAYING_SLOW_1"] =
{
			anchor = {0.5, 1},
			
			frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 3 * gradToRad,
				easing = -1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 3,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -3 * gradToRad,
				easing = -1
			},
			{
				time = 4,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = -1
			},
		}
}

hatcheryAnimations["H_NEST_INPROGRESS_1"] =
{
		anchor = {0.5, 0.8},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1.01,
				scaleY = 1.01,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1.02,
				scaleY = 1.02,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1.01,
				scaleY = 1.01,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_EGG_INPROGRESS_1"] =
{
		anchor = {0.5, 1},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 1.05,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1.1,
				scaleY = 1.1,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 1.05,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_EGG_IDLE_1"] =
{
		anchor = {0.5, 1},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -5 * gradToRad,
				easing = 1
			},
			{
				time = 0.1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 5 * gradToRad,
				easing = 0
			},
			{
				time = 0.2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -5 * gradToRad,
				easing = 0
			},
			{
				time = 0.3,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 5 * gradToRad,
				easing = 0
			},
			{
				time = 0.4,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -2 * gradToRad,
				easing = 0
			},
			{
				time = 1.8,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -2 * gradToRad,
				easing = 0
			},
			{
				time = 1.9,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 5 * gradToRad,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -5 * gradToRad,
				easing = 0
			},
			{
				time = 2.1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 5 * gradToRad,
				easing = 0
			},
			{
				time = 2.2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 2 * gradToRad,
				easing = 0
			},
			{
				time = 4.0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 2 * gradToRad,
				easing = 0
			},
			{
				time = 4.1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -2 * gradToRad,
				easing = 0
			},
			{
				time = 4.2,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 5 * gradToRad,
				easing = 1
			},
			{
				time = 4.3,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -5 * gradToRad,
				easing = 0
			},
			{
				time = 4.4,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 3 * gradToRad,
				easing = 0
			},
			{
				time = 4.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -5 * gradToRad,
				easing = 0
			},
			{
				time = 7,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = -5 * gradToRad,
				easing = 0
			},
		}
}

hatcheryAnimations["H_EGG_IDLE_2"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 360 * gradToRad,
				easing = 0
			},
		}
}

hatcheryAnimations["H_EGG_IDLE_3"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 360 * gradToRad,
				easing = 0
			},
		}
}

hatcheryAnimations["H_RED_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_BLUE_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_YELLOW_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_BLACK_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WHITE_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_GREEN_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_BIGBROTHER_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_ORANGE_BIRD_IDLE_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.95,
				scaleY = 1.05,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 1.05,
				scaleY = 0.95,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_SCALE_1"] =
{
		anchor = {0.5, 1.25},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 0.5,
				scaleY = 0,
				rotation = 0,
				easing = 1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0.5,
				scaleY = 0.5,
				rotation = 0,
				easing = -1
			},
			{
				time = 2,
				x = 0,
				y = 0,
				scaleX = 0.5,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
			{
				time = 5,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_MOVE_1"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 1,
				x = 25,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 2,
				x = 50,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 5,
				x = 50,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_BLINK_1"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 1
			},
			{
				time = 0.75,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
			{
				time = 6,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_BLINK_2"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = -1
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
			{
				time = 5,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_BLINK_3"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 1
			},
			{
				time = 0.25,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
			{
				time = 3.5,
				x = 0,
				y = 0,
				scaleX = 0,
				scaleY = 0,
				rotation = 0,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_BLINK_ROTATE_1"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 0.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 360 * gradToRad,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_BLINK_ROTATE_2"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 1.5,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 360 * gradToRad,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WAVE_BLINK_ROTATE_3"] =
{
		anchor = {0.5, 0.5},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 0
			},
			{
				time = 1,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 360 * gradToRad,
				easing = 0
			},
		}
}

hatcheryAnimations["H_WOBBLE_GENERIC_1"] =
{
		anchor = {0.5, 0.95},
			
		frames = {
			{
				time = 0,
				x = 0,
				y = 0,
				scaleX = 1.02,
				scaleY = 0.98,
				rotation = 0,
				easing = -1
			},
			{
				time = 0.35,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 0.7,
				x = 0,
				y = 0,
				scaleX = 0.98,
				scaleY = 1.02,
				rotation = 0,
				easing = -1
			},
			{
				time = 1.05,
				x = 0,
				y = 0,
				scaleX = 1,
				scaleY = 1,
				rotation = 0,
				easing = 1
			},
			{
				time = 1.4,
				x = 0,
				y = 0,
				scaleX = 1.02,
				scaleY = 0.98,
				rotation = 0,
				easing = 0
			},
		}
}
filename="hatcheryAnimations.lua"
