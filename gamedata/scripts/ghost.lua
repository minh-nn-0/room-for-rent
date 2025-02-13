local util = require "luamodules.utilities"
local ghost = {}
ghost.eid = rfr.add_entity()

-- HANGING
rfr.set_state_entry(ghost.eid, "hanging",
	function()
		rfr.set_image(ghost.eid, ASSETS.images.ghost_crawl)
		rfr.set_tileanimation(ghost.eid, {
			frames = {{0,400},{1,400},{2,400},{3,400}},
			framewidth = 100,
			frameheight = 64
		})
		rfr.set_location(ghost.eid, "Map.Mainroom")
		rfr.set_position(ghost.eid, 64,80)
	end)

rfr.set_state_entry(ghost.eid, "crawling",
	function()
		rfr.set_tileanimation(ghost.eid, {
			frames = {
				{4,50}, {5,50}, {6,50}, {7,50}, {8,50}, {9,50}, {10,50}, {11,50},
				{12,50}, {13,50}, {14,50}, {15,50}, {16,50}, {17,50}, {18,50}, {19,50}, {20,50}
			},
			framewidth = 100,
			frameheight = 64,
			["repeat"] = false
		})
	end)

-- NORMAL
rfr.set_image(ghost.eid, ASSETS.images.ghost)
rfr.set_state_entry(ghost.eid,"stand",
	function()
		rfr.set_tileanimation(ghost.eid, {
			frames = {{0,100}},
			framewidth = 64,
			frameheight = 64,
			["repeat"] = false
		})
	end)

rfr.set_state_entry(ghost.eid, "idle",
	function()
		rfr.set_tileanimation(ghost.eid, {
			frames = {{1,150},{2,150},{3,150},{4,150}},
			framewidth = 64,
			frameheight = 64,
			["repeat"] = true
		})
	end)

rfr.set_state_entry(ghost.eid, "move",
	function()
		rfr.set_tileanimation(ghost.eid, {
			frames = {{5,100},{6,100},{7,100},{8,100},{9,100},{10,100},{11,100},{12,100}},
			framewidth = 64,
			frameheight = 64,
			["repeat"] = true
		})
	end)

rfr.add_tag(ghost.eid, "npc")
rfr.set_position(ghost.eid, 100,104)
rfr.set_state(ghost.eid, "idle")
rfr.set_properties(ghost.eid, "walkspeed", 1)
local target = {}
function ghost.set_target(x,y)
	target.x = x
	target.y = y
end
ghost.chasing = false
-- Ghost will use only X coordinate. Needs to manually guide Ghost to doors, stairs,... if want to change Y
function ghost.update(dt)
	if ghost.chasing then
		local gpos = rfr.get_position(ghost.eid)
		if target.x and target.y then
			local distance = math.abs(target.x - (gpos.x + 32))
			if distance > 2 then
				rfr.set_state(ghost.eid, "move")
				if target.x > gpos.x + 32 then rfr.set_properties(ghost.eid, "facing_direction", "right")
					else rfr.set_properties(ghost.eid, "facing_direction", "left")
				end
			else
				rfr.set_state(ghost.eid, "idle")
			end
		end
	end
end

function ghost.draw()
end

return ghost
