-- "Small" number byte format
-- Stores decimals between 0-1 with even spacing. May be useful if you're serializing an 'alpha' value.

const U8_MAX = (2 ^ 8) - 1
const U16_MAX = (2 ^ 16) - 1
const U32_MAX = (2 ^ 32) - 1

return {
	s8 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, value * U8_MAX)
		end,
		read = @native function(b: buffer, offset: number)
			return buffer.readu8(b, offset) / U8_MAX
		end,
		size = 1,
		min = 0,
		max = 1,
	},
	s16 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, value * U16_MAX)
		end,
		read = @native function(b: buffer, offset: number)
			return buffer.readu16(b, offset) / U16_MAX
		end,
		size = 2,
		min = 0,
		max = 1,
	},
	s32 = {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu32(b, offset, value * U32_MAX)
		end,
		read = @native function(b: buffer, offset: number)
			return buffer.readu32(b, offset) / U32_MAX
		end,
		size = 4,
		min = 0,
		max = 1,
	},
}
