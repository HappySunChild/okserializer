local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_NUMBER_SPEC = specs.f32

return function(value_spec: types.NumberTypeSpec?): types.Schema<number>
	local value = if value_spec == nil then DEFAULT_NUMBER_SPEC else value_spec
	local value_write, value_read, value_size = value.write, value.read, value.size

	return {
		write = value_write,
		read = value_read,
		size = function(): number
			return value_size
		end,
		validate = function(value: unknown): boolean
			return type(value) == "number"
		end,
	} :: types.Schema<number>
end
