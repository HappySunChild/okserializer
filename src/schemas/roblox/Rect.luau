local types = require("../../types")

local Vector2_schema = require("./Vector2")

return function(format: types.NumberFormat?): types.Schema<Rect>
	local vec_schema = Vector2_schema(format)
	local write, read, size = vec_schema.write, vec_schema.read, vec_schema.size(Vector2.zero)

	return {
		write = function(b: buffer, offset: number, value: Rect)
			local min, max = value.Min, value.Max

			write(b, offset, min)
			write(b, offset + size, max)
		end,
		read = function(b: buffer, offset: number): Rect
			local min = read(b, offset)
			local max = read(b, offset + size)

			return Rect.new(min, max)
		end,
		size = function(value: Rect): number
			return size * 2
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Rect"
		end,
	}
end
