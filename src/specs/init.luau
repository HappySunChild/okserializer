const okserde = require("./types")

const radian = require("@self/radian")
const small = require("@self/small")

const none = require("@self/none")
const constant = require("@self/constant")

const float = require("@self/float")
const int = require("@self/int")
const uint = require("@self/uint")

return {
	u8 = uint.u8 :: okserde.NumberTypeSpec,
	u16 = uint.u16 :: okserde.NumberTypeSpec,
	u32 = uint.u32 :: okserde.NumberTypeSpec,

	i8 = int.i8 :: okserde.NumberTypeSpec,
	i16 = int.i16 :: okserde.NumberTypeSpec,
	i32 = int.i32 :: okserde.NumberTypeSpec,

	f16 = float.f16 :: okserde.NumberTypeSpec,
	f32 = float.f32 :: okserde.NumberTypeSpec,
	f64 = float.f64 :: okserde.NumberTypeSpec,

	s8 = small.s8 :: okserde.NumberTypeSpec, --   1 / 256        ≈ 0.00390625
	s16 = small.s16 :: okserde.NumberTypeSpec, -- 1 / 65536      ≈ 0.0000152587890625
	s32 = small.s32 :: okserde.NumberTypeSpec, -- 1 / 4294967296 ≈ 0.00000000023283064365386962890625

	r8 = radian.r8 :: okserde.NumberTypeSpec, --   tau / 256        ≈ 1.40625    degrees
	r16 = radian.r16 :: okserde.NumberTypeSpec, -- tau / 65536      ≈ 0.00549316 degrees
	r32 = radian.r32 :: okserde.NumberTypeSpec, -- tau / 4294967296 ≈ 0.00000008 degrees

	none = none :: okserde.NumberTypeSpec,
	constant = constant,
}
