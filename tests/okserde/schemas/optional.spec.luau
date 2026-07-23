const string_schema = require("@okserde/schemas/string")
const number_schema = require("@okserde/schemas/number")
const optional_schema = require("@okserde/schemas/optional")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / optional", function(test: butler.Test)
		test("constructs", function()
			expect(optional_schema(number_schema())):to_exist()
			expect(optional_schema(string_schema())):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "optional(number())",
					schema = optional_schema(number_schema()),
					sets = {
						{
							expected_size_bytes = 5,
							values = { 100 },
						},
						{
							expected_size_bytes = 1,
							values = { nil },
						},
					},
				},
				{
					label = "optional(string())",
					schema = optional_schema(string_schema()),
					sets = {
						{
							expected_size_bytes = 6,
							values = { "foo" },
						},
						{
							expected_size_bytes = 9,
							values = { "foobar" },
						},
						{
							expected_size_bytes = 1,
							values = { nil },
						},
					},
				},
			},
		})
	end)
end
