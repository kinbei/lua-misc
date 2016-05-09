local function CountedTable(x)
	assert(type(x) == 'table', 'bad parameter #1: must be table')

	local new_t = {}
	local mt = {}

	-- `all` will represent the number of both
	local all = 0
	for k, v in pairs(x) do
		all = all + 1
	end

	mt.__newindex = function(t, k, v)
		if v == nil then
			if rawget(x, k) ~= nil then
				all = all - 1
			end
		else
			if rawget(x, k) == nil then
				all = all + 1
			end
		end

		rawset(x, k, v)
	end

	mt.__index = function(t, k)
		if k == 'totalCount' then return all
		else return rawget(x, k) end
	end

	return setmetatable(new_t, mt)
end

local bar = CountedTable { x = 23, y = 43, z = 334, [true] = true }

assert(bar.totalCount == 4)
assert(bar.x == 23)
bar.x = nil
assert(bar.totalCount == 3)
bar.x = nil
assert(bar.totalCount == 3)
bar.x = 24
bar.x = 25
assert(bar.x == 25)
assert(bar.totalCount == 4)
