local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_VECTOR_FORMAT = formats.f32

return function(format: types.NumberFormat?): types.Schema<Vector2>
	local spec = if format == nil then DEFAULT_VECTOR_FORMAT else formats[format]
	local write, read, size = spec.write, spec.read, spec.size

	return {
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
			return size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "Vector2"
		end,
	}
end
