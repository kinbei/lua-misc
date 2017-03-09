function pack( ... )
    return table.pack( ... )
end

function memoize( fn )
    local function fnKey( ... )
        local key = ""
        local args = pack( ... )
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
                values = pack( fn( ... ) )
                targetTable.__memoized[ key ] = values
            end

            if ( table.getn( values ) > 0 ) then
                return unpack( values )
            end

            return nil
        end,
        __forget = function( self ) self.__memoized = {} end,
        __memoized = {},
        __mode = "v",
    }

    return setmetatable( object, object )
end
