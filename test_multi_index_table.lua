local function table_length(t)
	local length = 0
	for k, v in pairs(t) do
		length = length + 1
	end
	return length
end

local create = require("multi_index_table")
local multi_key_table = create({"activity_id", "activity_type"})

local activity1 = {}
activity1.activity_id = 100
activity1.activity_type = 1

local activity2 = {}
activity2.activity_id = 200
activity2.activity_type = 1

local activity3 = {}
activity3.activity_id = 300
activity3.activity_type = 2

multi_key_table:insert( activity1.activity_id, activity1 )
multi_key_table:insert( activity2.activity_id, activity2 )
multi_key_table:insert( activity3.activity_id, activity3 )

-- query key
local r = multi_key_table:query( "activity_id", 100 )
assert( table_length(r) == 1 )
assert( r[100].activity_id == 100 )
assert( r[100].activity_type == 1 )

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

local r = multi_key_table:query( "activity_type", 3 )
assert( table_length(r) == 0 )
