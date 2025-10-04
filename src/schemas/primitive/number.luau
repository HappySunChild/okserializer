local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../utility/getFormatInfo"

return function(format: types.NumberByteFormat): types.Schema<number>
	local _info = getFormatInfo(format, "f32")
	local write, read, size = _info.write, _info.read, _info.size

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
