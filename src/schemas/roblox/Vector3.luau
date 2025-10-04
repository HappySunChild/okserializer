local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../utility/getFormatInfo"

return function(format: types.NumberByteFormat): types.Schema<Vector3>
	local _info = getFormatInfo(format, "f32")
	local write, read, size = _info.write, _info.read, _info.size

	return Schema "Vector3" {
		write = function(b: buffer, offset: number, value: Vector3)
			write(b, offset, value.X)
			write(b, offset + size, value.Y)
			write(b, offset + size * 2, value.Z)
		end,
		read = function(b: buffer, offset: number): Vector3
			local x = read(b, offset)
			local y = read(b, offset + size)
			local z = read(b, offset + size * 2)

			return Vector3.new(x, y, z)
		end,
		size = function(): number
			return size * 3
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Vector3"
		end,
	}
end
