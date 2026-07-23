const encodings = require("@okserde/encodings")
const bitstruct_schema = require("@okserde/schemas/bitstruct")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / bitstruct", function(test: butler.Test)
		test("constructs", function()
			expect(bitstruct_schema({})):to_exist()
			expect(bitstruct_schema({}, encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "bitstruct({})",
					schema = bitstruct_schema({}),
					sets = {
						{
							expected_size_bytes = 0,
							values = { {} },
						},
					},
				},
				{
					label = "bitstruct({ foo = 1 })",
					schema = bitstruct_schema({ foo = 1 }),
					sets = {
						{
							expected_size_bytes = 1,
							values = { { foo = 0 } },
						},
						{
							expected_size_bytes = 1,
							values = { { foo = 1 } },
						},
					},
				},
				{
					label = "bitstruct({ foo = 4, bar = 4 })",
					schema = bitstruct_schema({ foo = 4, bar = 4 }),
					sets = {
						{
							expected_size_bytes = 1,
							values = { { foo = 0, bar = 0 } },
						},
						{
							expected_size_bytes = 1,
							values = { { foo = 15, bar = 15 } },
						},
						{
							expected_size_bytes = 1,
							values = { { foo = 2, bar = 9 } },
						},
					},
				},
				{
					label = "bitstruct({ foo = 4, bar = 4, baz = 4 })",
					schema = bitstruct_schema({ foo = 4, bar = 4, baz = 4 }),
					sets = {
						{
							expected_size_bytes = 2,
							values = { { foo = 0, bar = 0, baz = 0 } },
						},
						{
							expected_size_bytes = 2,
							values = { { foo = 15, bar = 15, baz = 15 } },
						},
						{
							expected_size_bytes = 2,
							values = { { foo = 1, bar = 2, baz = 3 } },
						},
					},
				},
			},
		})
	end)
end
