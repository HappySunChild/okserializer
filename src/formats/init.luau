local types = require("./types")

local radian = require("@self/radian")
local small = require("@self/small")

local float = require("@self/float")
local int = require("@self/integer")
local uint = require("@self/uinteger")

return table.freeze({
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

	none = require("@self/none"),
}) :: { [types.NumberFormat]: types.NumberSpec }
