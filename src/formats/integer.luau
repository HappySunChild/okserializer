local I8_MAX = (2 ^ 8) / 2 - 1
local I16_MAX = (2 ^ 16) / 2 - 1
local I32_MAX = (2 ^ 32) / 2 - 1

return table.freeze {
	i8 = table.freeze {
		write = buffer.writei8,
		read = buffer.readi8,
		size = 1,
		min = -I8_MAX - 1,
		max = I8_MAX,
	},
	i16 = table.freeze {
		write = buffer.writei16,
		read = buffer.readi16,
		size = 2,
		min = -I16_MAX - 1,
		max = I16_MAX,
	},
	i32 = table.freeze {
		write = buffer.writei32,
		read = buffer.readi32,
		size = 4,
		min = -I32_MAX - 1,
		max = I32_MAX,
	},
}
