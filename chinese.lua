local str = "Henry.T: 中文字符串判断"
local fontSize = 20
local lenInByte = #str
local width = 0

for i=1,lenInByte do
	local curByte = string.byte(str, i)
	local byteCount = 1;
	if curByte>0 and curByte<=127 then
		byteCount = 1
	elseif curByte>=192 and curByte<223 then
		byteCount = 2
	elseif curByte>=224 and curByte<239 then
		byteCount = 3
	elseif curByte>=240 and curByte<=247 then
		byteCount = 4
	end
	
	local char = string.sub(str, i, i+byteCount-1)
	i = i + byteCount -1
	
	if byteCount == 1 then
		width = width + fontSize * 0.5
	else
		width = width + fontSize
		print(char)
	end
end

print("length: "..width)
