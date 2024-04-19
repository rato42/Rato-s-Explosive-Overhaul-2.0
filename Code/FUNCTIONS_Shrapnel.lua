	
	function Grenade:GetShrapnelResults(attackResults, attacker)
	-----------------
		local num_shrap = self.r_shrap_num or 0

		if num_shrap < 1 then
			return
		end

		local explosion_pos = attackResults.explosion_pos
		explosion_pos = IsValidZ(explosion_pos) and explosion_pos or explosion_pos:SetTerrainZ()
		--explosion_pos = explosion_pos:SetZ(explosion_pos:SetTerrainZ():z()+ guim)
		explosion_pos = explosion_pos:SetZ(explosion_pos:z() + guic)
		local radius = 50000
		
		local att_pos = attacker:GetPos() or attacker
		att_pos = IsValidZ(att_pos) and att_pos or att_pos:SetTerrainZ()


		local cone_args = {cone_shape = false}
		if self.coneShaped then
			local direction = RotateRadius(self.AreaOfEffect*const.SlabSizeX
			,CalcOrientation(att_pos or attacker, explosion_pos), explosion_pos)

			direction = IsValidZ(direction) and direction or direction:SetTerrainZ()
			local direction_angle = CalcOrientation(explosion_pos, direction)

			cone_args = 
				{cone_shape = true,
				cone_angle = self.coneAngle,
				cone_direction = direction,
				cone_dir_angle = direction_angle,
				cone_radius = self.AreaOfEffect*const.SlabSizeX,
				}
			--adjusted_cone_angle = findAngleAtRadius(self.coneAngle*60,(self.AreaOfEffect or 0) * const.SlabSizeX, radius)
		end


		local shrapnels, phis = generateShrapnelPositions(num_shrap, radius, explosion_pos,cone_args)

		-- local shrapnels = get_shrapnels(explosion_pos, radius, 45)
		-- Inspect(shrapnels)
		
		for i, v in ipairs(shrapnels) do
			DbgAddCircle(v, const.SlabSizeX/6)
			DbgAddText(phis[i], v)
			
		end
		
		for i, unit in ipairs(g_Units) do
			unit.shrap_received = 0
		end
		
		
		local final_pos

		-- attacker:SetPos(explosion_pos)--thrower:SetPos(explosion_pos)
		local sharpnel_weapon = g_Classes["weapon_shrapnel"]
		local lof_args = {}
		lof_args.fire_relative_point_attack = false
		lof_args.ignore_colliders = false--compile_ignore_colliders(killed_colliders, target_unit)
		lof_args.seed = attacker:Random()
		lof_args.ignore_los = true
		lof_args.inside_attack_area_check = false
		lof_args.forced_hit_on_eye_contact = false
		
		---
		lof_args.prediction = false
		lof_args.aimIK = false
		lof_args.output_collisions = true
		lof_args.force_hit_seen_target = not config.DisableForcedHitSeenTarget
		---
		lof_args.weapon = sharpnel_weapon
		lof_args.weapon_visual = self:GetVisualObj(attacker)
		lof_args.action_id = "SingleShot"
		lof_args.obj = attacker
		lof_args.step_pos = explosion_pos
		lof_args.can_stuck_on_unit = true
		
		---
		lof_args.attack_pos = explosion_pos--ricochet_start_pos + SetLen(ricochet_dir, guic) -- get away from the collision
		lof_args.target_pos = final_pos
		lof_args.fire_relative_point_attack = false
		lof_args.clamp_to_target = true
		lof_args.extend_shot_start_to_attacker = false
		lof_args.can_hit_attacker = true
		lof_args.ignore_los = true
		lof_args.inside_attack_area_check = false
		lof_args.forced_hit_on_eye_contact = false
		lof_args.penetration_class = -1 -- stuck on the first hit
		lof_args.max_penetration_range = -1
		lof_args.can_use_covers = false
		lof_args.emplacement_weapon = false
		--lof_args.ricochet = true
		-------
		--local attack_data = GetLoFData(attacker, final_pos, lof_args)
		
		----
		
		-- local new_shrapnel = {}
		
		-- for i, v in ipairs(shrapnels) do
			-- if v:z() >= explosion_pos:z() then
				-- table.insert(new_shrapnel, v)
			-- end
		-- end
		-- shrapnels = new_shrapnel
		
		local coroutines ={}
		
		local end_time_g = GameTime()
		--print("main gtime", end_time_g)
		local function Shrapnel_Coroutine(Firearm, attacker, start_pt, end_pt, dir, speed, hits, target, attack_args)
			return coroutine.create(function()
				local thread = CreateGameTimeThread(Firearm.Shrapnel_Fly, Firearm, attacker, start_pt, end_pt, dir, speed, hits, target, attack_args, end_time_g)
				-- while IsValid(thread) do
					-- coroutine:y()ield()
				-- end
			end)
		end
	
		local dmg_log = {}
		
		
		local gren_random = 30
		
		for i, vector in ipairs(shrapnels) do
			final_pos = vector 
			
			lof_args.target_pos = final_pos
			--if IsValidZ(final_pos) then
			
				lof_args.attack_pos = explosion_pos + SetLen(final_pos - explosion_pos, guic*12)
			
				
			
			
				local random_f = 100-cRound(gren_random/2) + attacker:Random(gren_random)
			
				local attack_data = CheckLOF(final_pos, lof_args)
				
				local lof, hit, hit_pos
				
				local max_shrap_received
				if attack_data then
					lof = attack_data.lof and attack_data.lof[1]
					hit = lof and lof.hits and lof.hits[1] 
					hit_pos = hit and hit.pos
					
	
					
					local max_shrap = 6
					if hit and hit.obj and IsKindOf(hit.obj, "Unit")  then
						if hit.obj.shrap_received > max_shrap then
							max_shrap_received = true
							lof_args.attack_pos = hit_pos + SetLen(hit_pos - lof_args.attack_pos, cRound(const.SlabSizeX/3))
							attack_data = CheckLOF(final_pos, lof_args)
							lof = attack_data.lof and attack_data.lof[1]
							hit = lof and lof.hits and lof.hits[1] 
							hit_pos = hit and hit.pos
						else
							hit.obj.shrap_received = hit.obj.shrap_received + 1
						end
					end
				end
				
				if attack_data then
					lof = attack_data.lof and attack_data.lof[1]
					hit = lof and lof.hits and lof.hits[1] 
					hit_pos = hit and hit.pos
					
					--print("hit print", hit.obj)
					--
					
					
					local exclude_civ
					if hit and not hit.terrain then
	
						local hit_data = {
						obj = attacker,
						hits = {hit},
						target_pos = hit_pos,
						attack_pos = lof_args.attack_pos
						}
						
						local base_radius = self.AreaOfEffect * const.SlabSizeX
			
						local dist_ = hit_data.target_pos:Dist(hit_data.attack_pos)
						local outer_radius_t = 30
						local dist_t = dist_ <= base_radius and 100 or 
									dist_ <= cRound(base_radius*1.5) and 70 or 
									outer_radius_t
						
						
						
						if IsKindOf(hit.obj, "Unit") and hit.obj:IsCivilian() and dist_t < outer_radius_t then-- and hit.obj.session_id == "Ivan" and hit.spot_group == "Head" then
							exclude_civ = true
						else
							sharpnel_weapon:calc_shrap_damage(hit_data, false, random_f, dist_t)
							if IsKindOf(hit.obj, "Unit") then
							
							
							
								
							
								if not dmg_log[hit.obj.session_id] then
									dmg_log[hit.obj.session_id] = {dmg = 0}
								end
								
								dmg_log[hit.obj.session_id].dmg = dmg_log[hit.obj.session_id].dmg + hit.damage
								table.insert_unique(dmg_log[hit.obj.session_id], hit.spot_group)
								-- print("------------------------------------")
								-- print("dist_T", dist_t)
								-- print("hit obj", hit.obj.session_id)
								-- print("dmg", hit.spot_group, hit.damage)
								-- print("hit effects", hit.effects)
								-- print("------------------------------------")
							end
						end
						
	
					end
					
					local hits = not exclude_civ and {hit} or {}
					hit_pos = not exclude_civ and hit_pos or final_pos
					----
					
					--print(i, "sharp pos", vector)
					--print("main gtime", end_time_g)
					local sharpnel_dir = SetLen((hit_pos or final_pos) - explosion_pos,4096)--dir--false--hit_pos - explosion_pos--) or dir
					if max_shrap_received then
						DbgAddVector(lof_args.attack_pos, hit_pos - lof_args.attack_pos, const.clrBlue)
					end
					-- if hit then
						-- DbgAddVector(lof_args.attack_pos, hit_pos - lof_args.attack_pos, const.clrRed)
						
					-- else
						-- DbgAddVector(lof_args.attack_pos, final_pos - lof_args.attack_pos)
					-- end	
					
					
					
					local speed = MulDivRound(const.Combat.BulletVelocity*0.65, random_f, 100)--/10
					speed = speed/20
					
					local co = Shrapnel_Coroutine(sharpnel_weapon,attacker, explosion_pos, hit_pos or final_pos, sharpnel_dir, speed, hits or false, hit_pos or final_pos, lof_args, end_time_g)
					table.insert(coroutines, co)
				end
			--end
		end
		
		
		for k, v in pairs(dmg_log) do
			print(k,v)
		end
		
		for _, co in ipairs(coroutines) do
			coroutine.resume(co)
		end
		
	end
	
	--function Grenade:spawn_shrapnel(explosion_pos, attacker
	
	
	function Firearm:calc_shrap_damage(hit_data, ricochet_idx, random_f, dist_t)
		-- if not hit_data.prediction then
		-- Inspect(hit_data)
		-- end
		
		local attacker = hit_data.obj
		local target = hit_data.target
		local action = CombatActions[hit_data.action_id]
		local hits = hit_data.hits
		local record_breakdown = hit_data.record_breakdown
		local prediction = hit_data.prediction
	
	
		--------------------------
		
		local effect_chance = cRound(dist_t * random_f/350.00)
	
		--print("distt", dist_t, "effc", effect_chance)
		--------------------------
	
		if not ricochet_idx then
			local dmg_mod = hit_data.damage_bonus or 0
			if type(dmg_mod) == "table" then
				dmg_mod = dmg_mod[obj]
			end
			if record_breakdown and dmg_mod then
				local name = action and action:GetActionDisplayName({attacker}) or T(328963668848, "Base")
				table.insert(record_breakdown, { name = name, value = dmg_mod })
			end
			---
			local basedmg = self.Damage--attacker:GetBaseDamage(self, target, record_breakdown)
			---
			local dmg = MulDivRound(basedmg, Max(0, 100 + (dmg_mod or 0)), 100)
			-- if not prediction then
				-- dmg = RandomizeWeaponDamage(dmg)
			-- end
			
			dmg = MulDivRound(dmg, random_f, 100)
			dmg = MulDivRound(dmg, dist_t, 100)
			hit_data.damage = dmg
		end
		local target_reached
		local forced_target_hit = hit_data.forced_target_hit
		local impact_force = self:GetImpactForce()
	
		for idx = ricochet_idx or 1, hits and #hits or 0 do
			local hit = hits[idx]
			local stray = hit.stray
			local dmg = hit_data.damage
			local obj = hit.obj
			local is_unit
			if obj and IsKindOf(obj, "Unit") and not stray then
				is_unit = true
				stray = obj ~= target
				target_reached = target_reached or target and obj == target
	
				if not prediction then
					if hit_data.critical == nil and not stray then
						hit_data.target_spot_group =	hit_data.target_spot_group or hit.spot_group
						-- pass hit_data instead of attack_args, it has all the relevant data
						local critChance = attacker:CalcCritChance(self, target, action, hit_data, hit_data.step_pos)--hit_data.aim, hit_data.step_pos, hit_data.target_spot_group or hit.spot_group, action)
						local critRoll = attacker:Random(100)
						hit_data.critical = critRoll < critChance
					end
				end
				if not stray then
					hit.spot_group = hit_data.target_spot_group or hit.spot_group
				end
			end -- hits on non-units are never stray or critical
	
			hit.stray = stray
			hit.critical = not stray and hit_data.critical
			hit.damage = dmg
	
			local breakdown = obj == target and record_breakdown -- We only care about the damage breakdown on the target, not objects in the way.
			
			---
			self:shrap_precalc_damage_and_effects(attacker, obj, hit_data.step_pos, hit.damage, hit, hit_data.applied_status, hit_data, breakdown, action, prediction, effect_chance)
			---
			hit.impact_force = hit.damage > 0 and impact_force + self:GetDistanceImpactForce(hit.distance) or 0
	
			if idx < #hits and (hit.armor_prevented or 0) > 0 and not hit.ignored then
				if not forced_target_hit or target_reached then
					local penetrated = false
					if is_unit and (not target or target_reached) then
						for item, degrade in pairs(hit.armor_decay) do
							if hit.armor_pen[item] then
								penetrated = true
								break
							end
						end
					end
					if not penetrated and not hit.ricochet then
						-- remove the rest of the hits
						for i = idx + 1, #hits do
							hits[i] = nil
						end
						hit_data.stuck_pos = hit.pos -- adjust the final impact pos of the bullet
						if hit_data.target_hit_idx and hit_data.target_hit_idx > idx then
							hit_data.target_hit_idx = nil
							hit_data.stuck = true
						end
						break
					end
				end
			end
		end
	end
	
	
	
	function BaseWeapon:shrap_precalc_damage_and_effects(attacker, target, attack_pos, damage, hit, effect, attack_args, record_breakdown, action, prediction, effect_chance)
		if IsKindOf(target, "Unit") then
			local effects = EffectsTable(effect)--EffectsTable("Bleeding")
			--print("effects", effects)
			
			-----------------------------
			local effect_roll = 1 + attacker:Random(100)
			
			if effect_roll <= cRound(effect_chance * 1.2) then
				EffectTableAdd(effects, "Bleeding")
			end
			
			local other_effects_add = effect_roll <= effect_chance
			------------------------------
	
			-- local ignoreGrazing = IsFullyAimedAttack(attack_args) and self:HasComponent("IgnoreGrazingHitsWhenFullyAimed")
			-- local ignore_cover = (hit.aoe or hit.melee_attack or ignoreGrazing) and 100 or self.IgnoreCoverReduction
			
			--grazing hits
			-- local chance = 0
			-- local base_chance = 0
			--cover effect based on attack_pos
			-- if target:IsAware() and not target:HasStatusEffect("Exposed") and target:HasStatusEffect("Protected") and (not ignore_cover or ignore_cover <= 0) then
				-- local cover, any, coverage = target:GetCoverPercentage(attack_pos)
				-- base_chance = const.Combat.GrazingChanceInCover
				-- if target:HasStatusEffect("Protected") then
					-- base_chance = Protected:ResolveValue("base_chance")
				-- end
				-- chance = InterpolateCoverEffect(coverage, base_chance, 0)
				-- hit.grazing_reason = "cover"
			-- end
	
			-- if not ignoreGrazing and not hit.aoe then
				-- if target:IsConcealedFrom(attack_pos or attacker) then
					-- chance = chance + const.EnvEffects.FogGrazeChance
					-- hit.grazing_reason = "fog"
				-- end
				-- if target:IsObscuredFrom(attack_pos or attacker) then
					-- chance = chance + const.EnvEffects.DustStormGrazeChance
					-- hit.grazing_reason = "duststorm"
				-- end
			-- end		
			
			-- if not prediction then
				-- local grazing_roll = target:Random(100)
				-- if grazing_roll < chance then
					-- hit.grazing = true
				-- else
					-- hit.grazing_reason = false
				-- end
			-- elseif chance ~= 0 then
				-- hit.grazing = true
			-- end
			-- grazing hits (from cover and gas) cant crit
			-- if hit.grazing then
				-- hit.critical = nil
			-- end
			-- local ignore_armor = hit.aoe or IsKindOf(self, "MeleeWeapon")
			-- Order/method of damage buff calculations might need a revision. The are quite a few now and they seem to be added arbitrary.
			--if not hit.stray or hit.aoe then
			local ignore_armor = false
				local data = {
					breakdown = record_breakdown or {},
					effects = {},
					base_damage = damage,
					damage_add = 0,
					damage_percent = 100,
					ignore_armor = false,
					ignore_body_part_damage = {},
					action_id = "shrapnel_action",	
					weapon = self,
					prediction = false,
					critical = false,
					critical_damage = const.Weapons.CriticalDamage,
				}
				local mod_attack_args = attack_args or {}
				local mod_hit_data = hit or {}
				local action_id = "shrapnel_action"
				Msg("GatherDamageModifications", attacker, target, action_id, self, mod_attack_args, mod_hit_data, data) -- only called for non-stray hits (no misses)
				if IsKindOf(attacker, "Unit") then
					attacker:CallReactions("OnCalcDamageAndEffects", attacker, target, action, self, mod_attack_args, mod_hit_data, data)
				end
				if IsKindOf(target, "Unit") then
					target:CallReactions("OnCalcDamageAndEffects", attacker, target, action, self, mod_attack_args, mod_hit_data, data)
				end
				damage = Max(0, MulDivRound(data.base_damage + data.damage_add, data.damage_percent, 100))
				if data.critical then
					damage = Max(0, MulDivRound(damage, 100 + data.critical_damage, 100))
				end
				hit.critical = data.critical
				for _, effect in ipairs(data.effects) do
					------------------------
					if other_effects_add then
						EffectTableAdd(effects, effect)
					end
					------------------------
				end
				ignore_armor = ignore_armor or data.ignore_armor
								
				local part_def = hit.spot_group and Presets.TargetBodyPart.Default[hit.spot_group]
				
				
				if part_def then
					if not data.ignore_body_part_damage[part_def.id] then
						damage = MulDivRound(damage, 100 + part_def.damage_mod, 100)
						if record_breakdown then record_breakdown[#record_breakdown + 1] = { name = part_def.display_name, value = part_def.damage_mod } end
					end
					---------------
					if other_effects_add then
						EffectTableAdd(effects, part_def.applied_effect)
					end
					---------------
				end
				--print("dmg", damage)
			-- else
				-- damage = MulDivRound(damage, 50, 100)
			-- end
		
			hit.damage = damage
			target:ApplyHitDamageReduction(hit, self, hit.spot_group or g_DefaultShotBodyPart, nil, ignore_armor, record_breakdown)
			
			
			---------------
			local armor_pierced = target:IsArmorPiercedBy(self, 0, hit.spot_group, false)	
			if armor_pierced then
				hit.effects = effects
			end
			-------
			
			-- if hit.grazing then
				-- hit.effects = {}
				-- hit.damage = Max(1, MulDivRound(hit.damage, const.Combat.GrazingHitDamage, 100))
			-- else
				--hit.effects = effects
			--end
			
			
			
		else
			--apply dmg mod for non units
			local obj_dmg_mod = (not hit.ignore_obj_damage_mod and self:HasMember("ObjDamageMod")) and self.ObjDamageMod or 100
			if obj_dmg_mod ~= 100 then
				damage = MulDivRound(damage, obj_dmg_mod, 100)
				if record_breakdown then record_breakdown[#record_breakdown + 1] = { name = T{360767699237, "<em><DisplayName></em> damage modifier to objects", self}, value = obj_dmg_mod } end
			end
			-- if HasPerk(attacker, "CollateralDamage") and IsKindOfClasses(self, "HeavyWeapon", "MachineGun") then
				-- local collateralDamage = CharacterEffectDefs.CollateralDamage
				-- local damageBonus = collateralDamage:ResolveValue("objectDamageMod")
				-- damage = MulDivRound(damage, 100 + damageBonus, 100)
				-- if record_breakdown then record_breakdown[#record_breakdown + 1] = { name = collateralDamage.DisplayName, value = damageBonus } end
			-- end
			--apply armor for non units
			local pen_class = self:HasMember("PenetrationClass") and self.PenetrationClass or #PenetrationClassIds
			local armor_class = target and target.armor_class or 1
			if pen_class >= armor_class then
				hit.damage = damage or 0
				hit.armor_prevented = 0
			else
				hit.damage = 0
				hit.armor_prevented = damage or 0
			end
			if record_breakdown then 
				if hit.damage > 0 then
					record_breakdown[#record_breakdown + 1] = { name = T(478438763504, "Armor (Pierced)") }
				else
					record_breakdown[#record_breakdown + 1] = { name = T(360312988514, "Armor"), value = -hit.armor_prevented }
				end
			end
		end
	end	
	
	local BulletVegetationCollisionMask = const.cmDefaultObject | const.cmActionCamera
	local BulletVegetationCollisionQueryFlags = const.cqfSorted | const.cqfResultIfStartInside
	local BulletVegetationClasses = { "Shrub", "SmallTree", "TreeTop" }
	
	function Firearm:Shrapnel_Fly(attacker, start_pt, end_pt, dir, speed, hits, target, attack_args, end_time_g)
		NetUpdateHash("ProjectileFly", attacker, start_pt, end_pt, dir, speed, hits)
		dir = SetLen(dir or end_pt - start_pt, 4096)
		--print("fly gtime", end_time_g)
		local fx_actor = false
		if IsKindOf(attacker, "Unit") then
			fx_actor = attacker:CallReactions_Modify("OnUnitChooseProjectileFxActor", fx_actor)
		end
	
		local projectile = PlaceObject("FXBullet")
		projectile.fx_actor_class = fx_actor
		projectile:SetGameFlags(const.gofAlwaysRenderable)
		projectile:SetPos(start_pt)
		local axis, angle = OrientAxisToVector(1, dir) -- 1 = +X
		projectile:SetAxis(axis)
		projectile:SetAngle(angle)
		
		--print("projectile", projectile)
		
		PlayFX("Spawn", "start", projectile)
		local fly_time = MulDivRound(projectile:GetDist(end_pt), 1000, speed)
		---
		local end_time = end_time_g + fly_time
		----
		projectile:SetPos(end_pt, fly_time)
		--Sleep(const.Combat.BulletDelay)
	
		--local wind_last_dist
		-- collision.Collide(start_pt, end_pt - start_pt, BulletVegetationCollisionQueryFlags, 0, BulletVegetationCollisionMask, 
			-- function(o, _, hitX, hitY, hitZ)
				-- if o:IsKindOfClasses(BulletVegetationClasses) and not table.find(hits, "obj", o) then
					-- local hit = {
						-- obj = o,
						-- pos = point(hitX, hitY, hitZ),
						-- distance = start_pt:Dist(hitX, hitY, hitZ),
						-- vegetation = true,
					-- }
					-- table.insert(hits, hit)
					-- if not wind_last_dist or hit.distance - wind_last_dist >= WindModifiersVegetationMinDistance then
						-- PlaceWindModifierBullet(hit.pos)
						-- wind_last_dist = hit.distance
					-- end
				-- end
			-- end)
		-- if wind_last_dist then
			-- table.sortby_field(hits, "distance")
		-- end
	
		local context = {
			attacker = attacker,
			target = target,
			dir = dir,
			target_hit = false,
			last_unit_hit = false,
			water_hit = false,
			fx_target = false,
		}
		local last_start_pos = start_pt
		local last_time = 0
		
	
		for i, hit in ipairs(hits) do
			local hit_time = MulDivRound(hit.pos:Dist(last_start_pos), 1000, speed)
			if hit_time > last_time then
				Sleep(hit_time - last_time)
				last_time = hit_time
			end
			
			----
			self:BulletHit(projectile, hit, context)
			PlayFX("Spawn", "end", projectile, false)
			DoneObject(projectile)
			----
			if hit.ricochet and i < #hits then
				last_start_pos = hit.pos
				last_time = 0
				local ricochet_dir = SetLen(hits[i+1].pos - last_start_pos, 4096)
				local axis, angle = OrientAxisToVector(1, ricochet_dir) -- 1 = +X
				projectile:SetAxis(axis)
				projectile:SetAngle(angle)
				PlayFX("Ricochet", "start", projectile, context.fx_target, last_start_pos, ricochet_dir)
				local last_pos = hits[#hits].pos
				projectile:SetPos(last_pos, MulDivRound(last_pos:Dist(last_start_pos), 1000, speed))
			end
		end
		-- if IsValid(target) and not context.target_hit then
			-- PlayFX("TargetMissed", "start", target)
		-- end
		-- wait the projectile in case of no hits or long flight after the last hit
		
		
		if projectile then
			Sleep(Max(0, end_time - GameTime()))
			PlayFX("Spawn", "end", projectile, false)
			DoneObject(projectile)
		end
	end
		

		--local maxRandomAngle = 1
		-- theta = theta * ( math.random() * maxRandomAngle)
			-- phi = phi * (math.random() * maxRandomAngle)
	
	
	
			-- Calculate phi with bias towards the sides of the sphere
			--local phi = math.acos(math.random() * 2 - 1) -- Use cosine to bias distribution towards equator
	
	function generateShrapnelPositionsInCone(numPositions, radius, angle_degrees, center, direction)
		local positions = {}
		local phis_list = {}

		-- Convert degrees to radians
		local angle_radians = angle_degrees * math.pi / 180

		-- Generate random angles within the cone
		for i = 1, numPositions do
			local theta = math.random() * 2 * math.pi  -- Random angle around the center axis
			local h = math.random() * radius * math.tan(angle_radians / 2)  -- Random height within the cone

			-- Convert polar coordinates to Cartesian coordinates
			local x = center:x() + math.cos(theta) * h
			local y = center:y() + math.sin(theta) * h
			local z = center:z() + math.sqrt(radius^2 - h^2)

			-- Store the position
			local point = point(x, y, z)
			
			table.insert(positions, point)
			table.insert(phis_list, theta)  -- Store the theta angle for potential use
		end

		return positions, phis_list
	end

	function generateConicalVectors(numVectors, coneAngle, axisDirection, axisAngle)
		print("axisdir", axisDirection)
		local vectors = {}
		local phis = {}
		local thetas = {}
		local axisDirection = {axisDirection:x(),axisDirection:y(), axisDirection:z() }
		-- Normalize the direction vector
		local length = math.sqrt(axisDirection[1]^2 + axisDirection[2]^2 + axisDirection[3]^2)
		local axis = {axisDirection[1] / length, axisDirection[2] / length, axisDirection[3] / length}
		
		-- Calculate theta angle to align with the x-axis in the xy-plane
		local theta = math.rad(axisAngle/60)
		
		-- Calculate phi angle to align with the z-axis
		local phi = math.acos(axis[3])
		
		-- Print the calculated rotation angles for debugging
		print("Theta:", theta)
		print("Phi:", phi)
		-- Generate evenly spaced points on a cone
		for i = 1, numVectors do
			-- Calculate theta angle around the cone's axis
			local theta_i = 2 * math.pi * (i - 1) / numVectors
			
			-- Rotate theta angle by theta to align with the direction vector
			local theta_rotated = theta_i + theta
			
			-- Calculate phi angle within the cone's aperture
			local phi_i = math.acos(1 - 2 * (i - 1) / numVectors) * coneAngle
			
			-- Calculate Cartesian coordinates of the vector in the rotated coordinate system
			local x_rotated = math.sin(phi_i) * math.cos(theta_rotated)
			local y_rotated = math.sin(phi_i) * math.sin(theta_rotated)
			local z_rotated = math.cos(phi_i)
			
			-- Rotate vector back to original coordinate system
			local x = x_rotated * math.cos(phi) * math.cos(theta) - y_rotated * math.sin(theta) + z_rotated * math.sin(phi) * math.cos(theta)
			local y = x_rotated * math.cos(phi) * math.sin(theta) + y_rotated * math.cos(theta) + z_rotated * math.sin(phi) * math.sin(theta)
			local z = -x_rotated * math.sin(phi) + z_rotated * math.cos(phi)
			
			-- Store the vector and angles
			--print(i, x, y, z)
			table.insert(vectors, {x, y, z})
			table.insert(phis, phi_i)
			table.insert(thetas, theta_i)
		end
		
		return vectors, phis, thetas
	end

	function findAngleAtRadius(theta, radius1, radius2)
		theta = math.rad(theta) -- Convert degrees to radians
		local ratio = radius1 / radius2
		local angle = math.atan(math.tan(theta) * ratio)
		return angle
	end

	function generateShrapnelPositions(numPositions, radius, center, cone_args)
		local positions = {}
		local phis_list = {}
		local vectors, phis
		local original_radius = radius
		if cone_args.cone_shape then
			vectors, phis = generateConicalVectors(numPositions, cone_args.cone_angle, cone_args.direction, cone_args.cone_dir_angle)
			radius = cone_args.cone_radius
		else
			vectors, phis= generateShrapnelVectors(numPositions)
		end
--[[ 		if cone_angle then
			for i, vector in ipairs(vectors) do
				local vector_point = point(vector[1],vector[2], vector[3])
				DbgAddVector(center, vector_point - center)
				local angle = CalcOrientation(center, vector)
				if angle < cone_angle/2 then
					DbgAddVector(center, vector - center)
				end
			end
		end ]]
		local maxRandomOffset = const.SlabSizeX/2
		-- Scale the vectors by the radius to get positions and then shift them by the center position
		for i, v in ipairs(vectors) do
			--print(v)
			local x = v[1] * radius + center:x()
			local y = v[2] * radius + center:y()
			local z = v[3] * radius + center:z()
			
			local xOffset = math.random(-maxRandomOffset, maxRandomOffset)
			local yOffset = math.random(-maxRandomOffset, maxRandomOffset)
			local zOffset = math.random(-maxRandomOffset, maxRandomOffset)
	
			x = x + xOffset
			y = y + yOffset
			z = z + zOffset
			
			local point = point(x, y, z)
			--point = RotateRadius(point:Dist(center), math.random(-2.0,2.0)*60, center)
			
			
			table.insert(positions, point)
			table.insert(phis_list, phis[i])
		end
		if cone_args.cone_shape then
			local xtnd_positions = {}
			for i, position in ipairs(positions) do
				table.insert(xtnd_positions, Lengthen(position, original_radius))
			end
			positions = xtnd_positions
		end
		return positions, phis_list
	end
	
	



	
	function generateShrapnelVectors(numVectors)
		local vectors = {}
		local phis ={}
		-- Golden ratio to distribute points evenly
		local goldenRatio = (1 + math.sqrt(5)) / 2
	
		-- Generate evenly spaced points on a sphere
		for i = 1, numVectors do
			local theta = 2 * math.pi * (i - 1) / goldenRatio 
			
			local phi = math.acos(-1 + 2 * (i - 0.5) / numVectors)--*0.7 ---- bias to north hemisphere. 
			--local phi = math.acos(math.random() * 2 - 1) *0.9
			phi = phi >= 1.5 and phi *0.7 or phi*1.5 ---- bias to the sides of the sphere
	
			local x = math.sin(phi) * math.cos(theta)
			local y = math.sin(phi) * math.sin(theta)
			local z = math.cos(phi)
	
			table.insert(vectors, {x, y, z})
			table.insert(phis, phi)
		end
	
		return vectors, phis
	end











































	
	--[[local thrower_pos = thrower:GetPos()
		thrower_pos = IsValidZ(thrower_pos) and thrower_pos or thrower_pos:SetTerrainZ()
		local dir = SetLen(thrower_pos - explosion_pos,radius)
		dir:SetZ(explosion_pos:z())
		local master_pos = explosion_pos-dir
		
		local numVectors = 90
		local vectors_2d = numVectors/3
		local angleIncrement = 360*60 / (vectors_2d)
		print("angle inc", angleIncrement)
		local vectors = {}
		local explosion_z_vector = explosion_pos:SetZ(explosion_pos:z() + radius)
		for i = 1, vectors_2d do
			local rotate_point =  RotateAxis(explosion_z_vector, axis_y, angleIncrement * (i-1), explosion_pos)--RotateRadius(radius, angleIncrement * (i-1), explosion_pos)
			table.insert(vectors, rotate_point)
		end
			--RotateAxis(pt, axis, angle, center)
		--distributePointsOnSphere
		--local test_vectors = distributePointsOnSphere(45, radius)
		--EO_distributeVectorsOnSphereTEST(45, master_pos)
		local vectors_3d = {}
		for i, v in ipairs(vectors) do
			-- print(i,v)
			-- DbgAddCircle(v, const.SlabSizeX/2)
			-- for ii = 1, vectors_2d do
				-- local vector_3d = RotateAxis(v, axis_y, angleIncrement * (ii-1), explosion_pos)
				-- table.insert(vectors_3d, vector_3d)
			-- end
		end
		
		for i, v in ipairs(vectors_3d) do
			DbgAddCircle(v, const.SlabSizeX/2)
		end
		
		DbgAddCircle(explosion_z_vector, const.SlabSizeX/2, const.clrOrange)
		local target = g_Units["Steroid"]
		
		local target_pos = target:GetPos():SetTerrainZ()
		target_pos = target_pos:SetZ(target_pos:z() + const.SlabSizeX)
	
	
		DbgAddCircle(explosion_pos, const.SlabSizeX/2, const.clrOrange)
			DbgAddVector(explosion_pos, thrower_pos - explosion_pos)
		
		DbgAddCircle(explosion_pos-dir, const.SlabSizeX/2, const.clrOrange)
		local final_pos = target_pos--explosion_pos - dir
		--final_pos:SetZ((final_pos:z() or final_pos:SetTerrainZ():z()) + const.SlabSizeZ*2)
		--final_pos:SetZ(explosion_pos:z() + guic*1000)
		DbgAddCircle(final_pos, const.SlabSizeX/2)
		
		--DbgAddVector(explosion_pos, final_pos - explosion_pos)
		--local ipt = terrain.IntersectSegment(explosion_pos, final_pos)
		--local hits ={}
		--local hit_flags = 26543753--25495177 + const.efVisible + const.efCollision-- 0--const.efVisible + const.efCollision --+ const.efUnit
		-- local col = GetClosestRayObj(explosion_pos, final_pos, hit_flags, 0, function(obj, x, y, z)
				-- return true
		-- end)
		-- print("col", col)
		-- local lof_params = {
			-- action_id = "SingleShot",
			-- obj = false,
			-- stance = false,
			-- step_pos = explosion_pos,
			-- can_use_covers = false,
			-- ignore_colliders = false,
			-- prediction = true,
			-- range = 6000,
			-- weapon = false,
			-- ignore_los = true,
			-- inside_attack_area_check = false,
			-- forced_hit_on_eye_contact = false,
		-- }]]
		
		--[[
		function FromSpherical(phi, theta, r)
		local sin_theta = sin(theta)
		local x = r * sin_theta * cos(phi) / 4096 / 4096
		local y = r * sin_theta * sin(phi) / 4096 / 4096
		local z = r * cos(theta) / 4096
		return x, y, z
	end
	
	function BuildSphere(pstr, radius)
		local phi_steps = 40
		local theta_steps = 60
		for phi_step = 0, phi_steps - 1 do
			local phi_current = MulDivRound(phi_step, 60 * 360, phi_steps)
			local phi_next = MulDivRound(phi_step + 1, 60 * 360, phi_steps)
			for theta_step = 0, theta_steps - 1 do
				local theta_current = MulDivRound(theta_step, 60 * 180, theta_steps)
				local theta_next = MulDivRound(theta_step + 1, 60 * 180, theta_steps)
	
				local pt0 = point(FromSpherical(phi_current, theta_current, radius))
				local pt1 = point(FromSpherical(phi_next, theta_current, radius))
				local pt2 = point(FromSpherical(phi_next, theta_next, radius))
				local pt3 = point(FromSpherical(phi_current, theta_next, radius))
				
				
				print(theta_step, pt0, pt1, pt2, pt3)
	
				-- local AppendVertex = pstr.AppendVertex
				-- AppendVertex(pstr, pt0:x(), pt0:y(), pt0:z())
				-- AppendVertex(pstr, pt3:x(), pt3:y(), pt3:z())
				-- AppendVertex(pstr, pt1:x(), pt1:y(), pt1:z())
			
				-- AppendVertex(pstr, pt1:x(), pt1:y(), pt1:z())
				-- AppendVertex(pstr, pt3:x(), pt3:y(), pt3:z())
				-- AppendVertex(pstr, pt2:x(), pt2:y(), pt2:z())
			end
		end
	end
	
	function test_sphere()
		local points = {}
		BuildSphere(points, 9000)
		for i, v in ipairs(pstr) do
			print(i,v)
		end
	end
	
	
	function EO_distributeVectorsOnSphere(numVectors)
		local vectors = {}
		
		
		-- for i = 1, numVectors do
			-- local theta = 3.14 * (3 - sqrt(5)) * i -- Golden angle increment
			-- local y = 1 - (i / numVectors) * 2 -- Distribute along y-axis
			-- local radius = sqrt(1 - y * y)
			-- local x = cos(theta) * radius
			-- local z = sin(theta) * radius
			-- table.insert(vectors, point(x,y,z))
		-- end
		
		local phiIncrement = math.pi * (3 - math.sqrt(5)) -- Golden angle increment
		
		for i = 1, numVectors do
			local y = -1 + 2 * (i - 1) / (numVectors - 1)  -- Distribute along y-axis
			local radius = math.sqrt(1 - y * y)
			local theta = phiIncrement * (i - 1)  -- Angle around the y-axis
			local x = math.cos(theta) * radius
			local z = math.sin(theta) * radius
			table.insert(vectors, {x = x, y = y, z = z})
		end
		
	-- local inc = math.pi * (3 - math.sqrt(5)) -- Golden angle increment
	
	-- for i = 1, numVectors do
		-- local y = (i - 1) / (numVectors - 1) * 2 - 1 -- Distribute along y-axis
		-- local radius = math.sqrt(1 - y * y)
		-- local theta = inc * (i - 1) / (numVectors - 1) * 2 * math.pi -- Adjust theta range
		-- local x = math.cos(theta) * radius
		-- local z = math.sin(theta) * radius
		-- table.insert(vectors, {x = x, y = y, z = z})
	-- end
		
		
		-- for i, v in ipairs(vectors) do
			-- print(i,v)
		-- end
		return vectors
	end
	
	
	
	function get_shrapnels(explosionPoint, explosionRadius, numShrapnel)
		local shrapnel = {}
		
		-- Distribute vectors evenly on a sphere's surface
		local shrapnelDirections = EO_distributeVectorsOnSphere(numShrapnel)
		
		for i, direction in ipairs(shrapnelDirections) do
			-- Calculate position based on direction and explosion radius
			
			local x = explosionPoint:x() + direction:x() * explosionRadius
			local y = explosionPoint:y() + direction:y() * explosionRadius
			local z = explosionPoint:z() + direction:z() * explosionRadius
			
			local position = point(x,y,z)
			-- Assign random velocity to simulate movement
			-- local velocity = {
				-- x = direction:x() * math.random(10, 20), -- Adjust velocity range as needed
				-- y = direction:y() * math.random(10, 20),
				-- z = direction:z() * math.random(10, 20)
			-- }
			
			--table.insert(shrapnel, {position = position, velocity = velocity})
			table.insert(shrapnel, position)
		end
		
		return shrapnel
	end
	
	function distributePointsOnSphere(numPoints, radius)
		local points = {}
		for i = 1, numPoints do
			local theta = math.acos(1 - (2 * i - 1) / numPoints)
			local phi = 2 * math.pi * ((i - 1) / numPoints)
			local x = radius * math.sin(theta) * math.cos(phi)
			local y = radius * math.sin(theta) * math.sin(phi)
			local z = radius * math.cos(theta)
			table.insert(points, point(x,y,z))
		end
		return points
	end
	]]

	function Grenade:GetAreaAttackParams(action_id, attacker, target_pos, step_pos)
		target_pos = target_pos or self:GetPos()
		local aoeType = self.aoeType
		local max_range = self.AreaOfEffect
		if aoeType == "fire" then
			max_range = 2
		end
		local params = {
			attacker = false,
			weapon = self,
			target_pos = target_pos,
			step_pos = target_pos,
			stance = "Prone",
			min_range = self.AreaOfEffect,
			max_range = max_range,
			center_range = self.CenterAreaOfEffect,
			damage_mod = 100,
			attribute_bonus = 0,
			can_be_damaged_by_attack = true,
			aoe_type = aoeType,
			explosion = true, -- damage dealt depends on target stance
			explosion_fly = self.DeathType == "BlowUp",
		}
		if self.coneShaped then
			params.cone_length = self.AreaOfEffect * const.SlabSizeX
			params.cone_angle = self.coneAngle * 60
			params.target_pos = RotateRadius(params.cone_length, CalcOrientation(step_pos or attacker, target_pos), target_pos)
			
			if not params.target_pos:IsValidZ() or params.target_pos:z() - terrain.GetHeight(params.target_pos) <= 10*guic then
				params.target_pos = params.target_pos:SetTerrainZ(10*guic)
			end
		end
		if IsKindOf(attacker, "Unit") then
			params.attacker = attacker
			--params.attribute_bonus = GetGrenadeDamageBonus(attacker) -- already applied in GetBaseDamage
		end
		return params
	end
	