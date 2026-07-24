const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_VALUE_ENCODING = encodings.f32
const DEFAULT_ENVELOPE_ENCODING = encodings.f16

const time_enc = encodings.un16
const time_write, time_read, time_size = time_enc.write, time_enc.read, time_enc.size

const function NumberSequenceKeypoint_schema(
	value_enc: okserde.NumberEncoding?,
	envelope_enc: okserde.NumberEncoding?
): okserde.StaticSchema<NumberSequenceKeypoint>
	const value = if value_enc == nil then DEFAULT_VALUE_ENCODING else value_enc
	const value_write, value_read, value_size = value.write, value.read, value.size

	const envelope = if envelope_enc == nil then DEFAULT_ENVELOPE_ENCODING else envelope_enc
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
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "NumberSequenceKeypoint" then
				return false, `expected value of type NumberSequenceKeypoint, got {typeof(value)}`
			end

			return true, nil
		end,

		static_size = schema_size,
	}
end

return NumberSequenceKeypoint_schema
