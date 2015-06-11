local function new()
        local mil_idx_table = {}
        mil_idx_table.t = {}

        function mil_idx_table:make_index(field_name)
                self.t[field_name] = {}
        end

        function mil_idx_table:insert(value)
                for field_name, _ in pairs(self.t) do
                        assert(value[field_name])
                        self.t[field_name][ value[field_name] ] = value
                end
        end

        function mil_idx_table:delete(field_name, v)
				local value = self.t[field_name][v]
			
                for field_name, _ in pairs(self.t) do
                        self.t[field_name][ value[field_name] ] = nil
                end
        end

        function mil_idx_table:query(field_name, v)
                return self.t[field_name][v]
        end

        return mil_idx_table
end

t = new()
t:make_index ("id")
t:make_index ("name")
t:insert { id = 1, name = "foo" }
t:insert { id = 2, name = "bar" }
assert( t:query("id", 1).name == "foo" )
assert( t:query("name", "bar").id == 2 )
t:delete("id", 1)
assert(t:query("name", "foo") == nil)
assert(t:query("id", "1") == nil)
t:delete("name", "bar")
assert(t:query("name", "bar") == nil)
assert(t:query("id", "2") == nil)


