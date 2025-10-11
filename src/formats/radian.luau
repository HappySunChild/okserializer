-- "Radian" number byte format
-- Stores radians with even spacing. Useful for storing rotations. (is this better than floats? I'm not sure...)

local TAU = math.pi * 2

@native
local function convertWrite(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)

	return (value % TAU) / TAU * max
end

@native
local function convertRead(value: number, byte_count: number)
	local max = 2 ^ (byte_count * 8)

	return value / max * TAU
end

return table.freeze {
	r8 = table.freeze {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, convertWrite(value, 1))
		end,
		read = @native function(b: buffer, offset: number)
			local value = buffer.readu8(b, offset)

			return convertRead(value, 1)
		end,
		size = 1,
	},
	r16 = table.freeze {
		write = @native function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, convertWrite(value, 2))
		end,
		read = @native function(b: buffer, offset: number)
			local value = buffer.readu16(b, offset)

			return convertRead(value, 2)
		end,
		size = 2,
	},
	r32 = table.freeze {
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
