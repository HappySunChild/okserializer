const okserde = require("../types")

const null = require("./null")
const union = require("./union")

const function optional_schema<T>(schema: okserde.SizedSchema<T>): okserde.DynSchema<T?>
	return union(schema, null)
end

return optional_schema
