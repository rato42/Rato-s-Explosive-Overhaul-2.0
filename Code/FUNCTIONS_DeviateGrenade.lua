---- TODO increase throw range, revise max throw dviation
------- maybe get angle from pre-deviation for HeavyWeapon
------------- revise sideways deviation
---------------------
function MishapProperties:rat_deviation(attacker, target_pos, attack_args, attack_pos)

	local deviatePosition = self:rat_custom_deviation(attacker, target_pos, attack_pos, false)
	if not deviatePosition then
		return target_pos, false
	end
	target_pos = IsKindOf(self, "Grenade") and validate_deviated_gren_pos(deviatePosition, attack_args) or
						             IsValidZ(deviatePosition) and deviatePosition or deviatePosition:SetTerrainZ()
	return target_pos, true
end

----------Args
local GR_base_pen = -10
local GR_dist_pen = 12
local RPG_dist_pen = 22
local GL_dist_pen = 23

------------Grenade

function Grenade:rat_custom_deviation(unit, target_pos, attack_pos, test)
	local deviation = 0
	local dex = unit.Dexterity
	local explo = unit.Explosives
	local thrower_perk = HasPerk(unit, "Throwing")
	local opt = CurrentModOptions.deviate_stat or "Dexterity/Explosives"

	dex = opt == "Dexterity" and dex or opt == "Explosives" and explo or cRound((dex + explo) / 2)
	dex = dex + GR_base_pen
	dex = thrower_perk and dex + 10 or dex
	dex = Max(45, dex)

	local max_range = self:GetMaxAimRange(unit)
	if thrower_perk then
		max_range = max_range + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease")
	end
	max_range = max_range * const.SlabSizeX
	local dist = attack_pos:Dist(target_pos)
	local ratio_dist = dist * 1.00 / max_range * 1.00
	local diff_dist = cRound(ratio_dist * GR_dist_pen)
	local ai_handicap = AI_deviate_handicap(unit)
	print(dist, max_range, ratio_dist, diff_dist)
	local item_acc = self:get_throw_accuracy(unit)
	local opt_diff = extractNumberWithSignFromString(CurrentModOptions.grenade_throw_diff) or 0
	local modifiers = -item_acc + opt_diff + diff_dist - ai_handicap

	if GameState.RainHeavy and IsKindOf(self, "GrenadeProperties") then
		modifiers = modifiers and modifiers + 10 or 10
	end

	local roll = 1 + unit:Random(99) + modifiers
	local diff = dex - roll
	local def_min_dev = 0.75
	local min_deviation = diff >= 50 and 0 or def_min_dev

	if roll <= 5 then
		deviation = 0
	else
		deviation = Max(min_deviation, (100 - diff) ^ 2 / 100 ^ 2 * 2)
	end

	deviation = CheatEnabled("AlwaysHit") and 0 or deviation
	deviation = CheatEnabled("AlwaysMiss") and 5 or deviation
	print("roll", roll, "diff", diff, "deviation", deviation)

	if test then
		return deviation, roll
	end

	local perfect_throw = deviation <= 0.05
	local float_text

	if perfect_throw then
		float_text = T("Perfect Throw")
	elseif deviation <= def_min_dev then
		float_text = T("Great Throw")
	elseif deviation >= 3.2 then
		float_text = T("<color AmmoAPColor>Terrible Throw</color>")
	elseif deviation >= 2 then
		float_text = T("<color AmmoAPColor>Innacurate Throw</color>")
	end

	if float_text then
		CreateFloatingText(unit:GetPos(), float_text)
	end

	if perfect_throw then
		return false
	end

	local sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1
	local angle_of_rotation = 20 * 60 * deviation / 5 * sign
	local dir = target_pos - attack_pos

	sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1
	local distance_multiplier = deviation / 12.00 * sign
	print("dist mul", distance_multiplier)
	local distance_deviation = dir:Len() * (1 + distance_multiplier)
	print("frist distance deviation", distance_deviation)
	if sign > 0 then
		distance_deviation = distance_deviation <= cRound(max_range * 1.5) and distance_deviation or dir:Len() *
							                     (1 + distance_multiplier * -1)
	end
	print("adjusted distance deviation", distance_deviation)

	DbgAddCircle_devi(target_pos, const.SlabSizeX / 6, const.clrGreen)
	DbgAddVector_devi(attack_pos, dir, const.clrGreen)

	local rotated_vector = Rotate(dir, angle_of_rotation)
	rotated_vector = SetLen(rotated_vector, distance_deviation)
	DbgAddVector_devi(attack_pos, rotated_vector, const.clrRed)
	local final_pos = attack_pos + rotated_vector

	return final_pos
end

function Grenade:get_throw_accuracy(unit)
	local shape_list = {
		Spherical = 0,
		Stick_like = 0,
		Cylindrical = -3,
		Long = -7,
		Brick = -5,
		Bottle = -11,
	}
	local acc = shape_list[self.r_shape] or 0
	if IsKindOf(self, "ShapedCharge") then
		acc = unit.unitdatadef_id ~= "Barry" and acc - 15 or acc + 5
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

function GrenadeLauncher:rat_custom_deviation(unit, target_pos, attack_pos, test)

	local deviation = 0
	local marks = unit.Marksmanship
	local explo = unit.Explosives

	local opt = CurrentModOptions.deviate_stat_GL or "Marksmanship/Explosives"
	local stat = (marks + explo) / 2

	stat = opt == "Marksmanship" and marks or opt == "Explosives" and explo or cRound((marks + explo) / 2)
	stat = Max(45, stat)

	local max_range = self.WeaponRange

	max_range = max_range * const.SlabSizeX
	local dist = attack_pos:Dist(target_pos)
	local ratio_dist = dist * 1.00 / max_range * 1.00
	local diff_dist = cRound(ratio_dist * GL_dist_pen)
	local ai_handicap = AI_deviate_handicap(unit)

	print(dist, max_range, ratio_dist, diff_dist)
	local item_acc = self:get_throw_accuracy(unit)
	local opt_diff = extractNumberWithSignFromString(CurrentModOptions.GL_throw_diff) or 0
	local modifiers = -item_acc + opt_diff + diff_dist - ai_handicap

	if GameState.RainHeavy and IsKindOf(self, "GrenadeProperties") then
		modifiers = modifiers and modifiers + 10 or 10
	end

	local roll = 1 + unit:Random(99) + modifiers
	local diff = stat - roll
	local def_min_dev = 0.75
	local min_deviation = diff >= 50 and 0 or def_min_dev

	if roll <= 5 then
		deviation = 0
	else
		deviation = Max(min_deviation, (100 - diff) ^ 2 / 100 ^ 2 * 2)
	end

	if test then
		return deviation, roll
	end

	local perfect_throw = deviation <= 0.05
	local float_text

	if perfect_throw then
		float_text = T("Perfect Launch")
	elseif deviation <= def_min_dev then
		float_text = T("Great Launch")
	elseif deviation >= 3.2 then
		float_text = T("<color AmmoAPColor>Terrible Launch</color>")
	elseif deviation >= 2 then
		float_text = T("<color AmmoAPColor>Innacurate Launch</color>")
	end

	if float_text then
		CreateFloatingText(unit:GetPos(), float_text)
	end

	if perfect_throw then
		return false
	end

	local sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1
	local angle_of_rotation = 20 * 60 * deviation / 5 * sign
	local dir = target_pos - attack_pos
	-- local max_range = self:GetMaxAimRange(unit)
	--[[ 
	if thrower_perk then
		max_range = max_range + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease")
	end ]]

	-- max_range = max_range * const.SlabSizeX
	sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1
	local distance_multiplier = deviation / 12 * sign
	print("hv distance multiplier", distance_multiplier)
	local distance_deviation = dir:Len() * (1 + distance_multiplier)

	--[[ 	if sign > 0 then
		distance_deviation = distance_deviation <= cRound(max_range * 1.3) and distance_deviation or dir:Len() *
							                     (1 + distance_multiplier * -1)
	end
 ]]
	DbgAddCircle_devi(target_pos, const.SlabSizeX / 6, const.clrGreen)
	DbgAddVector_devi(attack_pos, dir, const.clrGreen)

	local rotated_vector = Rotate(dir, angle_of_rotation)
	rotated_vector = SetLen(rotated_vector, distance_deviation)
	DbgAddVector_devi(attack_pos, rotated_vector, const.clrRed)
	local final_pos = attack_pos + rotated_vector

	return final_pos
end

function GrenadeLauncher:get_throw_accuracy(unit)
	if unit then
		local active_wep = unit:GetActiveWeapons()
		return self == active_wep and 0 or -8
	else
		return 0
	end
end

-----------RPG

function RocketLauncher:rat_custom_deviation(unit, target_pos, attack_pos, test)
	local deviation = 0
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
	local ai_handicap = AI_deviate_handicap(unit)

	print(dist, max_range, ratio_dist, diff_dist)

	local item_acc = self:get_throw_accuracy(unit)
	local opt_diff = extractNumberWithSignFromString(CurrentModOptions.RPG_throw_diff) or 0
	local modifiers = -item_acc + opt_diff + diff_dist - ai_handicap

	if GameState.RainHeavy and IsKindOf(self, "GrenadeProperties") then
		modifiers = modifiers and modifiers + 10 or 10
	end

	local roll = 1 + unit:Random(99) + modifiers
	local diff = stat - roll
	local def_min_dev = 0.75
	local min_deviation = diff >= 50 and 0 or def_min_dev

	if roll <= 5 then
		deviation = 0
	else
		deviation = Max(min_deviation, (100 - diff) ^ 2 / 100 ^ 2 * 2)
	end

	if test then
		return deviation, roll
	end

	local perfect_throw = deviation <= 0.05
	local float_text

	if perfect_throw then
		float_text = T("Perfect Launch")
	elseif deviation <= def_min_dev then
		float_text = T("Great Launch")
	elseif deviation >= 3.2 then
		float_text = T("<color AmmoAPColor>Terrible Launch</color>")
	elseif deviation >= 2 then
		float_text = T("<color AmmoAPColor>Innacurate Launch</color>")
	end

	if float_text then
		CreateFloatingText(unit:GetPos(), float_text)
	end

	if perfect_throw then
		return false
	end

	local sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1
	local angle_of_rotation = 20 * 60 * deviation / 5 * sign
	local dir = target_pos - attack_pos
	-- local max_range = self:GetMaxAimRange(unit)
	--[[ 
	if thrower_perk then
		max_range = max_range + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease")
	end ]]

	-- max_range = max_range * const.SlabSizeX
	sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1
	local distance_multiplier = deviation / 12 * sign
	print("hv distance multiplier", distance_multiplier)
	local distance_deviation = dir:Len() * (1 + distance_multiplier)

	--[[ 	if sign > 0 then
		distance_deviation = distance_deviation <= cRound(max_range * 1.3) and distance_deviation or dir:Len() *
							                     (1 + distance_multiplier * -1)
	end
 ]]
	DbgAddCircle_devi(target_pos, const.SlabSizeX / 6, const.clrGreen)
	DbgAddVector_devi(attack_pos, dir, const.clrGreen)

	local rotated_vector = Rotate(dir, angle_of_rotation)
	rotated_vector = SetLen(rotated_vector, distance_deviation)
	DbgAddVector_devi(attack_pos, rotated_vector, const.clrRed)
	local final_pos = attack_pos + rotated_vector

	return final_pos
end

function RocketLauncher:get_throw_accuracy(unit)
	return 0
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
