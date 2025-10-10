local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(format: types.NumberByteFormat): types.Schema<Vector2>
	local _info = formats.get(format, "f32")
	local write, read, size = _info.write, _info.read, _info.size

	return Schema "Vector2" {
		write = function(b: buffer, offset: number, value: Vector2)
			write(b, offset, value.X)
			write(b, offset + size, value.Y)
		end,
		read = function(b: buffer, offset: number): Vector2
			local x = read(b, offset)
			local y = read(b, offset + size)

			return Vector2.new(x, y)
		end,
		size = function(): number
			return size * 3
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Vector2"
		end,
	}
end
