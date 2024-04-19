
function ratonade_bounce(self, trajectory, attack_args, explosion_pos, bounces)	


	local speed = get_throw_speed(trajectory, attack_args, 3)	--= get_throw_speed(trajectory, 5)
	
	if not speed then
		return trajectory, false, false
	end
	-- local trj_idx = trj_idx or 3
	-- if #trajectory > trj_idx then ---------------ADD GRAVITY
		-- local t_spd_idx = #trajectory - trj_idx
		
		
		-- local start_pos = trajectory[t_spd_idx].pos
		-- local start_time = trajectory[t_spd_idx].t
		-- local end_pos = trajectory[#trajectory].pos
		-- local end_time = trajectory[#trajectory].t
		
		-- local dist_sp = start_pos:Dist(end_pos)
		-- speed = dist_sp / (end_time - start_time) 
		-- rat_printBounce("speed", speed)
		
	-- elseif #trajectory > 1 then
	
		-- start_pos = trajectory[1].pos
		-- start_time = trajectory[1].t
		-- end_pos = trajectory[#trajectory].pos
		-- end_time = trajectory[#trajectory].t
		
		-- dist_sp = start_pos:Dist(end_pos)
		-- speed = dist_sp / (end_time - start_time)
		
	-- end
	
	rat_printBounce("speed", speed)
	
	local mishap = false
	local bounce_pos

	local normal, colide_obj, colide_obj_pos, terrain_material = collision_obj_norm_pos(trajectory, attack_args, 500)


	if colide_obj_pos then
		DbgAddCircle_rat(attack_args, colide_obj_pos, const.SlabSizeX/2, const.clrYellow)
		rat_printBounce("Collision detected at position:", colide_obj_pos)
	end
	
	local colide
	local is_wall 

	if colide_obj and IsKindOf(colide_obj, "WallSlab") then
		is_wall = true
		rat_printBounce("is wall")
	end

	--if not attack_args.prediction  then
	if explosion_pos then
		colide = colide_obj and (terrain_material or ( (not colide_obj:IsKindOf("SlabWallDoor") or colide_obj:IsDead() or colide_obj.pass_through_state ~= "open")))--and IsKindOf(colide_obj, "WallSlab")--CollideSegmentsNearest(explosion_pos, explosion_pos:SetTerrainZ())
		if colide_obj then
			rat_printBounce("colide obj", colide_obj.class)
		end
	end
	
	if colide then
		--normal = is_wall and Rotate(axis_x, colide_obj:GetAngle()) or normal
		-- print("pre validation normal", normal)
		-- if colide_obj and colide_obj ~= "terrain" then
			-- print("rotate method normal", Rotate(axis_x, colide_obj:GetAngle()))
		-- end
		if not is_valid_normal(normal) then
			normal = colide_obj and colide_obj ~= "terrain" and Rotate(axis_x, colide_obj:GetAngle()) or normal
			if not is_valid_normal(normal) then
				--normal = axis_z
				-- rat_printBounce("normal 0 0 0")
				return trajectory, false, false
			end
		end
		--print("normal", normal)
		--trajectory[#trajectory].pos = colide_obj_pos

		
		local adj = 10
		--if is_wall then --or bounces > 0 and terrain_material then
			--bounces < 1 and 10 or 0
		
			local pos_ult = trajectory[#trajectory].pos
			
			-------------------------------------------------------------- trajectory pos
			local pos_penultimo = trajectory[cRoundDown(#trajectory-3)].pos
			local dist = pos_penultimo:Dist(pos_ult)  
			local adj_dist = dist - adj * guic
			if adj_dist > 0 then
				local end_pt = pos_penultimo + SetLen(pos_ult - pos_penultimo, adj_dist)
				trajectory[#trajectory].pos = end_pt
			end	
			--------------------------------------------------------------
		
		-- elseif bounces> 0 then	
			------------------------------------------------------------ normal and end pos
			-- local pos_ult = trajectory[#trajectory].pos
			-- local end_pt = pos_ult - SetLen(normal, adj * guic)
			-- trajectory[#trajectory].pos = end_pt
			--------------------------------------------------------------
		--end
		
		--[[local dist = pos_penultimo:Dist(pos_ult)
		local adj = -10--bounces < 2 and 10 or 0
		local adj_dist = dist - adj * guic  -- Adjusted distance
		if adj_dist > 0 then
			local end_pt = pos_penultimo + SetLen(pos_ult - pos_penultimo, adj_dist)
			trajectory[#trajectory].pos = end_pt
		end]]
		-- if colide_obj == "terrain" then
			-- trajectory[#trajectory].pos = trajectory[#trajectory].pos:SetTerrainZ()
			-- trajectory[#trajectory].pos = trajectory[#trajectory].pos:SetZ(trajectory[#trajectory].pos:z() - adj * guic)
			
		-- else
			--local pos_penultimo = trajectory[cRoundDown(#trajectory/1.5)].pos
			--local pos_ult = trajectory[#trajectory].pos
		
			--local normal_adjs = pos_ult - normal
		
			-- DbgAddVector_rat(attack_args, pos_penultimo, pos_ult - pos_penultimo, const.clrGreen)
			-- local dist = pos_penultimo:Dist(pos_ult)

			-- local adj_dist = dist - adj * guic  -- Adjusted distance
			--if adj_dist > 0 then
				--local end_pt = pos_ult + SetLen(normal, adj * guic)
				--trajectory[#trajectory].pos = end_pt
			--end
		--end
		
		
		--trajectory[#trajectory].pos = trajectory[#trajectory].pos:SetZ(trajectory[#trajectory].pos:z() + 10 * guic)

		
		--speed = cRound(speed * (1.00 - (bounces *0.2)))
		-- print("col obj class at #bounce", bounces, colide_obj.class)
		-- print("col obj  at #bounce", bounces, colide_obj)
		
		local col_obj_entity = colide_obj.class and EntityData[colide_obj.class] and EntityData[colide_obj.class].entity or false
		local surf_fx_type = terrain_material or col_obj_entity and col_obj_entity.material_type or GetObjMaterial(colide_obj_pos, colide_obj):match(":%s*(.+)$")
		--print("mat", GetObjMaterialFXTarget(colide_obj))
		
		rat_printBounce("material", surf_fx_type)
	   ------------------------------------
		local ricochet_start_pos = trajectory[#trajectory].pos
		--ricochet_start_pos = ricochet_start_pos:SetZ(ricochet_start_pos:z() - 100)
		
		
		
		
		
		
		
		
		--local norm = is_wall and Rotate(axis_x, colide_obj:GetAngle()) or normal--Rotate(axis_x, colide_obj:GetAngle())
		local norm = normal

		DbgAddVector_rat(attack_args, ricochet_start_pos, norm, const.clrOrange)

		rat_printBounce("grenade norm", norm)
		local dir = trajectory[#trajectory-3].pos - trajectory[#trajectory].pos
		
		--DbgAddVector_rat(attack_args,  (trajectory[#trajectory-2].pos)*100, (trajectory[#trajectory].pos -  trajectory[#trajectory-2].pos )*100, const.clrCyan)
		local ricochet_dir = dir - MulDivRound(norm, 2 * Dot(dir, norm), Dot(norm, norm))

		local magnitude_bounce = get_bounce_distance(speed, surf_fx_type, self)
		
		if not magnitude_bounce or ricochet_dir == point30 or dir == point30 then
			return trajectory, false, false
		end
		

		bounce_pos = ricochet_start_pos - SetLen(ricochet_dir, magnitude_bounce)
		
		bounce_pos = IsValidZ(bounce_pos) and bounce_pos or bounce_pos:SetTerrainZ()
		--local bounce_angle = abs(atan(ricochet_dir:z(), sqrt(ricochet_dir:x()^2 + ricochet_dir:y()^2)))
		
		
		--local bounce_angle = (atan(ricochet_dir:z(), abs(sqrt(ricochet_dir:x()^2 + ricochet_dir:y()^2))))
		local start_high = ricochet_start_pos:z() > bounce_pos:z()
		-- local negative_z = ricochet_dir:z() < 0
		
		-- local sign = (start_high or negative_z) and -1 or 1
		
		local bounce_angle 
		
		if not start_high then
			bounce_angle = abs(atan(ricochet_dir:z(), sqrt(ricochet_dir:x()^2 + ricochet_dir:y()^2)))
		else
			bounce_angle = -abs(atan(dir:z(), sqrt(dir:x()^2 + dir:y()^2)))
			--print("------------- bounce angle befor adjs", bounce_angle)
			bounce_angle = Max(-500, bounce_angle)
			--print("------------- bounce angle", bounce_angle)
		end
		
		local debug_angle_text = "num bounce: " .. bounces .. " angle :" .. bounce_angle
		--DbgAddText_rat(attack_args, debug_angle_text, ricochet_start_pos, const.clrBlack)
		
		
		if start_high then
			if not attack_args.prediction then
				--print("starting high")
			end
			local ipt_bounce = terrain.IntersectSegment(ricochet_start_pos, bounce_pos)
			if ipt_bounce then
				rat_printBounce("ipt bounce", ipt_bounce)
				bounce_pos = ipt_bounce--:SetTerrainZ()
			else
				local bounce_flags = const.efVisible + const.efCollision
				local closest_obj2, closest_pos2, closest_norm2 = GetClosestRayObj(ricochet_start_pos, bounce_pos, bounce_flags, 0, function(obj, x, y, z)
						local window = IsBreakableWindow(obj) or nil
						local water = IsKindOf(obj, "WaterPlane") or nil
						if obj:IsKindOf("SlabWallDoor") then
							if obj.pass_through_state == "open" then
								return false 
							end 
						elseif (window and speed > 3) then -- water or 
							return false
						end
						return true 
				end)
				rat_printBounce("closest_pos2", closest_pos2)
				bounce_pos = closest_pos2 or bounce_pos
			end
		end	
		
		--ricochet_start_pos =  ricochet_start_pos + SetLen(normal, adj * guic)
		 rat_printBounce("bounce angle", bounce_angle)

		DbgAddCircle_rat(attack_args, bounce_pos, const.SlabSizeX/2)
		local debug_speed_text = "num bounce: " .. bounces .. " speed :" .. speed
		DbgAddText_rat(attack_args, debug_speed_text, ricochet_start_pos, const.clrBlack)
		DbgAddVector_rat(attack_args, ricochet_start_pos, bounce_pos - ricochet_start_pos, const.clrWhite)
		rat_printBounce("bounce_pos", bounce_pos)

	


		local bounce_trajectory = self:GetTrajectory(attack_args, ricochet_start_pos, bounce_pos, mishap, true, bounce_angle)
		local last_time = trajectory[#trajectory].t
		

		
	
		-----------debug only
		if #bounce_trajectory > 0 then
			if #bounce_trajectory > 2 then
				DbgAddVector_rat(attack_args, bounce_trajectory[1].pos , (bounce_trajectory[3].pos - bounce_trajectory[1].pos)*1000 , const.clrPink)
			end
			DbgAddCircle_rat(attack_args, bounce_trajectory[1].pos, const.SlabSizeX/5, const.clrRed)
			DbgAddVector_rat(attack_args, bounce_trajectory[1].pos, bounce_trajectory[#bounce_trajectory].pos - bounce_trajectory[1].pos , const.clrPaleYellow)
		end
		
		
		
		
		local diminish = attack_args and ((attack_args.num_bounces+1)  * 0.05) or 0
		diminish = diminish +1 
		--print("diminish", diminish)
		-- local fun_allowed = true
		
		-- if fun_allowed then
			-- diminish = 0.3
		-- end

		for i, step in ipairs(bounce_trajectory) do
			step.obj = i == 1 and colide_obj or nil
			step.t = cRound(step.t * diminish) + last_time 

		end
		--
		for i, step in ipairs(bounce_trajectory) do
			table.insert(trajectory, step)
			DbgAddCircle_rat(attack_args, step.pos, const.SlabSizeX/10, const.clrPaleYellow)
		end
	end
	--DbgClear()
	return trajectory, bounce_pos, colide and 1 or false
end


function collision_obj_norm_pos(trajectory, attack_args, adj, traj_idx)
	local adj = adj or 500
	local normal, colide_obj, colide_obj_pos, terrain_material
	local bounce_flags = const.efVisible + const.efCollision
	local mishap = false
	local bounce_pos
	local trajectory_index = traj_idx or #trajectory-2
	--local trajectory_index = cRound(#trajectory/2)
	--local trajectory_index = #trajectory-2
	--print("traj idx", trajectory_index)
	for i = trajectory_index, #trajectory do
	-- for i, point in ipairs(trajectory) do
		-- if i >= trajectory_index then
			--local pos = point.pos
			local pos = trajectory[i].pos
			DbgAddCircle_rat(attack_args, pos, const.SlabSizeX/6, const.clrBlack)
			local posnext = trajectory[i + 1] and trajectory[i + 1].pos -- Next position, if exists
			
			if posnext then
			
			

			
			
				local dist1 = pos:Dist(posnext)
				local adj_dist1 = dist1 + adj * guic
				local ipt_posnext

				if dist1 > 0 then
					ipt_posnext = posnext + SetLen(posnext - pos, adj_dist1)
					ipt_posnext = IsValidZ(ipt_posnext) and ipt_posnext or ipt_posnext:SetTerrainZ()
				end
				
				--[[local water_terrain = terrain.IsWater(posnext)
				print("water_terrain", water_terrain)
				if  water_terrain then
					return false, false, false, false
				end]]
				

				--
			
				
				--ipt_posnext:SetZ(ipt_posnext:z() -10 *guic)
				
				-- if i == (#trajectory -1) then
					-- DbgAddCircle_rat(attack_args, ipt_posnext, const.SlabSizeX/2, const.clrGreen)
				-- end
				
				
				local ipt = terrain.IntersectSegment(pos, ipt_posnext or posnext)
				--print("ipt",attack_args.num_bounces, ipt)
				
				local closest_obj, closest_pos, closest_norm = GetClosestRayObj(pos, ipt or ipt_posnext or posnext, bounce_flags, 0, function(obj, x, y, z)
					local window = IsBreakableWindow(obj) or nil
					local water = IsKindOf(obj, "WaterPlane") or nil
					if obj:IsKindOf("SlabWallDoor") then
						if obj.pass_through_state == "open" then
							return false 
						end 
					if window then
						return false
					end
					-- elseif water or window then -- and speed > 3) then
						-- return false
					end
					return true 
				end)
		

				if closest_obj then
					
					normal = closest_norm
					colide_obj = closest_obj
					colide_obj_pos =  closest_pos
					break

				
				elseif ipt then
						DbgAddCircle_rat(attack_args, ipt_posnext, const.SlabSizeX/10, const.clrGreen)
						DbgAddCircle_rat(attack_args, ipt, const.SlabSizeX/10, const.clrBlue)
						colide_obj_pos = ipt
						rat_printBounce("ipt2", ipt)
						normal = terrain.GetTerrainNormal(ipt)
						rat_printBounce("terrain nomral", normal)
						colide_obj = "terrain"
						terrain_material = terrain.GetTerrainType(ipt)
						rat_printBounce("terrain mat", terrain_material)
						break
					
				end
			--end
		end
	end	
	
	return normal, colide_obj, colide_obj_pos, terrain_material
end


function get_throw_speed(trajectory, attack_args, lst_idx)	
	

	
	local speed 
	
	local trj_idx = lst_idx or 3
	if #trajectory > trj_idx then ---------------ADD GRAVITY
		local t_spd_idx = #trajectory - trj_idx
		
		
		local start_pos = trajectory[t_spd_idx].pos
		local start_time = trajectory[t_spd_idx].t
		local end_pos = trajectory[#trajectory].pos
		local end_time = trajectory[#trajectory].t
		
		local time_dif = end_time - start_time
		--print("speed calc time", attack_args.num_bounces, time_dif)
		if time_dif < 10*trj_idx then
			return false
		end
		
		local dist_sp = start_pos:Dist(end_pos)
		speed = dist_sp / (time_dif) 
		rat_printBounce("speed", speed)
		
		--local dist
		-- if start_pos and end_pos then
			-- dist = start_pos:Dist(end_pos)
		-- end
		--print("speed calc dist", attack_args.num_bounces, dist*1.00000/const.SlabSizeX, end_time - start_time)
	-- elseif #trajectory > 1 then
	
		-- start_pos = trajectory[1].pos
		-- start_time = trajectory[1].t
		-- end_pos = trajectory[#trajectory].pos
		-- end_time = trajectory[#trajectory].t
		
		-- dist_sp = start_pos:Dist(end_pos)
		-- speed = dist_sp / (end_time - start_time)
		
	end

	------------------------- average speed
	-- local total_speed = 0
	-- local num_speeds = 0
	-- local start_calc_index = #trajectory -1 -(lst_idx or 2) 
	-- local speed = 4
	-- local start_pos, start_time, end_pos, end_time, dist_sp
	
	-- if #trajectory >= start_calc_index then
	
		-- for i = start_calc_index, #trajectory-2 do
			-- start_pos = trajectory[i].pos
			-- start_time = trajectory[i].t
			-- end_pos = trajectory[#trajectory].pos
			-- end_time = trajectory[#trajectory].t
			-- if end_pos and end_time then 
                -- dist_sp = start_pos:Dist(end_pos)
                -- speed = dist_sp / (end_time - start_time)
                
                -- total_speed = total_speed + speed
                -- num_speeds = num_speeds + 1
            -- else
                -- break 
            -- end
		-- end
		
		-- speed = total_speed / num_speeds
		
	-- elseif #trajectory > 1 then
	
		-- start_pos = trajectory[1].pos
		-- start_time = trajectory[1].t
		-- end_pos = trajectory[#trajectory].pos
		-- end_time = trajectory[#trajectory].t
		
		-- dist_sp = start_pos:Dist(end_pos)
		-- speed = dist_sp / (end_time - start_time)
		
	-- end





	return speed
end
	
	
	
function get_bounces(grenade, trajectory, attack_args, explosion_pos)

			local max_bounces = 2
			local bounces = 0
			local bounce_pos
			
			
			
			-- for i, step in ipairs(trajectory) do
				-- print(i, "worter?", step.water)
				-- if step.water then
					-- DbgAddCircle(step.pos, const.SlabSizeX/2, const.clrRed)
				-- end
			-- end
			
			
			-- local col, pts = CollideSegmentsNearest(trajectory[#trajectory].pos, trajectory[#trajectory].pos:SetTerrainZ())
			
			-- print("col", col)


			
			while bounces <= max_bounces do
			
				local water_terrain = terrain.IsWater(trajectory[#trajectory].pos)
			
				if water_terrain then
					return trajectory, bounce_pos
				end
			
			
				attack_args.num_bounces = bounces
				local bounce_add
				trajectory, bounce_pos, bounce_add = ratonade_bounce(grenade, trajectory, attack_args, explosion_pos, bounces)	
				
				----collide test
				DbgAddCircle_collide_test(bounce_pos, const.SlabSizeX/6, const.clrRed)
				
				
				if not bounce_add then
					break
				end
				bounces = bounces + bounce_add
			end	
			
			return trajectory, bounce_pos
end