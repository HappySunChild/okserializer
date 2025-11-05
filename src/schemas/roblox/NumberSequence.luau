local types = require "../../types"

local Schema = require "../Schema"

local Schema_NumberSequenceKeypoint = require "./NumberSequenceKeypoint"
local Schema_array = require "../compound/array"

return function(value_format: types.NumberFormat?, envelope_format: types.NumberFormat?)
	local _array = Schema_array(Schema_NumberSequenceKeypoint(value_format, envelope_format), "u8")
	local write, read, size = _array.write, _array.read, _array.size

	return Schema {
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
