local util = {}

function util.player_center()
	local ppos = rfr.get_position(PLAYER)
	return ppos.x + 16, ppos.y + 16
end
return util
