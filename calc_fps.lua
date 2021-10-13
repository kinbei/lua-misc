-- now_func return the current time in milliseconds
local function get_calc_fps(now_func)
	local q = {head = 1, tail = 1}
	function q:push(v)
		self[self.tail] = v
		self.tail = self.tail + 1
	end

	function q:pop()
		if self.head == self.tail then
			self.head = 1
			self.tail = 1
			return nil
		else
			local r = self[self.head]
			self[self.head] = nil
			self.head = self.head + 1
			return r
		end
	end

	function q:size()
		if self.tail - self.head <= 0 then
			return 0
		else
			return self.tail - self.head
		end
	end

	local calc_fpx_count <const> = 120 -- Calculate estimate of framerate for user over the last 120 times.
	local accum = 0.0
	local time = now_func()

	return function()
		local current_time = now_func()
		local delta_time = current_time - time
		time = current_time

		if q:size() > calc_fpx_count then
			accum = accum - q:pop()
		end

		accum = accum + delta_time
		q:push(delta_time)
		
		if accum <= 0 then
			return 0.0
		end

		return 1000 / (accum / q:size())
	end
end

local now_func ; do
	local now = 10000

	function now_func()
		now = now + 1
		return now
	end
end
local calc_fps = get_calc_fps(now_func)

for i = 1, 240 do
	local fps = calc_fps()
	print(fps)
end
