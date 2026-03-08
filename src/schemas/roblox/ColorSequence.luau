local specs = require("../../specs")
local types = require("../../types")

local ColorSequenceKeypoint_schema = require("./ColorSequenceKeypoint")
local array_schema = require("../compound/array")

local data = array_schema(ColorSequenceKeypoint_schema, specs.u8)
local data_write, data_read, data_size = data.write, data.read, data.size

return {
	write = function(b: buffer, offset: number, value: ColorSequence)
		data_write(b, offset, value.Keypoints)
	end,
	read = function(b: buffer, offset: number): ColorSequence
		return ColorSequence.new(data_read(b, offset))
	end,
	size = function(value: ColorSequence): number
		return data_size(value.Keypoints)
	end,
	validate = function(value: unknown): boolean
		return typeof(value) == "ColorSequence"
	end,
} :: types.Schema<ColorSequence>
