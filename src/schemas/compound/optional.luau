local types = require("../../types")

local null = require("../language/null")
local union = require("./union")

return function<T>(schema: types.Schema<T>): types.Schema<T | nil>
	return union(null, schema)
end
