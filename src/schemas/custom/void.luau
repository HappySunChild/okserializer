local types = require "../../types"

local Schema = require "../Schema"

return function(void_count: number): types.Schema<nil>
	return Schema "void" {
		write = @native function() end,
		read = @native function() end,
		size = @native function(): number
			return void_count
		end,

		validate = @native function(value: unknown): boolean
			return value == nil
		end,
	}
end
