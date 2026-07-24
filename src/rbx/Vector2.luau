const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_VECTOR_ENCODING = encodings.f32

const function Vector2_schema(component_enc: okserde.NumberEncoding?): okserde.StaticSchema<Vector2>
	const component = if component_enc == nil then DEFAULT_VECTOR_ENCODING else component_enc
	const component_write, component_read, component_size = component.write, component.read, component.size

	const schema_size = component_size * 2

	return {
		write = @native function(b: buffer, offset: number, value: Vector2): number
			component_write(b, offset, value.X)
			component_write(b, offset + component_size, value.Y)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, Vector2)
			return schema_size,
				Vector2.new(component_read(b, offset), component_read(b, offset + component_size))
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Vector2" then
				return false, `expected value of type Vector2, got {typeof(value)}`
			end

			return true, nil
		end,

		static_size = schema_size,
	}
end

return Vector2_schema
