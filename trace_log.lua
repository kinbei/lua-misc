local function trace_log(fmt, ...)
	local t = debug.getinfo( 2, "nSl" )
	local result = string.format("%s:%s", t.source, tostring(t.currentline))
	if t.name then
		result = result .. string.format(" - %s", tostring(t.name))
	end
	result = result .. string.format(": " .. fmt, ...)
	print( result )
end

function test_trace_log()
        local function abc()
                trace_log("test log")
        end
        abc()
end

test_trace_log()
