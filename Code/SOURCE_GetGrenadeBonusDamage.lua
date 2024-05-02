function GetGrenadeDamageBonus(unit)
	return 0--MulDivRound(const.Combat.GrenadeStatBonus, unit.Explosives, 100)
end