const okserde = require("../types")

const Vector2_schema = require("./Vector2")

const function Rect_schema(component_enc: okserde.NumberEncoding?): okserde.StaticSchema<Rect>
	const vec = Vector2_schema(component_enc)
	const vec_write, vec_read, vec_size = vec.write, vec.read, vec.static_size

	const schema_size = vec_size * 2

	return {
		write = @native function(b: buffer, offset: number, value: Rect): number
			vec_write(b, offset, value.Min)
			vec_write(b, offset + vec_size, value.Max)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, Rect)
			const _, min = vec_read(b, offset)
			const _, max = vec_read(b, offset + vec_size)
			return schema_size, Rect.new(min, max)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Rect" then
				return false, `expected value of type Rect, got {typeof(value)}`
			end

			return true, nil
		end,

		static_size = schema_size,
	}
end

return Rect_schema
