local util = require("luamodules.utilities")
local selection = require "phone.selection"
local notebook = {}

local questions = util.load_json(rfr.gamepath() .. "data/homework/" .. config.language .. ".json")["questions"]
local answered = {}
local homework_per_day = {
	{1,2,3},
	{4,5,6},
	{7,8,9},
	{10,11,12},
}
local current_selection = 1
local current_questionid = 1

function notebook.current_questions()
	local current_day, _ = rfr.current_time()
	return homework_per_day[current_day]
end


local function day_has_questions(day, questionid)
	local current_questions = homework_per_day[day]
	for _,v in ipairs(current_questions) do
		if v == questionid then return true end
	end
	return false
end

local book_start_posy = 600
local book_end_posy = 50
local book_posy = book_start_posy
local book_posx = config.render_size[1] / 2 + 40


local lerp_timer = rfr.add_entity()
local lerp_time = 1
rfr.set_timer(lerp_timer, lerp_time)

function notebook.at_position()
	if rfr.get_flag("notebook_opening") then return book_posy <= book_end_posy
	else return book_posy >= book_start_posy
	end
end

function notebook.toggle()
	rfr.toggle_flag("notebook_opening")
	rfr.set_timer(lerp_timer, lerp_time)

	if rfr.get_flag("notebook_opening") then
		rfr.set_flag("screen_fill")
		rfr.unset_flag("player_can_move")
		rfr.unset_flag("player_can_interact")
		rfr.set_tileanimation(PLAYER, {
			frames = {{12,100}},
			framewidth = 32,
			frameheight = 32,
			["repeat"] = false
		})
		rfr.set_position(PLAYER, 168, 112)
	else
		rfr.set_flag("player_can_move")
		rfr.set_flag("player_can_interact")
	end

end
function notebook.update()
	-- Scroll through homework with left and right
	if not notebook.at_position() then
		local t = rfr.get_timer(lerp_timer).elapsed
		if rfr.get_flag("notebook_opening") then
			rfr.set_properties(GAME, "screen_fill_color", {20,20,20,math.floor(200 * math.min(t * 2,1))})
			book_posy = book_start_posy + (book_end_posy - book_start_posy) * util.ease_in_out(math.min(t / lerp_time, 1))
		else
			rfr.set_properties(GAME, "screen_fill_color", {20,20,20,math.floor(200 * (1 - math.min(t * 2,1)))})
			if t >= lerp_time then rfr.unset_flag("screen_fill") end
			book_posy = book_end_posy + (book_start_posy - book_end_posy) * util.ease_in_out(math.min(t / lerp_time, 1))
		end
		return
	end

	if rfr.get_flag("notebook_opening") then
		if beaver.get_input(config.button.back) == 1 then notebook.toggle() end

		local current_day,_ = rfr.current_time()
		local current_questions = homework_per_day[current_day]
		local max_questionid = current_questions[#current_questions]
		if beaver.get_input("LEFT") == 1 then
			current_questionid = math.max(current_questionid - 1, 1)
			current_selection = 1
		end
		if beaver.get_input("RIGHT") == 1 then
			current_questionid = math.min(current_questionid + 1, max_questionid)
			current_selection = 1
		end

		if day_has_questions(current_day, current_questionid) then
			local current_question_max_answer = #questions[current_questionid]["answers"]
			if beaver.get_input("UP") == 1 then current_selection = math.max(current_selection - 1, 1) end
			if beaver.get_input("DOWN") == 1 then current_selection = math.min(current_selection + 1, current_question_max_answer) end

			if beaver.get_input(config.button.interaction) == 1 then
				answered[current_questionid] = current_selection
			end
		end
	end
end

function notebook.draw()
	if not rfr.get_flag("notebook_opening") and notebook.at_position() then return end
	local book_dst = {x = book_posx, y = book_posy, w = 52 * config.cam_zoom, h = 70 * config.cam_zoom}
	beaver.draw_texture(ASSETS.images.notebook, {dst = book_dst})
	beaver.set_draw_color(0,0,0,255)
	beaver.draw_text_centered(book_posx + 26 * config.cam_zoom, book_posy + (70 - 8) * config.cam_zoom,
								ASSETS.fonts[config.ui_font], 1,
								tostring(current_questionid), 0, true)

	local current_day,_ = rfr.current_time()
	local past_question = not day_has_questions(current_day, current_questionid)
	local topic = questions[current_questionid]["topic"]
	local answers = questions[current_questionid]["answers"]
	local current_correct_answer = questions[current_questionid]["correct"]
	local current_answer = answered[current_questionid] or 0
	beaver.draw_text(book_posx + 7 * config.cam_zoom, book_posy + 15 * config.cam_zoom,
						ASSETS.fonts[config.ui_font], 1,
						topic, 180, true)

	local answer_posy = book_posy + 30 * config.cam_zoom
	if not past_question then
		beaver.draw_text(book_posx + 4.5 * config.cam_zoom, answer_posy + 2.5 + 8 * current_selection * config.cam_zoom,
						ASSETS.fonts[config.ui_font], 1,
						"✏ ", 0 , true)
	end
	for i, answer in ipairs(answers) do
		answer_posy = answer_posy + 8 * config.cam_zoom
		local prefix = (current_answer == i) and "☒ " or "☐ "
		if past_question then
			if current_answer == current_correct_answer then
				beaver.set_draw_color(38,133,76,255)
				beaver.draw_text(book_posx + 40 * config.cam_zoom, book_posy + 56 * config.cam_zoom,
									ASSETS.fonts[config.ui_font], 2,
									"✔", 0, true)
				if current_answer ~= i then beaver.set_draw_color(0,0,0,255) end
			else
				beaver.set_draw_color(236,39,63,255)
				beaver.draw_text(book_posx + 40 * config.cam_zoom, book_posy + 56 * config.cam_zoom,
									ASSETS.fonts[config.ui_font], 2,
									"✘", 0, true)
				if current_answer ~= i then beaver.set_draw_color(0,0,0,255) end
				if current_correct_answer == i then beaver.set_draw_color(38,133,76,255) end
			end
		end
		beaver.draw_text(book_posx + 10 * config.cam_zoom, answer_posy,
							ASSETS.fonts[config.ui_font], 1,
							prefix .. answer, 0, true)
	end
end

return notebook
