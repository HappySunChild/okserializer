const radian = require("@okserde/encodings/radian")

const butler = require("@butler/butler")

const generate_encoding_tests = require("@utility/generate_encoding_tests")

return function(configured: butler.Configured)
	return configured.unit("encoding / radian", function(test: butler.Test)
		generate_encoding_tests({
			label = "rn8",
			encoding = radian.rn8,
			values = { math.tau / (2 ^ 8), math.pi },
			test = test,
		})
		generate_encoding_tests({
			label = "rn16",
			encoding = radian.rn16,
			values = { math.tau / (2 ^ 16), math.pi },
			test = test,
		})
		generate_encoding_tests({
			label = "rn32",
			encoding = radian.rn32,
			values = { math.tau / (2 ^ 32), math.pi },
			test = test,
		})
	end)
end
