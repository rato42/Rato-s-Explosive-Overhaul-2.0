function Grenade:Ratonade_Bounce_CalcTrajectory(attack_args, target_pos, angle, max_bounces, attack_pos)
	-- local attacker = attack_args.obj
	-- local anim_phase = attacker:GetAnimMoment(attack_args.anim, "hit") or 0
	-- local attack_offset = attacker:GetRelativeAttachSpotLoc(attack_args.anim, anim_phase, attacker, attacker:GetSpotBeginIndex("Weaponr"))
	-- local step_pos = attack_args.step_pos
	-- if not step_pos:IsValidZ() then
		-- step_pos = step_pos:SetTerrainZ()
	-- end
	------------------------
	local no_colision = false
	local step_pos = attack_pos

	-- local visual_obj = self:GetVisualObj(self)
	-- local attack_offset = visual_obj:GetVisualPos()
	if not step_pos:IsValidZ() then
		step_pos = step_pos:SetTerrainZ()
	end

	local pos0 = step_pos
	-------------------
	--local pos0 = step_pos:SetZ(step_pos:z() + attack_offset:z())
	if not angle then
		if target_pos:z() - pos0:z() > const.SlabSizeZ / 2 then
			angle = const.Combat.GrenadeLaunchAngle_Incline
		else
			angle = const.Combat.GrenadeLaunchAngle
		end
	end

	local sina, cosa = sincos(angle)

	local aim_pos = pos0 + Rotate(point(cosa, 0, sina), CalcOrientation(pos0, target_pos))
	local grenade_pos = step_pos
	-- local grenade_pos = GetAttackPos(attack_args.obj, step_pos, axis_z, attack_args.angle, aim_pos, attack_args.anim, anim_phase, attack_args.weapon_visual)

	-- grenade_pos = grenade_pos:SetZ(attack_pos:z())
	--DbgAddCircle(grenade_pos, const.SlabSizeX/2, const.clrBlue)
	if grenade_pos:Equal2D(target_pos) then
		return empty_table
	end

	local dir = target_pos - grenade_pos
	local bounce_diminish = 40
	local vec
	local can_bounce = self.CanBounce
	if attack_args.can_bounce ~= nil then
		can_bounce = attack_args.can_bounce
	end
	max_bounces = can_bounce and max_bounces or 0
	if can_bounce then
		max_bounces = 1
	end
	-- if max_bounces > 0 then
		-- local coeff = 1000
		-- local d = 10 * bounce_diminish
		-- for i = 1, max_bounces do
			-- coeff = coeff + d
			-- d = MulDivRound(d, bounce_diminish, 100)
		-- end
		-- local bounce_target_pos = grenade_pos + MulDivRound(dir, 1000, coeff)
		-- vec = CalcLaunchVector(grenade_pos, bounce_target_pos, angle, const.Combat.Gravity)
	-- else
		--vec = CalcLaunchVector(grenade_pos, target_pos, angle, const.Combat.Gravity)
		-- local dist = grenade_pos:Dist2D(target_pos)
		-- if attack_args.num_bounces then
			-- local adj = 1 - ((attack_args.num_bounces) * -0.2)
			-- target_pos = target_pos - SetLen(dir, dist * adj)
		-- end
			
			
		vec = CalcLaunchVector(grenade_pos, target_pos, angle, const.Combat.Gravity)
	--end
	
	--if attack_args.num_bounces then
		--local adj = 1 - ((attack_args.num_bounces +1) * -0.2)
		--vec = SetLen(vec, vec:Len())
	--end
	
	local time = MulDivRound(grenade_pos:Dist2D(target_pos), 1000, Max(vec:Len2D(), 1))
	if time == 0 then
		return empty_table
	end
	-- if angle and angle <0 then
		-- local adj_speed = 40
		-- time = MulDivRound(time, adj_speed, 100) 
		--vec = vec:SetLen(vec, MulDivRound(vec:Len(), 100, adj_speed)
	-- end

	local trajectory = CalcBounceParabolaTrajectory(grenade_pos, vec, const.Combat.Gravity, time, 20, max_bounces, bounce_diminish, false)
	
	--if attack_args.num_bounces == 2 then
		--trajectory = CalcBounceParabolaTrajectory_for_deviation(grenade_pos, vec, const.Combat.Gravity, time, 20, max_bounces, bounce_diminish, true)
	--end
	-- if #trajectory < 5 then
		-- trajectory = CalcBounceParabolaTrajectory(grenade_pos, vec, const.Combat.Gravity, time, 1, max_bounces, bounce_diminish, false)
	-- end
	
	--print("--------------- trajectory n steps: ", attack_args.num_bounces,  #trajectory, time, grenade_pos:Dist2D(target_pos), angle) 
	return trajectory
end







