local hands_bathroom_door = {}

local hands = rfr.add_entity()
rfr.set_image(hands, "hands_on_door")
local played_sounds = {}
local appeared = false
function hands_bathroom_door.begin()
	rfr.set_tileanimation(hands, {
		frames = {
			{0,200}, {1,200}, {2,1000},
			{3,200}, {4,200}, {5,100},
			{6,100}, {7,100}, {8,100},
			{9,100}, {10,100}, {11,200}
		},
		framewidth = 32,
		frameheight = 32,
		["repeat"] = false
	})
	rfr.set_location(hands, "Map.Bathroom")
	rfr.set_position(hands, 240,228)
	rfr.reset_tileanimation(hands)
	appeared = true
end
function hands_bathroom_door.ended()
	return not rfr.get_tileanimation(hands).playing
end
function hands_bathroom_door.update(dt)
	if not appeared then return end
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
