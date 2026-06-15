const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_VECTOR_SPEC = specs.f32

const function vector_schema(component_spec: types.NumberTypeSpec?): types.Schema<vector>
	const component = if component_spec == nil then DEFAULT_VECTOR_SPEC else component_spec
	const component_write, component_read, component_size = component.write, component.read, component.size

	return {
		write = function(b: buffer, offset: number, value: vector)
			component_write(b, offset, value.x)
			component_write(b, offset + component_size, value.y)
			component_write(b, offset + component_size * 2, value.z)
		end,
		read = function(b: buffer, offset: number): vector
			return vector.create(
				component_read(b, offset),
				component_read(b, offset + component_size),
				component_read(b, offset + component_size * 2)
			)
		end,
		size = function(): number
			return component_size * 3
		end,
		validate = function(value: unknown): (boolean, string?)
			if type(value) ~= "vector" then
				return false, `expected value of type vector, got {type(value)}`
			end

			return true, nil
		end,
	}
end

return vector_schema
