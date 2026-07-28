const okserde = require("../types")

const function flatten_into<K>(
	schemas: { [K]: okserde.SizedSchema },
	mut_props: { [K]: any },
	prop_key: keyof<okserde.SizedSchema>
)
	for key, schema in schemas do
		mut_props[key] = schema[prop_key]
	end
end

return flatten_into
