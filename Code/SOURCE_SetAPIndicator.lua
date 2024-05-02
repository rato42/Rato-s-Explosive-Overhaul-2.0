function SetAPIndicator(ap, reason, customText, appending, force_update, extraAp)
	if CheatEnabled("CombatUIHidden") then
		ClearAPIndicator()
		return
	end

	----------------
	if CthVisible() and ap == 1 and reason == "mishap-chance" and type(customText["num"]) == "table" then

		local num = customText["num"][1]

		customText["num"] = num
		customText[1] = 98215746952
		customText[2] = "Accuracy: <num>"
	end
	------------

	local existingReasonIdx = table.find(APIndicator, "reason", reason) or #APIndicator + 1
	local existingIndicator = APIndicator[existingReasonIdx]
	if not force_update and existingIndicator and existingIndicator.ap == ap and existingIndicator.extraAp == extraAp then
		return
	end

	if not ap then
		if APIndicator[existingReasonIdx] then
			table.remove(APIndicator, existingReasonIdx)
			ObjModified(APIndicator)
		end
	else
		APIndicator[existingReasonIdx] = {
			reason = reason,
			ap = ap or 0,
			customText = customText,
			appending = appending,
			extraAp = extraAp,
		}
		ObjModified(APIndicator)
	end
end

