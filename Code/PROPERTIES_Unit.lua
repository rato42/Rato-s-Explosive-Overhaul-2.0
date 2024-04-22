function EO_unitprop()
	UnitProperties.properties[#UnitProperties.properties+1] = {

        id = "shrap_received",
		editor = "number",
        default = 0,
		min = 0,
		max = 100,
		no_edit = true
    }
end

EO_unitprop()
