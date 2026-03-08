local specs = require("./specs")
local types = require("./types")

local function deserialize<T...>(schema: types.Schema<T...>, b: buffer): T...
	return schema.read(b, 0)
end

local function serialize<T...>(schema: types.Schema<T...>, ...: T...): buffer
	local b = buffer.create(schema.size(...))
	schema.write(b, 0, ...)
	return b
end

local function okserde(schemas)
	local new_okserde = {
		serialize = serialize,
		deserialize = deserialize,
		schemas = schemas,
		specs = specs,
	}

	return new_okserde
end

return okserde
