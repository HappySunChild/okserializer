const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_SCALE_ENCODING = encodings.f32
const DEFAULT_OFFSET_ENCODING = encodings.i16

const function UDim_schema(
	scale_enc: okserde.NumberEncoding?,
	offset_enc: okserde.NumberEncoding?
): okserde.StaticSchema<UDim>
	const scale = if scale_enc == nil then DEFAULT_SCALE_ENCODING else scale_enc
	const scale_write, scale_read, scale_size = scale.write, scale.read, scale.size

	const offset = if offset_enc == nil then DEFAULT_OFFSET_ENCODING else offset_enc
	const offset_write, offset_read, offset_size = offset.write, offset.read, offset.size

	const schema_size = scale_size + offset_size

	return {
		write = @native function(b: buffer, offset: number, value: UDim): number
			scale_write(b, offset, value.Scale)
			offset_write(b, offset + scale_size, value.Offset)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, UDim)
			return schema_size, UDim.new(scale_read(b, offset), offset_read(b, offset + scale_size))
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "UDim" then
				return false, `expected value of type UDim, got {typeof(value)}`
			end

			return true, nil
		end,

		static_size = schema_size,
	}
end

return UDim_schema
