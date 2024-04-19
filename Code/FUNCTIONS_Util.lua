function is_valid_normal(normal)
	if normal:x() == 0 and normal:z() == 0 and normal:y() == 0 then
		return false
	end
	if abs(normal:x()) > 4096 and abs(normal:z()) > 4096 and abs(normal:y()) > 4096 then
		return false
	end
	return true
end


function assign_gren_prop()
	
    local grenadeProp = {
        FragGrenade       = {595   , "Stick_like", 6500, 	true},          
        HE_Grenade        = {600   , "Spherical", 4500, true},            
        HE_Grenade_1      = {470   , "Cylindrical", 4500, true},          
        PipeBomb          = {980   , "Long", 11000, true},            
        TearGasGrenade    = {610   , "Cylindrical", 4000, true},      
        ConcussiveGrenade = {370   , "Cylindrical", 3000, true},   
        FlareStick        = {580   , "Long", false, false},         
        GlowStick         = {270   , "Long", false, false},           
        Molotov           = {980   , "Bottle", 7000, true},                 
        SmokeGrenade      = {610   , "Cylindrical", 3500, true},        
        ToxicGasGrenade   = {610   , "Cylindrical", 4000, true},     
        ShapedCharge      = {1070  , "Stick_like", false, true},        
		
        ProximityC4       = {2000  , "Brick", false, true},             
        ProximityPETN     = {1800  , "Brick", false, true},            
        ProximityTNT      = {1500  , "Long", false, true},        
        RemoteC4          = {2000  , "Brick", false, true},                
        RemotePETN        = {1800  , "Brick", false, true},               
        RemoteTNT         = {1500  , "Long", false, true},                
        TimedC4           = {2000  , "Brick", false, true},                 
        TimedPETN         = {1800  , "Brick", false, true},                
        TimedTNT          = {1500  , "Long", false, true},            
	}
	
    ForEachPreset("InventoryItemCompositeDef", function (p)
        if grenadeProp[p.id] then
            p.r_mass = grenadeProp[p.id][1]
            p.r_shape = grenadeProp[p.id][2]
            p.r_timer = grenadeProp[p.id][3] -- Timer in milliseconds
            p.is_explosive = grenadeProp[p.id][4] -- Explosive or not
		end
	end)
end




function list_gren_shape()
	return {"Stick_like", "Spherical", "Cylindrical", "Bottle", "Brick", "Long",  ""}
end

function cRound(num)
	local numf
	local sign = 1
	if num < 0 then
		sign = -1
		num = -num
	end

local integerNum = num + 0.5
integerNum = integerNum - integerNum % 1

numf = sign * integerNum

numf = tostring(numf)
numf = string.format("%.0f", numf)
numf = tonumber(numf)
return numf
end



function cRoundFlt(value, step)
local step = step or 0.5
local remainder = value % step
if remainder < step / 2 then
return value - remainder
else
return value + (step - remainder)
end
end


function cRoundDown(num)
local numf = num
--local sign = 1

--if num < 0 then
-- sign = -1
-- num = -num
-- end

-- local integerNum = num + 0.5
-- print("num", integerNum)
-- print("num int", integerNum % 1)
-- integerNum = integerNum - integerNum % 1

-- numf = sign * integerNum

numf = tostring(numf)
numf = string.match(numf, "([%-%d]+)")
numf = tonumber(numf)

return numf
end

function EO_IsAI(unit)

local side = unit and unit.team and unit.team.side or ''
if (side == "player1" or side == "player2") then
return false
end
return true
end


function extractNumberWithSignFromString(str)
if not str then	
return false
end
local num = tonumber(string.match(str, "[+-]?%d+"))
if num then
return num
else
return false  
end
end