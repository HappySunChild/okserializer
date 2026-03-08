local types = require("../../types")

return {
	write = function(b: buffer, offset: number, value: DateTime)
		buffer.writef64(b, offset, value.UnixTimestampMillis)
	end,
	read = function(b: buffer, offset: number): DateTime
		return DateTime.fromUnixTimestampMillis(buffer.readf64(b, offset))
	end,
	size = function(value: DateTime): number
		return 8
	end,
	validate = function(value: unknown): boolean
		return typeof(value) == "DateTime"
	end,
} :: types.Schema<DateTime>
