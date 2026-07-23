const encodings = require("@okserde/encodings")
const buffer_schema = require("@okserde/schemas/buffer")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / buffer", function(test: butler.Test)
		test("constructs", function()
			expect(buffer_schema()):to_exist()
			expect(buffer_schema(encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "buffer()",
					schema = buffer_schema(),
					sets = {
						{
							expected_size_bytes = 2,
							values = { buffer.create(0) },
						},
						{
							expected_size_bytes = 10,
							values = { buffer.create(8) },
						},
						{
							expected_size_bytes = 2 ^ 16 + 1,
							values = { buffer.create(2 ^ 16 - 1) },
						},
					},
				},
				{
					label = "buffer(u8)",
					schema = buffer_schema(encodings.u8),
					sets = {
						{
							expected_size_bytes = 1,
							values = { buffer.create(0) },
						},
						{
							expected_size_bytes = 9,
							values = { buffer.create(8) },
						},
						{
							expected_size_bytes = 256,
							values = { buffer.create(2 ^ 8 - 1) },
						},
					},
				},
			},
		})
	end)
end
