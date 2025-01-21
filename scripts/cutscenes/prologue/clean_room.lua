local util = require "luamodules.utilities"
local dialogues
local interaction_names
local narrative = util.load_json(rfr.gamepath() .. "data/narratives/" .. config.language .. ".json")
local broom = rfr.add_entity()
local cs_prologue_after_broom = rfr.add_cutscene({
	init = function()
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		rfr.fade_out(2)
	end,
	exit = function()
		rfr.unset_flag("prologue_room")
		rfr.set_layer_visible("balcony", "Map.Balcony.Bg.Garbage", false)
		print("exit broom")
		local note = require "phone.apps.note"
		note.add("guide")
		note.add("note")
		require "room_items"
		require "events.call_mom_first_time"
		require "events.pickup_card"
		require "events.meet_neighbour_first_time"
		require "events.complain_lights"
		require "events.ghost_in_mirror"
		require "events.sleep_1"
		require "activities.shower"
		require "activities.work"
		require "activities.sleep"
		require "activities.homework"
	end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_flag("screen_fill")
			rfr.fade_in(1)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_narrative_text(narrative['clean_room'])
			rfr.set_narrative_position(config.render_size[1]/2, config.render_size[2]/2)
			rfr.set_narrative_scale(2)
			return true
		end,
		function(dt)
			if rfr.narrative_text_active() then return false end
			rfr.unset_flag("screen_fill")
			rfr.set_current_map("room")
			rfr.fade_in(2)
			rfr.set_active(broom, false)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_done_clean"]})
			return true
		end,
	},
	update = function(dt) end
})
CS_PROLOGUE_CLEAN_ROOM = rfr.add_cutscene({
	init = function()
		print("enter clean")
		dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/prologue_" .. config.language .. ".json")
		interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
	end,
	exit = function()
		print("exit prologue_clean_room")
	end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, {content = dialogues["player_shiver"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_shiver2"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue(PLAYER, {content = dialogues["player_should_clean"]})
			rfr.set_position(broom, 218, 110)
			rfr.set_location(broom, "Map.Mainroom")
			rfr.set_interaction(broom, interaction_names["broom"],
				function()
					local px,_ = util.player_center()
					return px >= 210 and px <= 220
				end,
				function()
					rfr.play_cutscene(cs_prologue_after_broom)
				end)
			return true
		end,
	},
	update = function(dt) end
})



