local specs = require("../../specs")
local types = require("../../types")

local bitstruct_schema = require("../extra/bitstruct")

local DEFAULT_TIME_SPEC = specs.f32
local DEFAULT_DELAY_SPEC = specs.f32
local DEFAULT_REPEAT_COUNT_SPEC = specs.u8

type TweenCompactInfo = {
	direction: number,
	style: number,
	reverses: number,
	repeats_indefinitely: number,
}

local info_schema = bitstruct_schema(
	{ repeats_indefinitely = 1, reverses = 1, direction = 2, style = 4 },
	{ "repeats_indefinitely", "reverses", "direction", "style" }
) :: types.Schema<TweenCompactInfo>
local info_write, info_read, info_size = info_schema.write, info_schema.read, info_schema.size(nil :: any)

return function(
	time_spec: types.NumberTypeSpec?,
	delay_spec: types.NumberTypeSpec?,
	repeat_count_spec: types.NumberTypeSpec?
): types.Schema<TweenInfo>
	local time = if time_spec == nil then DEFAULT_TIME_SPEC else time_spec
	local time_write, time_read, time_size = time.write, time.read, time.size

	local delay = if delay_spec == nil then DEFAULT_DELAY_SPEC else delay_spec
	local delay_write, delay_read, delay_size = delay.write, delay.read, delay.size

	local repeat_count = if repeat_count_spec == nil then DEFAULT_REPEAT_COUNT_SPEC else repeat_count_spec
	local repeat_count_write, repeat_count_read, repeat_count_size =
		repeat_count.write, repeat_count.read, repeat_count.size

	return {
		write = function(b: buffer, offset: number, value: TweenInfo)
			info_write(b, offset, {
				direction = value.EasingDirection.Value,
				style = value.EasingStyle.Value,
				reverses = value.Reverses and 1 or 0,
				repeats_indefinitely = value.RepeatCount == -1 and 1 or 0,
			})
			offset += info_size

			repeat_count_write(b, offset, value.RepeatCount)
			offset += repeat_count_size

			delay_write(b, offset, value.DelayTime)
			offset += delay_size

			time_write(b, offset, value.Time)
		end,
		read = function(b: buffer, offset: number): TweenInfo
			local info = info_read(b, offset)
			offset += info_size

			local repeat_count = repeat_count_read(b, offset)
			offset += repeat_count_size

			local delay_time = delay_read(b, offset)
			offset += delay_size

			local tween_time = time_read(b, offset)

			return TweenInfo.new(
				tween_time,
				Enum.EasingStyle:FromValue(info.style),
				Enum.EasingDirection:FromValue(info.direction),
				info.repeats_indefinitely == 1 and -1 or repeat_count,
				info.reverses == 1,
				delay_time
			)
		end,
		size = function(value: TweenInfo): number
			return info_size + repeat_count_size + delay_size + time_size
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "TweenInfo"
		end,
	}
end
