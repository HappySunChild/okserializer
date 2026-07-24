const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_LEN_ENCODING = encodings.u16

const function string_schema(len_enc: okserde.NumberEncoding?): okserde.DynSchema<string>
	const len = if len_enc == nil then DEFAULT_LEN_ENCODING else len_enc
	const len_write, len_read, len_size, len_max = len.write, len.read, len.size, len.max

	return {
		write = @native function(b: buffer, offset: number, value: string): number
			const count = string.len(value)

			len_write(b, offset, count)
			buffer.writestring(b, offset + len_size, value, count)

			return len_size + count
		end,
		read = @native function(b: buffer, offset: number): (number, string)
			const count = len_read(b, offset)

			return len_size + count, buffer.readstring(b, offset + len_size, count)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "string" then
				return false, `expected value of type string, got {type(value)}`
			end

			if string.len(value) > len_max then
				return false,
					`string length ({string.len(value)}) is larger than specified length spec maximum value ({len_max})`
			end

			return true, nil
		end,

		dyn_size = @native function(value: string): number
			return len_size + string.len(value) % (len_max + 1)
		end,
	}
end

return string_schema
