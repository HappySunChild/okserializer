local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: types.NumberByteFormat)
	local info = getFormatInfo(format, "f32")

	local write = info.write
	local read = info.read
	local size = info.size

	return Schema "number" {
		write = write,
		read = read,
		size = function()
			return size
		end,

		validate = function(v: unknown)
			return type(v) == "number"
		end,
	}
end
