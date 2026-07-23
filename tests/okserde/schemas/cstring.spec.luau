const cstring_schema = require("@okserde/schemas/cstring")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	return configured.unit("schema / cstring", function(test: butler.Test)
		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "cstring",
					schema = cstring_schema,
					sets = {
						{
							expected_size_bytes = 4,
							values = { "foo" },
						},
						{
							expected_size_bytes = 7,
							values = { "foobar" },
						},
						{
							expected_size_bytes = 13,
							values = { "hello world!" },
						},
						{
							expected_size_bytes = 1001,
							values = { string.rep("a", 1000) },
						},
						{
							expected_size_bytes = 10001,
							values = { string.rep("a", 10000) },
						},
					},
				},
			},
		})
	end)
end
