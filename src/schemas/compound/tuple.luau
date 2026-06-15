const types = require("../../types")

const function tuple_schema<T...>(...: types.Schema<any>): types.Schema<T...>
	const tuple_order = { ... }

	return {
		write = function(b: buffer, offset: number, ...: T...)
			local current_offset = offset

			for index, schema in tuple_order do
				const value = select(index, ...)
				schema.write(b, current_offset, value)
				current_offset += schema.size(value)
			end
		end,
		read = function(b: buffer, offset: number): T...
			const output = {}
			local current_offset = offset

			for index, schema in tuple_order do
				const value = schema.read(b, current_offset)

				output[index] = value

				current_offset += schema.size(value)
			end

			return unpack(output, 1, #tuple_order)
		end,
		size = function(...: T...): number
			local total_size = 0

			for index, schema in tuple_order do
				const value = select(index, ...)

				total_size += schema.size(value)
			end

			return total_size
		end,
		validate = function(...: unknown): boolean
			for index, schema in tuple_order do
				local ok, err = schema.validate(select(index, ...))

				if not ok then
					return false, `invalid tuple item at index {index}:\n\t{err}`
				end
			end

			return true
		end,
	}
end

return tuple_schema
