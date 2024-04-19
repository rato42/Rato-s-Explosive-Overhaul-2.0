


---- try rotate radius




--[[ function generateConeVectors(numVectors, args)
    local vectors = {}
    local phis = {}
    local thetas = {}

    -- Extract parameters from args
    local axisDirection = args.direction
    local coneAngle = math.rad(args.angle_deg)
    local axisAngle = math.rad(args.dir_angle/60)

    -- Calculate unit vector in the direction of axis
    local axis = {axisDirection:x(), axisDirection:y(), axisDirection:z()}
    local length = math.sqrt(axis[1]^2 + axis[2]^2 + axis[3]^2)
    axis = {axis[1] / length, axis[2] / length, axis[3] / length}

    -- Calculate theta angle to align with the x-axis in the xy-plane
    local theta =  axisAngle  -- Adjust if necessary based on the coordinate system
	local phi = math.acos(axis[3])


	print("theta", theta)
	print("phi", phi)    -- Generate evenly spaced points on a cone
    for i = 1, numVectors do
		-- Calculate theta angle around the cone's axis
		local theta_i = 2 * math.pi * (i - 1) / numVectors
		
		-- Rotate theta angle by theta to align with the direction vector
		local theta_rotated = theta + theta_i
		
		-- Calculate phi angle within the cone's aperture
		local phi_i = math.acos(1 - 2 * (i - 1) / numVectors) * coneAngle
        

		-- Calculate Cartesian coordinates of the vector in the rotated coordinate system
		local x_rotated = math.sin(phi_i) * math.cos(theta_rotated)
		local y_rotated = math.sin(phi_i) * math.sin(theta_rotated)
		local z_rotated = math.cos(phi_i)
		
		-- Rotate vector back to original coordinate system
		local x = x_rotated * math.cos(phi) * math.cos(theta) - y_rotated * math.sin(theta) + z_rotated * math.sin(phi) * math.cos(theta)
		local y = x_rotated * math.cos(phi) * math.sin(theta) + y_rotated * math.cos(theta) + z_rotated * math.sin(phi) * math.sin(theta)
		local z = -x_rotated * math.sin(phi) + z_rotated * math.cos(phi)

        -- Store the vector and angles
		--print(i, x, y, z)
        table.insert(vectors, {x, y, z})
		table.insert(phis, phi_i)
		table.insert(thetas, theta_i)
    end

    return vectors, phis, thetas
end ]]

--[[ function generateConicalVectors(numVectors, args)
    local vectors = {}
    local phis = {}
    local thetas = {}

    local coneAngle = args.angle_deg * math.pi / 180

    -- Generate vectors on a sphere
    for i = 1, numVectors do
        local theta = math.random() * 2 * math.pi
        local phi = math.acos(math.random() * 2 - 1) -- Random phi between 0 and pi

        -- Project onto the cone
        phi = phi * math.cos(coneAngle)

        local x = math.sin(phi) * math.cos(theta)
        local y = math.sin(phi) * math.sin(theta)
        local z = math.cos(phi)

        table.insert(vectors, {x, y, z})
        table.insert(phis, phi)
        table.insert(thetas, theta)
    end

    return vectors, phis, thetas
end ]]








function generateShrapnelPositionsInCone(numPositions, radius, center, args)
    local positions = {}
    local phis_list = {}


    -- Convert degrees to radians
    local angle_radians = args.angle_deg * math.pi / 180

	local spread_p = center:SetZ(center:z() + args.radius)
	spread_p = RotateAxis(spread_p, point(1,0,0), 90*60, center)
	DbgAddCircle(spread_p,1000)
	local spread_orient = CalcOrientation(center, spread_p)
	print("spread ang", spread_orient, "dir angle", args.dir_angle)
	local sign = spread_orient < args.dir_angle and -1 or 1
	--local _, angle_offset = GetAxisAngle(spread_p, args.direction)
	--local angle_offset = spread_p - args.direction
	local angle_offset = (args.dir_angle - spread_orient )* sign
	--local angle_offset = CalcOrientation(spread_p, args.direction) --* sign--args.dir_angle - spread_orient
	print(angle_offset)

    -- Generate random angles within the cone
    for i = 1, numPositions do
        local theta = math.random() * 2 * math.pi  -- Random angle around the center axis
        local h = math.random() * radius * math.tan(angle_radians / 2)  -- Random height within the cone

        -- Convert polar coordinates to Cartesian coordinates
        local x = center:x() + math.cos(theta) * h
        local y = center:y() + math.sin(theta) * h
        local z = center:z() + math.sqrt(radius^2 - h^2)

        -- Store the position
        local p = point(x, y, z)
		p = RotateAxis(p, point(1,0,0), 90*60, center)
		--p = p + angle_offset
		p = RotateAxis(p,point(0,0,1), angle_offset, center)
		--p = RotateRadius(radius, angle_offset, center)
        table.insert(positions, p)
        table.insert(phis_list, theta)  -- Store the theta angle for potential use
    end

    return positions, phis_list
end




function generateShrapnelPositions(numPositions, radius, center, cone_args)
	local positions = {}
	local phis_list = {}
	local theta_list ={}
	local vectors, phis, thetas
	local original_radius = radius
	if cone_args then
		--vectors, phis, thetas = generateConeVectors(numPositions, cone_args)
		return generateShrapnelPositionsInCone(numPositions, radius, center, cone_args)
		--radius = cone_args.radius
	else
		vectors, phis, thetas= generateShrapnelVectors(numPositions)
	end
--[[ 		if cone_angle then
		for i, vector in ipairs(vectors) do
			local vector_point = point(vector[1],vector[2], vector[3])
			DbgAddVector(center, vector_point - center)
			local angle = CalcOrientation(center, vector)
			if angle < cone_angle/2 then
				DbgAddVector(center, vector - center)
			end
		end
	end ]]
	local maxRandomOffset = const.SlabSizeX/2
	-- Scale the vectors by the radius to get positions and then shift them by the center position
	for i, v in ipairs(vectors) do
		--print(v)
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
		--point = RotateRadius(point:Dist(center), math.random(-2.0,2.0)*60, center)
		if cone_args then
			
			local angle = CalcOrientation(center, point)
		
			if angle < cone_args.angle_deg*60 then
				DbgAddVector(center, point - center, const.clrBlue)
			else
				DbgAddVector(center, point - center)
			end
		end
		
		table.insert(positions, point)
		table.insert(phis_list, phis[i])
		table.insert(theta_list, thetas[i])
	end
--[[ 	if cone_args then
		local xtnd_positions = {}
		for i, position in ipairs(positions) do
			table.insert(xtnd_positions, Lengthen(position, original_radius))
		end
		positions = xtnd_positions
	end ]]
	return positions, phis_list, theta_list
end






function generateShrapnelVectors(numVectors)
	local vectors = {}
	local phis ={}
	local thetas = {}
	-- Golden ratio to distribute points evenly
	local goldenRatio = (1 + math.sqrt(5)) / 2

	-- Generate evenly spaced points on a sphere
	for i = 1, numVectors do
		local theta = 2 * math.pi * (i - 1) / goldenRatio 
		
		local phi = math.acos(-1 + 2 * (i - 0.5) / numVectors)--*0.7 ---- bias to north hemisphere. 
		--local phi = math.acos(math.random() * 2 - 1) *0.9
		phi = phi >= 1.5 and phi *0.7 or phi*1.5 ---- bias to the sides of the sphere

		local x = math.sin(phi) * math.cos(theta)
		local y = math.sin(phi) * math.sin(theta)
		local z = math.cos(phi)

		table.insert(vectors, {x, y, z})
		table.insert(phis, phi)
		table.insert(thetas, theta)
	end

	return vectors, phis, thetas
end



function findAngleAtRadius(theta, radius1, radius2)
	theta = math.rad(theta) -- Convert degrees to radians
	local ratio = radius1 / radius2
	local angle = math.atan(math.tan(theta) * ratio)
	return angle
end