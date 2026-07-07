const specs = require("../../specs")
const types = require("../../types")

const NumberSequenceKeypoint_schema = require("./NumberSequenceKeypoint")
const array_schema = require("../../schemas/compound/array")

const array_len_spec = specs.u8

const function NumberSequence_schema(
	value_spec: types.NumberTypeSpec?,
	envelope_spec: types.NumberTypeSpec?
): types.Schema<NumberSequence>
	const data = array_schema(NumberSequenceKeypoint_schema(value_spec, envelope_spec), array_len_spec)
	const data_write, data_read, data_alloc_size = data.write, data.read, data.alloc_size

	return {
		write = @native function(b: buffer, offset: number, value: NumberSequence): number
			return data_write(b, offset, value.Keypoints)
		end,
		read = @native function(b: buffer, offset: number): (number, NumberSequence)
			const bytes_read, keypoints = data_read(b, offset)
			return bytes_read, NumberSequence.new(keypoints)
		end,
		alloc_size = @native function(value: NumberSequence): number
			return data_alloc_size(value.Keypoints)
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
