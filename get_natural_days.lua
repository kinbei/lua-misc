function get_day_beginning_timestamp(time_stamp, i)
	local t = os.date("*t", time_stamp)
	t.hour = 0
	t.min = 0
	t.sec = 0
	return os.time(t)
end

-- 给出两个时间戳, 返回它们相差的天数(按自然天计算)
function get_natural_days(time_stamp_1, time_stamp_2)
	local t1 = func.get_day_beginning_timestamp(time_stamp_1)
	local t2 = func.get_day_beginning_timestamp(time_stamp_2)
	return math.floor( math.abs( t1 - t2 ) / (3600 * 24) )
end
