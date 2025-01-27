function determine_IED_misfire_chance(item, unit, override_stat)
    local amount = item and item.Amount or 1
    local chances = {}

    local random_factor = 12
    local max_chance = 35
    local min_chance = 5
    local max_skill = 100
    local min_skill = -10

    local stat = override_stat or unit.Explosives

    for i = 1, amount do
        local random = InteractionRand(random_factor * 2, "RATONADE_IED_misfire_chance") + 1 -- unit:Random(random_factor * 2) + 1
        random = random - random_factor
        local skill = Max(min_skill, Min(max_skill, stat + random))
        local slope = max_chance - min_chance
        local skill_rating = skill * 1.00 / max_skill * 1.00
        local chance = min_chance + slope * (1.00 - skill_rating)
        chance = cRound(chance)
        if ratG_simple_ied_misfire then
            return chance
        end
        chances[i] = chance
        -- print("---", i, random, skill, chance)
    end

    return chances
end

function test_chance(explo)
    local item = {}
    item.Amount = 10
    local unit = g_Units["Barry"]
    unit.Explosives = explo or 70
    determine_IED_misfire_chance(item, unit)
end
