UndefineClass('cancel_shot_flashbang')
DefineClass.cancel_shot_flashbang = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	msg_reactions = {
		PlaceObj('MsgReaction', {
			Event = "StatusEffectAdded",
			Handler = function (self, obj, id, stacks)
				local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
				if not reaction_idx then return end
				
				local function exec(self, obj, id, stacks)
				if IsKindOf(obj, "Unit") then
					obj:InterruptPreparedAttack()
					obj:ActivatePerk("MeleeTraining")
					obj:RemoveStatusEffect("BandageInCombat")
					obj:RemoveStatusEffect("CancelShot")
					obj:UpdateMeleeTrainingVisual()
				end
				end
				local _id = GetCharacterEffectId(self)
				if _id == id then exec(self, obj, id, stacks) end
				
			end,
		}),
	},
	DisplayName = T(192684063690, --[[ModItemCharacterEffectCompositeDef cancel_shot_flashbang DisplayName]] "Cancel readied attack"),
	Description = T(335808529700, --[[ModItemCharacterEffectCompositeDef cancel_shot_flashbang Description]] "Removes <color EmStyle>Overwatch</color> and <color EmStyle>Pin Down</color>."),
	Icon = "UI/Icons/Perks/CancelShotPerk",
}

