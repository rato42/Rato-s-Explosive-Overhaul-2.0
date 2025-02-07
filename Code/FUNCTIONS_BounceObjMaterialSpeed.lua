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
        ['cistern'] = 0.8

    }

    local coeff = ((coefficients_materials[material]) or 0.45)

    local gren_adj = (get_grenade_bounce_adj(grenade) or 1)
    local factor = (speed ^ 1.01) * coeff * 0.25 * const.SlabSizeX * gren_adj
    return factor > 0 and factor or false

end

function get_grenade_bounce_adj(grenade)
    local shp = grenade.r_shape or ""
    local shape_adj =
        shp == "Stick_like" and 0.75 or shp == "Long" and 0.66 or shp == "Cylindrical" and 0.9 or
            shp == "Can" and 0.9 or 1.0
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
        [9] = "florest_floor" -- TerrainJungleForest_Floor_02_mesh

    }

    return data[material] or "other"
end
