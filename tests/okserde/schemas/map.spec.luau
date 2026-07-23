const encodings = require("@okserde/encodings")
const map_schema = require("@okserde/schemas/map")
const string_schema = require("@okserde/schemas/string")
const number_schema = require("@okserde/schemas/number")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / map", function(test: butler.Test)
		test("constructs", function()
			expect(map_schema(string_schema(), string_schema())):to_exist()
			expect(map_schema(number_schema(), number_schema())):to_exist()
			expect(map_schema(number_schema(), string_schema())):to_exist()

			expect(map_schema(string_schema(), string_schema(), encodings.u8)):to_exist()
			expect(map_schema(number_schema(), number_schema(), encodings.u8)):to_exist()
			expect(map_schema(number_schema(), string_schema(), encodings.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "map(string(u8), number(u8), u8)",
					schema = map_schema(
						string_schema(encodings.u8),
						number_schema(encodings.u8),
						encodings.u8
					),
					sets = {
						{
							expected_size_bytes = 11,
							values = { { foo = 1, bar = 255 } },
						},
						{
							expected_size_bytes = 6,
							values = { { baz = 1 } },
						},
					},
				},
				{
					label = "map(number(u8), number(u8), u8)",
					schema = map_schema(
						number_schema(encodings.u8),
						number_schema(encodings.u8),
						encodings.u8
					),
					sets = {
						{
							expected_size_bytes = 7,
							values = { { 1, 2, 3 } },
						},
						{
							expected_size_bytes = 7,
							values = { { [255] = 1, [127] = 255, [78] = 21 } },
						},
					},
				},
				{
					label = "map(string(u8), string(u8), u8)",
					schema = map_schema(
						string_schema(encodings.u8),
						string_schema(encodings.u8),
						encodings.u8
					),
					sets = {
						{
							expected_size_bytes = 26,
							values = { { bar = "baz", foobar = "bazbaxqux" } },
						},
						{
							expected_size_bytes = 38,
							values = { { bar = "baz", foobar = "bazbaxqux", hello = "world" } },
						},
					},
				},
			},
		})
	end)
end
