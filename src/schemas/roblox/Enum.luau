local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(enum: Enum, format: types.UIntByteFormat?): types.Schema<EnumItem>
	local _info = getFormatInfo(format, "u16")
	local write, read, size = _info.write, _info.read, _info.size

	return Schema "Enum"({
		write = function(b: buffer, offset: number, value: EnumItem)
			write(b, offset, value.Value)
		end,
		read = function(b: buffer, offset: number): EnumItem
			return enum:FromValue(read(b, offset))
		end,
		size = function(): number
			return size
		end,

		validate = function(value: unknown): boolean
			return typeof(value) ~= "EnumItem" and (value :: EnumItem).EnumType == enum
		end,
	})._read()
end
