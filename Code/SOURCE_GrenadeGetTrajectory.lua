function Grenade:GetTrajectory(attack_args, attack_pos, target_pos, mishap, bounce, bounce_angle)
	if not attack_pos and attack_args.lof then
		local lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group)
		local lof_data = attack_args.lof[lof_idx or 1]
		attack_pos = lof_data.attack_pos
	end

	if not attack_pos then 
		return {}
	end

	-- sanity-check the target pos
	local pass = SnapToPassSlab(target_pos)

	local valid_target = true
	if pass then
		pass = pass:IsValidZ() and pass or pass:SetTerrainZ()
		if abs(pass:z() - target_pos:z()) >= 2*const.SlabSizeZ then
			valid_target = false
		end
	else 
		valid_target = false
	end
	
	local num_bounces = attack_args.num_bounces
	
	if bounce then
		--DbgAddCircle_rat(attack_args, target_pos, const.SlabSizeX/2, const.clrRed)
		target_pos = target_pos:SetTerrainZ() --target_pos:SetZ(target_pos:SetTerrainZ():z() +100 * guic)
		--target_pos = validate_deviated_gren_pos(target_pos, attack_args) --- dont use it, trust me
		DbgAddCircle_rat(attack_args, target_pos, const.SlabSizeX/1, const.clrMagenta)
	end

	
	-- try the different trajectories to pick a suitable one
	local angles = {}
		
	if attack_args.rat_angle and not bounce_angle and not mishap then
		angles = {attack_args.rat_angle}
	--elseif valid_target or mishap and not bounce then 
	elseif valid_target or mishap and not bounce_angle then 
		if target_pos:z() - attack_pos:z() >= 2*const.SlabSizeZ then
			angles[1] = const.Combat.GrenadeLaunchAngle_Incline
			angles[2] = const.Combat.GrenadeLaunchAngle
		else
			-- throwing down/level, prefer low arc
			if target_pos:z() - attack_pos:z() <= const.SlabSizeZ / 2 then
				angles[1] = const.Combat.GrenadeLaunchAngle_Low
			end
			angles[#angles+1] = const.Combat.GrenadeLaunchAngle
			if not GameState.Underground then
				angles[#angles+1] = const.Combat.GrenadeLaunchAngle_Incline
			end
		end
	end




	-------------------
	--local bounce_angle = 1800
	if bounce_angle then
		angles = {bounce_angle}
	end
	
	local attacker = attack_args.obj

	local best_dist, best_trajectory = attacker:GetDist(target_pos), {}
	-------------------
	if bounce then
		--print("bounce")
		best_dist, best_trajectory = attack_pos:Dist(target_pos), {}
	end
	
	
	local final_angle
	-----------------
	for _, angle in ipairs(angles) do	
		local trajectory
		--------------------------------------
		if bounce then
			trajectory = self:Ratonade_Bounce_CalcTrajectory(attack_args, target_pos, angle, (angle == const.Combat.GrenadeLaunchAngle_Low) and 1 or 0, attack_pos)		
		else
		---------------------------------------
			trajectory = self:CalcTrajectory(attack_args, target_pos, angle, (angle == const.Combat.GrenadeLaunchAngle_Low) and 1 or 0)		
		end
		local hit_pos = (#trajectory > 0) and trajectory[#trajectory].pos
		if hit_pos and (hit_pos:Dist(trajectory[1].pos) > 0) then
			--print("hit pos", hit_pos)
			if IsCloser(hit_pos, target_pos, const.SlabSizeX) then
				best_trajectory, final_angle = trajectory, angle
				break
				--return trajectory, angle
			end
			local dist = hit_pos:Dist(target_pos)
			if dist < best_dist then
				best_dist, best_trajectory = dist, trajectory
				final_angle = angle
			end
		end
	end
	
	
	---------------
	----- 1240 1222
	--[[if not bounce and best_trajectory and #best_trajectory> 0 then
		print("trajectory time pre adjs", #best_trajectory> 0 and best_trajectory[#best_trajectory].t)
		local mass_factor = grenade_mass_factor_adjusted(self,10) or 0) 
		--mass_factor = Min(1.15, mass_factor)
		print("mass_factor for launch", mass_factor)
		for i, step in ipairs(best_trajectory) do
			step.t = cRound(step.t * mass_factor) 

		end
		print("trajectory time final", #best_trajectory> 0 and best_trajectory[#best_trajectory].t)
	end]]
	
	if not bounce and best_trajectory and #best_trajectory> 0 then
		--print(#best_trajectory)
		--print("trajectory time pre adjs", #best_trajectory> 0 and best_trajectory[#best_trajectory].t)
		local launch_time_adjustment_factor = 1-grenade_mass_factor_adjusted(self, 8) or 0
		--launch_time_adjustment_factor = launch_time_adjustment_factor -0.10
		launch_time_adjustment_factor = Min(1.20, launch_time_adjustment_factor)
		--print("mass_factor for launch", launch_time_adjustment_factor)
		
		
		--local launch_time_adjustment_factor = mass_factor-- ^ (1/6)
		
		
		local launch_time = best_trajectory[2].t ------- T STEP IS ALWAYS 20
		--local launch_dist = best_trajectory[1].pos:Dist(best_trajectory[2].pos)
		--print("launch_time", launch_time)
		local adjusted_launch_time = cRound(launch_time * launch_time_adjustment_factor)
		
		
		for i, step in ipairs(best_trajectory) do
			step.t = adjusted_launch_time + cRound((step.t - launch_time) * launch_time_adjustment_factor)
		end
		--print("trajectory time final", #best_trajectory> 0 and best_trajectory[#best_trajectory].t)
	end
	
	
	-- if IsKindOf(self, "ShapedCharge") then
		-- print(#best_trajectory)
		-- local start_slow_step = #best_trajectory / 2
		-- print("strt step", start_slow_step)
		-- local start_slow_time = best_trajectory[start_slow_step].t
		-- local slow = 1.5
		-- local adjusted = cRound(start_slow_time * slow)
		
		-- for i, step in ipairs(best_trajectory) do
			
			-- if i >= start_slow_step and best_trajectory[i].t then
			
				-- local adjusted_time = adjusted + cRound((step.t - start_slow_time) * (1 / slow))
				
				-- step.t = adjusted_time
				-- print(i, step.t)
			-- end
		-- end
	-- end
	-------------
	
	return best_trajectory, final_angle
end


function Grenade:GetTrajectory_Original(attack_args, attack_pos, target_pos, mishap)
	if not attack_pos and attack_args.lof then
		local lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group)
		local lof_data = attack_args.lof[lof_idx or 1]
		attack_pos = lof_data.attack_pos
	end

	if not attack_pos then 
		return {}
	end
	
	-- sanity-check the target pos
	local pass = SnapToPassSlab(target_pos)
	local valid_target = true
	if pass then
		pass = pass:IsValidZ() and pass or pass:SetTerrainZ()
		if abs(pass:z() - target_pos:z()) >= 2*const.SlabSizeZ then
			valid_target = false
		end
	else 
		valid_target = false
	end
		
	-- try the different trajectories to pick a suitable one
	local angles = {}
		
	if valid_target or mishap then 
		if target_pos:z() - attack_pos:z() >= 2*const.SlabSizeZ then
			angles[1] = const.Combat.GrenadeLaunchAngle_Incline
			angles[2] = const.Combat.GrenadeLaunchAngle
		else
			-- throwing down/level, prefer low arc
			if target_pos:z() - attack_pos:z() <= const.SlabSizeZ / 2 then
				angles[1] = const.Combat.GrenadeLaunchAngle_Low
			end
			angles[#angles+1] = const.Combat.GrenadeLaunchAngle
			if not GameState.Underground then
				angles[#angles+1] = const.Combat.GrenadeLaunchAngle_Incline
			end
		end
	end
	
	local attacker = attack_args.obj

	local best_dist, best_trajectory = attacker:GetDist(target_pos), {}
	for _, angle in ipairs(angles) do		
		local trajectory = self:CalcTrajectory_Original(attack_args, target_pos, angle, (angle == const.Combat.GrenadeLaunchAngle_Low) and 1 or 0)		
		local hit_pos = (#trajectory > 0) and trajectory[#trajectory].pos
		if hit_pos and (hit_pos:Dist(trajectory[1].pos) > 0) then 
			if IsCloser(hit_pos, target_pos, const.SlabSizeX) then
				return trajectory
			end
			local dist = hit_pos:Dist(target_pos)
			if dist < best_dist then
				best_dist, best_trajectory = dist, trajectory
			end
		end
	end
	return best_trajectory
end

function Grenade:CalcTrajectory_Original(attack_args, target_pos, angle, max_bounces)
	local attacker = attack_args.obj
	local anim_phase = attacker:GetAnimMoment(attack_args.anim, "hit") or 0
	local attack_offset = attacker:GetRelativeAttachSpotLoc(attack_args.anim, anim_phase, attacker, attacker:GetSpotBeginIndex("Weaponr"))
	local step_pos = attack_args.step_pos
	if not step_pos:IsValidZ() then
		step_pos = step_pos:SetTerrainZ()
	end
	local pos0 = step_pos:SetZ(step_pos:z() + attack_offset:z())
	if not angle then
		if target_pos:z() - pos0:z() > const.SlabSizeZ / 2 then
			angle = const.Combat.GrenadeLaunchAngle_Incline
		else
			angle = const.Combat.GrenadeLaunchAngle
		end
	end
	local sina, cosa = sincos(angle)
	local aim_pos = pos0 + Rotate(point(cosa, 0, sina), CalcOrientation(pos0, target_pos))
	local grenade_pos = GetAttackPos(attack_args.obj, step_pos, axis_z, attack_args.angle, aim_pos, attack_args.anim, anim_phase, attack_args.weapon_visual)
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
	if max_bounces > 0 then
		local coeff = 1000
		local d = 10 * bounce_diminish
		for i = 1, max_bounces do
			coeff = coeff + d
			d = MulDivRound(d, bounce_diminish, 100)
		end
		local bounce_target_pos = grenade_pos + MulDivRound(dir, 1000, coeff)
		vec = CalcLaunchVector(grenade_pos, bounce_target_pos, angle, const.Combat.Gravity)
	else
		vec = CalcLaunchVector(grenade_pos, target_pos, angle, const.Combat.Gravity)
	end
	local time = MulDivRound(grenade_pos:Dist2D(target_pos), 1000, Max(vec:Len2D(), 1))
	if time == 0 then
		return empty_table
	end
	local trajectory = CalcBounceParabolaTrajectory(grenade_pos, vec, const.Combat.Gravity, time, 20, max_bounces, bounce_diminish)
	return trajectory
end