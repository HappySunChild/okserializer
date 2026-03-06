local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_VALUE_SPEC = formats.f32

return function(format: types.NumberFormat?): types.Schema<NumberRange>
	local _spec = if format == nil then DEFAULT_VALUE_SPEC else formats[format]
	local write, read, size = _spec.write, _spec.read, _spec.size

	return {
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
