package.path = package.path .. ";" .. rfr.gamepath() .. "/?.lua"
package.path = package.path .. ";" .. rfr.gamepath() .. "/scripts/?.lua"

beaver = require "beaver"
rfr = rfr or {}

require "properties"
config = {
	cam_zoom = 8,
	wpm = 0.05,
	text_scale = 1/12,
	dialogue_box_padding = 3,
	dialogue_wraplength = 800,
	interaction_box_padding = 4,
	button = {
		interaction = "X",
		move_left = "LEFT",
		move_right = "RIGHT"
	},

	base_character_move_animation_speed = 70
}
