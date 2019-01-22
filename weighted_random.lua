-- tbl_weight = { 
-- 	[xx] = { id = xx, weight = xx },
-- 	...
-- }
local function weighted_random( tbl_weight, random_func, id, weight )
	random_func = random_func or math.random
	id = id or "id"
	weight = weight or "weight"
	
	local t = {}
	local total_index = #tbl_weight
	local total_weight = 0

	for _, v in pairs(tbl_weight) do
		assert( type(v[weight]) == "number" )

		total_weight = total_weight + v[weight]
		table.insert(t, { [id] = v[id], [weight] = v[weight] })
	end

	return function()
		local rand_index
		
		while true do
			rand_index = random_func(1, total_index)
			if random_func(1, total_weight) < t[rand_index].weight then
				return t[rand_index][id]
			end
		end
	end
end

----------------------------------------------------------------------------------------
math.randomseed( os.time() )

local t = {}
table.insert(t, { id = 1, weight = 400 } )
table.insert(t, { id = 2, weight = 30  } )
table.insert(t, { id = 3, weight = 100 } )
table.insert(t, { id = 4, weight = 8   } )
table.insert(t, { id = 5, weight = 30  } )
table.insert(t, { id = 6, weight = 500 } )
table.insert(t, { id = 7, weight = 20  } )
table.insert(t, { id = 8, weight = 200 } )
table.insert(t, { id = 9, weight = 40  } )
table.insert(t, { id = 10, weight = 70  } )
table.insert(t, { id = 11, weight = 300 } )
table.insert(t, { id = 12, weight = 500 } )
table.insert(t, { id = 13, weight = 350 } )
table.insert(t, { id = 14, weight = 20  } )
table.insert(t, { id = 15, weight = 480 } )
table.insert(t, { id = 16, weight = 250 } )
table.insert(t, { id = 17, weight = 500 } )
table.insert(t, { id = 18, weight = 50  } )
table.insert(t, { id = 19, weight = 300 } )
table.insert(t, { id = 20, weight = 500 } )

local f = weighted_random(t)

local result = {}
for i = 1, 4648 do
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
