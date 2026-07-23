-- "snorm" encoding.
-- like unorm, but signed. stores decimals between -1, 1 with even spacing.
-- this uses the standard clamped mapping method to retain perfect 0 representation

const I8_MAX = 2 ^ 8 / 2 - 1
const I16_MAX = 2 ^ 16 / 2 - 1
const I32_MAX = 2 ^ 16 / 2 - 1

return {
	sn8 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writei8(b, offset, value * I8_MAX) -- resorting to truncation
		end,
		read = @native function(b: buffer, offset: number): number
			return math.max(-1, buffer.readi8(b, offset) / I8_MAX)
		end,
		size = 1,
		min = -1,
		max = 1,
	},
	sn16 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writei16(b, offset, value * I16_MAX)
		end,
		read = @native function(b: buffer, offset: number): number
			return math.max(-1, buffer.readi16(b, offset) / I16_MAX)
		end,
		size = 2,
		min = -1,
		max = 1,
	},
	sn32 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writei32(b, offset, value * I32_MAX)
		end,
		read = @native function(b: buffer, offset: number): number
			return math.max(-1, buffer.readi32(b, offset) / I32_MAX)
		end,
		size = 4,
		min = -1,
		max = 1,
	},
}
