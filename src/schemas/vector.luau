const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_VECTOR_ENCODING = encodings.f32

const function vector_schema(component_enc: okserde.NumberEncoding?): okserde.Schema<vector>
	const component = if component_enc == nil then DEFAULT_VECTOR_ENCODING else component_enc
	const component_write, component_read, component_size = component.write, component.read, component.size

	const static_size = component_size * 3

	return {
		write = @native function(b: buffer, offset: number, value: vector): number
			component_write(b, offset, value.x)
			component_write(b, offset + component_size, value.y)
			component_write(b, offset + component_size * 2, value.z)
			return static_size
		end,
		read = @native function(b: buffer, offset: number): (number, vector)
			return static_size,
				vector.create(
					component_read(b, offset),
					component_read(b, offset + component_size),
					component_read(b, offset + component_size * 2)
				)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "vector" then
				return false, `expected value of type vector, got {type(value)}`
			end

			return true, nil
		end,

		static_size = static_size,
	}
end

return vector_schema
