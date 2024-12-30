package.path = package.path .. ";" .. rfr.gamepath() .. "/?.lua"
package.path = package.path .. ";" .. rfr.gamepath() .. "/scripts/?.lua"

beaver = require "beaver"
rfr = rfr or {}

config = {
	wpm = 10,
	text_scale = 1/6,
	dialogue_box_padding = 3,
	dialogue_wraplength = 0,
	interaction_box_padding = 4,
}
