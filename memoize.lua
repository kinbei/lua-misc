if not table.pack then
    function table.pack (...)
        return {n=select('#',...), ...}
    end
end

if not table.unpack then
    table.unpack = unpack 
end

function memoize( fn )
    local function fnKey( ... )
        local key = ""
        local args = table.pack( ... )
        for i = 1, args.n do
            key = key .. "[" .. tostring( args[ i ] ) .. "]"
        end
        return key
    end

    local object = {
        __call  = function( targetTable, ... )
            local key = fnKey( ... )
            local values = targetTable.__memoized[ key ]

            if ( values == nil ) then
                values = table.pack( fn( ... ) )
                targetTable.__memoized[ key ] = values
            end

            if ( values.n > 0 ) then
                return table.unpack( values )
            end

            return nil
        end,
        __forget = function( self ) self.__memoized = {} end,
        __memoized = {},
        __mode = "v",
    }

    return setmetatable( object, object )
end

local function fn1(...)
        return ...
end

local m1 = memoize( fn1 )
local t = m1( 1, 2, 3 )

print( m1(1, 2, 3) )
