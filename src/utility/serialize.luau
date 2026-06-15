const types = require("../types")

const function serialize<T...>(schema: types.Schema<T...>, ...: T...): buffer
	const b = buffer.create(schema.size(...))
	schema.write(b, 0, ...)
	return b
end

return serialize
