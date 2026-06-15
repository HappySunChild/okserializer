local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_VALUE_SPEC = specs.f32

const function NumberRange_schema(value_spec: types.NumberTypeSpec?): types.Schema<NumberRange>
	local value = if value_spec == nil then DEFAULT_VALUE_SPEC else value_spec
	local value_write, value_read, value_size = value.write, value.read, value.size

	return {
		write = function(b: buffer, offset: number, value: NumberRange)
			value_write(b, offset, value.Min)
			value_write(b, offset + value_size, value.Max)
		end,
		read = function(b: buffer, offset: number): NumberRange
			return NumberRange.new(value_read(b, offset), value_read(b, offset + value_size))
		end,
		size = function(): number
			return value_size * 2
		end,
		validate = function(value: unknown): (boolean, string?)
			if typeof(value) ~= "NumberRange" then
				return false, `expected value of type NumberRange, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return NumberRange_schema
