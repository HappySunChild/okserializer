const types = require("../../types")

const sort_with_order = require("../../utility/sort_with_order")
const resolve_schemas = require("../../utility/resolve_schemas")

const function struct_schema<T>(
	schema_dict: { [keyof<T>]: types.Schema<any> | types.UnresolvedSchema },
	order: { keyof<T> }?
): types.Schema<T>
	const ordered_keys: { keyof<T> } = {}

	for key in schema_dict do
		table.insert(ordered_keys, key)
	end

	sort_with_order(ordered_keys :: { any }, order) -- casting to any because i don't know what it wants from me

	const new_schema = {
		write = @native function(b: buffer, offset: number, in_struct: T | any): number
			local current_offset = offset

			for _, key in ordered_keys do
				const value_schema = schema_dict[key]
				const value = in_struct[key]

				current_offset += value_schema.write(b, current_offset, value)
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, T)
			const out_struct = {}

			local current_offset = offset

			for _, key in ordered_keys do
				const schema = schema_dict[key]
				const bytes_read, value = schema.read(b, current_offset)

				out_struct[key] = value
				current_offset += bytes_read
			end

			return current_offset - offset, out_struct
		end,
		alloc_size = @native function(in_struct: T | any): number
			local total_byte_count = 0

			for _, key in ordered_keys do
				const value_schema = schema_dict[key]
				const value = in_struct[key]

				total_byte_count += value_schema.alloc_size(value)
			end

			return total_byte_count
		end,
		validate = @native function(in_struct: unknown): (boolean, string?)
			if type(in_struct) ~= "table" then
				return false, `expected value of type table, got {type(in_struct)}`
			end

			in_struct = in_struct :: T | any

			for key, value_schema in schema_dict do
				local ok, err = value_schema.validate(in_struct[key])

				if not ok then
					return false, `invalid value for key {key}:\n\t{err:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}

	resolve_schemas(new_schema, schema_dict)

	return new_schema
end

return struct_schema
