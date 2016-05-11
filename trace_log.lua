local function trace_log(fmt, ...)
        local t = debug.getinfo( 2, "nSl" )
        print( string.format("%s:%s - %s: " .. fmt, t.source, tostring(t.currentline), tostring(t.name), ...) )
end

function test_trace_log()
        local function abc()
                trace_log("test log")
        end
        abc()
end

test_trace_log()
