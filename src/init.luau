const types = require("@self/types")

export type Schema<T... = ...any> = types.Schema<T...>

return {
	serialize = require("@self/utility/serialize"),
	deserialize = require("@self/utility/deserialize"),
	validate = require("@self/utility/validate"),

	specs = require("@self/specs"),
	schemas = {
		boolean = require("@self/schemas/primitive/boolean"),
		buffer = require("@self/schemas/primitive/buffer"),
		null = require("@self/schemas/primitive/null"),
		number = require("@self/schemas/primitive/number"),
		string = require("@self/schemas/primitive/string"),
		vector = require("@self/schemas/primitive/vector"),

		array = require("@self/schemas/compound/array"),
		optional = require("@self/schemas/compound/optional"),
		struct = require("@self/schemas/compound/struct"),
		tuple = require("@self/schemas/compound/tuple"),
		union = require("@self/schemas/compound/union"),

		bitarray = require("@self/schemas/extra/bitarray"),
		bitstruct = require("@self/schemas/extra/bitstruct"),
		externalref = require("@self/schemas/extra/externalref"),
		flags = require("@self/schemas/extra/flags"),
		literalvariant = require("@self/schemas/extra/literalvariant"),
		termstring = require("@self/schemas/extra/termstring"),
		void = require("@self/schemas/extra/void"),
	},
}
