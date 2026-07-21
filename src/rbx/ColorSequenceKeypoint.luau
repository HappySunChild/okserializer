const encodings = require("../encodings")
const okserde = require("../types")

const time = encodings.s16
const time_write, time_read, time_size = time.write, time.read, time.size

const Color3_schema = require("./Color3")
const Color3_write, Color3_read, Color3_size = Color3_schema.write, Color3_schema.read, 3

const schema_size = time_size + Color3_size

const ColorSequenceKeypoint_schema: okserde.Schema<ColorSequenceKeypoint> = {
	write = @native function(b: buffer, offset: number, value: ColorSequenceKeypoint): number
		time_write(b, offset, value.Time)
		Color3_write(b, offset + Color3_size, value.Value)
		return schema_size
	end,
	read = @native function(b: buffer, offset: number): (number, ColorSequenceKeypoint)
		const keypoint_time = time_read(b, offset)
		const _, keypoint_color = Color3_read(b, offset + time_size)

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
