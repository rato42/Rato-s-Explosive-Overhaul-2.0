UndefineClass('Super_HE_Grenade')
DefineClass.Super_HE_Grenade = {
	__parents = { "Grenade" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Grenade",
	Repairable = false,
	Reliability = 100,
	Icon = "UI/Icons/Weapons/HEGrenade",
	ItemType = "Grenade",
	DisplayName = T(104319606099, --[[ModItemInventoryItemCompositeDef Super_HE_Grenade DisplayName]] "Demo Charge"),
	DisplayNamePlural = T(412750624562, --[[ModItemInventoryItemCompositeDef Super_HE_Grenade DisplayNamePlural]] "Demo Charges"),
	UnitStat = "Explosives",
	Cost = 1500,
	MinMishapChance = -2,
	MaxMishapChance = 18,
	MinMishapRange = 0,
	CenterObjDamageMod = 500,
	AreaOfEffect = 1,
	AreaObjDamageMod = 500,
	DeathType = "BlowUp",
	BaseDamage = 110,
	Scatter = 4,
	AttackAP = 2000,
	BaseRange = 3,
	InaccurateMaxOffset = 3000,
	IgnoreCoverReduction = 1,
	Entity = "Weapon_FragGrenadeM67",
}

