function Unit:ThrowGrenade(action_id, cost_ap, args)
	local stealth_attack = not not self:HasStatusEffect("Hidden")
	local target_pos = args.target
	if self.stance ~= "Standing" then
		self:ChangeStance(nil, nil, "Standing")
	end
	local action = CombatActions[action_id]
	self:ProvokeOpportunityAttacks(action, "attack interrupt")
	local grenade = action:GetAttackWeapons(self)
	args.prediction = false -- mishap needs to happen now
	local results, attack_args = action:GetActionResults(self, args) -- early check for PrepareToAttack
	self:PrepareToAttack(attack_args, results)
	self:UpdateAttachedWeapons()
	self:ProvokeOpportunityAttacks(action, "attack interrupt")
	self:EndInterruptableMovement()

	-- camera effects
	if not attack_args.opportunity_attack_type == "Retaliation" then
		if g_Combat and IsEnemyKill(self, results) then
			g_Combat:CheckPendingEnd(results.killed_units)
			local isKillCinematic, dontPlayForLocalPlayer = IsEnemyKillCinematic(self, results, attack_args)
			if isKillCinematic then
				cameraTac.SetForceMaxZoom(false)
				SetAutoRemoveActionCamera(self, results.killed_units[1], nil, nil, nil, nil, nil, dontPlayForLocalPlayer)
			end
		end
	end

	self:RemoveStatusEffect("FirstThrow")

	-- multi-throw support
	local attacks = results.attacks or {results}
	local ap = (cost_ap and cost_ap > 0) and cost_ap or action:GetAPCost(self, attack_args)
	table.insert(g_CurrentAttackActions, { action = action, cost_ap = ap, attack_args = attack_args, results = results })

	self:PushDestructor(function(self)
		self:ForEachAttach("GrenadeVisual", DoneObject)
		table.remove(g_CurrentAttackActions)
		self.last_attack_session_id = false
		local dlg = GetInGameInterfaceModeDlg()
		if dlg and dlg:HasMember("dont_return_camera_on_close") then
			dlg.dont_return_camera_on_close = true
		end
	end)

	Msg("ThrowGrenade", self, grenade, #attacks)
	-- throw anim
	
	------------------------
	
	
	
	if results.mishap then
		self:SetState("gr_Standing_Aim", const.eKeepComponentTargets)
	else
		self:SetState("gr_Standing_Attack", const.eKeepComponentTargets)
		
	end
   ------------------------
	-- pre-create visual objs and play activate fx 
	local visual_objs = {}
	for i = 1, #attacks do
		local visual_obj = grenade:GetVisualObj(self, i > 1)
		visual_objs[i] = visual_obj
		PlayFX("GrenadeActivate", "start", visual_obj)
	end
	
	----
	local mishap_explo_pos 
	if results.mishap then
		mishap_explo_pos = visual_objs[1]:GetVisualPos()
		--DbgAddCircle(visual_objs[1]:GetVisualPos())
	end
	----
	local mishap = results.mishap
	
	local time_to_hit = self:TimeToMoment(1, "hit") or 20
	self:Face(target_pos, time_to_hit/2)
	Sleep(time_to_hit)


	----
	-- if results.mishap_pos then
		-- target_pos = results.mishap_pos
		
	-- end
	-----

	if results.miss or not results.killed_units or not (#results.killed_units > 1) then
		local specialNadeVr = table.find(SpecialGrenades, grenade.class) and (IsMerc(self) and "SpecialThrowGrenade" or "AIThrowGrenadeSpecial")
		local standardNadeVr = IsMerc(self) and "ThrowGrenade" or "AIThrowGrenade"
		PlayVoiceResponse(self, specialNadeVr or standardNadeVr)
	end

	local thread = CreateGameTimeThread(function()
		-- create visuals and start anim thread for each throw
		local threads = {}
		-----
		if not results.mishap or IsKindOf(grenade, "Molotov") then
			for i, attack in ipairs(attacks) do
				visual_objs[i]:Detach()
				visual_objs[i]:SetHierarchyEnumFlags(const.efVisible)
				local trajectory = attack.trajectory
				if #trajectory > 0 then
					local rpm_range = const.Combat.GrenadeMaxRPM - const.Combat.GrenadeMinRPM
					local rpm = const.Combat.GrenadeMinRPM + self:Random(rpm_range)
					local rotation_axis = RotateAxis(axis_x, axis_z, CalcOrientation(trajectory[2].pos, trajectory[1].pos))
					threads[i] = CreateGameTimeThread(AnimateThrowTrajectory, visual_objs[i], trajectory, rotation_axis, rpm, "GrenadeDrop")
				else
					-- try to find a fall down pos
					threads[i] = CreateGameTimeThread(ItemFallDown, visual_objs[i])
				end
			end
		end
		
		----
		grenade:OnThrow(self, visual_objs)
		
		-- wait until all threads are done
		while #threads > 0 do
			Sleep(25)
			for i = #threads, 1, -1 do
				if not IsValidThread(threads[i]) then
					table.remove(threads, i)
				end
			end
		end
		-- real check when the grenade(s) landed must use the current position(s)
		if #attacks > 1 then
			args.explosion_pos = {}
			for i, res in ipairs(attacks) do
				args.explosion_pos[i] = res.explosion_pos or visual_objs[i]:GetVisualPos()
			end
		else
			args.explosion_pos = results.explosion_pos or visual_objs[1]:GetVisualPos()
		end
		
		----
		if results.mishap then
			args.explosion_pos = mishap_explo_pos
			--rat_printGR(args.explosion_pos)
		end
		---
		
		--IsKindOf( grenade, "Molotov") and args.explosion_pos
		
		results, attack_args = action:GetActionResults(self, args) 
		local attacks = results.attacks or {results}
		
		---- check mishap for all attacks FIX
		if mishap then 
			for i, attack in ipairs(attacks) do
				attack.mishap = true
			end
		end
		---	
		
		results.attack_from_stealth = stealth_attack
		
		-- needs to be after GetActionResults
		local destroy_grenade
		if not self.infinite_ammo then
			grenade.Amount = grenade.Amount - #attacks
			destroy_grenade = grenade.Amount <= 0
			if destroy_grenade then
				local slot = self:GetItemSlot(grenade)
				self:RemoveItem(slot, grenade)
			end
			ObjModified(self)
		end
		
		self:AttackReveal(action, attack_args, results)

		self:OnAttack(action_id, nil, results, attack_args)
		LogAttack(action, attack_args, results)
		for i, attack in ipairs(attacks) do
			----
			-- if mishap and IsKindOf(grenade, "ThrowableTrapItem") then
				-- Grenade.OnLand(grenade, self, attack, visual_objs[i])
			-- else
				------
				grenade:OnLand(self, attack, visual_objs[i])
				----
			--end
			---
		end
		if destroy_grenade then
			DoneObject(grenade)
		end
		AttackReaction(action, attack_args, results)
		Msg(CurrentThread())
	end)
		---
	-- if mishap and IsKindOf(grenade, "ThrowableTrapItem") then
		-- grenade:TriggerTrap(self, self)
	-- end

	Sleep(self:TimeToAnimEnd())
	self:SetRandomAnim(self:GetIdleBaseAnim())
	if IsValidThread(thread) then
		WaitMsg(thread)
	end
	

	-- if mishap then
		-- self:SetCommand("KnockDown")
	-- end
	----
	self:ProvokeOpportunityAttacks(action, "attack reaction")
	self:PopAndCallDestructor()
end


function DT_results_place()
	CombatActions.DoubleTossA.GetActionResults = function (self, unit, args)
		local grenade = self:GetAttackWeapons(unit)
		local target = ResolveGrenadeTargetPos(args.target)
		if not target or not grenade then
			return {}
		end
		
		-- get target_offset from DoubleTossA always (the function can be called for other actions)
		local target_offset = CombatActions.DoubleTossA:ResolveValue("target_offset")
		local offset = MulDivRound(grenade.AreaOfEffect * const.SlabSizeX, target_offset, 100)
		if grenade.coneShaped then
			offset = offset / DivRound(360, grenade.coneAngle)
		end
		local offset_dir = RotateRadius(offset, CalcOrientation(args.step_pos or unit, target) + 90*60)
		
		local args_arr = {}
		args_arr[1] = table.copy(args)
		args_arr[2] = table.copy(args)
		args_arr[1].target = target + offset_dir
		args_arr[2].target = target - offset_dir
		if args.explosion_pos then
			args_arr[1].explosion_pos = args.explosion_pos[1]
			args_arr[2].explosion_pos = args.explosion_pos[2]
		end
		
		local attacks = {}
		for i = 1, 2 do
			local results, attack_args = CombatActions.ThrowGrenadeA.GetActionResults(self, unit, args_arr[i])
			attacks[i] = results
			attacks[i].attack_args = attack_args
		end
		
		local results = MergeAttacks(attacks)
		return results, attacks[1].attack_args
	end
end