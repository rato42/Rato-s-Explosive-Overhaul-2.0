UndefineClass('Pipe_IED')
DefineClass.Pipe_IED = {
	__parents = { "ThrowableTrapItem" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "ThrowableTrapItem",
	Repairable = false,
	Reliability = 100,
	Icon = "UI/Icons/Weapons/PipeBomb",
	ItemType = "Grenade",
	DisplayName = T(343108932526, --[[ModItemInventoryItemCompositeDef Pipe_IED DisplayName]] "Pipe Bomb"),
	DisplayNamePlural = T(885497071669, --[[ModItemInventoryItemCompositeDef Pipe_IED DisplayNamePlural]] "Pipe Bombs"),
	AdditionalHint = T(392517442086, --[[ModItemInventoryItemCompositeDef Pipe_IED AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Explodes after 1 turn (or 5 seconds out of combat)\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High mishap chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Inflicts Bleeding"),
	UnitStat = "Explosives",
	Cost = 100,
	CanAppearInShop = true,
	RestockWeight = 50,
	CategoryPair = "Grenade",
	MinMishapChance = 2,
	MaxMishapChance = 30,
	MaxMishapRange = 6,
	CenterUnitDamageMod = 130,
	CenterAppliedEffects = {
		"Bleeding",
	},
	AttackAP = 3000,
	BaseRange = 3,
	ThrowMaxRange = 12,
	Entity = "Explosive_TNT",
	ActionIcon = "UI/Icons/Hud/pipe_bomb",
	r_timer = 5000,
	r_mass = 980,
	r_shape = "Long",
	is_ied = true,
	TimedExplosiveTurns = 0,
	ExplosiveType = "BlackPowder",
}

