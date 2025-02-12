local hands_bathroom_door = {}

local hands = rfr.add_entity()
rfr.set_image(hands, "hands_on_door")

function hands_bathroom_door.begin()
	rfr.set_tileanimation(hands, {
		frames = {
			{0,200}, {1,200}, {2,1000},
			{3,200}, {4,200}, {5,1000},
			{6,200}, {7,200}, {8,1000},
			{9,200}, {10,200}, {11,1000}
		},
		framewidth = 32,
		frameheight = 32,
		["repeat"] = false
	})
	rfr.set_location(hands, "Map.Bathroom")
	rfr.set_position(hands, 240,228)
end
local played_sounds = {}
function hands_bathroom_door.update(dt)
	local anim = rfr.get_tileanimation(hands)
	if anim and anim.playing then
		if anim.currentid == 0 or anim.currentid == 3 or anim.currentid == 6 or anim.currentid == 9 then
			if not played_sounds[anim.currentid] then
				beaver.play_sound("doorslam")
				played_sounds[anim.currentid] = true
			end
		end
	end
end

return hands_bathroom_door
