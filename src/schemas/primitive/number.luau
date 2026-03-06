local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_NUMBER_FORMAT = formats.f32

return function(format: types.NumberFormat?): types.Schema<number>
	local spec = if format == nil then DEFAULT_NUMBER_FORMAT else formats[format]
	local write, read, size = spec.write, spec.read, spec.size

	return {
		write = write,
		read = read,
		size = function(): number
			return size
		end,
		validate = function(value: unknown): boolean
			return type(value) == "number"
		end,
	} :: types.Schema<number>
end
