


function EO_props()

	GrenadeProperties.properties[#GrenadeProperties.properties+1] = {
		category = "Rato's Explosive Overhaul",
		id = "r_timer",
        name = "Fuse Timer",
        help = "Fuse Timer (in miliseconds)",
        editor = "number",
        default = false,
		template = true,
		min = 0,
		max = 10000,
		modifiable = false
		
	}
	
	GrenadeProperties.properties[#GrenadeProperties.properties+1] = {
		category = "Rato's Explosive Overhaul",
		id = "is_explosive",
        name = "Is Explosive",
        help = "Is Explosive",
        editor = "bool",
        default = true,
		template = true,
		modifiable = false
		
	}
	
	GrenadeProperties.properties[#GrenadeProperties.properties+1] = {
		category = "Rato's Explosive Overhaul",
		id = "r_mass",
        name = "Mass",
        help = "Mass (grams)",
        editor = "number",
        default = false,
		min = 0,
		max = 10000,
		template = true,
		modifiable = false
		
	}
	
	GrenadeProperties.properties[#GrenadeProperties.properties+1] = {
		category = "Rato's Explosive Overhaul",
		id = "r_shape",
        name = "Shape",
        help = "Shape",
        editor = "dropdownlist",
		items = list_gren_shape(),
        default = "",
		template = true,
		modifiable = true,
		
	}
	
	GrenadeProperties.properties[#GrenadeProperties.properties+1] = {
		category = "Rato's Explosive Overhaul",
		id = "is_ied",
        name = "IED",
        help = "Improvised Explosive Device",
        editor = "bool",
        default = false,
		template = true,
		modifiable = true,
		
	}
	
	GrenadeProperties.properties[#GrenadeProperties.properties+1] = {
		category = "Rato's Explosive Overhaul",
		id = "r_shrap_num",
        name = "Shrapnel Number",
        help = "Shrapnel Number",
        editor = "number",
        default = 0,
		min = 0,
		max = 1000,
		template = true,
		modifiable = false
		
	}
	
	
end

EO_props()