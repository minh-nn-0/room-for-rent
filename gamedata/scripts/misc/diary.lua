local util = require "luamodules.utilities"
local diary_texts = util.load_json(rfr.gamepath() .. "data/diary_" .. config.language .. ".json")["entries"]
local diary = {}

local current_page = 1

function diary.open()
end

function diary.close()
end

function diary.scroll(direction)
end

function diary.update()
end

function diary.draw()
end

return diary

