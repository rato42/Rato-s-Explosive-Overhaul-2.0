--[[ function ThrowableTrapItem:OnLand(thrower, attackResults, visual_obj)

	-- print("resu", attackResults)

	if self.TriggerType == "Contact" then
		Grenade.OnLand(self, thrower, attackResults, visual_obj)
		return
	end

	PushUnitAlert("thrown", visual_obj, thrower)

	-- <Unit> Heard a thud
	PushUnitAlert("noise", visual_obj, self.ThrowNoise, Presets.NoiseTypes.Default.ThrowableLandmine.display_name)

	local finalPointOfTrajectory = attackResults.explosion_pos
	assert(finalPointOfTrajectory, "Where'd that grenade fall?")
	if not finalPointOfTrajectory then
		return
	end

	local teamSide = thrower and thrower.team and thrower.team.side
	assert(teamSide)
	teamSide = teamSide or "player1"

	local newLandmine = PlaceObject("DynamicSpawnLandmine", {
		-- The landmine properties need to be set at init time
		TriggerType = self.TriggerType,
		triggerRadius = (self.TriggerType == "Proximity" or self.TriggerType == "Proximity-Timed") and 1 or 0,
		TimedExplosiveTurns = self.TimedExplosiveTurns,
		DisplayName = self.DisplayName,
		triggerChance = self.triggerChance,
		fx_actor_class = self.class .. "_OnGround",
		item_thrown = self.class,
		team_side = teamSide,
		attacker = thrower,
	})
	print("TriggerType:", newLandmine.TriggerType)
	print("triggerRadius:", newLandmine.triggerRadius)
	print("TimedExplosiveTurns:", newLandmine.TimedExplosiveTurns)
	print("DisplayName:", newLandmine.DisplayName)
	print("triggerChance:", newLandmine.triggerChance)
	print("fx_actor_class:", newLandmine.fx_actor_class)
	print("item_thrown:", newLandmine.item_thrown)
	print("team_side:", newLandmine.team_side)
	-- print("attacker:", newLandmine.attacker)
	if IsValid(visual_obj) then
		DoneObject(visual_obj)
	end

	-- Copy explosive type config to the mine
	local explosiveTypePreset = self:GetExplosiveTypePreset()
	newLandmine:CopyProperties(explosiveTypePreset, TrapExplosionProperties:GetProperties())

	-- Add explosive skill to landmine damage.
	newLandmine.BaseDamage = thrower:GetBaseDamage(self)

	-- Throwable mines are seen by all
	newLandmine.discovered_by[teamSide] = true
	newLandmine:SetPos(finalPointOfTrajectory)
	newLandmine:EnterSectorInit()
	VisibilityUpdate(true)

	table.iclear(attackResults)
	attackResults.trap_placed = true

	-----
	if attackResults.mishap then
		newLandmine:Explode(thrower, self.fx_actor_class, nil, thrower)
	end
	----
end
 ]] 
