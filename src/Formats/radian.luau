local TAU = math.pi * 2

local function convertWrite(value: number, byteCount: number)
	local max = 2 ^ (byteCount * 8)

	return (value % TAU) / TAU * max
end

local function convertRead(value: number, byteCount: number)
	local max = 2 ^ (byteCount * 8)

	return value / max * TAU
end

local format = table.freeze {
	r8 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, convertWrite(value, 1))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu8(b, offset)

			return convertRead(value, 1)
		end,
		size = 1,
	},
	r16 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, convertWrite(value, 2))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu16(b, offset)

			return convertRead(value, 2)
		end,
		size = 2,
	},
	r32 = table.freeze {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu32(b, offset, convertWrite(value, 4))
		end,
		read = function(b: buffer, offset: number)
			local value = buffer.readu32(b, offset)

			return convertRead(value)
		end,
		size = 4,
	},
}

return format
