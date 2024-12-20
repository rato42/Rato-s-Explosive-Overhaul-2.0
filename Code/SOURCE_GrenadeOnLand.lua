function Grenade:OnLand(thrower, attackResults, visual_obj)

	if not CurrentThread() then
		CreateGameTimeThread(Grenade.OnLand, self, thrower, attackResults, visual_obj)
		return
	end

	Sleep(160)
	-----
	if attackResults.ied_misfire then
		-- CreateFloatingText("IED Misfire", attackResults.explosion_pos)
		self:IED_trap_OnLand(thrower, attackResults, visual_obj)
		return
	end
	----

	if self.ThrowNoise > 0 then
		-- <Unit> Heard a thud
		PushUnitAlert("noise", visual_obj, self.ThrowNoise, Presets.NoiseTypes.Default.ThrowableLandmine.display_name)
	end
	if self.Noise > 0 then
		PushUnitAlert("noise", visual_obj, self.Noise, Presets.NoiseTypes.Default.Grenade.display_name)
	end
	attackResults.aoe_type = self.aoeType
	attackResults.burn_ground = self.BurnGround

	ApplyExplosionDamage(thrower, visual_obj, attackResults)
	if IsValid(visual_obj) and not IsKindOf(visual_obj, "GridMarker") then
		DoneObject(visual_obj)
	end

end

