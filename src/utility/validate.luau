const types = require("../types")

const function validate<T...>(schema: types.Schema<T...>, ...: T...): (boolean, string?)
	return schema.validate(...)
end

return validate
