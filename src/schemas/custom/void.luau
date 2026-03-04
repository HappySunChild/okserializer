local types = require("../../types")

return function(void_count: number): types.Schema<nil>
	return {
		write = @native function() end,
		read = @native function()
			return nil
		end,
		size = @native function(): number
			return void_count
		end,
		validate = @native function(value: unknown): boolean
			return value == nil
		end,
	}
end
