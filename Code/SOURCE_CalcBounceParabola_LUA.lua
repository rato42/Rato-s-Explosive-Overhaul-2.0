
--[[function CalcBounceParabolaTrajectory(start_pt, launch_speed, gravity, time, tStep, max_bounces, diminish, no_collision)
	local t = 0	
	local pos = start_pt
	local v = launch_speed
	local vg = point(0, 0, -(gravity or const.Combat.Gravity))
	local trajectory = {}
	local bounce_flags = const.efVisible + const.efCollision

	if not v:IsValidZ() then
		v = v:SetZ(0)
	end

	while terrain.IsPointInBounds(pos) and pos:z() >= terrain.GetHeight(pos) do
		table.insert(trajectory, { pos = pos, t = t })

		t = t + tStep
		local vnext = v + MulDivRound(vg, tStep, 1000)
		local posnext = pos + MulDivRound(vnext, tStep, 1000)
		local hit_water

		local function bounce(pt, normal, obj)
			if hit_water then 
				return 
			end
			
			if normal == point30 then
				normal = axis_z
			end
			local len = Dot(normal, v) / normal:Len()
			-- reflect the velocity vector
			local proj = SetLen(normal, len)
			local velocity = vnext:Len()
			vnext = SetLen(vnext - (2 * proj), velocity)
			if diminish then
				vnext = MulDivRound(vnext, diminish, 100)
			end

			-- correct the position
			local move_dist = posnext:Dist(pos)
			local hit_dist = pos:Dist(pt)
			local refl_dist = move_dist - hit_dist
			if refl_dist > 0 and vnext ~= point30 then
				table.insert(trajectory, {pos = pt, t = t - tStep + MulDivRound(tStep, hit_dist, move_dist), obj = obj, bounce = true})
				pos = pt
				posnext = pt + SetLen(vnext, refl_dist)
			end
			max_bounces = max_bounces - 1
		end

		-- window detection
		local ipt = terrain.IntersectSegment(pos, posnext)
		if not no_collision then
			local obj, pt, normal = GetClosestRayObj(pos, ipt or posnext, bounce_flags, 0, function(obj, x, y, z)
				local window = IsBreakableWindow(obj) or nil
				local water = IsKindOf(obj, "WaterPlane") or nil
				if window or water then
					local pt = point(x, y, z)
					local move_dist = posnext:Dist(pos)
					local hit_dist = pos:Dist(pt)
					if hit_dist > 0 and move_dist > 0 and vnext ~= point30 then
						local time = t - tStep + MulDivRound(tStep, hit_dist, move_dist)
						local step = { pos = pt, t = time, obj = obj }
						if window then
							step.window = true
						end
						if water then
							hit_water = #trajectory
							step.water = true
						end
						table.insert(trajectory, step)
						pos = pt
						posnext = pt + SetLen(vnext, hit_dist)
						t = time + tStep
					end
					return false
				end
				return true
			end, 0, const.cmDefaultObject)
			if obj and (not obj:IsKindOf("SlabWallDoor") or obj:IsDead() or obj.pass_through_state ~= "open") then				
				bounce(pt, normal, obj)
				if t >= time or max_bounces < 0 then
					-- end before collision pos to avoid detonating inside collision geometry
					local dist = pos:Dist(pt)
					local adj_dist = dist - 10*guic
					if adj_dist <= 0 then
						break
					end
					local end_pt = pos + SetLen(pt - pos, adj_dist)
					local time = t - tStep + MulDivRound(tStep, adj_dist, dist)
					table.insert(trajectory, { pos = end_pt, obj = obj, t = time })
					break
				end
			end
		end

		if ipt then
			bounce(ipt, terrain.GetTerrainNormal(ipt), "terrain")
			if max_bounces < 0 or t >= time then
				break
			end
		end

		pos, v = posnext, vnext
	end

	-- before returning make sure the trajectory stays above ground & has contents
	if #trajectory == 0 then
		table.insert(trajectory, { pos = start_pt, t = 0 })
	end
	if #trajectory == 1 then
		table.insert(trajectory, { pos = start_pt + SetLen(launch_speed, 10*guic), t = 1 })
	end
	
	for _, step in ipairs(trajectory) do
		if step.pos:z() < terrain.GetHeight(step.pos) then
			step.pos = step.pos:SetTerrainZ()
		end
	end
	
	return trajectory
end]]

