local flags = {}

function rfr.set_flag(flag)
	flags[flag] = true
end

function rfr.unset_flag(flag)
	flags[flag] = nil
end

function rfr.toggle_flag(flag)
	flags[flag] = not flags[flag]
end
function rfr.get_flag(flag)
	return flags[flag] or false
end
