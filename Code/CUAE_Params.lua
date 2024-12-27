--[[function RATONADE_Cuaeparams()
    if not IsMod_loaded("LDCUAE") then
        return
    end

    print("RATONADE - assigning CUAE Params")

    local ieds = {
        "SmokeGrenade_IED", "TearGasGrenade_IED", "ConcussiveGrenade_IED", "Molotov", "TNTBolt_IED",
        "NailBomb_IED", "PipeBomb"
    }

    local non_ieds = {
        "IncendiaryGrenade", -- "FragGrenade", 
        "ConcussiveGrenade", "HE_Grenade", "HE_Grenade_1", "SmokeGrenade", "TearGasGrenade"
    }

    local affiliation_exclusion_table = {
        Legion = non_ieds,
        Thugs = non_ieds,
        Army = ieds,
        Adonis = ieds,
        SuperSoldiers = ieds
    }

    CUAEAddExclusionTable(affiliation_exclusion_table)

    ---- This doesnt work
    -- if Cuae_Whitelist then
    --     for i, ied in ipairs(ieds) do
    --         table.insert_unique(Cuae_Whitelist, ied)
    --     end
    -- end
end

function OnMsg.ModsReloaded()
    RATONADE_Cuaeparams()
end
]] 
