const okserde = require("../types")

const function padding_schema(byte_count: number): okserde.Schema<nil>
	return {
		write = @native function(): number
			return byte_count
		end,
		read = @native function(): (number, nil)
			return byte_count, nil
		end,
		size = @native function(): number
			return byte_count
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if value ~= nil then
				return false, "can't write to void"
			end

			return true, nil
		end,
	}
end

return padding_schema
