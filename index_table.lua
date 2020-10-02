local EMPTY_TABLE = {}

local function query(self, index_name, index_value)
	if index_name == self.key_name then
		return self.tbl_kv
	end

	if not self.tbl_cache[index_name] then
		return EMPTY_TABLE
	end

	if not self.tbl_cache[index_name][index_value] then
		return EMPTY_TABLE
	end

	for k, v in pairs(self.tbl_cache[index_name][index_value]) do
		if not self.tbl_kv[k] then
			self.tbl_cache[index_name][index_value][k] = nil
		else
			if v[index_name] ~= index_value then
				self.tbl_cache[index_name][index_value][k] = nil
			end
		end
	end

	return self.tbl_cache[index_name][index_value]
end

local function insert(self, v)
	local k = v[self.key_name]

	--
	self.tbl_kv[k] = v

	--
	local index_name, index_value
	for _, index_name in ipairs(self.tbl_index_name) do
		index_value = v[index_name]
		assert(index_value)
		self.tbl_cache[index_name] = self.tbl_cache[index_name] or {}
		self.tbl_cache[index_name][index_value] = self.tbl_cache[index_name][index_value] or setmetatable({}, {__mode = "v"})
		self.tbl_cache[index_name][index_value][k] = v
	end
end

local function delete(self, key)
	self.tbl_kv[key] = nil
end

local function create(...)
	local m = {}
	m.key_name = select(1, ...)
	m.tbl_kv = {} -- = {[v.key] = v, ... }
	m.tbl_index_name = table.pack(select(2, ...)) -- = { index_name, ... }
	--[[
		tbl_cache = {
			[index_name] = {
				[index_value] = {
					[key] = v,
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
