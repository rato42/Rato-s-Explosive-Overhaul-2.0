--[[local dirPX = 0
local dirNX = 1
local dirPY = 2
local dirNY = 3
local dirPZ = 4
local dirNZ = 5
local sizex = const.SlabSizeX
local sizey = const.SlabSizeY
local sizez = const.SlabSizeZ

local function FindSmokeObjPos(smoke, blocked)
	-- find a place for the smoke grenade obj: nearest voxel to original target (0, 0, 0)
	local smoke_obj_ppos, min_dist2
	local mask = bor(shift(1, dirPX), shift(1, dirPY), shift(1, dirNX), shift(1, dirNY))
	for packed, _ in pairs(smoke) do
		-- only consider voxels that are blocked downwards and do not have blocked x/y sides
		local value = blocked[packed] or 0
		if band(value, shift(1, dirNZ)) ~= 0 and band(value, mask) == 0 then 
			local x, y, z = point_unpack(packed)
			local dist2 = (x*x*guim*guim) + (y*y*guim*guim) + (z*z*guim*guim)
			if not smoke_obj_ppos or min_dist2 > dist2 then
				smoke_obj_ppos, min_dist2 = packed, dist2
			end
		end
	end
	return smoke_obj_ppos
end


local function GetExplosionFXPos(visual_obj_or_pos)
	local pos = IsPoint(visual_obj_or_pos) and visual_obj_or_pos or visual_obj_or_pos:GetPos() --light fx use this pos, alternatively we could make them not affect stealth
	if not pos:IsValidZ() then
		pos = pos:SetTerrainZ() -- only when pos is on invalidz so we can still get walkable slabs that are over the terrain if the position is right
	end
	local slab, slab_z = WalkableSlabByPoint(pos)
	local z = pos:z()
	
	if slab_z then
		if slab_z <= z and slab_z >= z - guim then
			pos = pos:SetZ(slab_z)
		end
	else
		pos = GetExplosionDecalPos(pos)
	end
	
	return pos
end

function SmokeZone:PropagateSmoke()
	local gx, gy, gz = WorldToVoxel(self)
	local smoke, blocked = PropagateSmokeInGrid(gx, gy, gz, self.smoke_dx, self.smoke_dy)
	
	-- remove existing smoke if it no longer propagates there (e.g. a fire started there, door closed, etc)
	for ppos, wpt in pairs(self.smoke_positions) do
		local gppos = point_pack(WorldToVoxel(wpt))
		if not smoke[ppos] then
			self:RemoveSmokeFromPos(gppos)
		end
	end
	
	-- update self.smoke_positions from smoke & create smoke objs if necessary
	for _, wpt in pairs(smoke) do
		local ppos = point_pack(WorldToVoxel(wpt))
		local obj = g_SmokeObjs[ppos]
		local gas_type = obj and obj:GetGasType()
		if not obj then
			obj = PlaceObject("SmokeObj")
			obj:SetPos(wpt)
			g_SmokeObjs[ppos] = obj
		end
		table.insert_unique(obj.zones, self)
		if not gas_type then
			PlayFX("VoxelGas", "start", obj, self.gas_type)
		end
	end
	self.smoke_positions = smoke
	
	if not self.spinner then
		local ppos = FindSmokeObjPos(smoke, blocked)
		if ppos then
			local x, y, z = point_unpack(ppos)
			local pos = self:GetPos() + point(x*sizex, y*sizex, z*sizez)
			local fx_class = "SmokeGrenadeSpinner"
			if self.gas_type == "teargas" then
				fx_class = "TearGasGrenadeSpinner"
			elseif self.gas_type == "toxicgas" then
				fx_class = "ToxicGasGrenadeSpinner"
			end
			
			--------------------------------
			
			
			--fx_class = "Weapon_SmokeCanIED_Spinning"
			
			
			local obj = PlaceObject("GrenadeVisual", {fx_actor_class = fx_class} )
			
			obj:SetPos(pos)
			obj:SetAnim(1, "rotating")
			PlayFX("SmokeGrenadeSpin", "start", obj)
			self.spinner = obj
		else
			self.spinner = "none" -- non-false/nil value to indicate we couldn't find a place for the object
		end
	end
end



function ApplyExplosionDamage(attacker, fx_actor, results, noise, disableBurnFx, ignore_targets)
	if not CurrentThread() then
		CreateGameTimeThread(ApplyExplosionDamage, attacker, fx_actor, results, noise, disableBurnFx)
		return
	end


	
	
	local gas = results.aoe_type == "smoke" or results.aoe_type == "teargas" or results.aoe_type == "toxicgas"
	local fire = results.aoe_type == "fire"
	
	local pos
	local surf_fx_type
	local fx_action
	if fx_actor then
		pos = GetExplosionFXPos(fx_actor)
		surf_fx_type = GetObjMaterial(pos)
		if fire then
			fx_action = "ExplosionFire"
		elseif gas then
			fx_action = "ExplosionGas"
		else
			fx_action = "Explosion"
		end
		PlayFX(fx_action, "start", fx_actor, surf_fx_type, pos)
	end
	Sleep(100)
	if fx_actor and not disableBurnFx then
		PlayFX(fx_action, "end", fx_actor, surf_fx_type, pos)
	end
	local burn_ground = true
	if results.burn_ground ~= nil then
		burn_ground = results.burn_ground
	end
	if not fire and not gas and burn_ground and results.target_pos then
		--PlaceWindModifierExplosion(results.target_pos, results.range)
		if not disableBurnFx then
			local fDestroyOrBurn = (results.aoe_type == "fire") and igMolotovDestroyOrBurn or igExplosionDestroyOrBurn
			Explosion_ProcessGrassAndShrubberies(results.target_pos, results.range/2, fDestroyOrBurn)
		end
	end

	local attack_reaction, weapon
	if IsKindOf(attacker, "DynamicSpawnLandmine") and IsKindOf(attacker.attacker, "Unit") then
		attack_reaction = true
		weapon = attacker
		attacker = attacker.attacker
	elseif IsKindOf(attacker, "Unit") then
		attack_reaction = true
		weapon = results.weapon
	end
	
	local hit_units = {}
	ignore_targets = ignore_targets or empty_table
	for _, hit in ipairs(results) do
		local obj = hit.obj
		hit.explosion = true
		if IsValid(obj) then --after fx sleep this obj can no longer be valid
			if not ignore_targets[obj] then
				if IsKindOf(obj, "Unit") then
					if not hit_units[obj] then
						hit_units[obj] = hit
					else
						hit_units[obj].damage = hit_units[obj].damage + hit.damage
					end
				elseif IsKindOf(obj, "CombatObject") then
					obj:TakeDamage(hit.damage, attacker, hit)
				elseif IsKindOf(obj, "Destroyable") and hit.damage > 0 then
					obj:Destroy()
				end
			end
		end
	end
	--pp units so they know wheather they would need to fall down before dying
	for u, hit in sorted_handled_obj_key_pairs(hit_units or empty_table) do
		if not ignore_targets or not ignore_targets[u] then
			u:ApplyDamageAndEffects(attacker, hit.damage, hit, hit.armor_decay)
		end
	end
	
	if fx_actor and attacker and not attacker.spawned_by_explosive_object then
		PushUnitAlert("thrown", fx_actor, attacker)
	end
	if fx_actor and noise then
		PushUnitAlert("noise", fx_actor, noise, Presets.NoiseTypes.Default.Explosion.display_name)
	end
	
	if fire then
		ExplosionCreateFireAOE(attacker, results, fx_actor)
	elseif gas then
		ExplosionCreateSmokeAOE(attacker, results, fx_actor)
	end

	if attack_reaction then
		AttackReaction("ThrowGrenadeA", {obj = attacker, weapon = weapon}, results)
	end
	NetUpdateHash("g_LastExplosionTime_set")
	g_LastExplosionTime = GameTime()
end

]]
