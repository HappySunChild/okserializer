const okserde = require("../types")

const resolve_schemas_in_place = require("../utility/resolve_schemas_in_place")
const flatten_into = require("../utility/flatten_into")
const is_shape_static = require("../utility/is_shape_static")

const function create_tuple_proto<T...>(
	writes: { okserde.write },
	reads: { okserde.read },
	validates: { okserde.validate }
): okserde.Schema<T...>
	return {
		write = @native function(b: buffer, offset: number, ...: T...): number
			local current_offset = offset

			for index, write in writes do
				current_offset += write(b, current_offset, select(index, ...))
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, T...)
			const output = {}
			local current_offset = offset

			for index, read in reads do
				const read_data = { read(b, current_offset) }

				table.move(read_data, 2, #read_data, #output + 1, output)

				current_offset += read_data[1]
			end

			return current_offset - offset, unpack(output)
		end,
		validate = @native function(...: unknown): (boolean, string?)
			for index, validate in validates do
				const ok, err = validate(select(index, ...))

				if not ok then
					return false, `invalid tuple item at index {index}:\n\t{err:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}
end

const function tuple_schema<T...>(...: okserde.SizedSchema | okserde.UnresolvedSchema): okserde.SizedSchema<T...>
	const tuple_schemas = { ... }
	const writes: { okserde.write }, reads: { okserde.read }, validates: { okserde.validate }, dyn_sizes: { (...any) -> number } =
		{}, {}, {}, {}

	const proto: okserde.SizedSchema = create_tuple_proto(writes, reads, validates)

	const is_static, static_size = is_shape_static(tuple_schemas)

	if is_static then
		proto.static_size = static_size
	else
		proto.dyn_size = @native function(...: T...): number
			local total_byte_count = static_size

			for index: number, dyn_size in dyn_sizes do
				total_byte_count += dyn_size(select(index, ...))
			end

			return total_byte_count
		end
	end

	resolve_schemas_in_place(proto, tuple_schemas)
	flatten_into(tuple_schemas, {
		write = writes,
		read = reads,
		validate = validates,
		dyn_size = dyn_sizes,
	})

	return proto
end

return tuple_schema
