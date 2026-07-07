const types = require("../../types")

const boolean_schema: types.Schema<boolean> = {
	write = @native function(b: buffer, offest: number, value: boolean): number
		buffer.writeu8(b, offest, if value then 1 else 0)
		return 1
	end,
	read = @native function(b: buffer, offset: number): (number, boolean)
		return 1, buffer.readu8(b, offset) == 1
	end,
	alloc_size = @native function(): number
		return 1
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if type(value) ~= "boolean" then
			return false, `expected value of type boolean, got {type(value)}`
		end

		return true, nil
	end,
}

return boolean_schema
