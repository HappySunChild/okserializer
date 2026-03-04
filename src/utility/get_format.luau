local formats = require("../formats")
local types = require("../types")

local function get_format(index: types.NumberFormat?, default: types.NumberFormat): types.NumberSpec
	if index == nil then
		return formats[default]
	end

	return formats[index] or formats[default]
end

return get_format
