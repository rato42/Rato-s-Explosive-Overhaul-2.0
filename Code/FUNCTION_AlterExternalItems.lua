function EO_alterExternalItems()
	if g_Classes["_22m_HE"] then
		g_Classes["_22m_HE"].BaseDamage = 32
		g_Classes["_22m_HE"].r_shrap_num = 500
		g_Classes["_22m_HE"].r_concussive_force = 5
		g_Classes["_22m_HE"].AdditionalHint = T(98765432561, "<EO_description_hints>")
	end
end
function OnMsg.ModsReloaded()
	EO_alterExternalItems()
end
function OnMsg.DataLoaded()
	EO_alterExternalItems()
end
function OnMsg.EnterSector()
	EO_alterExternalItems()
end
