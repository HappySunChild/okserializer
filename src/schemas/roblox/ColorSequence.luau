local types = require "../../types"

local Schema = require "../Schema"

local Schema_ColorSequenceKeypoint = require "./ColorSequenceKeypoint"
local Schema_array = require "../compound/array"

local _array = Schema_array(Schema_ColorSequenceKeypoint, "u8")
local write, read, size = _array.write, _array.read, _array.size

return Schema {
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
