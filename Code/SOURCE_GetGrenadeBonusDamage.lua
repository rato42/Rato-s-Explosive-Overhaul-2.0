function GetGrenadeDamageBonus(unit)

	local dmg_setting = extractNumberWithSignFromString(CurrentModOptions['explosive_dmg']) or 100

	return dmg_setting - 100 ----MulDivRound(const.Combat.GrenadeStatBonus, unit.Explosives, 100)
end
