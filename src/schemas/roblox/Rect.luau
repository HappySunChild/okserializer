local types = require "../../types"

local Schema = require "../Schema"

local Schema_Vector2 = require "./Vector2"

return function(format: types.NumberFormat?): types.Schema<Rect>
	local _schem = Schema_Vector2(format)
	local write, read, size = _schem.write, _schem.read, _schem.size()

	return Schema "Rect" {
		write = function(b: buffer, offset: number, value: Rect)
			local min, max = value.Min, value.Max

			write(b, offset, min)
			write(b, offset + size, max)
		end,
		read = function(b: buffer, offset: number): Rect
			local min = read(b, offset)
			local max = read(b, offset + size)

			return Rect.new(min, max)
		end,
		size = function(value: Rect): number
			return size * 2
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "Rect"
		end,
	}
end
