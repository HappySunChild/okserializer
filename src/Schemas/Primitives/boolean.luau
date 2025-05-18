local Schema = require "../Schema"

return Schema "boolean" {
	write = function(b: buffer, offest: number, value: boolean)
		buffer.writeu8(b, offest, value and 1 or 0)
	end,
	read = function(b: buffer, offset: number)
		return buffer.readu8(b, offset) == 1
	end,
	size = function()
		return 1
	end,

	validate = function(value: unknown)
		return type(value) == "boolean"
	end,
}
