const constant = require("@okserde/encodings/constant")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("encoding / constant", function(test: butler.Test)
		test("constructs a NumberEncoding", function()
			const encoding = constant(0)

			expect(encoding):to_have_keys_of_type({
				write = "function",
				read = "function",
				size = "number",
				min = "number",
				max = "number",
			})
		end)
		test("properties", function()
			const encoding = constant(15)

			expect(encoding.size):to_equal(0)
			expect(encoding.max):to_equal(15)
			expect(encoding.min):to_equal(15)
		end)
		test("always reads as set number", function()
			const encoding_a = constant(1)
			const encoding_b = constant(-123)

			expect(encoding_a.read()):to_equal(1)
			expect(encoding_b.read()):to_equal(-123)
		end)
	end)
end
