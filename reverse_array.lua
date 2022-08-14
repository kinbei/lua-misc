local function reverse_array(t)
    local len = #t
    for i = 1, len // 2 do
        t[i], t[len - i + 1] = t[len - i + 1], t[i]
    end
    return t
end
