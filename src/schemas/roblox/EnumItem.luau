local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(enumerator: Enum, format: types.UIntFormat?): types.Schema<EnumItem>
	local _info = get_format(format, "u16")
	local write, read, size = _info.write, _info.read, _info.size

	return {
		write = function(b: buffer, offset: number, value: EnumItem)
			write(b, offset, value.Value)
		end,
		read = function(b: buffer, offset: number): EnumItem
			return enumerator:FromValue(read(b, offset))
		end,
		size = function(): number
			return size
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "EnumItem" and (value :: EnumItem).EnumType == enumerator
		end,
	}
end
