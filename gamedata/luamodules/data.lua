local util = require "luamodules.utilities"
return {
	dialogues = util.load_json(rfr.gamepath() .. "data/dialogues/events/talk_neighbour_at_door_" .. config.language .. ".json")["dialogues"],
	interaction_names = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json"),
	interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details" .. config.language .. ".json"),
	UI = util.load_json(rfr.gamepath() .. "data/ui/" .. config.language .. ".json"),
}
