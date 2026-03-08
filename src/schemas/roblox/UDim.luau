local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_SCALE_SPEC = specs.f32
local DEFAULT_OFFSET_SPEC = specs.i16

return function(scale_spec: types.NumberTypeSpec?, offset_spec: types.NumberTypeSpec?): types.Schema<UDim>
	local scale = if scale_spec == nil then DEFAULT_SCALE_SPEC else scale_spec
	local scale_write, scale_read, scale_size = scale.write, scale.read, scale.size

	local offset = if offset_spec == nil then DEFAULT_OFFSET_SPEC else offset_spec
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
