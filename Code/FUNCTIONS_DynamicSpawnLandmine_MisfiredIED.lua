DefineClass.DynamicSpawnLandmine_MisfiredIED = {
	__parents = {"DynamicSpawnLandmine"},
	discovered = true,
	discovered_trap = true,
	entity = false,
	spawned_by_explosive_object = false,
}

function DynamicSpawnLandmine_MisfiredIED:TriggerTrap(victim, attacker)
	local original_item = g_Classes[self.item_thrown]

	if original_item and IsKindOf(original_item, "ThrowableTrapItem") then
		self.fx_actor_class = original_item.class .. "_OnGround"
	end
	Landmine.TriggerTrap(self, victim, attacker)
end

function DynamicSpawnLandmine_MisfiredIED:UpdateTimedExplosionFx(addTime)
	Landmine.UpdateTimedExplosionFx(self, addTime)

	if self.timer_text and self.timer_text.ui and self.timer_text.ui.idText then
		self.timer_text.ui.idText:SetVisible(false)
	end
end

function DynamicSpawnLandmine_MisfiredIED:UpdateTriggerRadiusFx(delete)
	Landmine.UpdateTriggerRadiusFx(self, delete)

	if self.trigger_radius_fx then
		DoneObject(self.trigger_radius_fx)
		self.trigger_radius_fx = false
	end
end
