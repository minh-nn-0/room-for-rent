local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")

BED = rfr.add_entity()
rfr.set_position(BED, 104,100)


local anim_frames = {
	{619,620,621,657,658,659},
	{622,623,624,660,661,662},
	{543,544,545,581,582,583},
	{546,547,548,584,585,586},
}

local function set_bed_tiles(tiles)
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 5, 7, tiles[1])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 6, 7, tiles[2])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 7, 7, tiles[3])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 5, 8, tiles[4])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 6, 8, tiles[5])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 7, 8, tiles[6])
end


local tileframes = 3
local bed_animation_timer = rfr.add_entity()
local anim_time = 0.6

local premature_wakeup = false
local cs_sleep = rfr.add_cutscene({
	init = function()
		premature_wakeup = false
		rfr.set_timer(bed_animation_timer, anim_time)
		rfr.set_cam_target(BED,0,12)
		rfr.set_position(PLAYER, 1000,1000)
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_interact")
		rfr.set_flag("sleeping")
		rfr.fade_out(4)
	end,
	exit = function()
		if premature_wakeup then rfr.fade_in(0.5)
		else rfr.fade_in(2)
		end
		rfr.set_position(PLAYER, 96,112)
		rfr.set_cam_target(PLAYER, 16,0)
		rfr.set_state(PLAYER, "idle")
		rfr.set_flag("player_can_move")
		rfr.set_flag("player_can_interact")
		rfr.unset_flag("sleeping")
		set_bed_tiles(math.random() > 0.5 and anim_frames[1] or anim_frames[2])
	end,
	scripts = {
		function(dt)
			if premature_wakeup then return true end
			if rfr.is_transition_active() then return false end
			return true
		end,
	},
	update = function()
		if beaver.get_input(config.button.back) == 1 then premature_wakeup = true end

		if not rfr.get_timer(bed_animation_timer).running then
			tileframes = tileframes > 4 and 3 or tileframes + 1
			rfr.set_timer(bed_animation_timer, anim_time)
		end
		set_bed_tiles(anim_frames[tileframes])
	end
})
rfr.set_location(BED, "Map.Mainroom")
rfr.set_properties(BED, "normal", true)
rfr.set_interaction(BED, interaction_name["bed"],
	function()
		local px,_ = util.player_center()
		return px >= 90 and px <= 120
	end,
	function()
		rfr.play_cutscene(cs_sleep)
	end)
