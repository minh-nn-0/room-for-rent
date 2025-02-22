local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")

--local power_box = rfr.add_entity()
--rfr.set_position(power_box, 320, 134)
--rfr.set_location(power_box, "Map.Outside")
--power_box = interaction.add(interaction_names["power_box"],
--	function()
--		local px, py = util.player_center()
--		return px >= 310 and px <= 330
--	end,
--	function()
--		rfr.set_dialogue(PLAYER, {content = interaction_details["power_box"]})
--	end)
local cs_work = require "activities.work"
interaction.add(interaction_names["house_number"],
	function()
		local px, py = util.player_center()
		return px >= 380 and px <= 392 and rfr.get_location(PLAYER) == "Map.Outside"
	end,
	function()
		rfr.set_flag("read_house_number")
		rfr.set_dialogue(PLAYER, {content = interaction_details["house_number"]})
	end)

local cs_bus_work, cs_bus_nonwork = table.unpack((require "cutscenes.busstop"))
interaction.add(interaction_names["bus_stop"],
	function()
		local px,_ = util.player_center()
		return px >= 246 and px <= 266 and rfr.get_location(PLAYER) == "Map.Mainroom"
	end,
	function()
		local _,tod = rfr.current_time()
		if rfr.get_flag("prologue") then
			rfr.set_dialogue(PLAYER, {content = interaction_details["not_use_bus"]})
		else
			if tod == 2 then
				rfr.play_cutscene(cs_bus_nonwork)
			else
				rfr.play_cutscene(cs_bus_work)
			end
		end
	end)
