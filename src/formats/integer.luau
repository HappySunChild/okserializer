return table.freeze {
	i8 = table.freeze {
		write = buffer.writei8,
		read = buffer.readi8,
		size = 1,
	},
	i16 = table.freeze {
		write = buffer.writei16,
		read = buffer.readi16,
		size = 2,
	},
	i32 = table.freeze {
		write = buffer.writei32,
		read = buffer.readi32,
		size = 4,
	},
}
