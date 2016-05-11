function string.split(str, sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        string.gsub(str, pattern, function(c) fields[#fields+1] = c end)
        return fields
end

for k, v in pairs( string.split(test1(t), ";") ) do
	print(k, v)
end

