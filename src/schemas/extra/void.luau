local types = require("../../types")

return function(void_count: number): types.Schema<nil>
	return {
		write = function() end,
		read = function()
			return nil
		end,
		size = function(): number
			return void_count
		end,
		validate = function(value: unknown): boolean
			return value == nil
		end,
	}
end
