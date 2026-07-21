const okserde = require("@self/types")

export type Schema<T... = ...any> = okserde.Schema<T...>

return {
	serialize = require("@self/utility/serialize"),
	deserialize = require("@self/utility/deserialize"),
	validate = require("@self/utility/validate"),

	encodings = require("@self/encodings"),
	schemas = {
		array = require("@self/schemas/array"),
		bitarray = require("@self/schemas/bitarray"),
		bitstruct = require("@self/schemas/bitstruct"),
		boolean = require("@self/schemas/boolean"),
		buffer = require("@self/schemas/buffer"),
		cstring = require("@self/schemas/cstring"),
		enum = require("@self/schemas/enum"),
		flags = require("@self/schemas/flags"),
		map = require("@self/schemas/map"),
		null = require("@self/schemas/null"),
		number = require("@self/schemas/number"),
		optional = require("@self/schemas/optional"),
		padding = require("@self/schemas/padding"),
		string = require("@self/schemas/string"),
		struct = require("@self/schemas/struct"),
		transientref = require("@self/schemas/transientref"),
		tuple = require("@self/schemas/tuple"),
		union = require("@self/schemas/union"),
		vector = require("@self/schemas/vector"),
	},
}
