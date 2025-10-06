local types = require "../../types"

local Schema = require "../Schema"

local function nextTerminator(
	value: string,
	term: string,
	offset: number?
): number
	local index = string.find(value, term, offset or 0, false)

	if index then
		return index - 1
	end

	return string.len(value)
end

return function(term: string?): types.Schema<string>
	term = term or "\0"

	local term_len = string.len(term)

	return Schema "tmstring" {
		write = function(b: buffer, offset: number, value: string)
			local count = nextTerminator(value, term)

			buffer.writestring(b, offset, value, count)
			buffer.writestring(b, offset + count, term) -- terminator
		end,
		read = function(b: buffer, offset: number): string
			-- is this better than progressively reading the buffer and then stopping at the terminator?
			-- it'd sure be a lot easier to understand than whatever nonsense this is
			local count = nextTerminator(buffer.tostring(b), term, offset + 1)
				- offset

			return buffer.readstring(b, offset, count)
		end,
		size = function(value: string)
			return nextTerminator(value, term) + term_len
		end,

		validate = function(value: unknown)
			return type(value) == "string"
		end,
	}
end
