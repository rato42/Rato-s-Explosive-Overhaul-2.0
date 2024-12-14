local original_DynamicSpawnLandmine_GameInit = DynamicSpawnLandmine.GameInit

function DynamicSpawnLandmine:GameInit()
    original_DynamicSpawnLandmine_GameInit(self)
    self.triggerRadius =
        (self.TriggerType == "Proximity" or self.TriggerType == "Proximity-Timed") and
            (1 + (CurrentModOptions.extra_proximityExplosive_radius or 0)) or 0

    ObjModified(self)
    Landmine.UpdateTriggerRadiusFx(self)
end
