------------ Descriptive CTH
function descriptiveCTH_compatibility()
    function DCth_LabelsOnMishapChance()
        return false
    end
end

function OnMsg.ModsReloaded()
    descriptiveCTH_compatibility()
end

function OnMsg.ApplyModOptions()
    descriptiveCTH_compatibility()
end

function OnMsg.DataLoaded()
    descriptiveCTH_compatibility()
end
------------------------------
