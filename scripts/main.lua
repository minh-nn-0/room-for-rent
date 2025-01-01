local player = require "player"
local map = require "map"
local interaction = require "interaction"
local transition = require "transition"
local lighting = require "lighting"
function LOAD()
	beaver.set_render_logical_size(1280, 720)
	beaver.new_image(rfr.gamepath() .. "assets/images/tileset.png")
	beaver.new_image(rfr.gamepath() .. "assets/images/male_shirt.png", "male_shirt")
	beaver.new_image(rfr.gamepath() .. "assets/images/female_1.png", "female_1")
	beaver.new_image(rfr.gamepath() .. "assets/images/ghost.png", "ghost")
	beaver.new_image(rfr.gamepath() .. "assets/images/UI.png", "UI")

	beaver.new_font(rfr.gamepath() .. "assets/fonts/inconsolata.ttf", 64, "inconsolata")

	rfr.new_map("room", rfr.gamepath() .. "data/maps/rfr_room.tmj")
	rfr.new_map("hall", rfr.gamepath() .. "data/maps/hall.tmj")
	rfr.set_cam_smooth_speed(10)
	player.load()
	lighting.load()
	transition.load()
	interaction.load()
	rfr.set_dialogue(PEID, "hihi")
	rfr.set_dialogue_position(PEID, 16, -3)

	--ACT1 = rfr.add_entity()
	--rfr.set_position(ACT1, 30, 110)
	--rfr.set_interaction(ACT1, "Nút siêu dài",
	--	function()
	--		return rfr.get_position(PEID).x <= 50
	--	end,
	--	function()
	--		print("hahahahah")
	--	end)
end

local cam_zoom = 8
local showshadow = true
function UPDATE(dt)
	rfr.set_cam_zoom(cam_zoom)
	player.update(dt)
	local ppos = rfr.get_position(PEID)
	rfr.set_cam_target(ppos.x + 16, ppos.y)
	rfr.update_camera(dt)
	local w,_ = beaver.get_render_logical_size()
	rfr.clamp_camera(0, 320 - w / cam_zoom)

	if beaver.get_input("V") == 1 then lighting.set_background_color(100,100,130,255) end
	interaction.update()

	rfr.update_animation(dt)
	rfr.update_dialogue(dt)

	map.set_only_player_location_visible(map.current)
	rfr.cleanup_entities()


	transition.update(dt)
	return true
end

function DRAW()
	beaver.set_draw_color(10,10,10,255)
	beaver.clear()
	rfr.draw_map(map.current, 0, 0)
	if showshadow then lighting.draw() end
	for _, eid in ipairs(rfr.get_active_entities()) do
		if rfr.get_location(eid) == rfr.get_location(PEID) then
			rfr.draw_entities(eid)
		end
	end

	beaver.draw_texture("lights", {dst = {x = 64, y = 119, w = 21, h = 11},
											src = {x = 0, y = 6, w = 21, h = 11}})

	for _, eid in ipairs(rfr.get_active_entities()) do
		if rfr.get_location(eid) == rfr.get_location(PEID) then
			beaver.set_draw_color(0,0,0,255)
			rfr.draw_dialogue(eid)
			beaver.set_draw_color(255,255,255,255)
			rfr.draw_interactions_info(eid)
		end
	end
	transition.draw()
end
