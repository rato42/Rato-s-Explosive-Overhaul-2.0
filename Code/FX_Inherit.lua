function OnMsg.GetCustomFXInheritActorRules(rules)
	place_explosion_FXs()
	place_flashbang_FXs()
	-- EO_apply_inherit(rules)
end

function EO_apply_inherit(rules)
	local data = {
		-- {"ConcussiveGrenade", "ConcussiveGrenade_IED", "ConcussiveGrenade_IED_Misfired"},
		{"BlackPowder", "PipeBomb_Misfired"}}

	for _, entry in ipairs(data) do
		local category = entry[1]

		local tags = {table.unpack(entry, 2)}

		for _, tag in ipairs(tags) do
			rules[#rules + 1] = tag
			rules[#rules + 1] = category
		end
	end

end

function OnMsg.DataLoaded()
	-- DefineClass.Weapon_NailBomb = { __parents = {"GrenadeVisual"}, entity = "World_Flarestick_01", }
	-- explosive_entity()
end

function explosive_entity()
	ForEachPreset("InventoryItemCompositeDef", function(p)
		if p.id == "Frag_IED" then
			p.Entity = 'World_Flarestick_01'
			print(p.Entity)
		end
	end)
end

function OnMsg.ClassesGenerate(classdefs)
	-- print("classes generating")
	classdefs.Weapon_TNT_frag_IED = {
		__parents = {"GrenadeVisual"},
		entity = "fragmentary_tnt",
	}
	classdefs.Weapon_TNT_frag_IED_Misfired = {
		__parents = {"GrenadeVisual"},
		entity = "frag_tnt_misfired",
	}

	--[[ 	classdefs.GlowStickClone = {
		__parents = {"GrenadeVisual"},
		entity = "Weapon_GlowStick",
	} ]]
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

	-- classdefs.Weapon_SodaCanIED ={ __parents = {"GrenadeVisual"}, entity = "rusted_tin", }
	-- classdefs.Weapon_SodaCanIED ={ __parents = {"GrenadeVisual"}, entity = "Can_2", }
	-- weapon suppressor

	--[[ 	classdefs.Weapon_Test_entity = {
		__parents = {"GrenadeVisual"},
		entity = "Bar_Bottle_01",
	}
	classdefs.Weapon_Test_entity3 = {
		__parents = {"GrenadeVisual"},
		entity = "Bar_Bottle_02",
	} ]]
	-- print("def", classdefs.Weapon_SmokeCanIED)
end

