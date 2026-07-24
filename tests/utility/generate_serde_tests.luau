const butler = require("@butler/butler")
const expect = require("@butler/expect")

const okserde = require("@okserde")

type Set = {
	values: { any },
	expected_size_bytes: number,
}

type Case = {
	schema: okserde.Schema,
	label: string,
	sets: { Set },
}

type Options = {
	cases: { Case },
	test: butler.Test,
}

const function generate_serde_tests(options: Options)
	const test = options.test

	for _, case in options.cases do
		const schema, sets = case.schema, case.sets
		const write, read, dyn_size, static_size =
			schema.write, schema.read, schema.dyn_size, schema.static_size

		test(`serde {case.label}`, function(remark: (string) -> ())
			for index, set in sets do
				const values = set.values

				const size_start = os.clock()
				const size_bytes = static_size or dyn_size(unpack(values))
				const size_duration = os.clock() - size_start

				expect(size_bytes):to_equal(set.expected_size_bytes)

				const b = buffer.create(size_bytes)

				const write_start = os.clock()
				write(b, 0, unpack(values))
				const write_duration = os.clock() - write_start

				const deserialize_start = os.clock()
				const deserialized_values = { select(2, read(b, 0)) }
				const deserialize_duration = os.clock() - deserialize_start

				const duration_output = string.format(
					"size: %.2fµs, write %.2fµs, deserialize %.2fµs",
					size_duration * 1e6,
					write_duration * 1e6,
					deserialize_duration * 1e6
				)
				remark(`set #{index} with {#values} value(s): {size_bytes} bytes(s), {duration_output}`)

				expect(values):to_equal(deserialized_values)
			end
		end)
	end
end

return generate_serde_tests
