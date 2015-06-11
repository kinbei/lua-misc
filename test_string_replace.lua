
local value = "{type = 3,value=100,percent=5000,value_grow=10,percent_grow=100},\r\n{type = 3,value=120,percent=5100,value_grow=12,percent_grow=120},\r\n{type = 3,value=140,percent=5200,value_grow=14,percent_grow=140},"

print( value )

value = string.gsub(value, "\r\n", "")
print( value )
