const types = require("../../types")

const boolean_schema = {
	write = function(b: buffer, offest: number, value: boolean)
		buffer.writeu8(b, offest, if value then 1 else 0)
	end,
	read = function(b: buffer, offset: number): boolean
		return buffer.readu8(b, offset) == 1
	end,
	size = function(): number
		return 1
	end,

	validate = function(value: unknown): (boolean, string?)
		if type(value) ~= "boolean" then
			return false, `expected value of type boolean, got {type(value)}`
		end

		return true, nil
	end,
} :: types.Schema<boolean>

return boolean_schema
