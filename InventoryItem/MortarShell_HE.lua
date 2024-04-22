UndefineClass('MortarShell_HE')
DefineClass.MortarShell_HE = {
	__parents = { "Ordnance" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Ordnance",
	RepairCost = 0,
	Repairable = false,
	Reliability = 100,
	Icon = "UI/Icons/Items/mortar_shell_he",
	DisplayName = T(314888807427, --[[ModItemInventoryItemCompositeDef MortarShell_HE DisplayName]] "Mortar Cartridge"),
	DisplayNamePlural = T(610141949220, --[[ModItemInventoryItemCompositeDef MortarShell_HE DisplayNamePlural]] "Mortar Cartridges"),
	Description = T(134585683801, --[[ModItemInventoryItemCompositeDef MortarShell_HE Description]] "Explosive Ordnance ammo for Mortars."),
	Cost = 300,
	CanAppearInShop = true,
	Tier = 2,
	MaxStock = 5,
	RestockWeight = 50,
	CategoryPair = "Ordnance",
	CenterObjDamageMod = 500,
	AreaOfEffect = 5,
	AreaObjDamageMod = 500,
	PenetrationClass = 4,
	DeathType = "BlowUp",
	Caliber = "MortarShell",
	BaseDamage = 40,
}

