local original_ApplyExplosionDamage = ApplyExplosionDamage

function ApplyExplosionDamage(attacker, fx_actor, results, noise, disableBurnFx, ignore_targets)
	local weapon = results.weapon
	local time = GameTime()
	local explosion_pos = results.explosion_pos or results.target_pos
	local shr_results = results.shrapnel_results
	if explosion_pos and weapon and shr_results then
		if IsKindOf(weapon, "Ordnance") then
			if results.attack_from_stealth == nil then
				shrapnel_Execute(shr_results, time)
			end
		elseif IsKindOf(weapon, "Grenade") then
			shrapnel_Execute(shr_results, time)
		end
	end

	original_ApplyExplosionDamage(attacker, fx_actor, results, noise, disableBurnFx, ignore_targets)
end

function shrapnel_Execute(shr_results, time)
	for i, shrapnel in ipairs(shr_results) do
		CreateGameTimeThread(Firearm.Shrapnel_Fly, shrapnel.weapon, shrapnel.attacker, shrapnel.start_pt, shrapnel.end_pt,
		                     shrapnel.shrapnel_dir, shrapnel.speed, shrapnel.hits, shrapnel.target, shrapnel.lof_args, time)
	end
end
