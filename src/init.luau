local types = require "@self/types"

export type Schema<V> = types.Schema<V>

return table.freeze {
	Schemas = require "@self/Schemas",

	serialize = function<V>(value: V, schema: types.Schema<V>)
		return schema:Serialize(value)
	end,
	deserialize = function<V>(serialized: string, schema: types.Schema<V>): V
		return schema:Deserialize(serialized)
	end,
}
