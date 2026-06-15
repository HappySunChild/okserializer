local types = require("../../types")

const DateTime_schema = {
	write = function(b: buffer, offset: number, value: DateTime)
		buffer.writef64(b, offset, value.UnixTimestampMillis)
	end,
	read = function(b: buffer, offset: number): DateTime
		return DateTime.fromUnixTimestampMillis(buffer.readf64(b, offset))
	end,
	size = function(value: DateTime): number
		return 8
	end,
	validate = function(value: unknown): (boolean, string?)
		if typeof(value) ~= "DateTime" then
			return false, `expected value of type DateTime, got {typeof(value)}`
		end

		return true, nil
	end,
} :: types.Schema<DateTime>

return DateTime_schema
