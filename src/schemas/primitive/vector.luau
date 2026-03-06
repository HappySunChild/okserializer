local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_VECTOR_FORMAT = formats.f32

return function(format: types.NumberFormat?): types.Schema<vector>
	local spec = if format == nil then DEFAULT_VECTOR_FORMAT else formats[format]
	local write, read, size = spec.write, spec.read, spec.size

	return {
		write = function(b: buffer, offset: number, value: vector)
			write(b, offset, value.x)
			write(b, offset + size, value.y)
			write(b, offset + size * 2, value.z)
		end,
		read = function(b: buffer, offset: number): vector
			local x = read(b, offset)
			local y = read(b, offset + size)
			local z = read(b, offset + size * 2)

			return vector.create(x, y, z)
		end,
		size = function(): number
			return size * 3
		end,
		validate = function(value: unknown): boolean
			return type(value) == "vector"
		end,
	}
end
