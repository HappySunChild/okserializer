const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_LEN_ENCODING = encodings.u16

const function map_schema<K, V>(
	key_schema: okserde.Schema<K>,
	value_schema: okserde.Schema<V>,
	len_enc: okserde.NumberEncoding?
): okserde.Schema<{ [K]: V }>
	const len = if len_enc == nil then DEFAULT_LEN_ENCODING else len_enc
	const len_write, len_read, len_size = len.write, len.read, len.size

	const key_write, key_read, key_size, key_validate =
		key_schema.write, key_schema.read, key_schema.size, key_schema.validate
	const value_write, value_read, value_size, value_validate =
		value_schema.write, value_schema.read, value_schema.size, value_schema.validate

	return {
		write = @native function(b: buffer, offset: number, map: { [K]: V }): number
			local count = 0

			local current_offset = offset + len_size

			for key, value in map do
				current_offset += key_write(b, current_offset, key)
				current_offset += value_write(b, current_offset, value)
				count += 1
			end

			len_write(b, offset, count)

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, { [K]: V })
			const output_map = {}

			const count = len_read(b, offset)
			local current_offset = offset + len_size

			for i = 1, count do
				const key_len, key = key_read(b, current_offset)
				current_offset += key_len
				const value_len, value = value_read(b, current_offset)
				current_offset += value_len

				output_map[key] = value
			end

			return current_offset - offset, output_map
		end,
		size = @native function(map: { [K]: V })
			local total_byte_count = len_size

			for key, value in map do
				total_byte_count += key_size(key) + value_size(value)
			end

			return total_byte_count
		end,
		validate = @native function(map: any)
			if type(map) ~= "table" then
				return false, `expected value of type table, got {type(map)}`
			end

			for key, value in map do
				const ok_key, err_key = key_validate(key)

				if not ok_key then
					return false, `invalid key {key}:\n\t{err_key:gsub("\t", "\t\t")}`
				end

				const ok_value, err_value = value_validate(value)

				if not ok_value then
					return false, `invalid value for key {key}:\n\t{err_value:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}
end

return map_schema
