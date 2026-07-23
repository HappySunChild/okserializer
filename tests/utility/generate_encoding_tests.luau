const okserde = require("@okserde")
const butler = require("@butler/butler")
const expect = require("@butler/expect")

type Options = {
	label: string,
	encoding: okserde.NumberEncoding,
	values: { number },
	test: butler.Test,
}

const function generate_encoding_tests(options: Options)
	const test, encoding, values, label = options.test, options.encoding, options.values, options.label

	table.insert(values, encoding.min)
	table.insert(values, encoding.max)

	test(`{label} format sanity`, function()
		expect(encoding):to_have_keys_of_type({
			write = "function",
			read = "function",
			size = "number",
			min = "number",
			max = "number",
		})
	end)

	test(`{label} read/write`, function()
		const b = buffer.create(encoding.size)

		for _, original_value in values do
			expect(encoding.write):to_never_throw(b, 0, original_value)
			expect(encoding.read(b, 0)):to_be_near(original_value, 1e-6)
		end
	end)
end

return generate_encoding_tests
