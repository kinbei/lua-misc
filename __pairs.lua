local m={
January=31, February=28, March=31, April=30, May=31, June=30,
July=31, August=31, September=30, October=31, November=30, December=31,
}

setmetatable(m,{__pairs=
function (t)
    local k=nil
    return
    function ()
        local v
        repeat k,v=next(t,k) until v==31 or k==nil
        return k,v
    end
end})

for k,v in pairs(m) do print(k,v) end
