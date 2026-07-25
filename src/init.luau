const okserde = require("@self/types")

export type Schema<T... = ...any> = okserde.Schema<T...>
export type StaticSchema<T... = ...any> = okserde.StaticSchema<T...>
export type DynSchema<T... = ...any> = okserde.DynSchema<T...>
export type SizedSchema<T... = ...any> = okserde.SizedSchema<T...>

export type NumberEncoding = okserde.NumberEncoding

--[[
Deserializes a buffer using the provided schema.

This function does not validate that the passed values will be properly serialized, use `validate` for that.
]]
const function deserialize<T...>(schema: okserde.SizedSchema<T...>, b: buffer): T...
	return select(2, schema.read(b, 0))
end

--- Serializes values into a buffer using the provided schema.
const function serialize<T...>(schema: okserde.SizedSchema<T...>, ...: T...): buffer
	const b = buffer.create(schema.static_size or schema.dyn_size(...))
	schema.write(b, 0, ...)
	return b
end

--- Returns whether the provided values can be serialized via provided schema.
const function validate<T...>(schema: okserde.Schema<T...>, ...: T...): (boolean, string?)
	return schema.validate(...)
end

return {
	serialize = serialize,
	deserialize = deserialize,
	validate = validate,

	encodings = require("@self/encodings"),
	--- A set of schemas provided by `okserde`.
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
