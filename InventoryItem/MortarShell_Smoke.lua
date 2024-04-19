UndefineClass('MortarShell_Smoke')
DefineClass.MortarShell_Smoke = {
	__parents = { "Ordnance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Ordnance",
	RepairCost = 0,
	Repairable = false,
	Reliability = 100,
	Icon = "UI/Icons/Items/mortar_shell_smoke",
	DisplayName = T(377318516720, --[[ModItemInventoryItemCompositeDef MortarShell_Smoke DisplayName]] "Mortar Smoke Cartridge"),
	DisplayNamePlural = T(191255251161, --[[ModItemInventoryItemCompositeDef MortarShell_Smoke DisplayNamePlural]] "Mortar Smoke Cartridges"),
	Description = T(322194031802, --[[ModItemInventoryItemCompositeDef MortarShell_Smoke Description]] "Ordnance ammo for Mortars."),
	AdditionalHint = T(835706114170, --[[ModItemInventoryItemCompositeDef MortarShell_Smoke AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Ranged attacks passing through gas become <color EmStyle>grazing</color> hits\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> No damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Almost silent"),
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
	aoeType = "smoke",
}

