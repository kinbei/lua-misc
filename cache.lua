local EMPTY_TABLE = {}
local support_types = {["string"] = true, ["number"] = true, ["boolean"] = true}

local function sync_cache(self, obj, field_name)
	local key = assert(obj[self.key_field_name])
	local value = obj[field_name]
	if value == nil then
		return
	end

	assert(support_types[type(value)])
	self.cache[field_name] = self.cache[field_name] or {}
	self.cache[field_name][value] = self.cache[field_name][value] or {}
	self.cache[field_name][value][key] = true
end

local cache = {}

function cache:new(key_field_name, ...)
	local c = {}
	c.key_field_name = key_field_name
	c.index_field_names = {}
	for _, field_name in ipairs({...}) do
		c.index_field_names[field_name] = true
	end
	c.objs = {}
	c.cache = {}

	setmetatable(c, self)
    self.__index = self
    return c
end

function cache:add(obj)
	local key = assert(obj[self.key_field_name])
	assert(self.objs[key] == nil, ("duplicate key `%s`"):format(key))
	self.objs[key] = obj

	for field_name in pairs(self.index_field_names) do
		sync_cache(self, obj, field_name)
	end
end

function cache:remove(key)
	assert(self.objs[key])
	self.objs[key] = nil
end

function cache:sync(obj, ...)
	local key = assert(obj[self.key_field_name])
	assert(self.objs[key] == obj, ("can not found key `%s`"):format(key))

	local field_names = {...}
	assert(#field_names >= 1)
	for _, field_name in ipairs(field_names) do
		assert(type(field_name) == "string")
		if self.index_field_names[field_name] then
			sync_cache(self, obj, field_name)
		end
	end
end

function cache:select(field_name, value)
	assert(value ~= nil)
	assert(self.index_field_names[field_name], ("must specify the field_name `%s` as index field name"):format(field_name))

	if not self.cache[field_name] then
		return next, EMPTY_TABLE, nil
	end

	if not self.cache[field_name][value] then
		return next, EMPTY_TABLE, nil
	end

	local obj
	local t = {}
	for key in pairs(self.cache[field_name][value]) do
		obj = self.objs[key]
		if not obj then
			self.cache[field_name][value][key] = nil
		else
			if obj[field_name] ~= value then
				self.cache[field_name][value][key] = nil
			else
				t[key] = obj
			end
		end
	end

	return next, t, nil
end

function cache:selectkey(key)
	return self.objs[key]
end

function cache:selectall()
    return next, self.objs, nil
end

function cache:empty()
	return not next(self.objs)
end

function cache:clear(field_name)
	self.cache[field_name] = nil
end

function cache:clearall()
	self.objs = {}
	self.cache = {}
end

return cache