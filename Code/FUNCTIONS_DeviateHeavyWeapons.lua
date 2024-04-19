function MishapChanceByDist(item, attacker, target, async)
	local chance = MishapProperties.GetMishapChance(item, attacker, target, async)
	print("chance", chance)
	local range = item.WeaponRange * const.SlabSizeX
	print("range", item.WeaponRange)
	local dist = attacker:GetDist(target)
	if dist > range / 2 then
		chance = Min(100, chance + MulDivRound(dist - range/2, 100 - chance, range/2))
		
	end
		print("final chance", chance)
	return chance
end

function MishapDeviationVectorByDist(item, attacker, target)
	local dv = MishapProperties.GetMishapDeviationVector(item, attacker, target)
	--print("dv", dv)
	local range = item.WeaponRange * const.SlabSizeX
	--print("range", item.WeaponRange)
	local dist = attacker:GetDist(target)
	if dist > range / 2 then
		local mod = Min(100, MulDivRound(dist - range/2, 100, range/2))
		dv = MulDivRound(dv, 100 + mod, 100)
	end
	--print("final chance", chance)
	return dv
end

-- function OnMsg.DataLoaded()
	-- set_gl_r_deviation()
-- end

function set_gl_r_deviation()
	GrenadeLauncher.GetMishapChance = MishapChanceByDist
	GrenadeLauncher.GetMishapDeviationVector = MishapDeviationVectorByDist
	RocketLauncher.GetMishapChance = MishapChanceByDist
	RocketLauncher.GetMishapDeviationVector = MishapDeviationVectorByDist
end