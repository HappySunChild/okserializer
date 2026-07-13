const specs = require("../../specs")
const types = require("../../types")

const ColorSequenceKeypoint_schema = require("./ColorSequenceKeypoint")
const array_schema = require("../../schemas/compound/array")

const data = array_schema(ColorSequenceKeypoint_schema, specs.u8)
const data_write, data_read, data_alloc_size = data.write, data.read, data.alloc_size

const ColorSequence_schema: types.Schema<ColorSequence> = {
	write = @native function(b: buffer, offset: number, value: ColorSequence): number
		return data_write(b, offset, value.Keypoints)
	end,
	read = @native function(b: buffer, offset: number): (number, ColorSequence)
		const bytes_read, keypoints = data_read(b, offset)
		return bytes_read, ColorSequence.new(keypoints)
	end,
	alloc_size = @native function(value: ColorSequence): number
		return data_alloc_size(value.Keypoints)
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "ColorSequence" then
			return false, `expected value of type ColorSequence, got {typeof(value)}`
		end

		return true, nil
	end,
}

return ColorSequence_schema
