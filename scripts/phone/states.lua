local home = require "phone.apps.home"
local call = require "phone.apps.call"
local messenger = require "phone.apps.messenger"
local note = require "phone.apps.note"

local phone_states =  {
	["home"] = home,
	["call"] = call,
	["message"] = messenger,
	["note"] = note,
	["setting"] = {
		load = function() end,
		update = function(dt)
		end,
		draw = function()
		end,
	},
}

return phone_states
