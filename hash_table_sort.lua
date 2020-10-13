local function hash_table_sort(t, sort_func)
	local array = {}
	for k, v in pairs(t) do
		table.insert(array, {key = k, value = v})
	end
	table.sort(array, sort_func)
	return array
end
