-- like none, but can be set to a specific value instead of just always reading as zero.

const okserde = require("../types")

const function constant(value: number): okserde.NumberEncoding
	return {
		write = function(): () end,
		read = function(): number
			return value
		end,
		size = 0,
		min = value,
		max = value,
	}
end

return constant
