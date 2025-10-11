local types = require "../../types"

local Schema = require "../Schema"

local Schema_number = require "../primitive/number"

return function(format: types.NumberFormat?): types.Schema<NumberRange>
	local _schem = Schema_number(format)
	local write, read, size = _schem.write, _schem.read, _schem.size(0)

	return Schema "NumberRange" {
		write = function(b: buffer, offset: number, value: NumberRange)
			write(b, offset, value.Min)
			write(b, offset + size, value.Max)
		end,
		read = function(b: buffer, offset: number): NumberRange
			local min = read(b, offset)
			local max = read(b, offset + size)

			return NumberRange.new(min, max)
		end,
		size = function(): number
			return size * 2
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "NumberRange"
		end,
	}
end
