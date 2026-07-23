const int = require("@okserde/encodings/int")

const butler = require("@butler/butler")

const generate_encoding_tests = require("@utility/generate_encoding_tests")

return function(configured: butler.Configured)
	return configured.unit("encoding / int", function(test: butler.Test)
		generate_encoding_tests({
			label = "i8",
			encoding = int.i8,
			values = { 0, -10, 10 },
			test = test,
		})
		generate_encoding_tests({
			label = "i16",
			encoding = int.i16,
			values = { 0, -10, 10 },
			test = test,
		})
		generate_encoding_tests({
			label = "i32",
			encoding = int.i32,
			values = { 0, -10, -100, -1000, 10, 100, 1000 },
			test = test,
		})
	end)
end
