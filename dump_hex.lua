local string_gsub = string.gsub
local string_format = string.format
local string_byte = string.byte

local function dump_hex(bytes)
	return string_gsub(bytes, ".", function(x) return string_format("%02X ", string_byte(x)) end)
end

return {
	dump_hex = dump_hex,
}
