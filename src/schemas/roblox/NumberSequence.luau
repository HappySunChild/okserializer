local specs = require("../../specs")
local types = require("../../types")

local NumberSequenceKeypoint_schema = require("./NumberSequenceKeypoint")
local array_schema = require("../compound/array")

local array_len_spec = specs.u8

return function(value_spec: types.NumberTypeSpec?, envelope_spec: types.NumberTypeSpec?)
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
		validate = function(value: unknown): boolean
			return typeof(value) == "NumberSequence"
		end,
	}
end
