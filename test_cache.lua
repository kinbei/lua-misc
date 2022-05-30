local function table_length(t)
	local length = 0
	for _ in pairs(t) do
		length = length + 1
	end
	return length
end

local create_cache = require "cache"

do
	local cache = create_cache("id", "type")

	cache:add {id = 1, type = "type_1", x = 128, y = 129, name = "obj_1"}
	cache:add {id = 2, type = "type_1", x = 128, y = 130, name = "obj_2"}
	cache:add {id = 3, type = "type_2", x = 128, y = 131, name = "obj_3"}

	-- select index
	do
		local c = {}
		for k, v in cache:select("type", "type_1") do
			c[k] = v
		end
		assert( table_length(c) == 2 )
		assert( c[1].name == "obj_1" )
		assert( c[2].name == "obj_2" )
	end

	-- key
	do
		local obj = assert(cache:selectkey(1))
		assert( obj.name == "obj_1" )
	end

	-- change index value & select
	do
		local obj_3 = assert(cache:selectkey(3))
		obj_3.type = "type_1"
        cache:sync(obj_3, "type")

		local c = {}
		for k, v in cache:select("type", "type_1") do
			c[k] = v
		end

		assert( table_length(c) == 3 )
		assert( c[1].name == "obj_1" )
		assert( c[2].name == "obj_2" )
		assert( c[3].name == "obj_3" )
	end
end

-------------------------------------------------------------------------------------------------
do
	-- remove
	local cache = create_cache("id", "type")
	cache:add {id = 1, type = "type_1", x = 128, y = 129, name = "obj_1"}
	cache:add {id = 2, type = "type_1", x = 128, y = 130, name = "obj_2"}
	cache:add {id = 3, type = "type_2", x = 128, y = 131, name = "obj_3"}

	cache:remove(1)
	assert(cache:selectkey(1) == nil)

	local c = {}
	for k, v in cache:select("type", "type_1") do
		c[k] = v
	end
	assert( table_length(c) == 1 )
	assert( c[2].name == "obj_2" )
end

-------------------------------------------------------------------------------------------------
do
	-- empty values
	local cache = create_cache("id", "type", "tag")
	cache:add {id = 1, type = "type_1", x = 128, y = 129, name = "obj_1"}
	cache:add {id = 2, type = "type_1", x = 128, y = 130, name = "obj_2"}
	cache:add {id = 3, type = "type_2", x = 128, y = 131, name = "obj_3"}

	local obj_3 = assert(cache:selectkey(3))
	obj_3.tag = false
	cache:sync(obj_3, "tag")

	local c = {}
	for k, v in cache:select("tag", false) do
		c[k] = v
	end

	assert( table_length(c) == 1 )
	assert( c[3].name == "obj_3" )
end
