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

	if type(value) == "table" then
		for field_name, field_value in pairs(value) do
			self._tbl_cache[field_name] = self._tbl_cache[field_name] or {}
			self._tbl_cache[field_name][field_value] = self._tbl_cache[field_name][field_value] or {}
			self._tbl_cache[field_name][field_value][key] = true
		end
	end
end

local function delete(self, key)
	self._t[key] = nil
end

local function create()
	local t = {}
	t._t = {} -- {[key] = value, ... }
	t._tbl_cache = {} -- = { [field_name] = { [field_value] = { [key] = true }, ... }, ...  }

	t.query = query
	t.insert = insert
	t.delete = delete

	return t
end

return create
