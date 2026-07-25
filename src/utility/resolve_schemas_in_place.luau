const okserde = require("../types")

const function resolve_schemas_in_place(
	super: okserde.SizedSchema,
	mut_schemas: { [any]: okserde.UnresolvedSchema | okserde.SizedSchema }
)
	for key, schema in mut_schemas do
		if type(schema) == "function" then
			const new_schema = schema(super)

			if new_schema == super then
				error(
					"detected recursive schema definition with no form of indirection, did you mean to wrap it in an array or struct?",
					3
				)
			end

			mut_schemas[key] = new_schema
		end
	end
end

return resolve_schemas_in_place
