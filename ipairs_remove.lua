function ipairs_remove(tbl)
   local i = 0
   local remove = function()
      table.remove(tbl, i)
      i = i - 1
   end
   return function()
      i = i + 1
      if tbl[i] then
         return i, tbl[i], remove
      end
      return nil
   end
end

local t = { "a", "b", "c", "d", "e" }

for i, t, remove in ipairs_remove(t) do
   print(i, v)
   if v == "c" then remove() end
end

print("** After removal: **")

for i, v in ipairs(t) do
   print(i, v)
end
