local types = require("../types")

local function serialize<T...>(schema: types.Schema<T...>, ...: T...): buffer
	local b = buffer.create(schema.size(...))
	schema.write(b, 0, ...)
	return b
end

return serialize
