const encodings = require("@okserde/encodings")
const string_schema = require("@okserde/schemas/string")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / string", function(test: butler.Test)
		test("constructs", function()
			expect(string_schema()):to_exist()
			expect(string_schema(encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "string()",
					schema = string_schema(),
					sets = {
						{
							expected_size_bytes = 2,
							values = { "" },
						},
						{
							expected_size_bytes = 5,
							values = { "foo" },
						},
						{
							expected_size_bytes = 8,
							values = { "foobar" },
						},
						{
							expected_size_bytes = 2 ^ 16 + 1,
							values = { string.rep("a", 2 ^ 16 - 1) },
						},
					},
				},
				{
					label = "string(u8)",
					schema = string_schema(encodings.u8),
					sets = {
						{
							expected_size_bytes = 1,
							values = { "" },
						},
						{
							expected_size_bytes = 4,
							values = { "foo" },
						},
						{
							expected_size_bytes = 7,
							values = { "foobar" },
						},
						{
							expected_size_bytes = 2 ^ 8,
							values = { string.rep("a", 2 ^ 8 - 1) },
						},
					},
				},
			},
		})
	end)
end
