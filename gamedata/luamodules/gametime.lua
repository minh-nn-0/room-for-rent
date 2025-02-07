local day_number = 1
local time_of_day = 1

local meet_neighbour_scenes = require "events.neighbour"
local daily_init = {
	[2] = function()
		meet_neighbour_scenes.setup_neighbour()
		require "events.ghost_when_doing_homework"
		require "events.noshower"
	end
}

local daily_flag = {}

--- @param func function
function rfr.set_daily_init(day, func)
	daily_init[day] = func
end

function rfr.current_time()
	return day_number, time_of_day
end
function rfr.get_day_flag(day, flag)
	if not daily_flag[day] then daily_flag[day] = {} end
	return daily_flag[day][flag] or false
end
function rfr.set_day_flag(day, flag)
	if not daily_flag[day] then daily_flag[day] = {} end
	daily_flag[day][flag] = true
end
function rfr.unset_day_flag(day, flag)
	if not daily_flag[day] then daily_flag[day] = {} end
	daily_flag[day][flag] = false
end
function rfr.advance_time()
	time_of_day = time_of_day + 1
	if time_of_day > 2 then
		-- new day
		day_number = day_number + 1
		time_of_day = 1
		if daily_init[day_number] then daily_init[day_number]() end
	end
end
