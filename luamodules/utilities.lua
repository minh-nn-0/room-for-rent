local util = {}

function util.player_center()
	local ppos = rfr.get_position(PLAYER)
	return ppos.x + 16, ppos.y + 16
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
return util
