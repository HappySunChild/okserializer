local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_VALUE_SPEC = formats.u16

return function(enumerator: Enum, value_format: types.UIntFormat?): types.Schema<EnumItem>
	local value_spec = if value_format == nil then DEFAULT_VALUE_SPEC else formats[value_format]
	local write, read, size = value_spec.write, value_spec.read, value_spec.size

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
