const okserde = require("../types")

const DateTime_schema: okserde.StaticSchema<DateTime> = {
	write = @native function(b: buffer, offset: number, value: DateTime): number
		return 8, buffer.writef64(b, offset, value.UnixTimestampMillis)
	end,
	read = @native function(b: buffer, offset: number): (number, DateTime)
		return 8, DateTime.fromUnixTimestampMillis(buffer.readf64(b, offset))
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "DateTime" then
			return false, `expected value of type DateTime, got {typeof(value)}`
		end

		return true, nil
	end,

	static_size = 8,
}

return DateTime_schema
