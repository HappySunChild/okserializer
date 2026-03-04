local types = require("../../types")

local NumberSequenceKeypoint_schema = require("./NumberSequenceKeypoint")
local array_schema = require("../compound/array")

return function(value_format: types.NumberFormat?, envelope_format: types.NumberFormat?)
	local data = array_schema(NumberSequenceKeypoint_schema(value_format, envelope_format), "u8")
	local write, read, size = data.write, data.read, data.size

	return {
		write = @native function(b: buffer, offset: number, value: NumberSequence)
			write(b, offset, value.Keypoints)
		end,
		read = @native function(b: buffer, offset: number): NumberSequence
			return NumberSequence.new(read(b, offset))
		end,
		size = @native function(value: NumberSequence): number
			return size(value.Keypoints)
		end,
		validate = @native function(value: unknown): boolean
			return typeof(value) == "NumberSequence"
		end,
	}
end
