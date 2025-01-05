package.path = package.path .. ";" .. rfr.gamepath() .. "/?.lua"
package.path = package.path .. ";" .. rfr.gamepath() .. "/luamodules/?.lua"
package.path = package.path .. ";" .. rfr.gamepath() .. "/scripts/?.lua"

beaver = require "beaver"
rfr = rfr or {}

require "luamodules.properties"
require "luamodules.gameflags"
require "luamodules.dialogue"
require "luamodules.character"
require "luamodules.camera"
require "luamodules.interaction"
require "luamodules.transition"
require "luamodules.map"
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
	base_character_move_animation_speed = 70,
	language = "en",
}
