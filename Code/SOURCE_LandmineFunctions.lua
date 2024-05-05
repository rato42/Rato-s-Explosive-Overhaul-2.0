local rat_original_TriggerTrap = Landmine.TriggerTrap

function Landmine:TriggerTrap(victim, attacker)
	local original_item = g_Classes[self.item_thrown]
	if original_item and original_item.is_ied and not IsKindOf(self, "DynamicSpawnLandmine_MisfiredIED") then
		local misfire = processIEDmisfire(original_item, attacker or self.attacker)
		if misfire then

			local att = self.attacker
			local faux_results = {
				explosion_pos = self:GetPos(),
			}
			self.done = true
			--[[ 			self.visible = false
			self:SetOpacity(0) ]]
			self:DestroyAttaches("GrenadeVisual")
			original_item:IED_trap_OnLand(attacker or att, faux_results, false)
			return
		end
	end

	rat_original_TriggerTrap(self, victim, attacker)
end

