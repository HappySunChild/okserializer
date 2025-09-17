local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: types.NumberByteFormat): types.Schema<vector>
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
		read = function(b: buffer, offset: number): vector
			local x = read(b, offset)
			local y = read(b, offset + byteCount)
			local z = read(b, offset + byteCount * 2)

			return vector.create(x, y, z)
		end,
		size = function(): number
			return byteCount * 3
		end,

		validate = function(value: unknown): boolean
			return type(value) == "vector"
		end,
	}
end
