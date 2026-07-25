const okserde = require("../types")

const determine_encoding = require("../utility/determine_encoding")
const resolve_schemas_in_place = require("../utility/resolve_schemas_in_place")
const vararg_repr = require("../utility/vararg_repr")

const function determine_schema<T...>(schemas: { okserde.Schema }, ...: T...): (number?, okserde.Schema<T...>?)
	for index, schema in schemas do
		if schema.validate(...) then
			return index, schema
		end
	end

	return nil, nil
end

const function create_union_proto(
	schemas: { okserde.SizedSchema },
	id_enc: okserde.NumberEncoding
): okserde.DynSchema
	const id_write, id_read, id_size = id_enc.write, id_enc.read, id_enc.size

	return {
		write = @native function(b: buffer, offset: number, ...: any): number
			const index, schema = determine_schema(schemas, ...)

			if index == nil or schema == nil then
				error(`no valid schema available in union for value(s) of type {vararg_repr(...)}`)
			end

			id_write(b, offset, index)

			return id_size + schema.write(b, offset + id_size, ...)
		end,
		read = @native function(b: buffer, offset: number): (number, ...any)
			const index = id_read(b, offset)
			const schema = schemas[index]

			const read_data = { schema.read(b, offset + id_size) }

			return id_size + read_data[1], unpack(read_data, 2)
		end,
		validate = @native function(...: unknown): (boolean, string?)
			const index, schema = determine_schema(schemas, ...)

			if index == nil or schema == nil then
				return false, `no valid schema available in union for value(s) of type {vararg_repr(...)}`
			end

			return true, nil
		end,

		dyn_size = @native function(...: any): number
			const index, schema = determine_schema(schemas, ...)

			if index == nil or schema == nil then
				error(`no valid schema available in union for value(s) of type {vararg_repr(...)}`)
			end

			return id_size + (schema.static_size or schema.dyn_size(...))
		end,
	}
end

const function union_schema(...: okserde.SizedSchema | okserde.UnresolvedSchema): okserde.DynSchema
	const schemas = { ... }
	const proto = create_union_proto(schemas, determine_encoding(#schemas))

	resolve_schemas_in_place(proto, schemas)

	return proto
end

return union_schema
