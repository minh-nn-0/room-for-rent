local test = {}

local dreamday2 = require "dreams.day2"
function test.update(dt)
--	scatter_paper.update(dt)
	if beaver.get_input("Q") == 1 then rfr.play_cutscene(DREAM_DAY2) end
end

function test.draw()
--	scatter_paper.draw()
end

return test
