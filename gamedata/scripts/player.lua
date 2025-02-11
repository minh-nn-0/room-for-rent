local player = {}
PLAYER = rfr.add_entity()
rfr.set_properties(PLAYER, "walkspeed", 0.6)
rfr.set_properties(PLAYER, "footstep_sound", "footstep_tile_heavy")
rfr.add_tag(PLAYER, "footstep_sound")
rfr.set_flag("player_can_move")
rfr.set_flag("player_can_interact")
rfr.set_flag("player_can_open_phone")
rfr.set_position(PLAYER, 144, 112)
rfr.set_location(PLAYER, "Map.Mainroom")
rfr.set_dialogue_position(PLAYER, 16, -3)
rfr.set_image(PLAYER, "male_shirt")
rfr.set_state_entry(PLAYER, "idle",
	function()
		rfr.set_tileanimation(PLAYER, {
			frames = {{0,400},{1,200},{2,200},{3,200}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state_entry(PLAYER, "move",
	function()
		local speed = config.base_character_move_animation_speed / rfr.get_properties(PLAYER, "walkspeed")
		rfr.set_tileanimation(PLAYER, {
			frames = {{4,speed},{5,speed},{6,speed},{7,speed},{8,speed},{9,speed},{10,speed},{11,speed}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)

-- Exactly the same
rfr.set_state_entry(PLAYER, "move_fast",
	function()
		local speed = config.base_character_move_animation_speed / rfr.get_properties(PLAYER, "walkspeed")
		rfr.set_tileanimation(PLAYER, {
			frames = {{4,speed},{5,speed},{6,speed},{7,speed},{8,speed},{9,speed},{10,speed},{11,speed}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true
		})
	end)
rfr.set_state(PLAYER, "idle")
local map = require "luamodules.map"

--local ghost = require "ghost"
--rfr.set_particle_emitter_config(PLAYER, {
--	emitting_position = {x = 200, y = 100},
--	linear_acceleration = {x = 0, y = 0},
--	direction = math.rad(270),
--	spread = math.rad(360),
--	size_variation = {min = 0.2, max = 0.5},
--	speed_variation = {min = 3, max = 4},
--	lifetime = 3,
--	rate = 20
--})
--rfr.set_particle_emitter_auto(PLAYER, true)

require "room_items"
require "activities.shower"
--require "activities.work"
--require "activities.sleep"
--require "activities.homework"
--require "events.sleep.day1"
--require "events.sleep.day2"
--require "events.pickup_card"

require "events.sleep"
local blur = require "misc.blur"

local ghost = require "ghost"
function player.update(dt)
	local ppos = rfr.get_position(PLAYER)
	local pstate = rfr.get_state(PLAYER)
	if rfr.get_flag("player_can_move") then
		local walkspeed = rfr.get_properties(PLAYER, "walkspeed")
		if beaver.get_input("LEFT") > 0 then
			ppos.x = ppos.x - walkspeed
			if pstate ~= "move_fast" then pstate = "move" end
			rfr.set_flipflag(PLAYER, beaver.FLIP_H)
			rfr.set_dialogue_position(PLAYER, 10, -3)
		elseif beaver.get_input("RIGHT") > 0 then
			ppos.x = ppos.x + walkspeed
			if pstate ~= "move_fast" then pstate = "move" end
			rfr.set_flipflag(PLAYER, beaver.FLIP_NONE)
			rfr.set_dialogue_position(PLAYER, 22, -3)
		else
			pstate = "idle"
		end

		if beaver.get_input("LSHIFT") > 0 then
			rfr.set_properties(PLAYER, "walkspeed", 0.8)
			if pstate == "move" then pstate = "move_fast" end
		else
			rfr.set_properties(PLAYER, "walkspeed", 0.6)
			if pstate == "move_fast" then pstate = "move" end
		end
		rfr.set_state(PLAYER, pstate)
	end
	--print(ppos.x + 16, ppos.y + 16)
	if beaver.get_input("S") == 1 then
		rfr.set_image(PLAYER, "girl")
	end
	if beaver.get_input("D") == 1 then
		map.set_current_map("outside")
		ppos.x = 400
		ppos.y = 144
		rfr.set_cam_zoom(2)
		rfr.set_cam_target(PLAYER, 16, -43)
		rfr.set_location(PLAYER, "Map.Outside")
	end

	rfr.set_position(PLAYER, ppos.x, ppos.y)
	if beaver.get_input("E") == 1 then
		rfr.play_cutscene(CS_PROLOGUE_ARRIVE)
	end
	if beaver.get_input("T") == 1 then
		rfr.set_state(ghost.eid, "hanging")
	end
	if beaver.get_input("R") == 1 then
		rfr.set_state(ghost.eid, "crawling")
	end
	if beaver.get_input("ESCAPE") == 1 and rfr.get_flag("player_can_open_phone") then
		rfr.toggle_phone()
	end

	if beaver.get_input("B") == 1 then
		rfr.advance_time()
	end

	if rfr.having_dialogue_options() or rfr.has_active_dialogue(PLAYER) then
		rfr.unset_flag("player_can_interact")
	elseif not (rfr.has_tag(PLAYER, "npc") or rfr.get_flag("phone_opening") or rfr.get_flag("notebook_opening") or rfr.get_flag("inbed")) then
		rfr.set_flag("player_can_interact")
	end

	if rfr.get_flag("phone_opening") then
		if rfr.get_flipflag(PLAYER) == beaver.FLIP_H then
			rfr.set_dialogue_position(PLAYER, 20, -3)
		end
	end

	if rfr.having_dialogue_options() then
		if not rfr.get_flag("phone_opening") then
			if beaver.get_input("UP") == 1 then rfr.decrement_dialogue_options_selection() end
			if beaver.get_input("DOWN") == 1 then rfr.increment_dialogue_options_selection() end
			if beaver.get_input(config.button.interaction) == 1 then rfr.select_dialogue_options_selection() end
		end
	end
	--ghost.set_target(ppos.x + 16, ppos.y + 16)
end

return player
