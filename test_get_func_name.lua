function prettyinfo(info) 
   local function abc()
       return 123
   end 
   return abc
end

local function get_func_dbginfo(func)
	local t = debug.getinfo( prettyinfo(a), "Sl" )
	return string.format( "%s:%s-%s", t.source, tostring(t.linedefined), tostring(t.lastlinedefined) )
end


print( get_func_dbginfo( prettyinfo(nil) ) )
