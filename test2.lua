local function test1(t)
	local result = ""
	for _, v in pairs(t) do
		result = result .. tostring(v.item_id) .. ":" .. tostring(v.count) .. ";"
	end
	return result
end

local function test2(t)
	local result = ""
	for _, v in pairs(t) do
                result = result .. string.format("%d:%d;", v.item_id, v.count) 
        end
        return result
end

local t = {
{item_id = 123, count = 10},
{item_id = 456, count = 20},
{item_id = 789, count = 30},
}

--[[
real    0m3.593s
user    0m3.588s
sys     0m0.002s
]]
-- for i = 1, 1000000 do test1(t) end

--[[
real    0m2.679s
user    0m2.678s
sys     0m0.001s
]]
-- for i = 1, 1000000 do test2(t) end

function string.split(str, sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        string.gsub(str, pattern, function(c) fields[#fields+1] = c end)
        return fields
end

for k, v in pairs( string.split(test1(t), ";") ) do
	print(k, v)
end

