function explo_OH_change_item()
	print("RATONADE MOD - Changing explosives items properties")
	ForEachPreset("InventoryItemCompositeDef", function (p)
			local item = g_Classes[p.id]
			if IsKindOfClasses(item, "HE_Grenade") then
				item.CanBounce = true
			end
		end)
end

function OnMsg.DataLoaded()
	explo_OH_change_item()
end