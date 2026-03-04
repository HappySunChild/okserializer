local formats = require("../formats")
local types = require("../types")

local i32 = formats.i32
local i16 = formats.i16
local i16_limit = i16.max
local i8 = formats.i8
local i8_limit = i8.max

local u32 = formats.u32
local u16 = formats.u16
local u16_limit = u16.max
local u8 = formats.u8
local u8_limit = u8.max

local f32 = formats.f32

local function determine_format(n: number): types.NumberSpec
	local whole, frac = math.modf(n)

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

return determine_format
