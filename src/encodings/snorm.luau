-- "snorm" encoding
-- like unorm, but signed. stores decimals between -1, 1 with even spacing.

const I8_MAX = (2 ^ 8) / 2 - 1
const I8_MIN = -I8_MAX - 1
const I16_MAX = (2 ^ 16) / 2 - 1
const I16_MIN = -I16_MAX - 1
const I32_MAX = (2 ^ 32) / 2 - 1
const I32_MIN = -I32_MAX - 1

return {
	sn8 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writei8(b, offset, math.map(value, -1, 1, I8_MIN, I8_MAX))
		end,
		read = @native function(b: buffer, offset: number): number
			return math.map(buffer.readi8(b, offset), I8_MIN, I8_MAX, -1, 1)
		end,
		size = 1,
		min = -1,
		max = 1,
	},
	sn16 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writei16(b, offset, math.map(value, -1, 1, I16_MIN, I16_MAX))
		end,
		read = @native function(b: buffer, offset: number): number
			return math.map(buffer.readi16(b, offset), I16_MIN, I16_MAX, -1, 1)
		end,
		size = 2,
		min = -1,
		max = 1,
	},
	sn32 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writei32(b, offset, math.map(value, -1, 1, I32_MIN, I32_MAX))
		end,
		read = @native function(b: buffer, offset: number): number
			return math.map(buffer.readi32(b, offset), I32_MIN, I32_MAX, -1, 1)
		end,
		size = 4,
		min = -1,
		max = 1,
	},
}
