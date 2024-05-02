function TFormat.MishapToText(chance)
	local chanceT
	-----------
	if type(chance) == "table" then
		chanceT = get_label_throwacc(chance[1])
		return T {
			789465182475,
			"Accuracy: <chanceText>",
			chanceText = chanceT,
		}
		------------
	elseif chance <= 0 then
		chanceT = MishapChanceToText.None
	elseif chance <= 5 then
		chanceT = MishapChanceToText.VeryLow
	elseif chance <= 15 then
		chanceT = MishapChanceToText.Low
	elseif chance <= 30 then
		chanceT = MishapChanceToText.Moderate
	elseif chance <= 50 then
		chanceT = MishapChanceToText.High
	elseif chance > 50 then
		chanceT = MishapChanceToText.VeryHigh
	end

	return T {
		138326583335,
		"Mishap Chance: <chanceText>",
		chanceText = chanceT,
	}
end
