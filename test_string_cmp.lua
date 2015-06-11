local t = {}

table.insert(t, {k = "abc", v = 1})
table.insert(t, {k = "abd", v = 2})

table.sort( t, function(a, b) return tostring(a.k) < tostring(b.k) end  )

for _, v in ipairs(t) do
	print(v.k, v.v)
end
