local Types = require(script.Types)

export type Schema<V> = Types.Schema<V>

local Serializer = {
	Schemas = require(script.Schemas),
	CharacterSets = require(script.CharacterSets),

	serialize = function<V>(value: V, schema: Types.Schema<V>)
		return schema:Serialize(value)
	end,
	deserialize = function<V>(serialized: string, schema: Types.Schema<V>): V
		return schema:Deserialize(serialized)
	end,

	generateCset = require(script.Utility.generateCset),
}

return Serializer
