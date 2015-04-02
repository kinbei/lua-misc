local function create_tbl()
	return setmetatable({}, {__index = function(_, func_name) return 
			function (...)
        			local tbl_args = table.pack(...)
        			print( string.format("call func(%s) %s ", func_name, table.concat(tbl_args, " ") ) )
			end
		end } )
end

local t = create_tbl()
t.test1(1)
t.test2(2, 3)

