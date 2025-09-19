local types = require "@self/types"

export type Schema<V> = types.Schema<V>

return table.freeze {
	Schemas = require "@self/Schemas",

	serialize = function<V>(value: V, schema: types.Schema<V>): buffer
		return schema:serialize(value)
	end,
	deserialize = function<V>(serialized: buffer, schema: types.Schema<V>): V
		return schema:deserialize(serialized)
	end,
}
