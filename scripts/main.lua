local gamestate = require "gamestate"
function LOAD()
	beaver.set_render_logical_size(config.render_size[1], config.render_size[2])
	beaver.set_integer_scale(true)
	rfr.set_cam_smooth_speed(10)
	rfr.set_cam_zoom(config.cam_zoom)

	beaver.set_render_blend_mode("blend")

	beaver.new_image(rfr.gamepath() .. "assets/images/tileset.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/outside_wall.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/outside_pole.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/tree1.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/male_shirt.png", "male_shirt")
	beaver.new_image(rfr.gamepath() .. "assets/images/girl2.png", "girl")
	beaver.new_image(rfr.gamepath() .. "assets/images/woman_2.png", "woman")
	beaver.new_image(rfr.gamepath() .. "assets/images/neighbour.png", "neighbour")
	beaver.new_image(rfr.gamepath() .. "assets/images/ghost.png", "ghost")
	beaver.new_image(rfr.gamepath() .. "assets/images/character_heads.png", "character_heads")
	beaver.new_image(rfr.gamepath() .. "assets/images/UI.png", "UI")
	beaver.new_image(rfr.gamepath() .. "assets/images/phone.png", "phone")
	beaver.new_image(rfr.gamepath() .. "assets/images/notebook.png", "notebook")
	beaver.new_image(rfr.gamepath() .. "assets/images/student_card.png", "student_card")

	beaver.new_sound(rfr.gamepath() .. "assets/audios/dialogue1.wav", "dialogue1")

	beaver.new_font(rfr.gamepath() .. "assets/fonts/UnifontExMono.ttf", 16, "unifontexmono")
	beaver.new_font(rfr.gamepath() .. "assets/fonts/unifont.otf", 16, "unifont")
	beaver.new_font(rfr.gamepath() .. "assets/fonts/fs-tahoma/fs-tahoma-8px.ttf", 16, "fs-tahoma")

	rfr.new_map("room", rfr.gamepath() .. "data/maps/rfr_room2.tmj")
	rfr.new_map("room_before", rfr.gamepath() .. "data/maps/rfr_room_before2.tmj")
	rfr.new_map("hall", rfr.gamepath() .. "data/maps/hall2.tmj")
	rfr.new_map("outside", rfr.gamepath() .. "data/maps/outside.tmj")
	rfr.new_map("balcony", rfr.gamepath() .. "data/maps/behind1.tmj")

	gamestate.load()
end

function UPDATE(dt)
	return gamestate.update(dt)
end

function DRAW()
	return gamestate.draw()
end
