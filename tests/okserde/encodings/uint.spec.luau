const uint = require("@okserde/encodings/uint")

const butler = require("@butler/butler")

const generate_encoding_tests = require("@utility/generate_encoding_tests")

return function(configured: butler.Configured)
	return configured.unit("encoding / uint", function(test: butler.Test)
		generate_encoding_tests({
			label = "u8",
			encoding = uint.u8,
			values = {},
			test = test,
		})
		generate_encoding_tests({
			label = "u16",
			encoding = uint.u16,
			values = {},
			test = test,
		})
		generate_encoding_tests({
			label = "u32",
			encoding = uint.u32,
			values = {},
			test = test,
		})
	end)
end
