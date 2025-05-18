local Types = require "../../Types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: Types.NumberByteFormat)
	local info = getFormatInfo(format, "f32")
	local write = info.write
	local read = info.read
	local byteCount = info.size

	return Schema "vector" {
		write = function(b: buffer, offset: number, value: vector)
			write(b, offset, value.x)
			write(b, offset + byteCount, value.y)
			write(b, offset + byteCount * 2, value.z)
		end,
		read = function(b: buffer, offset: number)
			local x = read(b, offset)
			local y = read(b, offset + byteCount)
			local z = read(b, offset + byteCount * 2)

			return vector.create(x, y, z)
		end,
		size = function()
			return byteCount * 3
		end,

		validate = function(value: unknown)
			return type(value) == "vector"
		end,
	}
end
