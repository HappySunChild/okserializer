local types = require("../../types")

return {
	write = @native function() end,
	read = @native function(): nil
		return nil
	end,
	size = @native function(): number
		return 0
	end,

	validate = @native function(value: unknown): boolean
		return value == nil
	end,
} :: types.Schema<nil>
