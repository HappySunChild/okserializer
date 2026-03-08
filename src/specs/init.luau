local types = require("./types")

local radian = require("@self/radian")
local small = require("@self/small")

local float = require("@self/float")
local int = require("@self/integer")
local uint = require("@self/uinteger")

return table.freeze({
	u8 = uint.u8 :: types.NumberTypeSpec,
	u16 = uint.u16 :: types.NumberTypeSpec,
	u32 = uint.u32 :: types.NumberTypeSpec,

	i8 = int.i8 :: types.NumberTypeSpec,
	i16 = int.i16 :: types.NumberTypeSpec,
	i32 = int.i32 :: types.NumberTypeSpec,

	f16 = float.f16 :: types.NumberTypeSpec,
	f32 = float.f32 :: types.NumberTypeSpec,
	f64 = float.f64 :: types.NumberTypeSpec,

	s8 = small.s8 :: types.NumberTypeSpec, --   1 / 256        ≈ 0.00390625
	s16 = small.s16 :: types.NumberTypeSpec, -- 1 / 65536      ≈ 0.0000152587890625
	s32 = small.s32 :: types.NumberTypeSpec, -- 1 / 4294967296 ≈ 0.00000000023283064365386962890625

	r8 = radian.r8 :: types.NumberTypeSpec, --   tau / 256        ≈ 1.40625    degrees
	r16 = radian.r16 :: types.NumberTypeSpec, -- tau / 65536      ≈ 0.00549316 degrees
	r32 = radian.r32 :: types.NumberTypeSpec, -- tau / 4294967296 ≈ 0.00000008 degrees

	none = require("@self/none") :: types.NumberTypeSpec,
})
