const boolean_schema = require("@okserde/schemas/boolean")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	return configured.unit("schema / boolean", function(test: butler.Test)
		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "boolean",
					schema = boolean_schema,
					sets = {
						{
							expected_size_bytes = 1,
							values = { true },
						},
						{
							expected_size_bytes = 1,
							values = { false },
						},
					},
				},
			},
		})
	end)
end
