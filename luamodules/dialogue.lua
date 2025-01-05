local util = require "luamodules.utilities"
local json = require "luamodules.json"
function rfr.load_dialogue(file)
	local f = assert(io.open(file, "r"))
	local content = f:read("a")
	f:close()
	return json.decode(content)
end

function rfr.get_dialogue_from_json(dialogues, key)
	return dialogues[key][config.language] or "[Missing dialogue]"
end

function rfr.get_dialogue_options_from_json(dialogues, key)
	return table.unpack(util.split_string(rfr.get_dialogue_from_json(dialogues, key), "|"))end
