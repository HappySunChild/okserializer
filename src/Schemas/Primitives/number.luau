local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: types.NumberByteFormat): types.Schema<number>
	local info = getFormatInfo(format, "f32")

	local write = info.write
	local read = info.read
	local size = info.size

	return Schema "number" {
		write = write,
		read = read,
		size = function(): number
			return size
		end,

		validate = function(v: unknown): boolean
			return type(v) == "number"
		end,
	}
end
