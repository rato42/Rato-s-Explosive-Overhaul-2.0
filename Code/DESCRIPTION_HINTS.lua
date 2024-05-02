function OrdnanceProperties:GetEO_description_hints()
	
	return EO_grenade_format_hints(self)
end

function GrenadeProperties:GetEO_description_hints()
	return EO_grenade_format_hints(self)
end


function EO_grenade_format_hints(self)
	local formattedString = "<style CrosshairAPTotal>"

	local owner = self.owner and (not gv_SatelliteView and g_Units[self.owner] or gv_UnitData[self.owner]) or false

	local function getshape(self)
		local shapes = {
			Stick_like = "Stick",
			Spherical = "Spherical",
			Cylindrical = "Cylindrical",
			Bottle = "Bottle",
			Brick = "Brick",
			Long = "Long",
			Can = "Can",
			[""] = ""
		}

		return shapes[self.r_shape] or ""
	end



	local function getcanbounce(self)
		return self.CanBounce and "Yes" or "No"
	end

	local function getmass(self)
		local mass = self.r_mass
		if not mass then
			return ""
		end
		return mass .. " <color PDABrowserFlavorMedium>Grams</color>"
	end
	
	local function getconcussivef(self)
		local cf = self.r_concussive_force or 0 
		return  cf >3 and "High" or cf >2 and "Medium" or cf >1 and "Low" or cf == 0 and "None" or "Very Low"
	end


	local function getacc(self)
		local acc = self:get_throw_accuracy(owner) + 10 or 0 
		if acc > 0 then 
			return "+" .. abs(acc)
		elseif acc < 0 then
			return "-" .. abs(acc)
		end
		return acc
	end

	local function getfusetimer(self)
		local time = self.r_timer
		if not time or time == 0 then
			return false
		end
		return time/1000.0 .. " <color PDABrowserFlavorMedium>Seconds</color>"
	end



	
	local termList = {
		{"Fragmentation: ", get_FragLevel(self)},
		{"Concussive Force: ", getconcussivef(self)},
		{"Can Bounce: ", getcanbounce(self)},
		{"Fuse Timer: ", getfusetimer(self)}
	}
	
	if IsKindOf(self, "Grenade") then
		table.insert(termList, 1, {"Accuracy: ", getacc(self)})
		table.insert(termList, 3, {"Shape: ", getshape(self)})
		table.insert(termList, 5, {"Mass: ", getmass(self)})
	end

	for _, term in ipairs(termList) do
		if term[2] then
			formattedString = formattedString ..
			"<color PDABrowserFlavorMedium>" .. term[1] .. "</color>" ..
			"<color PDABrowserTextHighlight>" .. term[2] .. "</color>" ..
			--term[3] .. 
			"\n"
		end
	end

	formattedString = formattedString .. "</style>"

	return formattedString
end