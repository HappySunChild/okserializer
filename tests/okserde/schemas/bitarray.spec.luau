const encodings = require("@okserde/encodings")
const bitarray = require("@okserde/schemas/bitarray")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / bitarray", function(test: butler.Test)
		test("constructs", function()
			expect(bitarray(1)):to_exist()
			expect(bitarray(1, encodings.u8)):to_exist()
		end)
		test("throws without element bitwidth", function()
			expect(bitarray):to_throw()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "bitarray(2, u8)",
					schema = bitarray(2, encodings.u8),
					sets = {
						{
							expected_size_bytes = 1,
							values = { {} },
						},
						{
							expected_size_bytes = 2,
							values = { { 0 } },
						},
						{
							expected_size_bytes = 3,
							values = { { 3, 2, 0, 0, 1, 2 } },
						},
					},
				},
				{
					label = "bitarray(4, u8)",
					schema = bitarray(4, encodings.u8),
					sets = {
						{
							expected_size_bytes = 1,
							values = { {} },
						},
						{
							expected_size_bytes = 2,
							values = { { 0 } },
						},
						{
							expected_size_bytes = 5,
							values = { { 15, 0, 2, 4, 3, 3, 1 } },
						},
						{
							expected_size_bytes = 129,
							values = { table.create(255, 0) },
						},
					},
				},
				{
					label = "bitarray(4, u16)",
					schema = bitarray(4, encodings.u16),
					sets = {
						{
							expected_size_bytes = 2,
							values = { {} },
						},
						{
							expected_size_bytes = 3,
							values = { { 0 } },
						},
						{
							expected_size_bytes = 6,
							values = { { 15, 0, 2, 4, 3, 3, 1 } },
						},
						{
							expected_size_bytes = math.ceil(65535 * 4 / 8) + 2,
							values = { table.create(65535, 0) },
						},
					},
				},
			},
		})
	end)
end
