local util = require "luamodules.utilities"
local interaction_name = util.load_json(rfr.gamepath() .. "data/interaction/names_" .. config.language .. ".json")
local interaction_details = util.load_json(rfr.gamepath() .. "data/interaction/details_" .. config.language .. ".json")
local bed = {}
BED = rfr.add_entity()
rfr.set_position(BED, 104,110)


local anim_frames = {
	{619,620,621,657,658,659},
	{622,623,624,660,661,662},
	{543,544,545,581,582,583},
	{546,547,548,584,585,586},
}

function bed.set_tiles(id)
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 5, 7, anim_frames[id][1])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 6, 7, anim_frames[id][2])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 7, 7, anim_frames[id][3])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 5, 8, anim_frames[id][4])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 6, 8, anim_frames[id][5])
	rfr.set_tile("room", "Map.Mainroom.Bg.Items.1", 7, 8, anim_frames[id][6])
end
local tileframes = 3
local bed_animation_timer = rfr.add_entity()
local anim_time = 0.6
rfr.set_timer(bed_animation_timer, anim_time)

function bed.animate_bed_sleep()
	if not rfr.get_timer(bed_animation_timer).running then
		tileframes = tileframes == 4 and 3 or tileframes + 1
		rfr.set_timer(bed_animation_timer, anim_time)
	end
	bed.set_tiles(tileframes)
end

function bed.go_to_sleep_normally()
	rfr.set_cam_target(BED,0,2)
	rfr.set_position(PLAYER, 1000,1000)
	rfr.set_state(PLAYER, "idle")
	rfr.unset_flag("player_can_move")
	rfr.unset_flag("player_can_interact")
	rfr.set_flag("inbed")
	bed.set_tiles(3)
end

function bed.wake_up()
	rfr.set_position(PLAYER, 96,112)
	rfr.set_cam_target(PLAYER, 16,0)
	rfr.set_state(PLAYER, "idle")
	rfr.set_flag("player_can_move")
	rfr.set_flag("player_can_interact")
	rfr.unset_flag("inbed")
	bed.set_tiles(math.random() > 0.5 and 1 or 2)
end

local sleep_timer = rfr.add_entity()
local cs_sleep = rfr.add_cutscene({
	init = function()
		rfr.unset_flag("premature_wakeup")
		bed.go_to_sleep_normally()
		rfr.fade_out(4)
	end,
	exit = function()
		if not rfr.get_flag("premature_wakeup") then
			rfr.fade_in(2)
			rfr.advance_time()
		else
			rfr.fade_in(0.5)
		end
		rfr.unset_flag("sleeping")
	end,
	scripts = {
		function(dt)
			if rfr.get_flag("premature_wakeup") then return true end
			if rfr.is_transition_active() then return false end
			rfr.set_flag("sleeping")
			rfr.set_timer(sleep_timer, 2)
			return true
		end,
		function(dt)
			if rfr.get_flag("premature_wakeup") then return true end
			if rfr.get_timer(sleep_timer).running then return false end
			return true
		end,
	},
	update = function()
		if beaver.get_input(config.button.back) == 1 then rfr.set_flag("premature_wakeup") end
	end
})

rfr.set_location(BED, "Map.Mainroom")
rfr.set_properties(BED, "normal", true)
rfr.set_interaction(BED, interaction_name["bed"],
	function()
		local px,_ = util.player_center()
		return px >= 90 and px <= 120 and not rfr.get_flag("prologue")
	end,
	function()
		if rfr.get_flag("naked") then
			rfr.set_dialogue(PLAYER, {content = interaction_details["not_done_shower"]})
		else
			rfr.play_cutscene(cs_sleep)
		end
	end)

function bed.update()
	if rfr.get_flag("inbed") then
		bed.animate_bed_sleep()
		if not rfr.get_flag("sleeping") and not rfr.get_flag("dreaming") and beaver.get_input(config.button.back) == 1
			then bed.wake_up()
		end
	end
end
return bed
