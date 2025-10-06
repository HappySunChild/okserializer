local float16 = require "@self/float16"
local radian = require "@self/radian"
local small = require "@self/small"

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

	f16 = float16,
	f32 = table.freeze {
		write = buffer.writef32,
		read = buffer.readf32,
		size = 4,
	},
	f64 = table.freeze {
		write = buffer.writef64,
		read = buffer.readf64,
		size = 8,
	},

	s8 = small.s8,
	s16 = small.s16,
	s32 = small.s32,

	r8 = radian.r8, --   pi / 256        ≈ 0.703 degrees (perfect 4ths)
	r16 = radian.r16, -- pi / 65536      ≈ 0.002 degrees (perfect 4ths)
	r32 = radian.r32, -- pi / 4294967296 ≈ 0.00000004 degrees (perfect 4ths)
}
