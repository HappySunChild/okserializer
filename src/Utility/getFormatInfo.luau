local types = require "../types"

local formats = require "../Formats"

local function getFormatInfo(formatKey: types.NumberByteFormat?, default: types.NumberByteFormat): types.ByteFormatInfo
	local info = formats[formatKey]

	if default and info == nil then
		warn(`Unknown byte format '{formatKey}', resorting to default {default}.`)

		info = formats[default]
	end

	if info == nil then
		error(`Unknown byte format '{formatKey}'.`)
	end

	return info
end

return getFormatInfo
