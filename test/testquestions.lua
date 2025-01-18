local json = require "json"
local function load_json(file)
	local f = assert(io.open(file, "r"))
	local content = f:read("a")
	f:close()
	return json.decode(content)
end

print(load_json("../data/homework/vi.json")["questions"][1]["answers"][2])
