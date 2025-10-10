local types = require "@self/types"

export type Schema<T...> = types.Schema<T...>

return table.freeze {
	version = table.freeze {
		major = 0,
		minor = 2,
		patch = 0,
	},

	Schemas = require "@self/schemas",

	serialize = function<V>(value: V, schema: types.Schema<V>): buffer
		return schema:serialize(value)
	end,
	deserialize = function<V>(serialized: buffer, schema: types.Schema<V>): V
		return schema:deserialize(serialized)
	end,
}
