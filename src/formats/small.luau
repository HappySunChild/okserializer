-- "Small" number byte format
-- Stores decimals between 0-<1 with even spacing. May be useful if you're serializing an 'alpha' value.

@native
local function convertWrite(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)
	local _, decimal = math.modf(value)

	return math.round(decimal * max)
end

@native
local function convertRead(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)

	return value / max
end

return table.freeze {
	s8 = table.freeze {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, convertWrite(value, 1))
		end,
		read = @native function(b: buffer, offset: number)
			local value = buffer.readu8(b, offset)

			return convertRead(value, 1)
		end,
		size = 1,
	},
	s16 = table.freeze {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, convertWrite(value, 2))
		end,
		read = @native function(b: buffer, offset: number)
			local value = buffer.readu16(b, offset)

			return convertRead(value, 2)
		end,
		size = 2,
	},
	s32 = table.freeze {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu32(b, offset, convertWrite(value, 4))
		end,
		read = @native function(b: buffer, offset: number)
			local value = buffer.readu32(b, offset)

			return convertRead(value, 4)
		end,
		size = 4,
	},
}
