const types = require("@self/types")

export type Schema<T... = ...any> = types.Schema<T...>

return {
	serialize = require("@self/utility/serialize"),
	deserialize = require("@self/utility/deserialize"),
	validate = require("@self/utility/validate"),

	specs = require("@self/specs"),
	schemas = {
		array = require("@self/schemas/array"),
		bitarray = require("@self/schemas/bitarray"),
		bitstruct = require("@self/schemas/bitstruct"),
		boolean = require("@self/schemas/boolean"),
		buffer = require("@self/schemas/buffer"),
		enum = require("@self/schemas/enum"),
		externalref = require("@self/schemas/externalref"),
		flags = require("@self/schemas/flags"),
		map = require("@self/schemas/map"),
		null = require("@self/schemas/null"),
		number = require("@self/schemas/number"),
		optional = require("@self/schemas/optional"),
		string = require("@self/schemas/string"),
		struct = require("@self/schemas/struct"),
		termstring = require("@self/schemas/termstring"),
		tuple = require("@self/schemas/tuple"),
		union = require("@self/schemas/union"),
		vector = require("@self/schemas/vector"),
		void = require("@self/schemas/void"),
	},
}
