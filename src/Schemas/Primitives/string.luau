local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(lenFormat: types.UIntByteFormat?): types.Schema<string>
	local len = getFormatInfo(lenFormat, "u16")

	return Schema "string" {
		write = function(b: buffer, offset: number, value: string)
			local count = string.len(value)

			len.write(b, offset, count)
			buffer.writestring(b, offset + len.size, value, count)
		end,
		read = function(b: buffer, offset: number): string
			local count = len.read(b, offset)

			return buffer.readstring(b, offset + len.size, count)
		end,
		size = function(value: string): number
			return len.size + string.len(value)
		end,

		validate = function(value: unknown): boolean
			return type(value) == "string"
		end,
	}
end
