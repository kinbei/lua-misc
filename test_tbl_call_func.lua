-- pack an argument list into a table.
-- @param ... any arguments
-- @return a table with field n set to the length
-- @return the length
-- @function table.pack
if not table.pack then
    function table.pack (...)
        return {n=select('#',...), ...}
    end
end

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
