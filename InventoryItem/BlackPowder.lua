UndefineClass('BlackPowder')
DefineClass.BlackPowder = {
	__parents = { "ExplosiveSubstance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "ExplosiveSubstance",
	Repairable = false,
	Icon = "UI/Icons/Items/black_powder",
	DisplayName = T(714362259251, --[[ModItemInventoryItemCompositeDef BlackPowder DisplayName]] "Gunpowder"),
	DisplayNamePlural = T(161274261102, --[[ModItemInventoryItemCompositeDef BlackPowder DisplayNamePlural]] "Gunpowder"),
	AdditionalHint = T(515164545390, --[[ModItemInventoryItemCompositeDef BlackPowder AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Used in Craft Ammo and Craft Explosives operations"),
	UnitStat = "Explosives",
	Cost = 400,
	CanAppearInShop = true,
	MaxStock = 10,
	CategoryPair = "Components",
	ShopStackSize = 5,
	CenterUnitDamageMod = 130,
	CenterObjDamageMod = 200,
	AreaOfEffect = 4,
	AreaObjDamageMod = 200,
	PenetrationClass = 4,
	BurnGround = false,
	DeathType = "BlowUp",
	BaseDamage = 33,
}

