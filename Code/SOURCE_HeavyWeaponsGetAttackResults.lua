function HeavyWeapon:GetAttackResults(action, attack_args)
	local attacker = attack_args.obj
	local prediction = attack_args.prediction
	local trajectory, stealth_kill
	local lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group or "Torso")
	local lof_data = (attack_args.lof or empty_table)[lof_idx or 1]
	local target_pos = attack_args.target_pos or lof_data and lof_data.target_pos or (IsValid(attack_args.target) and attack_args.target:GetPos())
	local ordnance = self.ammo

	if not target_pos:IsValidZ() then
		target_pos = target_pos:SetTerrainZ()
	end

	-- mishap & stealth kill checks
	local mishap
	if not prediction and not attack_args.explosion_pos and IsKindOf(self, "MishapProperties") then
		local chance = self:GetMishapChance(attacker, target_pos)
		if CheatEnabled("AlwaysMiss") or attacker:Random(100) < chance then
			local dv = self:GetMishapDeviationVector(attacker, target_pos)
			mishap = true
			target_pos = target_pos + dv
			attacker:ShowMishapNotification(action)
		end
	end

	if self.trajectory_type == "line" then
		attack_args.max_pierced_objects = 0
		attack_args.can_use_covers = false
		if not prediction then
			attack_args.prediction = false
			attack_args.can_use_covers = false
			attack_args.seed = attacker:Random()
			local attack_data = GetLoFData(attacker, target_pos, attack_args)
			attack_args.lof = attack_data.lof
			lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group or "Torso")
			lof_data = attack_args.lof[lof_idx or 1]
		end
		-- trajectory from lof (shot origin -> first hit/target_pos)
		if lof_data then
			local hits = lof_data.hits or empty_table
			local hit_pos
			if #hits > 0 then
				hit_pos = hits[1].pos
			else
				hit_pos = target_pos
			end
			hit_pos = attack_args.explosion_pos or hit_pos
			local dist = lof_data.attack_pos:Dist(hit_pos)
			local time = MulDivRound(dist, 1000, const.Combat.RocketVelocity)
			trajectory = {
				{ pos = lof_data.attack_pos, t = 0 },
				{ pos = hit_pos, t = time },
			}
		end
	elseif self.trajectory_type == "parabola" then
		attack_args.can_bounce = ordnance and ordnance.CanBounce
		trajectory = Grenade:GetTrajectory(attack_args, nil, target_pos, mishap)
	elseif self.trajectory_type == "bombard" then
		-- no parabola for bombard
	else
		assert(false, string.format("unknown trajectory type '%s' used in heavy weapon '%s' of class %s", tostring(self.trajectory_type), self.class, self.class))
	end
	
	if not attack_args.explosion_pos and ((not trajectory or #trajectory == 0) and self.trajectory_type ~= "bombard" or not self.ammo or self.ammo.Amount <= 0) then
		return {}
	end
	
	local jammed, condition = false, false
	if prediction then
		attack_args.jam_roll = 0
		attack_args.condition_roll = 0
	else
		attack_args.jam_roll = attack_args.jam_roll or (1 + attacker:Random(100))
		attack_args.condition_roll = attack_args.condition_roll or (1 + attacker:Random(100))
		jammed, condition = self:ReliabilityCheck(attacker, 1, attack_args.jam_roll, attack_args.condition_roll)
	end
	
	if jammed then
		return {jammed = true, condition = condition}
	end
	local impact_pos = attack_args.explosion_pos or (trajectory and #trajectory > 0 and trajectory[#trajectory].pos) or target_pos
	local aoe_params = self:GetAreaAttackParams(action.id, attacker, impact_pos)
	aoe_params.stealth_kill = stealth_kill
	if attack_args.stealth_attack then
		aoe_params.stealth_attack_roll = not prediction and attacker:Random(100) or 100
	end

	aoe_params.prediction = prediction
	local results = GetAreaAttackResults(aoe_params, nil, not prediction and ordnance.AppliedEffects)
	results.trajectory = trajectory
	results.ordnance = ordnance
	results.weapon = ordnance
	results.jammed = jammed
	results.condition = condition
	results.fired = not jammed and 1
	results.mishap = mishap
	results.burn_ground = ordnance.BurnGround
	if self.trajectory_type == "bombard" then
		results.explosion_pos = target_pos
		if not jammed then
			results.fired = Min(attack_args.bombard_shots, ordnance.Amount)
		end
	elseif self.trajectory_type == "line" then
		-- add cone aoe behind attacker
		assert(#trajectory > 1)
		
		local range = self.BackfireRange
		local step_pos = attack_args.step_pos
		local target_pos = step_pos + SetLen(trajectory[1].pos - trajectory[2].pos, range * const.SlabSizeX)	
		
		local cone_params = {
			can_be_damaged_by_attack = false,			
			cone_angle = self.BackfireConeAngle,
			max_range = range,
			target_pos = target_pos,
			attacker = attacker,
			step_pos = step_pos,
			explosion = true,
			weapon = aoe_params.weapon,
			damage_override = self.BackfireDamage,
			damage_mod = 100,
			attribute_bonus = 0,
			prediction = prediction,
		}
		
		
		local cone_results = GetAreaAttackResults(cone_params)
		
		-- merge results from the cone attack into 'results'
		for _, hit in ipairs(cone_results) do
			hit.backfire = true
			results[#results + 1] = hit			
		end
		for _, obj in ipairs(cone_results.hit_objs) do
			results.hit_objs = results.hit_objs or {}
			table.insert_unique(results.hit_objs, obj)
		end
		
		results.total_damage = (results.total_damage or 0) + (cone_results.total_damage or 0)
		results.friendly_fire_dmg = (results.friendly_fire_dmg or 0) + (cone_results.friendly_fire_dmg or 0)
	end
	CompileKilledUnits(results)
	return results
end