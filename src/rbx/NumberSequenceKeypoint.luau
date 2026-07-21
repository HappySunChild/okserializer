const specs = require("../specs")
const types = require("../types")

const DEFAULT_VALUE_SPEC = specs.f32
const DEFAULT_ENVELOPE_SPEC = specs.f16

const time = specs.s16
const time_write, time_read, time_size = time.write, time.read, time.size

const function NumberSequenceKeypoint_schema(
	value_spec: types.NumberTypeSpec?,
	envelope_spec: types.NumberTypeSpec?
): types.Schema<NumberSequenceKeypoint>
	const value = if value_spec == nil then DEFAULT_VALUE_SPEC else value_spec
	const value_write, value_read, value_size = value.write, value.read, value.size

	const envelope = if envelope_spec == nil then DEFAULT_ENVELOPE_SPEC else envelope_spec
	const envelope_write, envelope_read, envelope_size = envelope.write, envelope.read, envelope.size

	const schema_size = time_size + value_size + envelope_size

	return {
		write = @native function(b: buffer, offset: number, value: NumberSequenceKeypoint): number
			time_write(b, offset, value.Time)
			value_write(b, offset + time_size, value.Value)
			envelope_write(b, offset + time_size + value_size, value.Envelope)

			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, NumberSequenceKeypoint)
			return schema_size,
				NumberSequenceKeypoint.new(
					time_read(b, offset),
					value_read(b, offset + time_size),
					envelope_read(b, offset + time_size + value_size)
				)
		end,
		size = @native function(value: NumberSequenceKeypoint): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "NumberSequenceKeypoint" then
				return false, `expected value of type NumberSequenceKeypoint, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return NumberSequenceKeypoint_schema
