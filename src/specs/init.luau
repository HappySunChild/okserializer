const okserde = require("./types")

const radian = require("@self/radian")
const unorm = require("@self/unorm")

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

	un8 = unorm.un8 :: okserde.NumberTypeSpec, --   1 / 255        ≈ 0.0039215686274509
	un16 = unorm.un16 :: okserde.NumberTypeSpec, -- 1 / 65535      ≈ 0.0000152590218967
	un32 = unorm.un32 :: okserde.NumberTypeSpec, -- 1 / 4294967295 ≈ 0.0000000002328306

	rn8 = radian.rn8 :: okserde.NumberTypeSpec, --   tau / 256        ≈ 1.40625    degrees
	rn16 = radian.rn16 :: okserde.NumberTypeSpec, -- tau / 65536      ≈ 0.00549316 degrees
	rn32 = radian.rn32 :: okserde.NumberTypeSpec, -- tau / 4294967296 ≈ 0.00000008 degrees

	none = none :: okserde.NumberTypeSpec,
	constant = constant,
}
