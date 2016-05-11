local function fib(n)
  if(n<=0) then return 0 end
  if(n<=1) then return 1 end
  return fib(n-1) + fib(n-2) 
end

local function fib1(n)
	local fibs={1,1}

	for i=3, n do
		fibs[i] = fibs[i-1] + fibs[i-2]
	end

	return fibs[n]
end

local function test_fib(n)
  print("Begin N=", n)
  local t1 = os.clock()*1000
  local x = fib(n)
  local t2 = os.clock()*1000
  print("N= ", n, "Time=", t2-t1, "ms", "Fib=",x)
end

test_fib(10)
