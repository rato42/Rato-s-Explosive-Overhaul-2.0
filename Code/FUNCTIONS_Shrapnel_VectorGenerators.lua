function generateShrapnelPositionsInCone(numPositions, radius, center, args)
	local positions = {}
	local phis_list = {}

	local angle_radians = args.angle_deg * math.pi / 180

	local spread_p = center:SetZ(center:z() + args.radius)
	spread_p = RotateAxis(spread_p, point(1, 0, 0), 90 * 60, center)
	local spread_orient = CalcOrientation(center, spread_p)
	local angle_offset = (args.dir_angle - spread_orient)

	for i = 1, numPositions do
		local theta = math.random() * 2 * math.pi
		local h = math.random() * radius * math.tan(angle_radians / 2)

		local x = center:x() + math.cos(theta) * h
		local y = center:y() + math.sin(theta) * h
		local z = center:z() + math.sqrt(radius ^ 2 - h ^ 2)

		local p = point(x, y, z)
		p = RotateAxis(p, point(1, 0, 0), 90 * 60, center)
		p = RotateAxis(p, point(0, 0, 1), angle_offset, center)

		table.insert(positions, p)
		-- table.insert(phis_list, theta)  -- Store the theta angle for potential use
	end

	return positions -- , phis_list
end

function generateShrapnelPositions(numPositions, radius, center, cone_args)
	local positions = {}
	local phis_list = {}
	local theta_list = {}
	local vectors, phis, thetas = generateShrapnelVectors(numPositions)

	local maxRandomOffset = const.SlabSizeX * 0.3

	for i, v in ipairs(vectors) do
		-- print(v)
		local x = v[1] * radius + center:x()
		local y = v[2] * radius + center:y()
		local z = v[3] * radius + center:z()

		local xOffset = math.random(-maxRandomOffset, maxRandomOffset)
		local yOffset = math.random(-maxRandomOffset, maxRandomOffset)
		local zOffset = math.random(-maxRandomOffset, maxRandomOffset)

		x = x + xOffset
		y = y + yOffset
		z = z + zOffset

		local point = point(x, y, z)

		table.insert(positions, point)
		table.insert(phis_list, phis[i])
		table.insert(theta_list, thetas[i])
	end

	return positions, phis_list, theta_list
end

function generateShrapnelVectors(numVectors)
	local vectors = {}
	local phis = {}
	local thetas = {}

	local goldenRatio = (1 + math.sqrt(5)) / 2

	for i = 1, numVectors do
		local theta = 2 * math.pi * (i - 1) / goldenRatio

		local phi = math.acos(-1 + 2 * (i - 0.5) / numVectors) -- *0.7 ---- bias to north hemisphere. 
		-- local phi = math.acos(math.random() * 2 - 1) *0.9
		phi = phi >= 1.5 and phi * 0.8 or phi * 1.2 ---- bias to the equator, a little to the north

		local x = math.sin(phi) * math.cos(theta)
		local y = math.sin(phi) * math.sin(theta)
		local z = math.cos(phi)

		table.insert(vectors, {x, y, z})
		table.insert(phis, phi)
		table.insert(thetas, theta)
	end

	return vectors, phis, thetas
end

