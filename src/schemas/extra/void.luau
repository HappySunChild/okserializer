const types = require("../../types")

const function void_schema(void_count: number): types.Schema<nil>
	return {
		write = function(): number
			return void_count
		end,
		read = function(): (number, nil)
			return void_count, nil
		end,
		alloc_size = function(): number
			return void_count
		end,
		validate = function(value: unknown): (boolean, string?)
			if value ~= nil then
				return false, `can't write to void`
			end

			return true, nil
		end,
	}
end

return void_schema
