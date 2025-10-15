local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

local Schema_bitstruct = require "../custom/bitstruct"

type TweenInfoCompactInfo = {
	direction: number,
	style: number,
	reverses: number,
	repeats_indefinitely: number,
}

local _info_schem = Schema_bitstruct(
	{ repeats_indefinitely = 1, reverses = 1, direction = 2, style = 4 },
	{ "repeats_indefinitely", "reverses", "direction", "style" }
) :: types.Schema<TweenInfoCompactInfo>
local info_write, info_read, info_size = _info_schem.write, _info_schem.read, _info_schem.size()

return function(
	time_format: types.NumberFormat?,
	delay_format: types.NumberFormat?,
	repeat_count_format: types.UIntFormat | types.NoneFormat?
): types.Schema<TweenInfo>
	local _time = formats.get(time_format, "f32")
	local time_write, time_read, time_size = _time.write, _time.read, _time.size

	local _delay = formats.get(delay_format, "f32")
	local delay_write, delay_read, delay_size = _delay.write, _delay.read, _delay.size

	local _repeat_count = formats.get(repeat_count_format, "u8")
	local repeat_count_write, repeat_count_read, repeat_count_size =
		_repeat_count.write, _repeat_count.read, _repeat_count.size

	return Schema "TweenInfo" {
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
