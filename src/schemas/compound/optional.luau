const types = require("../../types")

const null = require("../primitive/null")
const union = require("./union")

const function optional_schema<T>(schema: types.Schema<T>): types.Schema<T?>
	return union(schema, null)
end

return optional_schema
