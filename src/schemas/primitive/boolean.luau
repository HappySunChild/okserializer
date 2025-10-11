local types = require "../../types"

local Schema = require "../Schema"

return Schema "boolean" {
	write = @native function(b: buffer, offest: number, value: boolean)
		buffer.writeu8(b, offest, value and 1 or 0)
	end,
	read = @native function(b: buffer, offset: number): boolean
		return buffer.readu8(b, offset) == 1
	end,
	size = @native function(): number
		return 1
	end,

	validate = @native function(value: unknown): boolean
		return type(value) == "boolean"
	end,
} :: types.Schema<boolean>
