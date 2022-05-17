local mod = require "table-diff"
local table_diff = mod.diff
local table_patch = mod.patch
local inspect = require "inspect"

local function table_length(t)
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end
    return c
end

local function table_equal(a, b)
    if table_length(a) ~= table_length(b) then
        return false
    end

    for k, v in pairs(a) do
        if type(a[k]) == "table" and type(b[k]) == "table" then
            if not table_equal(a[k], b[k]) then
                return false
            end
        else
            if a[k] ~= b[k] then
                return false
            end
        end
    end
    return true
end

do
    local t1 = {
        a = 1,
        b = 2,
    }

    local t2 = {
        a = 11,
    }

    local diff = table_diff(t1, t2)
    assert(table_equal(diff, {
        del = { "b" },
        mod = {
          a = 11
        },
    }))

    t1 = table_patch(t1, diff)
    assert(table_equal(t1, t2))
end

do
    local t1 = {
        a = 1,
        b = 2,
        tt1 = {
            a = 1,
            b = 2,
        }
    }

    local t2 = {
        a = 11,
        tt1 = {
            a = 11,
        }
    }

    local diff = table_diff(t1, t2)
    assert(table_equal(diff, {
        del = { "b" },
        mod = {
          a = 11
        },
        sub = {
          tt1 = {
            del = { "b" },
            mod = {
              a = 11
            },
          }
        }
    }))

    t1 = table_patch(t1, diff)
    assert(table_equal(t1, t2))
end

