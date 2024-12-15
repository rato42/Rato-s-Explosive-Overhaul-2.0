local original_DynamicSpawnLandmine_GameInit = DynamicSpawnLandmine.GameInit

function DynamicSpawnLandmine:GameInit()
    original_DynamicSpawnLandmine_GameInit(self)

    if self.class == "DynamicSpawnLandmine" then
        self.triggerRadius = (self.TriggerType == "Proximity" or self.TriggerType ==
                                 "Proximity-Timed") and
                                 (1 + (CurrentModOptions.extra_proximityExplosive_radius or 0)) or 0
        ObjModified(self)
        self:UpdateTriggerRadiusFx()
    end
end
