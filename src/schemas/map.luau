const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_LEN_ENCODING = encodings.u16

const function create_map_proto<K, V>(
	key_schema: okserde.Schema<K>,
	value_schema: okserde.Schema<V>,
	len_enc: okserde.NumberEncoding
): okserde.Schema<{ [K]: V }>
	const len_write, len_read, len_size = len_enc.write, len_enc.read, len_enc.size

	const k_write, k_read, k_validate = key_schema.write, key_schema.read, key_schema.validate
	const v_write, v_read, v_validate = value_schema.write, value_schema.read, value_schema.validate

	return {
		write = @native function(b: buffer, offset: number, map: { [K]: V }): number
			local count = 0

			local current_offset = offset + len_size

			for key, value in map do
				current_offset += k_write(b, current_offset, key)
				current_offset += v_write(b, current_offset, value)
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
				const key_len, key = k_read(b, current_offset)
				current_offset += key_len
				const value_len, value = v_read(b, current_offset)
				current_offset += value_len

				output_map[key] = value
			end

			return current_offset - offset, output_map
		end,
		validate = @native function(map: any)
			if type(map) ~= "table" then
				return false, `expected value of type table, got {type(map)}`
			end

			for key, value in map do
				const ok_key, err_key = k_validate(key)

				if not ok_key then
					return false, `invalid key {key}:\n\t{err_key:gsub("\t", "\t\t")}`
				end

				const ok_value, err_value = v_validate(value)

				if not ok_value then
					return false, `invalid value for key {key}:\n\t{err_value:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}
end

const function map_schema<K, V>(
	key_schema: okserde.SizedSchema<K>,
	value_schema: okserde.SizedSchema<V>,
	len_enc: okserde.NumberEncoding?
): okserde.DynSchema<{ [K]: V }>
	const len = if len_enc == nil then DEFAULT_LEN_ENCODING else len_enc
	const proot: okserde.DynSchema<{ [K]: V }> = create_map_proto(key_schema, value_schema, len)

	const len_size = len.size
	const k_static_size = key_schema.static_size
	const k_dyn_size = key_schema.dyn_size
	const v_static_size = value_schema.static_size
	const v_dyn_size = value_schema.dyn_size

	-- horribly nested dyn_size dispatching, but it works

	proot.dyn_size = if k_static_size ~= nil
		then if v_static_size ~= nil
			then @native function(map: { [K]: V }): number -- static key, static value
				local count = 0

				for _ in map do
					count += 1
				end

				return len_size + (k_static_size + v_static_size) * count
			end
			else @native function(map: { [K]: V }): number -- static key, dyn value
				local total_byte_count = len_size

				for _, value in map do
					total_byte_count += k_static_size + v_dyn_size(value)
				end

				return total_byte_count
			end
		else if v_static_size ~= nil
			then @native function(map: { [K]: V }): number -- dyn key, static value
				local total_byte_count = len_size

				for key in map do
					total_byte_count += k_dyn_size(key) + v_static_size
				end

				return total_byte_count
			end
			else @native function(map: { [K]: V }): number -- dyn key, dyn value
				local total_byte_count = len_size

				for key, value in map do
					total_byte_count += k_dyn_size(key) + v_dyn_size(value)
				end

				return total_byte_count
			end

	return proot
end

return map_schema
