local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(format: types.NumberFormat?): types.Schema<number>
	local spec = get_format(format, "f32")
	local write, read, size = spec.write, spec.read, spec.size

	return {
		write = write,
		read = read,
		size = @native function(): number
			return size
		end,
		validate = @native function(value: unknown): boolean
			return type(value) == "number"
		end,
	} :: types.Schema<number>
end
