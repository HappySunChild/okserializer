local types = require "../../types"

local Schema = require "../Schema"

local Schema_bitstruct = require "../custom/bitstruct"

type TweenInfoCompactInfo = {
	direction: number,
	style: number,
	reverses: number,
	repeats_indefinitely: number,
}

local _infoschem = Schema_bitstruct(
	{ repeats_indefinitely = 1, reverses = 1, direction = 2, style = 4 },
	{ "reapeats_indefinitely", "reverses", "direction", "style" }
) :: types.Schema<TweenInfoCompactInfo>
local info_write, info_read = _infoschem.write, _infoschem.read

return Schema "TweenInfo" {
	write = function(b: buffer, offset: number, value: TweenInfo)
		info_write(b, offset, {
			direction = value.EasingDirection.Value,
			style = value.EasingStyle.Value,
			reverses = value.Reverses and 1 or 0,
			repeats_indefinitely = value.RepeatCount == -1 and 1 or 0,
		})
		buffer.writeu8(b, offset + 1, value.RepeatCount) -- compromising >255 repeat counts for storage space here
		buffer.writef32(b, offset + 2, value.DelayTime)
		buffer.writef32(b, offset + 6, value.Time)
	end,
	read = function(b: buffer, offset: number): TweenInfo
		local info = info_read(b, offset)
		local repeat_count = buffer.readu8(b, offset + 1)
		local delay_time = buffer.readf32(b, offset + 2)
		local tween_time = buffer.readf32(b, offset + 6)

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
		return 10
	end,

	validate = function(value: unknown): boolean
		return typeof(value) == "TweenInfo"
	end,
} :: types.Schema<TweenInfo>
