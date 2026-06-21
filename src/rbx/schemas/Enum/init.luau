const types = require("../../types")

const lookup = require("@self/lookup")
const to_index, to_enum = lookup.to_index, lookup.to_enum

const Enum_schema: types.Schema<EnumItem> = {
	write = @native function(b: buffer, offset: number, value: EnumItem): number
		buffer.writeu16(b, offset, to_index(value.EnumType))
		buffer.writeu16(b, offset + 2, value.Value)
		return 4
	end,
	read = @native function(b: buffer, offset: number): (number, EnumItem)
		return 4, to_enum(buffer.readu16(b, offset)):FromValue(buffer.readu16(b, offset + 2))
	end,
	alloc_size = @native function(): number
		return 4
	end,

	validate = function(value: unknown): (boolean, string?)
		if typeof(value) ~= "EnumItem" then
			return false, `expected value of type EnumItem, got {typeof(value)}`
		end

		return true, nil
	end,
}

return Enum_schema
