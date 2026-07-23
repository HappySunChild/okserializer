const snorm = require("@okserde/encodings/snorm")

const butler = require("@butler/butler")

const generate_encoding_tests = require("@utility/generate_encoding_tests")

return function(configured: butler.Configured)
	return configured.unit("encoding / snorm", function(test: butler.Test)
		generate_encoding_tests({
			label = "sn8",
			encoding = snorm.sn8,
			values = { 0, 1 / (2 ^ 8 / 2 - 1) },
			test = test,
		})
		generate_encoding_tests({
			label = "sn16",
			encoding = snorm.sn16,
			values = { 0, 1 / (2 ^ 16 / 2 - 1) },
			test = test,
		})
		generate_encoding_tests({
			label = "sn32",
			encoding = snorm.sn32,
			values = { 0, 1 / (2 ^ 32 / 2 - 1) },
			test = test,
		})
	end)
end
