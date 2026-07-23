const enum_schema = require("@okserde/schemas/enum")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / enum", function(test: butler.Test)
		test("constructs", function()
			expect(enum_schema({ nil })):to_exist()
			expect(enum_schema({ 1 })):to_exist()
			expect(enum_schema({ 1, "foo", {} })):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "enum({ 1 })",
					schema = enum_schema({ 1 }),
					sets = {
						{
							expected_size_bytes = 1,
							values = { 1 },
						},
					},
				},
				{
					label = "enum({ 0, math.huge, \"foo\", \"bar\" })",
					schema = enum_schema({ 0, math.huge, "foo", "bar" }),
					sets = {
						{
							expected_size_bytes = 1,
							values = { 0 },
						},
						{
							expected_size_bytes = 1,
							values = { math.huge },
						},
						{
							expected_size_bytes = 1,
							values = { "foo" },
						},
						{
							expected_size_bytes = 1,
							values = { "bar" },
						},
					},
				},
			},
		})
	end)
end
