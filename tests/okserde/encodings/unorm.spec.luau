const unorm = require("@okserde/encodings/unorm")

const butler = require("@butler/butler")

const generate_encoding_tests = require("@utility/generate_encoding_tests")

return function(configured: butler.Configured)
	return configured.unit("encoding / unorm", function(test: butler.Test)
		generate_encoding_tests({
			label = "un8",
			encoding = unorm.un8,
			values = { 1 / (2 ^ 8 - 1) },
			test = test,
		})
		generate_encoding_tests({
			label = "un16",
			encoding = unorm.un16,
			values = { 1 / (2 ^ 16 - 1) },
			test = test,
		})
		generate_encoding_tests({
			label = "un32",
			encoding = unorm.un32,
			values = { 1 / (2 ^ 32 - 1) },
			test = test,
		})
	end)
end
