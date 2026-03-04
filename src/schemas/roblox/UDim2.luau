local types = require("../../types")

local UDim_schema = require("./UDim")

return function(
	scale_format: types.NumberFormat?,
	offset_format: types.NumberFormat?
): types.Schema<UDim2>
	local udim_schema = UDim_schema(scale_format, offset_format)
	local write, read, size = udim_schema.write, udim_schema.read, udim_schema.size(UDim.new())

	return {
		write = function(b: buffer, offset: number, value: UDim2)
			write(b, offset, value.X)
			write(b, offset + size, value.Y)
		end,
		read = function(b: buffer, offset: number): UDim2
			return UDim2.new(read(b, offset), read(b, offset + size))
		end,
		size = function(value: UDim2): number
			return size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "UDim2"
		end,
	}
end
