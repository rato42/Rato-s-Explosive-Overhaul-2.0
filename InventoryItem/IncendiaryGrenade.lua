UndefineClass('IncendiaryGrenade')
DefineClass.IncendiaryGrenade = {
	__parents = { "Grenade" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Grenade",
	Repairable = false,
	Reliability = 100,
	Icon = "Mod/RATONADE/Images/incendiary2.png",
	ItemType = "GrenadeFire",
	DisplayName = T(690193619979, --[[ModItemInventoryItemCompositeDef IncendiaryGrenade DisplayName]] "Incendiary Grenade"),
	DisplayNamePlural = T(169272979158, --[[ModItemInventoryItemCompositeDef IncendiaryGrenade DisplayNamePlural]] "Incendiary Grenades"),
	AdditionalHint = T(622520137835, --[[ModItemInventoryItemCompositeDef IncendiaryGrenade AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Sets an area on fire and inflicts <color EmStyle>Burning</color>\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High mishap chance"),
	UnitStat = "Explosives",
	Cost = 300,
	CanAppearInShop = true,
	RestockWeight = 50,
	CategoryPair = "Grenade",
	MinMishapChance = 2,
	MaxMishapChance = 30,
	MinMishapRange = 0,
	CenterUnitDamageMod = 0,
	CenterObjDamageMod = 0,
	CenterAppliedEffects = {
		"Burning",
	},
	AreaUnitDamageMod = 0,
	AreaObjDamageMod = 0,
	AreaAppliedEffects = {
		"Burning",
	},
	PenetrationClass = 1,
	BaseDamage = 0,
	Scatter = 4,
	AttackAP = 4000,
	CanBounce = false,
	InaccurateMaxOffset = 4000,
	Noise = 0,
	aoeType = "fire",
	Entity = "Weapon_MolotovCocktail",
	ActionIcon = "UI/Icons/Hud/molotov",
	r_timer = 7000,
	r_mass = 980,
	r_shape = "Cylindrical",
}
