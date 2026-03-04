local types = require("../types")

local function deserialize<T...>(schema: types.Schema<T...>, b: buffer): T...
	return schema.read(b, 0)
end

return deserialize
