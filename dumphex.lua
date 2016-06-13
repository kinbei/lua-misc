local strgsub = string.gsub
local strformat = string.format
local strbyte = string.byte

local function _dumphex(bytes)
  return strgsub(bytes, ".", function(x) return strformat("%02x ", strbyte(x)) end)
end
