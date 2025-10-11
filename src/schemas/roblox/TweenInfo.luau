local types = require "../../types"

local Schema = require "../Schema"

local DIRECTION_MASK = 0b00000011
local STYLE_MASK = 0b00111100
local REVERSES_MASK = 0b01000000
local REPEATS_MASK = 0b10000000

return Schema "TweenInfo" {
	write = function(b: buffer, offset: number, value: TweenInfo)
		-- can be encoded into 7 bits
		local direction = value.EasingDirection.Value -- (max: 2 | 0b10, width: 2)
		local style = bit32.lshift(value.EasingStyle.Value, 2) -- (max: 10 | 0b1010, width: 4)
		local reverses = bit32.lshift(value.Reverses and 1 or 0, 6) -- (width: 1)
		local repeats_indefinitely = bit32.lshift(value.RepeatCount == -1 and 1 or 0, 7) -- (width: 1)

		buffer.writeu8(b, offset, bit32.bor(direction, style, reverses, repeats_indefinitely))
		buffer.writeu8(b, offset + 1, value.RepeatCount) -- compromising >255 repeat counts for storage space here
		buffer.writef32(b, offset + 2, value.DelayTime)
		buffer.writef32(b, offset + 6, value.Time)
	end,
	read = function(b: buffer, offset: number): TweenInfo
		local combined = buffer.readu8(b, offset)
		local direction = bit32.band(combined, DIRECTION_MASK)
		local style = bit32.rshift(bit32.band(combined, STYLE_MASK), 2)
		local reverses = bit32.btest(combined, REVERSES_MASK)
		local repeats_indefinitely = bit32.btest(combined, REPEATS_MASK)

		local repeat_count = buffer.readu8(b, offset + 1)
		local delay_time = buffer.readf32(b, offset + 2)
		local tween_time = buffer.readf32(b, offset + 6)

		return TweenInfo.new(
			tween_time,
			Enum.EasingStyle:FromValue(style),
			Enum.EasingDirection:FromValue(direction),
			repeats_indefinitely and -1 or repeat_count,
			reverses,
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
