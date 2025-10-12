local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

local Schema_Color3 = require "./Color3"

local _time = formats.get_atomic "s16"
local time_write, time_read, time_size = _time.write, _time.read, _time.size

local color_write, color_read, color_size =
	Schema_Color3.write, Schema_Color3.read, Schema_Color3.size(Color3.new())

return Schema "ColorSequenceKeypoint" {
	write = @native function(b: buffer, offset: number, value: ColorSequenceKeypoint)
		time_write(b, offset, value.Time)
		color_write(b, offset, value.Value)
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
