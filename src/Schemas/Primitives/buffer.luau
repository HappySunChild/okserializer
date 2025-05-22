local Types = require "../../Types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(lenFormat: Types.UIntByteFormat)
	local len = getFormatInfo(lenFormat, "u16")

	return Schema "buffer" {
		write = function(b: buffer, offset: number, value: buffer)
			local count = buffer.len(value)

			len.write(b, offset, count)
			buffer.writestring(b, offset + len.size, buffer.tostring(value))
		end,
		read = function(b: buffer, offset: number)
			local count = len.read(b, offset)

			return buffer.fromstring(buffer.readstring(b, offset + len.size, count))
		end,
		size = function(value: string)
			return len.size + buffer.len(value)
		end,

		validate = function(value: unknown)
			return type(value) == "buffer"
		end,
	}
end
