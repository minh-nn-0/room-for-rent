local test = {}
local hands = require "events.sleep.hands_bathroom_door"

function test.update(dt)
--	scatter_paper.update(dt)
	if beaver.get_input("Q") == 1 then hands.begin() end
	hands.update(dt)
end

function test.draw()
--	scatter_paper.draw()
end

return test
