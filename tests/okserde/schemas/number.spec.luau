const encodings = require("@okserde/encodings")
const number_schema = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / number", function(test: butler.Test)
		test("constructs", function()
			expect(number_schema()):to_exist()
			expect(number_schema(encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "number()",
					schema = number_schema(),
					sets = {
						{
							expected_size_bytes = 4,
							values = { 0 },
						},
						{
							expected_size_bytes = 4,
							values = { 0.5 },
						},
						{
							expected_size_bytes = 4,
							values = { -10.5 },
						},
						{
							expected_size_bytes = 4,
							values = { math.huge },
						},
						{
							expected_size_bytes = 4,
							values = { math.nan },
						},
					},
				},
				{
					label = "number(u8)",
					schema = number_schema(encodings.u8),
					sets = {
						{
							expected_size_bytes = 1,
							values = { 0 },
						},
						{
							expected_size_bytes = 1,
							values = { 255 },
						},
						{
							expected_size_bytes = 1,
							values = { 67 },
						},
					},
				},
			},
		})
	end)
end
