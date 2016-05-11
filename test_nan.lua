local test1 = 1/0
local test2 = 0/0

print(test1) -- inf
print(test2) -- -nan / luajit:nan / lua5.1:-nan
print( 1 % 0 ) -- error attempt to perform 'n%0' / luajit:nan / lua5.1:-nan

 