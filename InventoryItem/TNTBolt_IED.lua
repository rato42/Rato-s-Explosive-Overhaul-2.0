UndefineClass('TNTBolt_IED')
DefineClass.TNTBolt_IED = {
	__parents = { "Grenade" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Grenade",
	Repairable = false,
	Reliability = 100,
	Icon = "Mod/RATONADE/Images/TNTBOLT7.png",
	ItemType = "Grenade",
	DisplayName = T(564860260183, --[[ModItemInventoryItemCompositeDef TNTBolt_IED DisplayName]] "Fragmentary TNT Stick"),
	DisplayNamePlural = T(735927037683, --[[ModItemInventoryItemCompositeDef TNTBolt_IED DisplayNamePlural]] "Fragmentary TNT Sticks"),
	AdditionalHint = T(639163114527, --[[ModItemInventoryItemCompositeDef TNTBolt_IED AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Explodes immediately"),
	UnitStat = "Explosives",
	Cost = 400,
	CanAppearInShop = true,
	Tier = 2,
	CategoryPair = "Grenade",
	MinMishapChance = -2,
	MaxMishapChance = 18,
	MaxMishapRange = 6,
	CenterUnitDamageMod = 130,
	CenterObjDamageMod = 500,
	AreaObjDamageMod = 500,
	PenetrationClass = 4,
	DeathType = "BlowUp",
	Entity = "World_Flarestick_01",
	ActionIcon = "UI/Icons/Hud/throw_grenade",
}

