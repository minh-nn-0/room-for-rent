ASSETS = {images = {}, audios = {}, fonts = {}}
MAPS = {}
local gamestate
function LOAD()
	beaver.set_render_logical_size(config.render_size[1], config.render_size[2])
	beaver.set_integer_scale(true)
	rfr.set_cam_smooth_speed(10)
	rfr.set_cam_zoom(config.cam_zoom)
	beaver.set_render_blend_mode("blend")
	beaver.allocate_sound_channels(32)
	ASSETS.images = {
		tileset = beaver.new_image(rfr.gamepath() .. "assets/images/tileset.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/outside_wall.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/outside_wall2.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/outside_pole.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/fences.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/backwall.png"),
		clouds = beaver.new_image(rfr.gamepath() .. "assets/images/Clouds.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/house1.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/house2.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/house3.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/road.png"),
			beaver.new_image(rfr.gamepath() .. "assets/images/tree1.png"),
		diary = beaver.new_image(rfr.gamepath() .. "assets/images/diary.png"),
		male_shirt = beaver.new_image(rfr.gamepath() .. "assets/images/male_shirt.png"),
		male_naked = beaver.new_image(rfr.gamepath() .. "assets/images/male_naked.png"),
		girl = beaver.new_image(rfr.gamepath() .. "assets/images/girl.png"),
		woman = beaver.new_image(rfr.gamepath() .. "assets/images/woman_2.png"),
		neighbour = beaver.new_image(rfr.gamepath() .. "assets/images/neighbour.png"),
		ghost = beaver.new_image(rfr.gamepath() .. "assets/images/ghost.png"),
		character_heads = beaver.new_image(rfr.gamepath() .. "assets/images/character_heads.png"),
		UI = beaver.new_image(rfr.gamepath() .. "assets/images/UI.png"),
		phone = beaver.new_image(rfr.gamepath() .. "assets/images/phone.png"),
		notebook = beaver.new_image(rfr.gamepath() .. "assets/images/notebook.png"),
		student_card = beaver.new_image(rfr.gamepath() .. "assets/images/student_card.png"),
		blur = beaver.new_image(rfr.gamepath() .. "assets/images/blur.png"),
		bloods_ceiling_1 = beaver.new_image(rfr.gamepath() .. "assets/images/bloods_ceiling_1.png"),
		bloods_ceiling_2 = beaver.new_image(rfr.gamepath() .. "assets/images/bloods_ceiling_2.png"),
		bloods_bathroom_splatter = beaver.new_image(rfr.gamepath() .. "assets/images/bloods_bathroom_splatter.png"),
		bloods_floor = beaver.new_image(rfr.gamepath() .. "assets/images/bloods_floor.png"),
		hands_on_door = beaver.new_image(rfr.gamepath() .. "assets/images/hands_on_door.png"),
		ghost_crawl = beaver.new_image(rfr.gamepath() .. "assets/images/ghost_crawl_room.png"),
		light = beaver.new_image(rfr.gamepath() .. "assets/images/lights.png"),
	}
	beaver.set_texture_blend_mode(ASSETS.images.light, "additive")
	ASSETS.audios = {
		dialogue1 = beaver.new_sound(rfr.gamepath() .. "assets/audios/dialogue1.wav"),
		dooropen = beaver.new_sound(rfr.gamepath() .. "assets/audios/dooropen.wav"),
		dooropen2 = beaver.new_sound(rfr.gamepath() .. "assets/audios/dooropen2.wav"),
		footstep_wood_light = beaver.new_sound(rfr.gamepath() .. "assets/audios/footstep_wood_light.wav"),
		footstep_tile_heavy = beaver.new_sound(rfr.gamepath() .. "assets/audios/footstep2.wav"),
		footstep_tile_light = beaver.new_sound(rfr.gamepath() .. "assets/audios/footstep_tile_light.wav"),
		footstep_tile_medium = beaver.new_sound(rfr.gamepath() .. "assets/audios/footstep_tile_medium.wav"),
		footstep_mud_walk_08 = beaver.new_sound(rfr.gamepath() .. "assets/audios/footstep_mud_walk_08.wav"),
		footstep_mud_run_04 = beaver.new_sound(rfr.gamepath() .. "assets/audios/footstep_mud_run_04.wav"),
		doorknock = beaver.new_sound(rfr.gamepath() .. "assets/audios/doorknock.wav"),
		doorknock_panright = beaver.new_sound(rfr.gamepath() .. "assets/audios/doorknock_panright.wav"),
		phonering = beaver.new_sound(rfr.gamepath() .. "assets/audios/phonering.wav"),
		lightswitch = beaver.new_sound(rfr.gamepath() .. "assets/audios/lightswitch.wav"),
		running_water = beaver.new_sound(rfr.gamepath() .. "assets/audios/running_water.wav"),
		eatnoddle = beaver.new_sound(rfr.gamepath() .. "assets/audios/eatnoddle.mp3"),
		busdoor = beaver.new_sound(rfr.gamepath() .. "assets/audios/busdoor.mp3"),
		busengine = beaver.new_sound(rfr.gamepath() .. "assets/audios/busengine.wav"),
		doorsqueak = beaver.new_sound(rfr.gamepath() .. "assets/audios/doorsqueak.wav"),
		ambience_cricket = beaver.new_sound(rfr.gamepath() .. "assets/audios/ambience_night.wav"),
		ambience_night_2 = beaver.new_sound(rfr.gamepath() .. "assets/audios/ambience_night_2.wav"),
		bird = beaver.new_sound(rfr.gamepath() .. "assets/audios/bird.wav"),
		ambience_wind = beaver.new_sound(rfr.gamepath() .. "assets/audios/ambience_wind.wav"),
		carpassing = beaver.new_sound(rfr.gamepath() .. "assets/audios/carpassing.wav"),
		thrill1 = beaver.new_sound(rfr.gamepath() .. "assets/audios/thrill1.wav"),
		stinger_piano02 = beaver.new_sound(rfr.gamepath() .. "assets/audios/horror_01_stinger_piano_02.ogg"),
		stinger_piano12 = beaver.new_sound(rfr.gamepath() .. "assets/audios/horror_01_stinger_piano_12.ogg"),
		stinger_impact01 = beaver.new_sound(rfr.gamepath() .. "assets/audios/horror_01_stinger_impact_01.ogg"),
		creepy_atmosphere = beaver.new_sound(rfr.gamepath() .. "assets/audios/NDKG_CreepyAtmosphereLooped.ogg"),
		thrillsuspend = beaver.new_sound(rfr.gamepath() .. "assets/audios/thrillsuspend.wav"),
		dog = beaver.new_sound(rfr.gamepath() .. "assets/audios/dogbark.wav"),
		waterdrops = beaver.new_sound(rfr.gamepath() .. "assets/audios/waterdrops.wav"),
		doorslam = beaver.new_sound(rfr.gamepath() .. "assets/audios/doorslam.wav"),
		lockeddoor = beaver.new_sound(rfr.gamepath() .. "assets/audios/lockeddoor.wav"),
		cry = beaver.new_sound(rfr.gamepath() .. "assets/audios/cry.wav"),
		crack1 = beaver.new_sound(rfr.gamepath() .. "assets/audios/crack1.ogg"),
		crack2 = beaver.new_sound(rfr.gamepath() .. "assets/audios/crack2.ogg"),
		crack3 = beaver.new_sound(rfr.gamepath() .. "assets/audios/crack3.ogg"),
		crack4 = beaver.new_sound(rfr.gamepath() .. "assets/audios/crack4.ogg"),
		crack5 = beaver.new_sound(rfr.gamepath() .. "assets/audios/crack5.ogg"),
		lighter = beaver.new_sound(rfr.gamepath() .. "assets/audios/lighter.wav"),
	}

	beaver.set_volume_sound(ASSETS.audios.creepy_atmosphere, 40)
	ASSETS.fonts = {
		unifontexmono = beaver.new_font(rfr.gamepath() .. "assets/fonts/UnifontExMono.ttf", 16),
		unifont = beaver.new_font(rfr.gamepath() .. "assets/fonts/unifont.otf", 16),
		fs_tahoma = beaver.new_font(rfr.gamepath() .. "assets/fonts/fs-tahoma/fs-tahoma-8px.ttf", 16),
	}

	MAPS = {
		room = rfr.new_map(rfr.gamepath() .. "data/maps/rfr_room2.tmj"),
		room_before = rfr.new_map(rfr.gamepath() .. "data/maps/rfr_room_before2.tmj"),
		room_dream = rfr.new_map(rfr.gamepath() .. "data/maps/rfr_room_dream.tmj"),
		hall = rfr.new_map(rfr.gamepath() .. "data/maps/hall2.tmj"),
		outside = rfr.new_map(rfr.gamepath() .. "data/maps/outside.tmj"),
		balcony = rfr.new_map(rfr.gamepath() .. "data/maps/behind1.tmj"),
	}
	gamestate = require "gamestate"
	gamestate.load()
end
function UPDATE(dt)
	return gamestate.update(dt)
end

function DRAW()
	return gamestate.draw()
end
