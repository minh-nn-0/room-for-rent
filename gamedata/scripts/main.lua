ASSETS = {}
MAPS = {}
local gamestate
function LOAD()
	beaver.set_render_logical_size(config.render_size[1], config.render_size[2])
	beaver.set_integer_scale(true)
	rfr.set_cam_smooth_speed(10)
	rfr.set_cam_zoom(config.cam_zoom)
	beaver.set_render_blend_mode("blend")
	beaver.allocate_sound_channels(32)
	beaver.set_texture_blend_mode(ASSETS.images.light, "additive")
	beaver.set_volume_sound(ASSETS.audios.creepy_atmosphere, 30)
	beaver.set_volume_sound(ASSETS.audios.ghosthowling, 50)
	MAPS = {
		room = rfr.new_map(rfr.gamepath() .. "data/maps/rfr_room2.tmj"),
		room_before = rfr.new_map(rfr.gamepath() .. "data/maps/rfr_room_before2.tmj"),
		room_dream = rfr.new_map(rfr.gamepath() .. "data/maps/rfr_room_dream.tmj"),
		hall = rfr.new_map(rfr.gamepath() .. "data/maps/hall2.tmj"),
		outside = rfr.new_map(rfr.gamepath() .. "data/maps/outside.tmj"),
		balcony = rfr.new_map(rfr.gamepath() .. "data/maps/behind1.tmj"),
	}
	gamestate = require "gamestate"
	gamestate.load()
end
function UPDATE(dt)
	return gamestate.update(dt)
end

function DRAW()
	return gamestate.draw()
end
