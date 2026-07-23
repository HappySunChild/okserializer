const union_schema = require("@okserde/schemas/union")
const string_schema = require("@okserde/schemas/string")
const number_schema = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / union", function(test: butler.Test)
		test("constructs", function()
			expect(union_schema()):to_exist()
			expect(union_schema(number_schema())):to_exist()
			expect(union_schema(string_schema(), number_schema())):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "union(number())",
					schema = union_schema(number_schema()),
					sets = {
						{
							expected_size_bytes = 5,
							values = { 0 },
						},
						{
							expected_size_bytes = 5,
							values = { math.nan },
						},
					},
				},
				{
					label = "union(number(), string())",
					schema = union_schema(number_schema(), string_schema()),
					sets = {
						{
							expected_size_bytes = 5,
							values = { 0 },
						},
						{
							expected_size_bytes = 5,
							values = { math.nan },
						},
						{
							expected_size_bytes = 3,
							values = { "" },
						},
						{
							expected_size_bytes = 6,
							values = { "foo" },
						},
					},
				},
			},
		})
	end)
end
