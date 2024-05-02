Landmine.original_UpdateTriggerRadiusFx = Landmine.UpdateTriggerRadiusFx -- landmine_original_UpdateTriggerRadiusFx

function Landmine:UpdateTriggerRadiusFx(delete)
	self:original_UpdateTriggerRadiusFx(delete)
	if self.ied_misfire_trap then
		DoneObject(self.trigger_radius_fx)
		self.trigger_radius_fx = false
	end
end

Landmine.rat_original_UpdateTimedExplosionFx = Landmine.UpdateTimedExplosionFx

function Landmine:UpdateTimedExplosionFx(addTime)
	self:rat_original_UpdateTimedExplosionFx(addTime)
	if self.ied_misfire_trap and self.timer_text and self.timer_text.ui and self.timer_text.ui.idText then
		-- DoneObject(self.timer_text)
		self.timer_text.ui.idText:SetVisible(false)
	end
end

Landmine.rat_original_TriggerTrap = Landmine.TriggerTrap

function Landmine:TriggerTrap(victim, attacker)
	local original_item = g_Classes[self.item_thrown]
	if original_item and original_item.is_ied and not self.ied_misfire_trap then
		local misfire = processIEDmisfire(original_item, attacker or self.attacker)
		if misfire then
			local original_fx_actor = self.fx_actor_class
			local att = self.attacker
			local faux_results = {
				explosion_pos = self:GetPos(),
			}
			self.done = true
			--[[ 			self.visible = false
			self:SetOpacity(0) ]]
			self:DestroyAttaches("GrenadeVisual")
			original_item:IED_trap_OnLand(attacker or att, faux_results, false, original_fx_actor)
			return
		end
	end

	if self.r_original_fx_actor and self.r_original_fx_actor ~= "" then
		self.fx_actor_class = self.r_original_fx_actor
	end

	self:rat_original_TriggerTrap(victim, attacker)
end

--[[ Trap.original_Explode = Trap.Explode

function Trap:Explode(victim, fx_actor, state, attacker)
	Inspect(self)
	self:original_Explode(victim, fx_actor, state, attacker)
end ]]
-- local voxelSizeX = const.SlabSizeX
--[[ function Landmine:UpdateTriggerRadiusFx(delete)

	local range = (self.triggerRadius or 0) * voxelSizeX / 2
	------
	if self.ied_misfire_trap then
		range = 0
	end
	-----
	if self.done or not self.visible or range == 0 or
						(self.TriggerType ~= "Proximity" and self.TriggerType ~= "Proximity-Timed") or delete or not self:IsValidPos() then
		if self.trigger_radius_fx then
			DoneObject(self.trigger_radius_fx)
			self.trigger_radius_fx = false
		end
		return
	end

	local origin = self:GetPos()
	local step_positions, step_objs, los_values = GetAOETiles(origin, "Standing", range)
	self.trigger_radius_fx = CreateAOETilesCylinder(step_positions, step_objs, self.trigger_radius_fx, origin, range,
	                                                los_values)
	self.trigger_radius_fx:SetColorFromTextStyle("MineRange")
	return true
end ]]

--[[ function Landmine:UpdateTimedExplosionFx(addTime)
	if not self.sector_init_called then
		return
	end
	if self.done or self.TriggerType ~= "Timed" or addTime == "delete" then
		if self.timer_text then
			self.timer_text:delete()
			self.timer_text = false
		end
		return
	end

	-------------
	if not self.ied_misfire_trap then
		--------- vanilla
		if not self.timer_text and not self.spawned_by_explosive_object then
			self.timer_text = CreateBadgeFromPreset("TrapTimerBadge", {
				target = self,
				spot = "Origin",
			})
			self.timer_text.ui.idText:SetVisible(true)
		end
		----------
	end
	--------------

	self.timer_passed = self.timer_passed or 0

	if addTime then
		self.timer_passed = self.timer_passed + addTime
	end

	local timePassed = self.timer_passed
	local timeToExplosion = self.TimedExplosiveTurns * Traps_CombatTurnToTime
	timeToExplosion = timeToExplosion - timePassed

	local bombIcon = T(173303509811, "<image UI/Hud/bomb> ")
	if g_Combat and self.timer_text then
		local turns = DivCeil(timeToExplosion, Traps_CombatTurnToTime)
		self.timer_text.ui.idText:SetText(bombIcon .. T {
			116423252311,
			"<turns> turn(s)",
			turns = turns,
		})
		if turns == 1 then
			local text = self.timer_text.ui.idText.Text
			self.timer_text.ui.idText:SetText(T {
				465158248448,
				"<red><text></red>",
				text = text,
			})
		end
	elseif self.timer_text then
		self.timer_text.ui.idText:SetText(bombIcon .. T {
			918858375439,
			"<secondsToExplore>",
			secondsToExplore = timeToExplosion / 1000,
		})
	end

	if timeToExplosion <= 0 or (g_Combat and timeToExplosion < 1000) then
		if g_Combat then
			self.toExplode = true
		else
			self:TriggerTrap()
		end
	end
end ]]

--[[ function Landmine:TriggerTrap(victim, attacker)
	local original_item = g_Classes[self.item_thrown]
	if original_item and original_item.is_ied and not self.ied_misfire_trap then
		local misfire = processIEDmisfire(original_item, attacker or self.attacker)
		if misfire then

			local att = self.attacker
			local faux_results = {
				explosion_pos = self:GetPos(),
			}
			self.done = true
			self:DestroyAttaches("GrenadeVisual")
			original_item:IED_trap_OnLand(attacker or att, faux_results)
			return
		end
	end

	if self.done then
		return
	end -- We need to check if exploded because overwatch logic (which triggers this) doesnt
	if IsSetpiecePlaying() then
		return
	end

	if self.TriggerType == "Proximity-Timed" then
		self:SetVisible(true)
		self.TriggerType = "Timed"
		self.triggerRadius = 0
		self:UpdateTimedExplosionFx()
		self:UpdateTriggerRadiusFx("delete")
		return
	end

	self:UpdateTriggerRadiusFx("delete")
	self:UpdateTimedExplosionFx("delete")
	if #(self.GrenadeExplosion or "") > 0 then
		print("explode as grenade")
		self:ExplodeAsGrenade(victim, self.fx_actor_class, nil, attacker)
	else
		print("explode")
		self:Explode(victim, self.fx_actor_class, nil, attacker)
	end
	self:SetVisible(false)
end

function Trap:TriggerTrap(victim, attacker)
	print("-----------trap trigger")
	self:Explode(victim, nil, nil, attacker)
end

function Trap:Explode(victim, fx_actor, state, attacker)
	self.victim = victim
	self.done = true
	ObjModified("combat_bar_traps")

	-- Track who exploded the trap and handle chain explosions
	self.attacker = IsKindOf(attacker, "Trap") and attacker.attacker or attacker

	local trapName = self:GetTrapDisplayName()
	local pos = self:GetPos()
	local proj = PlaceObject("FXGrenade")
	proj.fx_actor_class = fx_actor or "Landmine"
	proj:SetPos(pos)
	proj:SetOrientation(self:GetOrientation())

	-- Check if dud
	local rand = InteractionRand(100)
	if rand > DifficultyToNumber(self.triggerChance) then
		self.discovered_trap = true
		self.dud = true
		CombatLog("important", T {
			536546697372,
			"<TrapName> was a dud.",
			TrapName = trapName,
		})
		CreateFloatingText(self:GetVisualPos(), T {
			372675206288,
			"<TrapName> was <em>a dud</em>",
			TrapName = trapName,
		}, "BanterFloatingText")
		PlayFX("Explosion", "failed", self)
		DoneObject(proj)
		return
	end

	if IsKindOf(self, "ContainerMarker") and not self:GetItemInSlot("Inventory", "QuestItem") then
		self.enabled = false
		self:UpdateHighlight()
	end

	state = state or "explode"
	CreateGameTimeThread(function()
		-- Moved ExplosionDamage and DoneObject here, so that if the current thread is the unit's that attempting the disarm
		-- it will still clean up the object.
		local isOnGround = true
		if self.spawned_by_explosive_object then
			isOnGround = IsOnGround(self.spawned_by_explosive_object)
		end
		ExplosionDamage(self, self, pos, proj, "fly_off", not isOnGround)
		DoneObject(proj)
		if state ~= "explode" then
			Sleep(50)
		end
		if self:HasState(state) then
			self:SetState(state)
		end
	end)

	if not self.spawned_by_explosive_object then
		-- Exploded
		CombatLog("important", T {
			811751960646,
			"<TrapName> <em>detonated</em>!",
			TrapName = trapName,
		})
		CreateFloatingText(self:GetVisualPos(), T {
			463301911995,
			"<TrapName> <em>explodes</em>!",
			TrapName = trapName,
		}, "BanterFloatingText")
	end
end
 ]]
