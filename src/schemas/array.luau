const encodings = require("../encodings")
const okserde = require("../types")

const is_array = require("../utility/is_array")

const DEFAULT_LEN_ENCODING = encodings.u16

const function create_array_proto<T>(
	element_schema: okserde.Schema<T>,
	len_enc: okserde.NumberEncoding
): okserde.Schema<{ T }>
	const len_write, len_read, len_size = len_enc.write, len_enc.read, len_enc.size
	const element_write, element_read, element_validate =
		element_schema.write, element_schema.read, element_schema.validate

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
		validate = @native function(array: unknown): (boolean, string)
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

const function array_schema<T>(
	element_schema: okserde.SizedSchema<T>,
	len_enc: okserde.NumberEncoding?
): okserde.DynSchema<{ T }>
	const len = if len_enc == nil then DEFAULT_LEN_ENCODING else len_enc
	const proot: okserde.DynSchema<{ T }> = create_array_proto(element_schema, len)

	const len_size = len.size
	const element_static_size = element_schema.static_size
	const element_dyn_size = element_schema.dyn_size

	proot.dyn_size = if element_static_size ~= nil
		then @native function(array: { T }): number
			return len_size + element_static_size * #array
		end
		else @native function(array: { T }): number
			local total_byte_count = len_size

			for _, value in array do
				total_byte_count += element_dyn_size(value)
			end

			return total_byte_count
		end

	return proot
end

return array_schema
