local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_POS_SPEC = formats.f32
local DEFAULT_ROT_SPEC = formats.r16

return function(
	pos_format: types.NumberFormat?,
	rot_format: types.NumberFormat?
): types.Schema<CFrame>
	local pos_spec = if pos_format == nil then DEFAULT_POS_SPEC else formats[pos_format]
	local pos_write, pos_read, pos_size = pos_spec.write, pos_spec.read, pos_spec.size

	local rot_spec = if rot_format == nil then DEFAULT_ROT_SPEC else formats[rot_format]
	local rot_write, rot_read, rot_size = rot_spec.write, rot_spec.read, rot_spec.size

	return {
		write = function(b: buffer, offset: number, value: CFrame)
			local x, y, z = value.X, value.Y, value.Z
			local rx, ry, rz = value:ToOrientation()

			pos_write(b, offset, x)
			pos_write(b, offset + pos_size, y)
			pos_write(b, offset + pos_size * 2, z)

			rot_write(b, offset + pos_size * 3, rx)
			rot_write(b, offset + pos_size * 3 + rot_size, ry)
			rot_write(b, offset + pos_size * 3 + rot_size * 2, rz)
		end,
		read = function(b: buffer, offset: number): CFrame
			local x = pos_read(b, offset)
			local y = pos_read(b, offset + pos_size)
			local z = pos_read(b, offset + pos_size * 2)

			local rx = rot_read(b, offset + pos_size * 3)
			local ry = rot_read(b, offset + pos_size * 3 + rot_size)
			local rz = rot_read(b, offset + pos_size * 3 + rot_size * 2)

			return CFrame.new(x, y, z) * CFrame.fromOrientation(rx, ry, rz)
		end,
		size = function(): number
			return pos_size * 3 + rot_size * 3
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "CFrame"
		end,
	}
end
