function change_operation()
	SectorOperations.CraftCommonBase.Tick = function(self, merc)
		local sector = merc:GetSector()
		local progress_per_tick = self:ProgressPerTick(merc)
		sector.custom_operations = sector.custom_operations or {}
		sector.custom_operations[self.id] = sector.custom_operations[self.id] or {}
		local prev_progress = (sector.custom_operations[self.id].progress or 0)
		sector.custom_operations[self.id].progress = prev_progress + progress_per_tick
		local cur_progress = sector.custom_operations[self.id].progress
		local queue = SectorOperationItems_GetItemsQueue(sector.Id, self.id)
		local item_data
		local rem_progress
		repeat
			if next(queue) then
				item_data = queue[1]
			end
			if not item_data then
				self:Complete(sector)
				return
			end
			local mercs = gv_Squads[merc.Squad].units
			local recipe = CraftOperationsRecipes[item_data.recipe]
			local cur = sector.custom_operations[self.id].item_id
			if not cur or cur ~= item_data.item_id then
				sector.custom_operations[self.id].item_id = item_data.item_id
				sector.custom_operations[self.id].item_id_start = rem_progress and rem_progress > 0 and rem_progress or
									                                                  prev_progress
				rem_progress = 0
				-- get items
				for _, ingrd in ipairs(recipe.Ingredients) do
					-- local result, results = InventoryFindItemInMercs(mercs, ingrd.item, ingrd.amount)
					local rem = TakeItemFromMercs(mercs, ingrd.item, ingrd.amount)
					if rem > 0 then
						sector.custom_operations[self.id].item_id = false
						sector.custom_operations[self.id].item_id_start = 0
						CombatLog("important", T {
							788054483744,
							"Not enough parts to continue <em><activity></em> Operation in sector <SectorName(sector)>.",
							sector = sector,
							activity = self.display_name,
						})
						self:Complete(sector)
						merc:SetCurrentOperation("Idle")
						return
					end
				end
			end
			local cur_item_time = SectorOperation_CraftItemTime(sector.Id, self.id, item_data.recipe)
			if sector.custom_operations[self.id].item_id_start and cur_progress >=
								sector.custom_operations[self.id].item_id_start + cur_item_time then
				local used_time = sector.custom_operations[self.id].item_id_start + cur_item_time
				sector.custom_operations[self.id].item_id_start = 0
				sector.custom_operations[self.id].item_id = false
				local item = PlaceInventoryItem(recipe.ResultItem.item)

				if IsKindOf(item, "InventoryStack") then
					item.Amount = recipe.ResultItem.amount
				end

				---------
				if item.is_ied then
					item.ied_quality_stack = determine_IED_misfire_chance(item, merc)
				end
				---------

				local items = {item}

				AddItemsToSquadBag(merc.Squad, items)
				for idx, m in ipairs(mercs) do
					if #items <= 0 then
						break
					end
					local unit = gv_UnitData[m]
					unit:AddItemsToInventory(items)
				end
				-- update queue
				rem_progress = used_time
				local tbl = GetCraftOperationQueueTable(gv_Sectors[sector.Id], self.id)
				table.remove(tbl, 1)
				SetCraftOperationQueueTable(gv_Sectors[sector.Id], self.id, tbl)
				-- SectorOperation_ItemsUpdateItemLists()
			end
		until not next(queue) or (not rem_progress or rem_progress <= 0)
		self:CheckCompleted(merc, sector)
	end
end

function OnMsg.DataLoaded()
	change_operation()
end
