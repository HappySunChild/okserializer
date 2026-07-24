const okserde = require("../types")

const resolve_schemas = require("../utility/resolve_schemas")
const is_static = require("../utility/is_static")

const function create_tuple_proto<T...>(
	tuple_order: { okserde.Resolvable<okserde.SizedSchema> }
): okserde.Schema<T...>
	return {
		write = @native function(b: buffer, offset: number, ...: T...): number
			local current_offset = offset

			for index, schema in tuple_order do
				current_offset += schema.write(b, current_offset, select(index, ...))
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, T...)
			const output = {}
			local current_offset = offset

			for index, schema in tuple_order do
				const read_data = { schema.read(b, current_offset) }

				table.move(read_data, 2, #read_data, #output + 1, output)

				current_offset += read_data[1]
			end

			return current_offset - offset, unpack(output)
		end,
		validate = @native function(...: unknown): (boolean, string?)
			for index, schema in tuple_order do
				local ok, err = schema.validate(select(index, ...))

				if not ok then
					return false, `invalid tuple item at index {index}:\n\t{err:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}
end

const function tuple_schema<T...>(...: okserde.Resolvable<okserde.SizedSchema>): okserde.SizedSchema<T...>
	const tuple_order = { ... }
	const proto: okserde.SizedSchema = create_tuple_proto(tuple_order)
	resolve_schemas(proto, tuple_order)

	const static, total_size = is_static(tuple_order)

	if static then
		proto.static_size = total_size
	else
		proto.dyn_size = @native function(...: T...): number
			local total_byte_count = 0

			for index, schema: okserde.Schema in tuple_order do
				total_byte_count += schema.static_size or schema.dyn_size(select(index, ...))
			end

			return total_byte_count
		end
	end

	return proto
end

return tuple_schema
