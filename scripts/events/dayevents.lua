local dayevents = {
	[1] = function(dt)
		-- ghost in mirror
	end,
}

function rfr.update_dayevent(dt)
	local d,_ = rfr.current_time()
	dayevents[d](dt)
end
