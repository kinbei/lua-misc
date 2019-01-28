local function query(self, field_name, field_value)
	if not self._tbl_cache[field_name] then
		return {}
	end

	if not self._tbl_cache[field_name][field_value] then
		return {}
	end

	local t = {}
	for key, _ in pairs(self._tbl_cache[field_name][field_value]) do
		local value = self._t[key]
		if not value then
			self._tbl_cache[field_name][field_value][key] = nil
		else
			if value[field_name] ~= field_value then
				self._tbl_cache[field_name][field_value][key] = nil
			else
				t[key] = value
			end
		end
	end
	return t
end

local function insert(self, key, value)
	self._t[key] = value

	if type(value) ~= "table" then
		return
	end
	
	local index_field_value
	for index_field_name, _ in pairs(self._tbl_index_field_name) do
		index_field_value = value[index_field_name]		

		self._tbl_cache[index_field_name] = self._tbl_cache[index_field_name] or {}
		self._tbl_cache[index_field_name][index_field_value] = self._tbl_cache[index_field_name][index_field_value] or {}
		self._tbl_cache[index_field_name][index_field_value][key] = true
	end
end

local function delete(self, key)
	self._t[key] = nil
end

local function create(tbl_field_name)
	local t = {}
	t._t = {} -- {[key] = value, ... }
	t._tbl_index_field_name = {} -- = { [field_name] = true, ... }
	t._tbl_cache = {} -- = { [field_name] = { [field_value] = { [key] = true }, ... }, ...  }

	t.query = query
	t.insert = insert
	t.delete = delete

	for _, v in ipairs(tbl_field_name) do
		t._tbl_index_field_name[v] = true
	end

	return t
end

return create
