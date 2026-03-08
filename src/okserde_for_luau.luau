local okserde = require("./okserde")

return okserde({
	specs = require("./specs"),
	schemas = {
		boolean = require("./schemas/language/boolean"),
		buffer = require("./schemas/language/buffer"),
		null = require("./schemas/language/null"),
		number = require("./schemas/language/number"),
		string = require("./schemas/language/string"),
		vector = require("./schemas/language/vector"),

		array = require("./schemas/compound/array"),
		optional = require("./schemas/compound/optional"),
		struct = require("./schemas/compound/struct"),
		tuple = require("./schemas/compound/tuple"),
		union = require("./schemas/compound/union"),

		bitarray = require("./schemas/extra/bitarray"),
		bitstruct = require("./schemas/extra/bitstruct"),
		charsetstring = require("./schemas/extra/charsetstring"),
		flags = require("./schemas/extra/flags"),
		nullstring = require("./schemas/extra/nullstring"),
		set = require("./schemas/extra/set"),
		termstring = require("./schemas/extra/termstring"),
		void = require("./schemas/extra/void"),
	},
})
