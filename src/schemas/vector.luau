const specs = require("../specs")
const okserde = require("../types")

const DEFAULT_VECTOR_SPEC = specs.f32

const function vector_schema(component_spec: okserde.NumberTypeSpec?): okserde.Schema<vector>
	const component = if component_spec == nil then DEFAULT_VECTOR_SPEC else component_spec
	const component_write, component_read, component_size = component.write, component.read, component.size

	return {
		write = @native function(b: buffer, offset: number, value: vector): number
			component_write(b, offset, value.x)
			component_write(b, offset + component_size, value.y)
			component_write(b, offset + component_size * 2, value.z)
			return component_size * 3
		end,
		read = @native function(b: buffer, offset: number): (number, vector)
			return component_size * 3,
				vector.create(
					component_read(b, offset),
					component_read(b, offset + component_size),
					component_read(b, offset + component_size * 2)
				)
		end,
		size = @native function(): number
			return component_size * 3
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "vector" then
				return false, `expected value of type vector, got {type(value)}`
			end

			return true, nil
		end,
	}
end

return vector_schema
