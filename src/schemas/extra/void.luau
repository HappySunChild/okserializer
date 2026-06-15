const types = require("../../types")

const function void_schema(void_count: number): types.Schema<nil>
	return {
		write = function() end,
		read = function()
			return nil
		end,
		size = function(): number
			return void_count
		end,
		validate = function(value: unknown): (boolean, string?)
			return value == nil, nil
		end,
	}
end

return void_schema
