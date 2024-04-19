function AnimateThrowTrajectory(visual_obj, trajectory, rotation_axis, rpm, surf_fx, explosion_fx)
	

	local time = trajectory[#trajectory].t
	local angle = MulDivTrunc(rpm * 360, time, 1000)
	local hit_water

	if rpm ~= 0 then
		visual_obj:SetAxis(rotation_axis)
	end

	local t = 0
	local pos, dir
	
	----
	local bounced
	----
	
	
	for i, step in ipairs(trajectory) do
		local step_time = step.t - t
		local dist = pos and step.pos:Dist(pos) or 0
		if dist > 0 then
			dir = step.pos - pos
			--[[if i == 1 and step_time == 0 then
				local idx = i
				local dt, d = 0, 0
				while dt <= 0 or d <= 0 do
					idx = idx + 1
					d = trajectory[idx].pos:Dist(trajectory[i].pos)
					dt = trajectory[idx].t - trajectory[i].t
				end
				step_time = MulDivRound(dt, dist, d)
			end--]]
		end

		step_time = Max(0, step_time)
		pos = step.pos
		visual_obj:SetPos(pos, step_time)
		local st = 0
		while st < step_time do
			local dt = Min(20, step_time - st)
			if rpm ~= 0 then
				visual_obj:SetAngle(visual_obj:GetAngle() + MulDivTrunc(angle, dt, time), dt)
			end
			st = st + dt
			Sleep(dt)
		end
		t = step.t
		local obj = IsValid(step.obj) and step.obj or nil
		
		----------
		if obj then 
			bounced = true
		end
		----------
		
		if IsBreakableWindow(obj) then
			obj:SetWindowState("broken")
			obj = nil
		end
		if surf_fx and not hit_water and (obj or i == #trajectory or step.bounce) then
			local surf_fx_type = GetObjMaterial(pos, obj)
			local fx_target = surf_fx_type or obj
			PlayFX(surf_fx, "start", visual_obj, fx_target, pos)
		end
		if step.water then
			hit_water = true
		end
	end

	------------------------
	--local visu_obj_pos = visual_obj:GetPos()
	
	if not bounced then
		------------- vanilla
		visual_obj:SetAxis(axis_z)
		visual_obj:SetAngle(dir and dir:Len2D() > 0 and CalcOrientation(dir) or 0)
		-----------------------
	end
	
	-----------------------
	
	

	if explosion_fx then
		local pos = GetExplosionFXPos(visual_obj)
		local surf_fx_type = GetObjMaterial(pos)
		dir = dir and dir:SetZ(0)
		if dir and dir:Len() > 0 then
			dir = SetLen(dir, 4096)
		else
			dir = axis_z
		end
		PlayFX(explosion_fx, "start", visual_obj, surf_fx_type, pos, dir)
	end
	Msg("GrenadeDoneThrow")
end