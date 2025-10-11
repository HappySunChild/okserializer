local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(len_format: types.UIntFormat?): types.Schema<string>
	local _len = formats.get(len_format, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size

	return Schema "string" {
		write = @native function(b: buffer, offset: number, value: string)
			local count = string.len(value)

			len_write(b, offset, count)
			buffer.writestring(b, offset + len_size, value, count)
		end,
		read = @native function(b: buffer, offset: number): string
			local count = len_read(b, offset)

			return buffer.readstring(b, offset + len_size, count)
		end,
		size = @native function(value: string): number
			return len_size + string.len(value)
		end,

		validate = @native function(value: unknown): boolean
			return type(value) == "string"
		end,
	}
end
