local test = {}
local bloods_drip = require "events.sleep.blood_dripping_bathroom"
local hands = require "events.sleep.hands_bathroom_door"
local camera_shake = require "misc.camera_shake"
local candle = require "misc.candle"
local day3 = require "events.sleep.day3"
local eat = require "activities.eat"
require "events.sleep.room_dream_items"
rfr.set_position(candle.eid, 160,112)
rfr.set_location(candle.eid, "Map.Mainroom")
function test.update(dt)
--	scatter_paper.update(dt)
	if beaver.get_input("Q") == 1 then candle.toggle() end
	hands.update(dt)
end

function test.draw()
--	scatter_paper.draw()
end

return test
