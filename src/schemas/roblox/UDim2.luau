local types = require "../../types"

local Schema = require "../Schema"

local Schema_UDim = require "./UDim"

return function(
	scale_format: types.NumberFormat?,
	offset_format: types.NumberFormat?
): types.Schema<UDim2>
	local _schem = Schema_UDim(scale_format, offset_format)
	local write, read, size = _schem.write, _schem.read, _schem.size(UDim.new())

	return Schema {
		write = function(b: buffer, offset: number, value: UDim2)
			write(b, offset, value.X)
			write(b, offset + size, value.Y)
		end,
		read = function(b: buffer, offset: number): UDim2
			local x = read(b, offset)
			local y = read(b, offset + size)

			return UDim2.new(x, y)
		end,
		size = function(value: UDim2): number
			return size * 2
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "UDim2"
		end,
	}
end
