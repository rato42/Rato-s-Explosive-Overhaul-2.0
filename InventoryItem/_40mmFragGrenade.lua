UndefineClass('_40mmFragGrenade')
DefineClass._40mmFragGrenade = {
	__parents = { "Ordnance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Ordnance",
	Icon = "UI/Icons/Items/40mm_frag_grenade",
	DisplayName = T(379883134750, --[[ModItemInventoryItemCompositeDef _40mmFragGrenade DisplayName]] "40 mm HE"),
	DisplayNamePlural = T(448697893920, --[[ModItemInventoryItemCompositeDef _40mmFragGrenade DisplayNamePlural]] "40 mm HE"),
	Description = T(429484513685, --[[ModItemInventoryItemCompositeDef _40mmFragGrenade Description]] "40 mm ordnance ammo for Grenade Launchers."),
	AdditionalHint = T(926889899942, --[[ModItemInventoryItemCompositeDef _40mmFragGrenade AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Inflicts <color EmStyle>Bleeding</color> in the epicenter"),
	Cost = 300,
	CanAppearInShop = true,
	Tier = 2,
	MaxStock = 5,
	RestockWeight = 50,
	CategoryPair = "Ordnance",
	CenterUnitDamageMod = 130,
	CenterObjDamageMod = 500,
	AreaObjDamageMod = 500,
	PenetrationClass = 4,
	DeathType = "BlowUp",
	Caliber = "40mmGrenade",
	BaseDamage = 40,
	Entity = "Weapon_MilkorMGL_Shell",
	r_shrap_num = 300,
}

