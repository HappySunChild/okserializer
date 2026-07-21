const specs = require("../specs")
const okserde = require("../types")

const is_array = require("../utility/is_array")

const DEFAULT_LEN_SPEC = specs.u16

const function array_schema<T>(
	element_schema: okserde.Schema<T>,
	len_spec: okserde.NumberTypeSpec?
): okserde.Schema<{ T }>
	const len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	const len_write, len_read, len_size = len.write, len.read, len.size

	const element_write, element_read, element_size, element_validate =
		element_schema.write, element_schema.read, element_schema.size, element_schema.validate

	return {
		write = @native function(b: buffer, offset: number, array: { T }): number
			len_write(b, offset, #array)

			local current_offset = offset + len_size

			for _, value in array do
				current_offset += element_write(b, current_offset, value)
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, { T })
			const count = len_read(b, offset)
			const output = table.create(count)

			local current_offset = offset + len_size

			for i = 1, count do
				const bytes_read, value = element_read(b, current_offset)
				output[i] = value

				current_offset += bytes_read
			end

			return current_offset - offset, output
		end,
		size = @native function(array: { T }): number
			local total_byte_count = len_size

			for _, value in array do
				total_byte_count += element_size(value)
			end

			return total_byte_count
		end,
		validate = @native function(array: unknown): (boolean, string?)
			if not is_array(array) then
				return false, "expected array value"
			end

			for index, element in array :: { T } do
				local ok, err = element_validate(element)

				if not ok then
					return false, `invalid array element at index {index}:\n\t{err:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}
end

return array_schema
