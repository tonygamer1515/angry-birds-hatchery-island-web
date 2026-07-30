--------------------------
-- EPISODE 1
--------------------------

pack1_intro =
{
	{ time = 0.0, action = "fitheight", image = "STORY_1_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_1_BEGINNING", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_1_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 9.6, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 15.6, action = "end", },
}

world1_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_1_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_1_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_1_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world2_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_1_MIDDLE_2", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_1_MIDDLE_2", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_1_MIDDLE_2", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world3_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_1_END", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_1_END", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_outro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_1_END", x = 0, y = 0, z = 0, },
	{ time = 2.5, action = "scroll", duration = 5.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 8.0, action = "createsprite", name = "eye", image = "KINGPIG_EYE_2", x = 0, y = 0, z = 1, },
	{ time = 9.0, action = "createsprite", name = "eye", image = "KINGPIG_EYE_3", x = 0, y = 0, z = 1, },
	{ time = 10.3, action = "createsprite", name = "eye", image = "KINGPIG_EYE_4", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "createsprite", name = "eye", image = "KINGPIG_EYE_3", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "playsound", sound = "piglette_oink_story", loop = false, volume = 1.0, track = 0, },
	{ time = 12.5, action = "end", },
}

--------------------------
-- EPISODE 2
--------------------------

pack2_intro =
{
	{ time = 0.0, action = "fitheight", image = "STORY_2_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_2_BEGINNING", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_2_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 4.0, action = "scroll", duration = 8.6, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 15.6, action = "end", },
}

world4_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_2_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_2_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_2_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world5_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_2_END", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_2_END", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_outro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_2_END", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 5.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 9.5, action = "createsprite", name = "eye", image = "KING_EYE_HOAX_2", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "deletesprite", name = "eye", },
	{ time = 11.5, action = "createsprite", name = "eye", image = "KING_EYE_HOAX_4", x = 0, y = 0, z = 1, },
	{ time = 11.7, action = "deletesprite", name = "eye", },
	{ time = 12.5, action = "createsprite", name = "eye", image = "KING_EYE_HOAX_3", x = 0, y = 0, z = 1, },
	{ time = 12.5, action = "playsound", sound = "piglette_oink_story", loop = false, volume = 1.0, track = 0, },
	{ time = 14.7, action = "end", },
}

--------------------------
-- EPISODE 3
--------------------------

pack3_intro =
{
	{ time = 0.0, action = "set_bg_colour", r = 14, g = 212, b = 255, },
	{ time = 0.0, action = "fitwidth", image = "STORY_3_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_3_BEGINNING", width = 1024, height = 1369 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_3_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 0.0, action = "set_scroll_position", scroll_cursor = { x = 0.0, y = 1.0 }, scroll_target = { type = "sprite", sprite = "background", x = 0.0, y = 1.0 }, },
	{ time = 4.0, action = "scroll", duration = 9.9, type = "cubic_in_out", scroll_cursor = { x = 0.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 0.0, y = 0.0 }, },
	{ time = 16.0, action = "end", },
}

world6_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_3_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_3_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_3_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world7_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_3_MIDDLE_2", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_3_MIDDLE_2", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_3_MIDDLE_2", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world8_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_3_END", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_3_END", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_outro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_3_END", x = 0, y = 0, z = 0, },
	{ time = 0.0, action = "createsprite", name = "eye", image = "KING_EYE_1", x = 0, y = 0, z = 1, },
	{ time = 3.5, action = "scroll", duration = 3.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "createsprite", name = "eye", image = "KING_EYE_2", x = 0, y = 0, z = 1, },
	{ time = 9.0, action = "createsprite", name = "eye", image = "KING_EYE_1", x = 0, y = 0, z = 1, },
	{ time = 10.0, action = "createsprite", name = "eye", image = "KING_EYE_3", x = 0, y = 0, z = 1, },
	{ time = 10.3, action = "createsprite", name = "eye", image = "KING_EYE_1", x = 0, y = 0, z = 1, },
	{ time = 11.0, action = "playsound", sound = "piglette_oink_story", loop = false, volume = 1.0, track = 0, },
	{ time = 13.0, action = "end", },
}

--------------------------
-- EPISODE 4
--------------------------

pack4_intro =
{
	{ time = 0.0, action = "fitheight", image = "STORY_4_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_4_BEGINNING", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_4_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 4.0, action = "scroll", duration = 9.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 0.822, y = 0.0 }, },
	{ time = 16.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0, }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 18.7, action = "playsound", sound = "big_brother_awakens", loop = false, volume = 1.0, track = 7 },
	{ time = 21.7, action = "end", },
}

world9_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_4_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_4_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_4_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world10_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_4_MIDDLE_2", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_4_MIDDLE_2", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_4_MIDDLE_2", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world11_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_4_END", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_4_END", width = 1325, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_outro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_4_END", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "createsprite", name = "eye", image = "KING_EYE_CAGE_2", x = 0, y = 0, z = 1, },
	{ time = 8.5, action = "createsprite", name = "eye", image = "KING_EYE_CAGE_3", x = 0, y = 0, z = 1, },
	{ time = 9.5, action = "createsprite", name = "eye", image = "KING_EYE_CAGE_2", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "deletesprite", name = "eye", },
	{ time = 10.5, action = "playsound", sound = "piglette_oink_story", loop = false, volume = 1.0, track = 0, },
	{ time = 10.7, action = "createsprite", name = "eye", image = "KING_EYE_CAGE_2", x = 0, y = 0, z = 1, },
	{ time = 12.3, action = "end", },
}

--------------------------
-- EPISODE 5
--------------------------

pack5_intro =
{
	{ time = 0.0, action = "fitheight", image = "STORY_5_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_5_BEGINNING", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_5_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 4.5, action = "scroll", duration = 9.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 15.6, action = "end", },
}

world12_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_5_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_5_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_5_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world13_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_5_MIDDLE_2", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_5_MIDDLE_2", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_5_MIDDLE_2", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world14_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_5_END", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_5_END", width = 1325, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_outro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_5_END", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "createsprite", name = "eye", image = "SOMBRERO_PIG_EYE_3", x = 0, y = 0, z = 1, },
	{ time = 8.5, action = "createsprite", name = "eye", image = "SOMBRERO_PIG_EYE_2", x = 0, y = 0, z = 1, },
	{ time = 9.5, action = "createsprite", name = "eye", image = "SOMBRERO_PIG_EYE_3", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "createsprite", name = "eye", image = "SOMBRERO_PIG_EYE_4", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "playsound", sound = "piglette_oink_story", loop = false, volume = 1.0, track = 0, },
	{ time = 10.7, action = "createsprite", name = "eye", image = "SOMBRERO_PIG_EYE_3", x = 0, y = 0, z = 1, },
	{ time = 12.3, action = "end", },
}

--------------------------
-- EPISODE 6
--------------------------

pack6_intro =
{
	{ time = 0.0, action = "fitheight", image = "STORY_6_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_6_BEGINNING", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_6_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 4.5, action = "scroll", duration = 8.6, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 15.6, action = "end", },
}

world15_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_6_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_6_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_6_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world16_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_6_MIDDLE_2", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_6_MIDDLE_2", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_6_MIDDLE_2", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

world17_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_6_END", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_6_END", width = 1325, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_outro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_6_END", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "createsprite", name = "eye", image = "KINGPIG_EYE3", x = 0, y = 0, z = 1, },
	{ time = 8.5, action = "createsprite", name = "eye", image = "KINGPIG_EYE4", x = 0, y = 0, z = 1, },
	{ time = 9.5, action = "createsprite", name = "eye", image = "KINGPIG_EYE3", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "createsprite", name = "eye", image = "KINGPIG_EYE2", x = 0, y = 0, z = 1, },
	{ time = 10.5, action = "playsound", sound = "piglette_oink_story", loop = false, volume = 1.0, track = 0, },
	{ time = 10.8, action = "createsprite", name = "eye", image = "KINGPIG_EYE3", x = 0, y = 0, z = 1, },
	
	{ time = 12.9, action = "end", },
}

--------------------------
-- EPISODE 6
--------------------------

pack7_intro =
{
	{ time = 0.0, action = "fitheight", image = "STORY_7_BEGINNING", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_7_BEGINNING", width = 2048, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_intro", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_7_BEGINNING", x = 0, y = 0, z = 0, },
	{ time = 4.5, action = "scroll", duration = 8.6, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 15.6, action = "end", },
}

world18_complete =
{
	{ time = 0.0, action = "fitheight", image = "STORY_7_MIDDLE_1", },
	{ time = 0.0, action = "setreferencesize", image = "STORY_7_MIDDLE_1", width = 1438, height = 659 },
	{ time = 0.0, action = "playsound", sound = "birds_boss", loop = false, volume = 1.0, track = 1, },
	{ time = 0.0, action = "createsprite", name = "background", image = "STORY_7_MIDDLE_1", x = 0, y = 0, z = 0, },
	{ time = 3.5, action = "scroll", duration = 2.0, type = "cubic_in_out", scroll_cursor = { x = 1.0, y = 0.0 }, scroll_target = { type = "sprite", sprite = "background", x = 1.0, y = 0.0 }, },
	{ time = 7.5, action = "end", },
}

filename="cutscenes.lua"
