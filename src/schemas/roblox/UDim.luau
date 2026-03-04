local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(
	scale_format: types.NumberFormat?,
	offset_format: types.NumberFormat?
): types.Schema<UDim>
	local scale = get_format(scale_format, "f32")
	local scale_write, scale_read, scale_size = scale.write, scale.read, scale.size

	local offset = get_format(offset_format, "i16")
	local offset_write, offset_read, offset_size = offset.write, offset.read, offset.size

	return {
		write = function(b: buffer, offset: number, value: UDim)
			scale_write(b, offset, value.Scale)
			offset_write(b, offset + scale_size, value.Offset)
		end,
		read = function(b: buffer, offset: number): UDim
			return UDim.new(scale_read(b, offset), offset_read(b, offset + scale_size))
		end,
		size = function(value: UDim): number
			return scale_size + offset_size
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "UDim"
		end,
	}
end
