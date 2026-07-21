const okserde = require("../types")

const sort_with_order = require("../utility/sort_with_order")
const resolve_schemas = require("../utility/resolve_schemas")

const function struct_schema<T>(
	shape: { [keyof<T>]: okserde.Schema<any> | okserde.UnresolvedSchema },
	order: { keyof<T> }?
): okserde.Schema<T>
	const ordered_keys: { keyof<T> } = {}

	for key in shape do
		table.insert(ordered_keys, key)
	end

	sort_with_order(ordered_keys :: { any }, order) -- casting to any because i don't know what it wants from me

	const new_schema = {
		write = @native function(b: buffer, offset: number, value: T | any): number
			local current_offset = offset

			for _, key in ordered_keys do
				const value_schema = shape[key]

				current_offset += value_schema.write(b, current_offset, value[key])
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, T)
			const output = {}

			local current_offset = offset

			for _, key in ordered_keys do
				const schema = shape[key]
				const bytes_read, value = schema.read(b, current_offset)

				output[key] = value
				current_offset += bytes_read
			end

			return current_offset - offset, output
		end,
		size = @native function(value: T | any): number
			local total_byte_count = 0

			for _, key in ordered_keys do
				const value_schema = shape[key]

				total_byte_count += value_schema.size(value[key])
			end

			return total_byte_count
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "table" then
				return false, `expected value of type table, got {type(value)}`
			end

			value = value :: T | any

			for key, value_schema in shape do
				local ok, err = value_schema.validate(value[key])

				if not ok then
					return false, `invalid value for key {key}:\n\t{err:gsub("\t", "\t\t")}`
				end
			end

			return true, nil
		end,
	}

	resolve_schemas(new_schema, shape)

	return new_schema
end

return struct_schema
