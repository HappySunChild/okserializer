local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(format: types.NumberFormat?): types.Schema<vector>
	local spec = get_format(format, "f32")
	local write, read, size = spec.write, spec.read, spec.size

	return {
		write = @native function(b: buffer, offset: number, value: vector)
			write(b, offset, value.x)
			write(b, offset + size, value.y)
			write(b, offset + size * 2, value.z)
		end,
		read = @native function(b: buffer, offset: number): vector
			local x = read(b, offset)
			local y = read(b, offset + size)
			local z = read(b, offset + size * 2)

			return vector.create(x, y, z)
		end,
		size = @native function(): number
			return size * 3
		end,
		validate = @native function(value: unknown): boolean
			return type(value) == "vector"
		end,
	}
end
