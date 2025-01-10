local home = require "phone.apps.home"
local call = require "phone.apps.call"
local messenger = require "phone.apps.messenger"
local selection = require "phone.selection"

local phone_states =  {
	["home"] = home,
	["call"] = call,
	["message"] = messenger,
	["note"] = {
		update = function(dt)
		end,
		draw = function()
		end,
	},
	["setting"] = {
		update = function(dt)
		end,
		draw = function()
		end,
	},
}

return phone_states
