local formats = require "../formats"
local types = require "../types"

local function getFormatInfo(
	format_key: types.NumberByteFormat?,
	default: types.NumberByteFormat
): types.ByteFormatInfo
	local info = formats[format_key]

	if default and info == nil then
		warn(
			`Unknown byte format '{format_key}', resorting to default {default}.`
		)

		info = formats[default]
	end

	if info == nil then
		error(`Unknown byte format '{format_key}'.`)
	end

	return info
end

return getFormatInfo
