UndefineClass('Warhead_Frag_IED')
DefineClass.Warhead_Frag_IED = {
	__parents = { "Ordnance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Ordnance",
	Icon = "Mod/RATONADE/Images/warhead_icon 2.png",
	DisplayName = T(439242608885, --[[ModItemInventoryItemCompositeDef Warhead_Frag_IED DisplayName]] "HE Rocket"),
	DisplayNamePlural = T(250143006457, --[[ModItemInventoryItemCompositeDef Warhead_Frag_IED DisplayNamePlural]] "HE Rockets"),
	Description = T(261557488921, --[[ModItemInventoryItemCompositeDef Warhead_Frag_IED Description]] "Ordnance ammo for Rocket Launchers."),
	AdditionalHint = T(444721835227, --[[ModItemInventoryItemCompositeDef Warhead_Frag_IED AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Inflicts Suppressed in the epicenter"),
	Cost = 400,
	CanAppearInShop = true,
	Tier = 3,
	MaxStock = 5,
	RestockWeight = 50,
	CategoryPair = "Ordnance",
	CenterUnitDamageMod = 130,
	CenterObjDamageMod = 500,
	CenterAppliedEffects = {
		"Suppressed",
	},
	AreaOfEffect = 2,
	AreaObjDamageMod = 500,
	DeathType = "BlowUp",
	Caliber = "Warhead",
	BaseDamage = 50,
	Noise = 30,
}

