local types = require("../../types")

local ColorSequenceKeypoint_schema = require("./ColorSequenceKeypoint")
local array_schema = require("../compound/array")

local data = array_schema(ColorSequenceKeypoint_schema, "u8")
local write, read, size = data.write, data.read, data.size

return {
	write = @native function(b: buffer, offset: number, value: ColorSequence)
		write(b, offset, value.Keypoints)
	end,
	read = @native function(b: buffer, offset: number): ColorSequence
		return ColorSequence.new(read(b, offset))
	end,
	size = @native function(value: ColorSequence): number
		return size(value.Keypoints)
	end,
	validate = @native function(value: unknown): boolean
		return typeof(value) == "ColorSequence"
	end,
} :: types.Schema<ColorSequence>
