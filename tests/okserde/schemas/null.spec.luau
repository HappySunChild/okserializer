const null_schema = require("@okserde/schemas/null")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	return configured.unit("schema / null", function(test: butler.Test)
		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "null",
					schema = null_schema,
					sets = {
						{
							expected_size_bytes = 0,
							values = { nil },
						},
					},
				},
			},
		})
	end)
end
