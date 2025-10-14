return table.freeze {
	u8 = table.freeze {
		write = buffer.writeu8,
		read = buffer.readu8,
		size = 1,
	},
	u16 = table.freeze {
		write = buffer.writeu16,
		read = buffer.readu16,
		size = 2,
	},
	u32 = table.freeze {
		write = buffer.writeu32,
		read = buffer.readu32,
		size = 4,
	},
}
