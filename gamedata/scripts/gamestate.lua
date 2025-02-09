GAME = rfr.add_entity()


local player = require "player"
local lighting = require "lighting"
require "door"
require "interactions"
require "cutscenes.prologue.prologue"
require "phone.main"
require "helper"
require "audios"

--local ghost = require "ghost"

local homework = require "activities.homework"
local bed = require "activities.sleep"
local bus = require "misc.bus"
local test = require "test"
local blur = require "misc.blur"
local map = require "luamodules.map"
local narrative = require "luamodules.narrative"
local dream = require "dreams.dream"
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

		test.update(dt)
		player.update(dt)
		--ghost.update(dt)
		lighting.update(dt)
		rfr.update_camera(dt)
		rfr.update_phone(dt)
		rfr.update_event_listener()
		rfr.update_character(dt)
		rfr.update_animation(dt)
		rfr.update_dialogue(dt)
		rfr.update_timer(dt)
		rfr.update_countdown(dt)
		rfr.update_cutscene(dt)
		rfr.update_interaction()
		rfr.update_transition(dt)
		rfr.update_particle_emitter(dt)
		homework.update()
		bed.update()
		bus.update(dt)

		blur.update()
		if rfr.get_flag("dreaming") then dream.update(dt) end
		map.set_only_player_location_visible()
		map.update(dt)
		narrative.update(dt)
		rfr.update_audios()
		rfr.cleanup_entities()

		return true
	end,
	draw = function()
		beaver.set_draw_color(0,0,0,255)
		beaver.clear()
		local plocation = rfr.get_location(PLAYER)
		local ppos = rfr.get_position(PLAYER)
		map.draw_bg()
		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == plocation and not rfr.has_tag(eid, "ui") then
				rfr.draw_particles(eid)
				rfr.draw_entities(eid)
			end
		end
		map.draw_fg()

		if rfr.get_flag("dreaming") then dream.draw() end
		test.draw()

		lighting.draw()
		if rfr.get_flag("player_can_interact") and rfr.get_first_interaction() ~= -1 then
			beaver.set_draw_color(255,255,255,255)
			local i = rfr.get_first_interaction()
			rfr.draw_interactions_info(i)
		end

		for _, eid in ipairs(rfr.get_active_entities()) do
			if rfr.get_location(eid) == plocation then
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
		rfr.draw_helper()
		if rfr.get_flag("screen_fill") then
			local fill_color = rfr.get_properties(GAME, "screen_fill_color") or {0,0,0,255}
			beaver.set_draw_color(fill_color[1], fill_color[2], fill_color[3], fill_color[4])
			beaver.draw_rectangle(0,0,1000,1000,true)
		end
		rfr.draw_helper_fg()
		config.text_scale = 1
		for _, eid in ipairs(rfr.get_entities_with_tags({"ui"})) do
			rfr.draw_entities(eid)
		end
		rfr.draw_phone_notification()
		rfr.draw_phone()
		homework.draw()

		beaver.set_draw_color(255,255,255,255)
		narrative.draw_text()
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
