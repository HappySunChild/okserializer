const okserde = require("../types")

const determine_spec = require("../utility/determine_spec")
const resolve_schemas = require("../utility/resolve_schemas")
const vararg_repr = require("../utility/vararg_repr")

const function determine_schema<T...>(schemas: { okserde.Schema }, ...: T...): (number?, okserde.Schema<T...>?)
	for index, schema in schemas do
		if schema.validate(...) then
			return index, schema
		end
	end

	return nil, nil
end

const function union_schema(...: okserde.Schema | okserde.UnresolvedSchema): okserde.Schema
	const schemas = { ... }

	const id = determine_spec(#schemas)
	const id_write, id_read, id_size = id.write, id.read, id.size

	const new_union_schema: okserde.Schema = {
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
		alloc_size = @native function(...: any): number
			const index, schema = determine_schema(schemas, ...)

			if index == nil or schema == nil then
				error(`no valid schema available in union for value(s) of type {vararg_repr(...)}`)
			end

			const value_size = schema.alloc_size(...)

			return id_size + value_size
		end,
		validate = @native function(...: unknown): (boolean, string?)
			const index, schema = determine_schema(schemas, ...)

			if index == nil or schema == nil then
				return false, `no valid schema available in union for value(s) of type {vararg_repr(...)}`
			end

			return true, nil
		end,
	}

	resolve_schemas(new_union_schema, schemas)

	return new_union_schema
end

return union_schema
