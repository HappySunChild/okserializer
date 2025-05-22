local Types = require "@self/Types"

export type Schema<V> = Types.Schema<V>

local Serializer = {
	Schemas = require "@self/Schemas",
	CharacterSets = require "@self/CharacterSets",

	generateCset = require "@self/Utility/generateCset",

	serialize = function<V>(value: V, schema: Types.Schema<V>)
		return schema:Serialize(value)
	end,
	deserialize = function<V>(serialized: string, schema: Types.Schema<V>): V
		return schema:Deserialize(serialized)
	end,
}

return Serializer
