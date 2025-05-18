local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local getFormatInfo = require(package.Utility.getFormatInfo)

return function(lenFormat: Types.UIntByteFormat?): Types.Schema<string>
	local len = getFormatInfo(lenFormat, "u16")

	return Schema "string" {
		write = function(b: buffer, offset: number, value: string)
			local count = string.len(value)

			len.write(b, offset, count)
			buffer.writestring(b, offset + len.size, value, count)
		end,
		read = function(b: buffer, offset: number)
			local count = len.read(b, offset)

			return buffer.readstring(b, offset + len.size, count)
		end,
		size = function(value: string)
			return len.size + string.len(value)
		end,

	}
end
