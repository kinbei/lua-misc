--[[
multi_index_table
1. insert 进去的 value 必须是一个 table
2. 允许用不同的字段去索引找到相应的 value
3. 放进去的 value 必须定义的一个唯一索引值

milti_index_table = {
	tbl_field_index = {
		...
	},
	--
	tbl_key_index = {
		...
	},
	--
	key_field_name = "",
}
--]]

local function make_key_index(self, field_name)
	self.key_field_name = field_name
end

local function make_index(self, field_name)
	assert( self.key_field_name )
	assert( self.key_field_name ~= field_name )
	self.tbl_field_index[field_name] = {}
end

local function query(self, field_name, field_value)
	if field_name == self.key_field_name then
		return self.tbl_key_index[ field_value ] or {}
	else
		assert( self.tbl_field_index[field_name] )
		return self.tbl_field_index[field_name][field_value] or {}
	end
end

local function insert(self, value)
	assert( value[self.key_field_name] ~= nil )
	for field_name, _ in pairs(self.tbl_field_index) do
		assert( value[field_name] ~= nil )
	end

	local key = value[self.key_field_name]

	self.tbl_key_index[ key ] = value
	for field_name, t in pairs(self.tbl_field_index) do
		local i = value[field_name]
		t[i] = t[i] or {}
		t[i][key] = value
	end
end

local function delete(self, key)
	local value = self.tbl_key_index[key]
	self.tbl_key_index[key] = nil

	for field_name, t in pairs(self.tbl_field_index) do
		local i = value[field_name]		
		t[i][key] = nil
	end
end

local function create()
  local multi_index_table = {}
  multi_index_table.tbl_field_index = {}
  multi_index_table.tbl_key_index = {}
  multi_index_table.key_field_name = ""

	multi_index_table.make_key_index = make_key_index
	multi_index_table.make_index = make_index
	multi_index_table.query = query
	multi_index_table.insert = insert
	multi_index_table.delete = delete
  return multi_index_table
end

return create
