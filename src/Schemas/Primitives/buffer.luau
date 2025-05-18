local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local getFormatInfo = require(package.Utility.getFormatInfo)

return function(lenFormat: Types.UIntByteFormat)
	local len = getFormatInfo(lengthFormat, "u16")

	return Schema "buffer" {
		write = function(b: buffer, offset: number, value: buffer)
			local count = buffer.len(value)

			len.write(b, offset, count)
			buffer.writestring(b, offset + len.size, buffer.tostring(value))
		end,
		read = function(b: buffer, offset: number)
			local count = len.read(b, offset)

			return buffer.fromstring(b, offset + len.size, count)
		end,
		size = function(value: string)
			return len.size + buffer.len(value)
		end,

	}
end
