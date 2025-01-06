local util = require "luamodules.utilities"
function rfr.get_dialogue_from_json(dialogues, key)
	return dialogues[key] or "[Missing dialogue]"
end

function rfr.get_dialogue_options_from_json(dialogues, key)
	return table.unpack(util.split_string(rfr.get_dialogue_from_json(dialogues, key), "|"))end
