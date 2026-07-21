const butler = require("@butler/butler")
const okserde = require("@okserde")
const serialize, deserialize = okserde.serialize, okserde.deserialize

const is_similar = require("./is_similar")

type Case = {
	schema: okserde.Schema,
	label: string,
	values: { any },
}

type Options = {
	label: string,
	cases: { Case },
	test: butler.Test,
}

const function generate_serde_tests(options: Options)
	const test = options.test

	for _, case in options.cases do
		const schema, values = case.schema, case.values

		test(`serde / {case.label}`, function(remark: (string) -> ())
			const serialized = serialize(schema, unpack(values))

			remark(`serialized bytes: {buffer.len(serialized)}`)

			const deserialized_values = { deserialize(schema, serialized) }
			const similar = is_similar(values, deserialized_values)

			if not similar then
				error(`deserialized values were not similar to serialzed values`)
			end
		end)
	end
end

return generate_serde_tests
