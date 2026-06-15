local types = require("../../types")

const null_schema = {
	write = function() end,
	read = function(): nil
		return nil
	end,
	size = function(): number
		return 0
	end,
	validate = function(value: unknown): (boolean, string?)
		if value ~= nil then
			return false, `expected value of type nil, got {type(value)}`
		end

		return true
	end,
} :: types.Schema<nil>

return null_schema
