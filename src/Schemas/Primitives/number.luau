local Types = require "../../Types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: Types.NumberByteFormat)
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
