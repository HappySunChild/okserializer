const types = require("../../types")

const function next_terminator(value: string, term: string, offset: number?): number
	const index = string.find(value, term, offset or 0, false)

	if index then
		return index - 1
	end

	return string.len(value)
end

const function termstring_schema(term: string?): types.Schema<string>
	const n_term: string = term or "\0"
	const term_len = string.len(n_term)

	return {
		write = @native function(b: buffer, offset: number, value: string): number
			const count = next_terminator(value, n_term)

			buffer.writestring(b, offset, value, count)
			buffer.writestring(b, offset + count, n_term) -- append terminator

			return term_len + count
		end,
		read = @native function(b: buffer, offset: number): (number, string)
			-- is this better than progressively reading the buffer and then stopping at the terminator?
			-- it'd sure be a lot easier to understand than whatever nonsense this is
			const count = next_terminator(buffer.tostring(b), n_term, offset + 1) - offset

			return term_len + count, buffer.readstring(b, offset, count)
		end,
		alloc_size = @native function(value: string): number
			return term_len + next_terminator(value, n_term)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "string" then
				return false, `expected value of type string, got {type(value)}`
			end

			return true, nil
		end,
	}
end

return termstring_schema
