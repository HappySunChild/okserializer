local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(format: types.NumberFormat?): types.Schema<NumberRange>
	local _spec = get_format(format, "f32")
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
