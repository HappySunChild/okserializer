local types = require("@self/types")

export type Schema<T...> = types.Schema<T...>

return table.freeze({
	version = table.freeze({
		major = 3,
		minor = 0,
		patch = 0,
	}),

	schemas = require("@self/schemas"),

	serialize = require("@self/serialize"),
	deserialize = require("@self/deserialize"),
})
