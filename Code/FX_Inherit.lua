function OnMsg.GetCustomFXInheritActorRules(rules)
	place_explosion_FXs()
	place_flashbang_FXs()
	-- EO_apply_inherit(rules)
end

--[[ function EO_apply_inherit(rules)
	local data = {
		-- {"ConcussiveGrenade", "ConcussiveGrenade_IED", "ConcussiveGrenade_IED_Misfired"},
		{"BlackPowder", "PipeBomb_Misfired"}}

	for _, entry in ipairs(data) do
		local category = entry[1]

		local tags = {table.unpack(entry, 2)}

		for _, tag in ipairs(tags) do
			rules[#rules + 1] = tag
			rules[#rules + 1] = category
		end
	end

end ]]

