-- "Radian" number byte format
-- Stores radians with even spacing. Useful for storing rotations. (is this better than floats? I'm not sure...)

const TAU = math.tau

-- I am aware that storing 2pi (tau) loops back around to 0, this is intentional.
const U8_MAX_INCLUSIVE = 2 ^ 8
const U16_MAX_INCLUSIVE = 2 ^ 16
const U32_MAX_INCLUSIVE = 2 ^ 32

return {
	r8 = {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu8(b, offset, value / TAU * U8_MAX_INCLUSIVE)
		end,
		read = function(b: buffer, offset: number)
			return buffer.readu8(b, offset) / U8_MAX_INCLUSIVE * TAU
		end,
		size = 1,
		min = 0,
		max = TAU - 1 / U8_MAX_INCLUSIVE,
	},
	r16 = {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu16(b, offset, value / TAU * U16_MAX_INCLUSIVE)
		end,
		read = function(b: buffer, offset: number)
			return buffer.readu16(b, offset) / U16_MAX_INCLUSIVE * TAU
		end,
		size = 2,
		min = 0,
		max = TAU - 1 / U16_MAX_INCLUSIVE,
	},
	r32 = {
		write = function(b: buffer, offset: number, value: number)
			buffer.writeu32(b, offset, value / TAU * U32_MAX_INCLUSIVE)
		end,
		read = function(b: buffer, offset: number)
			return buffer.readu32(b, offset) / U32_MAX_INCLUSIVE * TAU
		end,
		size = 4,
		min = 0,
		max = TAU - 1 / U32_MAX_INCLUSIVE,
	},
}
