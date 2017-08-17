-- 给出两个时间戳, 返回它们相差的天数(按自然天计算)
local function get_natural_days( time_stamp_1, time_stamp_2 )
        local t1 = math.floor( time_stamp_1 / ( 3600 * 24 ) )
        local t2 = math.floor( time_stamp_2 / ( 3600 * 24 ) )
        return math.abs( t1 - t2 )
end
