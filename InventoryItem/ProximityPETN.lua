UndefineClass('ProximityPETN')
DefineClass.ProximityPETN = {
	__parents = { "ThrowableTrapItem" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "ThrowableTrapItem",
	Repairable = false,
	Reliability = 100,
	Icon = "UI/Icons/Items/proximity_petn",
	ItemType = "Grenade",
	DisplayName = T(330241233338, --[[ModItemInventoryItemCompositeDef ProximityPETN DisplayName]] "Proximity PETN"),
	DisplayNamePlural = T(182079965364, --[[ModItemInventoryItemCompositeDef ProximityPETN DisplayNamePlural]] "Proximity PETN"),
	AdditionalHint = T(220972891844, --[[ModItemInventoryItemCompositeDef ProximityPETN AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Explodes when an enemy enters a small area around it"),
	UnitStat = "Explosives",
	Cost = 1500,
	CanAppearInShop = true,
	Tier = 3,
	MaxStock = 1,
	RestockWeight = 10,
	CategoryPair = "Grenade",
	MinMishapChance = -2,
	MaxMishapChance = 18,
	MaxMishapRange = 6,
	AttackAP = 7000,
	BaseRange = 3,
	ThrowMaxRange = 8,
	CanBounce = false,
	Noise = 30,
	Entity = "Explosive_PETN",
	ActionIcon = "UI/Icons/Hud/throw_proximity_explosive",
	r_mass = 1800,
	r_shape = "Brick",
	TriggerType = "Proximity",
	ExplosiveType = "PETN",
}
