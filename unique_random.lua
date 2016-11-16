--[[
--@ 在 [min, max] 的范围内生成 count 个不重复的随机数
--@ return = {x, x, x, ...}
--]]
function get_unique_random( min, max, count )
  -- assert( min > 0 )
  -- assert( max > 0 )
  -- assert( max >= min, string.format("%d %d", min, max) )

    local tbl_result = {}
    local t = {}

    while max >= min and count > 0 do
        local rnd = math.random( min, max )

        local ret = t[rnd] or rnd
        t[rnd] = t[max] or max

        max = max - 1

        table.insert( tbl_result, ret )
        count = count - 1
    end

    return tbl_result
end
