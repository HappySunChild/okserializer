const FLOAT16_SIGN_MASK = 0x8000 --     0b1000000000000000
const FLOAT16_EXPONENT_MASK = 0x7C00 -- 0b0111110000000000
const FLOAT16_MANTISSA_MASK = 0x03FF -- 0b0000001111111111

return {
	f16 = {
		write = @native function(b: buffer, offset: number, value: number): ()
			-- Handle zero and NaN
			if value == 0 then
				buffer.writei16(b, offset, 0)
				return
			elseif value ~= value then -- NaN check
				buffer.writei16(b, offset, bit32.bor(FLOAT16_EXPONENT_MASK, 1)) -- NaN pattern
				return
			end

			-- Extract sign bit first
			const sign = value < 0 and FLOAT16_SIGN_MASK or 0
			const absValue = math.abs(value)

			-- Handle infinity
			if absValue == math.huge then
				buffer.writei16(b, offset, bit32.bor(sign, FLOAT16_EXPONENT_MASK))
				return
			end

			-- Calculate exponent and normalized value
			local exponent = math.floor(math.log(absValue, 2))
			local normalized = absValue / (2 ^ exponent)

			-- Adjust if normalized value is exactly 2
			if normalized >= 2 then
				normalized = 1
				exponent = exponent + 1
			end

			-- Calculate mantissa
			local mantissa = normalized - 1

			-- Handle subnormal numbers and overflow
			if exponent < -14 then
				-- Subnormal number handling
				mantissa = math.floor((absValue / (2 ^ -14)) * 1024 + 0.5)
				exponent = -15

				if mantissa == 0 then
					buffer.writeu16(b, offset, sign) -- Signed zero
					return
				end
			elseif exponent > 15 then
				-- Overflow to infinity
				buffer.writeu16(b, offset, bit32.bor(sign, FLOAT16_EXPONENT_MASK))
				return
			end

			-- Convert mantissa to 10 bits, ensuring we don't exceed the maximum
			mantissa = math.min(math.floor(mantissa * 1024 + 0.5), 0x3FF)

			-- Combine all components
			const result = bit32.bor(sign, bit32.lshift(exponent + 15, 10), mantissa)

			buffer.writeu16(b, offset, result)
		end,
		read = @native function(b: buffer, offset: number): number
			const bits = buffer.readu16(b, offset)

			-- Extract components
			const sign = bit32.band(bits, FLOAT16_SIGN_MASK) ~= 0 and -1 or 1
			const exponent = bit32.rshift(bit32.band(bits, FLOAT16_EXPONENT_MASK), 10) - 15
			const mantissa = bit32.band(bits, FLOAT16_MANTISSA_MASK)

			-- Handle special cases
			if exponent == 16 then
				if mantissa == 0 then
					return sign * math.huge -- Infinity
				else
					return math.nan -- NaN
				end
			end

			-- Handle subnormal numbers
			if exponent == -15 then
				if mantissa == 0 then
					return sign * 0 -- Signed zero
				end
				-- Subnormal number
				return sign * (mantissa / 1024) * (2 ^ -14)
			end

			-- Normal number
			return sign * (1 + mantissa / 1024) * (2 ^ exponent)
		end,
		size = 2,
		min = -math.huge,
		max = math.huge,
	},
	f32 = {
		write = buffer.writef32,
		read = buffer.readf32,
		size = 4,
		min = -math.huge,
		max = math.huge,
	},
	f64 = {
		write = buffer.writef64,
		read = buffer.readf64,
		size = 8,
		min = -math.huge,
		max = math.huge,
	},
}
