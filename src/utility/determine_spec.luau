const specs = require("../specs")
const types = require("../types")

const i32 = specs.i32
const i16 = specs.i16
const i16_limit = i16.max
const i8 = specs.i8
const i8_limit = i8.max

const u32 = specs.u32
const u16 = specs.u16
const u16_limit = u16.max
const u8 = specs.u8
const u8_limit = u8.max

const f32 = specs.f32

const function determine_spec(n: number): types.NumberTypeSpec
	const whole, frac = math.modf(n)

	if frac == 0 then -- integer
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

	return f32
end

return determine_spec
