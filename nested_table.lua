local function test1()
	local t = { a = 1, b = t }

	print( t.a )
	print( t.b )
end

local function test2()
	local t = { a = 1 }
	t.b = t
	print( t.b.b.b.b.b.a )
end

test2()
