const encodings = require("../encodings")
const types = require("../types")

const i32 = encodings.i32
const i16 = encodings.i16
const i16_limit = i16.max
const i8 = encodings.i8
const i8_limit = i8.max

const u32 = encodings.u32
const u16 = encodings.u16
const u16_limit = u16.max
const u8 = encodings.u8
const u8_limit = u8.max

const f32 = encodings.f32

const function determine_encoding(n: number): types.NumberEncoding
	const whole, frac = math.modf(n)

	if frac ~= 0 then -- integer
		return f32
	end

	if whole < 0 then -- signed
		if math.abs(n) > i16_limit then
			return i32
		elseif math.abs(n) > i8_limit then
			return i16
		else
			return i8
		end
	end

	if n > u16_limit then
		return u32
	elseif n > u8_limit then
		return u16
	else
		return u8
	end
end

return determine_encoding
