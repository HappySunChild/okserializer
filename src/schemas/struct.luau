const okserde = require("../types")

const is_shape_static = require("../utility/is_shape_static")
const move_dyn_sizes_into = require("../utility/move_dyn_sizes_into")
const resolve_schemas_in_place = require("../utility/resolve_schemas_in_place")
const sort_with_order = require("../utility/sort_with_order")

const function create_struct_proto<T>(
	shape: { [keyof<T>]: okserde.SizedSchema },
	order: { keyof<T> }
): okserde.Schema<T>
	const ordered_keys: { keyof<T> } = {}

	for key in shape do
		table.insert(ordered_keys, key)
	end

	sort_with_order(ordered_keys, order)

	return {
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
end

const function struct_schema<T>(
	shape: { [keyof<T>]: okserde.SizedSchema | okserde.UnresolvedSchema },
	order: { keyof<T> }?
): okserde.SizedSchema<T>
	const proto: okserde.SizedSchema<T> = create_struct_proto(shape, order)
	const is_static, static_size = is_shape_static(shape)

	const dyn_sizes: { [keyof<T>]: (index<T, keyof<T>>) -> number } = {}

	if is_static then
		proto.static_size = static_size
	else
		proto.dyn_size = @native function(value: T | any): number
			local total_byte_count = static_size

			for key, dyn_size in dyn_sizes do
				total_byte_count += dyn_size(value[key])
			end

			return total_byte_count
		end
	end

	resolve_schemas_in_place(proto, shape)
	move_dyn_sizes_into(shape, dyn_sizes)

	return proto
end

return struct_schema
