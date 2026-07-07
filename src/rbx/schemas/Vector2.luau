const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_VECTOR_SPEC = specs.f32

const function Vector2_schema(component_spec: types.NumberTypeSpec?): types.Schema<Vector2>
	const component = if component_spec == nil then DEFAULT_VECTOR_SPEC else component_spec
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
		alloc_size = @native function(): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Vector2" then
				return false, `expected value of type Vector2, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return Vector2_schema
