const types = require("../types")

const UDim_schema = require("./UDim")

const function UDim2_schema(
	scale_spec: types.NumberTypeSpec?,
	offset_spec: types.NumberTypeSpec?
): types.Schema<UDim2>
	const udim = UDim_schema(scale_spec, offset_spec)
	const udim_write, udim_read, udim_size = udim.write, udim.read, udim.alloc_size(UDim.new())

	const schema_size = udim_size * 2

	return {
		write = @native function(b: buffer, offset: number, value: UDim2): number
			udim_write(b, offset, value.X)
			udim_write(b, offset + udim_size, value.Y)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, UDim2)
			const _, x = udim_read(b, offset)
			const _, y = udim_read(b, offset + udim_size)
			return schema_size, UDim2.new(x, y)
		end,
		alloc_size = @native function(value: UDim2): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "UDim2" then
				return false, `expected value of type UDim2, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return UDim2_schema
