local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_VECTOR_SPEC = specs.f32

return function(component_spec: types.NumberTypeSpec?): types.Schema<Vector2>
	local component = if component_spec == nil then DEFAULT_VECTOR_SPEC else component_spec
	local component_write, component_read, component_size = component.write, component.read, component.size

	return {
		write = function(b: buffer, offset: number, value: Vector2)
			component_write(b, offset, value.X)
			component_write(b, offset + component_size, value.Y)
		end,
		read = function(b: buffer, offset: number): Vector2
			return Vector2.new(component_read(b, offset), component_read(b, offset + component_size))
		end,
		size = function(): number
			return component_size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "Vector2"
		end,
	}
end
