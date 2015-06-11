local s = string.pack(">s2", 'a')

for i = 1, #s do
  print(string.byte( s, i ))
end

local function func(text)
  local success, s, len = pcall(string.unpack, ">s2", text) 
  if not success then
     return nil, text 
  else
     return len, s
  end
end


print( func(s) )
