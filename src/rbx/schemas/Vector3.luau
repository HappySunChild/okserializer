local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_VECTOR_SPEC = specs.f32

const function Vector3_schema(component_spec: types.NumberTypeSpec?): types.Schema<Vector3>
	local component = if component_spec == nil then DEFAULT_VECTOR_SPEC else component_spec
	local component_write, component_read, component_size = component.write, component.read, component.size

	return {
		write = function(b: buffer, offset: number, value: Vector3)
			component_write(b, offset, value.X)
			component_write(b, offset + component_size, value.Y)
			component_write(b, offset + component_size * 2, value.Z)
		end,
		read = function(b: buffer, offset: number): Vector3
			return Vector3.new(
				component_read(b, offset),
				component_read(b, offset + component_size),
				component_read(b, offset + component_size * 2)
			)
		end,
		size = function(): number
			return component_size * 3
		end,
		validate = function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Vector3" then
				return false, `expected value of type Vector3, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return Vector3_schema
