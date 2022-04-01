local function test(prefix, f)
	local ok, err = xpcall(f, debug.traceback)
	if not ok then
		print(prefix, err)
	end
end

local a = {}
a.__index = a
setmetatable(a, a)

a.value = 1
a.func = function()
	print("call func")
end

test("test func", function()
	a.func()
end)
test("test no func", function()
	a.n_func()
end)
test("test value", function()
	print(a.value)
end)
test("test no value", function()
	print(a.n_value)
end)
