local types = require "../../types"

local Schema = require "../Schema"

return function<R...>(...: types.Schema<any>): types.Schema<R...>
	local tuple_order = { ... }

	return Schema "tuple" {
		write = function(b: buffer, offset: number, ...: R...)
			local current_offset = offset

			for index, schema in tuple_order do
				local value = select(index, ...)

				schema._write(b, current_offset, value)

				current_offset += schema._size(value)
			end
		end,
		read = function(b: buffer, offset: number): R...
			local output = {}
			local current_offset = offset

			for index, schema in tuple_order do
				local value = schema._read(b, current_offset)

				output[index] = value

				current_offset += schema._size(value)
			end

			return unpack(output, 1, #tuple_order)
		end,
		size = function(...: R...): number
			local total_size = 0

			for index, schema in tuple_order do
				local value = select(index, ...)

				total_size += schema._size(value)
			end

			return total_size
		end,

		validate = function(...: unknown): boolean
			for index, schema in tuple_order do
				if not schema._validate(select(index, ...)) then
					return false
				end
			end

			return true
		end,
	}
end
