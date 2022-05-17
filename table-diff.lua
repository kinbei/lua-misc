local support_types = {["string"] = true, ["number"] = true, ["table"] = true}

local function diff(a, b)
    local r = {mod = {}, del = {}, sub = {}}

    for k, v in pairs(a) do
        if not support_types[type(a[k])] then
            error(("unsupport %s"):format(type(a[k])))
        elseif type(a[k]) == "table" and type(b[k]) == "table" then
            local d = diff(a[k], b[k])
            if next(d) then
                r.sub[k] = d
            end
        elseif b[k] == nil then
            r.del[#r.del+1] = k
        elseif b[k] ~= v then
            r.mod[k] = b[k]
        end
    end

    for k, v in pairs(b) do
        if not support_types[type(b[k])] then
            error(("un support %s"):format(type(a[k])))
        elseif a[k] == nil then
            r.mod[k] = b[k]
        end
    end

    for k, v in pairs(r) do
        if not next(v) then
            r[k] = nil
        end
    end

    return r
end

local function patch(a, diff)
    if diff.sub then
        for k, v in pairs(diff.sub) do
            a[k] = patch(a[k], v)
        end
    end

    if diff.del then
        for _, v in pairs(diff.del) do
            a[v] = nil
        end
    end

    if diff.mod then
        for k, v in pairs(diff.mod) do
            a[k] = v
        end
    end

    return a
end

return {
    diff = diff,
    patch = patch,
}
