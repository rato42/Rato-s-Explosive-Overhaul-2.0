Landmine.original_UpdateTriggerRadiusFx = Landmine.UpdateTriggerRadiusFx -- landmine_original_UpdateTriggerRadiusFx

function Landmine:UpdateTriggerRadiusFx(delete)
	self:original_UpdateTriggerRadiusFx(delete)
	if self.ied_misfire_trap then
		DoneObject(self.trigger_radius_fx)
		self.trigger_radius_fx = false
	end
end

Landmine.rat_original_UpdateTimedExplosionFx = Landmine.UpdateTimedExplosionFx

function Landmine:UpdateTimedExplosionFx(addTime)
	self:rat_original_UpdateTimedExplosionFx(addTime)
	if self.ied_misfire_trap and self.timer_text and self.timer_text.ui and self.timer_text.ui.idText then
		-- DoneObject(self.timer_text)
		self.timer_text.ui.idText:SetVisible(false)
	end
end

Landmine.rat_original_TriggerTrap = Landmine.TriggerTrap

function Landmine:TriggerTrap(victim, attacker)
	local original_item = g_Classes[self.item_thrown]
	if original_item and original_item.is_ied and not self.ied_misfire_trap then
		local misfire = processIEDmisfire(original_item, attacker or self.attacker)
		if misfire then
			local original_fx_actor = self.fx_actor_class
			local att = self.attacker
			local faux_results = {
				explosion_pos = self:GetPos(),
			}
			self.done = true
			--[[ 			self.visible = false
			self:SetOpacity(0) ]]
			self:DestroyAttaches("GrenadeVisual")
			original_item:IED_trap_OnLand(attacker or att, faux_results, false, original_fx_actor)
			return
		end
	end

	if self.r_original_fx_actor and self.r_original_fx_actor ~= "" then
		self.fx_actor_class = self.r_original_fx_actor
	end

	self:rat_original_TriggerTrap(victim, attacker)
end

