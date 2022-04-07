local EMPTY_TABLE = {}

local function key(self, key)
	return self.kv[key]
end

local function select(self, index_field, cache_value)
	if not self.cache[index_field] then
		return EMPTY_TABLE
	end

	if not self.cache[index_field][cache_value] then
		return EMPTY_TABLE
	end

    local value
    local r = {}
	for key in pairs(self.cache[index_field][cache_value]) do
        value = self.kv[key]
		if not value then
			self.cache[index_field][cache_value][key] = nil
		else
			if value[index_field] ~= cache_value then
				self.cache[index_field][cache_value][key] = nil
			end
		end
		r[key] = value
	end

	return r
end

local function insert(self, value)
	local key = value[self.key_field]
    local mt = {}
	mt.__index = value
	mt.__newindex = function(t, k, v)
		if k == self.key_field then
			self.kv[value[k]] = nil
		end
		value[k] = v
		insert(self, value)
	end
	mt.__pairs = function(t, k, v)
		return next, value, nil
	end
	self.kv[key] = setmetatable({}, mt)

	--
	local cache_value
	for _, index_field in ipairs(self.index_fields) do
		cache_value = assert(value[index_field])
		assert(type(cache_value) == "number" or type(cache_value) == "string")
		self.cache[index_field] = self.cache[index_field] or {}
		self.cache[index_field][cache_value] = self.cache[index_field][cache_value] or {}
		self.cache[index_field][cache_value][key] = true
	end
end

local function remove(self, key)
	self.kv[key] = nil
end

local function create(key_field, ...)
	local m = {}
	m.key_field = key_field
	m.index_fields = {...}
	m.kv = {}
	m.cache = {}

	m.insert = insert
	m.key = key
	m.select = select
	m.remove = remove
	return m
end
return create
