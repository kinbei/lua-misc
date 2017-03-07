local t = {
  r={displayname="Red", name="Ruby", age=15, x=4, y=10},
  y={displayname="Blue", name="Trey", age=22, x=3, y=2},
  t={displayname="Red", name="Jack", age=20, x=2, y=3},
  h={displayname="Red", name="Tim", age=25, x=2, y=33},
  v={displayname="Blue", name="Bonny", age=10, x=2, y=0}
}

function allmatching(tbl, kvs)
  return function(t, key)
    repeat
      key, row = next(t, key)
      if key == nil then
        return
      end
      for k, v in pairs(kvs) do
        if row[k] ~= v then
          row = nil
          break
        end
      end
    until row ~= nil
    return key, row
  end, tbl, nil
end

for k, row in allmatching(t, {displayname="Red", x=2}) do
  print(k, row.name, row.x, row.y)
end
