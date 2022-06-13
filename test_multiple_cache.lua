local MULTIPLE_CACHE = require "multiple_cache"
local function table_length(t)
	local length = 0
	for _ in pairs(t) do
		length = length + 1
	end
	return length
end

local function check_result(multiple_cache, func)
    local t = {}
    for key, obj in multiple_cache:selectall() do
        t[key] = obj
    end
    func(t)
end

do
	local mc = MULTIPLE_CACHE:new({"c1", "c2", "c3"}, "id", "type")
    mc:set {id = 1, type = "type_1", x = 128, y = 129, name = "obj_1"}
	mc:set {id = 2, type = "type_1", x = 128, y = 130, name = "obj_2"}
    mc:commit("c3", "c2")
    mc:commit("c2", "c1")

    assert(mc:selectkey(1) ~= nil)
    mc:remove(1)

    check_result(mc, function(t)
        assert(table_length(t) == 1)
        assert(t[2])
        assert(t[2].name == "obj_2")
    end)

    mc:commit("c3", "c2")
    mc:commit("c2", "c1")

    mc:set {id = 1, type = "type_1", x = 128, y = 129, name = "obj_1"}
    mc:revert({"c3"})

    check_result(mc, function(t)
        assert(table_length(t) == 1)
        assert(t[2].name == "obj_2")
    end)

    mc:cleanup()
end
