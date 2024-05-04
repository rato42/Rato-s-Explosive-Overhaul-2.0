--[[ function MoveItem(args)
	--prepresetup
	assert(args)
	local item                     = args.item
	local src_container            = args.src_container
	local src_container_slot_name  = args.src_container_slot_name or args.src_slot
	local dest_container           = args.dest_container
	local dest_container_slot_name = args.dest_container_slot_name or args.dest_slot
	local dest_x                   = args.dest_x or args.x
	local dest_y                   = args.dest_y or args.y
	local amount                   = args.amount
	local check_only               = args.check_only
	local ap_cost                  = args.ap_cost
	local merge_up_to_amount       = args.merge_up_to_amount
	local local_changes            = args.local_changes
	local exec_locally             = args.exec_locally
	local sync_call                = args.sync_call
	local s_src_x                  = args.s_src_x
	local s_src_y                  = args.s_src_y
	local s_item_at_dest           = args.s_item_at_dest
	local s_sync_unit              = args.s_sync_unit
	local s_player_id              = args.s_player_id
	local alternative_swap_pos     = args.alternative_swap_pos
	local no_ui_respawn            = args.no_ui_respawn
	local multi_items              = args.multi_items
	
	if sync_call then
		NetUpdateHash("MoveItem", item and item.class, item and item.id, 
			dest_container and type(dest_container) == "table" and dest_container.class or dest_container, dest_container_slot_name,
			src_container and src_container.class, src_container_slot_name,
			dest_x, dest_y, s_src_x, s_src_y)
	end
	--presetup
	assert((dest_x and dest_y) or (not dest_x and not dest_y))
	if not item then return end 
	
	exec_locally = not not exec_locally
	if dest_container == "drop" then
		dest_container_slot_name = "Inventory"
		if sync_call then
			dest_container = GetDropContainer(s_sync_unit, false, item)
		else
			dest_container = PlaceObject("LocalDropContainer")
		end
	elseif type(dest_container) == "number" then --unopenned squad bag, this being the squad id
		dest_container = PlaceObject("UnopennedSquadBag", {squad_id = dest_container})
	end
	
	--setup
	local src_x, src_y
	if src_container then
		src_x, src_y = src_container:GetItemPosInSlot(src_container_slot_name, item)
		if not src_x and not IsKindOf(src_container, "SectorStash") then --sector stash may now not contain the item due to tabbing.
			return "item not found in src container!"
		elseif not s_src_x then
			--lcl sync_call == true with omitted src locations
			s_src_x = src_x
			s_src_y = src_y
		end
	end
	local item_at_dest = dest_x and dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x, dest_y)
	if item_at_dest == item then
		item_at_dest = false
	end
	
	--this can only be a second weapon when trying to equip large weap on 2 small ones;
	--piggy back on item_at_dest and item checks and assume swap for scnd item is always possible;
	local item_at_dest_2 = false 
	if dest_x and item:IsLargeItem()
		and ( not sync_call or not IsKindOf(dest_container, "SectorStash") ) then
		--check for other items underneath
		local other_item_at_dest = dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x + 1, dest_y)
		if other_item_at_dest == item then
			other_item_at_dest = false
		end
		if item_at_dest and other_item_at_dest and other_item_at_dest ~= item_at_dest then
			if IsEquipSlot(dest_container_slot_name) then
				item_at_dest_2 = other_item_at_dest
			else
				return "too many items underneath"
			end
		end
		if not item_at_dest and other_item_at_dest then
			item_at_dest = other_item_at_dest
		end
	end
	if src_x and dest_x and not item:IsLargeItem() and item_at_dest and item_at_dest:IsLargeItem() then
		local other_item_at_dest = dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x + 1, dest_y)
		if other_item_at_dest ~= item_at_dest then
			--small item dropping on large item second slot
			src_x = src_x - 1
		end
	end
	if dbgMoveItem then
		invprint("MoveItem sync", sync_call, "check_only", check_only, "amount", amount, 
				string.format("moving %s %s from %s %s %d %d to %s %s %d %d, item_at_dest %s %s", 
				item.class, tostring(item.id), src_container and src_container.session_id or src_container and src_container.class or false, src_container_slot_name, src_x or -1, src_y or -1, dest_container.session_id or dest_container.class, tostring(dest_container_slot_name), dest_x or -1, dest_y or -1, item_at_dest and item_at_dest.class or tostring(item_at_dest), item_at_dest and tostring(item_at_dest.id) or "n/a"))
	end
	if sync_call then
		if item_at_dest ~= s_item_at_dest or src_x ~= s_src_x or src_y ~= s_src_y then
			--state is different from when/where command fired, resolve
			if IsKindOf(src_container, "SectorStash") and item_at_dest == s_item_at_dest then
				--sector stash can have items in visually different slots
				--just let it go through
			elseif IsKindOf(dest_container, "SectorStash") then
				if item_at_dest and not s_item_at_dest then
					--adding to sector stash but there is an item there on this client, add it as last (default stash behavior)
					item_at_dest = false
					dest_x = nil
					dest_y = nil
				elseif s_item_at_dest then
					--swapping items in stash but swapped items are in diff positions here
					--get item from net
					--get pos from item
					item_at_dest = s_item_at_dest
					dest_x, dest_y = dest_container:GetItemPosInSlot(dest_container_slot_name, item_at_dest)
				end
			else
				--unexpected
				NetUpdateHash("MoveItem state changed", item_at_dest and item_at_dest.class or "no item_at_dest",
						s_item_at_dest and s_item_at_dest.class or "no s_item_at_dest", src_x, s_src_x, src_y, s_src_y, 
						src_container, dest_container)
				return "state has changed"
			end
		end
	end
	if src_container == dest_container and src_container_slot_name == dest_container_slot_name then
		if not item_at_dest and src_x == dest_x and src_y == dest_y 
			and not IsKindOf(src_container, "SectorStash") then --they could be in different tabs, so dont early out this op
			--no change required
			if dbgMoveItem then
				invprint("no change required")
			end
			return false, "no change"
		end	
		if multi_items and not dest_x and not dest_y then
			if dbgMoveItem then
				invprint("no change required")
			end
			return false, "no change"		
		end
	end
	local is_reload = IsReload(item, item_at_dest)
	local is_refill = IsMedicineRefill(item, item_at_dest)
	local is_combine = not (IsKindOf(dest_container, "Unit") and dest_container:IsDead() or IsKindOf(dest_container, "ItemContainer")) and MoveItem_CombinesItems and InventoryIsCombineTarget(item, item_at_dest)

	if src_container and item.locked then
		return "item is locked"
	end
	if not is_reload and not is_refill then
		if item_at_dest and item_at_dest.locked then
			return "item underneath is locked"
		end
		if item_at_dest_2 and item_at_dest_2.locked then
			return "item underneath is locked"
		end
	end
	local is_local_changes = exec_locally and not sync_call
	local item_is_stack = IsKindOf(item, "InventoryStack")
	local partial_stack_merge = false
	if not is_reload and not is_combine and not is_refill and not dest_container:CheckClass(item, dest_container_slot_name) then
		return "Can't add item to container, wrong class"
	end

	--figure out ap costs
	local sync_ap, sync_unit
	if not sync_call then
		sync_ap, sync_unit = GetAPCostAndUnit(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, item_at_dest, is_reload)
		sync_ap = ap_cost or sync_ap
		if dbgMoveItem then
			invprint("MoveItem ap cost", sync_ap, "InventoryIsCombatMode()", InventoryIsCombatMode())
		end
		if InventoryIsCombatMode() then
			--check if unit has ap to exec the action
			if not sync_unit:UIHasAP(sync_ap) then
				return is_reload and "Unit doesn't have ap to reload" or "Unit doesn't have ap to execute action", false, sync_unit
			end
		else
			sync_ap = 0
		end
	end
	
	--sync code
	local sync_err = false
	local function Sync()
		if check_only then 
			return true
		end
		if not sync_call then
			local args = MoveItem_SendNetArgs(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, dest_x, dest_y, amount, merge_up_to_amount, exec_locally, 
															src_x, src_y, item_at_dest, alternative_swap_pos,sync_unit , no_ui_respawn, multi_items)
			
			local is_unit_data = IsKindOf(sync_unit, "UnitData")
			local is_unit = IsKindOf(sync_unit,"Unit")
			
			if is_unit_data then
				if not no_ui_respawn then
					if next(multi_args) then
						multi_args[#multi_args+1] = args
						multi_ap = (multi_ap or 0) + sync_ap
						NetSyncEvent("MoveMultiItems", multi_args)
						multi_args = {}
						multi_ap = false
					else
						NetSyncEvent("MoveItems", args)
					end	
				else
					multi_args[#multi_args+1] = args
					multi_ap = (multi_ap or 0) + sync_ap
				end
			else
				if not no_ui_respawn then
					if next(multi_args) then
						multi_args[#multi_args+1] = args
						multi_ap = (multi_ap or 0) + sync_ap
						NetStartCombatAction("MoveMultiItems", sync_unit, multi_ap or sync_ap, multi_args)
						multi_args = {}
						multi_ap = false
					else
						if not NetStartCombatAction("MoveItems", sync_unit, multi_ap or sync_ap, args) then
							sync_err = "NetStartCombatAction refused to start"
						end
					end	
				else
					multi_args[#multi_args+1] = args
					multi_ap = (multi_ap or 0) + sync_ap
				end
			end
			if not exec_locally or is_reload or is_refill then --only swap and move to x, y execs locally for now
				return true
			end
		end
		return false
	end
	
	if not item_at_dest then
		--no item underneath
		local merge_stacks = item_is_stack and not dest_x and not amount
		local local_stack_changes = local_changes and local_changes.local_stack_changes or false
		local local_items_moved = local_changes and local_changes.local_items_moved or false
		local p_pos, reason
		if merge_stacks then
			local is_mergable, new_amount = MergeStackIntoContainer(dest_container, dest_container_slot_name, item, "check", merge_up_to_amount, local_stack_changes)
			if not is_mergable or new_amount > 0 then
				--no part of the stack is mergable or only part is mergable, check for free slot
				p_pos, reason = dest_container:CanAddItem(dest_container_slot_name, item, dest_x, dest_y, local_items_moved)
				if not p_pos then
					if not is_mergable then
						--no room and we can't merge any part of the stack
						return "move failed, no part of the stack is transferable and dest inventory refused item", reason, sync_unit
					else
						--the item is only partially mergable, i.e. part of the stack will not move, but old_amount - new_amount will be moved;
						partial_stack_merge = new_amount --let caller know this is the case
					end
				end
			end
		else
			p_pos, reason = dest_container:CanAddItem(dest_container_slot_name, item, dest_x, dest_y, local_items_moved)
			if not p_pos and dest_x and IsKindOf(dest_container, "SectorStash") then
				p_pos, reason = dest_container:CanAddItem(dest_container_slot_name, item, nil, nil, local_items_moved)
			end
			if not p_pos then
				return "move failed, dest inventory refused item, reason", reason, sync_unit
			end
		end
		
		local x, y
		if p_pos then
			x, y = point_unpack(p_pos)
			if local_items_moved then
				local_items_moved[xxhash(x, y)] = item
				if item:IsLargeItem() then
					local_items_moved[xxhash(x + 1, y)] = item
				end
			end
		end
		
		if Sync() then return sync_err, partial_stack_merge, sync_unit end

		local function DoMove()
			assert(x and y)
			if src_container then
				local pos, reason = src_container:RemoveItem(src_container_slot_name, item, "no_update")
				assert(pos or IsKindOf(src_container, "SectorStash"))
			end
			local pos, reason = dest_container:AddItem(dest_container_slot_name, item, x, y, is_local_changes)
			assert(pos or IsKindOf(dest_container, "SectorStash"))
		end
		
		if amount and item_is_stack and item.Amount > amount then
			assert(not is_local_changes) --not impl.
			--we've been given precise amount to move, which basically means split;
			local new_item = item:SplitStack(amount)
			local pos, reason = dest_container:AddItem(dest_container_slot_name, new_item, x, y)
			assert(pos)
		elseif merge_stacks then
			assert(not is_local_changes) --not impl.
			MergeStackIntoContainer(dest_container, dest_container_slot_name, item, false, merge_up_to_amount)
			if item.Amount <= 0 then
				--the whole stack was merged
				if src_container then
					src_container:RemoveItem(src_container_slot_name, item, "no_update")
					
					--hack, hides removed item until respawnui executes through delayed call to avoid having a stack with 0/n visible for a bit
					--in other cases the item removed by respawnui doesn't change visually until it is removed
					local cntrl = GetInventorySlotCtrl(true, src_container, src_container_slot_name)
					if cntrl then
						local wnd = cntrl:FindItemWnd(item)
						if wnd then
							wnd:SetVisible(false)
						end
					end
				end
				
				DoneObject(item)
				item = false
			elseif x then
				--after the merge some of the stack remains and we have room where to place it
				DoMove()
			end
		else
			--regular old move
			DoMove()
		end

		ObjModified(src_container)
		ObjModified(dest_container)
		MoveItem_UpdateUnitOutfit(src_container,dest_container, check_only)
		if not no_ui_respawn then
			InventoryUIRespawn() --havn't found any other way to make the ui display the changes
		end
		return false, partial_stack_merge, sync_unit
	end
	
	--there is an item at dest, figure out what to do
	--combine stacks
	if item_is_stack and item.class == item_at_dest.class and item_at_dest.Amount < item_at_dest.MaxStacks then
		--this should be prty str8 forward
		print("merging simple")
		local to_add = Min(item_at_dest.MaxStacks - item_at_dest.Amount, item.Amount, amount or max_int)
		if amount and amount ~= to_add then
			--cancel op or just warning?
			if not sync_call then
				print("MoveItem requested to add specific amount, but not possible", amount, to_add)
			end
		end
		
		if Sync() then return sync_err end
		
		item_at_dest.Amount = item_at_dest.Amount + to_add
		item.Amount = item.Amount - to_add
		if item.Amount <= 0 then
			if src_container then
				src_container:RemoveItem(src_container_slot_name, item, "no_update")
			end
			DoneObject(item)
			item = false
		--else, item is dropped back at its source pos, no action needed
		end
		
		ObjModified(src_container)
		ObjModified(dest_container)
		MoveItem_UpdateUnitOutfit(src_container,dest_container, check_only)
		if not no_ui_respawn then
			InventoryUIRespawn() --havn't found any other way to make the ui display the changes
		end

		return false
	end
	
	--reload weapon
	if is_reload then
		--item is ammo
		--item_at_dest is a weapon
		local weapon_obj = FindWeaponReloadTarget(item_at_dest, item)
		if not weapon_obj then
			return "invalid reload target"
		end
		

		if Sync() then return sync_err end
		
		--actual reload
		local prev_loaded_ammo = weapon_obj:Reload(item)
		--process reload results
		if prev_loaded_ammo then
			--there was another ammo clip in the weapon, it is currently in limbo
			if prev_loaded_ammo.Amount == 0 then
				--prev loaded ammo clip is empty, kill it
				DoneObject(prev_loaded_ammo)
				prev_loaded_ammo = false
			else
				--put previous ammo in the ammo bag
				--find the squad
				local squad_id = (src_container and src_container.Squad) or dest_container.Squad
				if not squad_id then
					local squads = GetSquadsInSector(gv_CurrentSectorId)
					squad_id = squads[1] and squads[1].UniqueId
				end
				assert(squad_id)
				--find the bag
				local prev_ammo_dest_container = GetSquadBagInventory(squad_id)
				--put the lime in the coconut
				--could've used the move func again, but this seems faster and easier
				prev_ammo_dest_container:AddAndStackItem(prev_loaded_ammo)
			end
		end

		
		if item.Amount == 0 then
			--item was consumed in the weapon
			if src_container then
				src_container:RemoveItem(src_container_slot_name, item, "no_update")
			end
			DoneObject(item)
			item = false
		else
			--there are some bullets left in the ammo clip
			--ummm, there is nothign to do in this case - ammo hasn't moved and reload has adjusted amounts
		end
		
		ObjModified(src_container)
		if dest_container ~= src_container then
			ObjModified(dest_container)
		end
		MoveItem_UpdateUnitOutfit(src_container,dest_container, check_only)
		if not no_ui_respawn then
			InventoryUIRespawn() --havn't found any other way to make the ui display the changes
		end
		return false
	end
		--refill medicine
	if is_refill then
		--item is meds
		--item_at_dest is a medicine
		if Sync() then return sync_err end
		
		local allmedsNeeded = AmountOfMedsToFill(item_at_dest)
		if allmedsNeeded <=0 then return "not refill needed" end
		
		--get meds from squad bag untill fill the condition or all meds ends
		local usedmeds = Min(item.Amount,allmedsNeeded)
		local max_condition = item_at_dest:GetMaxCondition()
		if usedmeds==allmedsNeeded then
			-- full condition
			item_at_dest.Condition = max_condition
		else
			item_at_dest.Condition = Clamp(item_at_dest.Condition + MulDivRound(usedmeds, max_condition-item_at_dest.Condition, allmedsNeeded),0, max_condition)
		end
		item.Amount = item.Amount - usedmeds
		
		if item.Amount == 0 then
			--item was consumed in the weapon
			if src_container then
				src_container:RemoveItem(src_container_slot_name, item, "no_update")
			end
			DoneObject(item)
			item = false		
		end
		
		ObjModified(src_container)
		if dest_container ~= src_container then
			ObjModified(dest_container)
		end
		if not no_ui_respawn then
			InventoryUIRespawn() --havn't found any other way to make the ui display the changes
		end
		return false
	end

	--try combine
	if is_combine then
		if check_only then
			return false
		end
		local recipe = is_combine
		CombineItemsFromDragAndDrop(recipe.id, sync_unit, item, src_container, item_at_dest, dest_container)
		return false
	end
	--try swap items
	assert(item and item_at_dest and src_container)
	--in order to figure out whther items fit or are accepted in each other's places we would need to remove them first.
	--this is tricky to do with current methods without changing the state..
	local swap_src_x = src_x
	if item:IsLargeItem() and dest_container == src_container and dest_container_slot_name == src_container_slot_name and dest_x and dest_x + 1 == src_x then
		--this handles special case large with small swap where the small item is offset after swap because it feels more natural
		swap_src_x = src_x + 1
		assert(not item_at_dest_2)
	end
	if item_at_dest and  IsEquipSlot(src_container_slot_name) and IsEquipSlot(dest_container_slot_name) then
		if not InventoryCanEquip(item, dest_container, dest_container_slot_name, point_pack(dest_x,dest_y)) 
		or not InventoryCanEquip(item_at_dest, src_container, src_container_slot_name,point_pack(swap_src_x, src_y))
		then
			return "Could not swap equipped items"
		end
	end
	
	if IsEquipSlot(src_container_slot_name) and not InventoryCanEquip(item_at_dest, src_container, src_container_slot_name,point_pack(swap_src_x, src_y)) then
		return "Could not swap items, source container does not accept item at dest"
	end
	
	if not src_container:CheckClass(item_at_dest, src_container_slot_name) then
		return "Could not swap items, source container does not accept item at dest"
	end
	if not dest_container:CheckClass(item, dest_container_slot_name) then
		return "Could not swap items, dest container does not accept source item"
	end
	local alternative_pos,reason
	--swap_src_x and dest_x are nil when swapping in sec stash but diff tabs are open
	assert(swap_src_x or IsKindOf(src_container, "SectorStash"))
	assert(dest_x or IsKindOf(dest_container, "SectorStash"))
	
	if swap_src_x and not src_container:IsEmptyPosition(src_container_slot_name, item_at_dest, swap_src_x, src_y, item) then
		if alternative_swap_pos and IsEquipSlot(dest_container_slot_name) and not IsEquipSlot(src_container_slot_name) and item_at_dest then
			-- search for empty place on destination	
			alternative_pos, reason = src_container:CanAddItem(src_container_slot_name, item_at_dest, nil, nil,
																		{force_empty = {[xxhash(src_container:GetItemPosInSlot(src_container_slot_name, item))] = true} } ) --only findemptypos uses this, make it think the item we are swapping with is gone
			if not alternative_pos then
				return "Could not swap items, item at dest does not fit in source container at the specified position"
			end
		else
			return "Could not swap items, item at dest does not fit in source container at the specified position"
		end	
	end
	
	if not item_at_dest_2 and (dest_x and not dest_container:IsEmptyPosition(dest_container_slot_name, item, dest_x, dest_y, item_at_dest)) then
		--presumably, if item_at_dest_2 exists, then there is space for sure;
		return "Could not swap items, item does not fit in dest container at the specified position"
	end
	if (item:IsLargeItem() or item_at_dest:IsLargeItem()) and dest_x and swap_src_x and src_container == dest_container and src_container_slot_name == dest_container_slot_name and dest_y == src_y then
		--check if item_at_dest will fit after item has been placed
		local occupied1, occupied2 = dest_x, item:IsLargeItem() and (dest_x + 1) or dest_x
		local needed1, needed2 = swap_src_x, item_at_dest:IsLargeItem() and (swap_src_x + 1) or swap_src_x
		if needed1 == occupied1 or needed1 == occupied2 or needed2 == occupied1 or needed2 == occupied2 then
			return "Could not swap items, items overlap after swap"
		end
	end

	if Sync() then return sync_err end

	src_container:RemoveItem(src_container_slot_name, item, "no_update")
	dest_container:RemoveItem(dest_container_slot_name, item_at_dest, "no_update")
	if item_at_dest_2 then
		dest_container:RemoveItem(dest_container_slot_name, item_at_dest_2, "no_update")
	end
	local pos, reason = dest_container:AddItem(dest_container_slot_name, item, dest_x, dest_y, is_local_changes, dest_x)
	assert(pos, reason)
	if alternative_pos then
		local x,y = point_unpack(alternative_pos)
		local pos2, reason2 = src_container:AddItem(src_container_slot_name, item_at_dest, x,y, is_local_changes, dest_x)
		assert(pos2, reason2)
	else
		local pos2, reason2 = src_container:AddItem(src_container_slot_name, item_at_dest, swap_src_x, src_y, is_local_changes, dest_x)
		assert(pos2, reason2)
	end
	if item_at_dest_2 then
		src_container:AddItem(src_container_slot_name, item_at_dest_2, swap_src_x + 1, src_y, is_local_changes)
	end
	MoveItem_UpdateUnitOutfit(src_container,dest_container, check_only)
	if not no_ui_respawn then
		InventoryUIRespawn() --havn't found any other way to make the ui display the changes
	end

	return false
end ]] 
