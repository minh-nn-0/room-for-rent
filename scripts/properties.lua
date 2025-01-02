local properties = {}
function rfr.set_properties(eid, name, value)
	if not properties[eid] then properties[eid] = {} end
	properties[eid][name] = value
end

function rfr.get_properties(eid, name)
	local value = properties[eid][name]
	if value then
		return value
	else return nil
	end
end
