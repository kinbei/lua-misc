local function trace_log(fmt, ...)
        local t = debug.getinfo( 2, "Sl" )
        print( string.format("%s:%s: " .. fmt, t.source, tostring(t.currentline), ...) )
end

function test_trace_log(info)
        local function abc()
                trace_log("test log")
                return 123
        end
        return abc
end

test_trace_log(nil)()
