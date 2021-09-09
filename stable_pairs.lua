-- https://www.lua.org/manual/5.4/manual.html#pdf-next
-- The order in which the indices are enumerated is not specified, even for numeric indices.

local table_insert = table.insert
local table_sort = table.sort

local opairs = _G.pairs
_G.pairs = function(t)
	local st = {}
	for k, v in opairs(t) do
		table_insert(st, {k = k, v = v})
	end
	table_sort(st, function(a, b)
		-- Warning! This function is only guaranteed to work if all keys are strings or numbers.
		-- "number" < "string", so numbers will be sorted before strings.
		local type1, type2 = type(key1), type(key2)
		if type1 ~= type2 then
			return type1 < type2
		else
			return key1 < key2
		end
	end)

	local idx = 0
	local function n(t)
		while idx <= #st do
			idx = idx + 1
			local v = st[idx]
			if not v then
				return
			end

			if t[v.k] then
				return v.k, v.v				
			end
		end
		return
	end

	return n, t, nil
end

---
do
	print("example 1 ---")
	local t = {[1001] = 1, [1003] = 3, ["abc"] = "string_abc" }
	for k, v in pairs(t) do
		print(k, v)
	end
end

do
	print("example 2 ---")
	local t = {[1001] = 1, [1003] = 3, ["abc"] = "string_abc" }
	for k, v in pairs(t) do
		if t["abc"] then
			t["abc"] = nil
		end
		print(k, v)
	end
end
