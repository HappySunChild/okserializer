local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(format: types.NumberFormat?): types.Schema<Vector3>
	local component_spec = get_format(format, "f32")
	local write, read, size = component_spec.write, component_spec.read, component_spec.size

	return {
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
