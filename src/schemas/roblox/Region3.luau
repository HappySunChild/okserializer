local types = require "../../types"

local Schema = require "../Schema"

local Schema_Vector3 = require "./Vector3"

return function(format: types.NumberFormat?): types.Schema<Region3>
	local _schem = Schema_Vector3(format)
	local write, read, size = _schem.write, _schem.read, _schem.size()

	return Schema "Region3" {
		write = function(b: buffer, offset: number, value: Region3)
			local reg_cf, reg_size = value.CFrame, value.Size
			local reg_min, reg_max = reg_cf * -reg_size / 2, reg_cf * reg_size / 2

			write(b, offset, reg_min)
			write(b, offset + size, reg_max)
		end,
		read = function(b: buffer, offset: number): Region3
			local min = read(b, offset)
			local max = read(b, offset + size)

			return Region3.new(min, max)
		end,
		size = function(value: Region3): number
			return size * 2
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Region3"
		end,
	}
end
