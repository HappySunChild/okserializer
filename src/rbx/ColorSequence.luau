const encodings = require("../encodings")
const okserde = require("../types")

const ColorSequenceKeypoint_schema = require("./ColorSequenceKeypoint")
const array_schema = require("../schemas/array")

const data = array_schema(ColorSequenceKeypoint_schema, encodings.u8)
const data_write, data_read, data_dyn_size = data.write, data.read, data.dyn_size

const ColorSequence_schema: okserde.DynSchema<ColorSequence> = {
	write = @native function(b: buffer, offset: number, value: ColorSequence): number
		return data_write(b, offset, value.Keypoints)
	end,
	read = @native function(b: buffer, offset: number): (number, ColorSequence)
		const bytes_read, keypoints = data_read(b, offset)
		return bytes_read, ColorSequence.new(keypoints)
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "ColorSequence" then
			return false, `expected value of type ColorSequence, got {typeof(value)}`
		end

		return true, nil
	end,

	dyn_size = @native function(value: ColorSequence): number
		return data_dyn_size(value.Keypoints)
	end,
}

return ColorSequence_schema
