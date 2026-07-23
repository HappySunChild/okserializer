const padding_schema = require("@okserde/schemas/padding")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / padding", function(test: butler.Test)
		test("constructs", function()
			expect(padding_schema(0)):to_exist()
			expect(padding_schema(10)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "padding(1)",
					schema = padding_schema(1),
					sets = {
						{
							expected_size_bytes = 1,
							values = { nil },
						},
					},
				},
				{
					label = "padding(10)",
					schema = padding_schema(10),
					sets = {
						{
							expected_size_bytes = 10,
							values = { nil },
						},
					},
				},
			},
		})
	end)
end
