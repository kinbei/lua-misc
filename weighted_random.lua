-- tbl_weight = { 
-- 	[xx] = { id = xx, weight = xx },
-- 	...
-- }
local function weighted_random( tbl_weight, random_func, id, weight )
	random_func = random_func or math.random
	id = id or "id"
	weight = weight or "weight"

	local t = {}
	local total_weight = 0

	for _, v in pairs(tbl_weight) do
		assert( type(v[weight]) == "number" )
		total_weight = total_weight + v[weight]
		table.insert(t, { [id] = v[id], [weight] = v[weight] })
	end
	table.sort(t, function (a, b) return a[weight] > b[weight] end)

	return function()
		local rand = random_func(1, total_weight)
		local curweight = 0

		for _, v in ipairs(t) do
			curweight = curweight + v[weight]
			if rand <= curweight then
				return v[id]
			end
		end

		assert(false, string.format("%d %d", rand, curweight))
	end
end

----------------------------------------------------------------------------------------
math.randomseed( os.time() )

local t = {}
t[1] = { weight = 2000, id = 1 }
t[2] = { weight = 2000, id = 2 }
t[3] = { weight = 30, id = 3 }
t[4] = { weight = 40, id = 4 }
t[5] = { weight = 50, id = 5 }

local f = weighted_random(t)

local result = {}
for i = 1, 1500 do
	local id = f()
	result[id] = result[id] or 0
	result[id] = result[id] + 1
end

local r = {}
for k, v in pairs(result) do
	table.insert(r, { id = k, times = v })
end

table.sort(r, function(a, b) return a.times > b.times end)
for _, v in ipairs(r) do
	print(v.id, v.times)
end
