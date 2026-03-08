local types = require("../../types")

local UDim_schema = require("./UDim")

return function(scale_spec: types.NumberTypeSpec?, offset_spec: types.NumberTypeSpec?): types.Schema<UDim2>
	local udim = UDim_schema(scale_spec, offset_spec)
	local udim_write, udim_read, udim_size = udim.write, udim.read, udim.size(UDim.new())

	return {
		write = function(b: buffer, offset: number, value: UDim2)
			udim_write(b, offset, value.X)
			udim_write(b, offset + udim_size, value.Y)
		end,
		read = function(b: buffer, offset: number): UDim2
			return UDim2.new(udim_read(b, offset), udim_read(b, offset + udim_size))
		end,
		size = function(value: UDim2): number
			return udim_size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "UDim2"
		end,
	}
end
