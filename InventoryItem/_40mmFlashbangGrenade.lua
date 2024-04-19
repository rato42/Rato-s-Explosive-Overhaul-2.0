UndefineClass('_40mmFlashbangGrenade')
DefineClass._40mmFlashbangGrenade = {
	__parents = { "Ordnance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Ordnance",
	Icon = "UI/Icons/Items/40mm_flashbang_grenade",
	DisplayName = T(886826508035, --[[ModItemInventoryItemCompositeDef _40mmFlashbangGrenade DisplayName]] "40 mm Flashbang"),
	DisplayNamePlural = T(414325610296, --[[ModItemInventoryItemCompositeDef _40mmFlashbangGrenade DisplayNamePlural]] "40 mm Flashbangs"),
	Description = T(611944552839, --[[ModItemInventoryItemCompositeDef _40mmFlashbangGrenade Description]] "40 mm ordnance ammo for Grenade Launchers."),
	AdditionalHint = T(237735748307, --[[ModItemInventoryItemCompositeDef _40mmFlashbangGrenade AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Causes <color EmStyle>Suppressed</color>\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Causes <color EmStyle>Dazed</color>\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cancel readied attacks\n"),
	Cost = 850,
	CanAppearInShop = true,
	Tier = 2,
	MaxStock = 5,
	RestockWeight = 25,
	CategoryPair = "Ordnance",
	CenterUnitDamageMod = 130,
	CenterObjDamageMod = 10,
	CenterAppliedEffects = {
		"Revealed",
		"CancelShot",
		"Suppressed",
		"SeverelySuppressed",
	},
	AreaObjDamageMod = 10,
	AreaAppliedEffects = {
		"Revealed",
		"CancelShot",
		"Suppressed",
		"SeverelySuppressed",
	},
	PenetrationClass = 1,
	BurnGround = false,
	Caliber = "40mmGrenade",
	BaseDamage = 5,
	Noise = 40,
	Entity = "Weapon_MilkorMGL_Shell",
}

