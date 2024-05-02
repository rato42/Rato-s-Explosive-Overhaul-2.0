UndefineClass('NailBomb_IED')
DefineClass.NailBomb_IED = {
	__parents = { "Grenade" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Grenade",
	Repairable = false,
	Reliability = 100,
	Icon = "Mod/RATONADE/Images/nailbomb2 4.png",
	ItemType = "Grenade",
	DisplayName = T(439953250262, --[[ModItemInventoryItemCompositeDef NailBomb_IED DisplayName]] "Nail Bomb"),
	DisplayNamePlural = T(880534339154, --[[ModItemInventoryItemCompositeDef NailBomb_IED DisplayNamePlural]] "Nail Bombs"),
	AdditionalHint = T(808458367295, --[[ModItemInventoryItemCompositeDef NailBomb_IED AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Explodes immediately"),
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
	is_ied = true,
}

