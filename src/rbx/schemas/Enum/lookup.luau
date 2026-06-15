local ENUMS = Enum:GetEnums()
local ENUM_TO_INDEX = {}

for key, value in ENUMS do
	ENUM_TO_INDEX[value] = key
end

const function to_index(enum: Enum): number
	return ENUM_TO_INDEX[enum]
end

const function to_enum(index: number): Enum
	return ENUMS[index]
end

return {
	to_index = to_index,
	to_enum = to_enum,
}
