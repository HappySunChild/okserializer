const types = require("../types")

const ENUMS = Enum:GetEnums()
const ENUM_TO_INDEX = {}

for key, value in ENUMS do
	ENUM_TO_INDEX[value] = key
end

@native
const function to_index(enum: Enum): number
	return ENUM_TO_INDEX[enum]
end

@native
const function to_enum(index: number): Enum
	return ENUMS[index]
end

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

	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "EnumItem" then
			return false, `expected value of type EnumItem, got {typeof(value)}`
		end

		return true, nil
	end,
}

return Enum_schema
