config = {
	render_size = {640, 360},
	cam_zoom = 4,
	cpf = 40,
	text_scale = 1/4,
	dialogue_font = "unifont",
	ui_font = "unifont",
	narrative_cpf = 50,
	narrative_wait_time = 2,
	dialogue_wait_time = 1,
	dialogue_box_padding = 3,
	dialogue_wraplength = 200,
	interaction_box_padding = 3,
	default_dialogue_sound = "dialogue1",
	button = {
		interaction = "X",
		back = "Z",
		move_left = "LEFT",
		move_right = "RIGHT"
	},
	base_character_move_animation_speed = 80,
	language = "vi",
	current_main_character = 'male'
}

package.path = package.path .. ";" .. rfr.gamepath() .. "?.lua"
package.path = package.path .. ";" .. rfr.gamepath() .. "luamodules/?.lua"
package.path = package.path .. ";" .. rfr.gamepath() .. "scripts/?.lua"

beaver = require "beaver"
rfr = rfr or {}

require "luamodules.properties"
require "luamodules.gameflags"
require "luamodules.dialogue"
require "luamodules.character"
require "luamodules.camera"
require "luamodules.interaction"
require "luamodules.transition"
require "luamodules.narrative"
require "luamodules.gametime"
require "luamodules.map"
