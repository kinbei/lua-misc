local create = require "multi_index_table"
local multi_key_table = create()

local function table_length(t)
	local count = 0
	for _, _ in pairs(t) do
		count = count + 1
	end
	return count
end

local activity1 = {}
activity1.activity_id = 100
activity1.activity_type = 1

local activity2 = {}
activity2.activity_id = 200
activity2.activity_type = 1

local activity3 = {}
activity3.activity_id = 300
activity3.activity_type = 2


multi_key_table:make_key_index( "activity_id" )
multi_key_table:make_index( "activity_type" )

multi_key_table:insert( activity1 )
multi_key_table:insert( activity2 )
multi_key_table:insert( activity3 )

-- query key
local r = multi_key_table:query( "activity_id", 100 )
assert( r.activity_id == 100 )
assert( r.activity_type == 1 )

-- query index "activity_type"
local r = multi_key_table:query( "activity_type", 1 )
assert( table_length(r) == 2 )
assert( r[100] )
assert( r[100].activity_type == 1 )
assert( r[100].activity_id == 100 )
assert( r[200] )
assert( r[200].activity_type == 1 )
assert( r[200].activity_id == 200 )

-- query index "activity_type"
local r = multi_key_table:query( "activity_type", 2 )
assert( table_length(r) == 1 )
assert( r[300] )
assert( r[300].activity_type == 2 )
assert( r[300].activity_id == 300 )
