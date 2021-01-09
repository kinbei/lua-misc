if not table.pack then
	function table.pack (...)
		return {n = select('#',...), ...}
	end
end

if not table.unpack then
	table.unpack = unpack 
end

local function table_length(t)
	local length = 0
	for k, v in pairs(t) do
		length = length + 1
	end
	return length
end

local function get_pairs_result(t)
	for k, v in pairs(t) do
		t[k] = v
	end
	return t
end

local create = require("cache_table")
local t = create({}, "player_id", "session_id", "profession")

t:insert({player_id = 100, session_id = 1, profession = 2})
t:insert({player_id = 101, session_id = 1, profession = 3})
t:insert({player_id = 102, session_id = 2, profession = 3})

-- query key
local r = t:query("player_id")
assert( table_length(r) == 3 )
assert( r[100].player_id == 100 )
assert( r[101].player_id == 101 )
assert( r[102].player_id == 102 )

-- query cache "session_id"
local r = t:query("session_id", 1 )
assert( table_length(r) == 2 )
assert( r[100].player_id == 100 )
assert( r[101].player_id == 101 )

-- query cache "profession"
local r = t:query("profession", 3 )
assert( table_length(r) == 2 )
assert( r[101].player_id == 101 )
assert( r[102].player_id == 102 )

local r = t:query("session_id", 10)
assert( table_length(r) == 0 )

local r = get_pairs_result(t:pairs_query("session_id", 1))
assert( table_length(r) == 2 )
assert( r[100].player_id == 100 )
assert( r[101].player_id == 101 )
