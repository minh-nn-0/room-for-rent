local scatter_paper = require "dreams.scatter_paper"
local dream = {}

function dream.update(dt)
	if rfr.get_flag("scatter_paper") then scatter_paper.update(dt) end
end

function dream.draw()
	if rfr.get_flag("scatter_paper") then scatter_paper.draw() end
end

return dream
