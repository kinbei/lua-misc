local s = "do return { id = 1, map_type = 2, map_id = 2, name = \"abc\", } end "

local t = load(s)()
