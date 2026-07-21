const specs = require("../specs")
const types = require("../types")

const bitstruct_schema = require("../schemas/extra/bitstruct")

const DEFAULT_TIME_SPEC = specs.f32
const DEFAULT_DELAY_SPEC = specs.f32
const DEFAULT_REPEAT_COUNT_SPEC = specs.u8

type TweenInfoStruct = {
	direction: number,
	style: number,
	reverses: number,
	repeats_indefinitely: number,
}

const tweeninfo_schema = bitstruct_schema<<TweenInfoStruct>>(
	{ repeats_indefinitely = 1, reverses = 1, direction = 2, style = 4 },
	{ "repeats_indefinitely", "reverses", "direction", "style" }
)
const tweeninfo_write, tweeninfo_read, tweeninfo_size =
	tweeninfo_schema.write, tweeninfo_schema.read, tweeninfo_schema.size(nil :: any)

const function TweenInfo_schema(
	time_spec: types.NumberTypeSpec?,
	delay_spec: types.NumberTypeSpec?,
	repeat_count_spec: types.NumberTypeSpec?
): types.Schema<TweenInfo>
	const time = if time_spec == nil then DEFAULT_TIME_SPEC else time_spec
	const time_write, time_read, time_size = time.write, time.read, time.size

	const delay = if delay_spec == nil then DEFAULT_DELAY_SPEC else delay_spec
	const delay_write, delay_read, delay_size = delay.write, delay.read, delay.size

	const repeat_count = if repeat_count_spec == nil then DEFAULT_REPEAT_COUNT_SPEC else repeat_count_spec
	const repeat_count_write, repeat_count_read, repeat_count_size =
		repeat_count.write, repeat_count.read, repeat_count.size

	const schema_size = tweeninfo_size + repeat_count_size + delay_size + time_size

	return {
		write = @native function(b: buffer, offset: number, value: TweenInfo): number
			tweeninfo_write(b, offset, {
				direction = value.EasingDirection.Value,
				style = value.EasingStyle.Value,
				reverses = value.Reverses and 1 or 0,
				repeats_indefinitely = value.RepeatCount == -1 and 1 or 0,
			})
			offset += tweeninfo_size

			repeat_count_write(b, offset, value.RepeatCount)
			offset += repeat_count_size

			delay_write(b, offset, value.DelayTime)
			offset += delay_size

			time_write(b, offset, value.Time)

			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, TweenInfo)
			const _, info = tweeninfo_read(b, offset)
			offset += tweeninfo_size

			const repeat_count = repeat_count_read(b, offset)
			offset += repeat_count_size

			const delay_time = delay_read(b, offset)
			offset += delay_size

			const tween_time = time_read(b, offset)

			return schema_size,
				TweenInfo.new(
					tween_time,
					Enum.EasingStyle:FromValue(info.style),
					Enum.EasingDirection:FromValue(info.direction),
					info.repeats_indefinitely == 1 and -1 or repeat_count,
					info.reverses == 1,
					delay_time
				)
		end,
		size = @native function(value: TweenInfo): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "TweenInfo" then
				return false, `expected value of type TweenInfo, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return TweenInfo_schema
