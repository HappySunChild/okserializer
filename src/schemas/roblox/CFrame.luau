local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_POS_SPEC = specs.f32
local DEFAULT_ROT_SPEC = specs.r16

return function(pos_spec: types.NumberTypeSpec?, rot_spec: types.NumberTypeSpec?): types.Schema<CFrame>
	local pos = if pos_spec == nil then DEFAULT_POS_SPEC else pos_spec
	local pos_write, pos_read, pos_size = pos.write, pos.read, pos.size

	local rot = if rot_spec == nil then DEFAULT_ROT_SPEC else rot_spec
	local rot_write, rot_read, rot_size = rot.write, rot.read, rot.size

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
