local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(
	pos_format: types.NumberByteFormat,
	rot_format: types.NumberByteFormat
): types.Schema<CFrame>
	local _pos = formats.get(pos_format, "f32")
	local pos_write, pos_read, pos_size = _pos.write, _pos.read, _pos.size

	local _rot = formats.get(rot_format, "r16")
	local rot_write, rot_read, rot_size = _rot.write, _rot.read, _rot.size

	return Schema "CFrame" {
		write = function(b: buffer, offset: number, value: CFrame)
			local x, y, z = value.X, value.Y, value.Z
			local rx, ry, rz = value:ToOrientation()

			-- TODO: find a way to reduce this maybe???
			-- might have to learn quaternions nooooooo....
			-- i'm too used to euler,,. its 3 am WHY AM I STILL AWAKE
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
