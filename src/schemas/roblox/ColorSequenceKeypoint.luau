local formats = require("../../formats")
local types = require("../../types")

local time = formats.s16
local time_write, time_read, time_size = time.write, time.read, time.size

local color = require("./Color3")
local color_write, color_read, color_size = color.write, color.read, 3

return {
	write = @native function(b: buffer, offset: number, value: ColorSequenceKeypoint)
		time_write(b, offset, value.Time)
		color_write(b, offset + color_size, value.Value)
	end,
	read = @native function(b: buffer, offset: number): ColorSequenceKeypoint
		local keypoint_time = time_read(b, offset)
		local keypoint_color = color_read(b, offset + time_size)

		return ColorSequenceKeypoint.new(keypoint_time, keypoint_color)
	end,
	size = @native function(): number
		return time_size + color_size
	end,
	validate = @native function(value: unknown): boolean
		return typeof(value) == "ColorSequenceKeypoint"
	end,
} :: types.Schema<ColorSequenceKeypoint>
