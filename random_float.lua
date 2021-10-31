local math_random = math.random
function random_float(min, max)
	return min + (math_random() * (max - min))
end

print( random_float(1.0002, 1.0006) )
