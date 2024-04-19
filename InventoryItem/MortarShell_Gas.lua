UndefineClass('MortarShell_Gas')
DefineClass.MortarShell_Gas = {
	__parents = { "Ordnance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Ordnance",
	RepairCost = 0,
	Repairable = false,
	Reliability = 100,
	Icon = "UI/Icons/Items/mortar_shell_gas",
	DisplayName = T(533793585299, --[[ModItemInventoryItemCompositeDef MortarShell_Gas DisplayName]] "Mortar Gas Cartridge"),
	DisplayNamePlural = T(568374576075, --[[ModItemInventoryItemCompositeDef MortarShell_Gas DisplayNamePlural]] "Mortar Gas Cartridges"),
	Description = T(692883813791, --[[ModItemInventoryItemCompositeDef MortarShell_Gas Description]] "Ordnance ammo for Mortars."),
	AdditionalHint = T(481066088983, --[[ModItemInventoryItemCompositeDef MortarShell_Gas AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Inflicts <color EmStyle>Choking</color>\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Ranged attacks passing through gas become Grazing hits\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Almost silent"),
	Cost = 400,
	CanAppearInShop = true,
	Tier = 2,
	MaxStock = 5,
	RestockWeight = 25,
	CategoryPair = "Ordnance",
	PenetrationClass = 1,
	BurnGround = false,
	Caliber = "MortarShell",
	BaseDamage = 0,
	Noise = 0,
	aoeType = "toxicgas",
}

