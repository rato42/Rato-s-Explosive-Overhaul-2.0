UndefineClass('weapon_shrapnel')
DefineClass.weapon_shrapnel = {
	__parents = { "Pistol" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Pistol",
	ScrapParts = 6,
	RepairCost = 70,
	Reliability = 50,
	DisplayName = T(214207252979, --[[ModItemInventoryItemCompositeDef weapon_shrapnel DisplayName]] "shrap"),
	DisplayNamePlural = T(163052994957, --[[ModItemInventoryItemCompositeDef weapon_shrapnel DisplayNamePlural]] "shrap"),
	UnitStat = "Marksmanship",
	Cost = 500,
	CategoryPair = "Handguns",
	CanAppearStandard = false,
	Caliber = "9mm",
	Damage = 10,
	ObjDamageMod = 50,
	AimAccuracy = 1,
	CritChanceScaled = 0,
	MagazineSize = 15,
	WeaponRange = 200,
	PointBlankBonus = 1,
	OverwatchAngle = 2160,
	Noise = 10,
	HolsterSlot = "Leg",
	AvailableAttacks = {
		"SingleShot",
		"DualShot",
		"CancelShot",
		"MobileShot",
	},
}

