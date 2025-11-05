local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(
	scale_format: types.NumberFormat?,
	offset_format: types.NumberFormat?
): types.Schema<UDim>
	local _scale = formats.get(scale_format, "f32")
	local scale_write, scale_read, scale_size = _scale.write, _scale.read, _scale.size

	local _offset = formats.get(offset_format, "i16")
	local offset_write, offset_read, offset_size = _offset.write, _offset.read, _offset.size

	return Schema {
		write = function(b: buffer, offset: number, value: UDim)
			scale_write(b, offset, value.Scale)
			offset_write(b, offset + scale_size, value.Offset)
		end,
		read = function(b: buffer, offset: number): UDim
			local ud_scale = scale_read(b, offset)
			local ud_offset = offset_read(b, offset + scale_size)

			return UDim.new(ud_scale, ud_offset)
		end,
		size = function(value: UDim): number
			return scale_size + offset_size
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "UDim"
		end,
	}
end
