const okserde = require("../types")

const function resolve_schemas(base: okserde.Schema, schemas: { [any]: okserde.Resolvable<okserde.Schema> })
	for key, raw_schema in schemas do
		if type(raw_schema) == "function" then
			const new_schema = raw_schema(base)

			if new_schema == base then
				error(
					"detected recursive schema definition with no form of indirection, did you mean to wrap it in an array or struct?",
					3
				)
			end

			schemas[key] = new_schema
		end
	end
end

return resolve_schemas
