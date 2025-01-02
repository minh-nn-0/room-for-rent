local map = require("map")
local cutscene = {}

local scripts = {}
local active = false
function cutscene.play(scene)
	scene.load()
	scripts = scene.scripts
	active = true
end
function cutscene.update(dt)
	if not active or #scripts == 0 then return true end
	local current_script = scripts[1]
	if current_script(dt) then
		table.remove(scripts, 1)
	end

	return false
end
return cutscene
