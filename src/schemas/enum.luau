const okserde = require("../types")

const determine_encoding = require("../utility/determine_encoding")

const function enum_schema<T>(variants: { T }): okserde.StaticSchema<T>
	const id_enc = determine_encoding(#variants)
	const id_write, id_read, id_size = id_enc.write, id_enc.read, id_enc.size

	const values_to_index = {}

	for key, value in variants do
		values_to_index[value] = key
	end

	return {
		write = @native function(b: buffer, offset: number, value: T): number
			const id = values_to_index[value]

			if id == nil then
				error(`value of type {type(value)} ({value}) not in enum`)
			end

			id_write(b, offset, id)

			return id_size
		end,
		read = @native function(b: buffer, offset: number): (number, T)
			const id = id_read(b, offset)
			const value = variants[id]

			if value == nil then
				error(`invalid set index read {id}`)
			end

			return id_size, value
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if value == nil then
				return false, "cannot store nil in a variant"
			end

			if values_to_index[value :: any] == nil then
				return false, `value of type {type(value)} ({value}) not in enum`
			end

			return true, nil
		end,

		static_size = id_size,
	}
end

return enum_schema
