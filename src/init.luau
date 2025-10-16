local types = require "@self/types"

export type Schema<T...> = types.Schema<T...>

return table.freeze {
	version = table.freeze {
		major = 2,
		minor = 0,
		patch = 0,
	},

	schemas = require "@self/schemas",
	Schema = require "@self/schemas/Schema",

	serialize = function<T...>(schema: types.Schema<T...>, ...: T...): buffer
		return schema:serialize(...)
	end,
	deserialize = function<T...>(schema: types.Schema<T...>, serialized: buffer): T...
		return schema:deserialize(serialized)
	end,
}
