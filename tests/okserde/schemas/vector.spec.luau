const encodings = require("@okserde/encodings")
const vector_schema = require("@okserde/schemas/vector")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / vector", function(test: butler.Test)
		test("constructs", function()
			expect(vector_schema()):to_exist()
			expect(vector_schema(encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "vector()",
					schema = vector_schema(),
					sets = {
						{
							expected_size_bytes = 12,
							values = { vector.zero },
						},
						{
							expected_size_bytes = 12,
							values = { vector.one },
						},
						{
							expected_size_bytes = 12,
							values = { vector.create(math.huge, -math.huge, math.nan) },
						},
					},
				},
				{
					label = "vector(u8)",
					schema = vector_schema(encodings.u8),
					sets = {
						{
							expected_size_bytes = 3,
							values = { vector.zero },
						},
						{
							expected_size_bytes = 3,
							values = { vector.one },
						},
						{
							expected_size_bytes = 3,
							values = { vector.create(0, 5, 255) },
						},
					},
				},
			},
		})
	end)
end
