local enabled
function rat_printGR(...)
	local enabled 
	
	if enabled then
		print(...)
	end
end

function DbgAddVector_rat(attack_args, a, b , color)
	if true then return end
	if not attack_args or attack_args.prediction then
		return
	end
	DbgAddVector(a,b,color)
end


function rat_printBounce(...)
	local enabled --= true
	
	if enabled then
		print(...)
	end
end

function DbgAddText_rat(attack_args, text, pos, color)
	if true then return end
	if not attack_args or attack_args.prediction then
		return
	end
	DbgAddText(text, pos, color)
end

function DbgAddCircle_rat(attack_args, a, b , color)
	if true then return end
	if not attack_args or attack_args.prediction then
		return
	end
	DbgAddCircle(a,b,color)
end

function DbgAddCircle_collide_test(pos, r, c)
	--local enabled = true
	if enabled then
		DbgAddCircle(pos, r, c)
	end
end
	
function DbgAddCircle_devi(a, b , color)
	--local enabled = true
	if enabled then
		DbgAddCircle(a,b,color)
	end
	
end	

function DbgAddVector_devi(a, b , color)
	--local enabled = true
	if enabled then
		DbgAddVector(a,b,color)
	end
	
end	

function DbgAddCircle_ai_adj(a,b,c)
	--local enabled = true
	if enabled then
		DbgAddCircle(a,b,c)
	end
end

function DbgAddVector_ai_adj(a,b,c)
	--local enabled = true
	if enabled then
		DbgAddVector(a,b,c)
	end
end
