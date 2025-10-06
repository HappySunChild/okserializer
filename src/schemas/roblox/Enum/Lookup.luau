local ENUMS = Enum:GetEnums()
local KEYS = {}

for key, value in ENUMS do
	KEYS[value] = key
end

return table.freeze {
	indexOf = function(enum: Enum): number
		return KEYS[enum]
	end,
	enumFor = function(index: number): Enum
		return ENUMS[index]
	end,
}
