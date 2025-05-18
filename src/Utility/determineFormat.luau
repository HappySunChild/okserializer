local Types = require "../Types"

local U8_LIMIT = 2 ^ 8
local U16_LIMIT = 2 ^ 16

local I8_LIMIT = U8_LIMIT / 2 - 1
local I16_LIMIT = U16_LIMIT / 2 - 1

local function determineFormat(value: number): Types.NumberByteFormat
	local integral, decimal = math.modf(value)

	if decimal == 0 then -- integer
		if integral < 0 then -- signed
			if value > I16_LIMIT then
				return "i32"
			elseif value > I8_LIMIT then
				return "i16"
			else
				return "i8"
			end
		end

		if value > U16_LIMIT then
			return "u32"
		elseif value > U8_LIMIT then
			return "u16"
		else
			return "u8"
		end
	end

	if integral == 0 then
		return "d16"
	end

	return "f32"
end

return determineFormat
