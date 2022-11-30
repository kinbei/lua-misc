local mt = {
	__index = function(t, k)
		return t.__lastversion[k]
	end,
  __newindex = function(t, k, v)
    if t.__lastversion[k] ~= v then
      t.__change_keys[k] = true
      t.__lastversion[k] = v
    end
  end,
  __pairs = function (t)
      return function(t, key)
          return next(t.__lastversion, key)
      end, t
  end,
}

local function new(t)
    t = t or {}
    t.__change_keys = {}
	  t.__lastversion = {}
    return setmetatable(t, mt)
end
