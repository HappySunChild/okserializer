local Types = require "../Types"

local float16 = require "../Formats/float16"
local radian = require "../Formats/radian"
local small = require "../Formats/small"

local BYTE_FORMATS = table.freeze {
	u8 = {
		write = buffer.writeu8,
		read = buffer.readu8,
		size = 1,
	},
	u16 = {
		write = buffer.writeu16,
		read = buffer.readu16,
		size = 2,
	},
	u32 = {
		write = buffer.writeu32,
		read = buffer.readu32,
		size = 4,
	},

	i8 = {
		write = buffer.writei8,
		read = buffer.readi8,
		size = 1,
	},
	i16 = {
		write = buffer.writei16,
		read = buffer.readi16,
		size = 2,
	},
	i32 = {
		write = buffer.writei32,
		read = buffer.readi32,
		size = 4,
	},

	s8 = small.s8,
	s16 = small.s16,
	s32 = small.s32,

	r8 = radian.r8, --   pi / 256        ≈ 0.703 degrees
	r16 = radian.r16, -- pi / 65536      ≈ 0.002 degrees
	r32 = radian.r32, -- pi / 4294967296 ≈ 0.00000004 degrees

	f16 = float16,
	f32 = {
		write = buffer.writef32,
		read = buffer.readf32,
		size = 4,
	},
	f64 = {
		write = buffer.writef64,
		read = buffer.readf64,
		size = 8,
	},
} :: { [string]: Types.ByteFormatInfo }

local function getFormatInfo(formatKey: Types.NumberByteFormat?, default: Types.NumberByteFormat): Types.ByteFormatInfo
	local info = BYTE_FORMATS[formatKey]

	if default and info == nil then
		warn(`Unknown byte format '{formatKey}', resorting to default.`)

		info = BYTE_FORMATS[default]
	end

	if info == nil then
		error(`Unknown byte format '{formatKey}'.`)
	end

	return info
end

return getFormatInfo
