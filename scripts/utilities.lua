local util = {}

function util.player_center()
	local ppos = rfr.get_position(PEID)
	return ppos.x + 16, ppos.y + 16
end
return util
