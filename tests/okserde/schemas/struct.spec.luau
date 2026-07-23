const struct_schema = require("@okserde/schemas/struct")
const string_schema = require("@okserde/schemas/string")
const number_schema = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / struct", function(test: butler.Test)
		test("constructs", function()
			expect(struct_schema({})):to_exist()
			expect(struct_schema({ foo = string_schema() })):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "struct({})",
					schema = struct_schema({}),
					sets = {
						{
							expected_size_bytes = 0,
							values = { {} },
						},
					},
				},
				{
					label = "struct({ foo = number() })",
					schema = struct_schema({ foo = number_schema() }),
					sets = {
						{
							expected_size_bytes = 4,
							values = { { foo = 1 } },
						},
						{
							expected_size_bytes = 4,
							values = { { foo = math.nan } },
						},
					},
				},
				{
					label = "struct({ foo = string(), bar = number() })",
					schema = struct_schema({ foo = string_schema(), bar = number_schema() }),
					sets = {
						{
							expected_size_bytes = 6,
							values = { { foo = "", bar = 1 } },
						},
						{
							expected_size_bytes = 9,
							values = { { foo = "baz", bar = math.huge } },
						},
					},
				},
			},
		})
	end)
end
