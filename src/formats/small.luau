local function convert_write(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)
	local _, decimal = math.modf(value)

	return math.round(decimal * max)
end

local function convert_read(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)

	return value / max
end

return table.freeze {
	s8 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, convert_write(value, 1))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu8(b, offset)

			return convert_read(value, 1)
		end,
		size = 1,
	},
	s16 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, convert_write(value, 2))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu16(b, offset)

			return convert_read(value, 2)
		end,
		size = 2,
	},
	s32 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu32(b, offset, convert_write(value, 4))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu32(b, offset)

			return convert_read(value, 4)
		end,
		size = 4,
	},
}
