local util = require("luamodules.utilities")
local selection = require "phone.selection"

local questions = util.load_json(rfr.gamepath() .. "data/homework/" .. config.language .. ".json")["questions"]
local answered = {}
local homework_per_day = {
	{1,2,3},
	{4}
}
local current_selection = 1
local current_questionid = 1

local function day_has_questions(day, questionid)
	local current_day = rfr.get_properties(GAME, "day_number") or 1
	local current_questions = homework_per_day[current_day]

	for _,v in ipairs(current_questions) do
		if v == questionid then return true end
	end
	return false
end

function rfr.update_notebook()
	-- Scroll through homework with left and right

	local current_day = rfr.get_properties(GAME, "day_number") or 1
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
	-- Back with Z
end

function rfr.draw_notebook()
	local current_day = rfr.get_properties(GAME, "day_number") or 1
	local current_questions = homework_per_day[current_day]

	local past_question = not day_has_questions(current_day, current_questionid)

	local book_posx = config.render_size[1]/2 - 26 * config.cam_zoom
	local book_posy = 50
	beaver.draw_texture("notebook", {dst = {x = book_posx, y = book_posy, w = 52 * config.cam_zoom, h = 70 * config.cam_zoom}})
	local topic = questions[current_questionid]["topic"]
	local answers = questions[current_questionid]["answers"]
	local current_correct_answer = questions[current_questionid]["correct"]
	local current_answer = answered[current_questionid] or 0
	beaver.draw_text(book_posx + 7 * config.cam_zoom, book_posy + 15 * config.cam_zoom,
						config.ui_font, 1,
						topic, 180, true)

	local answer_posy = book_posy + 30 * config.cam_zoom
	if not past_question then
		beaver.draw_text(book_posx + 4.5 * config.cam_zoom, answer_posy + 2.5 + 8 * current_selection * config.cam_zoom,
						config.ui_font, 1,
						"✏ ", 0 , true)
	end
	for i, answer in ipairs(answers) do
		answer_posy = answer_posy + 8 * config.cam_zoom
		local prefix = (current_answer == i) and "☒ " or "☐ "
		beaver.set_draw_color(0,0,0,255)
		if past_question then
			if current_answer == current_correct_answer then
				beaver.set_draw_color(38,133,76,255)
				beaver.draw_text(book_posx + 40 * config.cam_zoom, book_posy + 56 * config.cam_zoom,
									config.ui_font, 2,
									"✔", 0, true)
				if current_answer ~= i then beaver.set_draw_color(0,0,0,255) end
			else
				beaver.set_draw_color(236,39,63,255)
				beaver.draw_text(book_posx + 40 * config.cam_zoom, book_posy + 56 * config.cam_zoom,
									config.ui_font, 2,
									"✘", 0, true)
				if current_answer ~= i then beaver.set_draw_color(0,0,0,255) end
				if current_correct_answer == i then beaver.set_draw_color(38,133,76,255) end
			end
		end
		beaver.draw_text(book_posx + 10 * config.cam_zoom, answer_posy,
							config.ui_font, 1,
							prefix .. answer, 0, true)
	end

end
