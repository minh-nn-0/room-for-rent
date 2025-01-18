local util = require "luamodules.utilities"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")

rfr.set_state_entry(PLAYER, "shower",
	function()
		rfr.set_tileanimation(PLAYER, {
			frames = {{13, 300},{14,300}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = true})
	end)

local shower_timer = rfr.add_entity()
local cs_shower = rfr.add_cutscene({
	init = function()
		rfr.fade_out(2)
	end,
	exit = function() end,
	scripts = {
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_state(PLAYER, "shower")
			rfr.unset_flag("player_can_move")
			rfr.unset_flag("player_can_interact")
			rfr.set_position(PLAYER, 176, 240)
			rfr.fade_in(2)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.set_timer(shower_timer, 1)
			return true
		end,
		function(dt)
			if rfr.get_timer(shower_timer).running then return false end
			rfr.fade_out(2)
			return true
		end,
		function(dt)
			if rfr.is_transition_active() then return false end
			rfr.fade_in(2)
			rfr.set_state(PLAYER, "idle")
			rfr.set_flag("player_can_move")
			rfr.set_flag("player_can_interact")
			return true
		end
	},
	update = function(dt) end
})


SHOWER = rfr.add_entity()
rfr.set_position(SHOWER, 192, 224)
rfr.set_location(SHOWER, "Map.Bathroom")
rfr.set_interaction(SHOWER, interaction_names["shower"],
	function()
		local px,_ = util.player_center()
		return px >= 176 and px <= 200
	end,
	function()
		rfr.play_cutscene(cs_shower)
	end)
