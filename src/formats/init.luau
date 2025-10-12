local types = require "./types"

local float16 = require "@self/float16"
local radian = require "@self/radian"
local small = require "@self/small"

local U8_LIMIT = (2 ^ 8) - 1
local U16_LIMIT = (2 ^ 16) - 1

local I8_LIMIT = U8_LIMIT / 2 - 1
local I16_LIMIT = U16_LIMIT / 2 - 1

local NUMBER_FORMATS = table.freeze {
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

	r8 = radian.r8, --   tau / 256        ≈ 1.40625    degrees
	r16 = radian.r16, -- tau / 65536      ≈ 0.00549316 degrees
	r32 = radian.r32, -- tau / 4294967296 ≈ 0.00000008 degrees
} :: { [types.NumberFormat]: types.NumberFormatSpec }

return table.freeze {
	get_atomic = function(format_key: types.NumberFormat): types.NumberFormatSpec
		return NUMBER_FORMATS[format_key]
	end,
	get = function(
		format_key: types.NumberFormat?,
		default: types.NumberFormat
	): types.NumberFormatSpec
		if format_key then
			return NUMBER_FORMATS[format_key]
		end

		return NUMBER_FORMATS[default]
	end,
	determine = function(value: number): types.NumberFormatSpec
		local integral, decimal = math.modf(value)

		if decimal == 0 then -- integer
			if integral < 0 then -- signed
				if value > I16_LIMIT then
					return NUMBER_FORMATS["i32"]
				elseif value > I8_LIMIT then
					return NUMBER_FORMATS["i16"]
				else
					return NUMBER_FORMATS["i8"]
				end
			end

			if value > U16_LIMIT then
				return NUMBER_FORMATS["u32"]
			elseif value > U8_LIMIT then
				return NUMBER_FORMATS["u16"]
			else
				return NUMBER_FORMATS["u8"]
			end
		end

		return NUMBER_FORMATS["f32"]
	end,
}
