local types = require("./types")

local function deserialize<T...>(schema: types.Schema<T...>, b: buffer): T...
	return schema.read(b, 0)
end

local function serialize<T...>(schema: types.Schema<T...>, ...: T...): buffer
	local b = buffer.create(schema.size(...))
	schema.write(b, 0, ...)
	return b
end

type Options<Schemas, Specs> = {
	schemas: Schemas,
	specs: Specs,
}

type Configured<Schemas, Specs> = {
	serialize: <T...>(schema: types.Schema<T...>, T...) -> buffer,
	deserialize: <T...>(schema: types.Schema<T...>, buffer) -> T...,
	schemas: Schemas,
	specs: Specs,
}

local function okserde<Schemas, Specs>(options: Options<Schemas, Specs>): Configured<Schemas, Specs>
	local new_okserde = {
		serialize = serialize,
		deserialize = deserialize,
		schemas = options.schemas,
		specs = options.specs,
	}

	return new_okserde
end

return okserde
