local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_VALUE_SPEC = specs.f32
local DEFAULT_ENVELOPE_SPEC = specs.f16

local time = specs.s16
local time_write, time_read, time_size = time.write, time.read, time.size

return function(
	value_spec: types.NumberTypeSpec?,
	envelope_spec: types.NumberTypeSpec?
): types.Schema<NumberSequenceKeypoint>
	local value = if value_spec == nil then DEFAULT_VALUE_SPEC else value_spec
	local value_write, value_read, value_size = value.write, value.read, value.size

	local envelope = if envelope_spec == nil then DEFAULT_ENVELOPE_SPEC else envelope_spec
	local envelope_write, envelope_read, envelope_size = envelope.write, envelope.read, envelope.size

	return {
		write = function(b: buffer, offset: number, value: NumberSequenceKeypoint)
			time_write(b, offset, value.Time)
			value_write(b, offset + time_size, value.Value)
			envelope_write(b, offset + time_size + value_size, value.Envelope)
		end,
		read = function(b: buffer, offset: number): NumberSequenceKeypoint
			local keypoint_time = time_read(b, offset)
			local keypoint_value = value_read(b, offset + time_size)
			local keypoint_envelope = envelope_read(b, offset + time_size + value_size)

			return NumberSequenceKeypoint.new(keypoint_time, keypoint_value, keypoint_envelope)
		end,
		size = function(value: NumberSequenceKeypoint): number
			return time_size + value_size + envelope_size
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "NumberSequenceKeypoint"
		end,
	}
end
