function CombatActionGrenadeDescription(action, units)
	local baseDescription = T(519947740930, "Affects a designated area.")
	
	local unit = units[1]
	local weapon = action:GetAttackWeapons(unit)
	if not weapon then return baseDescription end
	
	if weapon:HasMember("GetCustomActionDescription") then
		local descr = weapon:GetCustomActionDescription(action, units)
		if descr and descr ~= "" then
			return descr
		end
	end

	-------
	--local additional_hints = string.gsub(weapon.AdditionalHint, "<EO_description_hints>", "")
	---

	local base = unit:GetBaseDamage(weapon)
	local bonus = GetGrenadeDamageBonus(unit)
	local damage = MulDivRound(base, 100 + bonus, 100)
	local text = T{baseDescription, damage = damage, basedamage = base, bonusdamage = damage - base}
--[[ 	if (weapon.AdditionalHint or "") ~= "" then
		text = text  .. "<newline>" ..weapon.AdditionalHint
	end ]]
	return text
end