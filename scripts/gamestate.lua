GAME = rfr.add_entity()


local player = require "player"
local lighting = require "lighting"
require "door"
require "interactions"
require "cutscenes.prologue.prologue"
require "phone.main"

require "activities.homework"
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
		config.text_scale = 1/rfr.get_cam_zoom()
		player.update(dt)
		rfr.update_camera(dt)
		rfr.update_phone(dt)
		rfr.update_events()
		rfr.update_event_listener()
		rfr.update_character(dt)
		rfr.update_animation(dt)
		rfr.update_dialogue(dt)
		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == rfr.get_location(PLAYER) then
				local dialogue_info = rfr.get_dialogue_info(eid)
				if dialogue_info and dialogue_info.verbal and rfr.has_active_dialogue(eid) and not rfr.dialogue_reached_fulllength(eid) then
					if not rfr.get_properties(eid, "dialogue_audio_timer") then
						rfr.set_properties(eid, "dialogue_audio_timer", rfr.add_entity()) end
					local audio_timerid = rfr.get_properties(eid, "dialogue_audio_timer")
					local audio_timer = rfr.get_timer(audio_timerid)
					if audio_timer then
						if not audio_timer.running then
							beaver.play_sound(dialogue_info.sound)
							rfr.set_timer(audio_timerid, 5/config.cpf)
						end
					else
						rfr.set_timer(audio_timerid, 5/config.cpf)
					end
				end
			end
		end
		rfr.update_timer(dt)
		rfr.update_countdown(dt)
		rfr.update_cutscene(dt)
		rfr.update_interaction()
		rfr.update_narrative(dt)
		rfr.update_transition(dt)

		rfr.update_homework()

		rfr.set_only_player_location_visible()
		rfr.cleanup_entities()

		return true
	end,
	draw = function()
		beaver.set_draw_color(10,10,10,255)
		beaver.clear()
		local ppos = rfr.get_position(PLAYER)
		rfr.draw_map_by_layer(rfr.get_current_map(), rfr.get_location(PLAYER) .. ".Bg", 0, 0)
		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == rfr.get_location(PLAYER) and not rfr.has_tag(eid, "ui") then
				rfr.draw_entities(eid)
			end
		end
		rfr.draw_map_by_layer(rfr.get_current_map(), rfr.get_location(PLAYER) .. ".Fg", 0, 0)
		lighting.draw()
		if rfr.get_flag("player_can_interact") and rfr.get_first_interaction() ~= -1 then
			beaver.set_draw_color(255,255,255,255)
			local i = rfr.get_first_interaction()
			rfr.draw_interactions_info(i)
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
		if rfr.get_flag("screen_fill") then
			local fill_color = rfr.get_properties(GAME, "screen_fill_color") or {0,0,0,255}
			beaver.set_draw_color(fill_color[1], fill_color[2], fill_color[3], fill_color[4])
			beaver.draw_rectangle(0,0,1000,1000,true)
		end
		for _, eid in ipairs(rfr.get_entities_with_tags({"ui"})) do
			rfr.draw_entities(eid)
		end
		rfr.draw_phone_notification()
		rfr.draw_phone()

		rfr.draw_homework()
		beaver.set_draw_color(255,255,255,255)
		rfr.draw_narrative_text()
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
