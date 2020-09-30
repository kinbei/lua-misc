local EMPTY_TABLE = {}

local function query(self, index_name, index_value)
	if not self.tbl_cache[index_name] then
		return EMPTY_TABLE
	end

	if not self.tbl_cache[index_name][index_value] then
		return EMPTY_TABLE
	end

	for key, _ in pairs(self.tbl_cache[index_name][index_value]) do
		local v = self.tbl_kv[key]
		if not v then
			self.tbl_cache[index_name][index_value][key] = nil
		else
			if v[index_name] ~= index_value then
				self.tbl_cache[index_name][index_value][key] = nil
			else
				t[key] = v
			end
		end
	end

	return self.tbl_cache[index_name][index_value]
end

local function insert(self, v)
	assert(v[self.key_name])

	local k = v[self.key_name]
	self.tbl_kv[k] = v

	local index_value
	for _, index_name in ipairs(self.tbl_index_name) do
		index_value = v[index_name]
		assert(index_value)
		self.tbl_cache[index_name] = self.tbl_cache[index_name] or {}
		self.tbl_cache[index_name][index_value] = self.tbl_cache[index_name][index_value] or {}
		self.tbl_cache[index_name][index_value][k] = true
	end
end

local function delete(self, key)
	self.tbl_kv[key] = nil
end

local function create(key_name, tbl_index_name)
	local m = {}
	m.tbl_kv = {} -- = {[v.key] = v, ... }
	m.tbl_index_name = tbl_index_name -- = { index_name, ... }
	m.key_name = key_name
	--[[
		tbl_cache = {
			[index_name] = {
				[index_value] = {
					[key] = true,
					...
				},
				...
			},
			...
		}
	--]]
	m.tbl_cache = {}

	m.query = query
	m.insert = insert
	m.delete = delete
	m.update = insert

	return m
end

return create
