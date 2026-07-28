const okserde = require("../types")

const function flatten_into<K>(
	schemas: { [K]: okserde.SizedSchema },
	prop_mapping: { [keyof<okserde.SizedSchema>]: { [K]: any } }
)
	for key, schema in schemas do
		for prop_key, prop_out in prop_mapping do
			prop_out[key] = schema[prop_key]
		end
	end
end

return flatten_into
