local function setbit(x, y)
	return x | (1 << y)
end

local function unsetbit(x, y)
	return x & ~(1 << y)
end

local function getbit(x, y)
	return (x & ( 1 << y )) >> y
end

local function countbit(x)
	local c = 0
	while x > 0 do
		c = c + 1
		x = x >> 1
	end
	return c
end

---------------------
local function tobit(n)
    local t = {}
    for i = countbit(n) - 1, 0, -1 do
    	t[#t + 1] = tostring(getbit(n, i))
    end
    return table.concat(t)
end

---------------------
do
	assert(countbit(0) == 0)
	assert(countbit(1) == 1)
	assert(countbit(2) == 2)
	assert(countbit(3) == 2)
	assert(countbit(4) == 3)

	assert(tobit(0) == "")
	assert(tobit(1) == "1")
	assert(tobit(2) == "10")
	assert(tobit(3) == "11")
	assert(tobit(4) == "100")
end

---------------------
local function test_setbit(x, y)
	x = tonumber(x, 2)
	return tobit( setbit(x, y) )
end

local function test_unsetbit(x, y)
	x = tonumber(x, 2)
	return tobit( unsetbit(x, y) )
end

---------------------
assert(test_setbit("1110", 0) == "1111")
assert(test_unsetbit("1111", 0) == "1110")

assert(test_setbit("0111", 3) == "1111")
assert(test_unsetbit("1111", 3) == "111")
