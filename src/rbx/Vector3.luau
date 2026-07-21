const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_VECTOR_ENC = encodings.f32

const function Vector3_schema(component_enc: okserde.NumberEncoding?): okserde.Schema<Vector3>
	const component = if component_enc == nil then DEFAULT_VECTOR_ENC else component_enc
	const component_write, component_read, component_size = component.write, component.read, component.size

	const schema_size = component_size * 3

	return {
		write = @native function(b: buffer, offset: number, value: Vector3): number
			component_write(b, offset, value.X)
			component_write(b, offset + component_size, value.Y)
			component_write(b, offset + component_size * 2, value.Z)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, Vector3)
			return schema_size,
				Vector3.new(
					component_read(b, offset),
					component_read(b, offset + component_size),
					component_read(b, offset + component_size * 2)
				)
		end,
		size = @native function(): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Vector3" then
				return false, `expected value of type Vector3, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return Vector3_schema
