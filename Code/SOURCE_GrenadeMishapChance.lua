function MishapProperties:GetMishapChance(unit, target, async)
	local chance = self.MinMishapChance + MulDivRound(Max(0, 100 - unit.Explosives), Max(0, self.MaxMishapChance - self.MinMishapChance), 100)
	local item = IsKindOf(self, "FirearmBase") and self.parent_weapon or self
	local percent = 100
	if IsKindOf(item, "InventoryItem") then
		percent = item:GetConditionPercent()
		chance = Max(chance, 100 - percent)
	end 
	-- if GameState.RainHeavy  and IsKindOf(item, "GrenadeProperties") then
		-- chance = Clamp(MulDivRound(chance, const.EnvEffects.RainMishapMultiplier, 100), const.EnvEffects.RainMishapMinChance, const.EnvEffects.RainMishapMaxChance)
	-- end
	
	if not async then
		NetUpdateHash("GetMishapChance", unit, target, chance, unit.Explosives, percent, GameState.RainHeavy, self.MinMishapChance, self.MaxMishapChance)
	end
	
	----
	chance = cRound(chance * 0.6)
	local mishap_option = extractNumberWithSignFromString(CurrentModOptions['mishap_option']) or 100
	chance = MulDivRound(chance, mishap_option, 100)
	----
	
	return Max(0, chance)
end

----     -3, 25 a good bet

function test_mishap(minc, maxc, steps)

	local minc, maxc = minc or-2,maxc or 18
	local steps = 5 or steps
	
    for explosives = 0, 100, steps or 20 do
        local chance = minc + MulDivRound(Max(0, 100 - explosives), Max(0, maxc -(minc)), 100)
        chance = MulDivRound(chance, 60, 100)
        chance = Max(0, chance)
        print("Explosives:", explosives, "Chance:", chance)
    end
end