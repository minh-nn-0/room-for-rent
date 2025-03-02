local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local items = {}
local diary = require "misc.diary"
local candle = require "misc.candle"
items.can_interact = false
items.books = interaction.add({202, 112},
	function()
		local px,_ = util.player_center()
		return px >= 194 and px <= 208 and rfr.get_location(PLAYER) == "Map.Dream" and items.can_interact
	end,
	function()
		if candle.picked_up() then
			rfr.set_dialogue(PLAYER, {content = interaction_details["books"]})
		else
			rfr.set_dialogue(PLAYER, {content = interaction_details["toodark"]})
		end
	end)

local should_read_diary = rfr.add_cutscene({
	init = function() end,
	exit = function() end,
	scripts = {
		function(dt)
			rfr.set_dialogue(PLAYER, {content = interaction_details["read_diary"]})
			return true
		end,
		function(dt)
			if rfr.has_active_dialogue(PLAYER) then return false end
			rfr.set_dialogue_options(rfr.get_dialogue_options_from_json(interaction_details, "choice_read_diary"))
			return true
		end,
		function(dt)
			if rfr.having_dialogue_options() then return false end
			local sl = rfr.get_dialogue_options_selection()
			if sl == 0 then
				diary.open()
			end
			return true
		end
	},
	update = function(dt) end,

})
items.bookshelf = interaction.add({288, 112},
	function()
		local px,_ = util.player_center()
		return px >= 278 and px <= 296 and rfr.get_location(PLAYER) == "Map.Dream" and not rfr.has_active_dialogue(PLAYER) and items.can_interact
	end,
	function()
		if candle.picked_up() then
			rfr.play_cutscene(should_read_diary)
		else
			rfr.set_dialogue(PLAYER, {content = interaction_details["toodark"]})
		end
	end)

return items

