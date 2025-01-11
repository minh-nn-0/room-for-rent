local player = require "player"
local lighting = require "lighting"
local door = require "door"
require "phone.main"
local gamestate = {
	current_state = "ingame"
}


local state = {}
state["menu"] = {
	load = function()
	end,
	update = function(dt)
	end,
	draw = function(dt)
	end
}

state["ingame"] = {
	load = function()
		rfr.set_cam_target(PLAYER, 16,0)
		door.load()
	end,
	update = function(dt)
		config.text_scale = 1/rfr.get_cam_zoom()
		rfr.set_location(PHONE, rfr.get_location(PLAYER))
		player.update(dt)
		rfr.set_only_player_location_visible()
		rfr.update_transition(dt)
		rfr.update_camera(dt)
		rfr.update_character(dt)
		rfr.update_cutscene(dt)
		rfr.update_interaction()
		rfr.update_animation(dt)
		rfr.update_dialogue(dt)
		rfr.update_phone(dt)
		rfr.update_events()
		rfr.update_event_listener()
		rfr.update_timer(dt)
		rfr.update_countdown(dt)
		rfr.cleanup_entities()

		return true
	end,
	draw = function()
		beaver.set_draw_color(10,10,10,255)
		beaver.clear()
		local ppos = rfr.get_position(PLAYER)
		rfr.draw_map_by_layer(rfr.get_current_map(), rfr.get_location(PLAYER) .. ".Bg", 0, 0)
		for _, eid in ipairs(rfr.get_active_entities()) do
			local bgcolor = lighting.get_background_color()
			rfr.set_tint(eid, bgcolor[1], bgcolor[2], bgcolor[3], bgcolor[4])
			if rfr.get_location(eid) == rfr.get_location(PLAYER) and not rfr.has_tag(eid, "ui") then
				rfr.draw_entities(eid)
			end
		end
		rfr.draw_map_by_layer(rfr.get_current_map(), rfr.get_location(PLAYER) .. ".Fg", 0, 0)
		lighting.draw()
		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				beaver.set_draw_color(0,0,0,255)
				if rfr.get_properties(PLAYER, "can_interact") then
					beaver.set_draw_color(255,255,255,255)
					rfr.draw_interactions_info(eid)
				end
			end
		end

		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				if rfr.has_active_dialogue(eid) then
					beaver.set_draw_color(10,10,10,255)
					rfr.draw_dialogue(eid)
				end
			end
		end
		beaver.set_draw_color(255,255,255,255)
		local cx,_,cw,_ = rfr.get_cam_view()
		local player_near_right_edge = ppos.x >= cx + (cw / config.cam_zoom) - 70
		rfr.draw_dialogue_options(player_near_right_edge and ppos.x or ppos.x + 30, ppos.y + 5, not player_near_right_edge)

		beaver.set_draw_color(10,10,10,255)
		beaver.set_using_cam(false)
		config.text_scale = 1
		for _, eid in ipairs(rfr.get_entities_with_tags({"ui"})) do
			rfr.draw_entities(eid)
		end
		rfr.draw_phone()
		rfr.draw_transition()
		beaver.set_using_cam(true)
	end
}

function gamestate.load()
	state[gamestate.current_state].load()
end

function gamestate.update(dt)
	return state[gamestate.current_state].update(dt)
end

function gamestate.draw()
	state[gamestate.current_state].draw()
end
return gamestate
