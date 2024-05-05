function stack_props()
	InventoryStack.properties[#InventoryStack.properties + 1] = {
		id = "ied_quality_stack",
		editor = "table",
		default = {},
		no_edit = true,
	}
end

stack_props()
