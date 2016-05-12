local test1 = 1/0
local test2 = 0/0

print(test1) -- inf
print(test2) -- -nan / luajit:nan / lua5.1:-nan

local function test()
        print( 1 % 0 ) -- lua5.3:error attempt to perform 'n%0' / luajit:nan / lua5.1:-nan
end

local ok, err = xpcall(test, debug.traceback) -- it would be error in lua5.3+
print(ok)
print(err)
