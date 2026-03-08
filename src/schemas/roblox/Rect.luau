local types = require("../../types")

local Vector2_schema = require("./Vector2")

return function(vec_spec: types.NumberTypeSpec?): types.Schema<Rect>
	local vec = Vector2_schema(vec_spec)
	local vec_write, vec_read, vec_size = vec.write, vec.read, vec.size(Vector2.zero)

	return {
		write = function(b: buffer, offset: number, value: Rect)
			vec_write(b, offset, value.Min)
			vec_write(b, offset + vec_size, value.Max)
		end,
		read = function(b: buffer, offset: number): Rect
			return Rect.new(vec_read(b, offset), vec_read(b, offset + vec_size))
		end,
		size = function(value: Rect): number
			return vec_size * 2
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Rect"
		end,
	}
end
