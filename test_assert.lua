local a = 10

local b = assert(a, "invalid a")
print(b) -- 10

local c = assert(a >= 10, "invalid a")
print(c) -- true

