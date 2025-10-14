local types = require "./types"

local radian = require "@self/radian"
local small = require "@self/small"

local float = require "@self/float"
local int = require "@self/integer"
local uint = require "@self/uinteger"

local U8_LIMIT = (2 ^ 8) - 1
local U16_LIMIT = (2 ^ 16) - 1

local I8_LIMIT = U8_LIMIT / 2 - 1
local I16_LIMIT = U16_LIMIT / 2 - 1

local NUMBER_FORMATS = table.freeze {
	u8 = uint.u8,
	u16 = uint.u16,
	u32 = uint.u32,

	i8 = int.i8,
	i16 = int.i16,
	i32 = int.i32,

	f16 = float.f16,
	f32 = float.f32,
	f64 = float.f64,

	s8 = small.s8, --   1 / 256        ≈ 0.00390625
	s16 = small.s16, -- 1 / 65536      ≈ 0.0000152587890625
	s32 = small.s32, -- 1 / 4294967296 ≈ 0.00000000023283064365386962890625

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
