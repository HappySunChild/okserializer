local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_LEN_FORMAT = formats.u16

return function(len_format: types.UIntFormat?): types.Schema<string>
	local len_spec = if len_format == nil then DEFAULT_LEN_FORMAT else formats[len_format]
	local len_write, len_read, len_size = len_spec.write, len_spec.read, len_spec.size

	return {
		write = function(b: buffer, offset: number, value: string)
			local count = string.len(value)

			len_write(b, offset, count)
			buffer.writestring(b, offset + len_size, value, count)
		end,
		read = function(b: buffer, offset: number): string
			local count = len_read(b, offset)

			return buffer.readstring(b, offset + len_size, count)
		end,
		size = function(value: string): number
			return len_size + string.len(value) % (len_spec.max + 1)
		end,
		validate = function(value: unknown): boolean
			return type(value) == "string"
		end,
	}
end
