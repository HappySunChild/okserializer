local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: types.NumberByteFormat): types.Schema<Vector2>
	local info = getFormatInfo(format, "f32")
	local write = info.write
	local read = info.read
	local size_bytes = info.size

	return Schema "Vector2" {
		write = function(b: buffer, offset: number, value: Vector2)
			write(b, offset, value.X)
			write(b, offset + size_bytes, value.Y)
		end,
		read = function(b: buffer, offset: number): Vector2
			local x = read(b, offset)
			local y = read(b, offset + size_bytes)

			return Vector2.new(x, y)
		end,
		size = function(): number
			return size_bytes * 3
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Vector2"
		end,
	}
end
