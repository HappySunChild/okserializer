local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(format: types.NumberByteFormat): types.Schema<Vector3>
	local info = getFormatInfo(format, "f32")
	local write = info.write
	local read = info.read
	local size_bytes = info.size

	return Schema "Vector3" {
		write = function(b: buffer, offset: number, value: Vector3)
			write(b, offset, value.X)
			write(b, offset + size_bytes, value.Y)
			write(b, offset + size_bytes * 2, value.Z)
		end,
		read = function(b: buffer, offset: number): Vector3
			local x = read(b, offset)
			local y = read(b, offset + size_bytes)
			local z = read(b, offset + size_bytes * 2)

			return Vector3.new(x, y, z)
		end,
		size = function(): number
			return size_bytes * 3
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Vector3"
		end,
	}
end
