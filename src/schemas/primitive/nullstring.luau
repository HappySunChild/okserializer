local types = require "../../types"

local Schema = require "../Schema"

local function nextTerminator(value: string, offset: number?): number
	local _, finish = string.find(value, "\0", offset or 0, false)

	if finish then
		return finish - 1
	end

	return string.len(value)
end

return Schema "nullstring" {
	write = function(b: buffer, offset: number, value: string)
		local count = nextTerminator(value)

		buffer.writestring(b, offset, value, count)
		buffer.writeu8(b, offset + count, 0) -- null terminator byte
	end,
	read = function(b: buffer, offset: number): string
		local count = nextTerminator(buffer.tostring(b), offset) - offset

		return buffer.readstring(b, offset, count)
	end,
	size = function(value: string)
		return nextTerminator(value) + 1
	end,

	validate = function(value: unknown)
		return type(value) == "string"
	end,
} :: types.Schema<string>
