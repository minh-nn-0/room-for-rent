local gamestate = require "gamestate"
function LOAD()
	beaver.set_render_logical_size(1280, 720)
	rfr.set_cam_smooth_speed(6)
	rfr.set_cam_zoom(config.cam_zoom)

	beaver.new_image(rfr.gamepath() .. "assets/images/tileset.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/male_shirt.png", "male_shirt")
	beaver.new_image(rfr.gamepath() .. "assets/images/girl2.png", "girl")
	beaver.new_image(rfr.gamepath() .. "assets/images/woman_2.png", "woman")
	beaver.new_image(rfr.gamepath() .. "assets/images/neighbor.png", "neighbor")
	beaver.new_image(rfr.gamepath() .. "assets/images/ghost.png", "ghost")
	beaver.new_image(rfr.gamepath() .. "assets/images/UI.png", "UI")

	beaver.new_font(rfr.gamepath() .. "assets/fonts/inconsolata.ttf", 64, "inconsolata")

	rfr.new_map("room", rfr.gamepath() .. "data/maps/rfr_room.tmj")
	rfr.new_map("hall", rfr.gamepath() .. "data/maps/hall.tmj")

	gamestate.load()
end

function UPDATE(dt)
	return gamestate.update(dt)
end

function DRAW()
	return gamestate.draw()
end
