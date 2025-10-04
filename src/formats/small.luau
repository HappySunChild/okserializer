local function convertWrite(value: number, byte_count: number)
	local decimal = math.modf(value)
	local max = 2 ^ (byte_count * 8)

	return math.round(decimal * max)
end

local function convertRead(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)

	return value / max
end

local format = table.freeze {
	s8 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, convertWrite(value, 1))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu8(b, offset)

			return convertRead(value, 1)
		end,
		size = 1,
	},
	s16 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, convertWrite(value, 2))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu16(b, offset)

			return convertRead(value, 2)
		end,
		size = 2,
	},
	s32 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu32(b, offset, convertWrite(value, 4))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu32(b, offset)

			return convertRead(value, 4)
		end,
		size = 4,
	},
}

return format
