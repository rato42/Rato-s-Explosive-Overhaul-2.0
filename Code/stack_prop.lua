function stack_props()
	InventoryStack.properties[#InventoryStack.properties + 1] = {
		id = "ied_quality_stack",
		editor = "table",
		default = {12, 14, 70, 20, 10, 8, 8, 1, 9, 10},

		no_edit = true,
	}
end

stack_props()

--[[ function InventoryStack:MergeStack(otherItem, amount)
	print("--------------------------------------------------inventory stack mergestack")

	local other_stack_table = table.copy(otherItem.ied_quality_stack)

	local self_stack_table = table.copy(self.ied_quality_stack)
	print("other", other_stack_table)
	print("self", self_stack_table)
	for _, v in ipairs(other_stack_table) do
		table.insert(self_stack_table, v)
	end
	self.ied_quality_stack = self_stack_table
	print("joined", self.ied_quality_stack)
	assert(otherItem.class == self.class)
	amount = amount or otherItem.Amount
	local to_add = Min(amount, otherItem.Amount, self.MaxStacks - self.Amount)
	self.Amount = self.Amount + to_add
	otherItem.Amount = otherItem.Amount - to_add
	return otherItem.Amount <= 0
end ]]

function AddItemsToInventory(inventoryObj, items, bLog)
	-- local pos, reason
	for i = #items, 1, -1 do
		local item = items[i]

		if IsKindOf(item, "InventoryStack") and item.is_ied then
			local item_amount = item.Amount
			local item_table = item.ied_quality_stack or {}

			print("------ initial item table", item_table, "n", #item_table, "initial item amount", item_amount)
			print("--------- loop start ------- ")
			inventoryObj:ForEachItemDef(item.class, function(curitm, slot_name, item_left, item_top)
				if slot_name ~= "Inventory" then
					return
				end

				if curitm.Amount < curitm.MaxStacks then
					local to_add = Min(curitm.MaxStacks - curitm.Amount, item_amount) -- item.Amount)
					-- print("curitm amount", curitm.Amount)
					local curitem_new_amnt = curitm.Amount + to_add
					item_amount = item_amount - to_add
					-- print("curitem_new_amnt", curitem_new_amnt, "item_amount", item_amount)
					-- local item_new_amnt = item.Amount - to_add
					local curitem_table = curitm.ied_quality_stack or {}
					print("_____________APPLYING MERGE from AddItemsToInventoryi")
					for i = 1, to_add do
						if item_table[i] then
							table.insert(curitem_table, item_table[i])
						end
						-- table.remove(item_table, i)
					end
					local new_item_table = {}
					for i = to_add + 1, #item_table do
						if item_table[i] then
							table.insert(new_item_table, item_table[i])
						end
					end
					item_table = new_item_table
					curitm.ied_quality_stack = curitem_table
					print("curitem_table", curitem_table, "n", #curitem_table, "curitem new amnt", curitem_new_amnt)
					print("inside loop item table, pós process", item_table, "n", #item_table, "item amnt", item_amount)

					-- curitm.Amount = curitm.Amount + to_add
					-- curitm.drop_chance = Max(curitm.drop_chance, item.drop_chance)
					--[[ 					if bLog then
						Msg("InventoryAddItem", inventoryObj, curitm, to_add)
					end ]]
					-- item.Amount = item.Amount - to_add
					if item_amount <= 0 then
						return "break"
					end
					--[[ 					if item.Amount <= 0 then
						DoneObject(item)
						item = false
						table.remove(items, i)
						return "break"
					end ]]
				end
			end)
			item.ied_quality_stack = item_table
		end
		--[[ 		if item then
			pos, reason = inventoryObj:AddItem("Inventory", item)
			if pos then
				if bLog then
					Msg("InventoryAddItem", inventoryObj, item, IsKindOf(item, "InventoryStack") and item.Amount or 1)
				end
				table.remove(items, i)
			end
		else
			pos = true
		end ]]
	end
	--[[ 	ObjModified(inventoryObj)
	return pos, reason ]]
	return rat_original_AddItemsToInventory(inventoryObj, items, bLog)
end

function MoveItem(args)
	local item = args.item
	if item.is_ied then
		local dest_x = args.dest_x or args.x
		local dest_y = args.dest_y or args.y
		local s_item_at_dest = args.s_item_at_dest
		local merge_up_to_amount = args.merge_up_to_amount
		if merge_up_to_amount then
			print("------------item", item, "merge_up_to_amount arg", merge_up_to_amount)
		end
		local amount = args.amount
		local local_changes = args.local_changes
		local dest_container = args.dest_container
		local dest_container_slot_name = args.dest_container_slot_name or args.dest_slot
		local item_at_dest = dest_x and dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x, dest_y)
		if item_at_dest == item then
			item_at_dest = false
		end
		local item_is_stack = IsKindOf(item, "InventoryStack")
		local item_table, dest_item_table, item_num, dest_item_num
		if item_at_dest then
			local merging = item_is_stack and item.class == item_at_dest.class and item_at_dest.Amount < item_at_dest.MaxStacks
			if merging then
				print("_______________ APPLYING MERGE _______________ merging IED from move item")
				local to_add = Min(item_at_dest.MaxStacks - item_at_dest.Amount, item.Amount, amount or max_int)
				item_table = item.ied_quality_stack
				item_num = item.Amount
				dest_item_num = item_at_dest.Amount
				dest_item_table = item_at_dest.ied_quality_stack
				local new_tabuao = table.copy(item.ied_quality_stack)
				for i, v in ipairs(item_at_dest.ied_quality_stack) do
					table.insert(new_tabuao, v)
				end
				print("item table n", #item_table)
				print("dest item table n", #dest_item_table)
				print("tabuao", new_tabuao, "n", #new_tabuao)
				local item_at_dest_new_amount = item_at_dest.Amount + to_add
				local item_new_amount = item.Amount - to_add
				local new_item_at_dest_table = {}
				local new_item_table = {}
				print("item_at_dest_new_amount", item_at_dest_new_amount)
				for i = 1, item_at_dest_new_amount do
					-- print(i)
					-- print("tabuao #", #new_tabuao)
					if new_tabuao[i] then
						table.insert(new_item_at_dest_table, new_tabuao[i])
					end
				end

				-- for i = #new_item_at_dest_table + 1, #new_tabuao do
				for i = item_at_dest_new_amount + 1, #new_tabuao do

					-- print(i)
					-- print("tabuao #", #new_tabuao)
					if new_tabuao[i] then
						table.insert(new_item_table, new_tabuao[i])
					end
				end

				item_at_dest.ied_quality_stack = new_item_at_dest_table
				item.ied_quality_stack = new_item_table

				print("AMOUNTS NEW   === item at dest", item_at_dest_new_amount, "item ", item_new_amount)
				print("item table n", #(item.ied_quality_stack))
				print("dest_Item table n", #(item_at_dest.ied_quality_stack))
			end
			--[[ 			else
				local partial_stack_merge = false
				local merge_stacks = item_is_stack and not dest_x and not amount
				local local_stack_changes = local_changes and local_changes.local_stack_changes or false
				local local_items_moved = local_changes and local_changes.local_items_moved or false
				local p_pos, reason
				if merge_stacks then
					local is_mergable, new_amount = MergeStackIntoContainer(dest_container, dest_container_slot_name, item, "check",
					                                                        merge_up_to_amount, local_stack_changes)
					print("is mergeable", is_mergable, "new amount", new_amount)
					if not is_mergable or new_amount > 0 then
						-- no part of the stack is mergable or only part is mergable, check for free slot
						p_pos, reason = dest_container:CanAddItem(dest_container_slot_name, item, dest_x, dest_y, local_items_moved)
						print("---- p_pos, reason", p_pos, reason)
						if not p_pos then
							if not is_mergable then
								-- no room and we can't merge any part of the stack
								print("-----no room and we can't merge any part of the stack")
								return "move failed, no part of the stack is transferable and dest inventory refused item", reason, sync_unit
							else
								print(
													"-----the item is only partially mergable, i.e. part of the stack will not move, but old_amount - new_amount will be moved;")

								-- the item is only partially mergable, i.e. part of the stack will not move, but old_amount - new_amount will be moved;
								partial_stack_merge = new_amount -- let caller know this is the case
								print("partial_stack_merge", partial_stack_merge)
							end
						end
					end
				end
			end ]]
		end
	end

	-- print("item at dest", s_item_at_dest)

	print("moving")
	rat_original_MoveItem(args)

	print("-------after move")
	print(item.ied_quality_stack, "n", #(item.ied_quality_stack), "item amnt", item.Amount)
end

function MergeStackIntoContainer(dest_container, dest_slot, item, check, up_to_amount, local_changes)
	local original_loc_changes = local_changes
	if not check and item.is_ied then
		print("-----------------------------------------------------merging container")
		print("check?", check)
		print("local changes", local_changes)
		print("up to amount", up_to_amount)

		local function get_local_changes(i)
			return local_changes and local_changes[i] or 0
		end

		local a = Min(item.Amount, up_to_amount)
		----
		local item_table = item.ied_quality_stack or {}
		print("item table n", #item_table)
		----
		local cls = item.class
		local other_stack_items = {}
		dest_container:ForEachItemInSlot(dest_slot, false,
		                                 function(item_at_dest) -- this loops in reverse, so in order to fill stacks in a nice way its 2ON
			if item_at_dest.class == cls then
				table.insert(other_stack_items, item_at_dest)
			end
		end)

		table.sort(other_stack_items, function(a, b)
			local a_a = a.Amount + get_local_changes(a)
			local b_a = b.Amount + get_local_changes(a)
			return a_a > b_a
		end)
		-- print("-------------item", item, item.Amount, "table", item.ied_quality_stack)
		for iii, item_at_dest in ipairs(other_stack_items) do
			-- print("looping distribution merge", iii)

			local item_at_dest_table = item_at_dest.ied_quality_stack or {}
			print("item_at_dest_table n ", #item_at_dest_table)

			local to_add = item_at_dest.MaxStacks - (item_at_dest.Amount + get_local_changes(item_at_dest))
			print("to add", to_add)
			to_add = Min(to_add, a)
			-- print("itemdest", item_at_dest, item_at_dest.Amount, "to add", to_add, "table", item_at_dest.ied_quality_stack)
			if to_add > 0 then
				a = a - to_add
				if not check then
					--[[ 					print("----------would be merging items", "original 'a'", a)
					print("to add =", to_add)
					print("item amount would be ", item.Amount - to_add)
					print("dest item amount would be", item_at_dest.Amount + to_add) ]]
					for i = 1, to_add do
						print("dest i", i)
						if item_table[i] then
							table.insert(item_at_dest_table, item_table[i])
						end
					end
					local new_item_table = {}
					for i = to_add + 1, #item_table do
						print("item i", i)
						if item_table[i] then
							table.insert(new_item_table, item_table[i])
						end
					end
					item_table = new_item_table
					item_at_dest.ied_quality_stack = item_at_dest_table
					-- item.Amount = item.Amount - to_add
					-- item_at_dest.Amount = item_at_dest.Amount + to_add
					--[[ 				elseif local_changes then
					print("local changes")
					print("loc item", local_changes[item])
					print("item at dest", local_changes[item_at_dest])
					print("---- pos process:")
					local_changes[item] = (local_changes[item] or 0) - to_add
					local_changes[item_at_dest] = (local_changes[item_at_dest] or 0) + to_add
					print("loc item", local_changes[item])
					print("item at dest", local_changes[item_at_dest]) ]]
				end
				if a <= 0 then
					break
				end
			end
		end
		item.ied_quality_stack = item_table
	end
	rat_original_MergeStackIntoContainer(dest_container, dest_slot, item, check, up_to_amount, original_loc_changes)
	--[[ 	assert(a >= 0)
	return a ~= item.Amount, a ]]
end

-- InventoryStack.original_SplitStack = original_provisory -- InventoryStack.SplitStack
function InventoryStack:SplitStack(newStackAmount, splitIfEqual)
	if self.is_ied then
		-- print("splitting ied")
		local old_stack_table = table.copy(self.ied_quality_stack)
		-- print("original stack", old_stack_table)
		local newItem = rat_original_InventoryStack_SplitStack(self, newStackAmount, splitIfEqual) -- self:original_SplitStack(newStackAmount, splitIfEqual)

		local new_stack_amount = newItem.Amount
		local splited_stack_amount = self.Amount

		local old_stack_contents = {}
		local new_stack_contents = {}

		for i = 1, new_stack_amount do
			if old_stack_table[i] then
				table.insert(new_stack_contents, old_stack_table[i])
			end
		end

		for i = 1 + new_stack_amount, #old_stack_table do
			if old_stack_table[i] then
				table.insert(old_stack_contents, old_stack_table[i])
			end
		end

		self.ied_quality_stack = old_stack_contents

		newItem.ied_quality_stack = new_stack_contents
		print("split, old item tbl", self.ied_quality_stack)
		print("split, new item tbl", newItem.ied_quality_stack)
		return newItem
	end

	return rat_original_InventoryStack_SplitStack(self, newStackAmount, splitIfEqual) -- self:original_SplitStack(newStackAmount, splitIfEqual)

end

--[[ function InventoryStack:SplitStack(newStackAmount, splitIfEqual)
if newStackAmount < 0 then
	return
end
if not splitIfEqual and newStackAmount >= self.Amount or splitIfEqual and newStackAmount > self.Amount then
	return
end

local newItem = PlaceInventoryItem(self.class)
if not newItem then
	return
end
self.Amount = self.Amount - newStackAmount
newItem.Amount = newStackAmount

return newItem
end ]]
