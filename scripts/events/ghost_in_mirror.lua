local ghost_in_mirror_evaluated = false
local ghost_in_mirror = rfr.add_event(
	function()
		local _,tod = rfr.current_time()
		if not ghost_in_mirror_evaluated then
			ghost_in_mirror_evaluated = true
			return tod == 2 and rfr.get_last_interaction() == DOOR_ROOM_TO_BATHROOM and not rfr.get_flag("ghost_in_mirror") and math.random() < 0.8
		elseif rfr.get_location(PLAYER) ~= "Map.Bathroom" then
			ghost_in_mirror_evaluated = false
		end
		return false
	end)

rfr.set_event_listener(GAME, ghost_in_mirror,
	function()
		rfr.set_tile("room", "Map.Bathroom.Bg.Items.1", 14, 14, 835)
		rfr.set_tile("room", "Map.Bathroom.Bg.Items.1", 14, 15, 873)
		rfr.set_flag("ghost_in_mirror")
	end)

local ghost_disappear_in_mirror = rfr.add_event(
	function()
		return rfr.get_flag("ghost_in_mirror") and rfr.get_location(PLAYER) == "Map.Mainroom"
	end)
rfr.set_event_listener(GAME, ghost_disappear_in_mirror,
	function()
		rfr.set_tile("room", "Map.Bathroom.Bg.Items.1", 14, 14, 871)
		rfr.set_tile("room", "Map.Bathroom.Bg.Items.1", 14, 15, 909)
		rfr.unset_flag("ghost_in_mirror")
	end)
