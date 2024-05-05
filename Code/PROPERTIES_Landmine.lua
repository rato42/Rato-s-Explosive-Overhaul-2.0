--[[ function landmine_props()
	LandmineProperties.properties[#LandmineProperties.properties + 1] = {
		category = "Rato's Explosive Overhaul",
		id = "ied_misfire_trap",
		editor = "bool",
		default = false,
		template = false,
		modifiable = false,

	}
	LandmineProperties.properties[#LandmineProperties.properties + 1] = {
		category = "Rato's Explosive Overhaul",
		id = "r_original_fx_actor",
		editor = "text",
		default = false,
		template = false,
		modifiable = false,

	}

end
function dynamic_spawned_props()
	DynamicSpawnLandmine.properties[#DynamicSpawnLandmine.properties + 1] = {
		category = "Rato's Explosive Overhaul",
		id = "r_original_fx_actor",
		editor = "text",
		default = false,
		template = false,
		modifiable = false,
	}

	DynamicSpawnLandmine.properties[#DynamicSpawnLandmine.properties + 1] = {
		category = "Rato's Explosive Overhaul",
		id = "ied_misfire_trap",
		editor = "bool",
		default = false,
		template = false,
		modifiable = false,

	}
end
function OnMsg.DataLoaded()
	dynamic_spawned_props()
end

landmine_props()
 ]] 
