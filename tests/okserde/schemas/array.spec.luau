const specs = require("@okserde/specs")
const array = require("@okserde/schemas/array")
const number = require("@okserde/schemas/number")
const string = require("@okserde/schemas/string")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("array", function(test: butler.Test)
		test("throws without element schema", function()
			expect(array):to_throw()
		end)
		test("constructs", function()
			expect(array(number())):to_exist()
			expect(array(number(), specs.u8)):to_exist()
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					schema = array(number(specs.u8)),
					label = "number(u8)",
					values = { { 0, 255, 127 } },
				},
				{
					schema = array(string(specs.u8)),
					label = "string(u8)",
					values = { { "hello", "world", "foo", "bar" } },
				},
			},
		})
	end)
end
