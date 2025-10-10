local types = require "./types"

local float16 = require "@self/float16"
local radian = require "@self/radian"
local small = require "@self/small"

local U8_LIMIT = 2 ^ 8
local U16_LIMIT = 2 ^ 16

local I8_LIMIT = U8_LIMIT / 2 - 1
local I16_LIMIT = U16_LIMIT / 2 - 1

local FORMATS = table.freeze {
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

	r8 = radian.r8, --   tau / 256        ≈ 1.40625    degrees (perfect 4ths)
	r16 = radian.r16, -- tau / 65536      ≈ 0.00549316 degrees (perfect 4ths)
	r32 = radian.r32, -- tau / 4294967296 ≈ 0.00000008 degrees (perfect 4ths)
} :: { [types.NumberByteFormat]: types.ByteFormatInfo }

return table.freeze {
	get = function(
		format_key: types.NumberByteFormat?,
		default: types.NumberByteFormat
	): types.ByteFormatInfo
		if format_key then
			return FORMATS[format_key]
		end

		return FORMATS[default]
	end,
	determine = function(value: number): types.ByteFormatInfo
		local integral, decimal = math.modf(value)

		if decimal == 0 then -- integer
			if integral < 0 then -- signed
				if value > I16_LIMIT then
					return FORMATS["i32"]
				elseif value > I8_LIMIT then
					return FORMATS["i16"]
				else
					return FORMATS["i8"]
				end
			end

			if value > U16_LIMIT then
				return FORMATS["u32"]
			elseif value > U8_LIMIT then
				return FORMATS["u16"]
			else
				return FORMATS["u8"]
			end
		end

		return FORMATS["f32"]
	end,
}
