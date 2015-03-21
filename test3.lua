local inspect = require "inspect"

local t = {1, 2}

print( inspect( t ) )
print( inspect( loadfile("test_inspect_1.lua") ) )

