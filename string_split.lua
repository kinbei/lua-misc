function string.split(str, sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        string.gsub(str, pattern, function(c) fields[#fields+1] = c end)
        return fields
end


local t = {
	{item_id = 123, count = 10},
	{item_id = 456, count = 20},
	{item_id = 789, count = 30},
}

local function test1(t)
	local result = ""
	for _, v in pairs(t) do
		result = result .. tostring(v.item_id) .. ":" .. tostring(v.count) .. ";"
	end
	return result
end

for k, v in pairs( string.split(test1(t), ";") ) do
	print(k, v)
end
