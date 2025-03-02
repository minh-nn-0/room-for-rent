local util = require "luamodules.utilities"
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local interaction = require "luamodules.interaction"
local room_items = {}
room_items.altar = interaction.add({152, 96},
	function()
		local px,_ = util.player_center()
		return px >= 144 and px <= 160 and rfr.get_location(PLAYER) == "Map.Mainroom"
	end,
	function()
		rfr.set_dialogue(PLAYER, {content = interaction_details["altar"]})
	end)
room_items.cabinet = interaction.add({288, 96},
	function()
		local px,_ = util.player_center()
		return px >= 276 and px <= 300 and rfr.get_location(PLAYER) == "Map.Mainroom"
	end,
	function()
		--if rfr.get_properties(CABINET, "normal") then
		--	-- rfr.set_dialogue(PLAYER, {content = interaction_details["cabinet"]})
		--	-- change_clothes
		--end
	end)

local lighting = require "lighting"
room_items.light_switch_mainroom = interaction.add({136, 112},
	function()
		local px,_ = util.player_center()
		return px >= 128 and px < 144 and rfr.get_location(PLAYER) == "Map.Mainroom"
	end,
	function()
		beaver.play_sound(ASSETS.audios.lightswitch)
		lighting.toggle_light("room_ceiling")
	end)

room_items.light_switch_bathroom = interaction.add({280, 240},
	function()
		local px,_ = util.player_center()
		return px >= 272 and px < 287 and rfr.get_location(PLAYER) == "Map.Bathroom"
	end,
	function()
		beaver.play_sound(ASSETS.audios.lightswitch)
		lighting.toggle_light("bathroom_ceiling")
	end)

return room_items
