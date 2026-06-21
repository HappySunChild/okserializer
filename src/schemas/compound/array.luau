const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_LEN_SPEC = specs.u16

const is_array = require("../../utility/is_array")

const function array_schema<T>(schema: types.Schema<T>, len_spec: types.NumberTypeSpec?): types.Schema<{ T }>
	const len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	const len_write, len_read, len_size = len.write, len.read, len.size

	const schema_write, schema_read, schema_alloc_size, schema_validate =
		schema.write, schema.read, schema.alloc_size, schema.validate

	return {
		write = @native function(b: buffer, offset: number, array: { T }): number
			len_write(b, offset, #array)

			local current_offset = offset + len_size

			for _, value in array do
				const bytes_written = schema_write(b, current_offset, value)
				current_offset += bytes_written
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, { T })
			const count = len_read(b, offset)
			const output = table.create(count)

			local current_offset = offset + len_size

			for i = 1, count do
				const bytes_read, value = schema_read(b, current_offset)
				output[i] = value

				current_offset += bytes_read
			end

			return current_offset - offset, output
		end,
		alloc_size = @native function(array: { T }): number
			local total_byte_count = len_size

			for _, value in array do
				total_byte_count += schema_alloc_size(value)
			end

			return total_byte_count
		end,
		validate = function(array: unknown): (boolean, string?)
			if not is_array(array) then
				return false, "expected array value"
			end

			for index, element in array :: { T } do
				local ok, err = schema_validate(element)

				if not ok then
					return false, `invalid array element at index {index}:\n\t{err}`
				end
			end

			return true, nil
		end,
	}
end

return array_schema
