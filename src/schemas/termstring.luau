const okserde = require("../types")

const NULL_TERMINATOR = "\0"

const function next_terminator(value: string, offset: number?): number
	const index = string.find(value, NULL_TERMINATOR, offset or 0, false)

	if index then
		return index - 1
	end

	return string.len(value)
end

const termstring_schema: okserde.Schema<string> = {
	write = @native function(b: buffer, offset: number, value: string): number
		const count = next_terminator(value)

		buffer.writestring(b, offset, value, count)
		buffer.writestring(b, offset + count, NULL_TERMINATOR) -- append terminator

		return 1 + count
	end,
	read = @native function(b: buffer, offset: number): (number, string)
		-- is this better than progressively reading the buffer and then stopping at the terminator?
		-- it'd sure be a lot easier to understand than whatever nonsense this is
		const count = next_terminator(buffer.tostring(b), offset + 1) - offset

		return 1 + count, buffer.readstring(b, offset, count)
	end,
	size = @native function(value: string): number
		return 1 + next_terminator(value)
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if type(value) ~= "string" then
			return false, `expected value of type string, got {type(value)}`
		end

		return true, nil
	end,
}

return termstring_schema
