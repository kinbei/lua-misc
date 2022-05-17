local support_types = {["string"] = true, ["number"] = true, ["table"] = true}

local function diff(a, b)
    local r = {mod = {}, del = {}, sub = {}}

    for k, v in pairs(a) do
        if not support_types[type(a[k])] then
            error(("un support %s"):format(type(a[k])))
        elseif type(a[k]) == "table" and type(b[k]) == "table" then
            r.sub[k] = diff(a[k], b[k])
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

    return r
end

local function patch(a, diff)
    for k, v in pairs(diff.sub) do
        a[k] = patch(a[k], v)
    end

    for _, v in pairs(diff.del) do
        a[v] = nil
    end

    for k, v in pairs(diff.mod) do
        a[k] = v
    end

    return a
end

return {
    diff = diff,
    patch = patch,
}
