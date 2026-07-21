const okserde = require("../types")

const null_schema: okserde.Schema<nil> = {
	write = @native function(): number
		return 0
	end,
	read = @native function(): (number, nil)
		return 0, nil
	end,
	alloc_size = @native function(): number
		return 0
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if value ~= nil then
			return false, `expected value of type nil, got {type(value)}`
		end

		return true, nil
	end,
}

return null_schema
