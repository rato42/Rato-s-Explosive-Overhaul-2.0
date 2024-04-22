function AI_deviate_handicap(unit)
	if not EO_IsAI(unit) then
		return 0
	end
	local level = unit:GetLevel() or 1

	if unit.Affiliation == "Adonis" then
		level = level + 2
	elseif unit.Affiliation == "Army" then
		level = level + 1
	end

	local reduction = cRound(level * 1.66)
	reduction = MulDivRound(reduction, tonumber(CurrentModOptions.ai_deviate_hc) or 100, 100)

	return reduction
end

function AI_adj_targetpos_for_bounce(orig_attack_args, target_pos, attack_pos, grenade)

	----------- TODO: increase range for enemies when targeting, normal otherwise

	local attack_args = table.copy(orig_attack_args)
	local max_tries = 40
	local tries = 0
	local z_adj = 10 * guic

	local trg_pos_traj = grenade:GetTrajectory(attack_args, attack_pos, target_pos, false)

	if #trg_pos_traj > 0 then
		target_pos = trg_pos_traj[#trg_pos_traj].pos
	end

	local target_posz = target_pos:z() -- validate_deviated_gren_pos(target_pos, attack_args):z()
	-- local target_pos_z_up = target_pos:z()+ const.SlabSizeZ *5

	-- local col, pts = CollideSegmentsNearest(target_pos:SetZ(target_pos:z() + z_adj), target_pos:SetZ(target_pos_z_up))

	-- if col then
	-- target_pos_z_up = pts[1]:z() - z_adj
	-- DbgAddCircle_ai_adj(pts[1]:SetZ(pts[1]:z() - z_adj), const.SlabSizeX/6, const.clrBlue)
	-- end
	-- target_pos = validate_deviated_gren_pos(target_pos, attack_args)

	local high_target_pos = target_pos:SetZ(target_posz + const.SlabSizeZ * 10)
	local col, pts = CollideSegmentsNearest(target_pos:SetZ(target_posz + z_adj), high_target_pos)

	if col and pts[1] then
		high_target_pos = pts[1]
	end

	DbgAddCircle_ai_adj(high_target_pos, const.SlabSizeX / 2, const.clrBlue)

	local dir = target_pos - attack_pos

	local best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos

	local thrs_dist = 0.2 * const.SlabSizeX
	local dist_adjst = const.SlabSizeX * 0.15
	local sideways_adjst = const.SlabSizeX / 1.5

	local z_tolerance = const.SlabSizeZ * 2 -- grenade.AreaOfEffect and Max(grenade.AreaOfEffect * const.SlabSizeX, const.SlabSizeZ*2) or const.SlabSizeZ*2

	local positive_thresh = cRound(max_tries / 3)
	DbgAddCircle_ai_adj(target_pos, const.SlabSizeX / 2, const.clrBlack)
	-- DbgAddCircle_ai_adj(target_pos, const.SlabSizeX/4, const.clrPink)
	while tries <= max_tries do

		local sign = tries < positive_thresh and 1 or -1

		local adj_mul = tries < positive_thresh and tries or tries - positive_thresh

		local bounce_pos, bounced_trajectory
		local loop_dir = SetLen(dir, dir:Len() + (sign * dist_adjst * adj_mul))

		local final_target_pos = attack_pos + loop_dir
		-- final_target_pos = final_target_pos:SetZ(target_posz)
		final_target_pos = final_target_pos:SetTerrainZ()
		-- final_target_pos =validate_deviated_gren_pos(final_target_pos, attack_args)
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX / 2, const.clrPink)

		local fin_col, fin_pts = CollideSegmentsNearest(high_target_pos:SetZ(high_target_pos:z() - z_adj), final_target_pos)

		if fin_col and fin_pts[1] then
			final_target_pos = fin_pts[1]
		end
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX / 6, const.clrRed)
		DbgAddVector_ai_adj(high_target_pos, final_target_pos - high_target_pos)

		-- local final_tg_copy = final_target_pos
		-- local up_z_pos = final_target_pos:SetZ(target_posz + const.SlabSizeZ *10)
		-- DbgAddCircle_ai_adj(up_z_pos, const.SlabSizeX/6)
		-- DbgAddVector_ai_adj(up_z_pos, final_target_pos - up_z_pos)
		-- local col, pts = CollideSegmentsNearest(final_target_pos, up_z_pos)
		-- local z_pos = up_z_pos:z()

		-- if col and pts[1] and pts[1]:z() > final_target_pos:z() then
		-- z_pos = pts[1]:z() 
		-- DbgAddCircle_ai_adj(pts[1], const.SlabSizeX/4, const.clrBlue)
		-- end

		-- final_target_pos = final_target_pos:SetZ(z_pos)
		-- DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrPink)
		-- final_target_pos = validate_deviated_gren_pos(final_target_pos, attack_args)
		-- DbgAddVector_ai_adj(up_z_pos, final_target_pos - up_z_pos)
		-- DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrRed)
		-- final_target_pos = final_target_pos:SetZ(target_pos_z_up)
		-- final_target_pos = validate_deviated_gren_pos(final_target_pos, attack_args)

		-- local dist = loop_dir:Len() - attack_pos
		-- local rotate_dir = Rotate(loop_dir, 90*60)
		-- rotate_dir = SetLen(rotate_dir, loop_dir:Len())

		-- final_target_pos = target_pos + rotate_dir

		-- print("rotated pos", final_target_pos)

		local trajectory, angle = grenade:GetTrajectory(attack_args, attack_pos, final_target_pos, false)

		if #trajectory > 0 then
			local normal, colide_obj, colide_obj_pos, terrain_material = collision_obj_norm_pos(trajectory, attack_args)

			if colide_obj_pos then
				local att_args_copy = table.copy(attack_args)
				-- att_args_copy.rat_angle = angle
				final_target_pos = colide_obj_pos
				trajectory, angle = grenade:GetTrajectory(att_args_copy, attack_pos, final_target_pos, false)
				-- DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrRed)
			end
		end
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX / 6, const.clrMagenta)
		-- for i, step in ipairs(trajectory) do
		-- DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
		-- end

		local explosion_pos
		if #trajectory > 0 then
			explosion_pos = trajectory[#trajectory].pos
		end

		if explosion_pos then

			bounced_trajectory, bounce_pos = get_bounces(grenade, trajectory, attack_args, explosion_pos)

			bounce_pos = bounced_trajectory[#bounced_trajectory].pos
			-- for i, step in ipairs(bounced_trajectory) do
			-- 		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
			-- end

			if bounce_pos then
				-- DbgAddCircle_ai_adj(bounce_pos, const.SlabSizeX/6, const.clrBlack)
				local bounce_dist_target = bounce_pos:Dist(target_pos)

				-- print("bounce_dist target", bounce_dist_target)
				-- DbgAddVector_ai_adj(bounce_pos, target_pos - bounce_pos, const.clrRed)

				if abs(bounce_pos:z() - target_pos:z()) <= z_tolerance then
					if bounce_dist_target <= thrs_dist then
						DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX / 6, const.clrYellow)
						best_target_pos, best_traj, best_angle, best_bounce_pos = final_target_pos, bounced_trajectory, angle, bounce_pos
						break
						-- return final_target_pos, bounced_trajectory, angle
					elseif best_target_pos then
						best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos =
											best_dist <= bounce_dist_target and best_target_pos, best_dist, best_traj, best_angle,
											best_bounce_pos or final_target_pos, bounce_dist_target, bounced_trajectory, angle, bounce_pos
					else
						best_bounce_pos = bounce_pos
						best_angle = angle
						best_traj = bounced_trajectory
						best_dist = bounce_dist_target
						best_target_pos = final_target_pos
					end
				end
			end
		end

		tries = tries + 1
	end

	for i, step in ipairs(best_traj) do

		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX / 10, const.clrCyan)
	end

	-- DbgAddCircle_ai_adj(best_bounce_pos, const.SlabSizeX/6, const.clrRed)
	-- DbgAddCircle_ai_adj(best_target_pos, const.SlabSizeX/4, const.clrGreen)
	return best_target_pos and best_target_pos, best_traj, best_angle or target_pos, false, false
end

--[[function AI_adj_targetpos_for_bounce(orig_attack_args, target_pos, attack_pos, grenade)

	----------- increase range for enemies when targeting, normal otherwise

	local attack_args = table.copy(orig_attack_args)
	local max_tries = 30
	local tries = 0
	local z_adj = 10*guic
	local target_posz= target_pos:z()--validate_deviated_gren_pos(target_pos, attack_args):z()
	-- local target_pos_z_up = target_pos:z()+ const.SlabSizeZ *5
	
	-- local col, pts = CollideSegmentsNearest(target_pos:SetZ(target_pos:z() + z_adj), target_pos:SetZ(target_pos_z_up))
	
	-- if col then
		-- target_pos_z_up = pts[1]:z() - z_adj
		-- DbgAddCircle_ai_adj(pts[1]:SetZ(pts[1]:z() - z_adj), const.SlabSizeX/6, const.clrBlue)
	-- end
	--target_pos = validate_deviated_gren_pos(target_pos, attack_args)
	
	local dir = target_pos - attack_pos
	
	local best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos
	
	local thrs_dist = 0.3 * const.SlabSizeX
	local dist_adjst = const.SlabSizeX*0.1
	local sideways_adjst = const.SlabSizeX/1.5
	
	local z_tolerance = const.SlabSizeZ*2--grenade.AreaOfEffect and Max(grenade.AreaOfEffect * const.SlabSizeX, const.SlabSizeZ*2) or const.SlabSizeZ*2
	
	local positive_thresh = cRound(max_tries/3)
	DbgAddCircle_ai_adj(target_pos, const.SlabSizeX/2, const.clrBlack)
	--DbgAddCircle_ai_adj(target_pos, const.SlabSizeX/4, const.clrPink)
	while tries <= max_tries do
		
		local sign = tries < positive_thresh and 1 or -1
		
		
		local adj_mul = tries < positive_thresh and tries or tries - positive_thresh
		
		local bounce_pos, bounced_trajectory
		local loop_dir = SetLen(dir, dir:Len() + (sign*dist_adjst*adj_mul))
		

		local final_target_pos = attack_pos + loop_dir
		--final_target_pos = final_target_pos:SetTerrainZ()
		--final_target_pos =validate_deviated_gren_pos(final_target_pos, attack_args)
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/2, const.clrPink)
		
		--local final_tg_copy = final_target_pos
		local up_z_pos = final_target_pos:SetZ(target_posz + const.SlabSizeZ *10)
		DbgAddCircle_ai_adj(up_z_pos, const.SlabSizeX/6)
		DbgAddVector_ai_adj(up_z_pos, final_target_pos - up_z_pos)
        local col, pts = CollideSegmentsNearest(final_target_pos, up_z_pos)
		local z_pos = up_z_pos:z()
		
        if col and pts[1] and pts[1]:z() > final_target_pos:z() then
            z_pos = pts[1]:z() 
            DbgAddCircle_ai_adj(pts[1], const.SlabSizeX/4, const.clrBlue)
		end
		
		
        final_target_pos = final_target_pos:SetZ(z_pos)
		--DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrPink)
        final_target_pos = validate_deviated_gren_pos(final_target_pos, attack_args)
		DbgAddVector_ai_adj(up_z_pos, final_target_pos - up_z_pos)
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrRed)
		-- final_target_pos = final_target_pos:SetZ(target_pos_z_up)
		-- final_target_pos = validate_deviated_gren_pos(final_target_pos, attack_args)

		-- local dist = loop_dir:Len() - attack_pos
		-- local rotate_dir = Rotate(loop_dir, 90*60)
		-- rotate_dir = SetLen(rotate_dir, loop_dir:Len())
		
		-- final_target_pos = target_pos + rotate_dir
		
		-- print("rotated pos", final_target_pos)
			
		
		
		local trajectory, angle = grenade:GetTrajectory(attack_args, attack_pos, final_target_pos, false)
		
		if #trajectory > 0 then
			local normal, colide_obj, colide_obj_pos, terrain_material = collision_obj_norm_pos(trajectory, attack_args)
			
			
			if colide_obj_pos then
				local att_args_copy = table.copy(attack_args)
				-- att_args_copy.rat_angle = angle
				final_target_pos = colide_obj_pos
				trajectory, angle = grenade:GetTrajectory(att_args_copy, attack_pos, final_target_pos, false)
				--DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrRed)
			end
		end
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrMagenta)
		-- for i, step in ipairs(trajectory) do
			-- DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
		-- end
		
		local explosion_pos
		if #trajectory > 0 then
			explosion_pos = trajectory[#trajectory].pos
		end
		
		
		if explosion_pos then
			
			bounced_trajectory, bounce_pos = get_bounces(grenade, trajectory, attack_args, explosion_pos)
			
			
			bounce_pos = bounced_trajectory[#bounced_trajectory].pos
			-- for i, step in ipairs(bounced_trajectory) do
			-- 		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
			-- end
			
			if bounce_pos then
				--DbgAddCircle_ai_adj(bounce_pos, const.SlabSizeX/6, const.clrBlack)
				local bounce_dist_target = bounce_pos:Dist(target_pos)
				
				print("bounce_dist target", bounce_dist_target)
				--DbgAddVector_ai_adj(bounce_pos, target_pos - bounce_pos, const.clrRed)
				
				if abs(bounce_pos:z() - target_pos:z()) <= z_tolerance then
					if bounce_dist_target <= thrs_dist then
						DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrYellow)
						best_target_pos, best_traj, best_angle, best_bounce_pos = final_target_pos, bounced_trajectory, angle, bounce_pos
						break
						--return final_target_pos, bounced_trajectory, angle
					elseif best_target_pos then
						best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos = best_dist <= bounce_dist_target and best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos or final_target_pos, bounce_dist_target, bounced_trajectory, angle, bounce_pos
					else
						best_bounce_pos = bounce_pos
						best_angle = angle
						best_traj = bounced_trajectory
						best_dist = bounce_dist_target
						best_target_pos = final_target_pos
					end
				end
			end
		end	
			
		tries = tries +1
	end
	
	for i, step in ipairs(best_traj) do
			
		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
	end
	
	
	--DbgAddCircle_ai_adj(best_bounce_pos, const.SlabSizeX/6, const.clrRed)
	--DbgAddCircle_ai_adj(best_target_pos, const.SlabSizeX/4, const.clrGreen)
	return best_target_pos and best_target_pos, best_traj, best_angle or target_pos, false, false
end]]

--[[function AI_adj_targetpos_for_bounce(orig_attack_args, target_pos, attack_pos, grenade)

	local attack_args = table.copy(orig_attack_args)
	local max_tries = 30
	local tries = 0
	
	local target_posz= validate_deviated_gren_pos(target_pos, attack_args):z()
	--target_pos = validate_deviated_gren_pos(target_pos, attack_args)
	
	local dir = target_pos - attack_pos
	
	local best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos
	
	local thrs_dist = 0.3 * const.SlabSizeX
	local dist_adjst = const.SlabSizeX*0.2
	local sideways_adjst = const.SlabSizeX/1.5
	
	local z_tolerance = const.SlabSizeZ*2--grenade.AreaOfEffect and Max(grenade.AreaOfEffect * const.SlabSizeX, const.SlabSizeZ*2) or const.SlabSizeZ*2
	
	local positive_thresh = cRound(max_tries/3)

	DbgAddCircle_ai_adj(target_pos, const.SlabSizeX/4, const.clrPink)
	while tries <= max_tries do
		
		local sign = tries < positive_thresh and 1 or -1
		
		
		local adj_mul = tries < positive_thresh and tries or tries - positive_thresh
		
		local bounce_pos, bounced_trajectory
		local loop_dir = SetLen(dir, dir:Len() + (sign*dist_adjst*adj_mul))
		

		local final_target_pos = attack_pos + loop_dir

		final_target_pos = final_target_pos:SetZ(target_posz + const.SlabSizeZ *3)
		final_target_pos = validate_deviated_gren_pos(final_target_pos, attack_args)

		-- local dist = loop_dir:Len() - attack_pos
		-- local rotate_dir = Rotate(loop_dir, 90*60)
		-- rotate_dir = SetLen(rotate_dir, loop_dir:Len())
		
		-- final_target_pos = target_pos + rotate_dir
		
		-- print("rotated pos", final_target_pos)
			
		DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrMagenta)
		
		local trajectory, angle = grenade:GetTrajectory(attack_args, attack_pos, final_target_pos, false)
		
		-- for i, step in ipairs(trajectory) do
			-- DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
		-- end
		
		local explosion_pos
		if #trajectory > 0 then
			explosion_pos = trajectory[#trajectory].pos
		end
		
		
		if explosion_pos then
			
			bounced_trajectory, bounce_pos = get_bounces(grenade, trajectory, attack_args, explosion_pos)
			
			
			bounce_pos = bounced_trajectory[#bounced_trajectory].pos
			-- for i, step in ipairs(bounced_trajectory) do
			-- 		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
			-- end
			
			if bounce_pos then
				DbgAddCircle_ai_adj(bounce_pos, const.SlabSizeX/6, const.clrBlack)
				local bounce_dist_target = bounce_pos:Dist(target_pos)
				
				print("bounce_dist target", bounce_dist_target)
				--DbgAddVector_ai_adj(bounce_pos, target_pos - bounce_pos, const.clrRed)
				
				if abs(bounce_pos:z() - target_posz) <= z_tolerance then
					if bounce_dist_target <= thrs_dist then
						DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrYellow)
						best_target_pos, best_traj, best_angle, best_bounce_pos = final_target_pos, bounced_trajectory, angle, bounce_pos
						break
						--return final_target_pos, bounced_trajectory, angle
					elseif best_target_pos then
						best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos = best_dist <= bounce_dist_target and best_target_pos, best_dist, best_traj, best_angle, best_bounce_pos or final_target_pos, bounce_dist_target, bounced_trajectory, angle, bounce_pos
					else
						best_bounce_pos = bounce_pos
						best_angle = angle
						best_traj = bounced_trajectory
						best_dist = bounce_dist_target
						best_target_pos = final_target_pos
					end
				end
			end
		end	
			
		tries = tries +1
	end
	
	for i, step in ipairs(best_traj) do
			
		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
	end
	
	
	DbgAddCircle_ai_adj(best_bounce_pos, const.SlabSizeX/6, const.clrRed)
	DbgAddCircle_ai_adj(best_target_pos, const.SlabSizeX/4, const.clrGreen)
	return best_target_pos and best_target_pos, best_traj, best_angle or target_pos, false, false
end]]

--[[function AI_adj_targetpos_for_bounce(orig_attack_args, target_pos, attack_pos, grenade)

	local attack_args = table.copy(orig_attack_args)
	local max_tries = 30
	local tries = 0
	
	local target_posz= target_pos:z()
	--target_pos = validate_deviated_gren_pos(target_pos, attack_args)
	
	local dir = target_pos - attack_pos
	
	local best_target_pos, best_dist, best_traj, best_angle
	
	local thrs_dist = 0.3 * const.SlabSizeX
	local dist_adjst = const.SlabSizeX*0.3
	local sideways_adjst = const.SlabSizeX/1.5
	
	local z_tolerance = const.SlabSizeZ*2--grenade.AreaOfEffect and Max(grenade.AreaOfEffect * const.SlabSizeX, const.SlabSizeZ*2) or const.SlabSizeZ*2
	
	local positive_thresh = cRound(max_tries/3)

	DbgAddCircle_ai_adj(target_pos, const.SlabSizeX/4, const.clrBlack)
	while tries <= max_tries do
		
		local sign = tries < positive_thresh and 1 or -1
		
		
		local adj_mul = tries < positive_thresh and tries or tries - positive_thresh
		
		local bounce_pos, bounced_trajectory
		local loop_dir = SetLen(dir, dir:Len() + (sign*dist_adjst*adj_mul))
		local final_target_pos = attack_pos + loop_dir
		
		final_target_pos = final_target_pos:SetZ(target_posz + const.SlabSizeZ *2)
		final_target_pos = validate_deviated_gren_pos(final_target_pos, attack_args)
		local before_rotation = final_target_pos
		for i = -2 , 2 do 
			print(i, "initial pos", final_target_pos)
			local rotation =  Rotate(point(sideways_adjst*i, 0, 0)) --RotateAxis(point(sideways_adjst, 0, 0), axis_z, i*90*60) 
			
			local finaltargetVector = final_target_pos
			final_target_pos = before_rotation + rotation
			
		
			print("rotated pos", final_target_pos)
				
			DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, i == -1 and const.clrRed or i== 1 and const.clrBlue or const.clrMagenta)
			DbgAddVector_ai_adj(finaltargetVector, final_target_pos - finaltargetVector, const.clrBlue)
			local trajectory, angle = grenade:GetTrajectory(attack_args, attack_pos, final_target_pos, false)
			
			-- for i, step in ipairs(trajectory) do
				
				-- DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
			-- end
			
			local explosion_pos
			if #trajectory > 0 then
				explosion_pos = trajectory[#trajectory].pos
			end
			
			
			if explosion_pos then
				
				bounced_trajectory, bounce_pos = get_bounces(grenade, trajectory, attack_args, explosion_pos)
				
				
				bounce_pos = bounced_trajectory[#bounced_trajectory].pos
				-- for i, step in ipairs(bounced_trajectory) do
				
				-- DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
				-- end
				
				if bounce_pos then
					local bounce_dist_target = bounce_pos:Dist(target_pos)
					
					print("bounce_dist target", bounce_dist_target)
					--DbgAddVector_ai_adj(bounce_pos, target_pos - bounce_pos, const.clrRed)
					
					if abs(bounce_pos:z() - target_posz) <= z_tolerance then
						-- if bounce_dist_target <= thrs_dist then
							-- DbgAddCircle_ai_adj(final_target_pos, const.SlabSizeX/6, const.clrYellow)
							-- return final_target_pos, bounced_trajectory, angle
						-- else
						if best_target_pos then
							best_target_pos, best_dist, best_traj = best_dist <= bounce_dist_target and best_target_pos, best_dist, best_traj, best_angle or final_target_pos, bounce_dist_target, bounced_trajectory, angle
						else
							best_angle = angle
							best_traj = bounced_trajectory
							best_dist = bounce_dist_target
							best_target_pos = final_target_pos
						end
					end
				end
			end	
		end--DbgAddCircle_ai_adj(best_target_pos, const.SlabSizeX/2, const.clrBlue)	
		tries = tries +1
	end
	
	for i, step in ipairs(best_traj) do
			
		DbgAddCircle_ai_adj(step.pos, const.SlabSizeX/10, const.clrCyan)
	end
	
	
	
	DbgAddCircle_ai_adj(best_target_pos, const.SlabSizeX/4, const.clrGreen)
	return best_target_pos and best_target_pos, best_traj, best_angle or target_pos, false, false
end]]

