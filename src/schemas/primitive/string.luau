local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(lenFormat: types.UIntByteFormat?): types.Schema<string>
	local _len = getFormatInfo(lenFormat, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size
	
	return Schema "string" {
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
			return len_size + string.len(value)
		end,

		validate = function(value: unknown): boolean
			return type(value) == "string"
		end,
	}
end
