function OnMsg.ClassesGenerate(classdefs)
	classdefs.Weapon_TNT_frag_IED = {
		__parents = {"GrenadeVisual"},
		entity = "fragmentary_tnt",
	}
	classdefs.Weapon_TNT_frag_IED_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "frag_tnt_misfired",
	}
	classdefs.Weapon_IncendiaryGrenade = {
		__parents = {"GrenadeVisual"},
		entity = "Weapon_SmokeGrenade",
	}
	classdefs.Weapon_SmokeCanIED = {
		__parents = {"GrenadeVisual"},
		entity = "smoke_can",
	}
	classdefs.Weapon_SmokeCanIED_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "smoke_can",
	}
	classdefs.Weapon_SmokeCanIED_Spinning = {
		__parents = {"Weapon_SmokeGrenade_Base"},
		entity = "smoke_can",
	}
	classdefs.Weapon_TearCanIED = {
		__parents = {"GrenadeVisual"},
		entity = "tear_can",
	}
	classdefs.Weapon_TearCanIED_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "tear_can",
	}
	classdefs.Weapon_TearCanIED_OnGround = {
		__parents = {"GrenadeVisual"},
		entity = "tear_can",
	}
	classdefs.Weapon_NailCanIED = {
		__parents = {"GrenadeVisual"},
		entity = "nail_can",
	}
	classdefs.Weapon_NailCanIED_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "nail_can",
	}
	classdefs.Weapon_FlashCanIED = {
		__parents = {"GrenadeVisual"},
		entity = "flash_can",
	}
	classdefs.Weapon_FlashCanIED_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "flash_can",
	}
	classdefs.Weapon_PipeBomb_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "Weapon_PipeBomb",
	}

end

