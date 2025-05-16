local Types = require(script.Types)

local Serializer = {
	Schemas = require(script.Schemas),
	
	-- thinking of just removing this
	serialize = function<V>(value: V, schema: Types.Schema<V>)
		return schema:Serialize(value)
	end,
	deserialize = function<V>(serialized: string, schema: Types.Schema<V>): V
		return schema:Deserialize(serialized)
	end,
}

return Serializer
