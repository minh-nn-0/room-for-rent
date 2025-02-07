local dream_day2 = require "dreams.day2"
local scatter_paper = require "dreams.scatter_paper"
local dream = {}

local sleep_day2 = rfr.add_event(
	function()
		local d, tod = rfr.current_time()
		return d == 2 and tod == 1 and rfr.get_flag("sleeping")
	end)

rfr.set_event_listener(GAME, sleep_day2,
	function()
		rfr.play_cutscene(dream_day2)
		rfr.unset_event_listener(GAME, sleep_day2)
	end)

function dream.update(dt)
	if rfr.get_flag("scatter_paper") then scatter_paper.update(dt) end
end

function dream.draw()
	if rfr.get_flag("scatter_paper") then scatter_paper.draw() end
end

return dream
