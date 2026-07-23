const okserde = require("./types")

const radian = require("@self/radian")
const unorm = require("@self/unorm")
const snorm = require("@self/snorm")

const constant = require("@self/constant")

const float = require("@self/float")
const int = require("@self/int")
const uint = require("@self/uint")

return {
	u8 = uint.u8 :: okserde.NumberEncoding,
	u16 = uint.u16 :: okserde.NumberEncoding,
	u32 = uint.u32 :: okserde.NumberEncoding,

	i8 = int.i8 :: okserde.NumberEncoding,
	i16 = int.i16 :: okserde.NumberEncoding,
	i32 = int.i32 :: okserde.NumberEncoding,

	f16 = float.f16 :: okserde.NumberEncoding,
	f32 = float.f32 :: okserde.NumberEncoding,
	f64 = float.f64 :: okserde.NumberEncoding,

	un8 = unorm.un8 :: okserde.NumberEncoding, --   1 / 255        ≈ 0.0039215686274509
	un16 = unorm.un16 :: okserde.NumberEncoding, -- 1 / 65535      ≈ 0.0000152590218967
	un32 = unorm.un32 :: okserde.NumberEncoding, -- 1 / 4294967295 ≈ 0.0000000002328306

	sn8 = snorm.sn8 :: okserde.NumberEncoding, --   1 / 127        ≈ 0.0078431372549019
	sn16 = snorm.sn16 :: okserde.NumberEncoding, -- 1 / 32767      ≈ 0.0000305180437934
	sn32 = snorm.sn32 :: okserde.NumberEncoding, -- 1 / 2147483647 ≈ 0.0000000004656612

	rn8 = radian.rn8 :: okserde.NumberEncoding, --   tau / 256        ≈ 1.40625    degrees
	rn16 = radian.rn16 :: okserde.NumberEncoding, -- tau / 65536      ≈ 0.00549316 degrees
	rn32 = radian.rn32 :: okserde.NumberEncoding, -- tau / 4294967296 ≈ 0.00000008 degrees

	constant = constant,
}
