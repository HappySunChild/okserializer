local types = require "../../types"

local Schema = require "../Schema"

return Schema "DateTime" {
	write = @native function(b: buffer, offset: number, value: DateTime)
		buffer.writef64(b, offset, value.UnixTimestampMillis)
	end,
	read = @native function(b: buffer, offset: number): DateTime
		local milliseconds = buffer.readf64(b, offset)

		return DateTime.fromUnixTimestampMillis(milliseconds)
	end,
	size = @native function(value: DateTime): number
		return 8
	end,

	validate = @native function(value: unknown): boolean
		return typeof(value) == "DateTime"
	end,
} :: types.Schema<DateTime>
