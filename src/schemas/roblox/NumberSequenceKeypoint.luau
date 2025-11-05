local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

local _time = formats.get_atomic "s16"
local time_write, time_read, time_size = _time.write, _time.read, _time.size

return function(
	value_format: types.NumberFormat?,
	envelope_format: types.NumberFormat?
): types.Schema<NumberSequenceKeypoint>
	local _value = formats.get(value_format, "f32")
	local value_write, value_read, value_size = _value.write, _value.read, _value.size

	local _envelope = formats.get(envelope_format, "f16")
	local envelope_write, envelope_read, envelope_size =
		_envelope.write, _envelope.read, _envelope.size

	return Schema {
		write = @native function(b: buffer, offset: number, value: NumberSequenceKeypoint)
			time_write(b, offset, value.Time)
			value_write(b, offset + time_size, value.Value)
			envelope_write(b, offset + time_size + value_size, value.Envelope)
		end,
		read = @native function(b: buffer, offset: number): NumberSequenceKeypoint
			local keypoint_time = time_read(b, offset)
			local keypoint_value = value_read(b, offset + time_size)
			local keypoint_envelope = envelope_read(b, offset + time_size + value_size)

			return NumberSequenceKeypoint.new(keypoint_time, keypoint_value, keypoint_envelope)
		end,
		size = @native function(value: NumberSequenceKeypoint): number
			return time_size + value_size + envelope_size
		end,

		validate = @native function(value: unknown): boolean
			return typeof(value) == "NumberSequenceKeypoint"
		end,
	}
end
