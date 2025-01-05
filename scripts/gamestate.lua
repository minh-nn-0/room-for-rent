local player = require "player"
local lighting = require "lighting"
require "door"
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
	end,
	update = function(dt)
		player.update(dt)
		rfr.set_only_player_location_visible()
		rfr.update_transition(dt)
		rfr.update_camera(dt)
		rfr.update_character(dt)
		rfr.update_cutscene(dt)
		rfr.update_interaction()
		rfr.update_animation(dt)
		rfr.update_dialogue(dt)
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
		rfr.draw_map(rfr.get_current_map(), 0, 0)
		for _, eid in ipairs(rfr.get_active_entities()) do
			local bgcolor = lighting.get_background_color()
			rfr.set_tint(eid, bgcolor[1], bgcolor[2], bgcolor[3], bgcolor[4])
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				rfr.draw_entities(eid)
			end
		end
		lighting.draw()
		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				beaver.set_draw_color(0,0,0,255)
				rfr.draw_dialogue(eid)
				beaver.set_draw_color(255,255,255,255)
				rfr.draw_interactions_info(eid)
			end
		end

		local ppos = rfr.get_position(PLAYER)
		local oldtscale = config.text_scale

		config.text_scale = 1/15
		local cx,_,cw,_ = rfr.get_cam_view()
		local player_near_right_edge = ppos.x >= cx + (cw / config.cam_zoom) - 70
		rfr.draw_dialogue_options(player_near_right_edge and ppos.x or ppos.x + 30, ppos.y + 5, not player_near_right_edge)
		config.text_scale = oldtscale

		rfr.draw_transition()
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
