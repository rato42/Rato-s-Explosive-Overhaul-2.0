function get_bounce_distance(speed, obj_material, grenade)

	-- local material = obj_material:match(":%s*(.+)$")

	local material = get_material_group(obj_material)

	-- print("material", material, obj_material)

	local coefficients_materials = {
		['water'] = 0.08,
		['mud_wet'] = 0.170,
		['mud'] = 0.220,
		['moss'] = 0.275,
		['paper'] = 0.275,
		['meat'] = 0.275,
		['sand'] = 0.3, -- 0.275,
		['dirt'] = 0.3, -- 0.413,
		['farmland'] = 0.385,
		['forest_floor'] = 0.385,
		['grass'] = 0.413,
		['debris'] = 0.413,
		['bone'] = 0.39,
		['dry_earth'] = 0.413,
		['trash'] = 0.413,
		['carpet'] = 0.385,
		['gravel'] = 0.5,
		['cloth'] = 0.3,
		['sandbag'] = 0.4,
		['tin'] = 0.65,
		['stony_ground'] = 0.62,
		['wood'] = 0.675,
		['ceramic'] = 0.675,
		['plywood'] = 0.675,
		['electronics'] = 0.675,
		['clay_brick'] = 0.675,
		['plastic'] = 0.75,
		['city_sidewalk'] = 0.75,
		['brick'] = 0.75,
		['asphalt'] = 0.75,
		['rubber'] = 0.80,
		['glass'] = 0.80,
		['concrete'] = 0.80,
		['rock'] = 0.80,
		['metal'] = 0.86,
		['metal_props'] = 0.8,
		['other'] = 0.45,
		['cistern'] = 0.8,

	}

	local coeff = ((coefficients_materials[material]) or 0.45)

	local gren_adj = (get_grenade_bounce_adj(grenade) or 1)
	local factor = (speed ^ 1.01) * coeff * 0.25 * const.SlabSizeX * gren_adj
	return factor > 0 and factor or false

end

function get_grenade_bounce_adj(grenade)
	local shp = grenade.r_shape or ""
	local shape_adj = shp == "Stick_like" and 0.75 or shp == "Long" and 0.66 or shp == "Cylindrical" and 0.9 or shp ==
						                  "Can" and 0.9 or 1.0
	local mass_adj = 1 + grenade_mass_factor_adjusted(grenade, 4)
	local soft_mod = grenade.r_soft_surface and 0.4 or 1.0
	return shape_adj * mass_adj * soft_mod
end

function grenade_mass_factor_adjusted(grenade, adj)
	local adj = adj or 2
	local mass_ratio = (grenade.r_mass or 600.00) / 600.00
	mass_ratio = (1 - mass_ratio)
	local mass_adj = (mass_ratio) / adj
	return mass_adj
end

function get_material_group(material)

	local data = {
		['Water'] = "water",
		['Grass'] = "grass",
		['grass_Props'] = "grass",
		['grasss_inv'] = "grass",
		['Carpet_Solid'] = "carpet",
		['Matress_Solid'] = "carpet",
		['Sand'] = "sand",
		['Wallpaper'] = "paper",
		['Papers'] = "paper",
		['Meat'] = "meat",
		['Flesh'] = "meat",
		['Dirt'] = "dirt",
		['Cloth_Prop'] = "cloth",
		['Cloth_Solid'] = "cloth",
		['Debris'] = "debris",
		['Bone_Prop'] = "bone",
		['Bone_Solid'] = "bone",
		['Rubber'] = "rubber",
		['Sticks_Props'] = "wood",
		['Sticks_Solids'] = "wood",
		['Sandbag'] = "sandbag",
		['Plastic'] = "plastic",
		['Ceramic_Prop'] = "ceramic",
		['Plywood'] = "plywood",
		['Tin'] = "tin",
		['Tin_Props'] = "tin",
		['Planks'] = "wood",
		['Wood'] = "wood",
		['Wood_Props'] = "wood",
		['Logs'] = "wood",
		['Wood_inv'] = "wood",
		['Electronics_Prop'] = "electronics",
		['Brick'] = "brick",
		['Brick_Inv'] = "brick",
		['Brick_Prop'] = "brick",
		['Brick_Solid'] = "brick",
		['Tiles'] = "city_sidewalk",
		['Landmine'] = "landmine",
		['ClayBrick'] = "clay_brick",
		['Glass'] = "glass",
		['Concrete'] = "concrete",
		['ConcreteThin'] = "concrete",
		['Stone'] = "rock",
		['Rock'] = "rock",
		['Metal_Inv_Imp'] = "metal",
		['Metal_Inv_Penetrable'] = "metal",
		['Metal_Props'] = "metal_props",
		['Metalsheets'] = "metal_props",
		["Cardboard"] = "paper",
		['Mud'] = "mud",
		["ShallowWater"] = "water",
		['Metal_Props_Hard'] = "metal",
		['Metal_Solid'] = "metal",
		['Metal_Solid_Hard'] = "metal",
		["Explosive_Barrel"] = "metal",
		["Explosive_Vehicle"] = "metal",
		["Explosive_Cistern"] = "cistern",
		[0] = "florest_floor", -- TerrainJungleGround_mesh
		[1] = "grass", -- TerrainJungleGrass_mesh
		[10] = "sand", -- TerrainBeachSand_01_mesh
		[11] = "sand", -- TerrainBeachSand_02_mesh
		[12] = "sand", -- TerrainBeachSand_03_mesh
		[13] = "sand", -- TerrainBeachSand_04_mesh
		[14] = "sand", -- TerrainBeachSand_05_mesh
		[15] = "mud_wet", -- TerrainJungleMud_Wet_mesh
		[16] = "mud", -- TerrainJungleMud_01_mesh
		[17] = "mud", -- TerrainJungleMud_02_mesh
		[18] = "moss", -- TerrainJungleMoss_mesh
		[19] = "grass", -- TerrainGrass_01_mesh
		[2] = "grass", -- TerrainJungleGrass_Mix_mesh
		[20] = "bone", -- TerrainSkeletonGraveyard_mesh
		[21] = "concrete", -- TerrainMilitaryConcrete_01_mesh
		[22] = "concrete", -- TerrainMilitaryConcrete_02_mesh
		[23] = "concrete", -- TerrainMilitaryConcrete_03_mesh
		[24] = "dry_earth", -- TerrainDry_01_mesh
		[25] = "dry_earth", -- TerrainDry_02_mesh
		[26] = "dry_earth", -- TerrainDry_03_mesh
		[27] = "dry_earth", -- TerrainDry_04_mesh
		[3] = "mud", -- TerrainJungleMud_Dry_mesh
		[32] = "dry_earth", -- TerrainDry_05_mesh
		[33] = "dry_earth", -- TerrainBurntGround_01_mesh
		[34] = "dry_earth", -- TerrainBurntGround_02_mesh
		[35] = "stony_ground", -- TerrainDryStony_01_mesh
		[37] = "stony_ground", -- TerrainDryRock_01_mesh
		[38] = "stony_ground", -- TerrainDryRock_02_mesh
		[39] = "stony_ground", -- TerrainDryStony_02_mesh
		[4] = "florest_floor", -- TerrainJungleForest_Floor_01_mesh
		[40] = "trash", -- TerrainDump_01_mesh
		[41] = "city_sidewalk", -- TerrainCityDecoTiles_01_mesh
		[42] = "stony_ground", -- TerrainMineToxic_01_mesh
		[43] = "gravel", -- TerrainCityGravel_01_mesh
		[44] = "dry_earth", -- TerrainSavannaGround_02_mesh
		[45] = "water", -- TerrainRiverBottomWalkable_mesh
		-- [46]	= ""               ,        -- TerrainAzollaPinnata_01_mesh
		[47] = "water", -- TerrainRiverImpassable_mesh
		[48] = "farmland", -- TerrainFarmland_01_mesh
		[5] = "sand", -- TerrainJungleSand_mesh
		[50] = "asphalt", -- TerrainAsphalt_01_mesh
		[51] = "asphalt", -- TerrainAsphalt_02_mesh
		[52] = "mud_wet", -- TerrainJungleMud_Wet_02_mesh
		[53] = "mud", -- TerrainJungleMud_Mix_mesh
		[6] = "florest_floor", -- TerrainJungleGround_Mix_mesh
		[7] = "florest_floor", -- TerrainJungleForest_Floor_03_mesh
		-- [8]	    = ""           ,        -- TerrainBlack_mesh
		[9] = "florest_floor", -- TerrainJungleForest_Floor_02_mesh

	}

	return data[material] or "other"
end
--[[function grenade_mass_factor_adjusted(grenade ,adj )

	local adj = adj or 2
	--tonumber(string.format("%.2f",((grenade.r_mass or 350.00) /350.00 )))
	local mass_ratio = (grenade.r_mass or 350.00) /350.00 
	print(mass_ratio)
	mass_ratio = (mass_ratio -1)
	print("mass diff", mass_ratio)
	--adj = mass_ratio < 1 and -adj or adj
	local pow_mass_ratio = my_pow(mass_ratio, adj)
	print("pow_mass_ratio", pow_mass_ratio)
	--pow_mass_ratio = mass_ratio < 1 and -pow_mass_ratio or pow_mass_ratio
	mass_ratio = mass_ratio+1
	print("pow_mass_ratio", pow_mass_ratio)
	return mass_ratio
end]]
--[[function get_grenade_bounce_adj(grenade)
	
	
	--shape_adj = tonumber(string.format("%.2f". shape_adj))
	--local mass_adj = tonumber(string.format("%.2f",((grenade.r_mass or 350.00) /350.00 )))^0.5
	local mass_adj = 1 + grenade_mass_factor_adjusted(grenade,2)
	--local mass_adj = MulDivRound((grenade.r_mass or 350)*100,100,350)*0.33
	
	return mass_adj
end


function grenade_mass_factor_adjusted(grenade ,adj )

	local adj = adj or 2
	--local mass_adj = --math.sqrt((grenade.r_mass or 350.00) / 350.00)
	local mass_adj = ((grenade.r_mass or 350.00) / 350.00)
	--mass_adj = sqrt(mass_adj*100)/100.00
	mass_adj = tonumber(string.format("%.2f",mass_adj))-1
	print("massadj before adj", mass_adj)
	
	mass_adj = mass_adj / adj 
	print("massadj", mass_adj)
	return mass_adj
end]]
-- local coefficients_materials = {
-- ["Bone_Prop"] = 0.51,
-- ["Bone_Solid"] = 0.51,
-- ["Ceramic_Prop"] = 0.595,
-- ["Cloth_Prop"] = 0.425,
-- ["Cloth_Solid"] = 0.425,
-- ["Electronics_Prop"] = 0.68,
-- ["Papers"] = 0.34,
-- ["Plywood"] = 0.595,
-- ["Rubber"] = 0.51,
-- ["Trees"] = 0.765,
-- ["Body_Inv"] = 0.51,
-- ["Body_Solid"] = 0.51,
-- ["none"] = 0.2,
-- ["Wallpaper"] = 0.34,
-- ["Sticks_Props"] = 0.51,
-- ["Sticks_Solids"] = 0.51,
-- ["Tin"] = 0.595,
-- ["Tin_Props"] = 0.595,
-- ["Brick"] = 0.68,
-- ["Brick_Inv"] = 0.68,
-- ["Brick_Prop"] = 0.68,
-- ["Brick_Solid"] = 0.68,
-- ["Tiles"] = 0.68,
-- ["Meat"] = 0.34,
-- ["Planks"] = 0.595,
-- ["Landmine"] = 0.68,
-- ["Metal_Inv_Imp"] = 0.85,
-- ["Metal_Inv_Penetrable"] = 0.85,
-- ["Metal_Props"] = 0.85,
-- ["Metal_Props_Hard"] = 0.85,
-- ["Metal_Solid"] = 0.85,
-- ["Metal_Solid_Hard"] = 0.85,
-- ["Wood"] = 0.595,
-- ["Wood_Props"] = 0.595,
-- ["Logs"] = 0.595,
-- ["Wood_inv"] = 0.595,
-- ["Concrete"] = 0.765,
-- ["ConcreteThin"] = 0.765,
-- ["Sandbag"] = 0.51,
-- ["Stone"] = 0.765,
-- ["ClayBrick"] = 0.68,
-- ["Grass"] = 0.17,
-- ["grass_Props"] = 0.17,
-- ["grasss_inv"] = 0.17,
-- ["Flesh"] = 0.34,
-- ["Water"] = 0.0,
-- ["Rock"] = 0.765,
-- ["Debris"] = 0.425,
-- ["Dirt"] = 0.34,
-- ["Carpet_Solid"] = 0.255,
-- ["Matress_Solid"] = 0.255,
-- ["Plastic"] = 0.51,
-- ["Glass"] = 0.68,
-- ["Explosive_Barrel"] = 0.765,
-- ["Explosive_Cistern"] = 0.765,
-- ["Explosive_Vehicle"] = 0.765,
-- ["Sand"] = 0.255,
-- [0] = 0.34,
-- [1] = 0.17,
-- [2] = 0.17,
-- [3] = 0.425,
-- [4] = 0.255,
-- [5] = 0.17,
-- [6] = 0.255,
-- [7] = 0.255,
-- [8] = 0.34,
-- [9] = 0.255,
-- [10] = 0.255,
-- [11] = 0.255,
-- [12] = 0.255,
-- [13] = 0.255,
-- [14] = 0.255,
-- [15] = 0.17,
-- [16] = 0.255,
-- [17] = 0.255,
-- [18] = 0.17,
-- [19] = 0.17,
-- [20] = 0.425,
-- [21] = 0.765,
-- [22] = 0.765,
-- [23] = 0.765,
-- [24] = 0.255,
-- [25] = 0.255,
-- [26] = 0.255,
-- [27] = 0.255,
-- [32] = 0.255,
-- [33] = 0.255,
-- [34] = 0.255,
-- [35] = 0.765,
-- [37] = 0.765,
-- [38] = 0.765,
-- [39] = 0.765,
-- [40] = 0.51,
-- [41] = 0.595,
-- [42] = 0.68,
-- [43] = 0.34,
-- [44] = 0.51,
-- [45] = 0.51,
-- [46] = 0.51,
-- [47] = 0.0,
-- [48] = 0.425,
-- [50] = 0.765,
-- [51] = 0.765,
-- [52] = 0.17,
-- [53] = 0.255,
-- }

--[[local coefficients_materials = {
		["Bone_Prop"] = 0.6,
		["Bone_Solid"] = 0.6,
		["Ceramic_Prop"] = 0.7,
		["Cloth_Prop"] = 0.5,
		["Cloth_Solid"] = 0.5,
		["Electronics_Prop"] = 0.8,
		["Papers"] = 0.4,
		["Plywood"] = 0.7,
		["Rubber"] = 0.6,
		["Trees"] = 0.9,
		["Body_Inv"] = 0.6,
		["Body_Solid"] = 0.6,
		["none"] = 0.2,--1.0, -- No effect
		["Wallpaper"] = 0.4,
		["Sticks_Props"] = 0.6,
		["Sticks_Solids"] = 0.6,
		["Tin"] = 0.7,
		["Tin_Props"] = 0.7,
		["Brick"] = 0.8,
		["Brick_Inv"] = 0.8,
		["Brick_Prop"] = 0.8,
		["Brick_Solid"] = 0.8,
		["Tiles"] = 0.8,
		["Meat"] = 0.4,--0.6,
		["Planks"] = 0.7,
		["Landmine"] = 0.8,
		["Metal_Inv_Imp"] = 1.0,
		["Metal_Inv_Penetrable"] = 1.0,
		["Metal_Props"] = 1.0,
		["Metal_Props_Hard"] = 1.0,
		["Metal_Solid"] = 1.0,
		["Metal_Solid_Hard"] = 1.0,
		["Wood"] = 0.7,
		["Wood_Props"] = 0.7,
		["Logs"] = 0.7,
		["Wood_inv"] = 0.7,
		["Concrete"] = 0.9,
		["ConcreteThin"] = 0.9,
		["Sandbag"] = 0.6,--0.8,
		["Stone"] = 0.9,
		["ClayBrick"] = 0.8,
		["Grass"] = 0.2,--0.4,
		["grass_Props"] = 0.2,--0.4,
		["grasss_inv"] = 0.2,--0.4,
		["Flesh"] = 0.4,--0.6,
		["Water"] = 0.0,
		["Rock"] = 0.9,
		["Debris"] = 0.5,
		["Dirt"] = 0.4, --0.5,
		["Carpet_Solid"] = 0.3,--0.5,
		["Matress_Solid"] = 0.3,--0.6,
		["Plastic"] = 0.6,
		["Glass"] = 0.8,
		["Explosive_Barrel"] = 0.9,
		["Explosive_Cistern"] = 0.9,
		["Explosive_Vehicle"] = 0.9,
		
		["Sand"] = 0.3,
		[0] = 0.4, --0.5,  			-- TerrainJungleGround_mesh
		[1] = 0.2,--0.4,  		-- TerrainJungleGrass_mesh
		[2] = 0.2,--0.4, 		-- TerrainJungleGrass_Mix_mesh
		[3] = 0.5,  			-- TerrainJungleMud_Dry_mesh
		[4] = 0.3,--0.5,  		-- TerrainJungleForest_Floor_01_mesh
		[5] = 0.2,--0.5, 		 -- TerrainJungleSand_mesh
		[6] = 0.3,--0.5,  		-- TerrainJungleGround_Mix_mesh
		[7] = 0.3,--0.5,  		-- TerrainJungleForest_Floor_03_mesh
		[8] = 0.4,  			-- TerrainBlack_mesh
		[9] = 0.3,--0.5,  -- TerrainJungleForest_Floor_02_mesh
		[10] = 0.3, --0.6, -- TerrainBeachSand_01_mesh
		[11] = 0.3, --0.6, -- TerrainBeachSand_02_mesh
		[12] = 0.3, --0.6, -- TerrainBeachSand_03_mesh
		[13] = 0.3, --0.6, -- TerrainBeachSand_04_mesh
		[14] = 0.3, --0.6, -- TerrainBeachSand_05_mesh
		[15] = 0.2, --0.6, -- TerrainJungleMud_Wet_mesh
		[16] = 0.3, --0.5, -- TerrainJungleMud_01_mesh
		[17] = 0.3, --0.5, 		-- TerrainJungleMud_02_mesh
		[18] = 0.2,--0.4, -- TerrainJungleMoss_mesh
		[19] = 0.2,-- 0.4, -- TerrainGrass_01_mesh
		[20] = 0.5, 		-- TerrainSkeletonGraveyard_mesh
		[21] = 0.9, --0.7, -- TerrainMilitaryConcrete_01_mesh
		[22] = 0.9, --0.7, -- TerrainMilitaryConcrete_02_mesh
		[23] = 0.9, --0.7, -- TerrainMilitaryConcrete_03_mesh
		[24] = 0.5, --0.5, -- TerrainDry_01_mesh
		[25] = 0.5,			-- TerrainDry_02_mesh
		[26] = 0.5,			-- TerrainDry_03_mesh
		[27] = 0.5,			-- TerrainDry_04_mesh
		[32] = 0.5,			-- TerrainDry_05_mesh
		[33] = 0.5,			-- TerrainBurntGround_01_mesh
		[34] = 0.5,			-- TerrainBurntGround_02_mesh
		[35] = 0.9,  --0.6,			-- TerrainDryStony_01_mesh
		[37] = 0.9,  --0.6,			-- TerrainDryRock_01_mesh
		[38] = 0.9,  --0.6,			-- TerrainDryRock_02_mesh
		[39] = 0.9,  --0.6,			-- TerrainDryStony_02_mesh
		[40] = 0.6,			-- TerrainDump_01_mesh
		[41] = 0.7,			-- TerrainCityDecoTiles_01_mesh
		[42] = 0.8,			-- TerrainMineToxic_01_mesh
		[43] = 0.4,--0.7,			-- TerrainCityGravel_01_mesh
		[44] = 0.6,			-- TerrainSavannaGround_02_mesh
		[45] = 0.6,			-- TerrainRiverBottomWalkable_mesh
		[46] = 0.6,			-- TerrainAzollaPinnata_01_mesh
		[47] = 0.0, --0.6, -- TerrainRiverImpassable_mesh
		[48] = 0.5,--0.7, -- TerrainFarmland_01_mesh
		[50] = 0.9,--0.7, -- TerrainAsphalt_01_mesh
		[51] = 0.9,--0.7, -- TerrainAsphalt_02_mesh
		[52] = 0.2,--0.6, 		-- TerrainJungleMud_Wet_02_mesh
		[53] = 0.3,--0.6, 		-- TerrainJungleMud_Mix_mesh
	}]]

-- TerrainJungleGround_mesh
-- TerrainJungleGrass_mesh
-- TerrainBeachSand_01_mesh
-- TerrainBeachSand_02_mesh
-- TerrainBeachSand_03_mesh
-- TerrainBeachSand_04_mesh
-- TerrainBeachSand_05_mesh
-- TerrainJungleMud_Wet_mesh
-- TerrainJungleMud_01_mesh
-- TerrainJungleMud_02_mesh
-- TerrainJungleMoss_mesh
-- TerrainGrass_01_mesh
-- TerrainJungleGrass_Mix_mesh
-- TerrainSkeletonGraveyard_mesh
-- TerrainMilitaryConcrete_01_mesh
-- TerrainMilitaryConcrete_02_mesh
-- TerrainMilitaryConcrete_03_mesh
-- TerrainDry_01_mesh
-- TerrainDry_02_mesh
-- TerrainDry_03_mesh
-- TerrainDry_04_mesh
-- TerrainJungleMud_Dry_mesh
-- TerrainDry_05_mesh
-- TerrainBurntGround_01_mesh
-- TerrainBurntGround_02_mesh
-- TerrainDryStony_01_mesh
-- TerrainDryRock_01_mesh
-- TerrainDryRock_02_mesh
-- TerrainDryStony_02_mesh
-- TerrainJungleForest_Floor_01_mesh
-- TerrainDump_01_mesh
-- TerrainCityDecoTiles_01_mesh
-- TerrainMineToxic_01_mesh
-- TerrainCityGravel_01_mesh
-- TerrainSavannaGround_02_mesh
-- TerrainRiverBottomWalkable_mesh
-- TerrainJungleForest_Floor_01_mesh
-- TerrainRiverImpassable_mesh
-- TerrainFarmland_01_mesh
-- TerrainJungleSand_mesh
-- TerrainAsphalt_01_mesh
-- TerrainAsphalt_02_mesh
-- TerrainJungleMud_Wet_02_mesh
-- TerrainJungleMud_Mix_mesh
-- TerrainJungleGround_Mix_mesh
-- TerrainJungleForest_Floor_03_mesh
-- TerrainBlack_mesh
-- TerrainJungleForest_Floor_02_mesh
