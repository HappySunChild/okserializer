local Types = require "../../Types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

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

		validate = function(value: unknown)
			if typeof(value) ~= "EnumItem" then
				return false
			end

			return (value :: EnumItem).EnumType == enum
		end,
	}
end
