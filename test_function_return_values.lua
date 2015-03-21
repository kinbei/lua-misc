local function test1()
	return 1, 2, 3
end

local function test2(a1, a, b, c, c1, d1)
	print(a1, a, b, c, c1, d1)
end

local function test3(a, b, c)
	print(a, b, c)
end

local function test4(a1, a, b, c)
  print(a1, a, b, c)
end

test2( 11, test1(), 12, 13 ) -- > 11      1       12      13      nil     nil
test3( test1() ) -- > 1, 2, 3
test4( 10, test1() ) --> 10, 1, 2, 3
