return {
	all_units = {
		require("./okserde/encodings/constant.spec"),
		require("./okserde/encodings/float.spec"),
		require("./okserde/encodings/int.spec"),
		require("./okserde/encodings/radian.spec"),
		require("./okserde/encodings/snorm.spec"),
		require("./okserde/encodings/uint.spec"),
		require("./okserde/encodings/unorm.spec"),

		require("./okserde/schemas/array.spec"),
		require("./okserde/schemas/bitarray.spec"),
		require("./okserde/schemas/bitstruct.spec"),
		require("./okserde/schemas/boolean.spec"),
		require("./okserde/schemas/buffer.spec"),
	},
}
