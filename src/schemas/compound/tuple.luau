const types = require("../../types")

const resolve_schemas = require("../../utility/resolve_schemas")

const function tuple_schema<T...>(...: types.Schema | types.UnresolvedSchema): types.Schema<T...>
	const tuple_order = { ... }

	const new_schema = {
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
		alloc_size = @native function(...: T...): number
			local total_size = 0

			for index, schema in tuple_order do
				total_size += schema.alloc_size(select(index, ...))
			end

			return total_size
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

	resolve_schemas(new_schema, tuple_order)

	return new_schema
end

return tuple_schema
