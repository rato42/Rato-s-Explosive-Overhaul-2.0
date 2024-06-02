function stack_props()
	InventoryStack.properties[#InventoryStack.properties + 1] = {
		id = "ied_quality_stack",
		editor = "table",
		default = {},
		no_edit = true,
	}
end
if not ratG_simple_ied_misfire then
	print("RATONADE - Changing Inventory Stack properties")
	stack_props()
end
