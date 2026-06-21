const types = require("../../types")

const function tuple_schema<T...>(...: types.Schema<any>): types.Schema<T...>
	const tuple_order = { ... }

	return {
		write = @native function(b: buffer, offset: number, ...: T...): number
			local current_offset = offset

			for index, schema in tuple_order do
				const value = select(index, ...)
				current_offset += schema.write(b, current_offset, value)
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, T...)
			const output = {}
			local current_offset = offset

			for index, schema in tuple_order do
				const bytes_read, value = schema.read(b, current_offset)

				output[index] = value
				current_offset += bytes_read
			end

			return current_offset - offset, unpack(output, 1, #tuple_order)
		end,
		alloc_size = @native function(...: T...): number
			local total_size = 0

			for index, schema in tuple_order do
				const value = select(index, ...)
				total_size += schema.alloc_size(value)
			end

			return total_size
		end,
		validate = function(...: unknown): (boolean, string?)
			for index, schema in tuple_order do
				local ok, err = schema.validate(select(index, ...))

				if not ok then
					return false, `invalid tuple item at index {index}:\n\t{err}`
				end
			end

			return true, nil
		end,
	}
end

return tuple_schema
