-- 计算游戏升级所需能量, 保留小数点后两位
--[[
local t = table.pack(...)

local current_power = tonumber(t[1]) or 1000
local remain = tonumber(t[2]) or 1000

print(string.format("current_power = %s", current_power))
print(string.format("remain = %s", remain))

local total_power = 0
for i = 1, remain do
        total_power = total_power + current_power
        print(string.format("current_power = %s", current_power))
        current_power = current_power * 1.15
        current_power = current_power - current_power % 0.01
end

print(string.format("result : total_power = %s", total_power))
--]]
