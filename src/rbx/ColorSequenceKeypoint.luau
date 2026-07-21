const specs = require("../specs")
const types = require("../types")

const time = specs.s16
const time_write, time_read, time_size = time.write, time.read, time.size

const color = require("./Color3")
const color_write, color_read, color_size = color.write, color.read, 3

const schema_size = time_size + color_size

const ColorSequenceKeypoint_schema: types.Schema<ColorSequenceKeypoint> = {
	write = @native function(b: buffer, offset: number, value: ColorSequenceKeypoint): number
		time_write(b, offset, value.Time)
		color_write(b, offset + color_size, value.Value)
		return schema_size
	end,
	read = @native function(b: buffer, offset: number): (number, ColorSequenceKeypoint)
		const keypoint_time = time_read(b, offset)
		const _, keypoint_color = color_read(b, offset + time_size)

		return schema_size, ColorSequenceKeypoint.new(keypoint_time, keypoint_color)
	end,
	size = @native function(): number
		return schema_size
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "ColorSequenceKeypoint" then
			return false, `expected value of type ColorSequenceKeypoint, got {typeof(value)}`
		end

		return true, nil
	end,
}

return ColorSequenceKeypoint_schema
