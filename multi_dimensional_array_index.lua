-- coord  = {xx, xx, xx, ...}
-- bounds = {xx, xx, xx, ...}
local function multi_dimensional_array_index_func(bounds)
	local accelerate = {}
	local total = 1
	for i = #bounds, 1, -1 do
		accelerate[i] = total
		total = total * bounds[i]
	end

	return function(coord)
		local idx = 0
		for i = #coord, 1, -1 do
			if i == #coord then
				idx = idx + (accelerate[i] * coord[i])
			else
				idx = idx + (accelerate[i] * (coord[i] - 1))
			end
		end
		return idx
	end
end

do
	local idx = 0

	local bounds = {30, 40, 50}
	local func = multi_dimensional_array_index_func(bounds)

	for i = 1, bounds[1] do
		for j = 1, bounds[2] do
			for k = 1, bounds[3] do
				idx = idx + 1
				assert(func({i, j, k}) == idx, string.format("%d %d %d -> %d", i, j, k, idx))
			end
		end
	end
end

local function check(v1, v2, s)
	assert(v1 == v2, string.format("%s : actual value: %s", s, v1))
end

local test_case ; do
	local idx = 0
	local d = {}
	local bounds = {3, 4, 5, 6, 7, 8, 9}
	local func = multi_dimensional_array_index_func(bounds)

	local function f(bounds, dimension)
		if #bounds == dimension then
			for i = 1, bounds[dimension] do
				idx = idx + 1
				d[dimension] = i
				check(func(d), idx, string.format("{%s} -> %d", table.concat(d, ","), idx))
			end
			return
		end

		for i = 1, bounds[dimension] do
			d[dimension] = i
			f(bounds, dimension + 1)
		end
	end

	function test_case()
		f(bounds, 1)
	end
end
test_case()
