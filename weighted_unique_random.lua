local function weighted_unique_random(tbl_weight, tbl_exists, random_func, id, weight)
        random_func = random_func or math.random
        id = id or "id"
        weight = weight or "weight"

        local t = {}
        local total_weight = 0

        for _, v in pairs(tbl_weight) do
                if not tbl_exists[v[id]] then
                        assert( type(v[weight]) == "number" )
                        total_weight = total_weight + v[weight]
                        table.insert(t, { [id] = v[id], [weight] = v[weight], value = v })
                end
        end
        table.sort(t, function (a, b) return a[weight] > b[weight] end )

        if total_weight == 0 then
                return nil
        end

        local rand = random_func(1, total_weight)
        local curweight = 0

        for _, v in ipairs(t) do
                curweight = curweight + v[weight]
                if rand <= curweight then
                        return v.value
                end
        end
        assert(false, string.format("%d %d", rand, curweight))
end

math.randomseed( os.time() )

local t = {}
t[1] = { weight = 2000, id = 1 }
t[2] = { weight = 2000, id = 2 }
t[3] = { weight = 30, id = 3 }
t[4] = { weight = 40, id = 4 }
t[5] = { weight = 50, id = 5 }

local r = {}

for i = 1, 5 do
        local v = weighted_unique_random(t, r, math.random)
        assert(v)
        r[v.id] = v

        print(v.id, v.weight)
end
assert( weighted_unique_random(t, r) == nil )

