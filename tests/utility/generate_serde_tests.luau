const butler = require("@butler/butler")
const okserde = require("@okserde")
const serialize, deserialize = okserde.serialize, okserde.deserialize

const is_similar = require("./is_similar")

type Case = {
	schema: okserde.Schema,
	label: string,
	value_sets: { { any } },
}

type Options = {
	cases: { Case },
	test: butler.Test,
}

const function generate_serde_tests(options: Options)
	const test = options.test

	for _, case in options.cases do
		const schema, value_sets = case.schema, case.value_sets

		test(`serde {case.label}`, function(remark: (string) -> ())
			for index, value_set in value_sets do
				const serialize_start = os.clock()
				const serialized_b = serialize(schema, unpack(value_set))
				const serialize_duration = os.clock() - serialize_start

				const deserialize_start = os.clock()
				const deserialized_set = { deserialize(schema, serialized_b) }
				const deserialize_duration = os.clock() - deserialize_start

				const duration_output = string.format(
					"serialize %.2fµs, deserialize %.2fµs",
					serialize_duration * 1e6,
					deserialize_duration * 1e6
				)

				remark(
					`set #{index} with {#value_set} value(s): {buffer.len(serialized_b)} bytes(s), {duration_output}`
				)

				const similar = is_similar(value_set, deserialized_set)

				if not similar then
					error(`deserialized values were not similar to serialized values`)
				end
			end
		end)
	end
end

return generate_serde_tests
