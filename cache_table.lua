local EMPTY_TABLE = {}

local function query(self, cache_name, cache_value)
	if cache_name == self.key_name then
		if cache_value then
			local t = {}
			local v = self.tbl_kv[cache_value]
			t[v[cache_name]] = v
			return t
		else
			return self.tbl_kv
		end
	end

	if not self.tbl_cache[cache_name] then
		return EMPTY_TABLE
	end

	if not self.tbl_cache[cache_name][cache_value] then
		return EMPTY_TABLE
	end

	for k, v in pairs(self.tbl_cache[cache_name][cache_value]) do
		if not self.tbl_kv[k] then
			-- 已经删除, 但还未 gc
			self.tbl_cache[cache_name][cache_value][k] = nil
		else
			-- 值已经变更
			if v[cache_name] ~= cache_value then
				self.tbl_cache[cache_name][cache_value][k] = nil
			end
		end
	end

	return self.tbl_cache[cache_name][cache_value]
end

local function pairs_query(self, cache_name, cache_value)
	if cache_name == self.key_name then
		return self.tbl_kv[cache_name]
	end

	if not self.tbl_cache[cache_name] then
		return EMPTY_TABLE
	end

	if not self.tbl_cache[cache_name][cache_value] then
		return EMPTY_TABLE
	end

	local function next_func(t, key)
		local k, v
		while true do
			k, v = next(t, key)
			if not k then
				return
			end
		
			-- 已经删除, 但还未 gc
			if not self.tbl_kv[k] then
				self.tbl_cache[cache_name][cache_value][k] = nil
				goto continue
			end

			-- 值已经变更
			if v[cache_name] ~= cache_value then
				self.tbl_cache[cache_name][cache_value][k] = nil
				goto continue
			end

			do
				return k, self.tbl_cache[cache_name][cache_value][k]
			end
			::continue::
		end
	end

	return setmetatable(self.tbl_cache[cache_name][cache_value], {__pairs = function(t)
		return next_func, t
	end})
end

local function insert(self, v)
	local k = v[self.key_name]

	--
	self.tbl_kv[k] = v

	--
	local cache_name, cache_value
	for _, cache_name in ipairs(self.tbl_cache_name) do
		cache_value = v[cache_name]
		assert(cache_value)
		self.tbl_cache[cache_name] = self.tbl_cache[cache_name] or {}
		self.tbl_cache[cache_name][cache_value] = self.tbl_cache[cache_name][cache_value] or setmetatable({}, {__mode = "v"})
		self.tbl_cache[cache_name][cache_value][k] = v
	end
end

local function delete(self, key)
	self.tbl_kv[key] = nil
end

--[[
-- key_name: 主键名称, 保证唯一
-- cache_name: 缓存字段, 支持多个
--]]
local function create(t, ...)
	local m = {}
	m.key_name = select(1, ...)
	m.tbl_kv = {} -- = {[v.key] = v, ... }
	m.tbl_cache_name = table.pack(select(2, ...)) -- = { cache_name, ... }
	--[[
		tbl_cache = {
			[cache_name] = {
				[cache_value] = {
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
	m.pairs_query = pairs_query

	for _, v in pairs(t) do
		m:insert(v)
	end
	return m
end

return create
