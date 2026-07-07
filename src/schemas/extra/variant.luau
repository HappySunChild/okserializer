const types = require("../../types")

const determine_spec = require("../../utility/determine_spec")

const function variant_schema<T>(set: { T }): types.Schema<T>
	const spec = determine_spec(#set)
	const write, read, size = spec.write, spec.read, spec.size

	const values_to_index = {}

	for key, value in set do
		values_to_index[value] = key
	end

	return {
		write = @native function(b: buffer, offset: number, value: T): number
			const index = values_to_index[value]

			if index == nil then
				error(`value of type {type(value)} ({value}) not in variant`)
			end

			write(b, offset, index)

			return size
		end,
		read = @native function(b: buffer, offset: number): (number, T)
			const index = read(b, offset)
			const value = set[index]

			if value == nil then
				error(`invalid set index read {index}`)
			end

			return size, value
		end,
		alloc_size = @native function(): number
			return size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if value == nil then
				return false, "cannot store nil in a variant"
			end

			if values_to_index[value :: any] == nil then
				return false, `value of type {type(value)} ({value}) not in variant`
			end

			return true, nil
		end,
	}
end

return variant_schema
