const okserde = require("../types")

const function void_schema(void_count: number): okserde.Schema<nil>
	return {
		write = @native function(): number
			return void_count
		end,
		read = @native function(): (number, nil)
			return void_count, nil
		end,
		alloc_size = @native function(): number
			return void_count
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if value ~= nil then
				return false, `can't write to void`
			end

			return true, nil
		end,
	}
end

return void_schema
