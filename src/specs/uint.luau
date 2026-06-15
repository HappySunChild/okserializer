const U8_MAX = (2 ^ 8) - 1
const U16_MAX = (2 ^ 16) - 1
const U32_MAX = (2 ^ 32) - 1

return {
	u8 = {
		write = buffer.writeu8,
		read = buffer.readu8,
		size = 1,
		min = 0,
		max = U8_MAX,
	},
	u16 = {
		write = buffer.writeu16,
		read = buffer.readu16,
		size = 2,
		min = 0,
		max = U16_MAX,
	},
	u32 = {
		write = buffer.writeu32,
		read = buffer.readu32,
		size = 4,
		min = 0,
		max = U32_MAX,
	},
}
