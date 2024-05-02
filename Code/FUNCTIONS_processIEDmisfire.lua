function processIEDmisfire(weapon, unit)
	print("process ied")
	if weapon and weapon.is_ied then
		local chance = 100
		local roll = unit:Random(99) + 1
		print("chance", chance, "roll", roll)
		if roll <= chance then
			print("misfire")
			return true
		end
	end
	return false
end
function MishapProperties:IED_trap_OnLand(thrower, attackResults, visual_obj, original_fx_actor)

	-- print("resu", attackResults)

	--[[ 	if self.TriggerType == "Contact" then
		Grenade.OnLand(self, thrower, attackResults, visual_obj)
		return
	end ]]

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

	local random_type = thrower:Random(3)
	print("randomtype", random_type)
	local landmine_args
	if random_type == 1 then
		print("prox")
		landmine_args = {
			TriggerType = "Proximity",
			triggerRadius = 1,
			TimedExplosiveTurns = 1,

		}
	elseif random_type == 2 then
		print("timed")
		landmine_args = {
			TriggerType = "Timed",
			triggerRadius = 0,
			TimedExplosiveTurns = thrower:Random(3) + 1,

		}
	else
		print("inert")
		landmine_args = {
			TriggerType = "Proximity",
			triggerRadius = 0,
			TimedExplosiveTurns = 1,

		}
	end

	local newLandmine = PlaceObject("DynamicSpawnLandmine", {
		-- The landmine properties need to be set at init time
		TriggerType = landmine_args.TriggerType,
		triggerRadius = landmine_args.triggerRadius,
		TimedExplosiveTurns = landmine_args.TimedExplosiveTurns,
		DisplayName = self.DisplayName,
		triggerChance = "Always",
		fx_actor_class = self.class .. "_Misfired",
		item_thrown = self.class,
		team_side = teamSide,
		attacker = thrower,
		ied_misfire_trap = true,
		GrenadeExplosion = IsKindOf(self, "Grenade") or false, -- true,
		r_original_fx_actor = original_fx_actor or false,
	})

	if IsValid(visual_obj) then
		DoneObject(visual_obj)
	end

	-- Copy explosive type config to the mine
	local explosiveTypePreset = IsKindOf(self, "ThrowableTrapItem") and self:GetExplosiveTypePreset() or self -- g_Classes["C4"] -- self:GetExplosiveTypePreset()
	newLandmine:CopyProperties(explosiveTypePreset, TrapExplosionProperties:GetProperties())

	-- Add explosive skill to landmine damage.
	newLandmine.BaseDamage = thrower:GetBaseDamage(self)

	-- Throwable mines are seen by all
	-- newLandmine.discovered_by[teamSide] = true
	newLandmine:SetPos(finalPointOfTrajectory)
	newLandmine:EnterSectorInit()

	local orient = newLandmine:GetOrientation()

	VisibilityUpdate(true)

	table.iclear(attackResults)

	--
	CreateFloatingText(newLandmine:GetPos(), T("<color AmmoAPColor>IED Misfire</color>"))
	--

	attackResults.trap_placed = true

end
