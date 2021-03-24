local table_insert = table.insert
local table_concat = table.concat
local string_format = string.format
local ini = {}

local function log_error(fmt, ...)
	print(string.format(fmt, ...))
end

local PDATA_TYPE = {
	COMMENT = 1,
	BLANK = 2,
	SECTION = 3,
	KAYVALUE = 4,
	UNKNOWN = 5,
}

local PDATA_PATTERN = {
	{type = PDATA_TYPE.COMMENT,  patten = "^#(.*)$"},
	{type = PDATA_TYPE.BLANK,    patten = "^(%s*)$"},
	{type = PDATA_TYPE.SECTION,  patten = "^%[([%g%s]+)%].*$"},
	{type = PDATA_TYPE.KAYVALUE, patten = "^(.*)=([^\r\n#]*)#*([^\r\n]*)([\r\n]*)$"},
}

local tbl_pdata_func = {}
tbl_pdata_func[PDATA_TYPE.COMMENT] = function(line, tbl_capture, syntax_state)
	table_insert(syntax_state.tbl_line, line)
	return true
end

tbl_pdata_func[PDATA_TYPE.BLANK] = function(line, tbl_capture, syntax_state)
	table_insert(syntax_state.tbl_line, line)
	return true
end

tbl_pdata_func[PDATA_TYPE.SECTION] = function(line, tbl_capture, syntax_state)
	syntax_state.section = tbl_capture[1]
	table_insert(syntax_state.tbl_line, line)
	return true
end

tbl_pdata_func[PDATA_TYPE.KAYVALUE] = function(line, tbl_capture, syntax_state)
	table_insert(syntax_state.tbl_line, line)
	
	local section = syntax_state.section
	if not section then
		return false, string.format("can not found section, line:%d %s", #syntax_state.tbl_line, line)
	end

	local key, value, comment, new_line = tbl_capture[1], tbl_capture[2], tbl_capture[3], tbl_capture[4]
	syntax_state.tbl_kv[section] = syntax_state.tbl_kv[section] or {}
	syntax_state.tbl_kv[section][key] = {value = value, comment = comment, new_line = new_line, line_no = #syntax_state.tbl_line}
	return true
end

local function get_pdata_type(line)
	for _, v in ipairs(PDATA_PATTERN) do
		t = {line:match(v.patten)}
		if t[1] then
			return v.type, t
		end
	end

	return PDATA_TYPE.UNKNOWN
end

local function create_syntax_state()
	local syntax_state = {}
	syntax_state.section = nil
	syntax_state.tbl_kv = {} -- { [section] = {[key] = {value = value, comment = comment, new_line = new_line, line_no = line_no}, ...}, ... }
	syntax_state.tbl_line = {}
	return syntax_state
end

local function parse_ini_file(filename)
	local file = assert(io.open(filename, "r"), string.format("Failed to open file : %s", filename))
	local tbl_line = {}
	local pdata_func
	local syntax_state = create_syntax_state()

	for line in file:lines("*L") do
		local pdata_type, tbl_capture = get_pdata_type(line)
		if pdata_type == PDATA_TYPE.UNKNOWN then
			return false, string_format("can not parse line:%d %s", #tbl_line, line)
		end
		
		pdata_func = tbl_pdata_func[pdata_type]
		local success, errmsg = pdata_func(line, tbl_capture, syntax_state)
		if not success then
			return false, errmsg
		end
	end
	file:close()
	return true, syntax_state
end

local function set(filename, section, key, value)
	local success, syntax_state = parse_ini_file(filename)
	if not success then
		local errmsg = syntax_state
		print(errmsg)
		return
	end

	if not syntax_state.tbl_kv[section] then
		print(string.format("can not found section: %s", section))
		return
	end

	if not syntax_state.tbl_kv[section][key] then
		print(string.format("can not found key: %s - %s", section, key))
		return
	end

	syntax_state.tbl_kv[section][key].value = value
	local line_no = syntax_state.tbl_kv[section][key].line_no
	local comment = syntax_state.tbl_kv[section][key].comment
	local new_line = syntax_state.tbl_kv[section][key].new_line

	if comment and comment ~= "" then
		syntax_state.tbl_line[line_no] = string.format("%s=%s#%s%s", key, value, comment, new_line)
	else
		syntax_state.tbl_line[line_no] = string.format("%s=%s%s", key, value, new_line)
	end

	local file = assert(io.open(filename, "w"), string.format("Failed to open file : %s", filename))
	file:write(table_concat(syntax_state.tbl_line))
	file:close()
	return
end

ini.set = set
return ini
