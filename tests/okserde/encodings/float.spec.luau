const float = require("@okserde/encodings/float")

const butler = require("@butler/butler")

const generate_encoding_tests = require("@utility/generate_encoding_tests")

return function(configured: butler.Configured)
	return configured.unit("encoding / float", function(test: butler.Test)
		generate_encoding_tests({
			label = "f16",
			encoding = float.f16,
			values = { 0, 1, 3, -32, math.nan },
			test = test,
		})
		generate_encoding_tests({
			label = "f32",
			encoding = float.f32,
			values = { 0, 1, 3.141, -32.5, math.nan },
			test = test,
		})
		generate_encoding_tests({
			label = "f64",
			encoding = float.f64,
			values = { 0, 1, math.pi, -math.e, math.nan },
			test = test,
		})
	end)
end
