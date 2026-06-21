const types = require("../types")

const function deserialize<T...>(schema: types.Schema<T...>, b: buffer): T...
	return select(2, schema.read(b, 0))
end

return deserialize
