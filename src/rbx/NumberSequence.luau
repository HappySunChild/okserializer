const encodings = require("../encodings")
const okserde = require("../types")

const NumberSequenceKeypoint_schema = require("./NumberSequenceKeypoint")
const array_schema = require("../schemas/array")

const ARRAY_LEN_ENCODING = encodings.u8

const function NumberSequence_schema(
	value_enc: okserde.NumberEncoding?,
	envelope_enc: okserde.NumberEncoding?
): okserde.Schema<NumberSequence>
	const data = array_schema(NumberSequenceKeypoint_schema(value_enc, envelope_enc), ARRAY_LEN_ENCODING)
	const data_write, data_read, data_size = data.write, data.read, data.size

	return {
		write = @native function(b: buffer, offset: number, value: NumberSequence): number
			return data_write(b, offset, value.Keypoints)
		end,
		read = @native function(b: buffer, offset: number): (number, NumberSequence)
			const bytes_read, keypoints = data_read(b, offset)
			return bytes_read, NumberSequence.new(keypoints)
		end,
		size = @native function(value: NumberSequence): number
			return data_size(value.Keypoints)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "NumberSequence" then
				return false, `expected value of type NumberSequence, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return NumberSequence_schema
