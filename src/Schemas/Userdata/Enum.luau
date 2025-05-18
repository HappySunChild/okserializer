local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local getFormatInfo = require(package.Utility.getFormatInfo)

return function(enum: Enum, format: Types.UIntByteFormat?)
	local info = getFormatInfo(format, "u16")
	local write = info.write
	local read = info.read
	local sizeBytes = info.size

	return Schema "Enum" {
		write = function(b: buffer, offset: number, value: EnumItem)
			write(b, offset, value.Value)
		end,
		read = function(b: buffer, offset: number)
			return enum:FromValue(read(b, offset))
		end,
		size = function()
			return sizeBytes
		end,

	}
end
