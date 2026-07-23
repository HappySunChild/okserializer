const encodings = require("@okserde/encodings")
const array = require("@okserde/schemas/array")
const number = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / array", function(test: butler.Test)
		test("throws without element schema", function()
			expect(array):to_throw()
		end)
		test("constructs", function()
			expect(array(number())):to_exist()
			expect(array(number(), encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "array of number(f32), length=u8",
					schema = array(number(encodings.f32), encodings.u8),
					value_sets = {
						{ {} },
						{ { 0 } },
						{ { -100, math.huge, math.nan, 10, -math.huge, 255 } },
						{ table.create(255, 0) },
					},
				},
				{
					label = "array of number(f32), length=u16",
					schema = array(number(encodings.u8)),
					value_sets = {
						{ {} },
						{ { 0 } },
						{ { -100, math.huge, math.nan, 10, -math.huge, 255 } },
						{ table.create(65535, 0) },
					},
				},
				{
					label = "nested arrays of number(f32), length=u8 (all)",
					schema = array(array(number(encodings.f32), encodings.u8), encodings.u8),
					value_sets = {
						{ {} },
						{ { {}, {} } },
						{ { { 0 }, {} } },
						{ { { 0 }, { 0 } } },
						{ { {}, { 0 } } },
						{ { { 127, 10 }, { 0, 987654, 1234 } } },
					},
				},
			},
		})
	end)
end
