const encodings = require("@okserde/encodings")
const array_schema = require("@okserde/schemas/array")
const number_schema = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / array", function(test: butler.Test)
		test("constructs", function()
			expect(array_schema(number_schema())):to_exist()
			expect(array_schema(number_schema(), encodings.u8)):to_exist()
		end)
		test("throws without element schema", function()
			expect(array_schema):to_throw()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "array(number(f32), u8)",
					schema = array_schema(number_schema(encodings.f32), encodings.u8),
					sets = {
						{
							expected_size_bytes = 1,
							values = { {} },
						},
						{
							expected_size_bytes = 5,
							values = { { 0 } },
						},
						{
							expected_size_bytes = 25,
							values = { { -100, math.huge, math.nan, 10, -math.huge, 255 } },
						},
						{
							expected_size_bytes = 255 * 4 + 1,
							values = { table.create(255, 0) },
						},
					},
				},
				{
					label = "array(number(f32), u16)",
					schema = array_schema(number_schema(encodings.f32), encodings.u16),
					sets = {
						{
							expected_size_bytes = 2,
							values = { {} },
						},
						{
							expected_size_bytes = 6,
							values = { { 0 } },
						},
						{
							expected_size_bytes = 26,
							values = { { -100, math.huge, math.nan, 10, -math.huge, 255 } },
						},
						{
							expected_size_bytes = 65535 * 4 + 2,
							values = { table.create(65535, 0) },
						},
					},
				},
				{
					label = "array(array(number(f32), u8), u8)",
					schema = array_schema(
						array_schema(number_schema(encodings.f32), encodings.u8),
						encodings.u8
					),
					sets = {
						{
							expected_size_bytes = 1,
							values = { {} },
						},
						{
							expected_size_bytes = 3,
							values = { { {}, {} } },
						},
						{
							expected_size_bytes = 7,
							values = { { { 0 }, {} } },
						},
						{
							expected_size_bytes = 11,
							values = { { { 0 }, { 0 } } },
						},
						{
							expected_size_bytes = 7,
							values = { { {}, { 0 } } },
						},
						{
							expected_size_bytes = 23,
							values = { { { 127, 10 }, { 0, 987654, 1234 } } },
						},
					},
				},
			},
		})
	end)
end
