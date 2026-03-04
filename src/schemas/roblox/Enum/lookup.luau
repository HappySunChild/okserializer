local ENUMS = Enum:GetEnums()
local KEYS = {}

for key, value in ENUMS do
	KEYS[value] = key
end

return table.freeze({
	to_index = function(enum: Enum): number
		return KEYS[enum]
	end,
	to_enum = function(index: number): Enum
		return ENUMS[index]
	end,
})
