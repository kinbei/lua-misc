local cache = require "cache"
local multiple_cache = {}

function multiple_cache:new(cache_names, key_field_name, ...)
    local c = {}
    c.caches = {}
    for _, field_name in ipairs({key_field_name, ...}) do
        assert(field_name ~= "REMOVED")
    end
    assert(#cache_names >= 1)
    for _, cache_name in ipairs(cache_names) do
        c.caches[cache_name] = cache:new(key_field_name, ...)
    end
    self.cache_names = cache_names
    self.key_field_name = key_field_name

	setmetatable(c, self)
    self.__index = self
    return c
end

function multiple_cache:set(obj)
    local cache_name = self.cache_names[#self.cache_names]
    local cache = self.caches[cache_name]
    local key = obj[self.key_field_name]
    if cache:selectkey(key) then
        cache:remove(key)
    end
    cache:add(obj)
end

function multiple_cache:remove(key)
    assert(self:selectkey(key))

    local cache_name = self.cache_names[#self.cache_names]
    local cache = self.caches[cache_name]
    local obj = cache:selectkey(key)
    if obj then
        cache:remove(key)
    else
        cache:add({
            [self.key_field_name] = key,
            REMOVED = true,
        })
    end
end

function multiple_cache:select(field_name, value)
    local t = {}
    for _, cache_name in ipairs(self.cache_names) do
        for key, obj in self.caches[cache_name]:select(field_name, value) do
            t[key] = obj
        end
    end

    for key, obj in pairs(t) do
        if obj[field_name] ~= value then
            t[key] = nil
        end
        if obj.REMOVED then
            t[key] = nil
        end
    end
    return next, t, nil
end

function multiple_cache:selectkey(key)
    for i = #self.cache_names, 1, -1 do
        local obj = self.caches[self.cache_names[i]]:selectkey(key)
        if obj then
            if not obj.REMOVED then
                return obj
            else
                return
            end
        end
    end
end

function multiple_cache:selectall()
    local t = {}
    for _, cache_name in ipairs(self.cache_names) do
        for key, obj in self.caches[cache_name]:selectall() do
            t[key] = obj
        end
    end

    for key, obj in pairs(t) do
        if obj.REMOVED then
            t[key] = nil
        end
    end
    return next, t, nil
end

function multiple_cache:revert(cache_names)
    for _, cache_name in ipairs(cache_names) do
        local cache = self.caches[cache_name]
        cache:clearall()
    end
end

function multiple_cache:commit(cache_name_1, cache_name_2)
    local cache_1 = assert(self.caches[cache_name_1])
    local cache_2 = assert(self.caches[cache_name_2])
    for _, obj in cache_1:selectall() do
        local key = obj[self.key_field_name]
        if cache_2:selectkey(key) then
            cache_2:remove(key)
        end
        cache_2:add(obj)
    end
    cache_1:clearall()
end

function multiple_cache:cleanup()
    for _, cache_name in ipairs(self.cache_names) do
        local cache = self.caches[cache_name]
        for key, obj in cache:selectall() do
            if obj.REMOVED then
                cache:remove(key)
            end
        end
    end
end

return multiple_cache