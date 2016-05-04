local function diff_date( time_1, time_2 )
        local t1_begin = math.floor( time_1 / ( 3600 * 24 ) )
        local t2_begin = math.floor( time_2 / ( 3600 * 24 ) )
        local diff = math.abs( t1_begin - t2_begin )
        return diff
end
