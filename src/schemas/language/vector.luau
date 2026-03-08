local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_VECTOR_SPEC = specs.f32

return function(component_spec: types.NumberTypeSpec?): types.Schema<vector>
	local component = if component_spec == nil then DEFAULT_VECTOR_SPEC else component_spec
	local component_write, component_read, component_size = component.write, component.read, component.size

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
		validate = function(value: unknown): boolean
			return type(value) == "vector"
		end,
	}
end
