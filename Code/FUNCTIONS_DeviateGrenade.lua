function rat_custom_deviation(unit, target_pos, mishap_chance, test, attack_pos, grenade)
	local deviation = 0
	local dex = unit.Dexterity  
	local explo = unit.Explosives
	local thrower_perk = HasPerk(unit, "Throwing")
	
	local opt = CurrentModOptions['deviate_stat'] or "Dexterity/Explosives"
	dex = (opt == "Dexterity" and dex) or
		  (opt == "Explosives" and explo) or
		  (opt == "Dexterity/Explosives" and (cRound((dex+explo)/2.00)))
		  
	dex = dex -5 
	dex = thrower_perk and dex + 10 or dex
	dex = Max(45, dex)
	
	
	local item_acc = grenade:get_throw_accuracy(unit)
	local opt_diff = extractNumberWithSignFromString(CurrentModOptions['grenade_throw_diff']) or 0
	
	local modifiers = (-item_acc) + opt_diff
	
	
	
	
	
	
	if GameState.RainHeavy and IsKindOf(grenade, "GrenadeProperties") then
		modifiers = modifiers and modifiers + 10 or 10
	end

	-------------------------

	
	local roll = 1 + unit:Random(99) + modifiers
	
	
	local diff = dex - roll 



	local def_min_dev = 0.75
	local min_deviation = diff >= 50 and 0 or def_min_dev
	if roll <= 5 then
		deviation = 0
	else
		deviation = Max(min_deviation,((100 - diff)^2 / 100.00^2 * 2.0))
	end
	

	
	--deviation = Min(5.00, deviation)
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
		CreateFloatingText(unit:GetPos(),  float_text)
	end
	
	if perfect_throw then
		return false
	end
	
	
	
	
	local sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1

	local angle_of_rotation = 20*60*deviation/5*sign


	
	local dir = target_pos - attack_pos
	
	local max_range = grenade:GetMaxAimRange(unit)
	if thrower_perk then
		max_range = max_range + CharacterEffectDefs.Throwing:ResolveValue("RangeIncrease")
	end
	max_range = max_range *const.SlabSizeX
	
	
	sign = InteractionRand(2)
	sign = sign == 1 and 1 or -1 
	
	local distance_multiplier = (deviation/12.0 * sign)
	local distance_deviation = dir:Len()  * (1.00 + distance_multiplier)
	--print("distance deviation", distance_deviation)
	-- if distance_deviation > max_range then
		-- print("more than max range")
	-- end
	
	if sign > 0 then
		distance_deviation = distance_deviation <= cRound(max_range*1.3) and distance_deviation or (dir:Len() * (1.00 + distance_multiplier *-1))
	end
	


	
	
	DbgAddCircle_devi(target_pos, const.SlabSizeX/6, const.clrGreen)
	DbgAddVector_devi(attack_pos,  dir, const.clrGreen)
	
	
	
	--print("angle of rot", angle_of_rotation)
	local rotated_vector = Rotate(dir, angle_of_rotation)

	rotated_vector = SetLen(rotated_vector, distance_deviation)
	DbgAddVector_devi(attack_pos,  rotated_vector, const.clrRed )
	
	local final_pos = attack_pos + rotated_vector
	return final_pos
	

end

function Grenade:get_throw_accuracy(unit)

	local shape_list = {
		["Spherical"] = 0,
		["Stick_like"] = 0,
		["Cylindrical"] = -3,
		["Long"] = -7,
		["Brick"] = -5,
		["Bottle"] = -11,
	}
	

	
	local acc = shape_list[self.r_shape] or 0
	
	if IsKindOf(self, "ShapedCharge") then
		acc = unit.unitdatadef_id ~= "Barry" and acc - 15 or acc + 5
	end
	
	return acc
end

function MishapProperties:rat_deviation(attacker, target_pos, attack_args, attack_pos)
	local grenade = self
	local mishap_chance = grenade:GetMishapChance(attacker, target_pos)		

	local deviatePosition = rat_custom_deviation(attacker, target_pos, mishap_chance, false, attack_pos, grenade)
	--	
	if not deviatePosition then
		return target_pos, false
	end
	
	
	target_pos = validate_deviated_gren_pos(deviatePosition, attack_args)
	
	return target_pos, true
end


function validate_deviated_gren_pos(explosion_pos, attack_args)
	local newGroundPos
	if explosion_pos then
		local slab, slab_z = WalkableSlabByPoint(explosion_pos, "downward only")

		local z = explosion_pos:z()
		if slab_z and slab_z <= z and slab_z >= z - guim then

			newGroundPos = explosion_pos:SetZ(slab_z)
		else
			-- check for collision geometry between explosion_pos and ground
			newGroundPos = explosion_pos:SetTerrainZ()
			local col, pts = CollideSegmentsNearest(explosion_pos, newGroundPos)
			if col then

				newGroundPos = pts[1]
			end
		end
	end
	-- if newGroundPos and attack_args and attack_args.obj and (g_AIExecutionController or attack_args.opportunity_attack_type == "Retaliation") then
		-- if IsTrapClose(newGroundPos) then
			-- newGroundPos = nil
		-- end
	-- end
	return newGroundPos
end

function deviation_prob(dex, expl, steps, not_round)
	local dex = dex or 80
	local expl = expl or 80
	local steps = steps or 0.5
	local deviations = {}
	local unit = g_Units["Barry"]
	unit.Dexterity = dex
	unit.Explosives = expl 
	local grenade = unit:GetItemInSlot("Handheld A", "Grenade", 1, 1)
	local mishap_chance = grenade:GetMishapChance(unit, unit:GetPos())
	-- Simulate a large number of rolls
	local num_rolls = 10000.00
	local deviation
	for i = 1, num_rolls do
		local mishap =  unit:Random(100) < mishap_chance and "mishap"
		deviation = mishap or (rat_custom_deviation(unit, false, mishap_chance, true, false, grenade))

		--print("origi dev", deviation,"round", not mishap and cRoundFlt(deviation) or "mishap")
		if not not_round then
			deviation = not mishap and cRoundFlt(deviation,steps) or deviation
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

    print("Deviation   Probability   for " .. dex .. " dex and " .. expl , " expl" )
    for _, deviation in ipairs(sorted_keys) do
        local probability = deviations[deviation] / num_rolls * 100
        print(deviation .. "         " .. probability)
    end
end

function test_roll()
	local unit = g_Units["Barry"]
	local num_rolls = 10000.00
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
		local probability = count / num_rolls *100
		print(deviation .. "         " .. probability)
	end
end