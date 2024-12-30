local player = require "player"
function LOAD()
	beaver.new_image(rfr.gamepath() .. "assets/images/tileset.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/male_shirt.png", "male_shirt")
	beaver.new_image(rfr.gamepath() .. "assets/images/female_1.png", "female_1")
	beaver.new_image(rfr.gamepath() .. "assets/images/tl.png", "tl")
	beaver.new_image(rfr.gamepath() .. "assets/images/UI.png", "UI")


	beaver.new_font(rfr.gamepath() .. "assets/fonts/FVF Fernando 08.ttf", 16, "fvf_fernando")

	beaver.create_texture_for_drawing("shadow")

	beaver.set_texture_blend_mode("shadow", "modulate")

	rfr.new_map("room", rfr.gamepath() .. "data/maps/rfr_room.tmj")
	rfr.set_cam_smooth_speed(8)
	player.load()

	rfr.set_dialogue(PEID, "hihi")
	rfr.set_dialogue_position(PEID, 16, -3)


	ACT1 = rfr.add_entity()
	rfr.set_position(ACT1, 30, 110)
	rfr.set_interaction(ACT1, "Nút siêu dài",
		function()
			return rfr.get_position(PEID).x <= 50
		end,
		function()
			print("hahahahah")
		end)
end

local cam_zoom = 5
function UPDATE(dt)
	if beaver.get_input("UP") == 1 then cam_zoom = cam_zoom + 1 end
	if beaver.get_input("DOWN") == 1 then cam_zoom = cam_zoom - 1 end
	rfr.set_cam_zoom(cam_zoom)

	if beaver.get_input("K") == 1 then rfr.set_layer_visible("room", "Before", false) end

	if beaver.get_input("A") == 1 then config.interaction_box_padding = config.interaction_box_padding + 1 end
	if beaver.get_input("S") == 1 then config.interaction_box_padding = config.interaction_box_padding - 1 end




	if beaver.get_input("U") == 1 then
		rfr.set_dialogue(PEID, "Calculating the destRect Let’s assume: x, y: The top-left position of the dialogue box. \
					boxWidth, boxHeight: The width and height of the dialogue box. \
					cornerWidth, cornerHeight: The width and height of the rounded corners. \
				The center area starts after the corners and edges. Its dimensions are:")
	end
	if beaver.get_input("I") == 1 then
		rfr.set_dialogue(PEID, "Đụ má")
	end
	if beaver.get_input("O") == 1 then
		rfr.set_dialogue(PEID, "Có gì đâu mà sợ\nAAAAAA\nAAAAAAAAAAAAAAAAAA")
	end
	player.update(dt)

	local ppos = rfr.get_position(PEID)
	rfr.set_cam_target(ppos.x + 16, ppos.y)

	rfr.update_camera(dt)

	local w,_ = beaver.get_render_output_size()
	rfr.clamp_camera(0, 320 - w / cam_zoom)
	rfr.update_animation(dt)

	rfr.update_dialogue(dt)
	rfr.cleanup_entities()
	return true
end

function DRAW()
	beaver.set_draw_color(0,0,0,255)
	beaver.clear()
	beaver.set_render_target("shadow")
	beaver.set_using_cam(false)
	beaver.set_draw_color(100,100,100,200)
	beaver.draw_rectangle(0,0,0,0,true)
	beaver.draw_texture("tl", {dst = {x = 100, y = 80, w = 64, h = 64}});

	beaver.set_render_target()
	beaver.set_using_cam(true)
	rfr.draw_map("room", 0, 0)
	rfr.draw_entities()
	beaver.set_draw_color(0,0,0,255)
	rfr.draw_dialogue()
	beaver.set_draw_color(255,255,255,255)
	rfr.draw_interactions_info()

	beaver.draw_texture("UI", {dst = {x= 100, y = 100, w = 32, h = 8}, src = {x = 24, y = 0, w = 32, h = 8}})
	local shadowdst = {x = 0, y = 0, w = 1280, h = 720}
	--beaver.draw_texture("shadow", {dst = shadowdst})
end
