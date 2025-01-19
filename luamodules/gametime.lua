local day_number = 1
local time_of_day = 1


function rfr.current_time()
	return day_number, time_of_day
end

function rfr.advance_time()
	time_of_day = time_of_day + 1
	if time_of_day > 2 then
		-- new day
		day_number = day_number + 1
		time_of_day = 1
	end
end
