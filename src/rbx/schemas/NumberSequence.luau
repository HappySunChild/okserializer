local specs = require("../../specs")
local types = require("../../types")

local NumberSequenceKeypoint_schema = require("./NumberSequenceKeypoint")
local array_schema = require("../../schemas/compound/array")

local array_len_spec = specs.u8

const function NumberSequence_schema(
	value_spec: types.NumberTypeSpec?,
	envelope_spec: types.NumberTypeSpec?
): types.Schema<NumberSequence>
	local data = array_schema(NumberSequenceKeypoint_schema(value_spec, envelope_spec), array_len_spec)
	local data_write, data_read, data_size = data.write, data.read, data.size

	return {
		write = function(b: buffer, offset: number, value: NumberSequence)
			data_write(b, offset, value.Keypoints)
		end,
		read = function(b: buffer, offset: number): NumberSequence
			return NumberSequence.new(data_read(b, offset))
		end,
		size = function(value: NumberSequence): number
			return data_size(value.Keypoints)
		end,
		validate = function(value: unknown): (boolean, string?)
			if typeof(value) ~= "NumberSequence" then
				return false, `expected value of type NumberSequence, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return NumberSequence_schema
