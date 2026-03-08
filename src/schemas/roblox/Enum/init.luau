local types = require("../../types")

local lookup = require("@self/lookup")
local to_index, to_enum = lookup.to_index, lookup.to_enum

return {
	write = function(b: buffer, offset: number, value: EnumItem)
		buffer.writeu16(b, offset, to_index(value.EnumType))
		buffer.writeu16(b, offset + 2, value.Value)
	end,
	read = function(b: buffer, offset: number): EnumItem
		return to_enum(buffer.readu16(b, offset)):FromValue(buffer.readu16(b, offset + 2))
	end,
	size = function(): number
		return 4
	end,

	validate = function(value: unknown)
		return typeof(value) == "EnumItem"
	end,
} :: types.Schema<EnumItem>
