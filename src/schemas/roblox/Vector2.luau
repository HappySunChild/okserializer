local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(format: types.NumberFormat?): types.Schema<Vector2>
	local component_spec = get_format(format, "f32")
	local write, read, size = component_spec.write, component_spec.read, component_spec.size

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
