local util = require "luamodules.utilities"
local interaction = require "luamodules.interaction"
local interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local items = {}
local diary = require "misc.diary"
local candle = require "misc.candle"
items.books = interaction.add(interaction_names["books"],
	function()
		local px,_ = util.player_center()
		return px >= 194 and px <= 208 and rfr.get_location(PLAYER) == "Map.Dream" and candle.picked_up()
	end,
	function()
		rfr.set_dialogue(PLAYER, {content = interaction_details["books"]})
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
items.bookshelf = interaction.add(interaction_names["bookshelf"],
	function()
		local px,_ = util.player_center()
		return px >= 278 and px <= 296 and rfr.get_location(PLAYER) == "Map.Dream" and candle.picked_up()
	end,
	function()
		if not rfr.is_cutscene_playing() then
			rfr.play_cutscene(should_read_diary)
		end
	end)

