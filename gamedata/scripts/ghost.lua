local util = require "luamodules.utilities"
local ghost = {}
GHOST = rfr.add_entity()
rfr.set_image(GHOST, "ghost")
rfr.set_state_entry(GHOST,"stand",
	function()
		rfr.set_tileanimation(GHOST, {
			frames = {{0,100}},
			framewidth = 64,
			frameheight = 64,
			["repeat"] = false
		})
	end)

rfr.set_state_entry(GHOST, "idle",
	function()
		rfr.set_tileanimation(GHOST, {
			frames = {{1,150},{2,150},{3,150},{4,150}},
			framewidth = 64,
			frameheight = 64,
			["repeat"] = true
		})
	end)

rfr.set_state_entry(GHOST, "move",
	function()
		rfr.set_tileanimation(GHOST, {
			frames = {{5,150},{6,150},{7,150},{8,150},{9,150},{10,150},{11,150},{12,150}},
			framewidth = 64,
			frameheight = 64,
			["repeat"] = true
		})
	end)

rfr.add_tag(GHOST, "npc")
rfr.set_position(GHOST, 100,104)
rfr.set_location(GHOST, "Map.Mainroom")
rfr.set_state(GHOST, "idle")
rfr.set_properties(GHOST, "walkspeed", 0.5)
local target = {}
function ghost.set_target(x,y)
	target.x = x
	target.y = y
end
-- Ghost will use only X coordinate. Needs to manually guide Ghost to doors, stairs,... if want to change Y
function ghost.update(dt)
	local gpos = rfr.get_position(GHOST)
	if target.x and target.y then
		local distance = math.abs(target.x - (gpos.x + 32))
		if distance > 2 then
			rfr.set_state(GHOST, "move")
			if target.x > gpos.x + 32 then rfr.set_properties(GHOST, "facing_direction", "right")
				else rfr.set_properties(GHOST, "facing_direction", "left")
			end
		else
			rfr.set_state(GHOST, "idle")
		end
	end
end

function ghost.draw()
end

return ghost
