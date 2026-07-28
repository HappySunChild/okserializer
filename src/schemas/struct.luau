const okserde = require("../types")

const is_shape_static = require("../utility/is_shape_static")
const flatten_into = require("../utility/flatten_into")
const resolve_schemas_in_place = require("../utility/resolve_schemas_in_place")
const sort_with_order = require("../utility/sort_with_order")

const function create_struct_proto<T>(
	ordered_keys: { keyof<T> },
	writes: { [keyof<T>]: okserde.write },
	reads: { [keyof<T>]: okserde.read },
	validates: { [keyof<T>]: okserde.validate }
): okserde.Schema<T>
	return {
		write = @native function(b: buffer, offset: number, value: T | any): number
			local current_offset = offset

			for _, key in ordered_keys do
				current_offset += writes[key](b, current_offset, value[key])
			end

			return current_offset - offset
		end,
		read = @native function(b: buffer, offset: number): (number, T)
			const output = {}

			local current_offset = offset

			for _, key in ordered_keys do
				const bytes_read, value = reads[key](b, current_offset)

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

			for key, validate in validates do
				const ok, err = validate(value[key])

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
	const ordered_keys = {}

	for key in shape do
		table.insert(ordered_keys, key)
	end

	sort_with_order(ordered_keys, order)

	const writes, reads, validates = {}, {}, {}
	const dyn_sizes: { [keyof<T>]: (any) -> number } = {}

	const proto: okserde.SizedSchema<T> = create_struct_proto(ordered_keys, writes, reads, validates)
	const is_static, static_size = is_shape_static(shape)

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
	flatten_into(shape, {
		write = writes,
		read = reads,
		validate = validates,
		dyn_size = dyn_sizes,
	})

	return proto
end

return struct_schema
