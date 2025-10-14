local types = require "../../types"

local Schema = require "../Schema"

local Schema_Vector3 = require "./Vector3"

return function(format: types.NumberFormat?): types.Schema<Ray>
	local _schem = Schema_Vector3(format)
	local write, read, size = _schem.write, _schem.read, _schem.size()

	return Schema "Ray" {
		write = @native function(b: buffer, offset: number, value: Ray)
			write(b, offset, value.Origin)
			write(b, offset + size, value.Direction)
		end,
		read = @native function(b: buffer, offset: number): Ray
			local origin = read(b, offset)
			local direction = read(b, offset + size)

			return Ray.new(origin, direction)
		end,
		size = @native function(): number
			return size * 2
		end,

		validate = @native function(value: unknown): boolean
			return typeof(value) == "Ray"
		end,
	}
end
