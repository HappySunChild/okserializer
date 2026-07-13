const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_VALUE_SPEC = specs.f32

const function NumberRange_schema(value_spec: types.NumberTypeSpec?): types.Schema<NumberRange>
	const value = if value_spec == nil then DEFAULT_VALUE_SPEC else value_spec
	const value_write, value_read, value_size = value.write, value.read, value.size

	const schema_size = value_size * 2

	return {
		write = @native function(b: buffer, offset: number, value: NumberRange): number
			value_write(b, offset, value.Min)
			value_write(b, offset + value_size, value.Max)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, NumberRange)
			return schema_size, NumberRange.new(value_read(b, offset), value_read(b, offset + value_size))
		end,
		alloc_size = @native function(): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "NumberRange" then
				return false, `expected value of type NumberRange, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return NumberRange_schema
