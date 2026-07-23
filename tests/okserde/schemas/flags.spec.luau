const flags_schema = require("@okserde/schemas/flags")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / flags", function(test: butler.Test)
		test("constructs", function()
			expect(flags_schema(1)):to_exist()
			expect(flags_schema(16)):to_exist()
			expect(flags_schema(32)):to_exist()
		end)
		test("checks flag count range", function()
			expect(flags_schema):to_throw(0)
			expect(flags_schema):to_throw(33)
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "flags(1)",
					schema = flags_schema(1),
					sets = {
						{
							expected_size_bytes = 1,
							values = { { false } },
						},
						{
							expected_size_bytes = 1,
							values = { { true } },
						},
					},
				},
				{
					label = "flags(32)",
					schema = flags_schema(32),
					sets = {
						{
							expected_size_bytes = 4,
							values = { table.create(32, true) },
						},
						{
							expected_size_bytes = 4,
							values = { table.create(32, false) },
						},
					},
				},
			},
		})
	end)
end
