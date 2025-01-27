function MishapProperties:rat_deviation(attacker, target_pos, attack_args, attack_pos)

    local deviatePosition = self:rat_custom_deviation(attacker, target_pos, attack_pos, false)
    if not deviatePosition then
        return target_pos, false
    end
    -- DbgAddCircle(target_pos, const.SlabSizeX, const.clrGreen)
    -- DbgAddCircle(deviatePosition, const.SlabSizeX, const.clrRed)
    local target_posz = target_pos:z()

    -- target_pos = IsKindOf(self, "Grenade") and
    --                  validate_deviated_gren_pos(deviatePosition, attack_args) or
    --                  IsValidZ(deviatePosition) and deviatePosition or deviatePosition:SetTerrainZ()

    target_pos = validate_deviated_gren_pos(IsValidZ(deviatePosition) and deviatePosition or
                                                deviatePosition:SetZ(target_posz), attack_args)
    -- DbgAddCircle(target_pos, const.SlabSizeX, const.clrCyan)
    return target_pos, true
end

----------Args
local base_skill_modifier = 5
local GR_dist_pen = 16
local RPG_dist_pen = 19
local GL_dist_pen = 20

local accurate_angle_mul = 0.75 ---- when a throw is accurate or better, reduce the amount of angle deviation to minimize the chance of hitting close objects

local base_gr_rotation_factor = 22.00 ----- degree
local base_launcher_rotation_factor = 12.00 ----- degree
---------

function MishapProperties:rat_custom_deviation(unit, target_pos, attack_pos, test)
    -- if not target_pos then
    --     return false
    -- end
    local is_grenade = IsKindOf(self, "Grenade")
    local thrower_perk, max_range
    local ai_handicap = 0 -- AI_deviate_handicap(unit) or 0
    local ai_modifier = AI_deviate_skill_diff(unit) or 0

    if is_grenade then
        thrower_perk = HasPerk(unit, "Throwing")
        max_range = self:GetMaxAimRange(unit)
        if thrower_perk then
            max_range = max_range + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease") or 0
        end
    else
        max_range = self.WeaponRange
    end

    local stat = self:GetMishapChance(unit, target_pos)[1] - ai_modifier + ai_handicap
    stat = stat + base_skill_modifier
    local deviation = 0
    local roll = InteractionRand(100, "RATONADE_DeviationRoll", unit) + 1 -- 1 + unit:Random(100)
    local diff = stat - roll
    local def_min_dev = 0.75
    local min_deviation = diff >= 50 and 0 or def_min_dev

    local dev_thrs_innac_throw = 2.0
    local rotation_factor = is_grenade and base_gr_rotation_factor or base_launcher_rotation_factor
    local length_factor = 0.088

    if roll <= 5 then
        deviation = 0
    else
        deviation = Max(min_deviation, (100 - diff * 1.00) ^ 2 / 100 ^ 2 * 2)
    end

    deviation = CheatEnabled("AlwaysHit") and 0 or deviation
    deviation = CheatEnabled("AlwaysMiss") and 5 or deviation
    if Platform.developer then
        print("----RATONADE - DEBUG deviation")
        print("roll", roll, "stat", stat, "diff", diff, "deviation", deviation)
    end

    if test then
        return deviation, roll
    end

    local perfect_throw = deviation <= 0.05
    local float_text
    if is_grenade then
        if perfect_throw then
            float_text = T("Perfect Throw")
        elseif deviation <= def_min_dev then
            float_text = T("Great Throw")
        elseif deviation >= 3.2 then
            float_text = T("<color AmmoAPColor>Terrible Throw</color>")
        elseif deviation >= dev_thrs_innac_throw then
            float_text = T("<color AmmoAPColor>Innacurate Throw</color>")
        end
    else
        if perfect_throw then
            float_text = T("Perfect Launch")
        elseif deviation <= def_min_dev then
            float_text = T("Great Launch")
        elseif deviation >= 3.2 then
            float_text = T("<color AmmoAPColor>Terrible Launch</color>")
        elseif deviation >= dev_thrs_innac_throw then
            float_text = T("<color AmmoAPColor>Innacurate Launch</color>")
        end
    end

    if float_text then
        CreateFloatingText(target_pos, float_text)
    end

    if perfect_throw then
        return false
    end

    if deviation < dev_thrs_innac_throw then
        rotation_factor = rotation_factor * accurate_angle_mul
    end

    local sign = InteractionRand(2, "RATONADE_DeviationSign", unit)
    sign = sign == 1 and 1 or -1
    local angle_of_rotation = rotation_factor * 60 * deviation / 5 * sign
    local dir = target_pos - attack_pos

    sign = InteractionRand(2, "RATONADE_DeviationSign", unit)
    sign = sign == 1 and 1 or -1
    -- local distance_multiplier = deviation / 12.00 * sign
    local distance_multiplier = length_factor * deviation * sign

    local distance_deviation = dir:Len() * (1 + distance_multiplier)

    if is_grenade and sign > 0 then
        distance_deviation = distance_deviation <= cRound(max_range * 1.5) and distance_deviation or
                                 dir:Len() * (1 + distance_multiplier * -1)
    end

    DbgAddCircle_devi(target_pos, const.SlabSizeX / 6, const.clrGreen)
    DbgAddVector_devi(attack_pos, dir, const.clrGreen)

    local rotated_vector = Rotate(dir, angle_of_rotation)
    rotated_vector = SetLen(rotated_vector, distance_deviation)
    DbgAddVector_devi(attack_pos, rotated_vector, const.clrRed)
    local final_pos = attack_pos + rotated_vector

    return final_pos
end

------------Grenade

function Grenade:GetMishapChance(unit, target, async)
    local attack_pos = unit:GetPos()
    local target_pos = target
    if not target then
        return {0, 0}
    end
    local dex = unit.Dexterity
    local explo = unit.Explosives
    local thrower_perk = HasPerk(unit, "Throwing")
    local opt = CurrentModOptions.deviate_stat or "Dexterity/Explosives"

    dex = opt == "Dexterity" and dex or opt == "Explosives" and explo or cRound((dex + explo) / 2)
    dex = dex + 0
    dex = thrower_perk and dex + 10 or dex
    dex = Max(45, dex)

    local max_range = self:GetMaxAimRange(unit)
    if thrower_perk then
        max_range = max_range + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease") or 0
    end
    max_range = max_range * const.SlabSizeX
    local dist = attack_pos:Dist(target_pos)
    local ratio_dist = dist * 1.00 / max_range * 1.00
    local diff_dist = cRound(ratio_dist * GR_dist_pen)

    -- print(dist, max_range, ratio_dist, diff_dist)
    local item_acc = self:get_throw_accuracy(unit)
    local opt_diff = extractNumberWithSignFromString(CurrentModOptions.grenade_throw_diff) or 0
    local modifiers = -item_acc + opt_diff + diff_dist
    local modifiers = HasPerk(unit, "Inaccurate") and modifiers + 15 or modifiers

    if GameState.RainHeavy and IsKindOf(self, "GrenadeProperties") then
        modifiers = modifiers and modifiers + 10 or 10
    end
    return {Max(0, dex - modifiers)}
end

function Grenade:get_throw_accuracy(unit)
    local shape_list = {
        Spherical = 0,
        Stick_like = 0,
        Cylindrical = -2,
        Can = -3,
        Long = -5,
        Brick = -4,
        Bottle = -6
    }
    local acc = shape_list[self.r_shape] or 0

    if IsKindOf(self, "FlareStick") or IsKindOf(self, "GlowStick") then
        acc = acc + 6
    end

    if IsKindOf(self, "ShapedCharge") then
        acc = unit and unit.unitdatadef_id == "Barry" and acc or acc - 25
    end
    return acc
end

function validate_deviated_gren_pos(explosion_pos, attack_args)
    local newGroundPos
    if explosion_pos then
        local slab, slab_z = WalkableSlabByPoint(explosion_pos, "downward only")
        local z = explosion_pos:z()
        if slab_z and slab_z <= z and slab_z >= z - guim then
            newGroundPos = explosion_pos:SetZ(slab_z)
        else
            newGroundPos = explosion_pos:SetTerrainZ()
            local col, pts = CollideSegmentsNearest(explosion_pos, newGroundPos)
            if col then
                newGroundPos = pts[1]
            end
        end
    end
    return newGroundPos
end

-----------GL
function GrenadeLauncher:GetMishapChance(unit, target, async)
    local attack_pos = unit:GetPos()
    local target_pos = target

    if not target then
        return {0, 0}
    end

    local deviation = 0
    local marks = unit.Marksmanship
    local explo = unit.Explosives

    local opt = CurrentModOptions.deviate_stat_GL or "Marksmanship/Explosives"
    local stat = (marks + explo) / 2

    stat = opt == "Marksmanship" and marks or opt == "Explosives" and explo or
               cRound((marks + explo) / 2)
    stat = Max(45, stat)

    local max_range = self.WeaponRange

    max_range = max_range * const.SlabSizeX
    local dist = attack_pos:Dist(target_pos)
    local ratio_dist = dist * 1.00 / max_range * 1.00
    local diff_dist = cRound(ratio_dist * GL_dist_pen)

    local item_acc = self:get_throw_accuracy(unit)
    local opt_diff = extractNumberWithSignFromString(CurrentModOptions.GL_throw_diff) or 0
    local modifiers = -item_acc + opt_diff + diff_dist

    if GameState.RainHeavy and IsKindOf(self, "GrenadeProperties") then
        modifiers = modifiers and modifiers + 10 or 10
    end

    return {Max(0, stat - modifiers)}
end

function GrenadeLauncher:get_throw_accuracy(unit)
    if unit then
        local active_wep = unit:GetActiveWeapons()
        return self == active_wep and 0 or -8
    end
    return 0
end

-----------RPG

function RocketLauncher:GetMishapChance(unit, target, async)
    local attack_pos = unit:GetPos()
    local target_pos = target

    if not target then
        return {0, 0}
    end

    local str = unit.Strength
    local explo = unit.Explosives

    local opt = CurrentModOptions.deviate_stat_RPG or "Strength/Explosives"
    local stat = (str + explo) / 2

    stat = opt == "Strength" and str or opt == "Explosives" and explo or cRound((str + explo) / 2)
    stat = Max(45, stat)

    local max_range = self.WeaponRange

    max_range = max_range * const.SlabSizeX
    local dist = attack_pos:Dist(target_pos)
    local ratio_dist = dist * 1.00 / max_range * 1.00
    local diff_dist = cRound(ratio_dist * RPG_dist_pen)

    -- print(dist, max_range, ratio_dist, diff_dist)

    local item_acc = self:get_throw_accuracy(unit)
    local opt_diff = extractNumberWithSignFromString(CurrentModOptions.RPG_throw_diff) or 0
    local modifiers = -item_acc + opt_diff + diff_dist

    if GameState.RainHeavy and IsKindOf(self, "GrenadeProperties") then
        modifiers = modifiers and modifiers + 10 or 10
    end

    return {Max(0, stat - modifiers)}
end

function RocketLauncher:get_throw_accuracy(unit)
    return 0
end
-------------
function get_label_throwacc(num)
    if num == 100 then
        return T("Perfect")
    elseif num >= 90 then
        return T("Very High")
    elseif num >= 80 then
        return T("High")
    elseif num >= 70 then
        return T("Moderately High")
    elseif num >= 60 then
        return T("Medium")
    elseif num >= 50 then
        return T("Moderately Low")
    elseif num >= 40 then
        return T("Low")
    elseif num >= 30 then
        return T("Very Low")
    elseif num >= 20 then
        return T("Extremely Low")
    else
        return T("Abysmal")
    end
end
------------------Tests

function deviation_prob(dex, expl, steps, not_round)
    local dex = dex or 80
    local expl = expl or 80
    local steps = steps or 0.5
    local deviations = {}
    local unit = g_Units.Barry
    unit.Dexterity = dex
    unit.Explosives = expl
    local grenade = unit:GetItemInSlot("Handheld A", "Grenade", 1, 1)
    local mishap_chance = grenade:GetMishapChance(unit, unit:GetPos())
    local num_rolls = 10000
    local deviation
    for i = 1, num_rolls do
        local mishap = unit:Random(100) < mishap_chance and "mishap"
        deviation = mishap or self:rat_custom_deviation(unit, false, false, true)
        if not not_round then
            deviation = not mishap and cRoundFlt(deviation, steps) or deviation
        end
        if not deviations[deviation] then
            deviations[deviation] = 1
        else
            deviations[deviation] = deviations[deviation] + 1
        end
    end
    local sorted_keys = {}
    for deviation, _ in pairs(deviations) do
        table.insert(sorted_keys, deviation)
    end
    table.sort(sorted_keys, function(a, b)
        if a == "mishap" then
            return false
        elseif b == "mishap" then
            return true
        else
            return a < b
        end
    end)
    print("Deviation   Probability   for " .. dex .. " dex and " .. expl, " expl")
    for _, deviation in ipairs(sorted_keys) do
        local probability = deviations[deviation] / num_rolls * 100
        print(deviation .. "         " .. probability)
    end
end

function test_roll()
    local unit = g_Units.Barry
    local num_rolls = 10000
    local deviations = {}
    local deviation
    for i = 1, num_rolls do
        deviation = 1 + unit:Random(100)
        if deviations[deviation] == nil then
            deviations[deviation] = 1
        else
            deviations[deviation] = deviations[deviation] + 1
        end
    end
    for deviation, count in pairs(deviations) do
        local probability = count / num_rolls * 100
        print(deviation .. "         " .. probability)
    end
end
