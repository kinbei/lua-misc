local function hash_table_sort(t, sort_func)
	local array = {}
	for _, v in pairs(t) do
		table.insert(array, v)
	end
	table.sort(array, sort_func)
	return array
end
