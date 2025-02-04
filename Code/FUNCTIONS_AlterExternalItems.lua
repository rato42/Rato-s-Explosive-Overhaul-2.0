function EO_alterExternalItems()
    local _40fragshrap, _40fragconcussivf
    if g_Classes["_40mmFragGrenade"] then
        _40fragshrap = g_Classes["_40mmFragGrenade"].r_shrap_num
        _40fragconcussivf = g_Classes["_40mmFragGrenade"].r_concussive_force
    end
    if g_Classes["_22m_HE"] then
        g_Classes["_22m_HE"].BaseDamage = 32
        g_Classes["_22m_HE"].r_shrap_num = _40fragshrap or 350
        g_Classes["_22m_HE"].r_concussive_force = _40fragconcussivf or 4
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
