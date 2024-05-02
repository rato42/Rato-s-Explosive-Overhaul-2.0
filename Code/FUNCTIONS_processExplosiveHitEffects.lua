local flashbang_effects = {"cancel_shot_flashbang", "Suppressed", "dazed_flashbang"}

function processExplosiveHitEffects(results, weapon)
	local has_shrap = weapon and weapon.r_shrap_num and weapon.r_shrap_num > 0
	local is_flashbang = weapon and
						                     IsKindOfClasses(weapon, "ConcussiveGrenade", "ConcussiveGrenade_IED", "_40mmFlashbangGrenade")
	for ii, hit in ipairs(results) do
		local effects = hit.effects
		if effects then
			if is_flashbang then
				hit.effects = flashbang_effects
			else
				for i, effect in ipairs(effects) do
					if effect == "Bleeding" and has_shrap then
						table.remove(effects, i)
						break
					end
				end
			end
		end
		hit.effects = effects
		results[ii] = hit
	end

	return results
end
