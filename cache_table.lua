local EMPTY_TABLE = {}

local function select(self, field_name, value)
	assert(value ~= nil)
	assert(self.index_field_names[field_name], ("must specify the field_name `%s` as index field name"):format(field_name))

	if not self.cache[field_name] then
		return next, EMPTY_TABLE, nil
	end

	if not self.cache[field_name][value] then
		return next, EMPTY_TABLE, nil
	end

	local obj
	local r = {}
	for key in pairs(self.cache[field_name][value]) do
		obj = self.objs[key]
		if not obj then
			self.cache[field_name][value][key] = nil
		else
			if obj[field_name] ~= value then
				self.cache[field_name][value][key] = nil
			else
				r[key] = setmetatable({}, {__index = obj})
			end
		end
	end

	return next, r, nil
end

local function selectkey(self, key)
	local obj = self.objs[key]
	if not obj then
		return
	else
		return setmetatable({}, {__index = obj})
	end
end

local function selectall(self)
    return next, self.objs, nil
end

local function _sync_cache(self, obj, field_name)
	local key = assert(obj[self.key_field_name])
	local value = assert(obj[field_name])
	assert(type(value) == "number" or type(value) == "string" or type(value) == "boolean")
	self.cache[field_name] = self.cache[field_name] or {}
	self.cache[field_name][value] = self.cache[field_name][value] or {}
	self.cache[field_name][value][key] = true
end

local function sync(self, syncobj, ...)
	local key = assert(syncobj[self.key_field_name])
	local obj = assert(self.objs[key], ("invalid key `%s`"):format(key))

	local field_names = {...}
	assert(#field_names >= 1)
	for _, field_name in ipairs(field_names) do
		assert(type(field_name) == "string")
		obj[field_name] = syncobj[field_name]

		if self.index_field_names[field_name] then
			_sync_cache(self, obj, field_name)
		end
	end
end

local function create(self, obj)
	assert(self.objs[self.key_field_name] == nil)
	local k = assert(obj[self.key_field_name])
	self.objs[k] = obj

	for field_name in pairs(self.index_field_names) do
		_sync_cache(self, obj, field_name)
	end
end

local function remove(self, key)
	assert(self.objs[key])
	self.objs[key] = nil
end

local function empty(self)
	return not next(self.objs)
end

local function new(key_field_name, ...)
	local m = {}
	m.key_field_name = key_field_name
	m.index_field_names = {}
	for _, field_name in ipairs({...}) do
		m.index_field_names[field_name] = true
	end
	m.objs = {}
	m.cache = {}

	m.create = create
	m.select = select
	m.selectkey = selectkey
	m.selectall = selectall
	m.sync = sync
	m.remove = remove
	m.empty = empty
	return m
end
return new
