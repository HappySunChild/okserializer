const types = require("../../types")

const sort_with_order = require("../../utility/sort_with_order")

const function struct_schema<T>(
	schema_dict: { [keyof<T>]: types.Schema<any> },
	order: { keyof<T> }?
): types.Schema<T>
	const ordered_keys: { keyof<T> } = {}

	for key in schema_dict do
		table.insert(ordered_keys, key)
	end

	sort_with_order(ordered_keys, order)

	return {
		write = function(b: buffer, offset: number, struct: T)
			for _, key in ordered_keys do
				const value_schema = schema_dict[key]
				const value = struct[key]

				value_schema.write(b, offset, value)

				offset += value_schema.size(value)
			end
		end,
		read = function(b: buffer, offset: number): T
			const output_dict = {}

			for _, key in ordered_keys do
				const schema = schema_dict[key]
				const value = schema.read(b, offset)

				output_dict[key] = value

				offset += schema.size(value)
			end

			return output_dict
		end,
		size = function(struct: T): number
			local byte_count = 0

			for _, key in ordered_keys do
				const schema = schema_dict[key]
				const value = struct[key]

				byte_count += schema.size(value)
			end

			return byte_count
		end,
		validate = function(struct: unknown): (boolean, string?)
			if type(struct) ~= "table" then
				return false, `expected value of type table, got {type(struct)}`
			end

			struct = struct :: T

			for key, value_schema in schema_dict do
				local ok, err = value_schema.validate(struct[key])

				if not ok then
					return false, `invalid value for key {key}:\n\t{err}`
				end
			end

			return true
		end,
	}
end

return struct_schema
