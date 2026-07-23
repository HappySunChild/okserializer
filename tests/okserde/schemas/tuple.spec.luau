const tuple_schema = require("@okserde/schemas/tuple")
const string_schema = require("@okserde/schemas/string")
const number_schema = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / tuple", function(test: butler.Test)
		test("constructs", function()
			expect(tuple_schema()):to_exist()
			expect(tuple_schema(number_schema())):to_exist()
			expect(tuple_schema(number_schema(), number_schema())):to_exist()
			expect(tuple_schema(string_schema(), number_schema())):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "tuple()",
					schema = tuple_schema(),
					sets = {
						{
							expected_size_bytes = 0,
							values = {},
						},
					},
				},
				{
					label = "tuple(number())",
					schema = tuple_schema(number_schema()),
					sets = {
						{
							expected_size_bytes = 4,
							values = { 1 },
						},
						{
							expected_size_bytes = 4,
							values = { -1000 },
						},
					},
				},
				{
					label = "tuple(number(), number())",
					schema = tuple_schema(number_schema(), number_schema()),
					sets = {
						{
							expected_size_bytes = 8,
							values = { 1, 1 },
						},
						{
							expected_size_bytes = 8,
							values = { -1000, 1000 },
						},
					},
				},
				{
					label = "tuple(string(), number())",
					schema = tuple_schema(string_schema(), number_schema()),
					sets = {
						{
							expected_size_bytes = 6,
							values = { "", 1 },
						},
						{
							expected_size_bytes = 9,
							values = { "foo", -1000 },
						},
					},
				},
				{
					label = "tuple(string(), tuple(string(), number()))",
					schema = tuple_schema(string_schema(), tuple_schema(string_schema(), number_schema())),
					sets = {
						{
							expected_size_bytes = 8,
							values = { "", "", 1 },
						},
						{
							expected_size_bytes = 14,
							values = { "foo", "bar", 1 },
						},
					},
				},
			},
		})
	end)
end
