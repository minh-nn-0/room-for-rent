local json = require "luamodules.json"
local util = {}

function util.player_center()
	local ppos = rfr.get_position(PLAYER)
	return ppos.x + 16, ppos.y + 16
end

function util.load_json(file)
	local f = assert(io.open(file, "r"))
	local content = f:read("a")
	f:close()
	return json.decode(content)
end

function util.split_string(str, delim)
	local rs = {}
	local start = 1
	while true do
		local delim_start, delim_end = string.find(str, delim, start)

		if not delim_start then
			table.insert(rs, string.sub(str, start))
			break
		end

		table.insert(rs, string.sub(str, start, delim_start - 1))

		start = delim_end + 1
	end

	return rs
end
function util.ease_in_out(t)
    return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end
function util.ease_in_out_back(t)
	local c1 = 1.70158;
	local c2 = c1 * 1.525;

	return t < 0.5 and ((2 * t) ^ 2 * ((c2 + 1) * 2 * t - c2)) / 2
  		or ((2 * t - 2) ^ 2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2;
end

return util
