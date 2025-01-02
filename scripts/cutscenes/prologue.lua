local map = require "map"
local character = require "character"

local cs_prologue = {
	scripts = {}
}
function cs_prologue.load()
	map.current = "hall"
	rfr.set_location(PLAYER, "Map.Hall")
	rfr.set_location(OWNER, "Map.Hall")
	rfr.set_position(PLAYER, 16,240)
	rfr.set_position(OWNER, 32,240)
	print("HJOOH")
	cs_prologue.scripts = {
		function(dt)
			rfr.set_state(OWNER, "move")
			rfr.set_properties(OWNER, "facing_direction", "right")
			if (not rfr.has_active_dialogue(OWNER)) then
				rfr.set_dialogue(OWNER, "Giờ gần Tết rồi nên giá phòng cũng rẻ.")
				return true
			end
			return false
		end,
		function(dt)
			if (not rfr.has_active_dialogue(OWNER)) then
				rfr.set_dialogue(OWNER, "Chỗ cô hiện tại chỉ còn 1 phòng duy nhất trên tầng 2.")
				return true
			end
			return false
		end,
		function(dt)
			if (not rfr.has_active_dialogue(OWNER)) then
				rfr.set_dialogue(OWNER, "Yên tâm là giá rẻ nhất cả khu này rồi.")
				return true
			end
			return false
		end,
		function(dt)
			print(rfr.get_dialogue_time(OWNER))
			if (not rfr.has_active_dialogue(OWNER)) then
				rfr.set_dialogue(PLAYER, "Chỗ này cũng gần trường với chỗ làm cháu.\nPhòng như nào với giá ra sao ạ?")
				return true
			end
			return false
		end
	}
end

return cs_prologue

